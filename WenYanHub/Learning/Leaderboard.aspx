<%@ Page Title="Leaderboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Leaderboard.aspx.cs" Inherits="WenYanHub.Learning.Leaderboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .ld-body { 
            background-color: #F7F3ED; 
            color: #3E2723; 
            font-family: "Microsoft YaHei", "STKaiti", serif; 
            padding: 40px 20px; 
            min-height: 90vh; 

            min-width: 1024px;
            overflow-x: auto;
        }
        
        .ld-title { 
            text-align: center; 
            color: #3E2723; 
            font-size: 3rem; 
            margin-bottom: 5px; 
        }
        .ld-subtitle { 
            text-align: center; 
            color: #8D6E63; 
            margin-bottom: 40px; 
            letter-spacing: 2px; 
            font-size: 0.9rem;
        }

        .podium { 
            display: flex; 
            justify-content: center; 
            align-items: flex-end; 
            gap: 15px; 
            margin: 40px auto; 
            height: 300px; 
            
            width: 700px;
        }

        .p-item { 
            background: #EFEBE9;
            border-radius: 8px; 
            padding: 20px 10px; 
            text-align: center; 
            flex: 1; 
            max-width: 160px; 
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            border: 1px solid #D7CCC8;
        }

        /* Rank height and border */
        .rank-1 { height: 100%; border: 2px solid #C5A059; order: 2; background-color: #FFFFFF; }
        .rank-2 { height: 80%; border: 1px solid #B0BEC5; order: 1; }
        .rank-3 { height: 65%; border: 1px solid #BCAAA4; order: 3; }


        .medal { font-size: 2rem; margin-bottom: 5px; }
        .avatar-box { 
            width: 50px; 
            height: 50px; 
            line-height: 50px; 
            font-size: 1.5rem; 
            margin: 0 auto 10px; 
            background: #5D4037; 
            color: #FFFFFF;
            border-radius: 50%;
        }
        .p-username { font-weight: bold; font-size: 1rem; color: #3E2723; }
        .p-score { font-size: 1.3rem; color: #A52A2A; font-weight: bold; }

        .ld-list { 
            max-width: 650px; 
            margin: 0 auto; 
            background: #FFFFFF; 
            border-radius: 8px; 
            overflow: hidden; 
            border: 1px solid #D7CCC8;
        }
        .ld-header { 
            display: flex; 
            background: #F0F0F0; 
            padding: 12px 25px; 
            color: #5D4037; 
            font-weight: bold; 
            font-size: 0.9rem;
            border-bottom: 1px solid #D7CCC8; 
        }
        .ld-row { 
            display: flex; 
            align-items: center; 
            padding: 15px 25px; 
            border-bottom: 1px solid #EEEEEE; 
            color: #4E342E; 
        }
        
        .col-rank { width: 60px; font-weight: bold; color: #8D6E63; }
        .col-user { flex: 1; display: flex; align-items: center; gap: 12px; }
        .col-score { width: 100px; text-align: right; color: #A52A2A; font-weight: bold; }
        
        .is-me { background: #FFF9E1 !important; }
        
        .btn-container { text-align: center; margin-top: 40px; }
        .btn-back { 
            padding: 10px 35px; 
            background: #5D4037; 
            color: #FFFFFF; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 1rem;
            transition: opacity 0.2s;
        }
        .btn-back:hover { opacity: 0.9; }

        .your-title-class {
            max-width: 90%;
            margin: 0 auto;
            word-wrap: break-word; 
            text-align: center;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="ld-body">
    <h1 class="ld-title">
        <asp:Label ID="lblContentTitle" runat="server" Text="Leaderboard"></asp:Label>
    </h1>
    <p class="ld-subtitle">Hall of Fame</p>
        <div class="podium">
            <asp:Repeater ID="rptPodium" runat="server">
                <ItemTemplate>
                    <div class='<%# "p-item rank-" + (Eval("Rank")) %>'>
                        <span class="medal"><%# GetMedal(Eval("Rank")) %></span>
                        <div class="avatar-box"><%# Eval("Username").ToString().Substring(0,1).ToUpper() %></div>
                        <span class="p-username"><%# Eval("Username") %></span>
                        <div class="p-score"><%# Eval("Score") %> <small style="font-size: 0.8rem; font-weight: normal; color: #666;">PTS</small></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="ld-list">
            <div class="ld-header">
                <div class="col-rank">Rank</div>
                <div class="col-user">Scholar</div>
                <div class="col-score">Best Score</div>
            </div>
            <asp:Repeater ID="rptOthers" runat="server">
                <ItemTemplate>
                    <div class='<%# "ld-row " + (Eval("IsCurrentUser").ToString() == "True" ? "is-me" : "") %>'>
                        <div class="col-rank">#<%# Eval("Rank") %></div>
                        <div class="col-user">
                            <div style="width:30px; height:30px; background:#444; border-radius:50%; text-align:center; line-height:30px; font-size:0.8rem; color:#ffd700;">
                                <%# Eval("Username").ToString().Substring(0,1).ToUpper() %>
                            </div>
                            <span><%# Eval("Username") %></span>
                        </div>
                        <div class="col-score"><%# Eval("Score") %></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="btn-container">
            <asp:Button ID="btnBack" runat="server" Text="Back to Quiz" CssClass="btn-back" OnClick="btnBack_Click" />
        </div>
    </div>
</asp:Content>