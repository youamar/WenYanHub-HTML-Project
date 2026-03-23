using System;
using System.Web.UI.WebControls;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class EditPractice : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();
        int currentTeacherId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                currentTeacherId = Convert.ToInt32(Session["UserId"]);
            }

            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int practiceId = Convert.ToInt32(Request.QueryString["id"]);
                    LoadPracticeData(practiceId);
                }
            }
        }

        private void LoadPracticeData(int id)
        {
            var practice = db.Practices.Find(id);
            if (practice != null && practice.TeacherId != null)
            {
                hfPracticeId.Value = practice.PracticeId.ToString();
                txtTitle.Text = practice.Title;
                txtDescription.Text = practice.Description;
                txtDueDate.Text = practice.DueDate.ToString("yyyy-MM-dd");
                txtQuestionLink.Text = practice.QuestionFileUrl; // Load saved links
            }
            else
            {
                Response.Redirect("PracticeManage.aspx");
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                string title = txtTitle.Text.Trim();
                string description = txtDescription.Text.Trim();
                DateTime dueDate = Convert.ToDateTime(txtDueDate.Text);
                string driveLink = txtQuestionLink.Text.Trim(); 

                if (string.IsNullOrEmpty(driveLink))
                {
                    ShowError("Please provide a Google Drive link!");
                    return;
                }

                if (string.IsNullOrEmpty(hfPracticeId.Value))
                {
                    // 🌟 New logic: Store link
                    Practice newPractice = new Practice()
                    {
                        TeacherId = currentTeacherId,
                        Title = title,
                        Description = description,
                        DueDate = dueDate,
                        QuestionFileUrl = driveLink,
                        Approved = "Pending",
                        CreatedAt = DateTime.Now
                    };
                    db.Practices.Add(newPractice);
                }
                else
                {
                    int practiceId = Convert.ToInt32(hfPracticeId.Value);
                    var existPractice = db.Practices.Find(practiceId);

                    if (existPractice != null && existPractice.TeacherId != null)
                    {
                        existPractice.Title = title;
                        existPractice.Description = description;
                        existPractice.DueDate = dueDate;
                        existPractice.QuestionFileUrl = driveLink; // Update link
                        existPractice.Approved = "Pending";
                    }
                }

                db.SaveChanges();
                Response.Redirect("PracticeManage.aspx");
            }
            catch (Exception ex)
            {
                ShowError(ex.Message);
            }
        }

        private void ShowError(string msg)
        {
            lblMessage.Text = "🚨 Error: " + msg;
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Visible = true;
        }
    }
}