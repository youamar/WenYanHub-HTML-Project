using System;
using System.Web.UI;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class TeacherDashboard : Page
    {
        // Database context initialization
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Security Check: Redirect to login if user session is null
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/account/Login.aspx");
                return;
            }

            // The Dashboard serves as a navigation hub for all teacher-related tasks
            if (!IsPostBack)
            {
                // General initialization can be placed here if needed
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear all session data upon logout
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Default.aspx");
        }
    }
}