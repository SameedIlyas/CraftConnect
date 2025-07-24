using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace ELibrary
{
    public partial class ShoppingCart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadCart();
        }

        private void LoadCart()
        {
            // Simulate cart loading from Session or DB
            DataTable cart = Session["Cart"] as DataTable;

            if (cart == null || cart.Rows.Count == 0)
            {
                pnlCart.Visible = false;
                pnlEmpty.Visible = true;
                return;
            }

            rptCart.DataSource = cart;
            rptCart.DataBind();

            decimal total = cart.AsEnumerable().Sum(row => Convert.ToDecimal(row["Price"]) * Convert.ToInt32(row["Quantity"]));
            lblTotal.Text = total.ToString("N0");
            pnlCart.Visible = true;
            pnlEmpty.Visible = false;
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            DataTable cart = Session["Cart"] as DataTable;
            string productId = e.CommandArgument.ToString();

            if (e.CommandName == "Update")
            {
                TextBox txtQty = (TextBox)e.Item.FindControl("txtQuantity");
                int newQty = int.TryParse(txtQty.Text, out int result) ? result : 1;

                foreach (DataRow row in cart.Rows)
                {
                    if (row["ProductID"].ToString() == productId)
                    {
                        row["Quantity"] = newQty;
                        break;
                    }
                }
            }
            else if (e.CommandName == "Remove")
            {
                DataRow row = cart.AsEnumerable().FirstOrDefault(r => r["ProductID"].ToString() == productId);
                if (row != null) cart.Rows.Remove(row);
            }

            Session["Cart"] = cart;
            LoadCart(); // Rebind with AJAX
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            Response.Redirect("Checkout.aspx");
        }
    }
}
