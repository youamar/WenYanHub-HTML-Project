using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using WenYanHub.Models;
using WenYanHub.Admin.Utils;

namespace WenYanHub.Admin
{
    public partial class EditProfile : System.Web.UI.Page
    {
        private int CurrentUserId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 🔥 STRICT SESSION CHECK: No more hardcoded "1"
            if (Session["UserId"] != null)
            {
                CurrentUserId = Convert.ToInt32(Session["UserId"]);
            }
            else
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
            using (var db = new AppDbContext())
            {
                var user = db.Users.Find(CurrentUserId);
                if (user != null)
                {
                    txtUsername.Text = user.Username;
                    txtEmail.Text = user.MailAddress;
                    txtContact.Text = user.ContactNumber;
                    txtRole.Text = user.Role;

                    if (!string.IsNullOrEmpty(user.ProfilePictureUrl))
                    {
                        imgAvatar.ImageUrl = user.ProfilePictureUrl;
                        Session["ProfilePic"] = user.ProfilePictureUrl;
                    }
                }
            }
        }

        protected void btnUploadPic_Click(object sender, EventArgs e)
        {
            if (fuProfilePic.HasFile)
            {
                try
                {
                    string filename = Path.GetFileName(fuProfilePic.FileName);
                    string ext = Path.GetExtension(filename).ToLower();

                    if (ext == ".jpg" || ext == ".jpeg" || ext == ".png")
                    {
                        string savePath = Server.MapPath("~/Uploads/Profiles/") + CurrentUserId + "_" + filename;
                        fuProfilePic.SaveAs(savePath);
                        string dbPath = "~/Uploads/Profiles/" + CurrentUserId + "_" + filename;

                        using (var db = new AppDbContext())
                        {
                            var user = db.Users.Find(CurrentUserId);
                            if (user != null)
                            {
                                user.ProfilePictureUrl = dbPath;
                                db.SaveChanges();

                                imgAvatar.ImageUrl = dbPath;
                                Session["ProfilePic"] = dbPath; // Updates the top-right master page image too!

                                SystemLogger.LogEvent(CurrentUserId, "Updated Profile Picture", "User Management", "{ \"status\": \"Success\" }");
                                ScriptManager.RegisterStartupScript(this, GetType(), "Alert", "alert('Profile picture updated!');", true);
                            }
                        }
                    }
                }
                catch { }
            }
        }

        protected void btnSaveInfo_Click(object sender, EventArgs e)
        {
            using (var db = new AppDbContext())
            {
                var user = db.Users.Find(CurrentUserId);
                if (user != null)
                {
                    user.ContactNumber = txtContact.Text.Trim();
                    user.UpdatedAt = DateTime.Now;
                    db.SaveChanges();

                    SystemLogger.LogEvent(CurrentUserId, "Updated Contact Info", "User Management", $"{{ \"new_contact\": \"{user.ContactNumber}\" }}");
                    ScriptManager.RegisterStartupScript(this, GetType(), "Alert", "alert('Contact information saved!');", true);
                }
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            string oldPass = txtOldPassword.Text;
            string newPass = txtNewPassword.Text;
            string confirmPass = txtConfirmPassword.Text;

            if (newPass != confirmPass)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Alert", "alert('New passwords do not match!');", true);
                return;
            }
            
            using (var db = new AppDbContext())
            {
                var user = db.Users.Find(CurrentUserId);
                if (user != null)
                {
                    if (!BCrypt.Net.BCrypt.Verify(oldPass, user.Password))
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "Alert", "alert('Incorrect current password!');", true);
                        return;
                    }

                    user.Password = BCrypt.Net.BCrypt.HashPassword(newPass, 11);
                    user.UpdatedAt = DateTime.Now;
                    db.SaveChanges();

                    SystemLogger.LogEvent(CurrentUserId, "Changed Password", "Security", "{ \"status\": \"Success\" }");
                    ScriptManager.RegisterStartupScript(this, GetType(), "Alert", "alert('Password changed successfully!');", true);

                    txtOldPassword.Text = ""; txtNewPassword.Text = ""; txtConfirmPassword.Text = "";
                }
            }
        }
    }
}