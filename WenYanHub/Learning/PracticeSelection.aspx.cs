using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using WenYanHub.Models;

namespace WenYanHub.Learning
{
    public partial class PracticeSelection : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) Response.Redirect("~/Account/Login.aspx");
            if (!IsPostBack) BindPractices();
        }

        private void BindPractices()
        {
            int studentId = (int)Session["UserId"];
            using (var db = new AppDbContext())
            {
                DateTime now = DateTime.Now;
                var allData = (from p in db.Practices
                               join c in db.Contents on p.Title equals c.ContentId.ToString()
                               let sub = db.HomeworkSubmissions.FirstOrDefault(s => s.PracticeId == p.PracticeId && s.StudentId == studentId)
                               where p.DueDate > now
                               select new
                               {
                                   p.PracticeId,
                                   p.Description,
                                   p.DueDate,
                                   p.QuestionFileUrl,
                                   TeacherName = p.Teacher != null ? p.Teacher.Username : "Staff",
                                   ArticleTitle = c.Title,
                                   RawCategory = c.Category,
                                   HasSubmitted = sub != null,
                                   SubmissionStatus = sub != null ? sub.Status : "None",
                                   Score = sub != null ? sub.Score : 0,
                                   Comments = sub != null ? sub.TeacherComments : "",
                                   FeedbackFile = sub != null ? sub.TeacherFeedbackFileUrl : "",
                                   //Obtain the file path submitted by the student, which can be clicked to view.
                                   StudentFile = sub != null ? sub.StudentAnswerFileUrl : "",
                                   IsHidden = sub != null && sub.IsFeedbackHidden
                               }).ToList();

                rptJunior.DataSource = allData.Where(x => x.RawCategory?.Contains("Junior") == true).ToList();
                rptJunior.DataBind();
                pnlNoJunior.Visible = !allData.Any(x => x.RawCategory?.Contains("Junior") == true);

                rptSenior.DataSource = allData.Where(x => x.RawCategory?.Contains("Senior") == true).ToList();
                rptSenior.DataBind();
                pnlNoSenior.Visible = !allData.Any(x => x.RawCategory?.Contains("Senior") == true);

                rptExtra.DataSource = allData.Where(x => x.RawCategory?.Contains("Extra") == true || (x.RawCategory != null && !x.RawCategory.Contains("Junior") && !x.RawCategory.Contains("Senior"))).ToList();
                rptExtra.DataBind();
                pnlNoExtra.Visible = !allData.Any(x => x.RawCategory?.Contains("Extra") == true);
            }
        }

        public string GetItemHtml(object dataItem)
        {
            var p = (dynamic)dataItem;
            string collapseId = "task_" + p.PracticeId;
            string badgeClass = p.RawCategory.Contains("Junior") ? "bg-success" : (p.RawCategory.Contains("Senior") ? "bg-primary" : "bg-warning text-dark");

            string uploadSection = "";
            string tempFileKey = "TempFile_" + p.PracticeId;
            bool hasDraft = ViewState[tempFileKey] != null;

            if (!p.HasSubmitted)
            {
                if (!hasDraft)
                {
                    uploadSection = $@"
                        <div class='mt-3'>
                            <span class='section-title'>My Work</span>
                            <button type='button' class='btn btn-outline-secondary btn-sm border-dashed w-100 py-3' onclick='triggerUpload({p.PracticeId})'>
                                <i class='fa-solid fa-plus me-2'></i>Select PDF File
                            </button>
                        </div>";
                }
                else
                {
                    uploadSection = $@"
                        <div class='mt-3'>
                            <span class='section-title text-primary'>File Selected (Draft)</span>
                            <div class='file-card border-primary'>
                                <div class='pdf-icon-bg' style='background:#007bff'>PDF</div>
                                <div class='flex-grow-1 small fw-bold'>{ViewState[tempFileKey + "_Name"]}</div>
                            </div>
                            <button type='button' class='btn btn-dark w-100 rounded-pill mt-2 fw-bold' onclick='finalSubmit({p.PracticeId})'>Submit Assignment</button>
                            <button type='button' class='btn btn-link btn-sm w-100 text-danger mt-1' onclick='removeSub({p.PracticeId})'>Cancel</button>
                        </div>";
                }
            }
            else
            {
                string statusBadge = p.SubmissionStatus == "Graded" ? "bg-success" : "bg-info";
                uploadSection = $@"
                    <div class='mt-3'>
                        <span class='section-title'>Your Submission</span>
                        <div class='file-card'>
                            <div class='pdf-icon-bg'>PDF</div>
                            <div class='flex-grow-1'>
                                <a href='{p.StudentFile}' target='_blank' class='text-dark small fw-bold text-decoration-none'>Work_Submitted.pdf</a>
                            </div>
                            <span class='badge {statusBadge}'>{p.SubmissionStatus}</span>
                        </div>";

                if (p.SubmissionStatus == "Pending")
                {
                    uploadSection += $"<button type='button' class='btn btn-outline-danger btn-sm w-100 rounded-pill mt-2' onclick='removeSub({p.PracticeId})'><i class='fa-solid fa-trash-can me-2'></i>Remove Submission</button>";
                }
                else if (p.SubmissionStatus == "Graded")
                {
                    if (p.IsHidden)
                    {
                        uploadSection += $@"
                        <div class='feedback-card mt-3'>
                            <p class='small mb-0 text-secondary' style='font-style: italic;'>
                                <i class='fa-solid fa-circle-exclamation me-1'></i> The comment has been hidden by admin
                            </p>
                        </div>";
                    }
                    else
                    {
                        uploadSection += $@"
                        <div class='feedback-card mt-3'>
                            <h6 class='fw-bold text-danger'>Score: {p.Score} / 100</h6>
                            <p class='small mb-2 text-secondary'><b>Feedback:</b> {p.Comments}</p>
                            <a href='{p.FeedbackFile}' target='_blank' class='btn btn-sm btn-dark rounded-pill px-3'>View Graded Work</a>
                        </div>";
                    }
                }
                uploadSection += "</div>";
            }

            return $@"
            <div class='card mb-3 shadow-sm border-0 rounded-4 overflow-hidden'>
                <div class='card-body p-4 d-flex align-items-center justify-content-between hover-list-item' 
                     data-bs-toggle='collapse' data-bs-target='#{collapseId}'>
                    <div class='flex-grow-1'>
                        <div class='d-flex align-items-center mb-1'>
                            <span class='badge {badgeClass} bg-opacity-10 text-dark small'>{p.RawCategory}</span>
                            <small class='text-muted ms-3'><i class='fa-solid fa-user-tie me-1'></i> {p.TeacherName}</small>
                        </div>
                        <h4 class='font-classic fw-bold mb-0'>{p.ArticleTitle}</h4>
                        <div class='small text-danger mt-1'><i class='fa-regular fa-clock me-1'></i> Due: {p.DueDate:yyyy-MM-dd HH:mm}</div>
                    </div>
                    <i class='fa-solid fa-chevron-down text-muted'></i>
                </div>
                <div class='collapse' id='{collapseId}'>
                    <div class='task-detail-pane border-top'>
                        <div class='row'>
                            <div class='col-md-7 border-end pe-4'>
                                <span class='section-title'>Instructions</span>
                                <p class='text-secondary small mb-4'>{p.Description}</p>
                                <span class='section-title'>Materials</span>
                                <div class='file-card'>
                                    <div class='pdf-icon-bg'>PDF</div>
                                    <a href='{p.QuestionFileUrl}' target='_blank' class='text-dark small fw-bold text-decoration-none flex-grow-1'>Practice_Sheet.pdf</a>
                                </div>
                            </div>
                            <div class='col-md-5 ps-4'>{uploadSection}</div>
                        </div>
                    </div>
                </div>
            </div>";
        }

        protected void btnDoPreUpload_Click(object sender, EventArgs e)
        {
            if (!masterFileUpload.HasFile) return;
            string pid = hfTargetId.Value;
            string ext = Path.GetExtension(masterFileUpload.FileName).ToLower();
            if (ext != ".pdf") return;

            string fileName = $"Temp_{Session["UserId"]}_{pid}_{DateTime.Now.Ticks}.pdf";
            string path = Server.MapPath("~/Uploads/Submissions/");
            if (!Directory.Exists(path)) Directory.CreateDirectory(path);

            masterFileUpload.SaveAs(path + fileName);
            ViewState["TempFile_" + pid] = "/Uploads/Submissions/" + fileName;
            ViewState["TempFile_" + pid + "_Name"] = masterFileUpload.FileName;

            BindPractices();
        }

        protected void btnFinalSubmit_Click(object sender, EventArgs e)
        {
            string pid = hfTargetId.Value;
            string fileUrl = ViewState["TempFile_" + pid]?.ToString();
            if (string.IsNullOrEmpty(fileUrl)) return;

            int practiceId = int.Parse(pid);
            int studentId = (int)Session["UserId"];

            using (var db = new AppDbContext())
            {
                var practice = db.Practices.Find(practiceId);
                db.HomeworkSubmissions.Add(new HomeworkSubmission
                {
                    PracticeId = practiceId,
                    StudentId = studentId,
                    StudentAnswerFileUrl = fileUrl,
                    SubmittedAt = DateTime.Now,
                    Status = "Pending",
                    TeacherId = practice.TeacherId,
                    IsFeedbackHidden = false
                });
                db.SaveChanges();
            }
            ViewState["TempFile_" + pid] = null;
            BindPractices();
        }

        protected void btnRemoveSubmission_Click(object sender, EventArgs e)
        {
            string pid = hfTargetId.Value;
            int practiceId = int.Parse(pid);
            int studentId = (int)Session["UserId"];

            if (ViewState["TempFile_" + pid] != null)
            {
                ViewState["TempFile_" + pid] = null;
            }
            else
            {
                using (var db = new AppDbContext())
                {
                    var sub = db.HomeworkSubmissions.FirstOrDefault(s => s.PracticeId == practiceId && s.StudentId == studentId && s.Status == "Pending");
                    if (sub != null)
                    {
                        db.HomeworkSubmissions.Remove(sub);
                        db.SaveChanges();
                    }
                }
            }
            BindPractices();
        }
    }
}