<%@ Page Title="Game Leaderboard" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="GameLeaderboard.aspx.cs" Inherits="WenYanHub.Teacher.GameLeaderboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        .leaderboard-container { padding: 40px 0 60px 0; }
        .rank-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
            perspective: 1000px; 
        }
        .flip-card {
            background-color: transparent;
            height: 380px;
            perspective: 1000px;
        }
        .flip-card-inner {
            position: relative;
            width: 100%;
            height: 100%;
            text-align: center;
            transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
            transform-style: preserve-3d;
        }
        .flip-card:hover .flip-card-inner {
            transform: rotateY(180deg);
        }
        .flip-front, .flip-back {
            position: absolute;
            width: 100%;
            height: 100%;
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            border-radius: 15px;
            border: 1px solid #e0d9d5;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
        }
        .flip-front {
            background-color: rgba(255, 255, 255, 0.95);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .flip-back {
            background-color: #fdfcf9;
            color: #2c2420;
            transform: rotateY(180deg);
            display: flex;
            flex-direction: column;
        }
        .rank-icon { font-size: 40px; color: #2C2420; margin-bottom: 15px; }
        .rank-badge { background: #f8f5f2; color: #2C2420; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: bold; margin-bottom: 10px; }
        .game-name { font-size: 1.4rem; color: #2c2420; margin-bottom: 10px; }
        .score-val { font-size: 2.2rem; color: #2C2420; font-weight: bold; }
        .back-title { color: #5a4a42; border-bottom: 2px solid #5a4a42; padding-bottom: 10px; margin-bottom: 15px; font-weight: bold; }
        .score-list { flex-grow: 1; overflow-y: auto; text-align: left; padding-right: 5px; }
        .score-item { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee; font-size: 0.95rem; }
        .score-list::-webkit-scrollbar { width: 4px; }
        .score-list::-webkit-scrollbar-thumb { background: #5a4a42; border-radius: 10px; }




        .header-banner {
            background-color: #1a1513; 
            border-radius: 20px;
            padding: 50px 40px; 
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            margin-bottom: 40px;
            text-align: center;
        }


        .header-banner::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
     
            background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.6), rgba(20, 15, 12, 0.8));
            z-index: 1;
        }


        .header-banner-img {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
   
            background-image: url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg'); 
            background-size: cover;
            background-position: center;
            opacity: 0.4; 
            z-index: 0;
        }

 
        .header-content {
            position: relative;
            z-index: 2;
        }


        .banner-icon {
            margin-right: 15px;
            color: #2C2420; 
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container leaderboard-container">
        
        <div class="header-banner" style="background-color: #1a1513; border-radius: 20px; padding: 80px 40px; color: white; position: relative; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.2); margin-bottom: 40px; text-align: center;">
    
            <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-image: url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg'); background-size: cover; background-position: center; opacity: 0.5; z-index: 0;"></div>
    
            <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.6), rgba(20, 15, 12, 0.8)); z-index: 1;"></div>
    
            <div style="position: relative; z-index: 2;">
                <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                    <i class="fa-solid fa-trophy me-2"></i> Mini-Game Leaderboard
                </h2>
                <p class="lead opacity-75 mb-0 text-white">Ranking of scholar performance across all lesson scrolls.</p>
            </div>
        </div>

        <div class="rank-grid">
            <asp:Repeater ID="rptLeaderboard" runat="server">
                <ItemTemplate>
                    <div class="flip-card">
                        <div class="flip-card-inner">
                            
                            <div class="flip-front">
                                <div class="rank-icon"><i class="fa-solid fa-trophy"></i></div>
                                <div class="rank-badge">RANKING #<%# Container.ItemIndex + 1 %></div>
                                <div class="game-name font-classic"><%# Eval("ContentTitle") %></div>
                                <div class="score-val"><%# Eval("AvgScore", "{0:F1}") %></div>
                                <div class="hover-hint font-classic">Move to view details <i class="fa-solid fa-rotate"></i></div>
                            </div>

                            <div class="flip-back font-classic">
                                <div class="back-title">Scholar Scores</div>
                                <div class="score-list">
                                    <asp:Repeater ID="rptScores" runat="server" DataSource='<%# Eval("ScholarScores") %>'>
                                        <ItemTemplate>
                                            <div class="score-item">
                                                <span class="s-name"><%# Eval("Username") %></span>
                                                <span class="s-score"><%# Eval("Score", "{0:F1}") %></span>
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
    </div>
</asp:Content>