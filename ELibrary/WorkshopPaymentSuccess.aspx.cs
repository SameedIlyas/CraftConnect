using Stripe;
using Stripe.Checkout;
using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ELibrary
{
    public partial class WorkshopPaymentSuccess : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string sessionId = Request.QueryString["session_id"];
                int userId = Convert.ToInt32(Request.QueryString["userId"]);
                int workshopId = Convert.ToInt32(Request.QueryString["workshopId"]);

                ViewState["WorkshopId"] = workshopId; // store for button redirect

                if (string.IsNullOrEmpty(sessionId))
                {
                    Response.Redirect("BrowseWorkshop.aspx");
                    return;
                }

                StripeConfiguration.ApiKey = ConfigurationManager.AppSettings["StripeSecretKey"];
                var service = new SessionService();
                var session = service.Get(sessionId);

                if (session.PaymentStatus == "paid")
                {
                    SaveEnrollment(userId, workshopId);
                    litMessage.Text = $"You have been successfully enrolled in the workshop.";
                }
                else
                {
                    Response.Redirect("BrowseWorkshop.aspx");
                }
            }
        }

        protected void btnViewWorkshop_Click(object sender, EventArgs e)
        {
            if (ViewState["WorkshopId"] != null)
            {
                int workshopId = Convert.ToInt32(ViewState["WorkshopId"]);
                Response.Redirect($"WorkshopDetails.aspx?id={workshopId}");
            }
        }

        private void SaveEnrollment(int userId, int workshopId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO WorkshopRegistration (WorkshopId, UserId) VALUES (@w, @u)", con);
                cmd.Parameters.AddWithValue("@w", workshopId);
                cmd.Parameters.AddWithValue("@u", userId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}
