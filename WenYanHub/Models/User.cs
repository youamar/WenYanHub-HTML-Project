using System;
using System.Collections.Generic; // 🔥 Required for ICollection
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema; // 🔥 Required for InverseProperty

namespace WenYanHub.Models
{
    public class User
    {
        [Key]
        public int UserId { get; set; }

        [Required]
        [StringLength(50)]
        public string Username { get; set; }

        [Required]
        [StringLength(100)]
        public string MailAddress { get; set; }

        [Required]
        [StringLength(255)]
        public string Password { get; set; }

        public string Role { get; set; }

        // 头像和联络方式
        public string ProfilePictureUrl { get; set; }

        [StringLength(50)]
        public string ContactNumber { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime UpdatedAt { get; set; } = DateTime.Now;

        // 🔥 THE MAGIC BRIDGE 🔥
        // This tells Entity Framework: "If you want my videos or contents, 
        // look for the 'Teacher' property in those files. Do NOT look for UserId!"

        [InverseProperty("Teacher")]
        public virtual ICollection<VideoRecord> VideoRecords { get; set; }

        [InverseProperty("Teacher")]
        public virtual ICollection<Content> Contents { get; set; }

        // If you have a Note.cs, uncomment this:
        // [InverseProperty("Teacher")]
        // public virtual ICollection<Note> Notes { get; set; }
    }
}