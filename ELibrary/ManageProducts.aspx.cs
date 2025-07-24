using System;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace ELibrary
{
    public partial class ManageProducts : System.Web.UI.Page
    {
        string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null || (string)Session["Role"] != "Artisan")
                {
                    Response.Redirect("~/SignIn.aspx");
                    return;
                }
                LoadCategories();
                LoadProducts();
            }
        }

        private void LoadCategories()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT CategoryID, CategoryName FROM Categories", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlCategory.DataSource = dt;
                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataBind();

                ddlCategory.Items.Insert(0, new ListItem("Select Category", ""));
            }
        }

        private void LoadProducts()
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT P.ProductID, P.ProductName, P.Price, P.Quantity, C.CategoryName, P.ImagePath
                    FROM Products P
                    JOIN Categories C ON P.CategoryID = C.CategoryID
                    WHERE P.ArtisanId = @ArtisanId", con);

                cmd.Parameters.AddWithValue("@ArtisanId", artisanId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptProducts.DataSource = dt;
                rptProducts.DataBind();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hfProductId.Value))
            {
                btnAddProduct_Click(sender, e); // New Product
            }
            else
            {
                btnUpdateProduct_Click(sender, e); // Edit Product
            }
        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);
            string name = txtProductName.Text.Trim();
            decimal price = decimal.Parse(txtPrice.Text);
            string seller = Session["Username"]?.ToString();
            int categoryId = int.Parse(ddlCategory.SelectedValue);
            string description = txtDescription.Text.Trim();
            int quantity = int.Parse(txtQuantity.Text);
            string imagePath = "";

            int productId;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Products (ArtisanId, ProductName, Price, SellerName, CategoryID, Description, DateAdded, Quantity)
                    OUTPUT INSERTED.ProductID
                    VALUES (@ArtisanId, @Name, @Price, @Seller, @CategoryID, @Description, GETDATE(), @Quantity)", con);

                cmd.Parameters.AddWithValue("@ArtisanId", artisanId);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Price", price);
                cmd.Parameters.AddWithValue("@Seller", seller);
                cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                cmd.Parameters.AddWithValue("@Description", description);
                cmd.Parameters.AddWithValue("@Quantity", quantity);

                con.Open();
                productId = (int)cmd.ExecuteScalar();
            }

            // Save image if uploaded
            if (fuImage.HasFile)
            {
                string folderPath = Server.MapPath($"~/images/{artisanId}/{productId}/");
                Directory.CreateDirectory(folderPath);

                string fileName = Path.GetFileName(fuImage.FileName);
                string savePath = Path.Combine(folderPath, fileName);
                fuImage.SaveAs(savePath);

                imagePath = $"images/{artisanId}/{productId}/{fileName}";

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Products SET ImagePath = @Path WHERE ProductID = @Id", con);
                    cmd.Parameters.AddWithValue("@Path", imagePath);
                    cmd.Parameters.AddWithValue("@Id", productId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "Product added successfully.";
            lblMessage.CssClass = "alert alert-success";
            pnlMessage.Visible = true;

            ClientScript.RegisterStartupScript(this.GetType(), "HideMsg", "setTimeout(function() { document.getElementById('" + pnlMessage.ClientID + "').style.display = 'none'; }, 4000);", true);

            ClearForm();
            LoadProducts();
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Edit")
            {
                LoadProductForEdit(productId);
            }
        }

        protected void EditProduct_Command(object sender, CommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            hfProductId.Value = productId.ToString(); // Save for update
            btnSave.Text = "Update Product";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT * FROM Products WHERE ProductID = @ProductID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ProductID", productId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtProductName.Text = reader["ProductName"].ToString();
                            txtPrice.Text = reader["Price"].ToString();
                            txtQuantity.Text = reader["Quantity"].ToString();
                            ddlCategory.SelectedValue = reader["CategoryID"].ToString();
                            txtDescription.Text = reader["Description"].ToString();
                        }
                    }
                }
            }

            // Show panel and set button visibility
            pnlAddProduct.Visible = true;
            pnlAddProduct.CssClass = "card p-4 mb-4"; // Remove hidden-panel
        }


        private void LoadProductForEdit(int id)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Products WHERE ProductID = @Id", con);
                cmd.Parameters.AddWithValue("@Id", id);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    hfProductId.Value = id.ToString();
                    txtProductName.Text = reader["ProductName"].ToString();
                    txtPrice.Text = reader["Price"].ToString();
                    ddlCategory.SelectedValue = reader["CategoryID"].ToString();
                    txtDescription.Text = reader["Description"].ToString();
                    txtQuantity.Text = reader["Quantity"].ToString();

                }
            }
        }

        protected void BtnShowForm_Click(object sender, EventArgs e)
        {
            pnlAddProduct.Visible = true;
            pnlAddProduct.CssClass = "card p-4 mb-4"; // REMOVE 'hidden-panel' here

            btnSave.Text = "Save Product";

            lblMessage.Text = "";
            pnlMessage.Visible = false;

            ClearForm();
        }



        protected void btnUpdateProduct_Click(object sender, EventArgs e)
        {
            int productId = int.Parse(hfProductId.Value);
            int artisanId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    UPDATE Products SET
                        ProductName = @Name,
                        Price = @Price,
                        SellerName = @Seller,
                        CategoryID = @CategoryID,
                        Description = @Description,
                        Quantity = @Quantity
                    WHERE ProductID = @Id AND ArtisanId = @ArtisanId", con);

                cmd.Parameters.AddWithValue("@Name", txtProductName.Text.Trim());
                cmd.Parameters.AddWithValue("@Price", decimal.Parse(txtPrice.Text));
                cmd.Parameters.AddWithValue("@Seller", Session["Username"]?.ToString());
                cmd.Parameters.AddWithValue("@CategoryID", int.Parse(ddlCategory.SelectedValue));
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@Quantity", int.Parse(txtQuantity.Text));
                cmd.Parameters.AddWithValue("@Id", productId);
                cmd.Parameters.AddWithValue("@ArtisanId", artisanId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            // Optional: Update image if a new one is uploaded
            if (fuImage.HasFile)
            {
                string folderPath = Server.MapPath($"~/images/{artisanId}/{productId}/");
                Directory.CreateDirectory(folderPath);

                string fileName = Path.GetFileName(fuImage.FileName);
                string savePath = Path.Combine(folderPath, fileName);
                fuImage.SaveAs(savePath);

                string imagePath = $"images/{artisanId}/{productId}/{fileName}";

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Products SET ImagePath = @Path WHERE ProductID = @Id", con);
                    cmd.Parameters.AddWithValue("@Path", imagePath);
                    cmd.Parameters.AddWithValue("@Id", productId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            lblMessage.Text = "Product updated successfully.";
            lblMessage.CssClass = "alert alert-success";
            pnlMessage.Visible = true;

            ClientScript.RegisterStartupScript(this.GetType(), "HideMsg", "setTimeout(function() { document.getElementById('" + pnlMessage.ClientID + "').style.display = 'none'; }, 4000);", true);

            ClearForm();
            LoadProducts();
        }

        private void ClearForm()
        {
            txtProductName.Text = "";
            txtPrice.Text = "";
            ddlCategory.SelectedIndex = 0;
            txtDescription.Text = "";
            txtQuantity.Text = "";
            hfProductId.Value = "";
        }

        protected void DeleteProduct_Command(object sender, CommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Try deleting the product
                    string deleteQuery = "DELETE FROM Products WHERE ProductID = @ProductID";
                    using (SqlCommand deleteCmd = new SqlCommand(deleteQuery, conn))
                    {
                        deleteCmd.Parameters.AddWithValue("@ProductID", productId);
                        deleteCmd.ExecuteNonQuery();

                        lblMessage.Text = "Product deleted successfully!";
                        lblMessage.CssClass = "alert alert-success";
                    }
                }
            }
            catch (SqlException ex)
            {
                if (ex.Message.Contains("REFERENCE constraint"))
                {
                    // If product is referenced in orders, set quantity to 0 instead
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        string updateQuery = "UPDATE Products SET Quantity = 0 WHERE ProductID = @ProductID";
                        using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                        {
                            updateCmd.Parameters.AddWithValue("@ProductID", productId);
                            updateCmd.ExecuteNonQuery();

                            lblMessage.Text = "Product cannot be deleted because it has been ordered. Quantity set to 0.";
                            lblMessage.CssClass = "alert alert-warning";
                        }
                    }
                }
                else
                {
                    lblMessage.Text = "An unexpected error occurred.";
                    lblMessage.CssClass = "alert alert-danger";
                }
            }

            pnlMessage.Visible = true;
            LoadProducts(); // Refresh the product list
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlAddProduct.Visible = false;
            pnlMessage.Visible = false;
            ClearForm();
        }

    }
}
