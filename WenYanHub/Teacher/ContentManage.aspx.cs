using System;
using System.Linq;
using System.Web.UI.WebControls;
using WenYanHub.Models;
using System.Data.Entity;

namespace WenYanHub.Teacher
{
    public partial class ContentManage : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindContents();
            }
        }

        private void BindContents()
        {
            // Fetch list sorted by ID for a clear sequential display
            var contents = db.Contents
                             .AsNoTracking()
                             .OrderBy(c => c.ContentId)
                             .ToList();

            gvContents.DataSource = contents;
            gvContents.DataBind();
        }

        protected void gvContents_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Obtain the actual database key from the selected row
            int contentId = Convert.ToInt32(gvContents.DataKeys[e.RowIndex].Value);
            var content = db.Contents.Find(contentId);

            // Authority Lock: Only content uploaded by teachers can be deleted
            if (content != null && content.TeacherId != null)
            {
                db.Contents.Remove(content);
                db.SaveChanges();

                lblMessage.Text = "Scroll successfully removed.";
                lblMessage.Visible = true;
                BindContents();
            }
            else
            {
                lblMessage.Text = "❌ System records are read-only.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Visible = true;
            }
        }
    }
}