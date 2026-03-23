using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    [Table("SystemReports")]
    public class SystemReport
    {
        [Key]
        public int ReportId { get; set; }

        public int GeneratedByUserId { get; set; }

        [Required]
        [StringLength(200)]
        public string ReportName { get; set; }

        [Required]
        [StringLength(100)]
        public string ReportType { get; set; } // e.g., "UserActivity", "ContentStats"

        public string ReportData { get; set; } // JSON string

        public DateTime GeneratedAt { get; set; } = DateTime.Now;

        // 导航属性
        [ForeignKey("GeneratedByUserId")]
        public virtual User GeneratedByUser { get; set; }
    }
}