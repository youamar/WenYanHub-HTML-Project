<%@ Page Title="Manage Content" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="ContentManage.aspx.cs" Inherits="WenYanHub.Teacher.ContentManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
     
        .fa-solid, .fa-scroll, .fa-chart-line, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
     
        .manage-container { padding: 40px 0 60px 0; min-height: 80vh; }

     
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

        /* Button style: Dark brown background (#2C2420) + White text */
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container manage-container">
        
        <div class="header-banner">
            <div class="header-bg"></div>
            <div class="header-content">
                <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                    <i class="fa-solid fa-scroll me-2" style="color: #FFFFFF;"></i> Classical Content Archive
                </h2>
                <p class="lead opacity-75 mb-0 text-white">Review and organize the digital lesson scrolls.</p>
            </div>
        </div>

        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert alert-success d-block mb-4 p-3 rounded-3 shadow-sm"></asp:Label>

        <div class="table-card">
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                <asp:HyperLink ID="hlLeaderboard" runat="server" NavigateUrl="ContentDashboard.aspx" CssClass="btn-custom-dark">
                    <i class="fa-solid fa-chart-line me-2"></i> Popularity Leaderboard
                </asp:HyperLink>
                
                <a href="EditContent.aspx" class="btn-custom-dark">＋ Create New Scroll</a>
            </div>

            <asp:GridView ID="gvContents" runat="server" AutoGenerateColumns="False" CssClass="table modern-grid" 
                DataKeyNames="ContentId" OnRowDeleting="gvContents_RowDeleting">
                <Columns>
                    <asp:TemplateField HeaderText="ID">
                        <ItemStyle Width="80px" HorizontalAlign="Center" Font-Bold="true" />
                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Title" HeaderText="Title" ItemStyle-Font-Bold="true" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class="badge" style="background-color: #f4db9a; color: #2C2420;">
                                <%# Eval("Approved") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:BoundField DataField="UpdatedAt" HeaderText="Last Updated" DataFormatString="{0:yyyy-MM-dd}" />
                    
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:PlaceHolder ID="phTeacherActions" runat="server" 
                                Visible='<%# Eval("TeacherId") != DBNull.Value && Eval("TeacherId") != null %>'>
                                <asp:HyperLink ID="hlEdit" runat="server" NavigateUrl='<%# "EditContent.aspx?id=" + Eval("ContentId") %>' 
                                    CssClass="text-decoration-none fw-bold me-3" style="color: #5D4037;">Edit</asp:HyperLink>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" 
                                    OnClientClick="return confirm('Delete this scroll?');"
                                    CssClass="text-decoration-none fw-bold" style="color: #2C2420;">Delete</asp:LinkButton>
                            </asp:PlaceHolder>

                            <asp:Label ID="lblSystemLock" runat="server" Text="🔒 Original" CssClass="text-muted small italic"
                                Visible='<%# Eval("TeacherId") == DBNull.Value || Eval("TeacherId") == null %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>