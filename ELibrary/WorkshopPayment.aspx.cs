using Stripe;
using Stripe.Checkout;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace ELibrary
{
    public partial class WorkshopPayment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                Response.Redirect("SignIn.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);
            int workshopId = Convert.ToInt32(Request.QueryString["id"]);

            // Fetch actual workshop fee from DB
            int amountInPKR = GetWorkshopFee(workshopId);
            if (amountInPKR <= 0)
            {
                litMessage.Text = "<div class='alert alert-danger'>Invalid workshop fee or workshop not found.</div>";
                return;
            }

            int amountInMinorUnit = amountInPKR * 100; // Stripe's smallest unit

            StripeConfiguration.ApiKey = ConfigurationManager.AppSettings["StripeSecretKey"];

            try
            {
                var options = new SessionCreateOptions
                {
                    PaymentMethodTypes = new List<string> { "card" },
                    Mode = "payment",
                    LineItems = new List<SessionLineItemOptions>
                    {
                        new SessionLineItemOptions
                        {
                            PriceData = new SessionLineItemPriceDataOptions
                            {
                                Currency = "pkr",
                                UnitAmount = amountInMinorUnit,
                                ProductData = new SessionLineItemPriceDataProductDataOptions
                                {
                                    Name = GetWorkshopTitle(workshopId)
                                },
                            },
                            Quantity = 1
                        }
                    },
                    SuccessUrl = $"{Request.Url.GetLeftPart(UriPartial.Authority)}/WorkshopPaymentSuccess.aspx?workshopId={workshopId}&userId={userId}&session_id={{CHECKOUT_SESSION_ID}}",
                    CancelUrl = $"{Request.Url.GetLeftPart(UriPartial.Authority)}/BrowseWorkshop.aspx"
                };

                var service = new SessionService();
                Session session = service.Create(options);

                Response.Redirect(session.Url);
            }
            catch (Exception ex)
            {
                litMessage.Text = $"<div class='alert alert-danger'>Error: {ex.Message}</div>";
            }
        }

        private int GetWorkshopFee(int workshopId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT Fee FROM Workshops WHERE Id = @id", con);
                cmd.Parameters.AddWithValue("@id", workshopId);
                object fee = cmd.ExecuteScalar();
                return fee != null ? Convert.ToInt32(fee) : 0;
            }
        }

        private string GetWorkshopTitle(int workshopId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT Title FROM Workshops WHERE Id = @id", con);
                cmd.Parameters.AddWithValue("@id", workshopId);
                object title = cmd.ExecuteScalar();
                return title?.ToString() ?? "CraftConnect Workshop";
            }
        }
    }
}
