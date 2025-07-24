using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;

namespace ELibrary.Admin
{
    public partial class ProductDetails : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        int productId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Role"] != "Admin")
                {
                    Response.Redirect("~/adminlogin.aspx");
                }
                if (Request.QueryString["ProductId"] == null)
                {
                    Response.Redirect("ManageProducts.aspx");
                    return;
                }

                productId = Convert.ToInt32(Request.QueryString["ProductId"]);
                LoadProductDetails();
            }
        }

        private void LoadProductDetails()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        p.ProductId, 
                        p.ProductName, 
                        p.Description, 
                        p.Price, 
                        p.ImagePath, 
                        a.StoreName,
                        c.CategoryName
                    FROM Products p
                    INNER JOIN Artisans a ON p.ArtisanId = a.ArtisanId
                    LEFT JOIN Categories c ON p.CategoryId = c.CategoryId
                    WHERE p.ProductId = @ProductId";


                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ProductId", productId);
                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblProductName.Text = reader["ProductName"].ToString();
                    lblDescription.Text = reader["Description"].ToString();
                    lblCategory.Text = reader["CategoryName"].ToString();
                    lblPrice.Text = Convert.ToDecimal(reader["Price"]).ToString("F2");
                    lblStore.Text = reader["StoreName"].ToString();

                    string imagePath = reader["ImagePath"].ToString();
                    if (!string.IsNullOrEmpty(imagePath))
                        imgProduct.Src = "../" + imagePath;
                    else
                        imgProduct.Src = "~/images/cc.jpg";

                    pnlDetails.Visible = true;
                }
                else
                {
                    pnlError.Visible = true;
                }
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string deleteQuery = "DELETE FROM Products WHERE ProductId = @ProductId";
                SqlCommand cmd = new SqlCommand(deleteQuery, con);
                cmd.Parameters.AddWithValue("@ProductId", productId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("ManageProducts.aspx");
        }
    }
}
