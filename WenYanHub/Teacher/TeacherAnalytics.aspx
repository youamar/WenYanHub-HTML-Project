<%@ Page Title="Teacher Analytics" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="TeacherAnalytics.aspx.cs" Inherits="WenYanHub.Teacher.TeacherAnalytics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Prevent the icons from being distorted into squares due to interference from the master page font. */
        .fa-solid, .fa-chart-line, .fa-scroll, .fa-note-sticky, .fa-clipboard-list, .fa-video, .fa-pen-nib, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
        /* Core layout: Expand the entire screen and fill the background completely */
        .manage-container { padding: 40px 0 60px 0; min-height: 95vh; box-sizing: border-box; }

        /* Header Section: Completely synchronized dark ink banner of ContentManage */
        .header-banner {
            background-color: #1a1513;
            border-radius: 20px;
            padding: 50px 40px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            margin-bottom: 40px;
        }
        .header-bg {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.7), rgba(20, 15, 12, 0.9)), 
                              url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg');
            background-size: cover; background-position: center;
            z-index: 1;
        }
        .header-content { position: relative; z-index: 2; text-align: center; }
        .header-content h2 i { color: #FFFFFF !important; }

        /* Statistical card grid layout*/
        .analytics-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); 
            gap: 20px; 
            margin-bottom: 40px; 
        }

        /* Stat Card: Dark brown background + White text/icons */
        .stat-card {
            background: #2C2420; 
            padding: 25px;
            text-align: center;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 1px solid #4A3C31;
        }
        .stat-card:hover { 
            transform: translateY(-5px); 
            background: #1a1512; 
            box-shadow: 0 8px 25px rgba(0,0,0,0.2); 
        }
        
        .stat-card i { color: #FFFFFF !important; font-size: 24px; display: block; margin-bottom: 10px; }
        .stat-value { font-size: 36px; font-weight: bold; color: #FFFFFF; display: block; }
        .stat-label { font-size: 13px; color: #FDFCF9; font-weight: bold; text-transform: uppercase; letter-spacing: 1px; opacity: 0.8; }

        /* Details block style */
        .detail-block { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            margin-bottom: 30px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: none;
        }
        .detail-block h3 { 
            color: #2C2420; 
            border-bottom: 2px solid #e0d5c1; 
            padding-bottom: 15px; 
            margin-top: 0; 
            margin-bottom: 25px;
            font-size: 20px;
            font-weight: bold;
        }
        .detail-block h3 i { color: #2C2420 !important; margin-right: 10px; }

        /* Table style synchronization */
        .modern-grid { 
            width: 100% !important;
            border-collapse: collapse !important;
            border: none !important;
        }
        .modern-grid th {
            background-color: #2C2420 !important;
            color: #FFFFFF !important;
            padding: 15px !important;
            font-weight: 600;
            text-transform: uppercase;
        }
        .modern-grid td { padding: 12px 15px !important; border-bottom: 1px solid #f0f0f0 !important; color: #444; }

        /* Status label */
        .status-tag { 
            background-color: #f4db9a; 
            color: #2C2420; 
            padding: 4px 10px; 
            border-radius: 6px; 
            font-size: 12px; 
            font-weight: bold; 
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="manage-container">
        <div class="container">
            
            <div class="header-banner">
                <div class="header-bg"></div>
                <div class="header-content">
                    <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                        <i class="fa-solid fa-chart-line me-2"></i> Teaching Contribution Analytics
                    </h2>
                    <p class="lead opacity-75 mb-0 text-white">Monitor your pedagogical impact and scholar engagement.</p>
                </div>
            </div>

            <div class="analytics-grid">
                <div class="stat-card">
                    <i class="fa-solid fa-scroll"></i>
                    <span class="stat-value"><asp:Literal ID="litContentsCount" runat="server">0</asp:Literal></span>
                    <span class="stat-label">Lessons</span>
                </div>
                <div class="stat-card">
                    <i class="fa-solid fa-note-sticky"></i>
                    <span class="stat-value"><asp:Literal ID="litNotesCount" runat="server">0</asp:Literal></span>
                    <span class="stat-label">Scholar Notes</span>
                </div>
                <div class="stat-card">
                    <i class="fa-solid fa-clipboard-list"></i>
                    <span class="stat-value"><asp:Literal ID="litPracticesCount" runat="server">0</asp:Literal></span>
                    <span class="stat-label">Practices</span>
                </div>
                <div class="stat-card">
                    <i class="fa-solid fa-video"></i>
                    <span class="stat-value"><asp:Literal ID="litVideosCount" runat="server">0</asp:Literal></span>
                    <span class="stat-label">Videos</span>
                </div>
                <div class="stat-card">
                    <i class="fa-solid fa-pen-nib"></i>
                    <span class="stat-value"><asp:Literal ID="litGradedCount" runat="server">0</asp:Literal></span>
                    <span class="stat-label">Graded Tasks</span>
                </div>
            </div>

            <div class="detail-block">
                <h3><i class="fa-solid fa-scroll me-2"></i>My Lessons</h3>
                <asp:GridView ID="gvContents" runat="server" AutoGenerateColumns="False" CssClass="table modern-grid">
                    <Columns>
                        <asp:BoundField DataField="Title" HeaderText="TITLE" ItemStyle-Font-Bold="true" />
                        <asp:BoundField DataField="CreatedAt" HeaderText="DATE" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="STATUS">
                            <ItemTemplate><span class="status-tag"><%# Eval("Approved") %></span></ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div class="detail-block">
                <h3><i class="fa-solid fa-note-sticky me-2"></i>My Scholar Notes</h3>
                <asp:GridView ID="gvNotes" runat="server" AutoGenerateColumns="False" CssClass="table modern-grid">
                    <Columns>
                        <asp:TemplateField HeaderText="LESSON"><ItemTemplate><%# Eval("Content.Title") %></ItemTemplate></asp:TemplateField>
                        <asp:TemplateField HeaderText="CONTENT PREVIEW"><ItemTemplate><%# Eval("NoteContent").ToString().Length > 60 ? Eval("NoteContent").ToString().Substring(0, 60) + "..." : Eval("NoteContent") %></ItemTemplate></asp:TemplateField>
                        <%-- 🌟 这里是新增的 DATE 列 --%>
                        <asp:BoundField DataField="CreatedAt" HeaderText="DATE" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="STATUS"><ItemTemplate><span class="status-tag"><%# Eval("Approved") %></span></ItemTemplate></asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div class="detail-block">
                <h3><i class="fa-solid fa-clipboard-list me-2"></i>My Practices</h3>
                <asp:GridView ID="gvPractices" runat="server" AutoGenerateColumns="False" CssClass="table modern-grid">
                    <Columns>
                        <asp:BoundField DataField="Title" HeaderText="TITLE" ItemStyle-Font-Bold="true" />
                        <asp:BoundField DataField="DueDate" HeaderText="DEADLINE" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="STATUS"><ItemTemplate><span class="status-tag"><%# Eval("Approved") %></span></ItemTemplate></asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div class="detail-block">
                <h3><i class="fa-solid fa-video me-2"></i>My Videos</h3>
                <asp:GridView ID="gvVideos" runat="server" AutoGenerateColumns="False" CssClass="table modern-grid">
                    <Columns>
                        <asp:TemplateField HeaderText="LESSON"><ItemTemplate><%# Eval("Content.Title") %></ItemTemplate></asp:TemplateField>
                        <asp:BoundField DataField="Description" HeaderText="DESCRIPTION" />
                        <asp:TemplateField HeaderText="STATUS">
                            <ItemTemplate><span class="status-tag"><%# Eval("Approved") %></span></ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CreatedAt" HeaderText="UPLOADED" DataFormatString="{0:yyyy-MM-dd}" />
                    </Columns>
                </asp:GridView>
            </div>

            <div class="detail-block">
                <h3><i class="fa-solid fa-pen-nib me-2"></i>Recent Grading History</h3>
                <asp:GridView ID="gvSubmissions" runat="server" AutoGenerateColumns="False" CssClass="table modern-grid">
                    <Columns>
                        <asp:TemplateField HeaderText="STUDENT"><ItemTemplate><%# Eval("Student.Username") %></ItemTemplate></asp:TemplateField>
                        <asp:TemplateField HeaderText="PRACTICE"><ItemTemplate><%# Eval("Practice.Title") %></ItemTemplate></asp:TemplateField>
                        <asp:BoundField DataField="Score" HeaderText="SCORE" ItemStyle-Font-Bold="true" />
                        <asp:BoundField DataField="GradedAt" HeaderText="GRADED DATE" DataFormatString="{0:yyyy-MM-dd}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>