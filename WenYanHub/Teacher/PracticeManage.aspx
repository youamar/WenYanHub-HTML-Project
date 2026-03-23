<%@ Page Title="Manage Practices" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="PracticeManage.aspx.cs" Inherits="WenYanHub.Teacher.PracticeManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Icon font protection */
        .fa-solid, .fa-scroll, .fa-magnifying-glass, .fa-plus, .fa-file-pdf, .fa-pen-to-square, .fa-trash-can, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
        /* Layout fix: Automatically center, resolves alignment issues */
        .manage-container { padding: 20px 0 60px 0; min-height: 80vh; }

        /* Header Section: Dark Hero Style */
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

        /* Modern card layout */
        .table-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: none;
            margin-bottom: 30px;
        }

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

        /* Table style synchronization */
        .modern-grid { 
            width: 100% !important;
            border-collapse: collapse !important;
            margin-top: 20px;
            border: none !important;
        }
        .modern-grid th {
            background-color: #2C2420 !important;
            color: #FFFFFF !important;
            padding: 15px !important;
            border: none !important;
            font-weight: 600;
            text-transform: uppercase;
        }
        .modern-grid td { padding: 15px !important; border-bottom: 1px solid #f0f0f0 !important; }

        /* Status label */
        .badge-gold {
            background-color: #f4db9a;
            color: #2C2420;
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
        }

        /* Operation buttons: All have been uniformly changed to a dark brown color (#2C2420) */
        .action-icon-btn {
            color: #2C2420 !important;
            text-decoration: none;
            font-weight: 700;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
        }
        .action-icon-btn:hover { opacity: 0.7; }

        .footer-deco { margin-top: 40px; text-align: center; opacity: 0.3; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container manage-container">
        
        <div class="header-banner">
            <div class="header-bg"></div>
            <div class="header-content">
                <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                    <i class="fa-solid fa-scroll me-2" style="color: #FFFFFF;"></i> Practice Archive
                </h2>
                <p class="lead opacity-75 mb-0 text-white">Manage assignments and review student progress.</p>
            </div>
        </div>

        <asp:Label ID="lblMessage" runat="server" Visible="false" 
            CssClass="alert alert-success d-block mb-4 p-3 rounded-3 shadow-sm">
        </asp:Label>

        <div class="table-card">
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                <a href="SubmissionManage.aspx" class="btn-custom-dark">
                    <i class="fa-solid fa-magnifying-glass me-2"></i> All Submissions
                </a>
                <a href="EditPractice.aspx" class="btn-custom-dark">
                    <i class="fa-solid fa-plus me-2"></i> Create New Practice
                </a>
            </div>

            <asp:GridView ID="gvPractices" runat="server" AutoGenerateColumns="False" CssClass="table modern-grid" 
                DataKeyNames="PracticeId" OnRowCommand="gvPractices_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="ID">
                        <ItemStyle Width="60px" HorizontalAlign="Center" Font-Bold="true" />
                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Title" HeaderText="Practice Title" ItemStyle-Font-Bold="true" />
                    
                    <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" ItemStyle-CssClass="text-muted" />

                    <asp:TemplateField HeaderText="Status">
                        <ItemStyle Width="120px" />
                        <ItemTemplate>
                            <span class="badge-gold">
                               <%# string.IsNullOrEmpty(Eval("Approved")?.ToString()) ? "Pending" : Eval("Approved") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemStyle Width="220px" />
                        <ItemTemplate>
                            <div class="d-flex gap-3">
                                <a href='EditPractice.aspx?id=<%# Eval("PracticeId") %>' class="action-icon-btn">
                                    <i class="fa-solid fa-pen-to-square me-1"></i> Edit
                                </a>
                                <a href='<%# Eval("QuestionFileUrl") %>' target="_blank" class="action-icon-btn">
                                    <i class="fa-solid fa-file-pdf me-1"></i> PDF
                                </a>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeletePractice" 
                                    CommandArgument='<%# Eval("PracticeId") %>' OnClientClick="return confirm('Confirm deletion?');"
                                    CssClass="action-icon-btn">
                                    <i class="fa-solid fa-trash-can me-1"></i> Delete
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>


    </div>
</asp:Content>