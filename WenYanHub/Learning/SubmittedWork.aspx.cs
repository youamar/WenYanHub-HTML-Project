using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using WenYanHub.Models;

namespace WenYanHub.Learning
{
    public partial class SubmittedWork : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) Response.Redirect("~/Account/Login.aspx");
            if (!IsPostBack) BindWork();
        }

        private void BindWork()
        {
            int studentId = (int)Session["UserId"];
            using (var db = new AppDbContext())
            {
                // 1. Data retrieval via query
                var allData = (from s in db.HomeworkSubmissions
                               join p in db.Practices on s.PracticeId equals p.PracticeId
                               join c in db.Contents on p.Title equals c.ContentId.ToString()
                               where s.StudentId == studentId
                               orderby s.SubmittedAt descending
                               select new
                               {
                                   s.SubmissionId,
                                   s.Status,
                                   s.Score,
                                   s.SubmittedAt,
                                   s.StudentAnswerFileUrl,
                                   s.TeacherComments,
                                   s.TeacherFeedbackFileUrl,
                                   s.IsFeedbackHidden, 
                                   ArticleTitle = c.Title,
                                   Description = p.Description,
                                   QuestionUrl = p.QuestionFileUrl,
                                   TeacherName = s.Teacher != null ? s.Teacher.Username : "Teacher"
                               }).ToList();

                // 2. Bind All Work and check for empty state
                rptAll.DataSource = allData;
                rptAll.DataBind();
                pnlNoWorkAll.Visible = (allData.Count == 0);

                // 3. Bind Pending and check for empty state
                var pendingData = allData.Where(x => x.Status == "Pending").ToList();
                rptPending.DataSource = pendingData;
                rptPending.DataBind();
                pnlNoWorkPending.Visible = (pendingData.Count == 0);

                // 4. Bind Returned (Graded) and check for empty state
                var gradedData = allData.Where(x => x.Status == "Graded").ToList();
                rptGraded.DataSource = gradedData;
                rptGraded.DataBind();
                pnlNoWorkGraded.Visible = (gradedData.Count == 0);
            }
        }

        public string RenderWorkItem(object dataItem)
        {
            var s = (dynamic)dataItem;
            string collapseId = "collapse_" + s.SubmissionId;
            string statusBadge = s.Status == "Graded" ? "bg-success" : "bg-warning text-dark";

            // Handling Feedback Display or Hide
            string feedbackHtml = "";
            if (s.Status == "Graded")
            {
                if (s.IsFeedbackHidden)
                {
                    // Administrator hidden state
                    feedbackHtml = $@"
                        <div class='feedback-card mt-3'>
                            <p class='small mb-0 text-secondary' style='font-style: italic;'>
                                <i class='fa-solid fa-circle-exclamation me-1'></i> The comment has been hidden by admin
                            </p>
                        </div>";
                }
                else
                {
                    // Normal display status
                    feedbackHtml = $@"
                        <div class='feedback-card mt-3'>
                            <h6 class='fw-bold text-danger'>Score: {s.Score} / 100</h6>
                            <p class='small mb-2'><b>Comments:</b> {s.TeacherComments}</p>
                            <a href='{s.TeacherFeedbackFileUrl}' class='btn btn-sm btn-outline-dark' target='_blank'>View Graded Work</a>
                        </div>";
                }
            }
            else
            {
                feedbackHtml = "<p class='text-muted small mt-3 fst-italic'>Pending review...</p>";
            }

            string removeButtonHtml = s.Status == "Pending" ? $@"
                <div class='mt-4 pt-3 border-top'>
                    <button type='button' class='btn btn-outline-danger btn-sm rounded-pill px-3' 
                        onclick=""triggerRemove('{s.SubmissionId}')"">
                        <i class='fa-solid fa-trash-can me-1'></i> Remove Submission
                    </button>
                </div>" : "";

            return $@"
            <div class='card mb-3 border-0 shadow-sm rounded-4'>
                <div class='card-body p-4 d-flex align-items-center justify-content-between hover-list-item' 
                     style='cursor:pointer' data-bs-toggle='collapse' data-bs-target='#{collapseId}'>
                    <div>
                        <span class='badge {statusBadge} rounded-pill mb-2'>{s.Status}</span>
                        <h4 class='article-title font-classic fw-bold'>{s.ArticleTitle}</h4>
                        <small class='text-muted'>Submitted: {s.SubmittedAt:yyyy-MM-dd HH:mm}</small>
                    </div>
                    <i class='fa-solid fa-chevron-down text-muted'></i>
                </div>
                <div class='collapse' id='{collapseId}'>
                    <div class='task-detail-pane border-top p-4 bg-white'>
                        <div class='row'>
                            <div class='col-md-7 border-end'>
                                <h6 class='fw-bold text-brown'><i class='fa-solid fa-info-circle me-2'></i>Instructions</h6>
                                <p class='text-secondary small mb-4'>{s.Description}</p>

                                <h6 class='fw-bold text-brown'><i class='fa-solid fa-book me-2'></i>Teacher Resources</h6>
                                <div class='file-card mb-4'>
                                    <div class='pdf-icon-bg'>PDF</div>
                                    <a href='{s.QuestionUrl}' target='_blank' class='text-dark small fw-bold text-decoration-none'>Assignment_Materials.pdf</a>
                                </div>

                                <h6 class='fw-bold text-brown'><i class='fa-solid fa-file-user me-2'></i>Your Submission</h6>
                                <div class='file-card' style='border-left: 4px solid #2ecc71;'>
                                    <div class='pdf-icon-bg' style='background:#2ecc71'>MY PDF</div>
                                    <a href='{s.StudentAnswerFileUrl}' target='_blank' class='text-dark small fw-bold text-decoration-none'>My_Work_Submitted.pdf</a>
                                </div>
                            </div>
                            <div class='col-md-5 ps-4'>
                                <h6 class='fw-bold text-brown'>Feedback & Status</h6>
                                <small class='text-muted'>Instructor: {s.TeacherName}</small>
                                {feedbackHtml}
                                {removeButtonHtml}
                            </div>
                        </div>
                    </div>
                </div>
            </div>";
        }

        protected void btnHiddenDelete_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hfSubmissionIdToDelete.Value, out int subId))
            {
                int currentStudentId = (int)Session["UserId"];
                using (var db = new AppDbContext())
                {
                    var sub = db.HomeworkSubmissions.FirstOrDefault(x => x.SubmissionId == subId && x.StudentId == currentStudentId);
                    if (sub != null && sub.Status == "Pending")
                    {
                        db.HomeworkSubmissions.Remove(sub);
                        db.SaveChanges();
                        BindWork();
                    }
                }
            }
        }
    }
}