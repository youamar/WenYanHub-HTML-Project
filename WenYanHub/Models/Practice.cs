using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    public class Practice
    {
        [Key]
        public int PracticeId { get; set; }

        public int TeacherId { get; set; }
        [ForeignKey("TeacherId")]
        public virtual User Teacher { get; set; }

        [Required]
        [StringLength(200)]
        public string Title { get; set; }

        public string Description { get; set; }

        [Required]
        public string QuestionFileUrl { get; set; }

        public DateTime DueDate { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public string Approved { get; set; } = "Pending";

        // 导航属性：一个作业可以有多个学生的提交
        public virtual ICollection<HomeworkSubmission> Submissions { get; set; }
    }
}