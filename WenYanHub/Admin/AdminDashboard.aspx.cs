using System;
using System.Linq;
using System.Data.Entity;
using WenYanHub.Models;

namespace WenYanHub.Admin
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardData();
            }
        }

        private void LoadDashboardData()
        {
            using (var db = new AppDbContext())
            {
                // 1. Pending Queue (Total Count)
                var pendingQuery = db.Contents.Where(c => c.Approved != null && c.Approved.ToLower() == "pending");
                litPending.Text = pendingQuery.Count().ToString();

                // 2. TOTAL USERS (Absolute raw count)
                litUsers.Text = db.Users.Count().ToString();

                // 3. Urgent Threshold Indicator & Urgent Approvals List (Middle Card)
                DateTime threeDaysAgo = DateTime.Now.AddDays(-3);

                // Count for the bottom left indicator
                int overdueCount = pendingQuery.Count(c => c.CreatedAt <= threeDaysAgo);

                if (overdueCount > 0)
                {
                    litOverdueContent.Text = $"<span class='text-semantic-danger fw-bold'><i class='fa-solid fa-fire me-1'></i> {overdueCount} Items Overdue (3+ days)</span>";
                }
                else
                {
                    litOverdueContent.Text = "<span class='small fw-bold text-theme-accent'><i class='fa-solid fa-check-circle me-1'></i> Queue is healthy</span>";
                }

                // Fetch the actual records for the middle card (Oldest first, capped at 5)
                // Fetch the actual records for the middle card (Oldest first, capped at 5)
                var urgentItems = pendingQuery
                    .Where(c => c.CreatedAt <= threeDaysAgo)
                    .OrderBy(c => c.CreatedAt)
                    .Take(5)
                    .ToList() // Bring to memory to calculate DaysOld safely
                    .Select(c => new
                    {
                        Title = c.Title,

                        // 🔥 FIX: Changed c.Author.Username to c.Author.Name based on your model!
                        AuthorName = c.Author != null ? c.Author.Name : "Unknown Author",

                        DaysOld = (int)(DateTime.Now - c.CreatedAt).TotalDays
                    })
                    .ToList();

                rptUrgentContent.DataSource = urgentItems;
                rptUrgentContent.DataBind();

                phNoPending.Visible = !urgentItems.Any();

                // 4. Recent Tickets (Right Card)
                var recentTickets = db.Feedbacks
                                       .OrderByDescending(f => f.CreatedAt)
                                       .Take(5)
                                       .ToList()
                                       .Select(f => new
                                       {
                                           Category = f.Category ?? "Report",
                                           CategoryClass = GetTicketClass(f.Category),
                                           MessageSnippet = f.Message?.Length > 35 ? f.Message.Substring(0, 32) + "..." : f.Message,
                                           TimeAgo = GetFormattedTime(f.CreatedAt)
                                       }).ToList();

                rptRecentTickets.DataSource = recentTickets;
                rptRecentTickets.DataBind();
                phNoTickets.Visible = !recentTickets.Any();
            }
        }

        private string GetTicketClass(string cat)
        {
            if (string.IsNullOrEmpty(cat)) return "badge-outline-dark";
            cat = cat.ToLower();

            if (cat == "bug" || cat == "error") return "badge-outline-red";
            if (cat == "request" || cat == "suggestion") return "badge-outline-gold";

            return "badge-outline-dark";
        }

        private string GetFormattedTime(DateTime dt)
        {
            TimeSpan span = DateTime.Now - dt;
            if (span.TotalHours < 1) return $"{(int)span.TotalMinutes}m ago";
            if (span.TotalDays < 1) return $"{(int)span.TotalHours}h ago";
            return dt.ToString("MMM dd");
        }
    }
}