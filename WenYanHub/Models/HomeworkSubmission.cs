using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    public class HomeworkSubmission
    {
        [Key]
        public int SubmissionId { get; set; }

        public int PracticeId { get; set; }
        [ForeignKey("PracticeId")]
        public virtual Practice Practice { get; set; }

        public int StudentId { get; set; }
        [ForeignKey("StudentId")]
        public virtual User Student { get; set; }

        // --- 学生提交部分 ---
        [Required]
        public string StudentAnswerFileUrl { get; set; }
        public DateTime SubmittedAt { get; set; } = DateTime.Now;
        public string Status { get; set; } = "Pending"; // 状态：Pending / Graded

        // --- 老师批改部分 (允许为空) ---

        public int TeacherId { get; set; }
        [ForeignKey("TeacherId")]
        public virtual User Teacher { get; set; }
        public decimal? Score { get; set; }
        public string TeacherFeedbackFileUrl { get; set; }
        public string TeacherComments { get; set; }
        public DateTime? GradedAt { get; set; }
        public bool IsFeedbackHidden { get; set; }
    }
}