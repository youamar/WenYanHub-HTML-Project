using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WenYanHub.Models; 

namespace WenYanHub.Learning
{
    public partial class Game_result : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Retrieve URL parameters
                string scoreStr = Request.QueryString["finalScore"];
                string cidStr = Request.QueryString["cid"];

                if (int.TryParse(scoreStr, out int score) && int.TryParse(cidStr, out int cid))
                {
                    lblFinalScore.Text = $"{score} / 1000";

                    if (score >= 1000) lblEvaluation.Text = "Master of Classics: Peerless and Extraordinary";
                    else if (score >= 800) lblEvaluation.Text = "Top Scholar: Highly Knowledgeable";
                    else if (score >= 400) lblEvaluation.Text = "Developing Scholar: Keep Pushing Forward";
                    else lblEvaluation.Text = "Novice Disciple: Practice Makes Perfect";

                    // 3. Execute the core requirement: Store in the database
                    SaveQuizResult(cid, score);
                }
                else
                {
                    // If parameters are missing, you will be redirected back to the selection page.
                    Response.Redirect("Quiz.aspx");
                }
            }
        }

        private void SaveQuizResult(int cid, int score)
        {
            // Get the currently logged-in user ID
            if (Session["UserId"] == null) return;
            int userId = Convert.ToInt32(Session["UserId"]);

            using (var db = new AppDbContext())
            {
                try
                {
                    // Check if this user has already performed a quiz for this ContentId.
                    var record = db.QuizScores.FirstOrDefault(r => r.UserId == userId && r.ContentId == cid);

                    if (record == null)
                    {
                        // First time: Create a new record, AttemptNumber is 1
                        db.QuizScores.Add(new QuizScore
                        {
                            UserId = userId,
                            ContentId = cid,
                            Score = score,
                            AttemptNumber = 1,
                            TakenAt = DateTime.Now
                        });
                    }
                    else
                    {
                        // Already done: Compare scores, update if the new score is higher.
                        if (score > record.Score)
                        {
                            record.Score = score;
                        }

                        // Regardless of the score, increment the number of attempts (AttemptNumber) by 1 and update the time.
                        record.AttemptNumber += 1;
                        record.TakenAt = DateTime.Now;
                    }

                    db.SaveChanges();
                }
                catch (Exception ex)
                {
                    Response.Write("");
                }
            }
        }

        protected void btnRetry_Click(object sender, EventArgs e)
        {
            // To retry, you need to bring back cid; otherwise, Mini_Game won't get the question.
            string cid = Request.QueryString["cid"];
            Response.Redirect($"Mini_Game.aspx?cid={cid}");
        }

        protected void btnBackHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Quiz.aspx");
        }

        protected void btnLeaderboard_Click(object sender, EventArgs e)
        {
            // Get the current ContentId
            string cid = Request.QueryString["cid"];
            // Jump to and carry cid
            Response.Redirect($"Leaderboard.aspx?cid={cid}");
        }
    }
}