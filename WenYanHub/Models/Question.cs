using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    [Table("Questions")]
    public class Question
    {
        [Key]
        public int QuestionId { get; set; }

        public int ContentId { get; set; }

        [Required]
        [StringLength(50)]
        public string QuestionType { get; set; } // MCQ (选择题), ShortAns (简答题)

        [Required]
        public string QuestionText { get; set; }

        // 选项 (如果是简答题，这些可以为空)
        public string OptionA { get; set; }
        public string OptionB { get; set; }
        public string OptionC { get; set; }
        public string OptionD { get; set; }

        public string CorrectAnswer { get; set; }
        public string Explanation { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime UpdatedAt { get; set; } = DateTime.Now;

        // 导航属性
        [ForeignKey("ContentId")]
        public virtual Content Content { get; set; }
    }
}