<%@ Page Title="Manage Videos & Zoom" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="VideoManage.aspx.cs" Inherits="WenYanHub.Teacher.VideoManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Fix: Prevent icons from becoming squares */
        .fa-solid, .fa-scroll, .fa-video, .fa-chalkboard-user, .fa-play, .fa-link, .fa-pen-to-square, .fa-trash-can, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
        /* Core layout: Automatic centering */
        .manage-container { 
            background: #fdfcf9 url('https://www.transparenttextures.com/patterns/papyros.png');
            padding: 40px 0 60px 0; 
            min-height: 80vh; 
        }

        /* Header Section: Synchronized ContentManage Dark Ink Horizontal Banner */
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
            margin-bottom: 50px;
        }

        /* Button style: Dark brown background (#2C2420) + Pure white text */
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
            font-size: 16px;
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

        .action-icon-btn {
            color: #2C2420 !important;
            text-decoration: none;
            font-weight: 700;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
            margin-right: 15px;
        }
        .action-icon-btn:hover { opacity: 0.7; text-decoration: underline; }

        .badge-gold {
            background-color: #f4db9a;
            color: #2C2420;
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
        }

        .system-lock { color: #999; font-size: 13px; font-style: italic; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="manage-container">
        <div class="container">
            
            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert alert-success d-block mb-4 p-3 rounded-3 shadow-sm"></asp:Label>

            <%-- 📺 Video Section --%>
            <div class="header-banner">
                <div class="header-bg"></div>
                <div class="header-content">
                    <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                        <i class="fa-solid fa-video me-2" style="color: #FFFFFF;"></i> Video Records Archive
                    </h2>
                    <p class="lead opacity-75 mb-0 text-white">Manage digital lesson recordings and resources.</p>
                </div>
            </div>

            <div class="table-card">
                <div class="d-flex justify-content-end mb-4">
                    <a href="EditVideo.aspx" class="btn-custom-dark">
                        <i class="fa-solid fa-plus me-2"></i> Upload Video Link
                    </a>
                </div>

                <asp:GridView ID="gvVideos" runat="server" AutoGenerateColumns="False" CssClass="table modern-grid" DataKeyNames="RecordId" OnRowCommand="gvVideos_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="ID">
                            <ItemStyle Width="60px" HorizontalAlign="Center" Font-Bold="true" />
                            <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Content.Title" HeaderText="Related Lesson" ItemStyle-Font-Bold="true" />
                        <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-CssClass="text-muted" />

                        <asp:TemplateField HeaderText="Status">
                            <ItemStyle Width="120px" />
                            <ItemTemplate>
                                <span class="badge-gold">
                                    <%# string.IsNullOrEmpty(Eval("Approved")?.ToString()) ? "Pending" : Eval("Approved") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Actions">
                            <ItemStyle Width="250px" />
                            <ItemTemplate>
                                <a href='<%# Eval("RecordLink") %>' target="_blank" class="action-icon-btn">
                                    <i class="fa-solid fa-play me-1"></i> Watch
                                </a>
                                <asp:PlaceHolder ID="phVideoActions" runat="server" Visible='<%# Eval("TeacherId") != DBNull.Value && Eval("TeacherId") != null %>'>
                                    <a href='EditVideo.aspx?id=<%# Eval("RecordId") %>' class="action-icon-btn">
                                        <i class="fa-solid fa-pen-to-square me-1"></i> Edit
                                    </a>
                                    <asp:LinkButton ID="btnDelVideo" runat="server" CommandName="DeleteVideo" CommandArgument='<%# Eval("RecordId") %>' OnClientClick="return confirm('Delete this video?');" CssClass="action-icon-btn">
                                        <i class="fa-solid fa-trash-can me-1"></i> Delete
                                    </asp:LinkButton>
                                </asp:PlaceHolder>
                                <asp:Label ID="lblSysVideo" runat="server" Text="🔒 Original" CssClass="system-lock" Visible='<%# Eval("TeacherId") == DBNull.Value || Eval("TeacherId") == null %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <%-- 🎥 Zoom Section --%>
            <div class="header-banner">
                <div class="header-bg"></div>
                <div class="header-content">
                    <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                        <i class="fa-solid fa-chalkboard-user me-2" style="color: #FFFFFF;"></i> Live Zoom Sessions
                    </h2>
                    <p class="lead opacity-75 mb-0 text-white">Schedule and coordinate real-time scholar interactions.</p>
                </div>
            </div>

            <div class="table-card">
                <div class="d-flex justify-content-end mb-4">
                    <a href="EditZoom.aspx" class="btn-custom-dark">
                        <i class="fa-solid fa-plus me-2"></i> Create Zoom Link
                    </a>
                </div>

                <asp:GridView ID="gvZoom" runat="server" AutoGenerateColumns="False" CssClass="table modern-grid" DataKeyNames="ZoomSessionId" OnRowCommand="gvZoom_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="ID">
                            <ItemStyle Width="60px" HorizontalAlign="Center" Font-Bold="true" />
                            <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Title" HeaderText="Session Title" ItemStyle-Font-Bold="true" />
                        
                     
                        <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-CssClass="text-muted" />

                        <asp:BoundField DataField="StartTime" HeaderText="Start Time" DataFormatString="{0:yyyy-MM-dd HH:mm}" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemStyle Width="250px" />
                            <ItemTemplate>
                                <a href='<%# Eval("ZoomJoinUrl") %>' target="_blank" class="action-icon-btn">
                                    <i class="fa-solid fa-link me-1"></i> Join
                                </a>
                                <asp:PlaceHolder ID="phZoomActions" runat="server" Visible='<%# Eval("TeacherId") != DBNull.Value && Eval("TeacherId") != null %>'>
                                    <a href='EditZoom.aspx?id=<%# Eval("ZoomSessionId") %>' class="action-icon-btn">
                                        <i class="fa-solid fa-pen-to-square me-1"></i> Edit
                                    </a>
                                    <asp:LinkButton ID="btnDelZoom" runat="server" CommandName="DeleteZoom" CommandArgument='<%# Eval("ZoomSessionId") %>' OnClientClick="return confirm('Delete this Zoom?');" CssClass="action-icon-btn">
                                        <i class="fa-solid fa-trash-can me-1"></i> Delete
                                    </asp:LinkButton>
                                </asp:PlaceHolder>
                                <asp:Label ID="lblSysZoom" runat="server" Text="🔒 Original" CssClass="system-lock" Visible='<%# Eval("TeacherId") == DBNull.Value || Eval("TeacherId") == null %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

        </div>
    </div>
</asp:Content>