using System;
using System.Web;
using System.Web.SessionState; // 必须引用以支持 Session (以防后续需要做权限验证)
using WenYanHub.Models;

namespace WenYanHub
{
    // 实现 IRequiresSessionState 以防你需要校验当前登录用户的 Session
    public class NotifHandler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            // 获取前端 URL 传来的 NotificationId
            if (int.TryParse(context.Request["id"], out int notifId))
            {
                try
                {
                    using (var db = new AppDbContext())
                    {
                        var notif = db.Notifications.Find(notifId);
                        if (notif != null && !notif.IsRead)
                        {
                            notif.IsRead = true;
                            db.SaveChanges(); // 更新数据库
                        }
                    }
                    context.Response.Write("{\"success\": true}");
                }
                catch (Exception ex)
                {
                    context.Response.Write($"{{\"success\": false, \"error\": \"{ex.Message}\"}}");
                }
            }
            else
            {
                context.Response.Write("{\"success\": false, \"error\": \"Invalid ID\"}");
            }
        }

        public bool IsReusable => false;
    }
}