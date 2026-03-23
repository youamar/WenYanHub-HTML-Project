using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using WenYanHub.Models;

namespace WenYanHub.Learning
{
    public partial class Leaderboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get the ContentId passed from the URL
                if (int.TryParse(Request.QueryString["cid"], out int cid))
                {
                    LoadRankings(cid);
                }
                else
                {
                    Response.Redirect("Quiz.aspx");
                }
            }
        }

        private void LoadRankings(int cid)
        {
            int currentUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 0;

            using (var db = new AppDbContext())
            {
                var content = db.Contents.FirstOrDefault(c => c.ContentId == cid);
                if (content != null)
                {
                    // Set the title at the top of the page to the corresponding Chinese title.
                    lblContentTitle.Text = content.Title;
                }

                // 1. Perform a union query to retrieve the score and username
                var query = (from s in db.QuizScores
                             join u in db.Users on s.UserId equals u.UserId
                             where s.ContentId == cid
                             orderby s.Score descending, s.TakenAt ascending
                             select new
                             {
                                 u.Username,
                                 s.Score,
                                 s.UserId
                             }).ToList();

                // 2. Mapping ranked objects
                var rankedList = query.Select((item, index) => new
                {
                    Rank = index + 1,
                    Username = item.Username,
                    Score = (int)item.Score,
                    IsCurrentUser = item.UserId == currentUserId
                }).ToList();

                // 3. The top 3 will be assigned to the podium.
                rptPodium.DataSource = rankedList.Take(3).ToList();
                rptPodium.DataBind();

                // 4. Bind names 4-10 to a list
                if (rankedList.Count > 3)
                {
                    rptOthers.DataSource = rankedList.Skip(3).Take(7).ToList();
                    rptOthers.DataBind();
                }
            }
        }

        public string GetMedal(object rank)
        {
            int r = Convert.ToInt32(rank);
            if (r == 1) return "🥇";
            if (r == 2) return "🥈";
            if (r == 3) return "🥉";
            return "";
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Quiz.aspx");
        }
    }
}