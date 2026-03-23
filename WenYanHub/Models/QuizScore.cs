using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    [Table("QuizScores")]
    public class QuizScore
    {
        [Key]
        public int QuizScoreId { get; set; }

        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public virtual User User { get; set; }

        public int ContentId { get; set; }

        // 确保这里和数据库一致。如果数据库是 INT，这里也要用 int
        public int Score { get; set; }

        public int AttemptNumber { get; set; } = 1;

        public DateTime TakenAt { get; set; } = DateTime.Now;
    }
}