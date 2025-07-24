using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI.HtmlControls;

namespace ELibrary
{
    public partial class CreateStore : System.Web.UI.Page
    {
        string connectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlRegister.Visible = true;
                pnlAlreadyRegistered.Visible = false;

                if (Session["Role"] == "Artisan")
                {
                    Response.Redirect("ArtisanDashboard.aspx");
                }
            }
        }

        protected void btnAlreadyRegistered_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";
            Label1.Text = "";
            pnlRegister.Visible = false;
            pnlAlreadyRegistered.Visible = true;
            headingTitle.InnerText = "Login to Manage Your Artisan Profile";

            // Change button style to green
            btnAlreadyRegistered.CssClass = "btn btn-success";
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

        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            string connectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

            if (!isFormValid())
            {
                lblMessage.Text = "Please fill all required fields correctly.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Email = @Email OR UName = @UName", con);
                    checkCmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    checkCmd.Parameters.AddWithValue("@UName", txtUName.Text.Trim());

                    int count = (int)checkCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        lblMessage.Text = "Username or Email already exists.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        return;
                    }

                    // Insert into Users
                    SqlCommand cmd = new SqlCommand(
                        "INSERT INTO Users (UName, FullName, Email, PasswordHash, Role, Country) " +
                        "VALUES (@UName, @FullName, @Email, @PasswordHash, @Role, @Country); SELECT SCOPE_IDENTITY();", con);

                    cmd.Parameters.AddWithValue("@UName", txtUName.Text.Trim());
                    cmd.Parameters.AddWithValue("@FullName", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    string hashedPassword = ComputeSha256Hash(txtPassword.Text);
                    cmd.Parameters.AddWithValue("@PasswordHash", hashedPassword);
                    cmd.Parameters.AddWithValue("@Role", "Artisan");
                    cmd.Parameters.AddWithValue("@Country", ddlCountry.SelectedValue);

                    int userId = Convert.ToInt32(cmd.ExecuteScalar());

                    // If Artisan, insert into Artisans table
                        SqlCommand artisanCmd = new SqlCommand(
                            "INSERT INTO Artisans (UserId, ApprovalStatus, JoinedOn) " +
                            "VALUES (@UserId, 'Pending', GETDATE())", con);
                        artisanCmd.Parameters.AddWithValue("@UserId", userId);
                        artisanCmd.ExecuteNonQuery();

                    lblMessage.Text = "Registration Successful!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    Clr();
                    Response.Redirect("~/SignIn.aspx");
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        private bool isFormValid()
        {
            if (string.IsNullOrWhiteSpace(txtUName.Text)) return false;
            if (string.IsNullOrWhiteSpace(txtPassword.Text)) return false;
            if (txtPassword.Text != txtConfirmPassword.Text) return false;
            if (string.IsNullOrWhiteSpace(txtName.Text) || !IsValidFullName(txtName.Text)) return false;
            if (string.IsNullOrWhiteSpace(txtEmail.Text) || !IsValidEmail(txtEmail.Text)) return false;

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
            txtUName.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            txtName.Text = "";
            txtEmail.Text = "";
            ddlCountry.ClearSelection();
            txtLoginPassword.Text = "";
            txtLoginUsername.Text = "";
        }


        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";
            string hashedPassword = ComputeSha256Hash(txtLoginPassword.Text.Trim());

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM Users WHERE UName = @username AND PasswordHash = @pwd", con);
                cmd.Parameters.AddWithValue("@username", txtLoginUsername.Text.Trim());
                cmd.Parameters.AddWithValue("@pwd", hashedPassword);

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);

                if (dt.Rows.Count != 0)
                {

                    // Store session info
                    Session["Username"] = txtLoginUsername.Text.Trim();
                    Session["Role"] = dt.Rows[0]["Role"].ToString();
                    Session["UserId"] = dt.Rows[0]["UserId"].ToString(); // Add this line to store UserId

                    // Role-based redirect
                    string role = dt.Rows[0]["Role"].ToString();
                    if (role == "Admin")
                    {
                        Response.Redirect("~/Admin/AdminDashboard.aspx");
                    }
                    else if (role == "Artisan")
                    {
                        Response.Redirect("~/ArtisanAccessCheck.aspx");
                    }
                    else // User or default
                    {
                        Response.Redirect("~/UserHome.aspx");
                    }

                }
                else
                {
                    Label1.Text = "Invalid Username or Password.";
                    Label1.ForeColor = System.Drawing.Color.Red;
                }

                Clr();
            }
        }
    }
}