using System;
using System.Linq;
using System.Web.UI;
using WenYanHub.Models;

namespace WenYanHub.Admin
{
    public partial class AdminAuthorProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Dynamic back button logic
                string returnUrl = Request.QueryString["returnUrl"];
                if (!string.IsNullOrEmpty(returnUrl))
                {
                    lnkBack.NavigateUrl = returnUrl;
                }
                else
                {
                    lnkBack.NavigateUrl = "ManageContent.aspx";
                    lnkBack.Text = "<i class=\"fa-solid fa-arrow-left me-2\"></i> Back to Library";
                }

                if (int.TryParse(Request.QueryString["id"], out int authorId))
                {
                    LoadAuthorData(authorId);
                }
                else
                {
                    Response.Redirect("ManageContent.aspx");
                }
            }
        }

        private void LoadAuthorData(int authorId)
        {
            using (var db = new AppDbContext())
            {
                var author = db.Author.FirstOrDefault(a => a.AuthorId == authorId);

                if (author != null)
                {
                    txtName.Text = author.Name;
                    txtDynasty.Text = author.Dynasty;
                    txtBiography.Text = author.Biography;
                    txtImageUrl.Text = author.Image;

                    if (!string.IsNullOrEmpty(author.Image))
                    {
                        imgPreview.ImageUrl = author.Image;
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (int.TryParse(Request.QueryString["id"], out int authorId))
            {
                using (var db = new AppDbContext())
                {
                    var author = db.Author.FirstOrDefault(a => a.AuthorId == authorId);

                    if (author != null)
                    {
                        author.Name = txtName.Text.Trim();
                        author.Dynasty = txtDynasty.Text.Trim();
                        author.Biography = txtBiography.Text.Trim();
                        author.Image = txtImageUrl.Text.Trim();

                        db.SaveChanges();

                        lblMessage.Text = "Author profile updated successfully!";
                        lblMessage.Visible = true;

                        if (!string.IsNullOrEmpty(author.Image))
                            imgPreview.ImageUrl = author.Image;
                    }
                }
            }
        }
    }
}