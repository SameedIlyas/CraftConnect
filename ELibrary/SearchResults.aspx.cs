using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;

namespace ELibrary
{
    public partial class SearchResults : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }


        [WebMethod]
        public static List<Dictionary<string, object>> GetFilteredProducts(string query, string category, string price, string artisan)
        {
            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            List<Dictionary<string, object>> products = new List<Dictionary<string, object>>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Use JOIN to get CategoryName from Categories table
                List<string> conditions = new List<string>
        {
            "(P.ProductName LIKE @query OR P.Description LIKE @query)"
        };

                if (!string.IsNullOrEmpty(category))
                    conditions.Add("C.CategoryName = @category");

                if (!string.IsNullOrEmpty(artisan))
                    conditions.Add("P.SellerName LIKE @artisan");

                if (!string.IsNullOrEmpty(price))
                {
                    if (price == "0-500")
                        conditions.Add("P.Price < 500");
                    else if (price == "500-1000")
                        conditions.Add("P.Price >= 500 AND P.Price <= 1000");
                    else if (price == "1000-")
                        conditions.Add("P.Price > 1000");
                }

                string whereClause = string.Join(" AND ", conditions);

                string sql = $@"
            SELECT TOP 50 
                P.ProductId, 
                P.ProductName, 
                P.Description, 
                P.Price, 
                C.CategoryName, 
                P.SellerName, 
                P.ImagePath
            FROM Products P
            INNER JOIN Categories C ON P.CategoryID = C.CategoryID
            WHERE {whereClause}";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@query", "%" + query + "%");
                if (!string.IsNullOrEmpty(category))
                    cmd.Parameters.AddWithValue("@category", category);
                if (!string.IsNullOrEmpty(artisan))
                    cmd.Parameters.AddWithValue("@artisan", "%" + artisan + "%");

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Dictionary<string, object> product = new Dictionary<string, object>();
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        product[reader.GetName(i)] = reader[i];
                    }
                    products.Add(product);
                }
            }

            return products;
        }
    }
}