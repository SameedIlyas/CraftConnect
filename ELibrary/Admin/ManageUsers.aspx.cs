using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace ELibrary.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] != "Admin")
            {
                Response.Redirect("~/adminlogin.aspx");
            }
            if (!IsPostBack)
            {
                LoadUsers("All");
            }
        }

        protected void ddlUserType_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadUsers(ddlUserType.SelectedValue);
        }

        private void LoadUsers(string userType)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                StringBuilder query = new StringBuilder("SELECT UserId, UName, Email, Role FROM Users");

                if (userType == "User")
                    query.Append(" WHERE Role = 'User'");
                else if (userType == "Artisan")
                    query.Append(" WHERE Role = 'Artisan'");

                SqlCommand cmd = new SqlCommand(query.ToString(), con);
                SqlDataReader reader = cmd.ExecuteReader();

                StringBuilder html = new StringBuilder();
                while (reader.Read())
                {
                    string userId = reader["UserId"].ToString();
                    string name = reader["UName"].ToString();
                    string email = reader["Email"].ToString();
                    string role = reader["Role"].ToString();

                    html.Append($@"
                        <div class='col-md-4'>
                            <div class='user-card card border-0 shadow-sm' onclick=""location.href='UserDetails.aspx?UserId={userId}'"">
                                <div class='card-body text-center'>
                                    <h5 class='card-title fw-bold'>{name}</h5>
                                    <p class='card-text'>{email}</p>
                                    <span class='badge bg-secondary'>{role}</span>
                                </div>
                            </div>
                        </div>
                    ");
                }

                UsersContainer.InnerHtml = html.ToString();
            }
        }
    }
}
