using System;
using System.IO;
using System.Linq;
using WenYanHub.Models;
using BCrypt.Net; // Required for password hashing consistency

namespace WenYanHub.Teacher
{
    public partial class UpdateProfile : System.Web.UI.Page
    {
        private AppDbContext db = new AppDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify if the user is logged in
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserData();
            }
        }

        private void LoadUserData()
        {
            int uid = Convert.ToInt32(Session["UserId"]);
            var user = db.Users.Find(uid);

            if (user != null)
            {
                // Populate read-only and editable fields
                txtUsername.Text = user.Username;
                txtEmail.Text = user.MailAddress;
                txtPhone.Text = user.ContactNumber;

                // Load existing profile picture preview
                if (!string.IsNullOrEmpty(user.ProfilePictureUrl))
                {
                    imgAvatar.ImageUrl = ResolveUrl(user.ProfilePictureUrl);
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int uid = Convert.ToInt32(Session["UserId"]);
            var user = db.Users.Find(uid);

            if (user != null)
            {
                try
                {
                    // 1. Process profile picture upload from device
                    if (fuProfilePic.HasFile)
                    {
                        // Generate a unique filename using User ID and timestamp
                        string extension = Path.GetExtension(fuProfilePic.FileName);
                        string fileName = "User_" + uid + "_" + DateTime.Now.Ticks + extension;
                        string folderPath = Server.MapPath("~/Images/Profiles/");

                        // Ensure the target directory exists
                        if (!Directory.Exists(folderPath))
                        {
                            Directory.CreateDirectory(folderPath);
                        }

                        string savePath = Path.Combine(folderPath, fileName);
                        fuProfilePic.SaveAs(savePath);

                        // Update the profile picture URL in the database
                        user.ProfilePictureUrl = "~/Images/Profiles/" + fileName;
                    }

                    // 2. Update contact info and timestamp
                    user.ContactNumber = txtPhone.Text.Trim();
                    user.UpdatedAt = DateTime.Now;

                    // 3. Update password using BCrypt hashing if a new one is provided
                    // This ensures compatibility with the verification logic in Login.aspx.cs
                    if (!string.IsNullOrEmpty(txtPassword.Text))
                    {
                        // Hash the plain text password before storing
                        user.Password = BCrypt.Net.BCrypt.HashPassword(txtPassword.Text);
                    }

                    // 4. Save changes to the database
                    db.SaveChanges();

                    // Refresh the current page to display updated data and new avatar
                    Response.Redirect(Request.RawUrl);
                }
                catch (Exception ex)
                {
                    // Error handling logic
                    lblMsg.Text = "❌ Error: " + ex.Message;
                    lblMsg.Visible = true;
                    lblMsg.Style["color"] = "red";
                }
            }
        }
    }
}