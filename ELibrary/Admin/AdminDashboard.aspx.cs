using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ELibrary.Admin
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string connStr = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if ((string)Session["Role"] != "Admin")
            {
                Response.Redirect("~/adminlogin.aspx");
            }
            if (!IsPostBack)
            {
                LoadPendingArtisans();
            }
        }

        private void LoadPendingArtisans()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT a.ArtisanId, u.Email, a.StoreName, a.Category, a.Description, a.ApprovalStatus, u.UName
                    FROM Artisans a
                    INNER JOIN Users u ON a.UserId = u.UserId
                    WHERE a.ApprovalStatus = 'Pending'";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptArtisans.DataSource = dt;
                rptArtisans.DataBind();

                // Show pending count
                lblPendingRequests.Text = $"Pending Requests: {dt.Rows.Count}";
            }
        }

        protected void rptArtisans_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Approve" || e.CommandName == "Reject")
            {
                // Assuming CommandArgument contains Artisans.Id (int)
                int artisanId = Convert.ToInt32(e.CommandArgument);
                string newStatus = e.CommandName == "Approve" ? "Approved" : "Rejected";

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "UPDATE Artisans SET ApprovalStatus = @Status WHERE ArtisanId = @ArtisanId";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Status", newStatus);
                    cmd.Parameters.AddWithValue("@ArtisanId", artisanId);
                    cmd.ExecuteNonQuery();
                }

                // Reload the updated data
                LoadPendingArtisans();
            }
        }
    }
}
