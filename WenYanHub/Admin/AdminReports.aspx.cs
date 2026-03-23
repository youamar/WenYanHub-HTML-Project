using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Data.Entity;
using WenYanHub.Models;

namespace WenYanHub.Admin
{
    public partial class AdminReports : System.Web.UI.Page
    {
        private int CurrentLogPage
        {
            get { return ViewState["CurrentLogPage"] != null ? (int)ViewState["CurrentLogPage"] : 0; }
            set { ViewState["CurrentLogPage"] = value; }
        }

        private const int LogPageSize = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindQuickStats();
                BindLeaderboards();
                BindSystemLogs();
            }
        }

        protected void ddlChartRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindQuickStats();
        }

        protected void btnGenerateLog_Click(object sender, EventArgs e)
        {
            using (var db = new AppDbContext())
            {
                int adminId = Convert.ToInt32(Session["UserId"] ?? 1);

                int totalUsers = db.Users.Count();
                int totalContent = db.Contents.Count();
                int pendingTickets = db.Feedbacks.Count(f => f.Status == "Pending" || f.Status == "Open");

                string jsonData = $"{{ \"total_users\": {totalUsers}, \"total_content\": {totalContent}, \"pending_tickets\": {pendingTickets}, \"status\": \"OK\" }}";

                db.SystemReports.Add(new SystemReport
                {
                    GeneratedByUserId = adminId,
                    ReportName = "Manual System Summary",
                    ReportType = "ContentStats",
                    ReportData = jsonData,
                    GeneratedAt = DateTime.Now
                });

                db.SaveChanges();
            }

            CurrentLogPage = 0;
            BindSystemLogs();

            hfActiveReportTab.Value = "logs";

            BindQuickStats();
            BindLeaderboards();
        }

        private void BindSystemLogs()
        {
            using (var db = new AppDbContext())
            {
                var query = db.SystemReports.Include(r => r.GeneratedByUser).AsQueryable();

                if (!string.IsNullOrEmpty(ddlLogType.SelectedValue))
                {
                    string logType = ddlLogType.SelectedValue;
                    query = query.Where(r => r.ReportType == logType);
                }

                string search = txtLogSearch.Text.Trim().ToLower();
                if (!string.IsNullOrEmpty(search))
                {
                    query = query.Where(r => r.ReportName.ToLower().Contains(search) ||
                                             r.ReportData.ToLower().Contains(search) ||
                                             (r.GeneratedByUser != null && r.GeneratedByUser.Username.ToLower().Contains(search)));
                }

                if (DateTime.TryParse(txtStartDate.Text, out DateTime startDate))
                {
                    query = query.Where(r => r.GeneratedAt >= startDate);
                }
                if (DateTime.TryParse(txtEndDate.Text, out DateTime endDate))
                {
                    DateTime endDateLimit = endDate.Date.AddDays(1).AddTicks(-1);
                    query = query.Where(r => r.GeneratedAt <= endDateLimit);
                }

                int totalRecords = query.Count();
                litLogTotalRecords.Text = totalRecords.ToString();

                int calculatedTotalPages = (int)Math.Ceiling((double)totalRecords / LogPageSize);
                if (calculatedTotalPages == 0) calculatedTotalPages = 1;

                if (CurrentLogPage >= calculatedTotalPages) CurrentLogPage = calculatedTotalPages - 1;
                if (CurrentLogPage < 0) CurrentLogPage = 0;

                var logs = query.OrderByDescending(r => r.GeneratedAt)
                                .Skip(CurrentLogPage * LogPageSize)
                                .Take(LogPageSize)
                                .ToList()
                                .Select(r => {

                                    // THE FIX: Using strictly Hollow Outline CSS Classes
                                    string badge = "badge-outline-dark";

                                    if (r.ReportType == "Security" || r.ReportType == "Maintenance")
                                        badge = "badge-outline-red";
                                    else if (r.ReportType == "ContentStats" || r.ReportType == "Content Moderation")
                                        badge = "badge-outline-gold";

                                    return new
                                    {
                                        r.GeneratedAt,
                                        r.ReportName,
                                        r.ReportType,
                                        FullJson = r.ReportData,
                                        JsonSnippet = CreateJsonSnippet(r.ReportData),
                                        Username = r.GeneratedByUser != null ? r.GeneratedByUser.Username : "System",
                                        TypeBadgeClass = badge
                                    };
                                }).ToList();

                rptSystemLogs.DataSource = logs;
                rptSystemLogs.DataBind();

                phNoLogs.Visible = !logs.Any();

                litLogCurrentPage.Text = (CurrentLogPage + 1).ToString();
                litLogTotalPages.Text = calculatedTotalPages.ToString();

                pnlLogPagination.Visible = totalRecords > LogPageSize;

                btnPrevLogPage.Visible = CurrentLogPage > 0;
                btnNextLogPage.Visible = CurrentLogPage < (calculatedTotalPages - 1);
            }
        }

        protected void btnApplyFilters_Click(object sender, EventArgs e)
        {
            CurrentLogPage = 0;
            BindSystemLogs();
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            txtLogSearch.Text = "";
            ddlLogType.SelectedIndex = 0;
            txtStartDate.Text = "";
            txtEndDate.Text = "";
            CurrentLogPage = 0;
            BindSystemLogs();
        }

        protected void btnPrevLogPage_Click(object sender, EventArgs e)
        {
            CurrentLogPage--;
            BindSystemLogs();
        }

        protected void btnNextLogPage_Click(object sender, EventArgs e)
        {
            CurrentLogPage++;
            BindSystemLogs();
        }

        private string CreateJsonSnippet(string json)
        {
            if (string.IsNullOrEmpty(json)) return "{ }";
            string clean = json.Replace("\n", "").Replace("\r", "").Replace("  ", " ");
            if (clean.Length <= 45) return clean;
            return clean.Substring(0, 42) + "... }";
        }

        private void BindQuickStats()
        {
            using (var db = new AppDbContext())
            {
                DateTime startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);

                litTotalUsers.Text = db.Users.Count(u => u.CreatedAt >= startOfMonth).ToString();
                litContentThisMonth.Text = db.Contents.Count(c => c.CreatedAt >= startOfMonth).ToString();
                litResolvedTickets.Text = db.Feedbacks.Count(f => f.Status == "Solved").ToString();

                string range = ddlChartRange.SelectedValue;
                List<string> chartLabels = new List<string>();
                List<int> chartData = new List<int>();

                if (range == "12")
                {
                    int currentYear = DateTime.Now.Year;
                    for (int month = 1; month <= 12; month++)
                    {
                        DateTime targetMonth = new DateTime(currentYear, month, 1);
                        string monthLabel = targetMonth.ToString("MMM");

                        int count = db.Users.Count(u => u.CreatedAt.Year == currentYear && u.CreatedAt.Month == month);

                        chartLabels.Add($"\"{monthLabel}\"");
                        chartData.Add(count);
                    }
                }
                else
                {
                    int monthsToShow = int.Parse(range);
                    for (int i = monthsToShow - 1; i >= 0; i--)
                    {
                        DateTime targetMonth = DateTime.Now.AddMonths(-i);
                        string monthLabel = targetMonth.ToString("MMM yy");

                        int count = db.Users.Count(u => u.CreatedAt.Year == targetMonth.Year && u.CreatedAt.Month == targetMonth.Month);

                        chartLabels.Add($"\"{monthLabel}\"");
                        chartData.Add(count);
                    }
                }

                hfChartLabels.Value = "[" + string.Join(",", chartLabels) + "]";
                hfChartData.Value = "[" + string.Join(",", chartData) + "]";
            }
        }

        private void BindLeaderboards()
        {
            using (var db = new AppDbContext())
            {
                var topTeachers = db.Notes
                    .Where(n => n.TeacherId != null)
                    .GroupBy(n => n.TeacherId)
                    .Select(g => new
                    {
                        TeacherId = g.Key,
                        NotesCount = g.Count(),
                        LastActiveDate = g.Max(n => n.CreatedAt)
                    })
                    .OrderByDescending(x => x.NotesCount)
                    .Take(50)
                    .ToList();

                var teacherData = topTeachers.Select(t => new
                {
                    TeacherName = db.Users.FirstOrDefault(u => u.UserId == t.TeacherId)?.Username ?? "Unknown Teacher",
                    NotesCount = t.NotesCount,
                    LastActive = t.LastActiveDate.ToString("MMM dd, yyyy")
                }).ToList();

                rptTopTeachers.DataSource = teacherData;
                rptTopTeachers.DataBind();
                phNoTeachers.Visible = !teacherData.Any();

                var topStudents = db.QuizScores
                    .GroupBy(q => q.UserId)
                    .Select(g => new
                    {
                        UserId = g.Key,
                        QuizzesTaken = g.Count(),
                        TotalScore = g.Sum(q => (double)q.Score)
                    })
                    .OrderByDescending(x => x.QuizzesTaken)
                    .Take(50)
                    .ToList();

                var studentData = topStudents.Select(s => new
                {
                    StudentName = db.Users.FirstOrDefault(u => u.UserId == s.UserId)?.Username ?? "Unknown Student",
                    QuizzesTaken = s.QuizzesTaken,
                    AvgScore = Math.Round((s.TotalScore / (s.QuizzesTaken * 1000.0)) * 100, 1)
                }).ToList();

                rptTopStudents.DataSource = studentData;
                rptTopStudents.DataBind();
                phNoStudents.Visible = !studentData.Any();
            }
        }
    }
}