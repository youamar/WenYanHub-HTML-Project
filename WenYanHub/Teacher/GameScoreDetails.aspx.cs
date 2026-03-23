using System;
using System.Linq;
using System.Data.Entity;
using System.Web.UI;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class GameScoreDetails : Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string idQuery = Request.QueryString["contentId"];
                if (!string.IsNullOrEmpty(idQuery) && int.TryParse(idQuery, out int contentId))
                {
                    LoadScholarScores(contentId);
                }
            }
        }

        private void LoadScholarScores(int contentId)
        {
            // Get the specific title for the header
            litGameTitle.Text = db.Contents.Where(c => c.ContentId == contentId).Select(c => c.Title).FirstOrDefault() ?? "Unknown Game";

            // Fetching individual scores and linking to User profiles
            var studentScores = db.QuizScores
                                  .Include(q => q.User)
                                  .Where(q => q.ContentId == contentId)
                                  .OrderByDescending(q => q.Score) // Ranking students by wisdom/score
                                  .ToList();

            rptStudentScores.DataSource = studentScores;
            rptStudentScores.DataBind();
        }
    }
}