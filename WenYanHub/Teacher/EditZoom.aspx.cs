using System;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class EditZoom : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();
        int currentTeacherId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                currentTeacherId = Convert.ToInt32(Session["UserId"]);
            }

            if (!IsPostBack && !string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                var zoom = db.ZoomSessions.Find(Convert.ToInt32(Request.QueryString["id"]));
                // 🌟 Editing is only allowed for users with a teacher ID.
                if (zoom != null && zoom.TeacherId != null)
                {
                    hfZoomId.Value = zoom.ZoomSessionId.ToString();
                    txtTitle.Text = zoom.Title;
                    txtZoomUrl.Text = zoom.ZoomJoinUrl;
                    txtMeetingId.Text = zoom.MeetingId;
                    txtPasscode.Text = zoom.Passcode;
                    txtStartTime.Text = zoom.StartTime.ToString("yyyy-MM-ddTHH:mm");
                    txtDuration.Text = zoom.DurationMinutes.ToString();
                    txtDesc.Text = zoom.Description;
                }
                else
                {
                    Response.Redirect("VideoManage.aspx");
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hfZoomId.Value))
            {
                ZoomSession z = new ZoomSession
                {
                    TeacherId = currentTeacherId,
                    Title = txtTitle.Text,
                    ZoomJoinUrl = txtZoomUrl.Text,
                    MeetingId = txtMeetingId.Text,
                    Passcode = txtPasscode.Text,
                    StartTime = Convert.ToDateTime(txtStartTime.Text),
                    DurationMinutes = Convert.ToInt32(txtDuration.Text),
                    Description = txtDesc.Text,
                    CreatedAt = DateTime.Now
                };
                db.ZoomSessions.Add(z);
            }
            else
            {
                var z = db.ZoomSessions.Find(Convert.ToInt32(hfZoomId.Value));
                // 🌟 Only with a teacher's ID can the modifications be saved.
                if (z != null && z.TeacherId != null)
                {
                    z.Title = txtTitle.Text; z.ZoomJoinUrl = txtZoomUrl.Text; z.MeetingId = txtMeetingId.Text;
                    z.Passcode = txtPasscode.Text; z.StartTime = Convert.ToDateTime(txtStartTime.Text);
                    z.DurationMinutes = Convert.ToInt32(txtDuration.Text); z.Description = txtDesc.Text;
                }
            }
            db.SaveChanges();
            Response.Redirect("VideoManage.aspx");
        }
    }
}