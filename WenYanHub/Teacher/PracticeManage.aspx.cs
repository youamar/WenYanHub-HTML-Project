using System;
using System.Linq;
using System.Web.UI.WebControls;
using WenYanHub.Models;
using System.Data.Entity;

namespace WenYanHub.Teacher
{
    public partial class PracticeManage : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Security: Redirect to login if session is null
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindPractices();
            }
        }

        private void BindPractices()
        {
            // Fetch practices sorted by Due Date for easy management
            var practices = db.Practices
                              .AsNoTracking()
                              .OrderByDescending(p => p.DueDate)
                              .ToList();

            gvPractices.DataSource = practices;
            gvPractices.DataBind();
        }

        protected void gvPractices_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeletePractice")
            {
                int practiceId = Convert.ToInt32(e.CommandArgument);
                var practice = db.Practices.Find(practiceId);

                if (practice != null)
                {
                    try
                    {
                        db.Practices.Remove(practice);
                        db.SaveChanges();

                        lblMessage.Text = "✅ Practice removed successfully.";
                        lblMessage.Visible = true;
                        BindPractices();
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "❌ Error: " + ex.Message;
                        lblMessage.Visible = true;
                    }
                }
            }
        }
    }
}