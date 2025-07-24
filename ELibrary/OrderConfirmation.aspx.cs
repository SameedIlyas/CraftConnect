using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace ELibrary
{
    public partial class OrderConfirmation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string orderId = Request.QueryString["orderId"];
                if (string.IsNullOrEmpty(orderId))
                {
                    Response.Redirect("Products.aspx");
                    return;
                }

                LoadOrderDetails(orderId);
            }
        }

        private void LoadOrderDetails(string orderId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Get Order Info
                SqlCommand cmdOrder = new SqlCommand("SELECT * FROM Orders WHERE OrderID = @OID", con);
                cmdOrder.Parameters.AddWithValue("@OID", orderId);
                SqlDataReader reader = cmdOrder.ExecuteReader();

                if (reader.Read())
                {
                    lblOrderID.Text = "#" + reader["OrderID"].ToString();
                    lblOrderDate.Text = Convert.ToDateTime(reader["OrderDate"]).ToString("dd MMM yyyy, hh:mm tt");
                    lblStatus.Text = reader["Status"].ToString();
                    lblAddress.Text = reader["ShippingAddress"].ToString();
                    lblPhone.Text = reader["PhoneNumber"].ToString();
                    lblTotal.Text = Convert.ToDecimal(reader["TotalAmount"]).ToString("N0");
                }
                reader.Close();

                // Get Order Details
                SqlCommand cmdDetails = new SqlCommand(@"
                    SELECT od.Quantity, od.UnitPrice, p.ProductName
                    FROM OrderDetails od
                    INNER JOIN Products p ON od.ProductID = p.ProductID
                    WHERE od.OrderID = @OID", con);

                cmdDetails.Parameters.AddWithValue("@OID", orderId);
                SqlDataAdapter da = new SqlDataAdapter(cmdDetails);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptItems.DataSource = dt;
                rptItems.DataBind();
            }
        }
    }
}
