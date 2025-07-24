using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace ELibrary.Admin
{
    public partial class EditUser : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        int userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] != "Admin")
            {
                Response.Redirect("~/adminlogin.aspx");
            }
            if (!IsPostBack)
            {
                if (Request.QueryString["UserId"] == null)
                {
                    Response.Redirect("ManageUsers.aspx");
                }

                userId = Convert.ToInt32(Request.QueryString["UserId"]);
                LoadUserDetails();
            }
        }

        private void LoadUserDetails()
        {
            userId = Convert.ToInt32(Request.QueryString["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT u.UserId, u.UName, u.FullName, u.Email, u.Role, u.CreatedAt, u.IsActive, u.Country, u.PhoneNumber, u.ProfilePicture,
                           a.ArtisanId, a.StoreName, a.Category, a.Description, a.Skills, a.ApprovalStatus, a.JoinedOn
                    FROM Users u
                    LEFT JOIN Artisans a ON u.UserId = a.UserId
                    WHERE u.UserId = @UserId";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);
                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtUName.Text = reader["UName"].ToString();
                    txtFullName.Text = reader["FullName"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    ddlRole.SelectedValue = reader["Role"].ToString();
                    chkIsActive.Checked = Convert.ToBoolean(reader["IsActive"]);
                    txtCountry.Text = reader["Country"].ToString();
                    txtPhone.Text = reader["PhoneNumber"].ToString();

                    string profilePic = reader["ProfilePicture"].ToString();
                    if (!string.IsNullOrEmpty(profilePic))
                        imgPreview.ImageUrl = "~/images/ProfilePictures/" + profilePic;

                    if (reader["Role"].ToString() == "Artisan")
                    {
                        pnlArtisan.Visible = true;
                        txtStoreName.Text = reader["StoreName"].ToString();
                        txtCategory.Text = reader["Category"].ToString();
                        txtDescription.Text = reader["Description"].ToString();
                        txtSkills.Text = reader["Skills"].ToString();
                        ddlApprovalStatus.SelectedValue = reader["ApprovalStatus"].ToString();
                    }
                }
                else
                {
                    Response.Redirect("ManageUsers.aspx");
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            userId = Convert.ToInt32(Request.QueryString["UserId"]);
            string profileFileName = "";

            if (fuProfilePicture.HasFile)
            {
                string ext = Path.GetExtension(fuProfilePicture.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
                {
                    lblMessage.Text = "Only JPG, JPEG, or PNG files are allowed.";
                    return;
                }

                profileFileName = Guid.NewGuid().ToString() + ext;
                profileFileName = "~images/Profile/Pictures/" + profileFileName;
                fuProfilePicture.SaveAs(Server.MapPath(profileFileName));
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Update Users table
                string userUpdate = @"
                    UPDATE Users SET
                        UName = @UName,
                        FullName = @FullName,
                        Email = @Email,
                        Role = @Role,
                        IsActive = @IsActive,
                        Country = @Country,
                        PhoneNumber = @PhoneNumber
                        {0}
                    WHERE UserId = @UserId";

                string imageClause = !string.IsNullOrEmpty(profileFileName) ? ", ProfilePicture = @ProfilePicture" : "";
                userUpdate = string.Format(userUpdate, imageClause);

                SqlCommand userCmd = new SqlCommand(userUpdate, con);
                userCmd.Parameters.AddWithValue("@UName", txtUName.Text);
                userCmd.Parameters.AddWithValue("@FullName", txtFullName.Text);
                userCmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                userCmd.Parameters.AddWithValue("@Role", ddlRole.SelectedValue);
                userCmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                userCmd.Parameters.AddWithValue("@Country", txtCountry.Text);
                userCmd.Parameters.AddWithValue("@PhoneNumber", txtPhone.Text);
                userCmd.Parameters.AddWithValue("@UserId", userId);
                if (!string.IsNullOrEmpty(profileFileName))
                    userCmd.Parameters.AddWithValue("@ProfilePicture", profileFileName);

                userCmd.ExecuteNonQuery();

                // Update Artisan table if applicable
                if (ddlRole.SelectedValue == "Artisan")
                {
                    string artisanUpdate = @"
                        IF EXISTS (SELECT 1 FROM Artisans WHERE UserId = @UserId)
                        BEGIN
                            UPDATE Artisans SET
                                StoreName = @StoreName,
                                Category = @Category,
                                Description = @Description,
                                Skills = @Skills,
                                ApprovalStatus = @ApprovalStatus
                            WHERE UserId = @UserId
                        END
                        ELSE
                        BEGIN
                            INSERT INTO Artisans (UserId, StoreName, Category, Description, Skills, ApprovalStatus, JoinedOn)
                            VALUES (@UserId, @StoreName, @Category, @Description, @Skills, @ApprovalStatus, GETDATE())
                        END";

                    SqlCommand artisanCmd = new SqlCommand(artisanUpdate, con);
                    artisanCmd.Parameters.AddWithValue("@UserId", userId);
                    artisanCmd.Parameters.AddWithValue("@StoreName", txtStoreName.Text);
                    artisanCmd.Parameters.AddWithValue("@Category", txtCategory.Text);
                    artisanCmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                    artisanCmd.Parameters.AddWithValue("@Skills", txtSkills.Text);
                    artisanCmd.Parameters.AddWithValue("@ApprovalStatus", ddlApprovalStatus.SelectedValue);

                    artisanCmd.ExecuteNonQuery();
                }

                lblMessage.CssClass = "text-success";
                lblMessage.Text = "User details updated successfully!";
                LoadUserDetails(); // reload to refresh any changed values
            }
        }

        protected void ddlRole_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlArtisan.Visible = ddlRole.SelectedValue == "Artisan";
        }

    }
}
