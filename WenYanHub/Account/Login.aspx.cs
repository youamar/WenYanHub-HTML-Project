using System;
using System.Linq;
using System.Web.UI;
using WenYanHub.Models;
using BCrypt.Net;

namespace WenYanHub.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["registered"] == "true")
                {
                    pnlSuccess.Visible = true;
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string inputUsernameOrEmail = txtUsername.Text.Trim();
            string inputPassword = txtPassword.Text; 

            if (string.IsNullOrEmpty(inputUsernameOrEmail) || string.IsNullOrEmpty(inputPassword))
            {
                ShowError("Please enter both username/email and password.");
                return;
            }

            using (var db = new AppDbContext())
            {
                var user = db.Users.FirstOrDefault(u => u.Username == inputUsernameOrEmail || u.MailAddress == inputUsernameOrEmail);

                if (user != null)
                {
                    string storedHashedPassword = user.Password;
                    bool isPasswordValid = BCrypt.Net.BCrypt.Verify(inputPassword, storedHashedPassword);

                    if (isPasswordValid)
                    {
                        Session["FailedAttempts"] = 0;

                        Session["UserId"] = user.UserId;
                        Session["Username"] = user.Username;
                        Session["Role"] = user.Role;

                        GenerateLoginReport(db, user.UserId, user.Role);

                        string returnUrl = Request.QueryString["ReturnUrl"];

                        if (!string.IsNullOrEmpty(returnUrl) && (returnUrl.StartsWith("/") || returnUrl.StartsWith("~")))
                        {
                            Response.Redirect(returnUrl);
                        }
                        else
                        {
                            if (user.Role == "Admin")
                            {
                                Response.Redirect("~/Admin/AdminDashboard.aspx");
                            }
                            else if (user.Role == "Teacher")
                            {
                                Response.Redirect("~/Teacher/TeacherDashboard.aspx");
                            }
                            else
                            {
                                Response.Redirect("~/Others/Default.aspx");
                            }
                        }
                    }
                    else
                    {
                        // ❌ FAILED LOGIN: Increase the counter
                        HandleFailedLogin(inputUsernameOrEmail);
                        ShowError("Username/Email and Password mismatch!");
                    }
                }
                else
                {
                    // ❌ USER NOT FOUND: Also treat this as a failed login attempt for security tracking
                    HandleFailedLogin(inputUsernameOrEmail);
                    ShowError("User does not exist.");
                }
            }
        }

        private void HandleFailedLogin(string attemptedEmailOrUser)
        {
            int failedAttempts = Session["FailedAttempts"] != null ? (int)Session["FailedAttempts"] : 0;
            failedAttempts++;
            Session["FailedAttempts"] = failedAttempts;

            // Trigger the security log if it hits 3 failed attempts
            if (failedAttempts >= 3)
            {
                using (var db = new AppDbContext())
                {
                    // Find the FIRST Admin in the database to securely attach the log to
                    var adminUser = db.Users.FirstOrDefault(u => u.Role == "Admin");
                    int fallbackAdminId = adminUser != null ? adminUser.UserId : 1;

                    WenYanHub.Admin.Utils.SystemLogger.LogEvent(fallbackAdminId, "Brute Force Warning", "Security", $"{{ \"target_account\": \"{attemptedEmailOrUser}\", \"failed_attempts\": {failedAttempts} }}");
                }
            }
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }

        private void GenerateLoginReport(AppDbContext db, int userId, string role)
        {
            if (role == "Admin" || role == "Teacher")
            {
                var loginReport = new SystemReport
                {
                    GeneratedByUserId = userId,
                    ReportName = $"{role} Login Record",
                    ReportType = "System Access",
                    ReportData = $"{{\"Action\": \"Login\", \"Role\": \"{role}\", \"Status\": \"Success\"}}",
                    GeneratedAt = DateTime.Now
                };

                db.SystemReports.Add(loginReport);
                db.SaveChanges();
            }
        }
    }
}