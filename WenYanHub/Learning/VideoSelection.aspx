<%@ Page Title="Video Lessons" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VideoSelection.aspx.cs" Inherits="WenYanHub.Learning.VideoSelection" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="text-center mb-5 mt-4">
        <h1 class="display-4 font-classic fw-bold" style="color: #3e2723;">
            <i class="fa-solid fa-book-open me-2 icon-gold"></i> Video Lessons
        </h1>
        <p class="lead text-muted" style="color: #3e2723;">Select an article to view expert video explanations</p>
    </div>

    <ul class="nav nav-pills justify-content-center mb-5 gap-3" id="videoTabs" role="tablist">
        <li class="nav-item">
            <button class="nav-link active fw-bold px-4 rounded-pill shadow-sm" data-bs-toggle="tab" data-bs-target="#junior" type="button">Junior High</button>
        </li>
        <li class="nav-item">
            <button class="nav-link fw-bold px-4 rounded-pill shadow-sm" data-bs-toggle="tab" data-bs-target="#senior" type="button">Senior High</button>
        </li>
        <li class="nav-item">
            <button class="nav-link fw-bold px-4 rounded-pill shadow-sm" data-bs-toggle="tab" data-bs-target="#extra" type="button">Extra-Curricular</button>
        </li>
    </ul>

    <div class="tab-content">
        <div class="tab-pane fade show active" id="junior">
            <div class="row g-4">
                <asp:Repeater ID="rptJunior" runat="server">
                    <ItemTemplate><%# GetCardHtml(Container.DataItem, "success") %></ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoJunior" runat="server" Text="No Video" Visible="false" CssClass="text-muted w-100 text-center py-5 font-classic"></asp:Label>
            </div>
        </div>

        <div class="tab-pane fade" id="senior">
            <div class="row g-4">
                <asp:Repeater ID="rptSenior" runat="server">
                    <ItemTemplate><%# GetCardHtml(Container.DataItem, "primary") %></ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoSenior" runat="server" Text="No Video" Visible="false" CssClass="text-muted w-100 text-center py-5 font-classic"></asp:Label>
            </div>
        </div>

        <div class="tab-pane fade" id="extra">
            <div class="row g-4">
                <asp:Repeater ID="rptExtra" runat="server">
                    <ItemTemplate><%# GetCardHtml(Container.DataItem, "warning") %></ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoExtra" runat="server" Text="No Video" Visible="false" CssClass="text-muted w-100 text-center py-5 font-classic"></asp:Label>
            </div>
        </div>
    </div>

    <style>

    :root { 
        --gu-brown-dark: #3e2723;   
        --gu-brown-main: #5d4037;  
        --gu-paper: #fdfbf7;      
        --gu-gold: #D4AF37;      
    }
    .font-classic { font-family: 'Noto Serif SC', serif; }
    .icon-gold { color: var(--gu-gold) !important; }

    .nav-pills .nav-link {
        color: var(--gu-brown-main) !important;
        background-color: transparent;
        border: 1px solid var(--gu-brown-main);
        transition: all 0.3s ease;
        margin: 0 5px;
    }
    .nav-pills .nav-link.active {
        background-color: var(--gu-brown-dark) !important;
        color: var(--gu-paper) !important;
        border-color: var(--gu-brown-dark) !important;
    }

    .badge {
        background-color: rgba(93, 64, 55, 0.1) !important;
        color: var(--gu-brown-main) !important;
        border: 1px solid rgba(93, 64, 55, 0.2) !important;
    }

    .tab-content .card-body .btn,
    .tab-content .card-body .btn-dark,
    .tab-content .card-body .btn-outline-primary,
    .tab-content .card-body [class*="btn-outline"] {
        background-color: transparent !important; 
        color: var(--gu-brown-main) !important;    
        border: 1.5px solid var(--gu-brown-main) !important; 
        border-radius: 50px !important;
        font-weight: bold !important;
        transition: all 0.3s ease !important;
    }


    .tab-content .card-body .btn:hover,
    .tab-content .card-body .btn-dark:hover,
    .tab-content .card-body [class*="btn-outline"]:hover {
        background-color: var(--gu-brown-main) !important; 
        color: var(--gu-paper) !important;               
        box-shadow: 0 4px 8px rgba(93, 64, 55, 0.3) !important;
        transform: translateY(-1px);
    }

    .hover-lift { transition: all 0.3s ease; }
    .hover-lift:hover { 
        transform: translateY(-5px); 
        box-shadow: 0 10px 20px rgba(93, 64, 55, 0.15) !important; 
    }
</style>
</asp:Content>