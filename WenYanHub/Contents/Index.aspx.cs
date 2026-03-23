using System;
using System.Linq;
using System.Web.UI;
using WenYanHub.Models;
using System.Data.Entity; 

namespace WenYanHub.Contents
{
    public partial class Index : System.Web.UI.Page
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

                var allContents = db.Contents
                                    .Include("Author")
                                    .ToList();



                // 1. Junior High
                var juniorList = allContents
                    .Where(c => c.Category != null && c.Category.IndexOf("Junior", StringComparison.OrdinalIgnoreCase) >= 0)
                    .OrderBy(c => c.Category)
                    .ToList();

                // 2. Senior High
                var seniorList = allContents
                    .Where(c => c.Category != null && c.Category.IndexOf("Senior", StringComparison.OrdinalIgnoreCase) >= 0)
                    .OrderBy(c => c.Category)
                    .ToList();

                // 3. Extra (Everything else)
                var extraList = allContents
                    .Where(c => c.Category != null &&
                                !c.Category.Contains("Junior") &&
                                !c.Category.Contains("Senior"))
                    .OrderBy(c => c.Title)
                    .ToList();

                // Bind Data
                rptJunior.DataSource = juniorList; rptJunior.DataBind();
                lblNoJunior.Visible = juniorList.Count == 0;

                rptSenior.DataSource = seniorList; rptSenior.DataBind();
                lblNoSenior.Visible = seniorList.Count == 0;

                rptExtra.DataSource = extraList; rptExtra.DataBind();
                lblNoExtra.Visible = extraList.Count == 0;
            }
        }
    }
}