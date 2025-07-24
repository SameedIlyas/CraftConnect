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
    public partial class BestSellers : System.Web.UI.Page
    {
        public DataTable BestSeller { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBestSellers();
            }
        }

        private void LoadBestSellers()
        {
            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT TOP 10 
                        p.ProductId, 
                        p.ProductName, 
                        p.Description, 
                        p.Price, 
                        p.ImagePath, 
                        p.SellerName, 
                        COUNT(od.ProductId) AS OrderCount
                    FROM OrderDetails od
                    INNER JOIN Products p ON od.ProductId = p.ProductId
                    GROUP BY p.ProductId, p.ProductName, p.Description, p.Price, p.ImagePath, p.SellerName
                    ORDER BY COUNT(od.ProductId) DESC";

                using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    BestSeller = dt;
                }
            }
        }
    }
}
