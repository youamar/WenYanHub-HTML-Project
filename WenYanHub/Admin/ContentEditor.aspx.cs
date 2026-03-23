using System;
using System.Linq;
using System.Data.Entity;
using System.Web.UI;
using System.Web.UI.WebControls;
using WenYanHub.Models;

namespace WenYanHub.Admin
{
    public partial class ContentEditor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (int.TryParse(Request.QueryString["ContentId"], out int contentId))
                {
                    LoadContentData(contentId);
                }
                else
                {
                    Response.Redirect("ManageContent.aspx");
                }
            }
        }

        private void LoadContentData(int id)
        {
            using (var db = new AppDbContext())
            {
                var content = db.Contents.Include("Author").FirstOrDefault(c => c.ContentId == id);

                if (content != null)
                {
                    bool isPending = content.Approved != null && content.Approved.Trim().Equals("Pending", StringComparison.OrdinalIgnoreCase);
                    phPendingActions.Visible = isPending;

                    litTitle.Text = content.Title;
                    litContentText.Text = content.ContentText;
                    litAnalysis.Text = content.Analysis;
                    txtVideoUrl.Text = content.Video;
                    txtGenre.Text = content.Genre;

                    if (content.Author != null)
                    {
                        lblDynasty.Text = content.Author.Dynasty;
                        lnkAuthor.Text = content.Author.Name;
                        lnkAuthor.NavigateUrl = "~/Admin/AdminAuthorProfile.aspx?id=" + content.AuthorId + "&returnUrl=" + Server.UrlEncode(Request.RawUrl);
                    }
                    else
                    {
                        lblDynasty.Text = "Unknown";
                        lnkAuthor.Text = "Anonymous";
                        lnkAuthor.NavigateUrl = "#";
                    }

                    if (!string.IsNullOrEmpty(content.Picture))
                        pnlHero.Style["background-image"] = $"url('{content.Picture}')";
                    else
                        pnlHero.Style["background-image"] = "url('../Images/default-hero.jpg')";

                    if (!string.IsNullOrEmpty(content.Video))
                        litVideo.Text = $"<iframe src=\"{content.Video}\" allowfullscreen style=\"border:none; width:100%; height:100%; border-radius: 8px;\"></iframe>";
                    else
                        litVideo.Text = "<div class='bg-dark text-white d-flex align-items-center justify-content-center h-100 rounded-3'>No Video Available</div>";

                    // RESTORED: Notes Binding
                    var notesList = db.Notes
                                        .Where(n => n.ContentId == id)
                                        .OrderByDescending(n => n.CreatedAt)
                                        .ToList()
                                        .Select(n => new
                                        {
                                            NoteId = n.NoteId,
                                            NoteContent = n.NoteContent,
                                            CreatedAt = n.CreatedAt,
                                            TeacherName = db.Users.FirstOrDefault(u => u.UserId == n.TeacherId)?.Username ?? "Unknown Teacher",
                                            Status = string.IsNullOrEmpty(n.Approved) ? "Pending" : n.Approved,
                                            IsPending = string.IsNullOrEmpty(n.Approved) || n.Approved == "Pending",
                                            StatusClass = (string.IsNullOrEmpty(n.Approved) || n.Approved == "Pending") ? "badge-outline-gold" : "badge-outline-dark"
                                        }).ToList();

                    rptNotes.DataSource = notesList;
                    rptNotes.DataBind();
                    phNoNotes.Visible = !notesList.Any();

                    // RESTORED: Comments Binding
                    var commentList = db.Comments
                                        .Where(c => c.ContentId == id)
                                        .OrderByDescending(c => c.CreatedAt)
                                        .ToList()
                                        .Select(c => new
                                        {
                                            CommentId = c.CommentId,
                                            CommentText = c.CommentText,
                                            CreatedAt = c.CreatedAt,
                                            Username = db.Users.FirstOrDefault(u => u.UserId == c.UserId)?.Username ?? "Unknown",
                                            UserInitial = (db.Users.FirstOrDefault(u => u.UserId == c.UserId)?.Username ?? "U").Substring(0, 1).ToUpper(),
                                            IsCensored = c.CommentText != null && c.CommentText.Contains("[This comment was removed")
                                        }).ToList();

                    rptComments.DataSource = commentList;
                    rptComments.DataBind();
                    phNoComments.Visible = !commentList.Any();
                }
            }
        }

        protected void btnApproveLesson_Click(object sender, EventArgs e)
        {
            if (int.TryParse(Request.QueryString["ContentId"], out int id))
            {
                using (var db = new AppDbContext())
                {
                    var content = db.Contents.Find(id);
                    if (content != null)
                    {
                        content.Approved = "Approved";
                        db.SaveChanges();
                    }
                }
                Response.Redirect(Request.RawUrl);
            }
        }

        protected void btnRejectLesson_Click(object sender, EventArgs e)
        {
            if (int.TryParse(Request.QueryString["ContentId"], out int id))
            {
                using (var db = new AppDbContext())
                {
                    var content = db.Contents.Find(id);
                    if (content != null)
                    {
                        // 🔥 THE FIX: Change status to Rejected instead of removing the record
                        content.Approved = "Rejected";
                        db.SaveChanges();
                    }
                }
                Response.Redirect("ManageContent.aspx?view=pending");
            }
        }

        protected void rptNotes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int noteId = Convert.ToInt32(e.CommandArgument);
            using (var db = new AppDbContext())
            {
                var note = db.Notes.FirstOrDefault(n => n.NoteId == noteId);
                if (note != null)
                {
                    if (e.CommandName == "Approve")
                    {
                        note.Approved = "Approved";
                        db.SaveChanges();
                    }
                    else if (e.CommandName == "Reject")
                    {
                        db.Notes.Remove(note);
                        db.SaveChanges();
                    }
                }
            }
            if (int.TryParse(Request.QueryString["ContentId"], out int contentId)) LoadContentData(contentId);
        }

        protected void rptComments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Censor")
            {
                int commentId = Convert.ToInt32(e.CommandArgument);
                using (var db = new AppDbContext())
                {
                    var comment = db.Comments.FirstOrDefault(c => c.CommentId == commentId);
                    if (comment != null)
                    {
                        comment.CommentText = "[This comment was removed by an Admin for violating community guidelines.]";
                        db.SaveChanges();
                    }
                }
                if (int.TryParse(Request.QueryString["ContentId"], out int contentId)) LoadContentData(contentId);
            }
        }

        protected void btnSaveAll_Click(object sender, EventArgs e)
        {
            if (int.TryParse(Request.QueryString["ContentId"], out int id))
            {
                using (var db = new AppDbContext())
                {
                    var content = db.Contents.FirstOrDefault(c => c.ContentId == id);
                    if (content != null)
                    {
                        content.Title = hfTitle.Value.Trim();
                        content.ContentText = hfContentText.Value.Trim();
                        content.Analysis = hfAnalysis.Value.Trim();
                        content.Genre = txtGenre.Text.Trim();
                        content.Video = txtVideoUrl.Text.Trim();
                        content.UpdatedAt = DateTime.Now;
                        db.SaveChanges();
                    }
                }
                Response.Redirect(Request.RawUrl);
            }
        }
    }
}