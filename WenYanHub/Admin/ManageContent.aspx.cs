using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Web.UI.WebControls;
using WenYanHub.Models;
using WenYanHub.Admin.Utils;

namespace WenYanHub.Admin
{
    public partial class ManageContent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string selectedCat = Request.QueryString["cat"];
                string viewType = Request.QueryString["view"] ?? "active";
                BindFilteredContent(selectedCat, viewType);
            }
        }

        public string GetTagContainerClass()
        {
            return "card-tag-zone";
        }

        protected void btnBulkApprove_Click(object sender, EventArgs e) => ProcessBulkAction("Approved");
        protected void btnBulkReject_Click(object sender, EventArgs e) => ProcessBulkAction("Rejected");
        protected void btnBulkArchive_Click(object sender, EventArgs e) => ProcessBulkAction("Archived");
        protected void btnBulkDelete_Click(object sender, EventArgs e) => ProcessBulkAction("Deleted");
        protected void btnBulkRestore_Click(object sender, EventArgs e) => ProcessBulkAction("Pending");

        protected void btnBulkPermDelete_Click(object sender, EventArgs e)
        {
            string idsRaw = hfSelectedIds.Value;
            if (string.IsNullOrEmpty(idsRaw)) return;
            var idList = idsRaw.Split(',').ToList();

            var contentIds = idList.Where(id => id.StartsWith("C_")).Select(id => int.Parse(id.Substring(2))).ToList();
            var noteIds = idList.Where(id => id.StartsWith("N_")).Select(id => int.Parse(id.Substring(2))).ToList();
            var practiceIds = idList.Where(id => id.StartsWith("P_")).Select(id => int.Parse(id.Substring(2))).ToList();

            using (var db = new AppDbContext())
            {
                int totalDeleted = 0;

                if (contentIds.Any())
                {
                    var contentToUpdate = db.Contents.Where(c => contentIds.Contains(c.ContentId)).ToList();
                    db.Contents.RemoveRange(contentToUpdate);
                    totalDeleted += contentToUpdate.Count;
                }

                if (noteIds.Any())
                {
                    var notesToUpdate = db.Notes.Where(n => noteIds.Contains(n.NoteId)).ToList();
                    db.Notes.RemoveRange(notesToUpdate);
                    totalDeleted += notesToUpdate.Count;
                }

                if (practiceIds.Any())
                {
                    var practicesToUpdate = db.Practices.Where(p => practiceIds.Contains(p.PracticeId)).ToList();
                    db.Practices.RemoveRange(practicesToUpdate);
                    totalDeleted += practicesToUpdate.Count;
                }

                db.SaveChanges();

                int adminId = Convert.ToInt32(Session["UserId"]);
                SystemLogger.LogEvent(adminId, "Permanently Deleted Content", "Content Moderation", $"{{ \"deleted_count\": {totalDeleted} }}");
            }
            Response.Redirect(Request.RawUrl);
        }

        private void ProcessBulkAction(string newStatus)
        {
            string idsRaw = hfSelectedIds.Value;
            if (string.IsNullOrEmpty(idsRaw)) return;
            var idList = idsRaw.Split(',').ToList();

            var contentIds = idList.Where(id => id.StartsWith("C_")).Select(id => int.Parse(id.Substring(2))).ToList();
            var noteIds = idList.Where(id => id.StartsWith("N_")).Select(id => int.Parse(id.Substring(2))).ToList();
            var practiceIds = idList.Where(id => id.StartsWith("P_")).Select(id => int.Parse(id.Substring(2))).ToList();

            using (var db = new AppDbContext())
            {
                int totalAffected = 0;

                if (contentIds.Any())
                {
                    var contentToUpdate = db.Contents.Where(c => contentIds.Contains(c.ContentId)).ToList();
                    foreach (var item in contentToUpdate) { item.Approved = newStatus; totalAffected++; }
                }

                if (noteIds.Any())
                {
                    var notesToUpdate = db.Notes.Where(n => noteIds.Contains(n.NoteId)).ToList();
                    foreach (var item in notesToUpdate) { item.Approved = newStatus; totalAffected++; }
                }

                if (practiceIds.Any())
                {
                    var practicesToUpdate = db.Practices.Where(p => practiceIds.Contains(p.PracticeId)).ToList();
                    foreach (var item in practicesToUpdate) { item.Approved = newStatus; totalAffected++; }
                }

                db.SaveChanges();

                int adminId = Convert.ToInt32(Session["UserId"]);
                SystemLogger.LogEvent(adminId, $"Bulk Action: {newStatus}", "Content Moderation", $"{{ \"affected_count\": {totalAffected}, \"new_status\": \"{newStatus}\" }}");
            }
            Response.Redirect(Request.RawUrl);
        }

        private void BindFilteredContent(string category, string viewType)
        {
            using (var db = new AppDbContext())
            {
                bool isPendingView = (viewType == "pending");

                if (isPendingView)
                {
                    gridContainer.Attributes["class"] = "list-view-queue content-grid-container hide-previews";
                    litViewType.Text = "Moderation Queue (Lessons, Notes, & Practices)";
                    litTitleHeader.Text = "Pending Approvals";
                }
                else if (viewType == "trash")
                {
                    gridContainer.Attributes["class"] = "fixed-3-col-grid content-grid-container hide-previews";
                    litViewType.Text = "Trash Bin";
                    litTitleHeader.Text = "Trash Bin";
                }
                else if (viewType == "archived")
                {
                    gridContainer.Attributes["class"] = "fixed-3-col-grid content-grid-container hide-previews";
                    litViewType.Text = "Archive Storage";
                    litTitleHeader.Text = "Archive";
                }
                else if (viewType == "rejected")
                {
                    gridContainer.Attributes["class"] = "fixed-3-col-grid content-grid-container hide-previews";
                    litViewType.Text = "Rejected Content";
                    litTitleHeader.Text = "Rejected Items";
                }
                else
                {
                    gridContainer.Attributes["class"] = "fixed-3-col-grid content-grid-container hide-previews";
                    litViewType.Text = "Active Library";
                    litTitleHeader.Text = "Library Management";
                }

                var qContents = db.Contents.Include("Author").AsQueryable();
                var qNotes = db.Notes.Include("Teacher").AsQueryable();
                var qPractices = db.Practices.Include("Teacher").AsQueryable();

                if (isPendingView)
                {
                    qContents = qContents.Where(c => string.IsNullOrEmpty(c.Approved) || c.Approved.Trim().ToLower() == "pending");
                    qNotes = qNotes.Where(n => string.IsNullOrEmpty(n.Approved) || n.Approved.Trim().ToLower() == "pending");
                    qPractices = qPractices.Where(p => string.IsNullOrEmpty(p.Approved) || p.Approved.Trim().ToLower() == "pending");
                }
                else if (viewType == "trash")
                {
                    qContents = qContents.Where(c => c.Approved != null && c.Approved.Trim().ToLower() == "deleted");
                    qNotes = qNotes.Where(n => n.Approved != null && n.Approved.Trim().ToLower() == "deleted");
                    qPractices = qPractices.Where(p => p.Approved != null && p.Approved.Trim().ToLower() == "deleted");
                }
                else if (viewType == "archived")
                {
                    qContents = qContents.Where(c => c.Approved != null && c.Approved.Trim().ToLower().Contains("archive"));
                    qNotes = qNotes.Where(n => n.Approved != null && n.Approved.Trim().ToLower().Contains("archive"));
                    qPractices = qPractices.Where(p => p.Approved != null && p.Approved.Trim().ToLower().Contains("archive"));
                }
                else if (viewType == "rejected")
                {
                    qContents = qContents.Where(c => c.Approved != null && (c.Approved.Trim().ToLower() == "rejected" || c.Approved.Trim().ToLower() == "hidden"));
                    qNotes = qNotes.Where(n => n.Approved != null && (n.Approved.Trim().ToLower() == "rejected" || n.Approved.Trim().ToLower() == "hidden"));
                    qPractices = qPractices.Where(p => p.Approved != null && (p.Approved.Trim().ToLower() == "rejected" || p.Approved.Trim().ToLower() == "hidden"));
                }
                else
                {
                    qContents = qContents.Where(c => c.Approved != null && (c.Approved.Trim().ToLower() == "approved" || c.Approved.Trim().ToLower() == "published"));

                    // Force Notes and Practices to be completely hidden from the Active Library
                    qNotes = qNotes.Where(n => false);
                    qPractices = qPractices.Where(p => false);
                }

                if (!string.IsNullOrEmpty(category))
                {
                    qContents = qContents.Where(c => c.Category != null && c.Category.StartsWith(category));
                }

                // 🔥 Added FileUrl to all three maps
                var mappedContents = qContents.ToList().Select(c => new {
                    Id = "C_" + c.ContentId,
                    TargetContentId = c.ContentId,
                    ItemType = "Lesson",
                    TypeClass = "badge-outline-dark",
                    TypeIcon = "bi-book",
                    Title = c.Title,
                    PreviewText = c.ContentText,
                    FileUrl = "",
                    Picture = c.Picture,
                    Category = c.Category ?? "Uncategorized",
                    Genre = c.Genre ?? "Unspecified",
                    AuthorName = c.Author != null ? c.Author.Name : "System Admin",
                    CreatedAt = c.CreatedAt,
                    IsPending = isPendingView
                });

                var mappedNotes = qNotes.ToList().Select(n => new {
                    Id = "N_" + n.NoteId,
                    TargetContentId = n.ContentId,
                    ItemType = "Teacher Note",
                    TypeClass = "badge-outline-dark",
                    TypeIcon = "bi-journal-text",
                    Title = "Note for: " + (db.Contents.FirstOrDefault(c => c.ContentId == n.ContentId)?.Title ?? "Unknown Lesson"),
                    PreviewText = n.NoteContent,
                    FileUrl = "",
                    Picture = db.Contents.FirstOrDefault(c => c.ContentId == n.ContentId)?.Picture,
                    Category = "Teacher Feedback",
                    Genre = "Moderation",
                    AuthorName = n.Teacher != null ? n.Teacher.Username : "Teacher",
                    CreatedAt = n.CreatedAt,
                    IsPending = isPendingView
                });

                var mappedPractices = qPractices.ToList().Select(p => new {
                    Id = "P_" + p.PracticeId,
                    TargetContentId = p.PracticeId,
                    ItemType = "Practice Link",
                    TypeClass = "badge-outline-dark",
                    TypeIcon = "bi-file-earmark-text",
                    Title = string.IsNullOrEmpty(p.Title) ? "Untitled Practice" : p.Title,
                    PreviewText = string.IsNullOrEmpty(p.Description) ? "No description provided." : p.Description,
                    FileUrl = p.QuestionFileUrl ?? "", // 🔥 Explicitly passing the Drive URL
                    Picture = "../Images/default-hero.jpg",
                    Category = "Homework / Test",
                    Genre = "Assessment",
                    AuthorName = p.Teacher != null ? p.Teacher.Username : "Teacher",
                    CreatedAt = p.CreatedAt,
                    IsPending = isPendingView
                });

                var combinedData = mappedContents.Concat(mappedNotes).Concat(mappedPractices).Select(x => {
                    double daysOld = 0;
                    if (x.CreatedAt != null)
                    {
                        DateTime createdDate;
                        if (DateTime.TryParse(x.CreatedAt.ToString(), out createdDate))
                        {
                            daysOld = (DateTime.Now - createdDate).TotalDays;
                        }
                    }

                    string priorityColor = daysOld > 3 ? "var(--theme-red)" : "var(--theme-gold)";
                    string priorityBadgeClass = daysOld > 3 ? "badge-outline-red" : "badge-outline-gold";
                    string priorityText = daysOld > 3 ? "Urgent" : "New Submission";

                    return new
                    {
                        x.Id,
                        x.TargetContentId,
                        x.ItemType,
                        x.TypeClass,
                        x.TypeIcon,
                        x.Title,
                        x.PreviewText,
                        x.FileUrl, // 🔥 Ensure FileUrl is combined
                        x.Picture,
                        x.Category,
                        x.Genre,
                        x.AuthorName,
                        x.CreatedAt,
                        x.IsPending,
                        DaysOld = daysOld,
                        PriorityColor = isPendingView ? priorityColor : "transparent",
                        PriorityBadgeClass = isPendingView ? priorityBadgeClass : "",
                        PriorityText = isPendingView ? priorityText : ""
                    };
                }).OrderByDescending(x => x.DaysOld).ThenByDescending(x => x.CreatedAt).ToList();

                rptContent.DataSource = combinedData;
                rptContent.DataBind();

                btnBulkApprove.Visible = (viewType != "active" && !isPendingView);
                btnBulkArchive.Visible = (viewType != "archived" && viewType != "trash" && !isPendingView);
                btnBulkDelete.Visible = (viewType != "trash" && viewType != "rejected" && !isPendingView);
                btnBulkRestore.Visible = (viewType == "trash" || viewType == "rejected");
                btnBulkPermDelete.Visible = (viewType == "trash" || viewType == "rejected");
            }
        }
    }
}