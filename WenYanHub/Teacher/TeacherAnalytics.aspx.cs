using System;
using System.Linq;
using System.Data.Entity;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class TeacherAnalytics : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/account/Login.aspx");
                return;
            }

            int currentUserId = Convert.ToInt32(Session["UserId"]);

            if (!IsPostBack)
            {
                LoadTeacherAnalytics(currentUserId);
            }
        }

        private void LoadTeacherAnalytics(int teacherId)
        {
            // 1. Lessons
            var contents = db.Contents.Where(c => c.TeacherId == teacherId).OrderByDescending(c => c.CreatedAt).ToList();
            litContentsCount.Text = contents.Count.ToString();
            gvContents.DataSource = contents;
            gvContents.DataBind();

            // 2. Scholar Notes
            var notes = db.Notes.Include(n => n.Content).Where(n => n.TeacherId == teacherId).OrderByDescending(n => n.CreatedAt).ToList();
            litNotesCount.Text = notes.Count.ToString();
            gvNotes.DataSource = notes;
            gvNotes.DataBind();

            // 3. Practices
            var practices = db.Practices.Where(p => p.TeacherId == teacherId).OrderByDescending(p => p.CreatedAt).ToList();
            litPracticesCount.Text = practices.Count.ToString();
            gvPractices.DataSource = practices;
            gvPractices.DataBind();

            // 4. Videos
            var videos = db.VideoRecords.Include(v => v.Content).Where(v => v.TeacherId == teacherId).OrderByDescending(v => v.CreatedAt).ToList();
            litVideosCount.Text = videos.Count.ToString();
            gvVideos.DataSource = videos;
            gvVideos.DataBind();

            // 5. Graded Homework
            var submissions = db.HomeworkSubmissions.Include(s => s.Student).Include(s => s.Practice)
                                                    .Where(s => s.TeacherId == teacherId && s.GradedAt != null)
                                                    .OrderByDescending(s => s.GradedAt).ToList();
            litGradedCount.Text = submissions.Count.ToString();
            gvSubmissions.DataSource = submissions;
            gvSubmissions.DataBind();
        }
    }
}