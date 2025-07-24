using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace ELibrary
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

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

        protected void btnSignup_Click(object sender, EventArgs e)
        {
            string connectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

            if (!isFormValid())
            {
                lblMsg.Text = "Please fill all required fields correctly.";
                lblMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Email = @Email OR UName = @UName", con);
                    checkCmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    checkCmd.Parameters.AddWithValue("@UName", txtUname.Text.Trim());

                    int count = (int)checkCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        lblMsg.Text = "Username or Email already exists.";
                        lblMsg.ForeColor = System.Drawing.Color.Red;
                        return;
                    }

                    // Insert into Users
                    SqlCommand cmd = new SqlCommand(
                        "INSERT INTO Users (UName, FullName, Email, PasswordHash, Role) " +
                        "VALUES (@UName, @FullName, @Email, @PasswordHash, @Role); SELECT SCOPE_IDENTITY();", con);

                    cmd.Parameters.AddWithValue("@UName", txtUname.Text.Trim());
                    cmd.Parameters.AddWithValue("@FullName", txtFName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    string hashedPassword = ComputeSha256Hash(txtPass.Text);
                    cmd.Parameters.AddWithValue("@PasswordHash", hashedPassword);
                    cmd.Parameters.AddWithValue("@Role", ddlRole.SelectedValue);

                    int userId = Convert.ToInt32(cmd.ExecuteScalar());

                    // If Artisan, insert into Artisans table
                    if (ddlRole.SelectedValue == "Artisan")
                    {
                        SqlCommand artisanCmd = new SqlCommand(
                            "INSERT INTO Artisans (UserId, ApprovalStatus, JoinedOn) " +
                            "VALUES (@UserId, 'Pending', GETDATE())", con);
                        artisanCmd.Parameters.AddWithValue("@UserId", userId);
                        artisanCmd.ExecuteNonQuery();
                    }

                    lblMsg.Text = "Registration Successful!";
                    lblMsg.ForeColor = System.Drawing.Color.Green;
                    Clr();
                    Response.Redirect("~/SignIn.aspx");
                }
                catch (Exception ex)
                {
                    lblMsg.Text = "Error: " + ex.Message;
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        private bool isFormValid()
        {
            if (string.IsNullOrWhiteSpace(txtUname.Text)) return false;
            if (string.IsNullOrWhiteSpace(txtPass.Text)) return false;
            if (txtPass.Text != txtCPass.Text) return false;
            if (string.IsNullOrWhiteSpace(txtFName.Text) || !IsValidFullName(txtFName.Text)) return false;
            if (string.IsNullOrWhiteSpace(txtEmail.Text) || !IsValidEmail(txtEmail.Text)) return false;
            if (string.IsNullOrWhiteSpace(ddlRole.SelectedValue)) return false;

            return true;
        }

        private bool IsValidEmail(string email)
        {
            string pattern = @"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
            return Regex.IsMatch(email, pattern);
        }

        private bool IsValidFullName(string fullName)
        {
            string pattern = @"^[a-zA-Z\s]+$";
            return Regex.IsMatch(fullName, pattern);
        }

        private void Clr()
        {
            txtUname.Text = "";
            txtPass.Text = "";
            txtCPass.Text = "";
            txtFName.Text = "";
            txtEmail.Text = "";
            ddlRole.ClearSelection();
        }
    }
}
