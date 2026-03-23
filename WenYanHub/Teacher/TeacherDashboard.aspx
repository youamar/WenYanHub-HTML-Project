<%@ Page Title="Teacher Dashboard" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="TeacherDashboard.aspx.cs" Inherits="WenYanHub.Teacher.TeacherDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Synchronize the default.aspx core font */
        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
        .dashboard-container { padding: 20px 0 60px 0; }

        /* Hero Banner: Replicating the Dark High-Style Version of Default.aspx */
        .hero-section {
            background-color: #1a1513;
            border-radius: 20px;
            padding: 80px 40px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin-bottom: 40px;
            text-align: center;
        }
        .hero-bg {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.6), rgba(20, 15, 12, 0.9)), 
                              url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg');
            background-size: cover; background-position: center;
            z-index: 1;
        }
        .hero-content { position: relative; z-index: 2; }

        /* Modern cards: Rounded corners + Soft shadows */
        .modern-card {
            background: white;
            border: none;
            border-radius: 15px;
            padding: 45px 30px;
            height: 100%;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }
        .modern-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.12) !important;
        }

        /* Modification: Uniform icon color has been changed to dark brown (#2C2420) */
        .icon-box {
            font-size: 45px;
            margin-bottom: 25px;
            color: #2C2420; /* Force the color to be uniformly dark brown. */
            line-height: 1;
        }
        .icon-box i {
            color: #2C2420 !important;
        }

        .card-title { color: #2C2420; font-weight: 700; margin-bottom: 12px; font-size: 1.25rem; }
        .card-desc { color: #666; font-size: 14px; line-height: 1.6; margin: 0; }

        .footer-deco { margin-top: 50px; text-align: center; opacity: 0.4; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard-container">
        
        <div class="hero-section">
            <div class="hero-bg"></div>
            <div class="hero-content">
                <h1 class="font-classic ls-2 display-4 fw-bold mb-3">Teacher Workspace</h1>
                <p class="lead opacity-75">Welcome back, Master <%: Session["Username"] %>. Managing the legacy of wisdom.</p>
            </div>
        </div>

        <div class="row g-4">
            
            <div class="col-md-4">
                <div class="modern-card" onclick="location.href='GameLeaderboard.aspx';">
                    <div class="icon-box"><i class="fa-solid fa-trophy"></i></div>
                    <h4 class="card-title font-classic">Game Leaderboard</h4>
                    <p class="card-desc">Rank mini-games by scholar averages and view student scores.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="modern-card" onclick="location.href='ContentManage.aspx';">
                    <div class="icon-box"><i class="fa-solid fa-scroll"></i></div>
                    <h4 class="card-title font-classic">Lessons Content</h4>
                    <p class="card-desc">Organize classical texts, annotations, and translations.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="modern-card" onclick="location.href='NoteManage.aspx';">
                    <div class="icon-box"><i class="fa-solid fa-pen-nib"></i></div>
                    <h4 class="card-title font-classic">Scholar Notes</h4>
                    <p class="card-desc">Review reflections and provide pedagogical guidance.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="modern-card" onclick="location.href='PracticeManage.aspx';">
                    <div class="icon-box"><i class="fa-solid fa-file-signature"></i></div>
                    <h4 class="card-title font-classic">Student Practice</h4>
                    <p class="card-desc">Evaluate worksheets and manage student submissions.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="modern-card" onclick="location.href='VideoManage.aspx';">
                    <div class="icon-box"><i class="fa-solid fa-video"></i></div>
                    <h4 class="card-title font-classic">Video & Live</h4>
                    <p class="card-desc">Schedule live sessions and manage recordings.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="modern-card" onclick="location.href='TeacherForum.aspx';">
                    <div class="icon-box"><i class="fa-solid fa-comments"></i></div>
                    <h4 class="card-title font-classic">Teacher Forum</h4>
                    <p class="card-desc">Connect and exchange wisdom with fellow educators.</p>
                </div>
            </div>

            <%-- New addition: Teacher Analytics card --%>
            <div class="col-md-4">
                <div class="modern-card" onclick="location.href='TeacherAnalytics.aspx';">
                    <div class="icon-box"><i class="fa-solid fa-chart-line"></i></div>
                    <h4 class="card-title font-classic">Teacher Contribution Analytics</h4>
                    <p class="card-desc">Monitor your pedagogical impact and engagement statistics.</p>
                </div>
            </div>

        </div>

    </div>
</asp:Content>