using System;
using System.Linq;
using System.Data.Entity;
using WenYanHub.Models;
using System.Web.UI.WebControls;

namespace WenYanHub.Teacher
{
    public partial class TeacherForum : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) Response.Redirect("~/account/Login.aspx");
            if (!IsPostBack) LoadMessages();
        }

        private void LoadMessages()
        {
            // Include(m => m.Teacher) ensures that the Username can be retrieved.
            var msgs = db.TeacherMessages.Include(m => m.Teacher)
                         .OrderByDescending(m => m.CreatedAt).ToList();
            rptMessages.DataSource = msgs;
            rptMessages.DataBind();
        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrWhiteSpace(txtMessage.Text))
            {
                var newMsg = new TeacherMessage
                {
                    TeacherId = Convert.ToInt32(Session["UserId"]),
                    Content = txtMessage.Text.Trim(),
                    CreatedAt = DateTime.Now
                };
                db.TeacherMessages.Add(newMsg);
                db.SaveChanges();
                txtMessage.Text = "";
                LoadMessages();
            }
        }

        protected void rptMessages_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int msgId = Convert.ToInt32(e.CommandArgument);
            var msg = db.TeacherMessages.Find(msgId);

            if (msg != null && msg.TeacherId == Convert.ToInt32(Session["UserId"]))
            {
                if (e.CommandName == "DeleteMsg")
                {
                    db.TeacherMessages.Remove(msg);
                    db.SaveChanges();
                    LoadMessages();
                }
                else if (e.CommandName == "EditMsg")
                {
                    hfEditId.Value = msgId.ToString();
                    txtEditMessage.Text = msg.Content;
                    pnlEdit.Visible = true;
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int msgId = Convert.ToInt32(hfEditId.Value);
            var msg = db.TeacherMessages.Find(msgId);
            if (msg != null && msg.TeacherId == Convert.ToInt32(Session["UserId"]))
            {
                msg.Content = txtEditMessage.Text.Trim();
                db.SaveChanges();
                pnlEdit.Visible = false;
                LoadMessages();
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            pnlEdit.Visible = false;
        }
    }
}