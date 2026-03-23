<%@ Page Title="Game Score Details" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="GameScoreDetails.aspx.cs" Inherits="WenYanHub.Teacher.GameScoreDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Synchronize the default.aspx core font */
        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
        .details-container { padding: 20px 0 60px 0; }

        /* Header Section: Replicating the dark Hero style of the Default page */
        .header-banner {
            background-color: #1a1513;
            border-radius: 20px;
            padding: 40px 30px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            margin-bottom: 30px;
        }
        .header-bg {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.7), rgba(20, 15, 12, 0.9)), 
                              url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg');
            background-size: cover; background-position: center;
            z-index: 1;
        }
        .header-content { position: relative; z-index: 2; }

        /* Modern card-style table container */
        .table-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: none;
        }

        .details-table { width: 100%; border-collapse: collapse; margin-bottom: 0; }
        
        /* Header: Dark brown background, white text */
        .details-table th { 
            background: #2C2420; 
            color: #FFFFFF !important; 
            padding: 18px 20px; 
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 1px;
        }
    
        .details-table td { padding: 15px 20px; border-bottom: 1px solid #f0f0f0; vertical-align: middle; }
        .details-table tr:hover { background-color: #fcfcfc; }

        /* Return link: Dark Brown Style */
        .back-link { 
            color: #2C2420; 
            font-weight: 600; 
            text-decoration: none; 
            display: inline-flex; 
            align-items: center; 
            margin-bottom: 20px;
            transition: 0.3s;
        }
        .back-link:hover { color: #8B0000; transform: translateX(-5px); }

        .score-high { color: #2C2420; font-weight: bold; }
        .score-low { color: #8B0000; font-weight: bold; } /* Fail is indicated by vermilion red. */

        .footer-deco { margin-top: 40px; text-align: center; opacity: 0.3; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container details-container">
        <a href="GameLeaderboard.aspx" class="back-link">
            <i class="fa-solid fa-arrow-left-long me-2"></i> Back to Leaderboard
        </a>
        
        <div class="header-banner">
            <div class="header-bg"></div>
            <div class="header-content d-flex align-items-center">
                <div class="me-4 d-none d-md-block">
                    <i class="fa-solid fa-chart-line display-4 text-white opacity-75"></i>
                </div>
                <div>
                    <h2 class="font-classic ls-2 fw-bold mb-1 text-white">
                        Scholar Scores
                    </h2>
                    <p class="lead opacity-75 mb-0 fs-6">
                        Performance records for: <strong><asp:Literal ID="litGameTitle" runat="server"></asp:Literal></strong>
                    </p>
                </div>
            </div>
        </div>

        <div class="table-card">
            <table class="details-table">
                <thead>
                    <tr>
                        <th><i class="fa-solid fa-user-graduate me-2"></i> Scholar Name</th>
                        <th><i class="fa-solid fa-star me-2"></i> Score</th>
                        <th><i class="fa-solid fa-calendar-check me-2"></i> Completion Date</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptStudentScores" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td class="fw-bold text-dark"><%# Eval("User.Username") %></td>
                                <td class='<%# Convert.ToDecimal(Eval("Score")) < 60 ? "score-low" : "score-high" %>'>
                                    <%# Eval("Score", "{0:F1}") %>
                                </td>
                                <td class="text-muted"><%# Eval("TakenAt", "{0:yyyy-MM-dd HH:mm}") %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

 
    </div>
</asp:Content>