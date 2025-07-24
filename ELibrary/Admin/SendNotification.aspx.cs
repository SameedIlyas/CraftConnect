using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ELibrary.Admin
{
    public partial class SendNotifications : System.Web.UI.Page
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
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT UserId, UName FROM Users ORDER BY UName";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                ddlUsers.Items.Clear();
                ddlUsers.Items.Add(new ListItem("-- Select User or All --", ""));
                ddlUsers.Items.Add(new ListItem("All", "All"));

                while (reader.Read())
                {
                    ddlUsers.Items.Add(new ListItem(reader["UName"].ToString(), reader["UserId"].ToString()));
                }
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            string selectedUser = ddlUsers.SelectedValue;
            string message = txtMessage.Text.Trim();

            if (string.IsNullOrEmpty(selectedUser) || string.IsNullOrEmpty(message))
            {
                lblResult.CssClass = "text-danger";
                lblResult.Text = "Please select a user and enter a message.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                if (selectedUser == "All")
                {
                    string getUsersQuery = "SELECT UserId FROM Users";
                    SqlCommand getUsersCmd = new SqlCommand(getUsersQuery, con);
                    SqlDataReader reader = getUsersCmd.ExecuteReader();

                    var userIds = new System.Collections.Generic.List<int>();
                    while (reader.Read())
                    {
                        userIds.Add(Convert.ToInt32(reader["UserId"]));
                    }
                    reader.Close();

                    foreach (int id in userIds)
                    {
                        InsertNotification(con, id, message);
                    }
                }
                else
                {
                    InsertNotification(con, Convert.ToInt32(selectedUser), message);
                }

                lblResult.CssClass = "text-success";
                lblResult.Text = "Notification sent successfully!";
                txtMessage.Text = "";
                ddlUsers.SelectedIndex = 0;
            }
        }

        private void InsertNotification(SqlConnection con, int userId, string message)
        {
            string insertQuery = @"INSERT INTO Notifications (UserId, Message, IsRead, CreatedAt)
                                   VALUES (@UserId, @Message, 0, GETDATE())";
            SqlCommand cmd = new SqlCommand(insertQuery, con);
            cmd.Parameters.AddWithValue("@UserId", userId);
            cmd.Parameters.AddWithValue("@Message", message);
            cmd.ExecuteNonQuery();
        }
    }
}
