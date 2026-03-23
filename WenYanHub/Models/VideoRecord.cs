using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using WenYanHub.Models;

[Table("VideoRecords")]
public class VideoRecord
{
    [Key]
    public int RecordId { get; set; }

    public int ContentId { get; set; }

    // 💡 关键：确保这里只保留 TeacherId，并删除原来的 UserId 属性
    public int? TeacherId { get; set; }
    public string Description { get; set; }
    public string RecordLink { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.Now;
    public DateTime UpdatedAt { get; set; } = DateTime.Now;

    public string Approved { get; set; }

    // 导航属性
    [ForeignKey("ContentId")]
    public virtual Content Content { get; set; }

    // 💡 关键：只保留这一个导航属性，并指向 TeacherId
    [ForeignKey("TeacherId")]
    public virtual User Teacher { get; set; }
}