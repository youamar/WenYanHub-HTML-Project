using System;
using System.Linq;
using System.Web.UI.WebControls;
using WenYanHub.Models;
using System.Data.Entity;

namespace WenYanHub.Teacher
{
    public partial class NoteManage : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        // 🌟 declare variables

        int currentTeacherId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 🌟 Obtain the actual ID dynamically
            if (Session["UserId"] != null)
            {
                currentTeacherId = Convert.ToInt32(Session["UserId"]);
            }

            if (!IsPostBack)
            {
                BindNotes();
            }
        }

        private void BindNotes()
        {
            var notes = db.Notes
                          .Include(n => n.Content)
                          .OrderByDescending(n => n.UpdatedAt)
                          .ToList();

            gvNotes.DataSource = notes;
            gvNotes.DataBind();
        }

        protected void gvNotes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteNote")
            {
                int noteId = Convert.ToInt32(e.CommandArgument);
                var note = db.Notes.Find(noteId);

                // 🌟 Security Lock: Only data uploaded by teachers can be deleted (TeacherId cannot be empty)
                if (note != null && note.TeacherId != null)
                {
                    db.Notes.Remove(note);
                    db.SaveChanges();

                    lblMessage.Text = "Note deleted successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Visible = true;
                    BindNotes();
                }
                else if (note != null && note.TeacherId == null)
                {
                    // When attempting to delete the original data, a red warning prompt is displayed.
                    lblMessage.Text = "❌ You cannot delete original system records!";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Visible = true;
                }
            }
        }
    }
}