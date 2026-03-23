using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using WenYanHub.Models;

namespace WenYanHub.Learning
{
    public partial class VideoSelection : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindData();
            }
        }

        private void BindData()
        {
            using (var db = new AppDbContext())
            {
                // Get all articles and their authors
                var allContents = db.Contents.Include(c => c.Author).ToList();

                // 1. Junior High Data Binding and Null State Check
                var juniorList = allContents.Where(c => c.Category != null && c.Category.Contains("Junior")).ToList();
                rptJunior.DataSource = juniorList;
                rptJunior.DataBind();
                lblNoJunior.Visible = (juniorList.Count == 0);

                // 2. Senior High Data Binding and Null State Check
                var seniorList = allContents.Where(c => c.Category != null && c.Category.Contains("Senior")).ToList();
                rptSenior.DataSource = seniorList;
                rptSenior.DataBind();
                lblNoSenior.Visible = (seniorList.Count == 0);

                // 3. Extra Data Binding and Null State Check
                var extraList = allContents.Where(c => c.Category != null && !c.Category.Contains("Junior") && !c.Category.Contains("Senior")).ToList();
                rptExtra.DataSource = extraList;
                rptExtra.DataBind();
                lblNoExtra.Visible = (extraList.Count == 0);
            }
        }

        public string GetCardHtml(object dataItem, string themeColor)
        {
            var c = (dynamic)dataItem;
            string videoUrl = ResolveUrl("~/Learning/Video.aspx?id=" + c.ContentId);

            return $@"
                <div class='col-md-4 col-lg-3'>
                    <div class='card h-100 shadow-sm border-0 hover-lift'>
                        <div class='card-body text-center p-4'>
                            <span class='badge bg-{themeColor} bg-opacity-10 text-{themeColor} mb-3 px-3 py-2 rounded-pill'>{c.Category}</span>
                            <h4 class='card-title font-classic fw-bold text-dark mb-2'>{c.Title}</h4>
                            <h6 class='card-subtitle mb-4 text-muted'>{c.Author?.Name}</h6>
                            <a href='{videoUrl}' class='btn btn-outline-dark btn-sm rounded-pill px-4 stretched-link'>
                                <i class='fa-solid fa-circle-play me-1'></i> Watch Video
                            </a>
                        </div>
                    </div>
                </div>";
        }
    }
}