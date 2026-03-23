using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;
using WenYanHub.Models;

namespace WenYanHub.Learning
{
    public partial class Mini_Game : System.Web.UI.Page
    {
        public string JsonQuestions = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string cidStr = Request.QueryString["cid"];
                if (int.TryParse(cidStr, out int cid))
                {
                    LoadQuestions(cid);
                }
            }
        }

        private void LoadQuestions(int cid)
        {
            using (var db = new AppDbContext())
            {
                var rawData = db.Questions
                    .Where(q => q.ContentId == cid && q.QuestionType == "quiz")
                    .OrderBy(r => Guid.NewGuid())
                    .Take(5)
                    .Select(q => new {
                        q.QuestionText,
                        q.CorrectAnswer,
                        q.OptionA,
                        q.OptionB,
                        q.OptionC,
                        q.OptionD
                    }).ToList();

                var quizList = rawData.Select(q => new {
                    q = q.QuestionText,
                    a = q.CorrectAnswer,
                    options = new string[] { q.OptionA, q.OptionB, q.OptionC, q.OptionD }
                }).ToList();

                JsonQuestions = JsonConvert.SerializeObject(quizList);
            }
        }
    }
}