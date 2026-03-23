using System;
using System.Linq;
using System.Data.Entity;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class SubmissionManage : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAllPracticeStats();
            }
        }

        private void LoadAllPracticeStats()
        {
            try
            {
                // Removed .Where filter to show everything
                // Grouping by Practice to solve CS1061
                var stats = db.HomeworkSubmissions
                              .Include(s => s.Practice)
                              .GroupBy(s => new { s.PracticeId, s.Practice.Title })
                              .Select(g => new {
                                  PracticeId = g.Key.PracticeId,
                                  PracticeTitle = g.Key.Title,
                                  TotalCount = g.Count(),
                                  PendingCount = g.Count(s => s.Status == "Pending" || s.Score == null)
                              })
                              .ToList();

                if (stats.Any())
                {
                    // Binding to fix CS0103
                    rptPracticeStats.DataSource = stats;
                    rptPracticeStats.DataBind();
                    phEmpty.Visible = false;
                }
                else
                {
                    phEmpty.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Response.Write("<div style='color:red; padding:20px;'>Error: " + ex.Message + "</div>");
            }
        }
    }
}