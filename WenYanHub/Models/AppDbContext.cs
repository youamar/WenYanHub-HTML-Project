using System.Data.Entity; // 注意引用的是 System.Data.Entity

namespace WenYanHub.Models
{
    public class AppDbContext : DbContext
    {
        // 🔥 FIXED: This now exactly matches the <add name="AppDbContext"...> in your Web.config
        public AppDbContext() : base("name=AppDbContext")
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Content> Contents { get; set; }
        public DbSet<Sentence> Sentences { get; set; }
        public DbSet<Word> Words { get; set; }
        public DbSet<Comment> Comments { get; set; }
        public DbSet<Feedback> Feedbacks { get; set; }
        public DbSet<Note> Notes { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<Question> Questions { get; set; }
        public DbSet<SystemReport> SystemReports { get; set; }
        public DbSet<VideoRecord> VideoRecords { get; set; }
        public DbSet<Author> Author { get; set; }
        public DbSet<OtpRecord> OtpRecords { get; set; }
        public DbSet<Practice> Practices { get; set; }
        public DbSet<HomeworkSubmission> HomeworkSubmissions { get; set; }
        public DbSet<ZoomSession> ZoomSessions { get; set; }
        public DbSet<QuizScore> QuizScores { get; set; }
        public DbSet<TeacherMessage> TeacherMessages { get; set; }
    }
}