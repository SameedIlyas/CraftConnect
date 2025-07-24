using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;

namespace ELibrary
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            if (string.IsNullOrEmpty(email))
            {
                lblMsg.Text = "Please enter your registered email.";
                lblMsg.CssClass = "text-danger";
                return;
            }

            string connectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";
            bool emailExists = false;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    emailExists = count > 0;
                }
            }

            if (!emailExists)
            {
                lblMsg.Text = "Email not found in the system.";
                lblMsg.CssClass = "text-danger";
                return;
            }

            string resetLink = $"http://localhost:44338/ResetPassword.aspx?email={email}";
            bool mailSent = SendResetEmailViaMailerSend(email, resetLink);

            if (mailSent)
            {
                lblMsg.Text = "Reset link sent. Please check your email.";
                lblMsg.CssClass = "text-success";
            }
            else
            {
                lblMsg.Text = "Failed to send reset email. Try again later.";
                lblMsg.CssClass = "text-danger";
            }
        }

        private bool SendResetEmailViaMailerSend(string toEmail, string resetLink)
        {
            try
            {
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                string apiKey = ConfigurationManager.AppSettings["MailerSendApiKey"];
                string fromEmail = ConfigurationManager.AppSettings["MailerSendEmail"];
                string fromName = "CraftConnect";

                var payload = new
                {
                    from = new { email = fromEmail, name = fromName },
                    to = new[] { new { email = toEmail } },
                    subject = "Password Reset Request",
                    html = $@"<p>Hello,</p>
                      <p>You requested a password reset. Click the link below:</p>
                      <p><a href='{resetLink}'>Reset Password</a></p>
                      <p>If you didn't request this, ignore it.</p>"
                };

                string jsonPayload = JsonConvert.SerializeObject(payload);

                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri("https://api.mailersend.com/v1/");
                    client.DefaultRequestHeaders.Clear();
                    client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");
                    client.DefaultRequestHeaders.Add("Accept", "application/json");

                    var content = new StringContent(jsonPayload, System.Text.Encoding.UTF8, "application/json");

                    HttpResponseMessage response = client.PostAsync("email", content).Result;

                    System.Diagnostics.Debug.WriteLine($"MailerSend Status: {(int)response.StatusCode} {response.StatusCode}");
                    string responseContent = response.Content.ReadAsStringAsync().Result;
                    System.Diagnostics.Debug.WriteLine($"Response: {responseContent}");

                    return response.IsSuccessStatusCode;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Exception in HttpClient Email:");
                System.Diagnostics.Debug.WriteLine(ex.ToString());
                return false;
            }
        }


    }
}
