using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;


namespace ELibrary
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["Cart"] != null)
            {
                DataTable cart = Session["Cart"] as DataTable;
                int itemCount = cart.Rows.Count;

                //if (itemCount > 0)
                //{
                //    ltlCartBadge.Text = $"<span class='position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger'>{itemCount}</span>";
                //}
            }
            if (Session["UserId"] != null)
            {
                CheckNewNotifications();
            }
        }

        private void CheckNewNotifications()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            bool hasNewNotification = false;
            string latestMessage = "";

            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
            SELECT TOP 1 Message 
            FROM Notifications 
            WHERE UserId = @UserId AND IsRead = 0
            ORDER BY CreatedAt DESC", con);
                cmd.Parameters.AddWithValue("@UserId", userId);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    hasNewNotification = true;
                    latestMessage = reader["Message"].ToString();
                }
            }

            if (hasNewNotification)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "showToast", $"showNotification('{latestMessage}');", true);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(searchTerm))
            {
                Response.Redirect("~/SearchResults.aspx?query=" + Server.UrlEncode(searchTerm));
            }
        }




    }
}

