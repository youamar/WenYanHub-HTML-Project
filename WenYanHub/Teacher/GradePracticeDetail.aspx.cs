using System;
using System.Linq;
using System.Data.Entity;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class GradePracticeDetail : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && int.TryParse(Request.QueryString["practiceId"], out int pId))
            {
                LoadByPractice(pId);
            }
        }

        private void LoadByPractice(int pId)
        {
            var practice = db.Practices.Find(pId);
            if (practice != null) litContentTitle.Text = practice.Title;

            // Fetching ALL submissions for this practice
            var submissions = db.HomeworkSubmissions
                                .Include(s => s.Student)
                                .Where(s => s.PracticeId == pId)
                                .OrderBy(s => s.Status) // Pending first
                                .ThenByDescending(s => s.SubmittedAt)
                                .ToList();

            rptStudents.DataSource = submissions;
            rptStudents.DataBind();
        }
    }
}