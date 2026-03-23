using System;
using System.Linq;
using System.Data.Entity;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class EvaluateHomework : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) Response.Redirect("~/account/Login.aspx");

            if (!IsPostBack)
            {
                // Retrieve sid from URL
                if (int.TryParse(Request.QueryString["sid"], out int sid))
                {
                    LoadSubmission(sid);
                }
            }
        }

        private void LoadSubmission(int sid)
        {
            var sub = db.HomeworkSubmissions.Include(s => s.Student).FirstOrDefault(s => s.SubmissionId == sid);
            if (sub != null)
            {
                hfSubmissionId.Value = sub.SubmissionId.ToString();
                hfPracticeId.Value = sub.PracticeId.ToString();
                litStudentName.Text = sub.Student.Username;
                litSubmittedAt.Text = sub.SubmittedAt.ToString("yyyy-MM-dd HH:mm");
                hlStudentFile.NavigateUrl = sub.StudentAnswerFileUrl;

                // FIX: Support decimal(5,2) display format
                if (sub.Score.HasValue) txtScore.Text = sub.Score.Value.ToString("F2");
                txtComments.Text = sub.TeacherComments;
                txtFeedbackUrl.Text = sub.TeacherFeedbackFileUrl;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int sid = Convert.ToInt32(hfSubmissionId.Value);
            var sub = db.HomeworkSubmissions.Find(sid);

            if (sub != null)
            {
                // FIX: Parse as decimal to match DB type decimal(5,2)
                if (decimal.TryParse(txtScore.Text, out decimal grade))
                {
                    // Validation: Prevent Arithmetic Overflow (max 999.99 for decimal(5,2))
                    if (grade >= 1000)
                    {
                        Response.Write("<script>alert('Error: Score must be less than 1000.');</script>");
                        return;
                    }

                    sub.Score = grade;
                    sub.TeacherComments = txtComments.Text.Trim();
                    sub.TeacherFeedbackFileUrl = txtFeedbackUrl.Text.Trim();
                    sub.Status = "Graded"; // Update status to Graded
                    sub.GradedAt = DateTime.Now;
                    sub.TeacherId = Convert.ToInt32(Session["UserId"]);

                    db.SaveChanges();

                    // Redirect back to the scholar list for this practice
                    Response.Redirect("GradePracticeDetail.aspx?practiceId=" + hfPracticeId.Value);
                }
            }
        }
    }
}