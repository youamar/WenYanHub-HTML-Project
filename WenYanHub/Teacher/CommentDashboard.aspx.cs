using System;
using System.Linq;
using System.Data.Entity;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class CommentDashboard : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Retrieve the content ID passed through the URL query string
                string idStr = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idStr) && int.TryParse(idStr, out int contentId))
                {
                    LoadComments(contentId);
                }
            }
        }

        private void LoadComments(int contentId)
        {
            // Fetch content including the nested User property within Comments
            var content = db.Contents
                            .Include(c => c.Comments.Select(com => com.User))
                            .FirstOrDefault(c => c.ContentId == contentId);

            if (content != null)
            {
                // Update frontend Literal to show the specific scroll title
                litContentTitle.Text = content.Title;

                // Bind the comment list to the Repeater control
                rptStudentComments.DataSource = content.Comments.OrderByDescending(com => com.CreatedAt).ToList();
                rptStudentComments.DataBind();
            }
        }
    }
}