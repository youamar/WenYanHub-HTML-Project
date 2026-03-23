using System;
using System.Linq;
using System.Web.UI;
using System.Text.RegularExpressions;
using System.Net;
using System.Net.Mail;
using System.Web.Configuration;
using WenYanHub.Models;
using BCrypt.Net;

namespace WenYanHub.Account
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblMessage.Visible = false; 
        }

        protected void btnSendOTP_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            if (string.IsNullOrEmpty(email)) return;

            using (var db = new AppDbContext())
            {
                var user = db.Users.FirstOrDefault(u => u.MailAddress == email);

                if (user == null)
                {
                    ShowError("If the email is registered, a recovery code will be sent.");
                    return;
                }

                Random rand = new Random();
                string otpCode = rand.Next(100000, 999999).ToString();

                bool isSent = SendRecoveryEmail(email, otpCode);

                if (isSent)
                {
                    Session["ResetOTP"] = otpCode;
                    Session["ResetEmail"] = email;

                    pnlStep1.Visible = false;
                    pnlStep2.Visible = true;
                }
                else
                {
                    ShowError("Failed to send the recovery email. Please try again later.");
                }
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            string userOTP = txtOTP.Text.Trim();
            string newPassword = txtNewPassword.Text;
            string sessionOTP = Session["ResetOTP"] as string;
            string sessionEmail = Session["ResetEmail"] as string;

            if (string.IsNullOrEmpty(sessionOTP) || string.IsNullOrEmpty(sessionEmail))
            {
                ShowError("Session expired. Please start over.");
                pnlStep2.Visible = false;
                pnlStep1.Visible = true;
                return;
            }

            if (userOTP != sessionOTP)
            {
                ShowError("Invalid Verification Code.");
                return;
            }

            var passwordPattern = new Regex(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$");
            if (!passwordPattern.IsMatch(newPassword))
            {
                ShowError("Weak Password! Must contain uppercase, lowercase, number and at least 8 characters.");
                return;
            }

            try
            {
                using (var db = new AppDbContext())
                {
                    var user = db.Users.FirstOrDefault(u => u.MailAddress == sessionEmail);

                    if (user != null)
                    {
                        user.Password = BCrypt.Net.BCrypt.HashPassword(newPassword);
                        user.UpdatedAt = DateTime.Now;

                        db.SaveChanges();

                        Session["ResetOTP"] = null;
                        Session["ResetEmail"] = null;

                        Response.Redirect("~/Account/Login.aspx?registered=true");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error updating password: " + ex.Message);
            }
        }

        private bool SendRecoveryEmail(string userEmail, string code)
        {
            try
            {
                string myEmail = WebConfigurationManager.AppSettings["SmtpEmail"];
                string myPassword = WebConfigurationManager.AppSettings["SmtpPassword"];

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(myEmail, "WenYan Hub Security");
                mail.To.Add(userEmail);
                mail.Subject = "Password Reset Request - WenYan Hub";

                mail.Body = $@"
                    <div style='font-family: Arial, sans-serif; border: 1px solid #e0e0e0; padding: 20px; max-width: 500px;'>
                        <h2 style='color: #8b0000;'>Password Reset</h2>
                        <p>We received a request to reset your password. Use the code below to proceed:</p>
                        <h1 style='background-color: #f8f9fa; padding: 15px; text-align: center; letter-spacing: 5px; color: #333;'>{code}</h1>
                        <p style='color: #666; font-size: 12px;'>If you did not request this, please ignore this email.</p>
                    </div>";
                mail.IsBodyHtml = true;

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.EnableSsl = true;
                smtp.Credentials = new NetworkCredential(myEmail, myPassword);

                smtp.Send(mail);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "alert alert-danger d-block text-center border-0 bg-danger-subtle text-danger-emphasis mb-3";
            lblMessage.Visible = true;
        }
    }
}