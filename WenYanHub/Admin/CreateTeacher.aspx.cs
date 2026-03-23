using System;
using System.Linq;
using WenYanHub.Models;
using BCrypt.Net;
using WenYanHub.Admin.Utils;

namespace WenYanHub.Admin
{
    public partial class CreateTeacher : System.Web.UI.Page
    {
        protected void btnCreateTeacher_Click(object sender, EventArgs e)
        {
            // 🔥 SERVER-SIDE VALIDATION FIX 🔥
            Page.Validate();
            if (!Page.IsValid)
            {
                return; // Abort if frontend ASP.NET validators failed
            }

            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string rawPassword = txtPassword.Text.Trim();

            // 1. Basic Validation
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(rawPassword))
            {
                lblMessage.Text = "❌ All fields are required.";
                lblMessage.Visible = true;
                return;
            }

            // 🔥 STRICT SERVER-SIDE REGEX CHECK (Blocks "123" bypass) 🔥
            if (!System.Text.RegularExpressions.Regex.IsMatch(rawPassword, @"^(?=.*[a-z])(?=.*[A-Z]).{8,}$"))
            {
                lblMessage.Text = "❌ Password must be at least 8 chars with 1 uppercase and 1 lowercase letter.";
                lblMessage.Visible = true;
                return;
            }

            using (var db = new AppDbContext())
            {
                // 2. Check if username or email already exists
                if (db.Users.Any(u => u.Username == username || u.MailAddress == email))
                {
                    lblMessage.Text = "❌ Username or Email already taken.";
                    lblMessage.Visible = true;
                    return;
                }

                // 3. Hash the password securely
                string hashedPassword = BCrypt.Net.BCrypt.HashPassword(rawPassword, 11);

                // 4. Create the Teacher object
                var newTeacher = new User
                {
                    Username = username,
                    MailAddress = email,
                    Password = hashedPassword,
                    Role = "Teacher", // Set automatically
                    CreatedAt = DateTime.Now,
                    UpdatedAt = DateTime.Now
                };

                db.Users.Add(newTeacher);
                db.SaveChanges();

                // 🔥 TRIGGER AUDIT LOG 🔥
                int adminId = Convert.ToInt32(Session["UserId"] ?? 1);
                SystemLogger.LogEvent(adminId, "Created Teacher Account", "User Management", $"{{ \"new_teacher_id\": {newTeacher.UserId}, \"username\": \"{newTeacher.Username}\" }}");

                // Redirect back with a success message
                Response.Redirect("ManageUsers.aspx?status=success");
            }
        }
    }
}