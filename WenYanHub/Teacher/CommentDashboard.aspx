<%@ Page Title="Comment Dashboard" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="CommentDashboard.aspx.cs" Inherits="WenYanHub.Teacher.CommentDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        .comment-container { padding: 20px 0 60px 0; }

        /* Return link: Dark Brown Style */
        .back-link { 
            color: #2C2420; 
            font-weight: 600; 
            text-decoration: none; 
            margin-bottom: 25px; 
            display: inline-flex; 
            align-items: center; 
        }

        /* 🌟 Header Section */
        .header-banner {
            background-color: #1a1513;
            border-radius: 20px;
            padding: 40px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 30px;
        }
        .header-bg {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.7), rgba(20, 15, 12, 0.9)), 
                              url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg');
            background-size: cover; z-index: 1;
        }
        .header-content { position: relative; z-index: 2; }

        /* Message card: White rounded-edge style */
        .comment-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            border-left: 5px solid #2C2420; /* The side trim has been changed to a dark brown color. */
        }

        .scholar-name { color: #2C2420; font-weight: 700; font-size: 1.1rem; margin-bottom: 10px; display: block; }
        .comment-text { color: #444; line-height: 1.8; font-size: 16px; }
        .timestamp { color: #999; font-size: 13px; margin-top: 15px; text-align: right; }

        .footer-deco { margin-top: 40px; text-align: center; opacity: 0.3; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container comment-container">
        <a href="ContentDashboard.aspx" class="back-link">
            <i class="fa-solid fa-arrow-left me-2"></i> Return to Leaderboard
        </a>

        <div class="header-banner">
            <div class="header-bg"></div>
            <div class="header-content">
                <h2 class="font-classic ls-2 fw-bold mb-1 text-white">
                    <i class="fa-solid fa-comments me-2"></i> Detailed Comments
                </h2>
                <p class="lead opacity-75 mb-0">For: <strong><asp:Literal ID="litContentTitle" runat="server"></asp:Literal></strong></p>
            </div>
        </div>

        <asp:Repeater ID="rptStudentComments" runat="server">
            <ItemTemplate>
                <div class="comment-card">
                    <span class="scholar-name">
                        <i class="fa-solid fa-user-graduate me-2"></i> Scholar: <%# Eval("User.Username") %>
                    </span>
                    <div class="comment-text"><%# Eval("CommentText") %></div>
                    <div class="timestamp">
                        <i class="fa-solid fa-clock me-1"></i> <%# Eval("CreatedAt", "{0:yyyy-MM-dd HH:mm}") %>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

    </div>
</asp:Content>