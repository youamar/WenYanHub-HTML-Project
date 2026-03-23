using System;
using System.Linq;
using System.Data.Entity;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using WenYanHub.Models;

namespace WenYanHub.Contents
{
    public partial class Intro : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (int.TryParse(Request.QueryString["id"], out int id))
                {
                    LoadIntro(id);
                }
                else
                {
                    Response.Redirect("Index.aspx");
                }
            }

            bool isLoggedIn = Session["UserId"] != null;
            pnlCommentForm.Visible = isLoggedIn;
            pnlLoginPrompt.Visible = !isLoggedIn;

            if (!isLoggedIn && Request.QueryString["id"] != null)
            {
                string returnUrl = Server.UrlEncode($"~/Contents/Intro.aspx?id={Request.QueryString["id"]}");
                lnkLogin.NavigateUrl = $"~/Account/Login.aspx?ReturnUrl={returnUrl}";
            }
        }

        private void LoadIntro(int id)
        {
            using (var db = new AppDbContext())
            {
    
                var content = db.Contents.Include("Author").FirstOrDefault(c => c.ContentId == id);

                if (content != null)
                {
          
                    lblTitle.Text = content.Title;
                    lblAuthor.Text = content.Author != null ? content.Author.Name : "Anonymous";
                    lblDynasty.Text = content.Author != null ? content.Author.Dynasty : "Unknown";
                    lblAnalysis.Text = string.IsNullOrEmpty(content.Analysis) ? "No analysis available." : content.Analysis;
                    lblGenre.Text = string.IsNullOrEmpty(content.Genre) ? "Literature" : content.Genre;

                 
                    if (!string.IsNullOrEmpty(content.ContentText))
                    {
                        var rawParagraphs = content.ContentText.Split(new[] { "\n", "\r\n" }, StringSplitOptions.RemoveEmptyEntries);
                        lblContentText.Text = string.Join("", rawParagraphs.Select(p => $"<p class='mb-4 text-justify' style='text-indent: 2em;'>{p.Trim()}</p>"));
                    }

           
                    string imgUrl = !string.IsNullOrEmpty(content.Picture) ? content.Picture : "https://images.unsplash.com/photo-1516546453174-5e1098616b05?q=80&w=1200";
                    pnlHero.Attributes["style"] += $" background-image: url('{imgUrl}'); background-size: cover; background-position: center;";

                
                    if (!string.IsNullOrEmpty(content.Video))
                    {
                        string embedUrl = GetYouTubeEmbedLink(content.Video);
                        if (!string.IsNullOrEmpty(embedUrl))
                        {
                            litVideo.Text = $"<iframe src='{embedUrl}' title='YouTube video' allowfullscreen style='border:0; width:100%; height:100%; border-radius: 8px;'></iframe>";
                            pnlNoVideo.Visible = false;
                        }
                        else { pnlNoVideo.Visible = true; }
                    }
                    else { pnlNoVideo.Visible = true; }

              
                    lnkStartDetailedLearning.NavigateUrl = $"~/Contents/Details.aspx?id={id}";
                    lnkChapterLearning.NavigateUrl = $"~/Learning/Practice_with_cid.aspx?cid={id}";


                    // 如果已登录，正常进入对应的学习页面
                    if (Session["UserId"] != null)
                    {
                        // 已登录，直接进入对应的学习页面
                        lnkChapterLearning.NavigateUrl = $"~/Learning/Practice_with_cid.aspx?cid={id}";
                        lnkQuiz.NavigateUrl = $"~/Learning/Mini_Game.aspx?cid={id}";
                    }
                    else
                    {
                        string returnUrlWithAnchor = Server.UrlEncode($"~/Contents/Intro.aspx?id={id}#learning-section");

                        lnkChapterLearning.NavigateUrl = $"~/Account/Login.aspx?ReturnUrl={returnUrlWithAnchor}";
                        lnkQuiz.NavigateUrl = $"~/Account/Login.aspx?ReturnUrl={returnUrlWithAnchor}";
                    }

                    var notes = db.Notes.Include("Teacher")
                                    .Where(n => n.ContentId == id)
                                    .OrderByDescending(n => n.CreatedAt)
                                    .ToList();
                    rptNotes.DataSource = notes;
                    rptNotes.DataBind();
                    pnlNoNotes.Visible = !notes.Any();

                    BindComments();
                }
                else
                {
                    Response.Redirect("Index.aspx");
                }
            }
        }

        private void BindComments()
        {
            if (int.TryParse(Request.QueryString["id"], out int id))
            {
                using (var db = new AppDbContext())
                {
                    var comments = db.Comments.Include("User")
                                     .Where(c => c.ContentId == id && c.ValidStatus == true)
                                     .OrderByDescending(c => c.CreatedAt)
                                     .ToList();
                    rptComments.DataSource = comments;
                    rptComments.DataBind();
                    pnlNoComments.Visible = !comments.Any();
                }
            }
        }

        protected bool IsMyComment(object commentUserId)
        {
            if (Session["UserId"] == null || commentUserId == null) return false;
            return Session["UserId"].ToString() == commentUserId.ToString();
        }

        protected void rptComments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "CancelEdit")
            {
                e.Item.FindControl("lblCommentText").Visible = true;
                e.Item.FindControl("pnlEdit").Visible = false;
                e.Item.FindControl("phActions").Visible = true;

                ScriptManager.RegisterStartupScript(this, GetType(), "jumpToComment", "window.location.hash = '#discuss-box';", true);
                return;
            }

            int commentId = Convert.ToInt32(e.CommandArgument);

            using (var db = new AppDbContext())
            {
                var comment = db.Comments.Find(commentId);
                if (comment == null) return;

                if (comment.UserId != Convert.ToInt32(Session["UserId"])) return;

                if (e.CommandName == "DeleteComment")
                {
                    db.Comments.Remove(comment);
                    db.SaveChanges();
                    BindComments();

                    ScriptManager.RegisterStartupScript(this, GetType(), "jumpToComment", "window.location.hash = '#discuss-box';", true);
                }
                else if (e.CommandName == "EditComment")
                {
                    e.Item.FindControl("lblCommentText").Visible = false;
                    e.Item.FindControl("pnlEdit").Visible = true;
                    e.Item.FindControl("phActions").Visible = false;

                    ScriptManager.RegisterStartupScript(this, GetType(), "jumpToComment", "window.location.hash = '#discuss-box';", true);
                }
                else if (e.CommandName == "UpdateComment")
                {
                    TextBox txtEdit = (TextBox)e.Item.FindControl("txtEditComment");
                    string newText = txtEdit.Text.Trim();

                    if (!string.IsNullOrEmpty(newText))
                    {
                        comment.CommentText = newText;
                        comment.UpdatedAt = DateTime.Now;
                        db.SaveChanges();
                        BindComments(); 

                        ScriptManager.RegisterStartupScript(this, GetType(), "jumpToComment", "window.location.hash = '#discuss-box';", true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Content cannot be empty!');", true);
                    }
                }
            }
        }

        protected void btnSubmitComment_Click(object sender, EventArgs e)
        {
            string commentText = txtComment.Text.Trim();
            if (string.IsNullOrEmpty(commentText) || Session["UserId"] == null) return;

            if (int.TryParse(Request.QueryString["id"], out int contentId))
            {
                using (var db = new AppDbContext())
                {
                    db.Comments.Add(new Comment
                    {
                        ContentId = contentId,
                        UserId = (int)Session["UserId"],
                        CommentText = commentText,
                        CreatedAt = DateTime.Now,
                        ValidStatus = true
                    });
                    db.SaveChanges();
                }
                txtComment.Text = ""; 
                BindComments(); 

                ScriptManager.RegisterStartupScript(this, GetType(), "jumpToComment", "window.location.hash = '#discuss-box';", true);
            }
        }

        private string GetYouTubeEmbedLink(string url)
        {
            if (string.IsNullOrEmpty(url)) return "";
            var regex = new Regex(@"(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^""&?\/\s]{11})");
            var match = regex.Match(url);
            return match.Success ? $"https://www.youtube.com/embed/{match.Groups[1].Value}" : "";
        }
    }
}