using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WenYanHub.Models;
using System.Data.Entity;

namespace WenYanHub.Learning
{
    public partial class Quiz : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null)
                {
                    Response.Redirect("~/Account/Login.aspx");
                    return;
                }
                BindGames();
            }
        }

        private void BindGames()
        {
            int userId = (int)Session["UserId"];

            using (var db = new AppDbContext())
            {
                var completedContentIds = db.QuizScores
                                            .Where(s => s.UserId == userId)
                                            .Select(s => s.ContentId)
                                            .ToList();

                var allContents = db.Contents.ToList().Select(c => new {
                    c.ContentId,
                    c.Title,
                    c.Category,
                    IsDone = completedContentIds.Contains(c.ContentId)
                }).ToList();

                var juniorGames = allContents
                    .Where(c => c.Category != null && c.Category.IndexOf("Junior", StringComparison.OrdinalIgnoreCase) >= 0)
                    .OrderBy(c => c.Title)
                    .ToList();

                var seniorGames = allContents
                    .Where(c => c.Category != null && c.Category.IndexOf("Senior", StringComparison.OrdinalIgnoreCase) >= 0)
                    .OrderBy(c => c.Title)
                    .ToList();

                rptJuniorGames.DataSource = juniorGames;
                rptJuniorGames.DataBind();
                lblNoJunior.Visible = (juniorGames.Count == 0);

                rptSeniorGames.DataSource = seniorGames;
                rptSeniorGames.DataBind();
                lblNoSenior.Visible = (seniorGames.Count == 0);
            }
        }
    }
}