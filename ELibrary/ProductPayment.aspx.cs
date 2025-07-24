using Stripe;
using Stripe.Checkout;
using Stripe.Forwarding;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ELibrary

{
    public partial class ProductPayment : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
            {
                if (Session["UserID"] == null || Session["Cart"] == null)
                {
                    Response.Redirect("SignIn.aspx");
                    return;
                }

                if (!IsPostBack)
                {
                    // Read from session
                    DataTable cart = Session["Cart"] as DataTable;
                    decimal totalAmount = Convert.ToDecimal(Session["TotalAmount"]);
                    int amountInMinorUnit = (int)(totalAmount * 100);

                    StripeConfiguration.ApiKey = ConfigurationManager.AppSettings["StripeSecretKey"];

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
                                    Name = "CraftConnect Order"
                                },
                            },
                            Quantity = 1
                        }
                    },
                        SuccessUrl = $"{Request.Url.GetLeftPart(UriPartial.Authority)}/ProductPaymentSuccess.aspx?session_id={{CHECKOUT_SESSION_ID}}",
                        CancelUrl = $"{Request.Url.GetLeftPart(UriPartial.Authority)}/Checkout.aspx"
                    };

                    var service = new SessionService();
                    Session session = service.Create(options);

                    // Redirect user to Stripe Checkout
                    Response.Redirect(session.Url);
                }
            }
    }
}
