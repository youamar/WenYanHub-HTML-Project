using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using WenYanHub.Models;
using WenYanHub.Admin.Utils;

namespace WenYanHub.Admin
{
    public partial class ContentControl : System.Web.UI.Page
    {
        private const int PageSize = 10;

        private int VideoPage { get { return ViewState["VideoPage"] != null ? (int)ViewState["VideoPage"] : 0; } set { ViewState["VideoPage"] = value; } }
        private int ZoomPage { get { return ViewState["ZoomPage"] != null ? (int)ViewState["ZoomPage"] : 0; } set { ViewState["ZoomPage"] = value; } }
        private int CommentPage { get { return ViewState["CommentPage"] != null ? (int)ViewState["CommentPage"] : 0; } set { ViewState["CommentPage"] = value; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindTeacherDropdown();
                BindPendingVideos();
                BindScheduledZooms();
                BindComments();
            }
        }

        // ======================= VIDEO =======================
        protected void btnSearchVideos_Click(object sender, EventArgs e)
        {
            hfActiveTab.Value = "video";
            VideoPage = 0;
            BindPendingVideos();
        }

        private void BindPendingVideos()
        {
            using (var db = new AppDbContext())
            {
                var query = db.VideoRecords.AsQueryable();

                string vStatus = ddlVideoStatus.SelectedValue;
                if (vStatus == "Pending")
                    query = query.Where(v => string.IsNullOrEmpty(v.Approved) || v.Approved == "Pending");
                else if (vStatus != "All")
                    query = query.Where(v => v.Approved == vStatus);

                int totalRecords = query.Count();
                int totalPages = (totalRecords + PageSize - 1) / PageSize;
                if (totalPages == 0) totalPages = 1;

                if (VideoPage >= totalPages) VideoPage = totalPages - 1;
                if (VideoPage < 0) VideoPage = 0;

                var rawList = query.OrderByDescending(v => v.CreatedAt)
                                   .Skip(VideoPage * PageSize)
                                   .Take(PageSize)
                                   .ToList();

                var list = rawList.Select(v => {
                    string cTitle = db.Contents.FirstOrDefault(c => c.ContentId == v.ContentId)?.Title ?? "Lesson Video";

                    // 🔥 THE FIX: Removed .HasValue and .Value since TeacherId is a standard int
                    string sName = db.Users.FirstOrDefault(u => u.UserId == v.TeacherId)?.Username ?? "Unknown Teacher";

                    string currentStatus = string.IsNullOrEmpty(v.Approved) ? "Pending" : v.Approved;

                    string badgeClass = "bg-theme-primary text-theme-accent";
                    if (currentStatus == "Approved" || currentStatus == "Published")
                    {
                        currentStatus = "Approved";
                        badgeClass = "bg-theme-accent text-theme-primary";
                    }
                    else if (currentStatus == "Hidden")
                        badgeClass = "bg-semantic-danger text-white";

                    return new
                    {
                        RecordId = v.RecordId,
                        RecordLink = v.RecordLink,
                        Topic = cTitle,
                        ContentTitle = cTitle,
                        CreatedAt = v.CreatedAt,
                        // 🔥 THE FIX: Removed ?? DateTime.Now since CreatedAt is a standard DateTime
                        DateString = v.CreatedAt.ToString("MMM dd, yyyy"),
                        StudentName = sName, // Keeping StudentName for the HTML binding
                        Status = currentStatus,
                        BadgeClass = badgeClass
                    };
                }).ToList();

                rptVideos.DataSource = list;
                rptVideos.DataBind();

                phNoVideos.Visible = !list.Any();
                if (pnlVideoPagination != null) pnlVideoPagination.Visible = totalRecords > PageSize;

                litVideoPage.Text = (VideoPage + 1).ToString();
                litVideoTotal.Text = totalPages.ToString();

                btnVideoPrev.Visible = VideoPage > 0;
                btnVideoNext.Visible = VideoPage < (totalPages - 1);
            }
        }
        protected void btnVideoPrev_Click(object sender, EventArgs e) { VideoPage--; BindPendingVideos(); }
        protected void btnVideoNext_Click(object sender, EventArgs e) { VideoPage++; BindPendingVideos(); }

        // ======================= ZOOM =======================
        private void BindScheduledZooms()
        {
            using (var db = new AppDbContext())
            {
                DateTime cutoff = DateTime.Now.AddDays(-1);
                var query = db.ZoomSessions.Where(z => z.StartTime >= cutoff).AsQueryable();

                int totalRecords = query.Count();
                int totalPages = (totalRecords + PageSize - 1) / PageSize;
                if (totalPages == 0) totalPages = 1;

                if (ZoomPage >= totalPages) ZoomPage = totalPages - 1;
                if (ZoomPage < 0) ZoomPage = 0;

                var rawList = query.OrderBy(z => z.StartTime)
                                   .Skip(ZoomPage * PageSize)
                                   .Take(PageSize)
                                   .ToList();

                var list = rawList.Select(z => {
                    string tName = db.Users.FirstOrDefault(u => u.UserId == z.TeacherId)?.Username ?? "Unknown Teacher";
                    return new
                    {
                        z.ZoomSessionId,
                        z.Title,
                        StartTime = z.StartTime,
                        ScheduledDate = z.StartTime.ToString("MMM dd, HH:mm"),
                        TeacherName = tName
                    };
                }).ToList();

                rptZoom.DataSource = list;
                rptZoom.DataBind();

                phNoZoom.Visible = !list.Any();
                if (pnlZoomPagination != null) pnlZoomPagination.Visible = totalRecords > PageSize;

                litZoomPage.Text = (ZoomPage + 1).ToString();
                litZoomTotal.Text = totalPages.ToString();
                btnZoomPrev.Visible = ZoomPage > 0;
                btnZoomNext.Visible = ZoomPage < (totalPages - 1);
            }
        }
        protected void btnZoomPrev_Click(object sender, EventArgs e) { ZoomPage--; BindScheduledZooms(); }
        protected void btnZoomNext_Click(object sender, EventArgs e) { ZoomPage++; BindScheduledZooms(); }

        // ======================= COMMENTS =======================
        private void BindTeacherDropdown()
        {
            using (var db = new AppDbContext())
            {
                var teachers = db.Users.Where(u => u.Role == "Teacher").ToList();
                ddlTeachers.DataSource = teachers;
                ddlTeachers.DataTextField = "Username";
                ddlTeachers.DataValueField = "UserId";
                ddlTeachers.DataBind();

                ddlTeachers.Items.Insert(0, new ListItem("-- All Teachers --", ""));
            }
        }

        protected void btnSearchComments_Click(object sender, EventArgs e)
        {
            hfActiveTab.Value = "comments";
            CommentPage = 0;
            BindComments();
        }

        private void BindComments()
        {
            using (var db = new AppDbContext())
            {
                var query = db.HomeworkSubmissions
                    .Where(h => h.TeacherComments != "[Deleted]");

                if (!string.IsNullOrEmpty(ddlTeachers.SelectedValue))
                {
                    int tid = int.Parse(ddlTeachers.SelectedValue);
                    query = query.Where(h => h.TeacherId == tid);
                }

                if (ddlCommentStatus.SelectedValue == "Visible")
                    query = query.Where(h => h.IsFeedbackHidden == false);
                else if (ddlCommentStatus.SelectedValue == "Hidden")
                    query = query.Where(h => h.IsFeedbackHidden == true);

                int totalRecords = query.Count();
                int totalPages = (totalRecords + PageSize - 1) / PageSize;
                if (totalPages == 0) totalPages = 1;

                if (CommentPage >= totalPages) CommentPage = totalPages - 1;
                if (CommentPage < 0) CommentPage = 0;

                var rawList = query.OrderByDescending(h => h.GradedAt)
                                   .Skip(CommentPage * PageSize)
                                   .Take(PageSize)
                                   .ToList();

                var list = rawList.Select(h => {
                    var practice = db.Set<Practice>().FirstOrDefault(p => p.PracticeId == h.PracticeId);
                    string pTitle = practice != null ? practice.Title : "General Assignment";
                    string tName = db.Users.FirstOrDefault(u => u.UserId == h.TeacherId)?.Username ?? "Unknown Teacher";
                    string sName = db.Users.FirstOrDefault(u => u.UserId == h.StudentId)?.Username ?? "Unknown Student";

                    return new
                    {
                        h.SubmissionId,
                        GradedAt = h.GradedAt,
                        GradedAtString = h.GradedAt.HasValue ? h.GradedAt.Value.ToString("MMM dd, yyyy") : "N/A",
                        CommentText = string.IsNullOrEmpty(h.TeacherComments) ? "No comment provided yet." : h.TeacherComments,
                        PracticeTitle = pTitle,
                        TeacherName = tName,
                        StudentName = sName,
                        IsFeedbackHidden = h.IsFeedbackHidden
                    };
                }).ToList();

                rptComments.DataSource = list;
                rptComments.DataBind();

                phNoComments.Visible = !list.Any();
                if (pnlCommentPagination != null) pnlCommentPagination.Visible = totalRecords > PageSize;

                litCommentPage.Text = (CommentPage + 1).ToString();
                litCommentTotal.Text = totalPages.ToString();
                btnCommentPrev.Visible = CommentPage > 0;
                btnCommentNext.Visible = CommentPage < (totalPages - 1);
            }
        }
        protected void btnCommentPrev_Click(object sender, EventArgs e) { CommentPage--; BindComments(); }
        protected void btnCommentNext_Click(object sender, EventArgs e) { CommentPage++; BindComments(); }

        // ======================= ACTIONS =======================
        protected void rptVideos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            hfActiveTab.Value = "video";
            int id = Convert.ToInt32(e.CommandArgument);
            using (var db = new AppDbContext())
            {
                var v = db.VideoRecords.Find(id);
                if (v != null)
                {
                    string action = e.CommandName == "Approve" ? "Approved" : "Hidden";
                    v.Approved = action;
                    db.SaveChanges();

                    int adminId = Convert.ToInt32(Session["UserId"] ?? 1);
                    SystemLogger.LogEvent(adminId, "Moderated Teacher Video", "Content Moderation", $"{{ \"video_record_id\": {id}, \"action\": \"{action}\" }}");
                }
            }
            BindPendingVideos();
            TriggerToast(e.CommandName == "Approve" ? "Video Approved!" : "Video Hidden!", true);
        }

        protected void rptZoom_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            hfActiveTab.Value = "zoom";
            if (e.CommandName == "DeleteZoom")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                using (var db = new AppDbContext())
                {
                    var s = db.ZoomSessions.Find(id);
                    if (s != null)
                    {
                        string title = s.Title;
                        db.ZoomSessions.Remove(s);
                        db.SaveChanges();
                        int adminId = Convert.ToInt32(Session["UserId"] ?? 1);
                        SystemLogger.LogEvent(adminId, "Deleted Zoom Session", "Live Sessions", $"{{ \"session_id\": {id}, \"topic\": \"{title}\" }}");
                    }
                }
                BindScheduledZooms();
                TriggerToast("Zoom session deleted.", false);
            }
        }

        protected void rptComments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            hfActiveTab.Value = "comments";
            int id = Convert.ToInt32(e.CommandArgument);
            using (var db = new AppDbContext())
            {
                var h = db.HomeworkSubmissions.Find(id);
                if (h != null)
                {
                    int adminId = Convert.ToInt32(Session["UserId"] ?? 1);

                    if (e.CommandName == "DeleteComment")
                    {
                        h.IsFeedbackHidden = true;
                        TriggerToast("Feedback hidden from users.", true);
                        SystemLogger.LogEvent(adminId, "Hidden Teacher Comment", "Content Moderation", $"{{ \"submission_id\": {id} }}");
                    }
                    else if (e.CommandName == "UnhideComment")
                    {
                        h.IsFeedbackHidden = false;
                        TriggerToast("Feedback restored and is now visible.", true);
                        SystemLogger.LogEvent(adminId, "Restored Teacher Comment", "Content Moderation", $"{{ \"submission_id\": {id} }}");
                    }
                    else if (e.CommandName == "PermDelete")
                    {
                        h.TeacherComments = "[Deleted]";
                        TriggerToast("Feedback permanently deleted.", false);
                        SystemLogger.LogEvent(adminId, "Deleted Teacher Comment Permanently", "Content Moderation", $"{{ \"submission_id\": {id} }}");
                    }

                    db.SaveChanges();
                }
            }
            BindComments();
        }

        private void TriggerToast(string message, bool isSuccess)
        {
            string script = $"showToast('{message}', '{(isSuccess ? "success" : "danger")}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ToastMsg", script, true);
        }
    }
}