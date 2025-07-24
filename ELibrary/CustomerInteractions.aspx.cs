using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary
{
    public partial class CustomerInteractions : System.Web.UI.Page
    {
        string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null || (string)Session["Role"] != "Artisan")
                {
                    Response.Redirect("~/SignIn.aspx");
                    return;
                }

                LoadProductsDropdown();
                LoadAverageRatings();
                LoadCustomerInteractions();
            }
        }

        private void LoadProductsDropdown()
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT ProductID, ProductName FROM Products WHERE ArtisanId = @ArtisanId", con);
                cmd.Parameters.AddWithValue("@ArtisanId", artisanId);
                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                ddlProducts.DataSource = reader;
                ddlProducts.DataTextField = "ProductName";
                ddlProducts.DataValueField = "ProductID";
                ddlProducts.DataBind();
                ddlProducts.Items.Insert(0, new ListItem("-- All Products --", "0"));
            }
        }

        private void LoadAverageRatings()
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT 
                p.ProductName AS ProductName,
                ISNULL(AVG(CAST(pf.Rating AS FLOAT)), 0) AS AverageRating
            FROM Products p
            LEFT JOIN ProductFeedback pf ON pf.ProductId = p.ProductID
            WHERE p.ArtisanId = @ArtisanId
            GROUP BY p.ProductName
            ORDER BY p.ProductName", con);

                cmd.Parameters.AddWithValue("@ArtisanId", artisanId);

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                System.Data.DataTable dt = new System.Data.DataTable();
                adapter.Fill(dt);

                rptAvgRatings.DataSource = dt;
                rptAvgRatings.DataBind();
            }
        }

        private void LoadCustomerInteractions()
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);
            int selectedProductId = Convert.ToInt32(ddlProducts.SelectedValue);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            SELECT 
                pf.Id,
                pf.Comment,
                pf.Rating,
                pf.Response,
                pf.SubmittedAt,
                p.ProductName AS ProductName,
                u.UName AS UserName
            FROM ProductFeedback pf
            INNER JOIN Products p ON pf.ProductId = p.ProductID
            INNER JOIN Users u ON pf.UserId = u.UserId
            WHERE p.ArtisanId = @ArtisanId";

                if (selectedProductId != 0)
                    query += " AND p.ProductID = @ProductID";

                query += " ORDER BY pf.SubmittedAt DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ArtisanId", artisanId);
                if (selectedProductId != 0)
                    cmd.Parameters.AddWithValue("@ProductID", selectedProductId);

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                System.Data.DataTable dt = new System.Data.DataTable();
                adapter.Fill(dt);

                rptProductFeedback.DataSource = dt;
                rptProductFeedback.DataBind();
                pnlNoFeedback.Visible = dt.Rows.Count == 0;
            }
        }



        protected void rptProductFeedback_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Respond")
            {
                int feedbackId = Convert.ToInt32(e.CommandArgument);
                TextBox txtResponse = (TextBox)e.Item.FindControl("txtResponse");

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE ProductFeedback SET Response = @Response WHERE Id = @Id", con);
                    cmd.Parameters.AddWithValue("@Response", txtResponse.Text.Trim());
                    cmd.Parameters.AddWithValue("@Id", feedbackId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "Response submitted.";
                pnlMessage.Visible = true;
                LoadCustomerInteractions();
            }
        }

        protected void ddlProducts_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCustomerInteractions();
        }


    }
}