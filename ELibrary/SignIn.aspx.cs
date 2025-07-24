using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace ELibrary
{
    public partial class SignIn : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.Cookies["USERNAME"] != null && Request.Cookies["PASSWORD"] != null)
                {
                    txtUsername.Text = Request.Cookies["USERNAME"].Value;
                    txtPassword.Attributes["value"] = Request.Cookies["PASSWORD"].Value;
                    chkRememberMe.Checked = true;
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";
            string hashedPassword = ComputeSha256Hash(txtPassword.Text.Trim());

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM Users WHERE UName = @username AND PasswordHash = @pwd", con);
                cmd.Parameters.AddWithValue("@username", txtUsername.Text.Trim());
                cmd.Parameters.AddWithValue("@pwd", hashedPassword);

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);

                if (dt.Rows.Count != 0)
                {
                    // Remember Me Cookies (Not secure for passwords in production)
                    if (chkRememberMe.Checked)
                    {
                        Response.Cookies["USERNAME"].Value = txtUsername.Text.Trim();
                        Response.Cookies["PASSWORD"].Value = txtPassword.Text.Trim();
                        Response.Cookies["USERNAME"].Expires = DateTime.Now.AddDays(10);
                        Response.Cookies["PASSWORD"].Expires = DateTime.Now.AddDays(10);
                    }
                    else
                    {
                        Response.Cookies["USERNAME"].Expires = DateTime.Now.AddDays(-1);
                        Response.Cookies["PASSWORD"].Expires = DateTime.Now.AddDays(-1);
                    }

                    // Store session info
                    Session["Username"] = txtUsername.Text.Trim();
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


        private void Clr()
        {
            txtPassword.Text = "";
            txtUsername.Text = "";
            txtUsername.Focus();
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
