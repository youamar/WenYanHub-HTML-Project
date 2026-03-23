using System;

namespace WenYanHub.Teacher
{
    public partial class TeacherMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 🌟 Core access control: If the user is not logged in or the identity is not "Teacher", force a redirect.
            if (Session["UserId"] == null || Session["Role"] == null || Session["Role"].ToString() != "Teacher")
            {
                Response.Redirect("~/Account/Login.aspx");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // 1. Completely destroy the user's session
            Session.Clear();
            Session.Abandon();
            Session.RemoveAll();

            // 2. Clear the browser's memory of the session
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }

            // 3. Redirect back to login
            Response.Redirect("~/Account/Login.aspx");
        }
    }
}