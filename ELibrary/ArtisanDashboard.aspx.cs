using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary
{
    public partial class ArtisanDashboard : System.Web.UI.Page
    {
        string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if artisan is logged in
                if (Session["UserId"] == null || (string)Session["Role"] != "Artisan")
                {
                    Response.Redirect("~/Signin.aspx");
                    return;
                }

                LoadDashboardData();
            }
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDashboardData();
        }



        private void LoadDashboardData()
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);
            string statusFilter = ddlStatusFilter.SelectedValue;
            int totalOrders = 0;
            int pendingOrders = 0;
            decimal totalEarnings = 0;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Summary: Count of unique orders that include this artisan's products
                string summaryQuery = @"
            SELECT 
                COUNT(DISTINCT od.OrderID) AS TotalOrders,
                COUNT(DISTINCT CASE WHEN o.Status = 'Processing' THEN od.OrderID END) AS PendingOrders,
                SUM(od.Quantity * od.UnitPrice) AS TotalEarnings
            FROM OrderDetails od
            INNER JOIN Products p ON od.ProductID = p.ProductID
            INNER JOIN Orders o ON od.OrderID = o.OrderID
            WHERE p.ArtisanId = @ArtisanId";

                SqlCommand summaryCmd = new SqlCommand(summaryQuery, con);
                summaryCmd.Parameters.AddWithValue("@ArtisanId", artisanId);

                using (SqlDataReader reader = summaryCmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        totalOrders = reader["TotalOrders"] != DBNull.Value ? Convert.ToInt32(reader["TotalOrders"]) : 0;
                        pendingOrders = reader["PendingOrders"] != DBNull.Value ? Convert.ToInt32(reader["PendingOrders"]) : 0;
                        totalEarnings = reader["TotalEarnings"] != DBNull.Value ? Convert.ToDecimal(reader["TotalEarnings"]) : 0;
                    }
                }

                // Bind values to UI
                lblPendingOrders.Text = pendingOrders.ToString();
                lblEarnings.Text = "PKR " + totalEarnings.ToString("N2");
                lblTotalOrders.Text = totalOrders.ToString();

                // Get recent orders involving this artisan's products
                string recentOrdersQuery = @"
                    SELECT DISTINCT TOP 10 
                        o.OrderID, 
                        u.UName AS CustomerName, 
                        o.TotalAmount,
                        o.Status, 
                        o.OrderDate
                    FROM OrderDetails od
                    INNER JOIN Products p ON od.ProductID = p.ProductID
                    INNER JOIN Orders o ON od.OrderID = o.OrderID
                    INNER JOIN Users u ON o.UserID = u.UserId
                    WHERE p.ArtisanId = @ArtisanId";

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    recentOrdersQuery += " AND o.Status = @Status";
                }

                recentOrdersQuery += " ORDER BY o.OrderDate DESC";


                SqlCommand ordersCmd = new SqlCommand(recentOrdersQuery, con);
                ordersCmd.Parameters.AddWithValue("@ArtisanId", artisanId);

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    ordersCmd.Parameters.AddWithValue("@Status", statusFilter);
                }

                SqlDataAdapter da = new SqlDataAdapter(ordersCmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvRecentOrders.DataSource = dt;
                gvRecentOrders.DataBind();
            }
        }
        protected void gvRecentOrders_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvRecentOrders.EditIndex = e.NewEditIndex;
            LoadDashboardData(); // Rebind with edit row enabled
        }

        protected void gvRecentOrders_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvRecentOrders.EditIndex = -1;
            LoadDashboardData(); // Cancel editing mode
        }

        protected void gvRecentOrders_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = gvRecentOrders.Rows[e.RowIndex];
            int orderId = Convert.ToInt32(gvRecentOrders.DataKeys[e.RowIndex].Value);

            DropDownList ddlStatus = (DropDownList)row.FindControl("ddlStatus");
            string newStatus = ddlStatus.SelectedValue;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("UPDATE Orders SET Status = @Status WHERE OrderID = @OrderID", con);
                cmd.Parameters.AddWithValue("@Status", newStatus);
                cmd.Parameters.AddWithValue("@OrderID", orderId);
                cmd.ExecuteNonQuery();
            }

            gvRecentOrders.EditIndex = -1;
            LoadDashboardData();

            ClientScript.RegisterStartupScript(this.GetType(), "ShowToast", "showToast();", true);
        }

    }
}
