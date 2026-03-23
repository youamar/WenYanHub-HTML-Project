using System;
using System.Linq;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class GameLeaderboard : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) Response.Redirect("~/account/Login.aspx");
            if (!IsPostBack) BindLeaderboard();
        }

        private void BindLeaderboard()
        {

            var leaderboard = db.QuizScores
                .GroupBy(q => q.ContentId)
                .Select(g => new {
                    ContentId = g.Key,
                    ContentTitle = db.Contents.Where(c => c.ContentId == g.Key).Select(c => c.Title).FirstOrDefault() ?? "Unknown Scroll",
                    AvgScore = Math.Round(g.Average(q => q.Score), 1),

                    ScholarScores = db.QuizScores
                        .Where(qs => qs.ContentId == g.Key)
                        .OrderByDescending(qs => qs.Score)
                        .Select(qs => new {
                            Username = qs.User.Username,
                            Score = qs.Score
                        }).ToList()
                })
                .OrderByDescending(x => x.AvgScore)
                .ToList();

            rptLeaderboard.DataSource = leaderboard;
            rptLeaderboard.DataBind();
        }
    }
}