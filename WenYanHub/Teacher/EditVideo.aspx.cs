using System;
using System.Linq;
using System.Web.UI.WebControls;
using WenYanHub.Models;

namespace WenYanHub.Teacher
{
    public partial class EditVideo : System.Web.UI.Page
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
                // Bind the dropdown box for courses
                ddlContent.DataSource = db.Contents.ToList();
                ddlContent.DataTextField = "Title";
                ddlContent.DataValueField = "ContentId";
                ddlContent.DataBind();
                ddlContent.Items.Insert(0, new ListItem("-- Select Lesson --", ""));

                // If it is in edit mode, load the old data
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int id = Convert.ToInt32(Request.QueryString["id"]);
                    var video = db.VideoRecords.Find(id);

                    // Permission Lock: Only those uploaded by yourself can be edited.
                    if (video != null && video.TeacherId == currentTeacherId)
                    {
                        hfRecordId.Value = video.RecordId.ToString();
                        ddlContent.SelectedValue = video.ContentId.ToString();
                        txtDescription.Text = video.Description;
                        txtVideoLink.Text = video.RecordLink; // 🌟 Load the old Drive link
                    }
                    else
                    {
                        Response.Redirect("VideoManage.aspx");
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                string videoLink = txtVideoLink.Text.Trim();
                if (string.IsNullOrEmpty(videoLink))
                {
                    ShowError("Please provide a valid Google Drive link!");
                    return;
                }

                if (string.IsNullOrEmpty(hfRecordId.Value))
                {
                    // 🌟 1. New video recording added
                    VideoRecord newVid = new VideoRecord
                    {
                        ContentId = Convert.ToInt32(ddlContent.SelectedValue),
                        TeacherId = currentTeacherId,
                        RecordLink = videoLink, // Directly save the link
                        Description = txtDescription.Text.Trim(),
                        Approved = "Pending",
                        CreatedAt = DateTime.Now,
                        UpdatedAt = DateTime.Now
                    };
                    db.VideoRecords.Add(newVid);
                }
                else
                {
                    // 🌟 2. Modify the existing records
                    int vidId = Convert.ToInt32(hfRecordId.Value);
                    var existVid = db.VideoRecords.Find(vidId);

                    if (existVid != null && existVid.TeacherId == currentTeacherId)
                    {
                        existVid.ContentId = Convert.ToInt32(ddlContent.SelectedValue);
                        existVid.Description = txtDescription.Text.Trim();
                        existVid.RecordLink = videoLink;
                        existVid.Approved = "Pending"; // After modification, it needs to be reviewed again.
                        existVid.UpdatedAt = DateTime.Now;
                    }
                }

                db.SaveChanges();
                Response.Redirect("VideoManage.aspx");
            }
            catch (Exception ex)
            {
                ShowError("Save failed: " + ex.Message);
            }
        }

        private void ShowError(string msg)
        {
            lblMessage.Text = "🚨 " + msg;
            lblMessage.Visible = true;
            lblMessage.BackColor = System.Drawing.Color.MistyRose;
            lblMessage.ForeColor = System.Drawing.Color.DarkRed;
        }
    }
}