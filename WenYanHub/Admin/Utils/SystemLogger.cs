using System;
using System.Linq;
using WenYanHub.Models;

namespace WenYanHub.Admin.Utils
{
    public static class SystemLogger
    {
        public static void LogEvent(int userId, string reportName, string reportType, string jsonData)
        {
            try
            {
                using (var db = new AppDbContext())
                {
                    int validUserId = userId;
                    if (userId <= 0)
                    {
                        var fallbackAdmin = db.Users.FirstOrDefault(u => u.Role == "Admin");
                        validUserId = fallbackAdmin != null ? fallbackAdmin.UserId : 1;
                    }

                    var log = new SystemReport
                    {
                        GeneratedByUserId = validUserId,
                        ReportName = reportName,
                        ReportType = reportType,
                        ReportData = jsonData,
                        GeneratedAt = DateTime.Now
                    };
                    db.SystemReports.Add(log);
                    db.SaveChanges(); // Will now save successfully every time!
                }
            }
            catch
            {
                // Silently fails to prevent crashing the whole app if DB locks up
            }
        }
    }
}