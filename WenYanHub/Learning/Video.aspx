<%@ Page Title="Video Lessons" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Video.aspx.cs" Inherits="WenYanHub.Learning.Video" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .video-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; background: #000; border-radius: 8px; }
        .video-container iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: 0; }
        .video-card { border-left: 5px solid #3e2723 !important; transition: all 0.3s ease; }
        .video-card:hover { transform: translateX(5px); box-shadow: 0 5px 15px rgba(0,0,0,0.08) !important; }
        .font-classic { font-family: 'Noto Serif SC', serif; }

        .display-5.font-classic {
        color: #3e2723 !important;
    }

    .btn-watch-lesson {
        display: inline-block;
        color: #5D4037 !important;         
        background-color: transparent !important; 
        border: 1px solid #5D4037 !important; 
        padding: 5px 18px;
        border-radius: 20px;            
        text-decoration: none !important;
        font-size: 0.85rem;
        font-weight: 500;
        transition: all 0.3s ease;
        cursor: pointer;
    }

    .btn-watch-lesson:hover {
        background-color: #5D4037 !important; 
        color: #ffffff !important;           
        box-shadow: 0 4px 8px rgba(93, 64, 55, 0.2);
    }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="mb-4">
            <a href="VideoSelection.aspx" class="text-decoration-none text-muted small">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Selection
            </a>
            <h1 class="display-5 font-classic fw-bold mt-2">
                <asp:Literal ID="litArticleTitle" runat="server"></asp:Literal>
            </h1>
            <p class="text-muted">Available expert explanations for this text.</p>
        </div>

        <asp:Repeater ID="rptVideos" runat="server">
            <ItemTemplate>
                <div class="card mb-3 border-0 shadow-sm rounded-4 overflow-hidden video-card">
                    <div class="card-body p-4 d-flex align-items-center justify-content-between">
                        <div class="flex-grow-1">
                            <h5 class="fw-bold mb-1"><%# Eval("Description") %></h5>
                            <small class="text-muted">
    <i class="fa-solid fa-user-tie me-1"></i> Instructor: <%# Eval("Teacher.Username") %> 
    <span class="mx-2">|</span>
    <i class="fa-regular fa-calendar me-1"></i> <%# Eval("CreatedAt", "{0:yyyy-MM-dd}") %>
</small>
                        </div>
                        <div class="ms-4">
                            <button type="button" class="btn btn-watch-lesson rounded-pill px-4 btn-sm fw-bold" 
                                    data-bs-toggle="collapse" data-bs-target='#vid_<%# Eval("RecordId") %>'>
                                <i class="fa-solid fa-play me-1"></i> Watch Lesson
                            </button>
                        </div>
                    </div>

                    <div class="collapse" id='vid_<%# Eval("RecordId") %>'>
                        <div class="p-4 border-top bg-light">
                            <div class="video-container shadow-sm">
                                <iframe src='<%# GetEmbedUrl(Eval("RecordLink").ToString()) %>' 
                                        allowfullscreen></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoVideos" runat="server" Visible="false" CssClass="text-center py-5">
            <i class="fa-solid fa-video-slash fa-3x text-muted mb-3 opacity-25"></i>
            <h4 class="text-muted">No approved videos found for this lesson.</h4>
        </asp:Panel>
    </div>
</asp:Content>