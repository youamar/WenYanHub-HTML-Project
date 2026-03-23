using System;
using System.Linq;
using System.Web.UI.WebControls;
using WenYanHub.Models;
using System.Data.Entity;

namespace WenYanHub.Teacher
{
    public partial class EditContent : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        int currentTeacherId;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["UserId"] != null)
            {
                currentTeacherId = Convert.ToInt32(Session["UserId"]);
            }

            if (!IsPostBack)
            {
                BindAuthors();

                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int contentId = Convert.ToInt32(Request.QueryString["id"]);
                    LoadContentData(contentId);
                }
            }
        }

        private void BindAuthors()
        {
            var authors = db.Author.OrderBy(a => a.Name).ToList();

            var authorDisplayList = authors.Select(a => new
            {
                AuthorId = a.AuthorId,
                DisplayName = string.IsNullOrEmpty(a.Dynasty) ? a.Name : $"{a.Name} ({a.Dynasty})"
            }).ToList();

            ddlAuthor.DataSource = authorDisplayList;
            ddlAuthor.DataTextField = "DisplayName";
            ddlAuthor.DataValueField = "AuthorId";
            ddlAuthor.DataBind();
            ddlAuthor.Items.Insert(0, new ListItem("-- Select Existing Author --", ""));
        }

        private void LoadContentData(int id)
        {
            var content = db.Contents
                            .Include(c => c.Words)
                            .Include(c => c.Sentences)
                            .FirstOrDefault(c => c.ContentId == id);

            if (content != null)
            {
            
                hfContentId.Value = content.ContentId.ToString();
                txtTitle.Text = content.Title;
                txtCategory.Text = content.Category;
                txtGenre.Text = content.Genre;
                txtPicture.Text = content.Picture;
                txtVideo.Text = content.Video;
                txtContentText.Text = content.ContentText;
                txtAnalysis.Text = content.Analysis;

                if (content.AuthorId.HasValue)
                {
                    ddlAuthor.SelectedValue = content.AuthorId.Value.ToString();
                }

                if (content.Words != null && content.Words.Any())
                {
                    var wordLines = content.Words.Select(w => $"{w.Vocabulary} | {w.Annotations}");
                    txtWordsBulk.Text = string.Join("\n", wordLines);
                }

                if (content.Sentences != null && content.Sentences.Any())
                {
                    var sentenceLines = content.Sentences.Select(s => $"{s.SentenceText} | {s.Translate}");
                    txtSentencesBulk.Text = string.Join("\n", sentenceLines);
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                int? finalAuthorId = null;

                if (!string.IsNullOrEmpty(txtNewAuthor.Text.Trim()))
                {
                    Author newAuthor = new Author()
                    {
                        Name = txtNewAuthor.Text.Trim(),
                        Dynasty = txtNewDynasty.Text.Trim(),
                        CreatedAt = DateTime.Now,
                        UpdatedAt = DateTime.Now
                    };
                    db.Author.Add(newAuthor);
                    db.SaveChanges();

                    finalAuthorId = newAuthor.AuthorId;
                }
                else if (!string.IsNullOrEmpty(ddlAuthor.SelectedValue))
                {
                    finalAuthorId = Convert.ToInt32(ddlAuthor.SelectedValue);
                }

                WenYanHub.Models.Content contentToSave;
                bool isUpdateMode = !string.IsNullOrEmpty(hfContentId.Value);

                if (!isUpdateMode)
                {
                    contentToSave = new WenYanHub.Models.Content()
                    {
                        Title = txtTitle.Text.Trim(),
                        Category = txtCategory.Text.Trim(),
                        Genre = txtGenre.Text.Trim(),
                        Picture = txtPicture.Text.Trim(),
                        Video = txtVideo.Text.Trim(),
                        ContentText = txtContentText.Text.Trim(),
                        Analysis = txtAnalysis.Text.Trim(),
                        AuthorId = finalAuthorId,
                        TeacherId = currentTeacherId,
                        Approved = "Pending",
                        CreatedAt = DateTime.Now,
                        UpdatedAt = DateTime.Now
                    };
                    db.Contents.Add(contentToSave);
                }
                else
                {
                    int contentId = Convert.ToInt32(hfContentId.Value);
                    contentToSave = db.Contents.Find(contentId);

                    if (contentToSave == null) return; 

                    contentToSave.Title = txtTitle.Text.Trim();
                    contentToSave.Category = txtCategory.Text.Trim();
                    contentToSave.Genre = txtGenre.Text.Trim();
                    contentToSave.Picture = txtPicture.Text.Trim();
                    contentToSave.Video = txtVideo.Text.Trim();
                    contentToSave.ContentText = txtContentText.Text.Trim();
                    contentToSave.Analysis = txtAnalysis.Text.Trim();

                    if (finalAuthorId.HasValue)
                    {
                        contentToSave.AuthorId = finalAuthorId;
                    }

                    contentToSave.Approved = "Pending";
                    contentToSave.UpdatedAt = DateTime.Now;
                }

                db.SaveChanges();
                int savedContentId = contentToSave.ContentId;

                if (isUpdateMode)
                {
                    var oldWords = db.Words.Where(w => w.ContentId == savedContentId);
                    db.Words.RemoveRange(oldWords);

                    var oldSentences = db.Sentences.Where(s => s.ContentId == savedContentId);
                    db.Sentences.RemoveRange(oldSentences);

                    db.SaveChanges();
                }

                if (!string.IsNullOrEmpty(txtWordsBulk.Text.Trim()))
                {
                    var wordLines = txtWordsBulk.Text.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var line in wordLines)
                    {
                        var parts = line.Split('|');
                        if (parts.Length >= 2)
                        {
                            db.Words.Add(new Word()
                            {
                                ContentId = savedContentId,
                                Vocabulary = parts[0].Trim(),
                                Annotations = parts[1].Trim(),
                                CreatedAt = DateTime.Now,
                                UpdatedAt = DateTime.Now
                            });
                        }
                    }
                }

                if (!string.IsNullOrEmpty(txtSentencesBulk.Text.Trim()))
                {
                    var sentLines = txtSentencesBulk.Text.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var line in sentLines)
                    {
                        var parts = line.Split('|');
                        if (parts.Length >= 2)
                        {
                            db.Sentences.Add(new Sentence()
                            {
                                ContentId = savedContentId,
                                SentenceText = parts[0].Trim(),
                                Translate = parts[1].Trim(),
                                CreatedAt = DateTime.Now,
                                UpdatedAt = DateTime.Now
                            });
                        }
                    }
                }

                db.SaveChanges();

                Response.Redirect("ContentManage.aspx");
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error saving: " + ex.Message;
                lblMessage.BackColor = System.Drawing.Color.LightPink;
                lblMessage.Visible = true;
            }
        }
    }
}