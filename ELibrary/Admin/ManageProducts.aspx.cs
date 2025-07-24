using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ELibrary.Admin
{
    public partial class ManageProducts : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] != "Admin")
            {
                Response.Redirect("~/adminlogin.aspx");
            }
            if (!IsPostBack)
            {
                LoadProducts();
            }
        }

        private void LoadProducts()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT p.ProductId, p.ProductName, p.Description, p.Price, p.ImagePath, p.SellerName
                    FROM Products p";

                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptProducts.DataSource = dt;
                    rptProducts.DataBind();
                    pnlNoProducts.Visible = false;
                }
                else
                {
                    rptProducts.DataSource = null;
                    rptProducts.DataBind();
                    pnlNoProducts.Visible = true;
                }
            }
        }
    }
}
