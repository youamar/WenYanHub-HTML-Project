using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    [Table("Notifications")]
    public class Notification
    {
        [Key]
        public int NotificationId { get; set; }

        [Required]
        [StringLength(200)]
        public string Title { get; set; }

        [Required]
        public string Message { get; set; }

        [Required]
        [StringLength(50)]
        public string TargetRole { get; set; } // e.g., "All", "Member", "Admin"

        public int? UserId { get; set; } // 如果是私信，这里有值；如果是群发，这里为 null

        public bool IsRead { get; set; } = false;

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // 导航属性
        [ForeignKey("UserId")]
        public virtual User User { get; set; }
    }
}