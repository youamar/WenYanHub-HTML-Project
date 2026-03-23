using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    [Table("Sentences")]
    public class Sentence
    {
        [Key]
        public int SentenceId { get; set; }

        public int ContentId { get; set; }
        [ForeignKey("ContentId")]
        public virtual Content Content { get; set; }

        public string SentenceText { get; set; }
        public string Translate { get; set; }
        public string AudioFile { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime UpdatedAt { get; set; } = DateTime.Now;
    }
}