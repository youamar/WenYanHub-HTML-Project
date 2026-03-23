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
    public partial class Register : System.Web.UI.Page
    {
        protected void btnSendCode_Click(object sender, EventArgs e)
        {
            string emailTo = txtEmail.Text.Trim();

            if (string.IsNullOrEmpty(emailTo))
            {
                lblEmailMsg.Text = "Please enter an email.";
                lblEmailMsg.CssClass = "text-danger small fw-bold";
                lblEmailMsg.Visible = true;
                return;
            }

            Random rand = new Random();
            string otpCode = rand.Next(100000, 999999).ToString();

            bool isSent = SendEmail(emailTo, otpCode);

            if (isSent)
            {
                using (var db = new AppDbContext())
                {
                    var newOtp = new OtpRecord
                    {
                        Email = emailTo,
                        OtpCode = otpCode,
                        CreatedAt = DateTime.Now,
                        ExpiresAt = DateTime.Now.AddMinutes(10), 
                        IsUsed = false,
                        IpAddress = Request.UserHostAddress
                    };
                    db.OtpRecords.Add(newOtp);
                    db.SaveChanges();
                }


                lblEmailMsg.Text = "✅ Code sent! Check inbox (Valid for 10 mins).";
                lblEmailMsg.CssClass = "text-success small fw-bold";
                btnSendCode.Enabled = false;
                btnSendCode.Text = "Sent";
            }
            else
            {
                lblEmailMsg.Text = "❌ Failed to send.";
                lblEmailMsg.CssClass = "text-danger small fw-bold";
            }
            lblEmailMsg.Visible = true;
        }

        private bool SendEmail(string userEmail, string code)
        {
            try
            {
                Random rand = new Random();
                int accountIndex = rand.Next(1, 4); 

                string emailKey = $"SmtpEmail_{accountIndex}";
                string passwordKey = $"SmtpPassword_{accountIndex}";

                string myEmail = WebConfigurationManager.AppSettings[emailKey];
                string myPassword = WebConfigurationManager.AppSettings[passwordKey];

                System.Diagnostics.Debug.WriteLine($"[sending OTP] using {accountIndex}: {myEmail} sending emial...");

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(myEmail, "WenYan Hub");
                mail.To.Add(userEmail);
                mail.Subject = "Your Verification Code - WenYan Hub";
                mail.Body = $"<h3>Your Code: <span style='color:#8b0000'>{code}</span></h3><p>This code will expire in 10 minutes.</p>";
                mail.IsBodyHtml = true;

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.EnableSsl = true;
                smtp.Credentials = new NetworkCredential(myEmail, myPassword);

                smtp.Send(mail);
                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"[failed sending OTP] {ex.Message}");
                return false;
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string userOTP = txtOTP.Text.Trim();

            var passwordPattern = new Regex(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$");
            if (!passwordPattern.IsMatch(password))
            {
                ShowError("⚠️ Weak Password! Must contain uppercase, lowercase, number and at least 8 characters.");
                return;
            }

            try
            {
                using (var db = new AppDbContext())
                {
                    if (db.Users.Any(u => u.Username == username))
                    {
                        ShowError("❌ Username taken. Please choose another one.");
                        return;
                    }
                    if (db.Users.Any(u => u.MailAddress == email))
                    {
                        ShowError("❌ Email already registered. Please go to Login.");
                        return;
                    }

                    var validOtp = db.OtpRecords
                        .Where(o => o.Email == email
                                 && o.OtpCode == userOTP
                                 && o.IsUsed == false)
                        .OrderByDescending(o => o.CreatedAt)
                        .FirstOrDefault();

                    if (validOtp == null)
                    {
                        ShowError("❌ Invalid or mismatched OTP Code.");
                        return;
                    }

                    if (validOtp.ExpiresAt < DateTime.Now)
                    {
                        ShowError("❌ Verification code expired. Please request a new one.");
                        return;
                    }

                    string hashedPassword = BCrypt.Net.BCrypt.HashPassword(password);

                    var newUser = new User
                    {
                        Username = username,
                        MailAddress = email,
                        Password = hashedPassword,
                        Role = "Member",
                        CreatedAt = DateTime.Now,
                        UpdatedAt = DateTime.Now
                    };

                    db.Users.Add(newUser);
                    validOtp.IsUsed = true;
                    db.SaveChanges();

                    string returnUrl = Request.QueryString["ReturnUrl"];
                    string redirectUrl = "~/Account/Login.aspx?registered=true";

                    if (!string.IsNullOrEmpty(returnUrl))
                    {
                        redirectUrl += "&ReturnUrl=" + Server.UrlEncode(returnUrl);
                    }

                    Response.Redirect(redirectUrl);
                }
            }
            catch (Exception ex)
            {
                ShowError("Error: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }
    }
}