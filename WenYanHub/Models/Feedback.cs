using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    [Table("Feedbacks")]
    public class Feedback
    {
        [Key]
        public int FeedbackId { get; set; }

        // Who sent this? (Nullable, because guests can also send feedback)
        public int? UserId { get; set; }
        public virtual User User { get; set; }

        // Contact info (Important for guests)
        [StringLength(100)]
        public string ContactEmail { get; set; }

        // Category: Bug / Content Error / Suggestion
        [Required]
        public string Category { get; set; }

        // The actual feedback message
        [Required]
        public string Message { get; set; }

        // Where did they come from? (e.g., /Contents/Details.aspx?id=5)
        public string SourceUrl { get; set; }

        // Status: Pending / Resolved / Rejected (Default is Pending)
        public string Status { get; set; } = "Pending";

        [StringLength(50)]
        public string TrackingCode { get; set; }

        // 🔥 NEW: The administrator's response/resolution note
        public string AdminReply { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime UpdatedAt { get; set; } = DateTime.Now;
    }
}