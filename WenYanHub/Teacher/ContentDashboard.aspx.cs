using System;
using System.Linq;
using System.Data.Entity;
using System.Web.UI.WebControls;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class ContentDashboard : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLeaderboard();
            }
        }

        private void LoadLeaderboard()
        {
            var leaderboard = db.Contents
                                .Include(c => c.Comments.Select(com => com.User))
                                .AsNoTracking()
                                .ToList()
                                .Select(c => new {
                                    c.ContentId,
                                    c.Title,
                                    CommentCount = c.Comments.Count,

                                    StudentComments = c.Comments
                                                       .OrderByDescending(com => com.CreatedAt)
                                                       .Select(com => new {
                                                           Username = com.User.Username,
                                                           CommentText = com.CommentText,
                                                           Date = com.CreatedAt.ToString("yyyy-MM-dd")
                                                       }).ToList()
                                })
                                .OrderByDescending(x => x.CommentCount)
                                .ToList();

            rptLeaderboard.DataSource = leaderboard;
            rptLeaderboard.DataBind();
        }
    }
}