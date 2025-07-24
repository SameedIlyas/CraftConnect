using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace ELibrary
{
    public partial class WorkshopDetails : System.Web.UI.Page
    {
        string connStr = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=CraftConnect_Database;Integrated Security=True";
        int workshopId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out workshopId))
            {
                pnlError.Visible = true;
                lblError.Text = "Invalid workshop ID.";
                return;
            }

            if (!IsPostBack)
            {
                LoadWorkshopDetails();
            }
        }

        private void LoadWorkshopDetails()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT w.*, 
                   (SELECT COUNT(*) FROM WorkshopRegistration WHERE WorkshopId = w.Id) AS CurrentOccupancy 
            FROM Workshops w 
            WHERE w.Id = @Id", con);
                cmd.Parameters.AddWithValue("@Id", workshopId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                bool hasData = reader.Read();
                if (!hasData)
                {
                    pnlError.Visible = true;
                    lblError.Text = "Workshop not found.";
                    return;
                }

                // Read workshop data from reader and store in local variables
                string title = reader["Title"].ToString();
                string description = reader["Description"].ToString();
                string category = reader["Category"].ToString();
                DateTime date = Convert.ToDateTime(reader["Date"]);
                string time = reader["Time"].ToString();
                bool isOnline = Convert.ToBoolean(reader["IsOnline"]);
                string fee = reader["Fee"].ToString();
                int max = Convert.ToInt32(reader["MaxParticipants"]);
                int current = Convert.ToInt32(reader["CurrentOccupancy"]);
                string location = reader["Location"].ToString();
                string link = reader["OnlineLink"] == DBNull.Value ? "" : reader["OnlineLink"].ToString();

                reader.Close();

                // Now safely set UI controls
                pnlDetails.Visible = true;
                lblTitle.Text = title;
                lblDescription.Text = description;
                lblCategory.Text = category;
                lblDate.Text = date.ToString("MMM dd, yyyy");
                lblTime.Text = time;
                lblMode.Text = isOnline ? "Online" : "Onsite";
                spanMode.Attributes["class"] += isOnline ? " badge-online" : " badge-offline";
                lblFee.Text = fee;
                lblMaxOccupancy.Text = max.ToString();
                lblCurrentOccupancy.Text = current.ToString();

                // Enroll logic
                if (Session["UserId"] == null)
                {
                    pnlEnroll.Visible = false;
                }
                else
                {
                    int userId = Convert.ToInt32(Session["UserId"]);

                    using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM WorkshopRegistration WHERE WorkshopId = @WorkshopId AND UserId = @UserId", con))
                    {
                        checkCmd.Parameters.AddWithValue("@WorkshopId", workshopId);
                        checkCmd.Parameters.AddWithValue("@UserId", userId);

                        int enrolled = (int)checkCmd.ExecuteScalar();

                        if (enrolled > 0)
                        {
                            pnlEnroll.Visible = false;

                            if (isOnline)
                            {
                                pnlOnlineLink.Visible = true;
                                lnkWorkshop.Text = link;
                                lnkWorkshop.NavigateUrl = link;
                            }
                            else
                            {
                                pnlLocation.Visible = true;
                                lblLocation.Text = location;
                            }
                        }
                        else
                        {
                            pnlEnroll.Visible = true;

                            if (current >= max)
                            {
                                btnEnroll.Enabled = false;
                                lblEnrollStatus.Text = "Max number of participants already enrolled.";
                            }
                        }
                    }
                }
            }
        }


        protected void btnEnroll_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/SignIn.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);
            int workshopId = Convert.ToInt32(Request.QueryString["id"]);
            // Redirect user to the payment page with workshop ID
            Response.Redirect($"~/WorkshopPayment.aspx?id={workshopId}");

        }
    }
}
