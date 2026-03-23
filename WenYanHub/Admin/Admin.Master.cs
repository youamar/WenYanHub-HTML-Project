using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using WenYanHub.Models;
using System.Collections.Generic;

namespace WenYanHub.Admin
{
    public partial class Admin : System.Web.UI.MasterPage
    {
        public class NotifItem
        {
            public string Id { get; set; }
            public string Title { get; set; }
            public string Message { get; set; }
            public string Type { get; set; }
            public DateTime CreatedAt { get; set; }
            public string DateString { get; set; }
            public string ActionLink { get; set; }
            public bool IsRead { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["DismissedNotifs"] == null) Session["DismissedNotifs"] = new List<string>();
            if (Session["ReadNotifs"] == null) Session["ReadNotifs"] = new List<string>();

            // 🔥 STRICT LOGIN ENFORCEMENT
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Session["ProfilePic"] != null && !string.IsNullOrEmpty(Session["ProfilePic"].ToString()))
                    imgProfileTop.ImageUrl = Session["ProfilePic"].ToString();
                else
                    imgProfileTop.ImageUrl = $"https://ui-avatars.com/api/?name={Session["Username"] ?? "Admin"}&background=D4AF37&color=fff&bold=true";

                BindNotifications();
            }
        }

        private void BindNotifications()
        {
            string activeFilter = ViewState["NotifFilter"]?.ToString() ?? "Content";
            bool unreadOnly = chkUnreadOnly.Checked;
            bool thisWeek = chkThisWeek.Checked;

            var dismissed = (List<string>)Session["DismissedNotifs"];
            var read = (List<string>)Session["ReadNotifs"];

            var notiList = new List<NotifItem>();

            using (var db = new AppDbContext())
            {
                if (activeFilter == "Content")
                {
                    // 1. VIDEOS
                    var pendingVideos = db.VideoRecords
                        .Where(v => v.Approved == "Pending" || v.Approved == null || v.Approved == "")
                        .OrderByDescending(v => v.CreatedAt)
                        .ToList();

                    foreach (var v in pendingVideos)
                    {
                        string nid = "VID_" + v.RecordId;
                        if (dismissed.Contains(nid)) continue;

                        string cTitle = db.Contents.FirstOrDefault(c => c.ContentId == v.ContentId)?.Title ?? "Lesson Video";
                        string sName = db.Users.FirstOrDefault(u => u.UserId == v.TeacherId)?.Username ?? "Teacher";

                        notiList.Add(new NotifItem
                        {
                            Id = nid,
                            Title = "Pending Video",
                            Message = $"{sName} submitted a video for: {cTitle}",
                            CreatedAt = v.CreatedAt,
                            DateString = v.CreatedAt.ToString("MMM dd, HH:mm"),
                            ActionLink = "ContentControl.aspx",
                            Type = "Content",
                            IsRead = read.Contains(nid)
                        });
                    }

                    // 2. CONTENTS (LESSONS)
                    try
                    {
                        var pendingContent = db.Contents.Where(c => c.Approved == "Pending").ToList();
                        foreach (var c in pendingContent)
                        {
                            string nid = "CON_" + c.ContentId;
                            if (dismissed.Contains(nid)) continue;

                            notiList.Add(new NotifItem
                            {
                                Id = nid,
                                Title = "Pending Content",
                                Message = $"Library item requires review: {c.Title}",
                                CreatedAt = c.CreatedAt,
                                DateString = c.CreatedAt.ToString("MMM dd, HH:mm"),
                                ActionLink = "ManageContent.aspx?view=pending",
                                Type = "Content",
                                IsRead = read.Contains(nid)
                            });
                        }
                    }
                    catch { }

                    // 3. NOTES
                    try
                    {
                        var pendingNotes = db.Set<Note>().Where(n => n.Approved == "Pending").ToList();
                        foreach (var n in pendingNotes)
                        {
                            string nid = "NOT_" + n.NoteId;
                            if (dismissed.Contains(nid)) continue;

                            notiList.Add(new NotifItem
                            {
                                Id = nid,
                                Title = "Pending Note",
                                Message = $"A user note requires your review.",
                                CreatedAt = n.CreatedAt,
                                DateString = n.CreatedAt.ToString("MMM dd, HH:mm"),
                                ActionLink = "ManageContent.aspx?view=pending",
                                Type = "Content",
                                IsRead = read.Contains(nid)
                            });
                        }
                    }
                    catch { }

                    // 4. PRACTICES
                    try
                    {
                        var pendingPractices = db.Practices.Where(p => p.Approved == "Pending" || p.Approved == null || p.Approved == "").ToList();
                        foreach (var p in pendingPractices)
                        {
                            string nid = "PRA_" + p.PracticeId;
                            if (dismissed.Contains(nid)) continue;

                            string tName = db.Users.FirstOrDefault(u => u.UserId == p.TeacherId)?.Username ?? "Teacher";
                            string pTitle = string.IsNullOrEmpty(p.Title) ? "Untitled Practice" : p.Title;

                            notiList.Add(new NotifItem
                            {
                                Id = nid,
                                Title = "Pending Practice",
                                Message = $"{tName} submitted a practice: {pTitle}",
                                CreatedAt = p.CreatedAt,
                                DateString = p.CreatedAt.ToString("MMM dd, HH:mm"),
                                ActionLink = "ManageContent.aspx?view=pending",
                                Type = "Content",
                                IsRead = read.Contains(nid)
                            });
                        }
                    }
                    catch { }

                    btnFilterContent.CssClass = "btn font-classic flex-grow-1 btn-toggle-hollow active";
                    btnFilterTickets.CssClass = "btn font-classic flex-grow-1 btn-toggle-hollow";
                }
                else
                {
                    // TICKETS
                    var pendingTickets = db.Feedbacks.Where(f => f.Status == "Pending" || f.Status == "Open").ToList();

                    foreach (var t in pendingTickets)
                    {
                        string nid = "TKT_" + t.TrackingCode;
                        if (dismissed.Contains(nid)) continue;

                        notiList.Add(new NotifItem
                        {
                            Id = nid,
                            Title = "Support Ticket",
                            Message = "Ticket #" + t.TrackingCode + " needs attention.",
                            CreatedAt = t.CreatedAt,
                            DateString = t.CreatedAt.ToString("MMM dd, HH:mm"),
                            ActionLink = "ViewTickets.aspx?view=pending",
                            Type = "Ticket",
                            IsRead = read.Contains(nid)
                        });
                    }

                    btnFilterTickets.CssClass = "btn font-classic flex-grow-1 btn-toggle-hollow active";
                    btnFilterContent.CssClass = "btn font-classic flex-grow-1 btn-toggle-hollow";
                }
            }

            if (unreadOnly) notiList = notiList.Where(n => !n.IsRead).ToList();
            if (thisWeek)
            {
                DateTime startOfWeek = DateTime.Today.AddDays(-(int)DateTime.Today.DayOfWeek);
                notiList = notiList.Where(n => n.CreatedAt >= startOfWeek).ToList();
            }

            var sortedList = notiList.OrderBy(n => n.IsRead).ThenByDescending(n => n.CreatedAt).ToList();

            rptAdminNotis.DataSource = sortedList;
            rptAdminNotis.DataBind();

            phEmptyNotif.Visible = !sortedList.Any();

            // 🔥 UPDATED BADGE COUNT LOGIC HERE 🔥
            int unreadCount = sortedList.Count(n => !n.IsRead);

            if (unreadCount > 0)
            {
                bell.Attributes["class"] = "bell-icon hover-lift has-notif";
                lblNotifCount.Text = unreadCount > 99 ? "99+" : unreadCount.ToString();
            }
            else
            {
                bell.Attributes["class"] = "bell-icon hover-lift";
                lblNotifCount.Text = "";
            }

            ViewState["VisibleNotifIds"] = string.Join(",", sortedList.Select(n => n.Id));
        }

        protected void FilterNotifs_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            ViewState["NotifFilter"] = btn.CommandArgument;
            BindNotifications();
        }

        protected void FilterUpdate_Changed(object sender, EventArgs e)
        {
            BindNotifications();
        }

        protected void btnClearAll_Click(object sender, EventArgs e)
        {
            var dismissed = (List<string>)Session["DismissedNotifs"];
            string visibleIds = ViewState["VisibleNotifIds"]?.ToString();

            if (!string.IsNullOrEmpty(visibleIds))
            {
                foreach (string id in visibleIds.Split(','))
                {
                    if (!dismissed.Contains(id)) dismissed.Add(id);
                }
            }
            BindNotifications();
        }

        protected void btnLogOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Session.RemoveAll();

            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }

            Response.Redirect("~/Account/Login.aspx");
        }

        protected void rptAdminNotis_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string argument = e.CommandArgument.ToString();

            if (e.CommandName == "Clear")
            {
                var dismissed = (List<string>)Session["DismissedNotifs"];
                if (!dismissed.Contains(argument)) dismissed.Add(argument);
                BindNotifications();
            }
            else if (e.CommandName == "Redirect")
            {
                string[] args = argument.Split('|');
                string realId = args[0];
                string url = args.Length > 1 ? args[1] : "AdminDashboard.aspx";

                var read = (List<string>)Session["ReadNotifs"];
                if (!read.Contains(realId)) read.Add(realId);

                Response.Redirect(url);
            }
        }
    }
}