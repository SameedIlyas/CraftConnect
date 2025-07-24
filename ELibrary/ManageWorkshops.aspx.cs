using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ELibrary
{
    public partial class ManageWorkshops : System.Web.UI.Page
    {
        string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";
        private string currentStatusFilter;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                if (Session["UserId"] == null || (string)Session["Role"] != "Artisan")
                {
                    Response.Redirect("~/SignIn.aspx");
                }
                currentStatusFilter = "Upcoming";
                hfCurrentStatus.Value = currentStatusFilter;
                LoadWorkshops();
            }
            else
            {
                currentStatusFilter = hfCurrentStatus.Value;
            }
        }

        protected void rptWorkshops_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == System.Web.UI.WebControls.ListItemType.Item ||
                e.Item.ItemType == System.Web.UI.WebControls.ListItemType.AlternatingItem)
            {
                var pnlActions = (System.Web.UI.WebControls.Panel)e.Item.FindControl("pnlActions");
                pnlActions.Visible = hfCurrentStatus.Value == "Upcoming";
            }
        }


        protected void btnCreate_Click(object sender, EventArgs e)
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Workshops 
                    (ArtisanId, Title, Description, Category, Date, Time, DurationInHours, IsOnline, OnlineLink, Location, MaxPArticipants, Fee, Status, CreatedAt, UpdatedAt)
                    VALUES
                    (@ArtisanId, @Title, @Description, @Category, @Date, @Time, @Duration, @IsOnline, @OnlineLink, @Location, @Max, @Fee, 'Upcoming', GETDATE(), GETDATE())
                ", con);

                cmd.Parameters.AddWithValue("@ArtisanId", artisanId);
                cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@Date", DateTime.Parse(txtDate.Text));
                cmd.Parameters.AddWithValue("@Time", txtTime.Text);
                cmd.Parameters.AddWithValue("@Duration", int.Parse(txtDuration.Text));
                cmd.Parameters.AddWithValue("@IsOnline", chkIsOnline.Checked);
                cmd.Parameters.AddWithValue("@OnlineLink", chkIsOnline.Checked ? txtLocation.Text.Trim() : "");
                cmd.Parameters.AddWithValue("@Location", chkIsOnline.Checked ? "" : txtLocation.Text.Trim());
                cmd.Parameters.AddWithValue("@Max", int.Parse(txtMaxParticipants.Text));
                cmd.Parameters.AddWithValue("@Fee", decimal.Parse(txtFee.Text));

                con.Open();
                cmd.ExecuteNonQuery();
                lblMessage.Text = "Workshop created successfully.";
                pnlMessage.Visible = true;
            }

            ClearForm();
            LoadWorkshops();
        }

        private void ClearForm()
        {
            txtTitle.Text = txtDescription.Text = txtDuration.Text = txtFee.Text =
            txtLocation.Text = txtMaxParticipants.Text = "";
            ddlCategory.SelectedIndex = 0;
            chkIsOnline.Checked = false;
        }

        protected void btnShowUpcoming_Click(object sender, EventArgs e)
        {
            currentStatusFilter = "Upcoming";
            hfCurrentStatus.Value = currentStatusFilter;
            LoadWorkshops();
        }
        protected void btnShowCompleted_Click(object sender, EventArgs e)
        {
            currentStatusFilter = "Completed";
            hfCurrentStatus.Value = currentStatusFilter;
            LoadWorkshops();
        }

        protected void btnShowCancelled_Click(object sender, EventArgs e)
        {
            currentStatusFilter = "Cancelled";
            hfCurrentStatus.Value = currentStatusFilter;
            LoadWorkshops();
        }


        private void LoadWorkshops(string statusFilter = "Upcoming")
        {
            int artisanId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Workshops WHERE ArtisanId = @ArtisanId AND Status = @Status", con);
                cmd.Parameters.AddWithValue("@ArtisanId", artisanId);
                cmd.Parameters.AddWithValue("@Status", statusFilter);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptWorkshops.DataSource = dt;
                rptWorkshops.DataBind();
            }
        }

        protected void chkIsOnline_CheckedChanged(object sender, EventArgs e)
        {
            txtLocation.Attributes["placeholder"] = chkIsOnline.Checked ? "Enter Online Link" : "Enter Physical Location";
        }

        protected void rptWorkshops_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int workshopId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Cancel")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Workshops SET Status = 'Cancelled', UpdatedAt = GETDATE() WHERE Id = @Id", con);
                    cmd.Parameters.AddWithValue("@Id", workshopId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                    NotifyWorkshopParticipants(workshopId, "cancel");
                }

                lblMessage.Text = "Workshop cancelled successfully.";
                pnlMessage.Visible = true;
                LoadWorkshops();
            }
            else if (e.CommandName == "Edit")
            {
                LoadWorkshopForEdit(workshopId);
            }
            else if (e.CommandName == "Complete")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT Date, Time FROM Workshops WHERE Id = @Id", con);
                    cmd.Parameters.AddWithValue("@Id", workshopId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        DateTime date = Convert.ToDateTime(reader["Date"]);
                        TimeSpan time = TimeSpan.Parse(reader["Time"].ToString());
                        DateTime scheduledDateTime = date.Date + time;

                        if (DateTime.Now >= scheduledDateTime)
                        {
                            reader.Close();
                            SqlCommand updateCmd = new SqlCommand("UPDATE Workshops SET Status = 'Completed', UpdatedAt = GETDATE() WHERE Id = @Id", con);
                            updateCmd.Parameters.AddWithValue("@Id", workshopId);
                            updateCmd.ExecuteNonQuery();

                            lblMessage.Text = "Workshop marked as completed.";
                        }
                        else
                        {
                            lblMessage.Text = "Cannot complete. The workshop is scheduled in the future.";
                        }
                    }
                    else
                    {
                        lblMessage.Text = "Workshop not found.";
                    }

                    pnlMessage.Visible = true;
                    reader.Close();
                }

                LoadWorkshops();
            }
        }
        private void LoadWorkshopForEdit(int id)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Workshops WHERE Id = @Id", con);
                cmd.Parameters.AddWithValue("@Id", id);
                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    hfWorkshopId.Value = id.ToString();
                    txtTitle.Text = reader["Title"].ToString();
                    ddlCategory.SelectedValue = reader["Category"].ToString();
                    txtDate.Text = Convert.ToDateTime(reader["Date"]).ToString("yyyy-MM-dd");
                    txtTime.Text = reader["Time"].ToString();
                    txtDuration.Text = reader["DurationInHours"].ToString();
                    txtFee.Text = reader["Fee"].ToString();
                    txtMaxParticipants.Text = reader["MaxPArticipants"].ToString();

                    // Set checkbox and location field
                    chkIsOnline.Checked = (bool)reader["IsOnline"];
                    txtLocation.Text = chkIsOnline.Checked ? reader["OnlineLink"].ToString() : reader["Location"].ToString();
                    txtDescription.Text = reader["Description"].ToString();

                    // Trigger placeholder change
                    chkIsOnline_CheckedChanged(null, null);

                    btnCreate.Visible = false;
                    btnUpdate.Visible = true;
                }
                reader.Close();
            }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int id = int.Parse(hfWorkshopId.Value);
            int artisanId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            UPDATE Workshops SET 
                Title = @Title,
                Description = @Description,
                Category = @Category,
                Date = @Date,
                Time = @Time,
                DurationInHours = @Duration,
                IsOnline = @IsOnline,
                OnlineLink = @OnlineLink,
                Location = @Location,
                MaxPArticipants = @Max,
                Fee = @Fee,
                UpdatedAt = GETDATE()
            WHERE Id = @Id AND ArtisanId = @ArtisanId", con);

                cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@Date", DateTime.Parse(txtDate.Text));
                cmd.Parameters.AddWithValue("@Time", txtTime.Text);
                cmd.Parameters.AddWithValue("@Duration", int.Parse(txtDuration.Text));
                cmd.Parameters.AddWithValue("@IsOnline", chkIsOnline.Checked);
                cmd.Parameters.AddWithValue("@OnlineLink", chkIsOnline.Checked ? txtLocation.Text.Trim() : "");
                cmd.Parameters.AddWithValue("@Location", chkIsOnline.Checked ? "" : txtLocation.Text.Trim());
                cmd.Parameters.AddWithValue("@Max", int.Parse(txtMaxParticipants.Text));
                cmd.Parameters.AddWithValue("@Fee", decimal.Parse(txtFee.Text));
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.Parameters.AddWithValue("@ArtisanId", artisanId);

                con.Open();
                cmd.ExecuteNonQuery();
                NotifyWorkshopParticipants(id, "update");
            }

            lblMessage.Text = "Workshop updated successfully.";
            pnlMessage.Visible = true;

            ClearForm();
            btnUpdate.Visible = false;
            btnCreate.Visible = true;
            LoadWorkshops();
        }
        private void NotifyWorkshopParticipants(int workshopId, string action)
        {
            string message = "";
            string title = "";
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Get basic workshop info
                SqlCommand getWorkshopCmd = new SqlCommand("SELECT Title FROM Workshops WHERE Id = @Id", con);
                getWorkshopCmd.Parameters.AddWithValue("@Id", workshopId);
                string workshopTitle = (string)getWorkshopCmd.ExecuteScalar();

                if (action == "update")
                    message = $"The workshop '{workshopTitle}' has been updated.";
                else if (action == "cancel")
                    message = $"The workshop '{workshopTitle}' has been cancelled.";

                // Get all user IDs who are enrolled
                SqlCommand getUsersCmd = new SqlCommand("SELECT UserId FROM WorkshopRegistration WHERE WorkshopId = @WorkshopId", con);
                getUsersCmd.Parameters.AddWithValue("@WorkshopId", workshopId);

                SqlDataReader reader = getUsersCmd.ExecuteReader();
                List<int> userIds = new List<int>();
                while (reader.Read())
                {
                    userIds.Add(Convert.ToInt32(reader["UserId"]));
                }
                reader.Close();

                // Insert notification for each user
                foreach (int userId in userIds)
                {
                    SqlCommand insertCmd = new SqlCommand("INSERT INTO Notifications (UserId, Message, CreatedAt) VALUES (@UserId, @Message, GETDATE())", con);
                    insertCmd.Parameters.AddWithValue("@UserId", userId);
                    insertCmd.Parameters.AddWithValue("@Message", message);
                    insertCmd.ExecuteNonQuery();
                }
            }
        }


    }
}
