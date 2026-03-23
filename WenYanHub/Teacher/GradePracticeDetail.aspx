<%@ Page Title="Scholar Submissions" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="GradePracticeDetail.aspx.cs" Inherits="WenYanHub.Teacher.GradePracticeDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Prevent the icons from being distorted into squares due to interference from the master page font. */
        .fa-solid, .fa-scroll, .fa-house, .fa-pen-nib, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; [cite: 140] }
        .ls-2 { letter-spacing: 2px; [cite: 141] }
        
        /* Layout fix: Automatically center the standard container of ContentManage synchronously */
        .manage-container { padding: 40px 0 60px 0; min-height: 80vh; }

        /* Header Section: Dark Hero style synchronized with ContentManage  */
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
            background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.7), rgba(20, 15, 12, 0.9)), 
                              url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg');
            background-size: cover; background-position: center;
            z-index: 1;
        }
        .header-content { position: relative; z-index: 2; text-align: center; }

        /* Modern card layout container */
        .table-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: none;
            margin-bottom: 30px;
        }

        /* The table style is synchronized from ContentManage. */
        .modern-grid { 
            width: 100% !important;
            border-collapse: collapse !important;
            margin-top: 20px;
        }
        .modern-grid th {
            background-color: #2C2420 !important;
            color: #FFFFFF !important;
            padding: 15px !important;
            font-weight: 600;
            text-transform: uppercase; /* Force all characters to be in uppercase. */
            text-align: left;
        }
        .modern-grid td { padding: 15px !important; border-bottom: 1px solid #f0f0f0 !important; }
        
        /* Button style: Dark brown background (#2C2420) */
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
        }

        /* Status label synchronization */
        .badge-status {
            background-color: #f4db9a;
            color: #2C2420;
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: bold;
            font-size: 12px;
        }

        /* Change the color of the return link to dark brown. */
        .back-link { color: #2C2420; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; margin-bottom: 20px; transition: 0.3s; }
        .back-link:hover { transform: translateX(-5px); color: #8B0000; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container manage-container">
        <a href="SubmissionManage.aspx" class="back-link">
            <i class="fa-solid fa-house me-2"></i> Return to All Submissions
        </a>

        <div class="header-banner">
            <div class="header-bg"></div>
            <div class="header-content">
                <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                    <i class="fa-solid fa-scroll me-2" style="color: #FFFFFF;"></i> Submissions for: 
                    <asp:Literal ID="litContentTitle" runat="server"></asp:Literal>
                </h2>
                <p class="lead opacity-75 mb-0 text-white">Review and grade scholar performance records.</p>
            </div>
        </div>

        <div class="table-card">
            <table class="modern-grid">
                <thead>
                    <tr>
                        <th style="width: 80px; text-align: center;">ID</th>
                        <th>SCHOLAR NAME</th>
                        <th>SUBMISSION DATE</th>
                        <th>STATUS</th>
                        <th style="text-align: center;">ACTIONS</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Important fix: Revert the ID to "rptStudents" and use the Repeater control to match the backend code --%>
                    <asp:Repeater ID="rptStudents" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td style="text-align: center; font-weight: bold;"><%# Container.ItemIndex + 1 %></td>
                                <td style="font-weight: bold;"><%# Eval("Student.Username") %></td>
                                <td><%# Eval("SubmittedAt", "{0:yyyy-MM-dd HH:mm}") %></td>
                                <td><span class="badge-status"><%# Eval("Status") %></span></td>
                                <td style="text-align: center;">
                                    <a href='EvaluateHomework.aspx?sid=<%# Eval("SubmissionId") %>' class="text-decoration-none fw-bold" style="color: #2C2420;">
                                        <i class="fa-solid fa-pen-nib me-1"></i> Grade Now
                                    </a>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <asp:PlaceHolder ID="phNoData" runat="server" Visible="false">
                <div style="text-align:center; padding: 40px; color: #999; font-style: italic;">
                    No submissions received for this practice yet. 
                </div>
            </asp:PlaceHolder>
        </div>

        <div class="d-flex justify-content-center mt-4">
            <a href="PracticeManage.aspx" class="btn-custom-dark">
                <i class="fa-solid fa-scroll me-2"></i> Back to Practice Archive 
            </a>
        </div>
    </div>
</asp:Content>