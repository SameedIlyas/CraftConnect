using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net.NetworkInformation;
using System.Web.UI.WebControls;

namespace ELibrary
{
    public partial class ArtisanAccessCheck : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string userId = Session["UserId"].ToString();
            string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT StoreName, Category, Description, ApprovalStatus FROM Artisans WHERE UserId = @UserId", conn);
                cmd.Parameters.AddWithValue("@UserId", userId);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string storeName = reader["StoreName"]?.ToString();
                        string category = reader["Category"]?.ToString();
                        string description = reader["Description"]?.ToString();
                        string approvalStatus = reader["ApprovalStatus"]?.ToString();

                        // Missing essential store info
                        if (string.IsNullOrWhiteSpace(storeName) || string.IsNullOrWhiteSpace(category) || string.IsNullOrWhiteSpace(description))
                        {
                            Response.Redirect("~/ProfileCreation.aspx");
                            return;
                        }

                        // Handle status
                        if (approvalStatus == "Approved")
                        {
                            Response.Redirect("~/ArtisanDashboard.aspx");
                            return;
                        }
                        else if (approvalStatus == "Pending")
                        {
                            phStatus.Controls.Add(new Literal
                            {
                                Text = @"
                                <div class='alert alert-warning text-center'>
                                    <h4 class='mb-3'>Your store request is pending.</h4>
                                    <p>Please wait while the admin reviews your request.</p>
                                    <a href='Logout.aspx' class='btn btn-secondary mt-3'>Logout</a>
                                </div>"
                            });
                        }
                        else if (approvalStatus == "Rejected")
                        {
                            phStatus.Controls.Add(new Literal
                            {
                                Text = @"
                                <div class='alert alert-danger text-center'>
                                    <h4 class='mb-3'>Your store request was rejected.</h4>
                                    <p>Please update your store information and submit again.</p>
                                    <a href='ProfileCreation.aspx' class='btn btn-primary mt-3'>Update Store Info</a>
                                    <a href='Logout.aspx' class='btn btn-outline-secondary mt-3 ms-2'>Logout</a>
                                </div>"
                            });
                        }
                        else
                        {
                            // Unknown or null status
                            phStatus.Controls.Add(new Literal
                            {
                                Text = @"
                                <div class='alert alert-info text-center'>
                                    <h4>Store approval status not set.</h4>
                                    <p>Please contact support or try again later.</p>
                                </div>"
                            });
                        }
                    }
                    else
                    {
                        // Artisan not found
                        Response.Redirect("~/Login.aspx");
                    }
                }
            }
        }
    }
}
