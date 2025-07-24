using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary
{
    public partial class adminlogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (username == "admin" && password == "admin123")
            {
                Session["Role"] = "Admin";
                Response.Redirect("~/Admin/AdminDashboard.aspx");
            }
            else
            {
                // Optionally show error (e.g., via Label or Bootstrap alert)
                // Example:
                // lblError.Text = "Invalid credentials.";
            }
        }
    }
}