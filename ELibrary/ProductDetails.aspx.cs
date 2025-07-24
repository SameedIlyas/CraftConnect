using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace ELibrary
{
    public partial class ProductDetails : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    LoadProductDetails();
                    LoadFeedback();
                }
                else
                {
                    Response.Redirect("Products.aspx");
                }

                if (Session["UserId"] != null)
                    pnlAddFeedback.Visible = true;
            }
        }

        private void LoadProductDetails()
        {
            int productId = int.Parse(Request.QueryString["id"]);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"
                    SELECT p.*, c.CategoryName
                    FROM Products p
                    JOIN Categories c ON p.CategoryID = c.CategoryID
                    WHERE p.ProductID = @ProductID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ProductID", productId);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblName.Text = dr["ProductName"].ToString();
                    lblPrice.Text = dr["Price"].ToString();
                    lblDescription.Text = dr["Description"].ToString();
                    lblCategory.Text = dr["CategoryName"].ToString();
                    lblSeller.Text = dr["SellerName"].ToString();
                    lblQuantity.Text = Convert.ToInt32(dr["Quantity"]) > 0 ? dr["Quantity"].ToString() : "Out of Stock";
                    imgProduct.ImageUrl = dr["ImagePath"].ToString();

                    btnAddToCart.Visible = Convert.ToInt32(dr["Quantity"]) > 0 && Session["UserId"] != null;
                }
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                lblStatus.Text = "⚠️ Please sign in to add items to cart.";
                lblStatus.CssClass = "ms-3 fw-semibold text-danger";
                return;
            }

            int quantityAvailable = int.Parse(lblQuantity.Text);
            int quantityToAdd = int.Parse(txtQty.Text);

            if (quantityToAdd > quantityAvailable)
            {
                lblStatus.Text = "❌ Quantity exceeds available stock.";
                lblStatus.CssClass = "ms-3 fw-semibold text-danger";
                return;
            }

            // Initialize cart if not already
            DataTable cart;
            if (Session["Cart"] == null)
            {
                cart = new DataTable();
                cart.Columns.Add("ProductID");
                cart.Columns.Add("ProductName");
                cart.Columns.Add("Price", typeof(decimal));
                cart.Columns.Add("Quantity", typeof(int));
                cart.Columns.Add("ImagePath");
                Session["Cart"] = cart;
            }
            else
            {
                cart = (DataTable)Session["Cart"];
            }

            string productId = Request.QueryString["id"];
            bool productExists = false;

            foreach (DataRow row in cart.Rows)
            {
                if (row["ProductID"].ToString() == productId)
                {
                    int existingQty = Convert.ToInt32(row["Quantity"]);
                    int newQty = existingQty + quantityToAdd;

                    if (newQty > quantityAvailable)
                    {
                        lblStatus.Text = "⚠️ Adding this would exceed stock.";
                        lblStatus.CssClass = "ms-3 fw-semibold text-danger";
                        return;
                    }

                    row["Quantity"] = newQty;
                    productExists = true;
                    break;
                }
            }

            if (!productExists)
            {
                DataRow newRow = cart.NewRow();
                newRow["ProductID"] = productId;
                newRow["ProductName"] = lblName.Text;
                newRow["Price"] = Convert.ToDecimal(lblPrice.Text);
                newRow["Quantity"] = quantityToAdd;
                newRow["ImagePath"] = imgProduct.ImageUrl;
                cart.Rows.Add(newRow);
            }

            lblStatus.Text = "✅ Added to cart!";
            lblStatus.CssClass = "ms-3 fw-semibold text-success";
        }

        private void LoadFeedback()
        {
            int productId = Convert.ToInt32(Request.QueryString["id"]);
            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"SELECT f.Rating, f.Comment, f.Response, f.SubmittedAt, u.UName 
                         FROM ProductFeedback f
                         INNER JOIN Users u ON f.UserId = u.UserId
                         WHERE f.ProductId = @ProductId
                         ORDER BY f.SubmittedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ProductId", productId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    rptFeedback.DataSource = reader;
                    rptFeedback.DataBind();
                }
            }
        }

        protected void btnSubmitFeedback_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) return;

            int userId = Convert.ToInt32(Session["UserId"]);
            int productId = Convert.ToInt32(Request.QueryString["id"]);
            int rating = Convert.ToInt32(ddlRating.SelectedValue);
            string comment = txtComment.Text.Trim();

            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO ProductFeedback (ProductId, UserId, Rating, Comment, SubmittedAt)
                         VALUES (@ProductId, @UserId, @Rating, @Comment, GETDATE())";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ProductId", productId);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@Rating", rating);
                    cmd.Parameters.AddWithValue("@Comment", comment);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            lblFeedbackStatus.Text = "Thank you for your feedback!";
            txtComment.Text = "";
            ddlRating.SelectedIndex = 0;
            LoadFeedback();
        }

    }
}
