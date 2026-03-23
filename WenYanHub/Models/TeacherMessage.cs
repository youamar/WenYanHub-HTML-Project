using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    // The table name in the designated database is TeacherMessages.
    [Table("TeacherMessages")]
    public class TeacherMessage
    {
        [Key]
        public int MessageId { get; set; }

        // Foreign key: Points to the UserId in the User table (teacher)
        public int TeacherId { get; set; }

        // Establish a navigation property association with the User model
        [ForeignKey("TeacherId")]
        public virtual User Teacher { get; set; }

        // "Indicate the communication content and make it a mandatory field."
        [Required]
        public string Content { get; set; }

        // Automatically record the release time of the message, with the default being the current server time.
        public DateTime CreatedAt { get; set; } = DateTime.Now;


    }
}