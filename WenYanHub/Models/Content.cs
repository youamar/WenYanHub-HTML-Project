using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    [Table("Contents")]
    public class Content
    {
        [Key]
        public int ContentId { get; set; }

        [Required]
        public string Title { get; set; }   // 标题

        public string Category { get; set; } // 分类
        public string Analysis { get; set; } // 赏析

        public string Genre { get; set; } 
        public string Picture { get; set; }
        public string Video { get; set; }
        public string ContentText { get; set; } // 全文内容
        public string Approved { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime UpdatedAt { get; set; } = DateTime.Now;
        public int? AuthorId { get; set; } // 允许为空(Nullable)，兼容旧数据

        [ForeignKey("AuthorId")]
        public virtual Author Author { get; set; } // ✅ 这样就不会和上面的 string Author 冲突了

        public int? TeacherId { get; set; } // 加了 ? 代表允许为空 (以前的数据可能是空的)
        [ForeignKey("TeacherId")]
        public virtual User Teacher { get; set; }

        // 其他关联
        public virtual ICollection<Sentence> Sentences { get; set; }
        public virtual ICollection<Word> Words { get; set; }
        public virtual ICollection<Comment> Comments { get; set; }
    }
}