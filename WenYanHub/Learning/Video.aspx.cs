using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Text.RegularExpressions;
using WenYanHub.Models;

namespace WenYanHub.Learning
{
    public partial class Video : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int contentId;
                if (int.TryParse(Request.QueryString["id"], out contentId))
                {
                    LoadVideoData(contentId);
                }
                else
                {
                    Response.Redirect("VideoSelection.aspx");
                }
            }
        }

        private void LoadVideoData(int contentId)
        {
            using (var db = new AppDbContext())
            {
                // 1. Get the article title
                var content = db.Contents.FirstOrDefault(c => c.ContentId == contentId);
                if (content != null)
                {
                    litArticleTitle.Text = content.Title;
                }

                // 2. Retrieve all approved videos under this article and search for teacher information.
                var videos = db.VideoRecords
                    .Include(v => v.Teacher) 
                    .Where(v => v.ContentId == contentId && v.Approved == "Approved")
                    .OrderByDescending(v => v.CreatedAt)
                    .ToList();

                if (videos.Any())
                {
                    rptVideos.DataSource = videos;
                    rptVideos.DataBind();
                }
                else
                {
                    pnlNoVideos.Visible = true;
                }
            }
        }

        public string GetEmbedUrl(string url)
        {
            if (string.IsNullOrEmpty(url)) return "";

            string videoId = "";

            var match = Regex.Match(url, @"(?:youtu\.be\/|youtube\.com\/(?:referring\/|v\/|u\/\w\/|embed\/|watch\?v=))(?<id>[\w-]{11})");

            if (match.Success)
            {
                videoId = match.Groups["id"].Value;
                // Force the return of the standard embed format and add rel=0 to avoid recommending other people's videos after playback.
                return $"https://www.youtube.com/embed/{videoId}?rel=0";
            }

            return url;
        }
    }
}