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
    public partial class BrowseWorkshop : System.Web.UI.Page
    {
        string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                PopulateDateDropdown();
                LoadWorkshops();
            }
        }

        private void PopulateDateDropdown()
        {
            ddlDate.Items.Clear();
            ddlDate.Items.Add(new ListItem("All Dates", ""));

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT DISTINCT CAST(Date AS DATE) AS WorkshopDate FROM Workshops WHERE Status = 'Upcoming' ORDER BY WorkshopDate";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    DateTime date = Convert.ToDateTime(reader["WorkshopDate"]);
                    ddlDate.Items.Add(new ListItem(date.ToString("MMMM dd, yyyy"), date.ToString("yyyy-MM-dd")));
                }
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadWorkshops();
        }

        private void LoadCategories()
        {
            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new ListItem("All", ""));

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT DISTINCT Category FROM Workshops", con);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    ddlCategory.Items.Add(new ListItem(reader["Category"].ToString()));
                }
            }
        }

        private void LoadWorkshops()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT *, 
                   CASE WHEN IsOnline = 1 THEN 'Online' ELSE 'Offline' END AS Mode
            FROM Workshops
            WHERE Status = 'Upcoming'
              AND (@Category = '' OR Category = @Category)
              AND (@Location = '' OR Location LIKE '%' + @Location + '%')
              AND (@Date IS NULL OR CAST(Date AS DATE) = CAST(@Date AS DATE))
              AND (@Mode = '' OR 
                   (@Mode = 'Online' AND IsOnline = 1) OR 
                   (@Mode = 'Offline' AND IsOnline = 0))
        ", con);

                cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@Location", txtLocation.Text.Trim());

                DateTime parsedDate;
                object dateParam = DateTime.TryParse(ddlDate.SelectedValue, out parsedDate) ? (object)parsedDate : DBNull.Value;
                cmd.Parameters.AddWithValue("@Date", dateParam);

                cmd.Parameters.AddWithValue("@Mode", ddlMode.SelectedValue); // From dropdown (Online/Offline/"")

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                rptWorkshops.DataSource = reader;
                rptWorkshops.DataBind();
            }
        }

    }
}
