using System;
using System.Data.Entity;
using System.Linq;
using System.Web.UI;
using WenYanHub.Models;

namespace WenYanHub.Contents
{
    public partial class Details : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Validate ID from QueryString
                if (int.TryParse(Request.QueryString["id"], out int id))
                {
                    LoadContent(id);
                }
                else
                {
                    // Redirect to home if ID is invalid
                    Response.Redirect("Index.aspx");
                }
            }

            // Note: Login check is no longer needed here since Comments feature was moved to Intro.aspx
        }

        private void LoadContent(int id)
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
                    // Set Page Title for browser tab
                    Page.Title = content.Title + " - Detailed Study";

                    // Bind Basic Info to Header
                    lblTitle.Text = content.Title;

                    if (content.Author != null)
                    {
                        // 💡 Requirement 2: Make Author clickable and redirect to AuthorProfile
                        lnkAuthor.Text = content.Author.Name;
                        lnkAuthor.NavigateUrl = $"/Contents/AuthorProfile.aspx?id={content.Author.AuthorId}";
                        lblDynasty.Text = content.Author.Dynasty;
                    }
                    else
                    {
                        // Fallback if no author is linked in DB
                        lnkAuthor.Text = "Anonymous";
                        lnkAuthor.NavigateUrl = "#"; // Disable link
                        lblDynasty.Text = "Unknown";
                    }

                    // Bind Data to Repeaters
                    rptSentences.DataSource = content.Sentences;
                    rptSentences.DataBind();

                    rptWords.DataSource = content.Words;
                    rptWords.DataBind();
                }
                else
                {
                    // Redirect if article is not found in database
                    Response.Redirect("Index.aspx");
                }
            }
        }
    }
}