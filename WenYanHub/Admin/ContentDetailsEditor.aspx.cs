using System;
using System.Linq;
using System.Data.Entity;
using System.Web.UI.WebControls;
using WenYanHub.Models;

namespace WenYanHub.Admin
{
    public partial class ContentDetailsEditor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (int.TryParse(Request.QueryString["ContentId"], out int id))
                {
                    LoadDetailsData(id);
                }
                else
                {
                    Response.Redirect("ManageContent.aspx");
                }
            }
        }

        private void LoadDetailsData(int id)
        {
            using (var db = new AppDbContext())
            {
                var content = db.Contents
                    .Include(c => c.Sentences)
                    .Include(c => c.Words)
                    .Include(c => c.Author)
                    .FirstOrDefault(c => c.ContentId == id);

                if (content != null)
                {
                    lblTitle.Text = content.Title;

                    if (content.Author != null)
                    {
                        lblDynasty.Text = content.Author.Dynasty;
                        lnkAuthor.Text = "<i class=\"fa-solid fa-user-pen me-1\"></i>" + content.Author.Name;
                        lnkAuthor.NavigateUrl = "~/Admin/AdminAuthorProfile.aspx?id=" + content.AuthorId + "&returnUrl=" + Server.UrlEncode(Request.RawUrl);
                    }
                    else
                    {
                        lblDynasty.Text = "Unknown";
                        lnkAuthor.Text = "<i class=\"fa-solid fa-user-pen me-1\"></i>Anonymous";
                        lnkAuthor.NavigateUrl = "#";
                    }

                    rptSentences.DataSource = content.Sentences.ToList();
                    rptSentences.DataBind();

                    rptWords.DataSource = content.Words.ToList();
                    rptWords.DataBind();

                    gvSentences.DataSource = content.Sentences.ToList();
                    gvSentences.DataBind();

                    gvVocab.DataSource = content.Words.ToList();
                    gvVocab.DataBind();
                }
            }
        }

        protected void gvSentences_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvSentences.EditIndex = e.NewEditIndex;
            LoadDetailsData(int.Parse(Request.QueryString["ContentId"]));
        }

        protected void gvSentences_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvSentences.EditIndex = -1;
            LoadDetailsData(int.Parse(Request.QueryString["ContentId"]));
        }

        protected void gvSentences_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int sentenceId = Convert.ToInt32(gvSentences.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvSentences.Rows[e.RowIndex];

            string newText = (row.FindControl("txtClassical") as TextBox).Text;
            string newTranslation = (row.FindControl("txtEnglish") as TextBox).Text;

            using (var db = new AppDbContext())
            {
                var sentence = db.Sentences.Find(sentenceId);
                if (sentence != null)
                {
                    sentence.SentenceText = newText;
                    sentence.Translate = newTranslation;
                    db.SaveChanges();
                }
            }

            gvSentences.EditIndex = -1;
            LoadDetailsData(int.Parse(Request.QueryString["ContentId"]));
        }

        protected void gvVocab_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvVocab.EditIndex = e.NewEditIndex;
            LoadDetailsData(int.Parse(Request.QueryString["ContentId"]));
        }

        protected void gvVocab_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvVocab.EditIndex = -1;
            LoadDetailsData(int.Parse(Request.QueryString["ContentId"]));
        }

        protected void gvVocab_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int wordId = Convert.ToInt32(gvVocab.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvVocab.Rows[e.RowIndex];

            string newVocab = (row.FindControl("txtVocab") as TextBox).Text;
            string newPinyin = (row.FindControl("txtPinyin") as TextBox).Text;
            string newMeaning = (row.FindControl("txtMeaning") as TextBox).Text;

            using (var db = new AppDbContext())
            {
                var word = db.Words.Find(wordId);
                if (word != null)
                {
                    word.Vocabulary = newVocab;
                    word.Pinyin = newPinyin;
                    word.Annotations = newMeaning;
                    db.SaveChanges();
                }
            }

            gvVocab.EditIndex = -1;
            LoadDetailsData(int.Parse(Request.QueryString["ContentId"]));
        }
    }
}