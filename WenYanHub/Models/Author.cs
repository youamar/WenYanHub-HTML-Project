using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    [Table("Authors")]
    public class Author
    {
        // 构造函数：初始化集合，防止空引用报错
        public Author()
        {
            Contents = new HashSet<Content>();
            CreatedAt = DateTime.Now;
            UpdatedAt = DateTime.Now;
        }

        [Key]
        public int AuthorId { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; } // 作者名 (原 Content.Author)

        [StringLength(50)]
        public string Dynasty { get; set; } // 朝代 (原 Content.Dynasty)

        public string Biography { get; set; } // 生平简介

        [StringLength(255)]
        public string Image { get; set; } // 头像链接

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        // ==========================================
        // 导航属性 (一对多关系)
        // ==========================================
        // 一个作者可以对应多篇课文
        public virtual ICollection<Content> Contents { get; set; }
    }
}