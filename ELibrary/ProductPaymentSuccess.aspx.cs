using Stripe;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stripe.Checkout;

namespace ELibrary
{
    public partial class ProductPaymentSuccess : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string sessionId = Request.QueryString["session_id"];
            if (string.IsNullOrEmpty(sessionId)) Response.Redirect("Checkout.aspx");

            StripeConfiguration.ApiKey = ConfigurationManager.AppSettings["StripeSecretKey"];
            var service = new SessionService();
            var session = service.Get(sessionId);

            if (session.PaymentStatus == "paid")
            {
                int orderId = SaveOrder(); // Your DB saving logic
                Response.Redirect($"OrderConfirmation.aspx?orderId={orderId}");
            }
            else
            {
                Response.Redirect("Checkout.aspx"); // Payment failed or canceled
            }
        }


        private int SaveOrder()
        {
            string userId = Session["UserID"].ToString();
            string address = Session["ShippingAddress"].ToString();
            string phone = Session["PhoneNumber"].ToString();
            decimal totalAmount = Convert.ToDecimal(Session["TotalAmount"]);
            DataTable cart = Session["Cart"] as DataTable;

            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlTransaction transaction = con.BeginTransaction();

                try
                {
                    // Insert Order
                    SqlCommand cmdOrder = new SqlCommand(
                        "INSERT INTO Orders (UserID, OrderDate, ShippingAddress, PhoneNumber, TotalAmount, Status) OUTPUT INSERTED.OrderID " +
                        "VALUES (@UserID, @Date, @Addr, @Phone, @Total, 'Processing')", con, transaction);

                    cmdOrder.Parameters.AddWithValue("@UserID", userId);
                    cmdOrder.Parameters.AddWithValue("@Date", DateTime.Now);
                    cmdOrder.Parameters.AddWithValue("@Addr", address);
                    cmdOrder.Parameters.AddWithValue("@Phone", phone);
                    cmdOrder.Parameters.AddWithValue("@Total", totalAmount);

                    int orderId = (int)cmdOrder.ExecuteScalar();

                    foreach (DataRow row in cart.Rows)
                    {
                        int productId = Convert.ToInt32(row["ProductID"]);
                        int quantity = Convert.ToInt32(row["Quantity"]);
                        decimal price = Convert.ToDecimal(row["Price"]);

                        // Insert into OrderDetails
                        SqlCommand cmdDetail = new SqlCommand(
                            "INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) " +
                            "VALUES (@OID, @PID, @Qty, @Price)", con, transaction);

                        cmdDetail.Parameters.AddWithValue("@OID", orderId);
                        cmdDetail.Parameters.AddWithValue("@PID", productId);
                        cmdDetail.Parameters.AddWithValue("@Qty", quantity);
                        cmdDetail.Parameters.AddWithValue("@Price", price);
                        cmdDetail.ExecuteNonQuery();

                        // Update Product Quantity
                        SqlCommand cmdUpdate = new SqlCommand(
                            "UPDATE Products SET Quantity = Quantity - @Qty WHERE ProductID = @PID", con, transaction);

                        cmdUpdate.Parameters.AddWithValue("@Qty", quantity);
                        cmdUpdate.Parameters.AddWithValue("@PID", productId);
                        cmdUpdate.ExecuteNonQuery();
                    }

                    transaction.Commit();

                    // Clear session
                    Session["Cart"] = null;
                    Session["ShippingAddress"] = null;
                    Session["PhoneNumber"] = null;
                    Session["TotalAmount"] = null;

                    return orderId;
                }
                catch
                {
                    transaction.Rollback();
                    throw;
                }
            }
        }

    }
}