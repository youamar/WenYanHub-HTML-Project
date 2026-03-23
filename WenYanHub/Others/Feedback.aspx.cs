using System;
using System.Linq;
using System.Web.UI;
using WenYanHub.Models;
using System.Net;
using System.Net.Mail;
using System.Configuration; // 用来读取 Web.config

namespace WenYanHub.Others
{
    public partial class FeedbackPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["SuccessMessage"] != null)
            {
                ShowAlert(Session["SuccessMessage"].ToString(), "alert-success border-success text-success");
                Session.Remove("SuccessMessage"); // 显示完立刻清空，这样再按 F5 刷新就不会一直弹了
            }
            else
            {
                pnlAlert.Visible = false;
            }
        }

        // =====================================
        // UI 控制：强制切换到 Track Tab
        // =====================================
        private void SwitchToTrackTab()
        {
            // 1. 取消激活 Submit Tab
            btnTabSubmit.Attributes["class"] = "nav-link fw-bold py-3 text-dark border-0 rounded-0";
            divTabSubmit.Attributes["class"] = "tab-pane fade tab-submit"; // 移除 show active

            // 2. 激活 Track Tab
            btnTabTrack.Attributes["class"] = "nav-link active fw-bold py-3 text-dark border-0 rounded-0";
            divTabTrack.Attributes["class"] = "tab-pane fade show active tab-track"; // 加上 show active
        }

        // =====================================
        // CREATE (保持不变)
        // =====================================
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string category = ddlCategory.SelectedValue;
            // 🔥 抓取 URL
            string sourceUrl = txtSourceUrl.Text.Trim();
            string message = txtMessage.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(message)) return;

            string trackingCode = "WYH-" + Guid.NewGuid().ToString("N").Substring(0, 8).ToUpper();

            using (var db = new AppDbContext())
            {
                var newFeedback = new WenYanHub.Models.Feedback
                {
                    ContactEmail = email,
                    Category = category,
                    // 🔥 保存到数据库 (如果用户没填，就是 null)
                    SourceUrl = string.IsNullOrEmpty(sourceUrl) ? null : sourceUrl,
                    Message = message,
                    TrackingCode = trackingCode,
                    Status = "Pending",
                    CreatedAt = DateTime.Now,
                    UpdatedAt = DateTime.Now,
                    UserId = Session["UserId"] != null ? (int?)Session["UserId"] : null
                };
                db.Feedbacks.Add(newFeedback);
                db.SaveChanges();
            }

            // 调用发邮件方法 (如果你想，也可以把 sourceUrl 传给邮件，让邮件里也显示链接)
            SendEmailNotification(trackingCode, email, category, message);

            txtEmail.Text = "";
            txtSourceUrl.Text = ""; // 🔥 清空
            txtMessage.Text = "";

            // ⬇️ 【修改这里】不要直接调用 ShowAlert，而是把消息存进 Session，然后强制跳转刷新页面！
            Session["SuccessMessage"] = $"Ticket Submitted! Your Tracking Code is: <b>{trackingCode}</b>. Please save it!";
            Response.Redirect(Request.RawUrl); // 强制进行一次 GET 请求跳转，彻底斩断表单的 POST 状态
        }

        // =====================================
        // READ (更新：加入 SwitchToTrackTab)
        // =====================================
        // =====================================
        // READ (更新：加入 AdminReply 逻辑)
        // =====================================
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string code = txtTrackingCode.Text.Trim();
            if (string.IsNullOrEmpty(code)) return;

            using (var db = new AppDbContext())
            {
                var ticket = db.Feedbacks.FirstOrDefault(f => f.TrackingCode == code);

                if (ticket != null)
                {
                    lblDisplayCode.Text = ticket.TrackingCode;
                    lblDate.Text = ticket.CreatedAt.ToString("yyyy-MM-dd HH:mm");

                    // Defend against null status
                    string currentStatus = ticket.Status != null ? ticket.Status.Trim() : "";
                    lblStatus.Text = currentStatus;
                    txtEditMessage.Text = ticket.Message ?? "";

                    // Evaluate exactly once to prevent logic mismatch
                    bool isPending = currentStatus.Equals("Pending", StringComparison.OrdinalIgnoreCase);

                    // Badge styling
                    if (isPending)
                        lblStatus.CssClass = "badge bg-warning text-dark fs-6";
                    else if (currentStatus.Equals("Resolved", StringComparison.OrdinalIgnoreCase))
                        lblStatus.CssClass = "badge bg-success fs-6";
                    else
                        lblStatus.CssClass = "badge bg-secondary fs-6";

                    // 1. Lock/Unlock the textbox
                    txtEditMessage.Enabled = isPending;
                    txtEditMessage.ReadOnly = !isPending;
                    lblMessageHeader.InnerText = isPending ? "Your Message (Edit if needed)" : "Your Message (Locked)";

                    // 2. Hide/Show the buttons AND the lock notice
                    btnUpdate.Visible = isPending;
                    btnDelete.Visible = isPending;
                    lblLockNotice.Visible = !isPending;

                    // 3. Show Admin Reply ONLY if it's Resolved and actually has a reply
                    if (currentStatus.Equals("Resolved", StringComparison.OrdinalIgnoreCase) && !string.IsNullOrEmpty(ticket.AdminReply))
                    {
                        litAdminReply.Text = ticket.AdminReply.Replace("\n", "<br/>");
                        pnlAdminReply.Visible = true;
                    }
                    else
                    {
                        pnlAdminReply.Visible = false;
                    }

                    pnlTicketDetails.Visible = true;
                    ViewState["CurrentTrackingCode"] = ticket.TrackingCode;
                }
                else
                {
                    pnlTicketDetails.Visible = false;
                    ShowAlert("Invalid Tracking Code. Please check and try again.", "alert-danger border-danger text-danger");
                }
            }

            SwitchToTrackTab();
        }

        // =====================================
        // UPDATE (更新：加入 SwitchToTrackTab)
        // =====================================
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string code = ViewState["CurrentTrackingCode"] as string;
            string updatedMessage = txtEditMessage != null ? txtEditMessage.Text.Trim() : "";

            if (string.IsNullOrEmpty(code) || string.IsNullOrEmpty(updatedMessage)) return;

            using (var db = new AppDbContext())
            {
                var ticket = db.Feedbacks.FirstOrDefault(f => f.TrackingCode == code);

                // 🔥 后端二次验证：防止用户通过抓包或篡改前端强行提交
                if (ticket != null && ticket.Status != null && ticket.Status.Trim().Equals("Pending", StringComparison.OrdinalIgnoreCase))
                {
                    ticket.Message = updatedMessage;
                    db.SaveChanges();

                    ShowAlert("Ticket updated successfully.", "alert-success border-success text-success");
                    pnlTicketDetails.Visible = false;
                }
            }

            SwitchToTrackTab();
        }

        // =====================================
        // DELETE (更新：修复了删除失败问题 + 强制停留)
        // =====================================
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string code = ViewState["CurrentTrackingCode"] as string;

            if (string.IsNullOrEmpty(code)) return;

            using (var db = new AppDbContext())
            {
                var ticket = db.Feedbacks.FirstOrDefault(f => f.TrackingCode == code);

                // 🔥 后端二次验证：确保只有 Pending 状态的才能被删除
                if (ticket != null && ticket.Status != null && ticket.Status.Trim().Equals("Pending", StringComparison.OrdinalIgnoreCase))
                {
                    db.Feedbacks.Remove(ticket);
                    db.SaveChanges();

                    ShowAlert("Your ticket has been successfully withdrawn.", "alert-success border-success text-success");
                    pnlTicketDetails.Visible = false;
                    txtTrackingCode.Text = "";
                }
            }

            SwitchToTrackTab();
        }

        private void ShowAlert(string message, string cssClass)
        {
            litAlertMessage.Text = message;
            pnlAlert.CssClass = $"alert {cssClass} text-center mb-4 font-classic fw-bold shadow-sm";
            pnlAlert.Visible = true;
        }

        private void SendEmailNotification(string trackingCode, string userEmail, string category, string message)
        {
            try
            {
                string senderEmail = ConfigurationManager.AppSettings["SmtpEmail"];
                string senderAppPassword = ConfigurationManager.AppSettings["SmtpPassword"];

                string adminEmail = senderEmail; // 假设系统通知发回给你自己的邮箱

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(senderEmail, "WenYanHub Support");
                mail.To.Add(adminEmail);

                mail.Subject = $"[WenYanHub] New Support Ticket: {trackingCode}";
                mail.IsBodyHtml = true;

                mail.Body = $@"
                    <div style='font-family: Arial, sans-serif; color: #333; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden;'>
                        <div style='background-color: #8b0000; color: white; padding: 20px; text-align: center;'>
                            <h2 style='margin: 0; letter-spacing: 2px;'>WenYanHub Support</h2>
                            <p style='margin: 5px 0 0 0; opacity: 0.8;'>New Ticket Received</p>
                        </div>
                        <div style='padding: 30px; background-color: #fdfbf7;'>
                            <p><strong>Tracking Code:</strong> <span style='color: #8b0000; font-weight: bold;'>{trackingCode}</span></p>
                            <p><strong>Category:</strong> {category}</p>
                            <p><strong>Visitor Email:</strong> {userEmail}</p>
                            <h4 style='border-bottom: 1px solid #ccc; padding-bottom: 5px;'>Message Details:</h4>
                            <div style='background-color: white; padding: 15px; border-left: 4px solid #D4AF37; margin-top: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.05);'>
                                {message.Replace("\n", "<br/>")}
                            </div>
                        </div>
                        <div style='background-color: #2c2420; color: #888; padding: 15px; text-align: center; font-size: 12px;'>
                            * This is an automated notification from the WenYanHub system. Do not reply directly.
                        </div>
                    </div>";

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.EnableSsl = true;
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new NetworkCredential(senderEmail, senderAppPassword);

                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                // 如果发邮件失败，打印到 Output 窗口，不影响用户页面的正常运行
                System.Diagnostics.Debug.WriteLine("Email sending failed: " + ex.Message);
            }
        }
    }
}