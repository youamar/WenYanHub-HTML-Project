<%@ Page Title="Popularity Leaderboard" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="ContentDashboard.aspx.cs" Inherits="WenYanHub.Teacher.ContentDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        
   
        .header-banner {
            background-color: #1a1513; border-radius: 20px; padding: 50px 40px;
            color: white; position: relative; overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15); margin-bottom: 40px; text-align: center;
        }

    
        .rank-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px; perspective: 1000px;
        }
        .flip-card { height: 350px; perspective: 1000px; margin-bottom: 20px; }
        .extra-content { display: none; } 

        .flip-card-inner {
            position: relative; width: 100%; height: 100%;
            transition: transform 0.6s; transform-style: preserve-3d;
            cursor: pointer;
        }
        .flip-card.active .flip-card-inner { transform: rotateY(180deg); }

        .card-front, .card-back {
            position: absolute; width: 100%; height: 100%;
            -webkit-backface-visibility: hidden; backface-visibility: hidden;
            border-radius: 15px; border: 1px solid #e0d9d5; padding: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .card-front { background: white; display: flex; flex-direction: column; justify-content: space-between; }
        .card-back { background: #fdfcf9; transform: rotateY(180deg); display: flex; flex-direction: column; }

        .rank-num { font-size: 1.2rem; color: #2C2420; font-weight: bold; border-bottom: 2px solid #8e2023; display: inline-block; margin-bottom: 10px; }
        .content-title { font-size: 1.3rem; color: #2C2420; margin-bottom: 5px; }
        .btn-view { background: #2C2420; color: white; border: none; padding: 10px; border-radius: 8px; text-align: center; font-weight: bold; }

        .comment-list { flex-grow: 1; overflow-y: auto; text-align: left; font-size: 0.9rem; margin-top: 10px; }
        .comment-item { border-bottom: 1px solid #eee; padding: 8px 0; }
        .comment-user { color: #2C2420; font-weight: bold; }

        .btn-read-more {
            display: block; width: 200px; margin: 30px auto; padding: 12px;
            border: 2px solid #2C2420; background: transparent; color: #2C2420;
            border-radius: 25px; font-weight: bold; cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="header-banner" style="background-color: #1a1513; border-radius: 20px; padding: 80px 40px; color: white; position: relative; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.2); margin-bottom: 40px; text-align: center;">
    
            <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-image: url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg'); background-size: cover; background-position: center; opacity: 0.5; z-index: 0;"></div>
    
            <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.6), rgba(20, 15, 12, 0.8)); z-index: 1;"></div>
    
            <div style="position: relative; z-index: 2;">
                <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                    <i class="fa-solid fa-fire me-2"></i> Global Popularity Leaderboard
                </h2>
                <p class="lead opacity-75 mb-0 text-white">Discover which ancient scrolls resonate most with modern scholars.</p>
            </div>
        </div>

        <div class="rank-grid">
            <asp:Repeater ID="rptLeaderboard" runat="server">
                <ItemTemplate>
                    <div class='<%# Container.ItemIndex < 3 ? "flip-card" : "flip-card extra-content" %>' onclick="this.classList.toggle('active')">
                        <div class="flip-card-inner">
                            <div class="card-front">
                                <div>
                                    <span class="rank-num">RANK #<%# Container.ItemIndex + 1 %></span>
                                    <div class="content-title font-classic"><%# Eval("Title") %></div>
                                    <div class="text-muted small"><i class="fa-solid fa-comments me-1"></i> <%# Eval("CommentCount") %> Interactions</div>
                                </div>
                                <div class="btn-view">Review Comments</div>
                            </div>
                            <div class="card-back font-classic">
                                <div class="border-bottom pb-2 d-flex justify-content-between">
                                    <strong>Comments</strong>
                                    <small style="color:#2C2420">Click to Flip Back</small>
                                </div>
                                <div class="comment-list">
                                    <asp:Repeater ID="rptStudentComments" runat="server" DataSource='<%# Eval("StudentComments") %>'>
                                        <ItemTemplate>
                                            <div class="comment-item">
                                                <div class="comment-user"><%# Eval("Username") %></div>
                                                <div class="text-muted"><%# Eval("CommentText") %></div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <button type="button" id="btnReadMore" class="btn-read-more font-classic" onclick="showAll()">READ MORE</button>
    </div>

    <script>
        function showAll() {
            const extras = document.querySelectorAll('.extra-content');
            extras.forEach(el => el.style.display = 'block');
            document.getElementById('btnReadMore').style.display = 'none';
        }
    </script>
</asp:Content>