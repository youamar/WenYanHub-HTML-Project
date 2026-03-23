using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using WenYanHub.Models;
using WenYanHub.Admin.Utils;

namespace WenYanHub.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        private int CurrentPage
        {
            get { return ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 0; }
            set { ViewState["CurrentPage"] = value; }
        }

        private const int PageSize = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) { BindUsers(); }
        }

        protected void ApplyFilters(object sender, EventArgs e) { CurrentPage = 0; BindUsers(); }
        protected void btnPrevPage_Click(object sender, EventArgs e) { CurrentPage--; BindUsers(); }
        protected void btnNextPage_Click(object sender, EventArgs e) { CurrentPage++; BindUsers(); }

        private void BindUsers()
        {
            using (var db = new AppDbContext())
            {
                var query = db.Users.AsQueryable();

                string searchTerm = txtSearch.Text.Trim();
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query = query.Where(u => u.Username.Contains(searchTerm) || u.MailAddress.Contains(searchTerm));
                }

                bool showAdmin = chkFilterAdmin.Checked;
                bool showTeacher = chkFilterTeacher.Checked;
                bool showMember = chkFilterMember.Checked;

                var allUsers = query.ToList();

                var allFiltered = allUsers.Where(u => {
                    string r = (u.Role ?? "").Trim().ToLower();
                    bool isAdmin = r == "admin";
                    bool isTeacher = r == "teacher";
                    bool isMember = !isAdmin && !isTeacher;

                    return (showAdmin && isAdmin) || (showTeacher && isTeacher) || (showMember && isMember);
                }).ToList();

                int totalRecords = allFiltered.Count;

                int totalPages = (totalRecords + PageSize - 1) / PageSize;
                if (totalPages == 0) totalPages = 1;

                if (CurrentPage >= totalPages) CurrentPage = totalPages - 1;
                if (CurrentPage < 0) CurrentPage = 0;

                var rawList = allFiltered.OrderByDescending(u => u.CreatedAt)
                                         .Skip(CurrentPage * PageSize)
                                         .Take(PageSize)
                                         .ToList();

                var mappedData = rawList.Select(u => {

                    string badgeClass = "badge-outline-dark";

                    if (u.Role == "Admin")
                        badgeClass = "badge-outline-red";
                    else if (u.Role == "Teacher")
                        badgeClass = "badge-outline-gold";

                    string safeUsername = string.IsNullOrEmpty(u.Username) ? "User" : Uri.EscapeDataString(u.Username);
                    string finalPicUrl = !string.IsNullOrEmpty(u.ProfilePictureUrl)
                        ? ResolveUrl(u.ProfilePictureUrl)
                        : $"https://ui-avatars.com/api/?name={safeUsername}&background=D4AF37&color=fff&bold=true";

                    return new
                    {
                        u.UserId,
                        Username = string.IsNullOrEmpty(u.Username) ? "Unknown" : u.Username,
                        Role = string.IsNullOrEmpty(u.Role) ? "Member" : u.Role,
                        MailAddress = u.MailAddress,
                        JoinedDate = u.CreatedAt.ToString("MMM dd, yyyy HH:mm"),
                        RoleBadgeClass = badgeClass,
                        ProfilePic = finalPicUrl
                    };
                }).ToList();

                rptUsers.DataSource = mappedData;
                rptUsers.DataBind();

                phNoUsers.Visible = !mappedData.Any();

                litCurrentPage.Text = (CurrentPage + 1).ToString();
                litTotalPages.Text = totalPages.ToString();

                btnPrevPage.Visible = CurrentPage > 0;
                btnNextPage.Visible = CurrentPage < (totalPages - 1);
            }
        }

        private string HashPassword(string plainTextPassword)
        {
            return BCrypt.Net.BCrypt.HashPassword(plainTextPassword, 11);
        }

        protected void btnCreateUser_Click(object sender, EventArgs e)
        {
            // 🔥 SERVER-SIDE VALIDATION FIX 🔥
            Page.Validate("AddUserGroup");
            if (!Page.IsValid)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "ReopenModal", "openAddModal();", true);
                return;
            }

            string newEmail = txtAddEmail.Text.Trim();
            string newUsername = txtAddUsername.Text.Trim();
            string plainPassword = txtAddPassword.Text;

            using (var db = new AppDbContext())
            {
                bool emailExists = db.Users.Any(u => u.MailAddress == newEmail);

                if (emailExists)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "ErrorAlert", "alert('Creation Failed: This Email Address is already registered.'); openAddModal();", true);
                    return;
                }

                var newUser = new User
                {
                    Username = newUsername,
                    MailAddress = newEmail,
                    Password = HashPassword(plainPassword),
                    Role = ddlAddRole.SelectedValue,
                    CreatedAt = DateTime.Now,
                    UpdatedAt = DateTime.Now
                };

                db.Users.Add(newUser);
                db.SaveChanges();

                int adminId = Convert.ToInt32(Session["UserId"] ?? 1);
                SystemLogger.LogEvent(adminId, "Created User Account", "User Management", $"{{ \"new_user\": \"{newUsername}\", \"role\": \"{newUser.Role}\" }}");
            }

            txtAddUsername.Text = ""; txtAddEmail.Text = ""; txtAddPassword.Text = "";
            CurrentPage = 0; BindUsers();
            ScriptManager.RegisterStartupScript(this, GetType(), "SuccessAlert", "alert('User created successfully!');", true);
        }

        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            Page.Validate("EditUserGroup");
            if (!Page.IsValid)
            {
                string rawIdFail = hfEditUserId.Value;
                string usernameFail = txtEditUsername.Text;
                string emailFail = txtEditEmail.Text;
                string roleFail = ddlEditRole.SelectedValue;
                ScriptManager.RegisterStartupScript(this, GetType(), "ReopenEditModal", $"openEditModal('{rawIdFail}', '{usernameFail}', '{roleFail}', '{emailFail}');", true);
                return;
            }

            string rawId = hfEditUserId.Value;
            string newPassword = txtEditPassword.Text;

            if (int.TryParse(rawId, out int userId))
            {
                using (var db = new AppDbContext())
                {
                    var user = db.Users.Find(userId);
                    if (user != null)
                    {
                        user.Role = ddlEditRole.SelectedValue;

                        if (!string.IsNullOrEmpty(newPassword))
                        {
                            user.Password = HashPassword(newPassword);
                        }

                        user.UpdatedAt = DateTime.Now;
                        db.SaveChanges();

                        int adminId = Convert.ToInt32(Session["UserId"] ?? 1);
                        SystemLogger.LogEvent(adminId, "Modified User Account", "User Management", $"{{ \"user_id\": {userId}, \"new_role\": \"{user.Role}\", \"password_reset\": {!string.IsNullOrEmpty(newPassword)} }}");
                    }
                }
                BindUsers();
            }
        }

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteUser")
            {
                if (int.TryParse(e.CommandArgument.ToString(), out int userId))
                {
                    using (var db = new AppDbContext())
                    {
                        var user = db.Users.Find(userId);
                        if (user != null)
                        {
                            string deletedUsername = user.Username;
                            string deletedRole = user.Role;

                            db.Users.Remove(user);
                            db.SaveChanges();

                            int adminId = Convert.ToInt32(Session["UserId"] ?? 1);
                            SystemLogger.LogEvent(adminId, "Deleted User Account", "User Management", $"{{ \"deleted_user_id\": {userId}, \"username\": \"{deletedUsername}\", \"role\": \"{deletedRole}\" }}");
                        }
                    }
                    BindUsers();
                }
            }
        }
    }
}