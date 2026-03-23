using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    public class ZoomSession
    {
        [Key]
        public int ZoomSessionId { get; set; }

        public int TeacherId { get; set; }
        [ForeignKey("TeacherId")]
        public virtual User Teacher { get; set; }

        [Required]
        [StringLength(200)]
        public string Title { get; set; }

        public string Description { get; set; }

        [Required]
        public string ZoomJoinUrl { get; set; }

        [StringLength(100)]
        public string MeetingId { get; set; }

        [StringLength(100)]
        public string Passcode { get; set; }

        public DateTime StartTime { get; set; }
        public int DurationMinutes { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}