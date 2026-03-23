using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using WenYanHub.Models;

namespace WenYanHub
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadNotifications();
            }
        }

        private void LoadNotifications()
        {
            if (Session["UserId"] != null)
            {
                int userId = (int)Session["UserId"];
                string userRole = Session["Role"] as string ?? "Member";

                using (var db = new AppDbContext())
                {
                    var allNotifs = db.Notifications
                        .Where(n => (n.UserId == userId || n.TargetRole == userRole || n.TargetRole == "All"))
                        .OrderByDescending(n => n.CreatedAt)
                        .Take(10)
                        .ToList();

                    int unreadCount = allNotifs.Count(n => !n.IsRead);

                    if (allNotifs.Any())
                    {
                        rptNotifs.DataSource = allNotifs;
                        rptNotifs.DataBind();

                        if (unreadCount > 0)
                        {
                            lblNotifBadge.Text = unreadCount.ToString();
                            lblNotifBadge.Visible = true;
                        }
                        else
                        {
                            lblNotifBadge.Visible = false;
                        }
                        pnlNoNotif.Visible = false;
                    }
                    else
                    {
                        pnlNoNotif.Visible = true;
                        lblNotifBadge.Visible = false;
                    }
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Others/Default.aspx");
        }
    }
}