using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ELibrary
{
    public partial class Products : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                LoadSellers();

                if (!string.IsNullOrEmpty(Request.QueryString["category"]))
                {
                    string categoryName = Request.QueryString["category"];
                    ddlCategory.SelectedValue = GetCategoryIdByName(categoryName);
                }

                LoadProducts();
            }
        }

        private string GetCategoryIdByName(string categoryName)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT CategoryID FROM Categories WHERE CategoryName = @Name";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Name", categoryName);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? result.ToString() : "";
            }
        }


        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT CategoryID, CategoryName FROM Categories";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                ddlCategory.DataSource = cmd.ExecuteReader();
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataBind();
            }

            ddlCategory.Items.Insert(0, new ListItem("All Categories", ""));
        }

        private void LoadSellers()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT DISTINCT SellerName FROM Products";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                ddlSeller.DataSource = cmd.ExecuteReader();
                ddlSeller.DataTextField = "SellerName";
                ddlSeller.DataValueField = "SellerName";
                ddlSeller.DataBind();
            }

            ddlSeller.Items.Insert(0, new ListItem("All Sellers", ""));
        }

        private void LoadProducts(string sort = "")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        p.ProductID, p.ProductName, p.ImagePath, p.Price, p.Quantity, p.SellerName,
                        c.CategoryName
                    FROM Products p
                    JOIN Categories c ON p.CategoryID = c.CategoryID
                    WHERE 1=1
                ";

                // Filtering
                if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
                    query += " AND c.CategoryID = @CategoryID";

                if (!string.IsNullOrEmpty(ddlSeller.SelectedValue))
                    query += " AND p.SellerName = @SellerName";

                if (!string.IsNullOrEmpty(ddlPrice.SelectedValue))
                {
                    string priceRange = ddlPrice.SelectedValue;
                    if (priceRange.Contains("-"))
                    {
                        string[] range = priceRange.Split('-');
                        query += " AND p.Price BETWEEN @PriceMin AND @PriceMax";
                    }
                    else if (priceRange == "1000") // Below 1000
                    {
                        query += " AND p.Price < @PriceMax";
                    }
                    else if (priceRange == "3000") // Above 3000
                    {
                        query += " AND p.Price > @PriceMin";
                    }
                }

                // Sorting
                if (sort == "asc")
                    query += " ORDER BY p.Price ASC";
                else if (sort == "desc")
                    query += " ORDER BY p.Price DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
                        cmd.Parameters.AddWithValue("@CategoryID", ddlCategory.SelectedValue);

                    if (!string.IsNullOrEmpty(ddlSeller.SelectedValue))
                        cmd.Parameters.AddWithValue("@SellerName", ddlSeller.SelectedValue);

                    if (!string.IsNullOrEmpty(ddlPrice.SelectedValue))
                    {
                        string priceRange = ddlPrice.SelectedValue;
                        if (priceRange.Contains("-"))
                        {
                            string[] range = priceRange.Split('-');
                            cmd.Parameters.AddWithValue("@PriceMin", range[0]);
                            cmd.Parameters.AddWithValue("@PriceMax", range[1]);
                        }
                        else if (priceRange == "1000")
                        {
                            cmd.Parameters.AddWithValue("@PriceMax", 1000);
                        }
                        else if (priceRange == "3000")
                        {
                            cmd.Parameters.AddWithValue("@PriceMin", 3000);
                        }
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptProducts.DataSource = dt;
                        rptProducts.DataBind();
                    }
                }
            }
        }

        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts(ddlSort.SelectedValue);
        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts(ddlCategory.SelectedValue);
        }

        protected void ddlSeller_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts(ddlSeller.SelectedValue);
        }

        protected void ddlPrice_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts(ddlPrice.SelectedValue);
        }
    }
}
