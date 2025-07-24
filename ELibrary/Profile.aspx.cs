using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace ELibrary
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadProfile();
        }

        private void LoadProfile()
        {
            string userId = Session["UserId"]?.ToString();
            if (string.IsNullOrEmpty(userId))
            {
                Response.Redirect("~/SignIn.aspx");
                return;
            }

            string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // First, get data from Users table
                SqlCommand cmdUser = new SqlCommand("SELECT * FROM Users WHERE UserId = @UserId", con);
                cmdUser.Parameters.AddWithValue("@UserId", userId);
                SqlDataReader reader = cmdUser.ExecuteReader();

                string role = "";
                if (reader.Read())
                {
                    txtName.Text = reader["FullName"].ToString();
                    txtUsername.Text = reader["UName"].ToString();
                    ddlCountry.SelectedValue = reader["Country"].ToString();
                    txtPhone.Text = reader["PhoneNumber"].ToString();
                    imgProfile.ImageUrl = string.IsNullOrEmpty(reader["ProfilePicture"].ToString()) ? "~/images/profile.png" : reader["ProfilePicture"].ToString();
                    role = reader["Role"].ToString();
                }
                reader.Close();

                // If the user is an artisan, fetch their skills from the Artisans table
                if (role == "Artisan")
                {
                    pnlSkills.Visible = true;
                    SqlCommand cmdSkills = new SqlCommand("SELECT Skills FROM Artisans WHERE UserId = @UserId", con);
                    cmdSkills.Parameters.AddWithValue("@UserId", userId);
                    object skills = cmdSkills.ExecuteScalar();
                    txtSkills.Text = skills != null ? skills.ToString() : "";
                }
                else
                {
                    pnlSkills.Visible = false;
                }
            }
        }


        protected void btnSave_Click(object sender, EventArgs e)
        {
            string userId = Session["UserId"]?.ToString();
            if (string.IsNullOrEmpty(userId)) return;

            // Check username uniqueness
            if (!IsUsernameUnique(txtUsername.Text.Trim(), userId))
            {
                lblUsernameStatus.Text = "Username already taken.";
                return;
            }
            lblUsernameStatus.Text = "";

            string filePath = imgProfile.ImageUrl;
            if (fileUploadProfilePic.HasFile)
            {
                string extension = System.IO.Path.GetExtension(fileUploadProfilePic.FileName);
                string newFileName = "User_" + userId + extension;
                filePath = "~/images/ProfilePictures/" + newFileName;
                fileUploadProfilePic.SaveAs(Server.MapPath(filePath));
            }

            string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Update Users table
                SqlCommand userCmd = new SqlCommand(@"
            UPDATE Users 
            SET FullName = @Name, UName = @Username, Country = @Country, PhoneNumber = @Phone, ProfilePicture = @ProfilePic
            WHERE UserId = @UserId", con);

                userCmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                userCmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
                userCmd.Parameters.AddWithValue("@Country", ddlCountry.SelectedValue);
                userCmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                userCmd.Parameters.AddWithValue("@ProfilePic", filePath);
                userCmd.Parameters.AddWithValue("@UserId", userId);
                userCmd.ExecuteNonQuery();

                // Check role
                SqlCommand roleCmd = new SqlCommand("SELECT Role FROM Users WHERE UserId = @UserId", con);
                roleCmd.Parameters.AddWithValue("@UserId", userId);
                string role = roleCmd.ExecuteScalar()?.ToString();

                // Update Skills if Artisan
                if (role == "Artisan")
                {
                    SqlCommand artisanCmd = new SqlCommand("UPDATE Artisans SET Skills = @Skills WHERE UserId = @UserId", con);
                    artisanCmd.Parameters.AddWithValue("@Skills", txtSkills.Text.Trim());
                    artisanCmd.Parameters.AddWithValue("@UserId", userId);
                    artisanCmd.ExecuteNonQuery();
                }

                lblStatus.Text = "Profile updated successfully!";
            }

            LoadProfile(); // reload to reflect new image
        }


        private bool IsUsernameUnique(string username, string currentUserId)
        {

            string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE UName = @Username AND UserId <> @UserId", con);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@UserId", currentUserId);
                int count = (int)cmd.ExecuteScalar();
                return count == 0;
            }
        }
    }
}
