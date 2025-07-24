using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace ELibrary.Admin
{
    public partial class UserDetails : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] != "Admin")
            {
                Response.Redirect("~/adminlogin.aspx");
            }
            if (!IsPostBack)
            {
                string userId = Request.QueryString["UserId"];
                if (!string.IsNullOrEmpty(userId))
                {
                    LoadUserDetails(userId);
                }
                else
                {
                    pnlDetails.Visible = false;
                    pnlError.Visible = true;
                }
            }
        }

        private void LoadUserDetails(string userId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Fetch User Info
                string userQuery = "SELECT * FROM Users WHERE UserId = @UserId";
                SqlCommand cmd = new SqlCommand(userQuery, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    // Set User Fields
                    lblUserName.Text = reader["UName"].ToString();
                    lblFullName.Text = reader["FullName"].ToString();
                    lblEmail.Text = reader["Email"].ToString();
                    lblRole.Text = reader["Role"].ToString();
                    lblDate.Text = Convert.ToDateTime(reader["CreatedAt"]).ToString("dd MMM yyyy");
                    lblActive.Text = (bool)reader["IsActive"] ? "Active" : "Inactive";
                    lblPhone.Text = reader["PhoneNumber"].ToString();
                    lblCountry.Text = reader["Country"].ToString();
                    imgProfile.ImageUrl = reader["ProfilePicture"] != DBNull.Value ? reader["ProfilePicture"].ToString() : "~/images/profile.png";

                    pnlDetails.Visible = true;
                    pnlError.Visible = false;

                    reader.Close();

                    // If user is Artisan, get Artisan details
                    if (lblRole.Text.ToLower() == "artisan")
                    {
                        string artisanQuery = "SELECT * FROM Artisans WHERE UserId = @UserId";
                        SqlCommand artisanCmd = new SqlCommand(artisanQuery, conn);
                        artisanCmd.Parameters.AddWithValue("@UserId", userId);

                        SqlDataReader artisanReader = artisanCmd.ExecuteReader();
                        if (artisanReader.Read())
                        {
                            lblStoreName.Text = artisanReader["StoreName"].ToString();
                            lblCategory.Text = artisanReader["Category"].ToString();
                            lblDescription.Text = artisanReader["Description"].ToString();
                            lblSkills.Text = artisanReader["Skills"].ToString();
                            lblApproval.Text = artisanReader["ApprovalStatus"].ToString();
                            lblJoined.Text = Convert.ToDateTime(artisanReader["JoinedOn"]).ToString("dd MMM yyyy");

                            pnlArtisan.Visible = true;
                        }
                        artisanReader.Close();
                    }
                }
                else
                {
                    pnlDetails.Visible = false;
                    pnlError.Visible = true;
                }
            }
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            // Redirect to Edit Page (optional implementation)
            Response.Redirect("EditUser.aspx?UserId=" + Request.QueryString["UserId"]);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string userId = Request.QueryString["UserId"];
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Optional: delete artisan data if exists
                SqlCommand delArtisan = new SqlCommand("DELETE FROM Artisans WHERE UserId = @UserId", conn);
                delArtisan.Parameters.AddWithValue("@UserId", userId);
                delArtisan.ExecuteNonQuery();

                // Delete User
                SqlCommand delUser = new SqlCommand("DELETE FROM Users WHERE UserId = @UserId", conn);
                delUser.Parameters.AddWithValue("@UserId", userId);
                delUser.ExecuteNonQuery();
            }

            Response.Redirect("ManageUsers.aspx");
        }
    }
}
