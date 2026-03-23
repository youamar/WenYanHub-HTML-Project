using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WenYanHub.Models;

namespace WenYanHub.Learning
{
    public partial class ZoomLink : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                if (Session["UserId"] == null)
                {
                    Response.Redirect("~/Account/Login.aspx");
                    return;
                }
                LoadUpcomingSessions();
            }
        }

        private void LoadUpcomingSessions()
        {
            using (var db = new AppDbContext())
            {
                DateTime now = DateTime.Now;

                //Only retrieve Sessions with a start time greater than the current time.
                var sessions = db.ZoomSessions
                    .Include(z => z.Teacher)
                    .Where(z => z.StartTime > now)
                    .OrderBy(z => z.StartTime)
                    .Select(z => new {
                        z.ZoomSessionId,
                        z.Title,
                        z.Description,
                        z.ZoomJoinUrl,
                        z.MeetingId,
                        z.Passcode,
                        z.StartTime,
                        z.DurationMinutes,
                        TeacherName = z.Teacher.Username
                    })
                    .ToList();

                if (sessions.Any())
                {
                    rptZoomSessions.DataSource = sessions;
                    rptZoomSessions.DataBind();
                    pnlNoSessions.Visible = false;
                }
                else
                {
                    pnlNoSessions.Visible = true;
                }
            }
        }
    }
}