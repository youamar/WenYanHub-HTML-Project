using System;
using System.Linq;
using System.Web.UI.WebControls;
using WenYanHub.Models;
using System.Data.Entity;

namespace WenYanHub.Teacher
{
    public partial class VideoManage : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindVideos();
                BindZooms();
            }
        }

        private void BindVideos()
        {
            // Load all videos, including course titles
            gvVideos.DataSource = db.VideoRecords.Include(v => v.Content).AsNoTracking().OrderByDescending(v => v.UpdatedAt).ToList();
            gvVideos.DataBind();
        }

        private void BindZooms()
        {
            // Load all live broadcast lists
            gvZoom.DataSource = db.ZoomSessions.AsNoTracking().OrderByDescending(z => z.StartTime).ToList();
            gvZoom.DataBind();
        }

        protected void gvVideos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteVideo")
            {
                int vidId = Convert.ToInt32(e.CommandArgument);
                var video = db.VideoRecords.Find(vidId);

                // 🌟 Background security lock: Verifies TeacherId to prevent deletion of system videos
                if (video != null && video.TeacherId != null)
                {
                    db.VideoRecords.Remove(video);
                    db.SaveChanges();
                    ShowSuccess("Video deleted successfully!");
                    BindVideos();
                }
                else { ShowError("Cannot delete system records!"); }
            }
        }

        protected void gvZoom_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteZoom")
            {
                int zoomId = Convert.ToInt32(e.CommandArgument);
                var zoom = db.ZoomSessions.Find(zoomId);

                if (zoom != null && zoom.TeacherId != null)
                {
                    db.ZoomSessions.Remove(zoom);
                    db.SaveChanges();
                    ShowSuccess("Zoom session deleted!");
                    BindZooms();
                }
                else { ShowError("Cannot delete system Zoom sessions!"); }
            }
        }

        private void ShowSuccess(string msg) { lblMessage.Text = "✅ " + msg; lblMessage.BackColor = System.Drawing.Color.PaleGreen; lblMessage.ForeColor = System.Drawing.Color.DarkGreen; lblMessage.Visible = true; }
        private void ShowError(string msg) { lblMessage.Text = "❌ " + msg; lblMessage.BackColor = System.Drawing.Color.MistyRose; lblMessage.ForeColor = System.Drawing.Color.DarkRed; lblMessage.Visible = true; }
    }
}