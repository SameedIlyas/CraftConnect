using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace ELibrary
{
    public partial class EarningsReports : System.Web.UI.Page
    {
        string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null || (string)Session["Role"] != "Artisan")
                {
                    Response.Redirect("~/SignIn.aspx");
                    return;
                }

                PopulateFilters();
                LoadEarnings();
            }
        }

        private void PopulateFilters()
        {
            ddlMonth.Items.Clear();
            ddlMonth.Items.Add(new ListItem("All", "0"));
            for (int m = 1; m <= 12; m++)
            {
                ddlMonth.Items.Add(new ListItem(new DateTime(2000, m, 1).ToString("MMMM"), m.ToString()));
            }

            ddlYear.Items.Clear();
            ddlYear.Items.Add(new ListItem("All", "0"));
            for (int y = DateTime.Now.Year; y >= 2023; y--)
            {
                ddlYear.Items.Add(new ListItem(y.ToString(), y.ToString()));
            }

            ddlMonth.SelectedValue = "0";
            ddlYear.SelectedValue = "0";
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadEarnings();
        }

        private void LoadEarnings()
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);
            int selectedMonth = int.Parse(ddlMonth.SelectedValue);
            int selectedYear = int.Parse(ddlYear.SelectedValue);

            string workshopQuery = @"
                SELECT 
                    w.Id,
                    w.Title,
                    w.Date,
                    w.Fee,
                    ISNULL(COUNT(r.Id), 0) AS Participants
                FROM Workshops w
                LEFT JOIN WorkshopRegistration r ON w.Id = r.WorkshopId
                WHERE w.ArtisanId = @ArtisanId AND w.Status = 'Completed'";

            string productQuery = @"
                SELECT 
                    ISNULL(SUM(od.Quantity * od.UnitPrice), 0)
                FROM OrderDetails od
                INNER JOIN Products p ON od.ProductID = p.ProductID
                INNER JOIN Orders o ON od.OrderID = o.OrderID
                WHERE p.ArtisanId = @ArtisanId AND o.Status = 'Completed'";

            if (selectedMonth > 0)
            {
                workshopQuery += " AND MONTH(w.Date) = @Month";
                productQuery += " AND MONTH(OrderDate) = @Month";
            }
            if (selectedYear > 0)
            {
                workshopQuery += " AND YEAR(w.Date) = @Year";
                productQuery += " AND YEAR(OrderDate) = @Year";
            }

            workshopQuery += " GROUP BY w.Id, w.Title, w.Date, w.Fee ORDER BY w.Date DESC";

            decimal workshopRevenue = 0;
            decimal productRevenue = 0;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmdWorkshops = new SqlCommand(workshopQuery, con);
                cmdWorkshops.Parameters.AddWithValue("@ArtisanId", artisanId);
                if (selectedMonth > 0) cmdWorkshops.Parameters.AddWithValue("@Month", selectedMonth);
                if (selectedYear > 0) cmdWorkshops.Parameters.AddWithValue("@Year", selectedYear);

                SqlDataAdapter adapter = new SqlDataAdapter(cmdWorkshops);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                foreach (DataRow row in dt.Rows)
                {
                    decimal fee = Convert.ToDecimal(row["Fee"]);
                    int participants = Convert.ToInt32(row["Participants"]);
                    workshopRevenue += fee * participants;
                }

                rptWorkshops.DataSource = dt;
                rptWorkshops.DataBind();
                pnlNoWorkshops.Visible = dt.Rows.Count == 0;

                SqlCommand cmdProducts = new SqlCommand(productQuery, con);
                cmdProducts.Parameters.AddWithValue("@ArtisanId", artisanId);
                if (selectedMonth > 0) cmdProducts.Parameters.AddWithValue("@Month", selectedMonth);
                if (selectedYear > 0) cmdProducts.Parameters.AddWithValue("@Year", selectedYear);

                con.Open();
                object result = cmdProducts.ExecuteScalar();
                productRevenue = result != DBNull.Value ? Convert.ToDecimal(result) : 0;
            }

            decimal totalRevenue = workshopRevenue + productRevenue;

            lblTotalEarnings.Text = totalRevenue.ToString("N2");
            lblWorkshopRevenue.Text = workshopRevenue.ToString("N2");
            lblProductRevenue.Text = productRevenue.ToString("N2");
        }
    }
}
