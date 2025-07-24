using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary
{
    public partial class UserHome : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] != null)
            {
                lblSuccess.Text="Login  Successful  Welcome" +" "+ Session["Username"].ToString();
            }
            else
            {
                Response.Redirect("~/SignIn.aspx");
            }
        }
        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            // Clear all session data
            Session.Clear();
            Session.Abandon();

            // Expire any cookies if needed
            if (Request.Cookies["USERNAME"] != null)
            {
                Response.Cookies["USERNAME"].Expires = DateTime.Now.AddDays(-1);
            }
            if (Request.Cookies["PASSWORD"] != null)
            {
                Response.Cookies["PASSWORD"].Expires = DateTime.Now.AddDays(-1);
            }

            // Redirect to homepage
            Response.Redirect("~/homepage.aspx");
        }
    }
}