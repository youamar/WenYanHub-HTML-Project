using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using WenYanHub.Models;

namespace WenYanHub.Others
{
    public partial class Edit_Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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
            int userId = (int)Session["UserId"];
            using (var db = new AppDbContext())
            {
                var user = db.Users.Find(userId);
                if (user != null)
                {
                    txtUsername.Text = user.Username;
                    lblDisplayUsername.Text = user.Username;
                    txtEmail.Text = user.MailAddress;
                    txtContact.Text = user.ContactNumber;

                    if (!string.IsNullOrEmpty(user.ProfilePictureUrl))
                    {
                        imgProfile.ImageUrl = user.ProfilePictureUrl;
                    }
                }
            }
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            int userId = (int)Session["UserId"];
            string newContact = txtContact.Text.Trim();

            if (string.IsNullOrEmpty(newContact))
            {
                ShowError("Mobile number is required.");
                return;
            }

            //Mobile Number Verification
            if (!newContact.All(char.IsDigit) || newContact.Length <= 9)
            {
                ShowError("Mobile number must be digits only and more than 9 digits.");
                return;
            }

            using (var db = new AppDbContext())
            {
 

                var user = db.Users.Find(userId);
                if (user != null)
                {
  
                    user.ContactNumber = newContact;
                    user.UpdatedAt = DateTime.Now;

                    if (fuProfilePic.HasFile)
                    {
                        try
                        {
                            string fileName = "User_" + userId + "_" + Path.GetFileName(fuProfilePic.FileName);
                            string folderPath = Server.MapPath("~/Uploads/Profiles/");
                            if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);
                            string filePath = Path.Combine(folderPath, fileName);
                            fuProfilePic.SaveAs(filePath);
                            user.ProfilePictureUrl = "~/Uploads/Profiles/" + fileName;
                        }
                        catch (Exception ex)
                        {
                            ShowError("Image upload failed: " + ex.Message);
                            return;
                        }
                    }

                    db.SaveChanges();

                    lblStatus.Text = "Profile updated successfully!";
                    lblStatus.CssClass = "text-success fw-bold";
                }
            }
        }

        private void ShowError(string message)
        {
            lblStatus.Text = message;
            lblStatus.CssClass = "text-danger fw-bold";
        }
    }
}