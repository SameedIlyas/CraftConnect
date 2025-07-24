using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary
{
    public partial class Checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCart();
            }
        }

        private void BindCart()
        {
            if (Session["Cart"] != null)
            {
                DataTable cart = Session["Cart"] as DataTable;
                rptCart.DataSource = cart;
                rptCart.DataBind();

                decimal total = 0;
                foreach (DataRow row in cart.Rows)
                {
                    total += Convert.ToDecimal(row["Price"]) * Convert.ToInt32(row["Quantity"]);
                }
                lblTotalAmount.Text = total.ToString("N0");
                Session["TotalAmount"] = total;
            }
            else
            {
                Response.Redirect("Products.aspx");
            }
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string address = txtAddress.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string paymentMethod = hfPaymentMethod.Value;

            Session["ShippingAddress"] = address;
            Session["PhoneNumber"] = phone;
            Session["PaymentMethod"] = paymentMethod;

            if (paymentMethod == "online")
            {
                Response.Redirect("ProductPayment.aspx");
            }
            else if (paymentMethod == "cod")
            {
                // Insert into DB and redirect to Order Confirmation
                int orderId = SaveOrderToDatabase();
                Response.Redirect("OrderConfirmation.aspx?orderId=" + orderId);
            }
        }

        private int SaveOrderToDatabase()
        {
            string userId = Session["UserID"]?.ToString();
            string address = Session["ShippingAddress"]?.ToString();
            string phone = Session["PhoneNumber"]?.ToString();
            decimal totalAmount = Convert.ToDecimal(Session["TotalAmount"]);
            DataTable cart = Session["Cart"] as DataTable;

            if (string.IsNullOrEmpty(userId) || cart == null || cart.Rows.Count == 0)
                throw new InvalidOperationException("Missing order data.");

            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                using (SqlTransaction transaction = con.BeginTransaction())
                {
                    try
                    {
                        // 1. Insert into Orders and retrieve OrderID
                        SqlCommand cmdOrder = new SqlCommand(@"
                    INSERT INTO Orders (UserID, OrderDate, ShippingAddress, PhoneNumber, TotalAmount, Status)
                    OUTPUT INSERTED.OrderID
                    VALUES (@UserID, @OrderDate, @ShippingAddress, @PhoneNumber, @TotalAmount, @Status)", con, transaction);

                        cmdOrder.Parameters.AddWithValue("@UserID", userId);
                        cmdOrder.Parameters.AddWithValue("@OrderDate", DateTime.Now);
                        cmdOrder.Parameters.AddWithValue("@ShippingAddress", address);
                        cmdOrder.Parameters.AddWithValue("@PhoneNumber", phone);
                        cmdOrder.Parameters.AddWithValue("@TotalAmount", totalAmount);
                        cmdOrder.Parameters.AddWithValue("@Status", "Processing");

                        int orderId = (int)cmdOrder.ExecuteScalar();

                        // 2. Insert OrderDetails and update product quantities
                        foreach (DataRow row in cart.Rows)
                        {
                            int productId = Convert.ToInt32(row["ProductID"]);
                            int quantity = Convert.ToInt32(row["Quantity"]);
                            decimal unitPrice = Convert.ToDecimal(row["Price"]);

                            // Insert into OrderDetails
                            SqlCommand cmdDetail = new SqlCommand(@"
                        INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
                        VALUES (@OrderID, @ProductID, @Quantity, @UnitPrice)", con, transaction);

                            cmdDetail.Parameters.AddWithValue("@OrderID", orderId);
                            cmdDetail.Parameters.AddWithValue("@ProductID", productId);
                            cmdDetail.Parameters.AddWithValue("@Quantity", quantity);
                            cmdDetail.Parameters.AddWithValue("@UnitPrice", unitPrice);
                            cmdDetail.ExecuteNonQuery();

                            // Update Products stock
                            SqlCommand cmdUpdateStock = new SqlCommand(@"
                        UPDATE Products
                        SET Quantity = Quantity - @Quantity
                        WHERE ProductID = @ProductID", con, transaction);

                            cmdUpdateStock.Parameters.AddWithValue("@Quantity", quantity);
                            cmdUpdateStock.Parameters.AddWithValue("@ProductID", productId);
                            cmdUpdateStock.ExecuteNonQuery();
                        }

                        transaction.Commit();

                        // Clear session cart data
                        Session.Remove("Cart");
                        Session.Remove("ShippingAddress");
                        Session.Remove("PhoneNumber");
                        Session.Remove("TotalAmount");

                        return orderId;
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        // Optionally log the error here
                        throw new ApplicationException("An error occurred while placing the order.", ex);
                    }
                }
            }
        }
    }
}