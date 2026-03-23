using System;
using System.Linq;
using System.Web.UI;
using WenYanHub.Models;

namespace WenYanHub
{
    public partial class AuthorProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Get the 'id' parameter from URL (e.g., ?id=5)
                string authorIdStr = Request.QueryString["id"];

                // 2. Validate if ID is a valid integer
                if (int.TryParse(authorIdStr, out int authorId))
                {
                    LoadAuthorData(authorId);
                }
                else
                {
                    // Invalid ID: Redirect back to the Library/Index page
                    Response.Redirect("~/Contents/Index.aspx");
                }
            }
        }

        private void LoadAuthorData(int authorId)
        {
            // Use Entity Framework DbContext instead of raw SQL connection strings
            using (var db = new AppDbContext())
            {
                try
                {
                    // ============================================
                    // Step A: Query Author Information
                    // ============================================
                    var author = db.Author.FirstOrDefault(a => a.AuthorId == authorId);

                    if (author != null)
                    {
                        // Bind basic info to UI labels
                        lblName.Text = author.Name;
                        lblDynasty.Text = author.Dynasty;

                        // Bind Biography (Convert newlines to HTML line breaks)
                        if (!string.IsNullOrEmpty(author.Biography))
                        {
                            litBio.Text = author.Biography.Replace("\n", "<br/>");
                        }
                        else
                        {
                            litBio.Text = "No biography available.";
                        }

                        // Handle Profile Image (If not null, use it; otherwise, UI keeps default)
                        if (!string.IsNullOrEmpty(author.Image))
                        {
                            imgAuthor.ImageUrl = author.Image;
                        }

                        // ============================================
                        // Step B: Query Works List (Contents Table)
                        // ============================================
                        // Fetch all contents written by this author
                        var works = db.Contents
                                      .Where(c => c.AuthorId == authorId)
                                      .OrderBy(c => c.ContentId)
                                      .ToList();

                        // Bind the data to the Repeater control
                        rptWorks.DataSource = works;
                        rptWorks.DataBind();

                        // Update the "Collected Works" counter on the left card
                        lblWorksCount.Text = works.Count.ToString();

                        // If no works found, show the "Empty State" panel
                        pnlNoWorks.Visible = (works.Count == 0);
                    }
                    else
                    {
                        // Author ID not found in database -> Redirect
                        Response.Redirect("~/Contents/Index.aspx");
                    }
                }
                catch (Exception ex)
                {
                    // Log the error in a real app
                    // System.Diagnostics.Debug.WriteLine(ex.Message);
                }
            }
        }

        protected string GetExcerpt(object contentObj)
        {
            if (contentObj == null || string.IsNullOrWhiteSpace(contentObj.ToString()))
            {
                return "暂无内容简介..."; // 如果数据库里刚好没有内容，给个默认值
            }

            string text = contentObj.ToString().Trim();

            // 清理掉可能存在的换行符，让它保持在一行
            text = text.Replace("\r", "").Replace("\n", "");

            // 截取前 30 个字，如果不够 30 个字就完整显示
            int maxLength = 30;
            if (text.Length > maxLength)
            {
                return text.Substring(0, maxLength) + "......";
            }

            return text;
        }
    }
}