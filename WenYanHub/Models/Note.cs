using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    [Table("Notes")]
    public class Note
    {
        [Key]
        public int NoteId { get; set; }

        public int ContentId { get; set; }

        [Required]
        public string NoteContent { get; set; }

        public string Approved { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime UpdatedAt { get; set; } = DateTime.Now;

        // 导航属性
        [ForeignKey("ContentId")]
        public virtual Content Content { get; set; }

        public int? TeacherId { get; set; } // 加了 ? 代表允许为空 (以前的数据可能是空的)
        [ForeignKey("TeacherId")]
        public virtual User Teacher { get; set; }
    }
}