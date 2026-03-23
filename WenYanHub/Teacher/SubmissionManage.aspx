<%@ Page Title="Submission Management" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="SubmissionManage.aspx.cs" Inherits="WenYanHub.Teacher.SubmissionManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Prevent icons from being affected by the font of the master page */
        .fa-solid, .fa-house, .fa-magnifying-glass, .fa-chevron-right, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
        /* Use parchment background and automatically center it  */
        .manage-container { 
            background: #fdfcf9 url('https://www.transparenttextures.com/patterns/papyros.png');
            padding: 40px 0 60px 0; 
            min-height: 80vh; 
        }

        /* Header Section: Synchronized Watercolor Background Banner of PracticeManage */
        .header-banner {
            background-color: #1a1513;
            border-radius: 20px;
            padding: 50px 40px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            margin-bottom: 30px;
        }
        .header-bg {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            /* Use the ink-wash landscape background image you specified */
            background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.6), rgba(20, 15, 12, 0.8)), 
                              url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg');
            background-size: cover; background-position: center;
            z-index: 1;
        }
        .header-content { position: relative; z-index: 2; text-align: center; }

        /* Card layout: White shadow card */
        .table-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: none;
            margin-bottom: 30px;
        }

        /* Style for individual statistical item: Align with dark brown border */
        .stat-card {
            background: #fafafa;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid #eee;
            transition: 0.3s;
        }
        .stat-card:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 8px 20px rgba(44, 36, 32, 0.1);
            border-color: #2C2420;
        }
        
        .practice-title { color: #2C2420; font-weight: bold; font-size: 22px; margin-bottom: 8px; }
        .pending-count { color: #5D4037; font-weight: 600; font-size: 16px; }

        /* Unified button style: Dark brown background (#2C2420) + White text */
        .btn-custom-dark {
            background-color: #2C2420 !important;
            color: #FFFFFF !important;
            border-radius: 8px;
            padding: 12px 25px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: 0.3s;
            border: 1px solid #4A3C31;
        }
        .btn-custom-dark:hover {
            background-color: #1a1512 !important;
            transform: translateY(-2px);
            color: #FFFFFF !important;
        }

        /* Return link style */
        .back-link { 
            color: #2C2420; 
            font-weight: 600; 
            text-decoration: none; 
            display: inline-flex; 
            align-items: center; 
            margin-bottom: 20px; 
            transition: 0.3s; 
        }
        .back-link:hover { transform: translateX(-5px); color: #8B0000; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="manage-container">
        <div class="container">
            <a href="PracticeManage.aspx" class="back-link">
                <i class="fa-solid fa-house me-2"></i> Back to Practice Archive
            </a>
            
            <div class="header-banner">
                <div class="header-bg"></div>
                <div class="header-content">
                    <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                        <i class="fa-solid fa-magnifying-glass me-2"></i> Student Submissions
                    </h2>
                    <p class="lead opacity-75 mb-0 text-white">Review and grade scholar performance.</p>
                </div>
            </div>

            <div class="table-card">
                <asp:Repeater ID="rptPracticeStats" runat="server">
                    <ItemTemplate>
                        <div class="stat-card">
                            <div>
                                <div class="practice-title font-classic"><%# Eval("PracticeTitle") %></div>
                                <div class="pending-count">
                                    Pending Tasks: <%# Eval("PendingCount") %> submissions
                                </div>
                            </div>
                            <a href='GradePracticeDetail.aspx?practiceId=<%# Eval("PracticeId") %>' class="btn-custom-dark">
                                Review Scholars <i class="fa-solid fa-chevron-right ms-2" style="font-size: 12px;"></i>
                            </a>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:PlaceHolder ID="phEmpty" runat="server" Visible="false">
                    <div style="text-align:center; padding: 60px; color: #999; font-style: italic; font-size: 18px;">
                        No pending submissions found at this moment.
                    </div>
                </asp:PlaceHolder>
            </div>
        </div>
    </div>
</asp:Content>