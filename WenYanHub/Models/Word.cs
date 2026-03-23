using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    [Table("Words")]
    public class Word
    {
        [Key]
        public int WordId { get; set; }

        public int ContentId { get; set; }

        
        [ForeignKey("ContentId")]
        public virtual Content Content { get; set; }

        [Required(ErrorMessage = "Vocabulary word is required.")]
        public string Vocabulary { get; set; }

        public string Annotations { get; set; }
        public string Pinyin { get; set; }
        public string WordUrl { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime UpdatedAt { get; set; } = DateTime.Now;
    }
}