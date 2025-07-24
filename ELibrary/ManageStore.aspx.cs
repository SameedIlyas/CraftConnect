using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace ELibrary
{
    public partial class ManageStore : System.Web.UI.Page
    {
        string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null || (string)Session["Role"] != "Artisan")
                {
                    Response.Redirect("~/SignIn.aspx");
                    return;
                }

                LoadStoreDetails();
            }
        }

        private void LoadStoreDetails()
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT a.StoreName, a.Description, a.Category, a.ApprovalStatus, u.PhoneNumber FROM Artisans a INNER JOIN Users u ON a.UserId = u.UserId WHERE a.UserId = @UserId", con);
                cmd.Parameters.AddWithValue("@UserId", artisanId);

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    if (reader["StoreName"] == DBNull.Value || string.IsNullOrWhiteSpace(reader["StoreName"].ToString()))
                    {
                        // No store created yet
                        pnlNoStore.Visible = true;
                        pnlStoreDetails.Visible = false;
                    }
                    else
                    {
                        // Store exists, populate fields
                        txtStoreName.Text = reader["StoreName"].ToString();
                        txtDescription.Text = reader["Description"].ToString();
                        ddlCategory.SelectedValue = reader["Category"].ToString();
                        txtPhone.Text = reader["PhoneNumber"].ToString();
                        lblStatus.Text = reader["ApprovalStatus"].ToString();


                        pnlNoStore.Visible = false;
                        pnlStoreDetails.Visible = true;

                        LoadProductList();
                    }
                }
                reader.Close();
            }
        }

        protected void btnEditStore_Click(object sender, EventArgs e)
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);

            // Server-side validation
            if (string.IsNullOrWhiteSpace(txtStoreName.Text) ||
                string.IsNullOrWhiteSpace(ddlCategory.SelectedValue) ||
                string.IsNullOrWhiteSpace(txtDescription.Text) ||
                string.IsNullOrWhiteSpace(txtPhone.Text) ||
                !System.Text.RegularExpressions.Regex.IsMatch(txtPhone.Text.Trim(), @"^03\d{9}$"))
            {
                lblStatusMessage.Text = "Please enter valid information in all fields (Phone should start with 03).";
                lblStatusMessage.CssClass = "text-danger fw-semibold";
                return;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Update Artisans table
                SqlCommand updateArtisan = new SqlCommand(@"
            UPDATE Artisans
            SET StoreName = @StoreName,
                Description = @Description,
                Category = @Category,
                ApprovalStatus = 'Pending'
            WHERE UserId = @UserId", con);

                updateArtisan.Parameters.AddWithValue("@StoreName", txtStoreName.Text.Trim());
                updateArtisan.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                updateArtisan.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                updateArtisan.Parameters.AddWithValue("@UserId", artisanId);
                updateArtisan.ExecuteNonQuery();

                // Update Users table (PhoneNumber)
                SqlCommand updateUser = new SqlCommand(@"
            UPDATE Users
            SET PhoneNumber = @PhoneNumber
            WHERE UserId = @UserId", con);

                updateUser.Parameters.AddWithValue("@PhoneNumber", txtPhone.Text.Trim());
                updateUser.Parameters.AddWithValue("@UserId", artisanId);
                updateUser.ExecuteNonQuery();
            }

            // Send store approval email to admin
            string senderName = Session["Username"].ToString();
            string storeName = txtStoreName.Text;
            string adminLink = "http://localhost:44338/Admin/AdminDashboard.aspx";
            string adminEmail = ConfigurationManager.AppSettings["AdminEmail"];
            SendStoreApprovalNotificationEmail(adminEmail, senderName, storeName, adminLink);

            lblStatusMessage.Text = "Store updated and submitted for re-approval. Redirecting...";
            lblStatusMessage.CssClass = "text-success fw-semibold";

            // Delay and redirect to ArtisanAccessCheck
            ClientScript.RegisterStartupScript(this.GetType(), "redirect",
                "setTimeout(function(){ window.location='ArtisanAccessCheck.aspx'; }, 3000);", true);
        }

        private bool SendStoreApprovalNotificationEmail(string toEmail, string senderName, string storeName, string adminLink)
        {
            try
            {
                // Ensure TLS 1.2 is used (MailerSend requires this)
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                string apiKey = ConfigurationManager.AppSettings["MailerSendApiKey"];
                string fromEmail = ConfigurationManager.AppSettings["MailerSendEmail"];
                string fromName = "CraftConnect";

                var client = new RestClient("https://api.mailersend.com/v1");

                var request = new RestRequest("email", Method.Post);
                request.AddHeader("Authorization", $"Bearer {apiKey}");
                request.AddHeader("Content-Type", "application/json");
                request.AddHeader("Accept", "application/json");

                var body = new
                {
                    from = new { email = fromEmail, name = fromName },
                    to = new[] { new { email = toEmail } },
                    subject = $"New Store Submitted: {storeName}",
                    html = $@"<p>Hello Admin,</p>
                      <p><strong>{senderName}</strong> has submitted a new store named <strong>{storeName}</strong> for approval.</p>
                      <p>Please review it at your admin dashboard:</p>
                      <p><a href='{adminLink}'>Go to Admin Dashboard</a></p>"
                };

                // Serialize and log JSON request body
                string requestJson = JsonConvert.SerializeObject(body, Formatting.Indented);
                System.Diagnostics.Debug.WriteLine("Sending request to MailerSend:");
                System.Diagnostics.Debug.WriteLine(requestJson);

                request.AddJsonBody(body);

                var response = client.Execute(request);

                // Log response
                System.Diagnostics.Debug.WriteLine("MailerSend Response:");
                System.Diagnostics.Debug.WriteLine($"Status Code: {(int)response.StatusCode} {response.StatusCode}");
                System.Diagnostics.Debug.WriteLine($"Content: {response.Content}");
                System.Diagnostics.Debug.WriteLine($"Error Exception: {response.ErrorException?.Message}");
                System.Diagnostics.Debug.WriteLine($"Error Message: {response.ErrorMessage}");

                // Success check (200–299)
                if ((int)response.StatusCode >= 200 && (int)response.StatusCode <= 299)
                {
                    return true;
                }

                // Try to parse API error
                if (!string.IsNullOrEmpty(response.Content))
                {
                    try
                    {
                        var errorResponse = JsonConvert.DeserializeObject<dynamic>(response.Content);
                        System.Diagnostics.Debug.WriteLine($"API Error Message: {errorResponse?.message}");
                        System.Diagnostics.Debug.WriteLine($"API Error Code: {errorResponse?.code}");
                    }
                    catch (Exception jsonEx)
                    {
                        System.Diagnostics.Debug.WriteLine($"Failed to parse error response: {jsonEx.Message}");
                    }
                }

                return false;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Exception in SendStoreApprovalNotificationEmail:");
                System.Diagnostics.Debug.WriteLine($"Message: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
                if (ex.InnerException != null)
                {
                    System.Diagnostics.Debug.WriteLine($"Inner Exception: {ex.InnerException.Message}");
                }
                return false;
            }
        }



        private void LoadProductList()
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT ProductName, Price FROM Products WHERE ArtisanId = @ArtisanId", con);
                cmd.Parameters.AddWithValue("@ArtisanId", artisanId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptProducts.DataSource = dt;
                rptProducts.DataBind();
            }
        }

        protected void btnGoToProfileCreation_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ProfileCreation.aspx");
        }
    }
}
