using System;
using System.Web;

namespace ELibrary
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Clear session
            Session.Clear();
            Session.Abandon();

            // Clear authentication cookie if used
            if (Request.Cookies[".ASPXAUTH"] != null)
            {
                HttpCookie authCookie = new HttpCookie(".ASPXAUTH");
                authCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(authCookie);
            }

            // Clear any other cookies
            foreach (string cookie in Request.Cookies.AllKeys)
            {
                HttpCookie expiredCookie = new HttpCookie(cookie);
                expiredCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(expiredCookie);
            }

            // Redirect to homepage
            Response.Redirect("homepage.aspx");
        }
    }
}
