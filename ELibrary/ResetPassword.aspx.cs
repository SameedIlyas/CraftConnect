using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace ELibrary
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["email"] == null)
            {
                lblMessage.Text = "Invalid reset link.";
                lblMessage.CssClass = "text-danger";
                txtNewPassword.Enabled = false;
                txtConfirmPassword.Enabled = false;
                btnResetPassword.Enabled = false;
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            string email = Request.QueryString["email"];
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            if (string.IsNullOrEmpty(email))
            {
                lblMessage.Text = "Invalid reset link.";
                lblMessage.CssClass = "text-danger";
                return;
            }

            if (string.IsNullOrEmpty(newPassword) || string.IsNullOrEmpty(confirmPassword))
            {
                lblMessage.Text = "Please fill in all fields.";
                lblMessage.CssClass = "text-danger";
                return;
            }

            if (newPassword != confirmPassword)
            {
                lblMessage.Text = "Passwords do not match.";
                lblMessage.CssClass = "text-danger";
                return;
            }

            string hashedPassword = ComputeSha256Hash(newPassword);
            string connectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("UPDATE Users SET PasswordHash = @pwd WHERE Email = @Email", con);
                cmd.Parameters.AddWithValue("@pwd", hashedPassword);
                cmd.Parameters.AddWithValue("@Email", email);

                int rows = cmd.ExecuteNonQuery();

                if (rows > 0)
                {
                    lblMessage.Text = "Password has been reset successfully.";
                    lblMessage.CssClass = "text-success";
                }
                else
                {
                    lblMessage.Text = "Failed to reset password. Email not found.";
                    lblMessage.CssClass = "text-danger";
                }
            }
        }

        private string ComputeSha256Hash(string rawData)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(rawData));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}
