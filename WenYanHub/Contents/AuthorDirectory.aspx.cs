using System;
using System.Linq;
using System.Web.UI;
using WenYanHub.Models;

namespace WenYanHub
{
    public partial class AuthorDirectory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAllAuthors();
            }
        }

        private void LoadAllAuthors()
        {
            // 注意：这里使用你截图里的 AppDbContext
            using (var db = new AppDbContext())
            {
                try
                {
                    // 从数据库获取所有作者，按朝代排序
                    var authors = db.Author.OrderBy(a => a.Dynasty).ToList();

                    if (authors.Count > 0)
                    {
                        rptAuthors.DataSource = authors;
                        rptAuthors.DataBind();

                        rptAuthors.Visible = true;
                        lblNoAuthors.Visible = false;
                    }
                    else
                    {
                        rptAuthors.Visible = false;
                        lblNoAuthors.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    // 如果数据库连接出错
                    // System.Diagnostics.Debug.WriteLine(ex.Message);
                    lblNoAuthors.Text = "Error loading authors: " + ex.Message;
                    lblNoAuthors.Visible = true;
                }
            }
        }
    }
}