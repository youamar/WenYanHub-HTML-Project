using System;
using System.Linq;
using System.Web;
using System.IO;
using System.Data.Entity;
using WenYanHub.Models;

namespace WenYanHub.Learning
{
    public partial class Practice : System.Web.UI.Page
    {
        private int currentPracticeId;
        private int currentStudentId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) Response.Redirect("~/Account/Login.aspx");
            currentStudentId = (int)Session["UserId"];

            if (!int.TryParse(Request.QueryString["id"], out currentPracticeId)) Response.Redirect("PracticeSelection.aspx");

            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            using (var db = new AppDbContext())
            {
                // 1. 加载练习信息 & 教师名称
                var task = (from p in db.Practices
                            join c in db.Contents on p.Title equals c.ContentId.ToString()
                            join u in db.Users on p.TeacherId equals u.UserId
                            where p.PracticeId == currentPracticeId
                            select new { p, ArticleTitle = c.Title, TeacherName = u.Username }).FirstOrDefault();

                if (task != null)
                {
                    litArticleTitle.Text = task.ArticleTitle;
                    litTeacherName.Text = task.TeacherName;
                    litDescription.Text = task.p.Description;
                    litDueDate.Text = task.p.DueDate.ToString("MMM dd, yyyy HH:mm");
                    lnkQuestionFile.NavigateUrl = task.p.QuestionFileUrl;
                    ViewState["TeacherId"] = task.p.TeacherId;
                }

                // 2. 加载学生提交状态
                var sub = db.HomeworkSubmissions.FirstOrDefault(s => s.PracticeId == currentPracticeId && s.StudentId == currentStudentId);
                if (sub != null)
                {
                    ShowFilePreview(Path.GetFileName(sub.StudentAnswerFileUrl), "Already Submitted");
                    ViewState["CurrentFileUrl"] = sub.StudentAnswerFileUrl;
                    btnFinalSubmit.Visible = false; // 已提交则隐藏按钮

                    if (sub.Status == "Graded")
                    {
                        pnlFeedback.Visible = true;
                        litScore.Text = sub.Score.ToString();
                        litComments.Text = sub.TeacherComments;
                        lnkFeedbackFile.NavigateUrl = sub.TeacherFeedbackFileUrl;
                        btnRemove.Visible = false; // 已评分不能移除
                    }
                }
                else
                {
                    // 如果刚上传但没按 Submit，从 ViewState 恢复预览
                    if (ViewState["TempFileUrl"] != null)
                    {
                        ShowFilePreview(ViewState["TempFileName"].ToString(), "Not Submitted Yet");
                        btnFinalSubmit.Visible = true;
                    }
                }
            }
        }

        // 处理文件预上传（自动触发）
        protected override void OnPreRender(EventArgs e)
        {
            if (IsPostBack && fileInput.HasFile)
            {
                HandleFileUpload();
            }
            base.OnPreRender(e);
        }

        private void HandleFileUpload()
        {
            string ext = Path.GetExtension(fileInput.FileName).ToLower();
            if (ext != ".pdf") { lblMsg.Text = "Only PDF allowed!"; return; }

            string fileName = $"Temp_{currentStudentId}_{DateTime.Now.Ticks}.pdf";
            string folder = Server.MapPath("~/Uploads/Submissions/");
            if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);

            string path = Path.Combine(folder, fileName);
            fileInput.SaveAs(path);

            ViewState["TempFileUrl"] = "/Uploads/Submissions/" + fileName;
            ViewState["TempFileName"] = fileInput.FileName;

            ShowFilePreview(fileInput.FileName, "Draft - Click Submit to Finish");
            btnFinalSubmit.Visible = true;
        }

        // 正式提交到数据库
        protected void btnFinalSubmit_Click(object sender, EventArgs e)
        {
            if (ViewState["TempFileUrl"] == null) return;

            using (var db = new AppDbContext())
            {
                var sub = new HomeworkSubmission
                {
                    PracticeId = currentPracticeId,
                    StudentId = currentStudentId,
                    StudentAnswerFileUrl = ViewState["TempFileUrl"].ToString(),
                    SubmittedAt = DateTime.Now,
                    Status = "Pending",
                    TeacherId = (int)ViewState["TeacherId"]
                };
                db.HomeworkSubmissions.Add(sub);
                db.SaveChanges();
            }
            ViewState["TempFileUrl"] = null;
            Response.Redirect(Request.RawUrl); // 刷新页面
        }

        // 移除功能
        protected void btnRemove_Click(object sender, EventArgs e)
        {
            using (var db = new AppDbContext())
            {
                var sub = db.HomeworkSubmissions.FirstOrDefault(s => s.PracticeId == currentPracticeId && s.StudentId == currentStudentId);
                if (sub != null)
                {
                    db.HomeworkSubmissions.Remove(sub);
                    db.SaveChanges();
                }
            }
            ViewState["TempFileUrl"] = null;
            Response.Redirect(Request.RawUrl);
        }

        private void ShowFilePreview(string fileName, string status)
        {
            pnlWorkPreview.Visible = true;
            phUploadArea.Visible = false;
            lblFileName.Text = fileName;
            lblSubmitStatus.Text = status;
        }
    }
}