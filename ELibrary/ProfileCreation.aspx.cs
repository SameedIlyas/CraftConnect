using Newtonsoft.Json;
using RestSharp;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Web.UI.WebControls;

namespace ELibrary
{
    public partial class ProfileCreation : System.Web.UI.Page
    {
        string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null || Session["Username"] == null)
                {
                    Response.Redirect("~/SignIn.aspx");
                    return;
                }

                int userId = Convert.ToInt32(Session["UserId"]);
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = @"
                        SELECT u.UName, u.Email, u.Country, a.StoreName, a.Description, a.Category, a.ApprovalStatus, u.ProfilePicture
                        FROM Artisans a
                        INNER JOIN Users u ON a.UserId = u.UserId
                        WHERE a.UserId = @UserId";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblName.Text = reader["UName"].ToString();
                        lblEmail.Text = reader["Email"].ToString();
                        lblAddress.Text = reader["Country"].ToString();

                        txtStoreName.Text = reader["StoreName"]?.ToString();
                        txtDescription.Text = reader["Description"]?.ToString();
                        ddlCategory.SelectedValue = reader["Category"]?.ToString();

                        string approvalStatus = reader["ApprovalStatus"]?.ToString()?.Trim();
                        if (string.IsNullOrEmpty(approvalStatus))
                            lblApprovalStatus.Text = "New";
                        else if (approvalStatus.Equals("Pending", StringComparison.OrdinalIgnoreCase))
                            lblApprovalStatus.Text = "Pending";
                        else if (approvalStatus.Equals("Approved", StringComparison.OrdinalIgnoreCase))
                            lblApprovalStatus.Text = "Approved";
                        else
                            lblApprovalStatus.Text = "New";

                        string nameSlug = reader["UName"].ToString().ToLower().Replace(" ", "");
                        lnkProfileUrl.Text = $"https://craftconnect.com/seller/profile/{nameSlug}";
                        lnkProfileUrl.NavigateUrl = lnkProfileUrl.Text;

                        if (reader["ProfilePicture"] != DBNull.Value)
                        {
                            imgProfile.ImageUrl = reader["ProfilePicture"].ToString();
                        }
                    }
                }
            }
        }

        protected void btnSubmitRequest_Click(object sender, EventArgs e)
        {

            if (Session["UserId"] == null || Session["Username"] == null)
            {
                Response.Redirect("~/SignIn.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE Artisans
                    SET StoreName = @StoreName,
                        Description = @Description,
                        Category = @Category,
                        ApprovalStatus = 'Pending'
                    WHERE UserId = @UserId";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@StoreName", txtStoreName.Text);
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);

                con.Open();
                int rowsUpdated = cmd.ExecuteNonQuery();
                if (rowsUpdated > 0)
                {
                    lblApprovalStatus.Text = "Profile submitted for approval. Please wait for the admin's response.";
                    lblStatusMessage.Text = "Profile submitted for approval.";
                    // Get sender name and store name for email
                    string senderName = Session["Username"].ToString();
                    string storeName = txtStoreName.Text;
                    string adminLink = "http://localhost:44338/Admin/AdminDashboard.aspx";
                    string adminEmail = ConfigurationManager.AppSettings["AdminEmail"];
                    SendStoreApprovalNotificationEmail(adminEmail, senderName, storeName, adminLink);
                }
                else
                {
                    lblApprovalStatus.Text = "Error submitting the profile.";
                    lblStatusMessage.Text = "An error occurred while submitting your profile. Please try again later.";
                }
            }
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


        protected void btnAddProducts_Click(object sender, EventArgs e)
        {
            string approvalStatus = lblApprovalStatus.Text.Trim();
            if (approvalStatus.Equals("Approved", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("ManageProducts.aspx");
            }
            else
            {
                lblStatusMessage.Text = "You need to be approved to add products.";
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFile)
            {
                string fileName = Path.GetFileName(fileUpload.PostedFile.FileName);
                string filePath = Server.MapPath("~/images/ProfilePictures/") + fileName;
                fileUpload.SaveAs(filePath);

                int userId = Convert.ToInt32(Session["UserId"]);
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = "UPDATE Users SET ProfilePicture = @ProfilePicture WHERE UserId = @UserId";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@ProfilePicture", "~/images/ProfilePictures/" + fileName);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                imgProfile.ImageUrl = "~/images/ProfilePictures/" + fileName;
                lblStatusMessage.Text = "Profile picture uploaded successfully!";
            }
            else
            {
                lblStatusMessage.Text = "Please select an image to upload.";
            }
        }
    }
}
