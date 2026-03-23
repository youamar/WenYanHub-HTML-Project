using System;
using System.Linq;
using System.Web.UI.WebControls;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class EditNote : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();
        int currentTeacherId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                currentTeacherId = Convert.ToInt32(Session["UserId"]);
            }

            if (!IsPostBack)
            {
                BindContents();

                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int noteId = Convert.ToInt32(Request.QueryString["id"]);
                    LoadNoteData(noteId);
                }
            }
        }

        private void BindContents()
        {
            var contents = db.Contents.OrderBy(c => c.Title).ToList();
            ddlContent.DataSource = contents;
            ddlContent.DataTextField = "Title";
            ddlContent.DataValueField = "ContentId";
            ddlContent.DataBind();
            ddlContent.Items.Insert(0, new ListItem("-- Select Lesson --", ""));
        }

        private void LoadNoteData(int id)
        {
            var note = db.Notes.Find(id);
            // Editing is only allowed for users with a teacher ID.
            if (note != null && note.TeacherId != null)
            {
                hfNoteId.Value = note.NoteId.ToString();
                ddlContent.SelectedValue = note.ContentId.ToString();
                txtNoteContent.Text = note.NoteContent;
            }
            else
            {
                Response.Redirect("NoteManage.aspx");
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                int contentId = Convert.ToInt32(ddlContent.SelectedValue);
                string noteText = txtNoteContent.Text.Trim();

                if (string.IsNullOrEmpty(hfNoteId.Value))
                {
                    Note newNote = new Note()
                    {
                        ContentId = contentId,
                        TeacherId = currentTeacherId, 
                        NoteContent = noteText,
                        Approved = "Pending",
                        CreatedAt = DateTime.Now,
                        UpdatedAt = DateTime.Now
                    };
                    db.Notes.Add(newNote);
                }
                else
                {
                    int noteId = Convert.ToInt32(hfNoteId.Value);
                    var existNote = db.Notes.Find(noteId);

                    // 🌟 Only with a teacher's ID can the modifications be saved.
                    if (existNote != null && existNote.TeacherId != null)
                    {
                        existNote.ContentId = contentId;
                        existNote.NoteContent = noteText;
                        existNote.Approved = "Pending";
                        existNote.UpdatedAt = DateTime.Now;
                    }
                }

                db.SaveChanges();
                Response.Redirect("NoteManage.aspx");
            }
            catch (Exception ex)
            {
                string errorMsg = ex.Message;
                if (ex.InnerException != null)
                {
                    errorMsg += "<br/><b>深层原因:</b> " + ex.InnerException.Message;
                    if (ex.InnerException.InnerException != null)
                    {
                        errorMsg += "<br/><b>最终原因:</b> " + ex.InnerException.InnerException.Message;
                    }
                }

                lblMessage.Text = "🚨 Error saving note: " + errorMsg;
                lblMessage.BackColor = System.Drawing.Color.LightPink;
                lblMessage.Visible = true;
            }
        }
    }
}