using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WenYanHub.Models
{
    public class OtpRecord
    {
        [Key]
        public int OtpRecordId { get; set; }

        [Required]
        [MaxLength(255)]
        public string Email { get; set; }

        [Required]
        [MaxLength(10)]
        public string OtpCode { get; set; }

        public DateTime CreatedAt { get; set; }

        // 设定过期时间（例如 10 分钟后）
        public DateTime ExpiresAt { get; set; }

        // 标记这个验证码是否已经成功用于注册（防止二次利用）
        public bool IsUsed { get; set; }

        // [可选] 记录用户的 IP 地址，方便后期做防刷/安全风控
        [MaxLength(50)]
        public string IpAddress { get; set; }
    }
}