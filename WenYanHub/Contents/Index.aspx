<%@ Page Title="Library" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="WenYanHub.Contents.Index" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="text-center mb-5 mt-4">
        <h1 class="display-4 font-classic fw-bold" style="color: #3e2723;">
    <i class="fa-solid fa-book-open me-2 icon-gold"></i> The Library
</h1>
        <p class="lead text-muted">Select a category to browse our collection</p>
    </div>

    <ul class="nav nav-pills justify-content-center mb-5 gap-3" id="libraryTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active fw-bold px-4 rounded-pill shadow-sm" id="junior-tab" data-bs-toggle="tab" data-bs-target="#junior" type="button" role="tab">
                Junior High
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link fw-bold px-4 rounded-pill shadow-sm" id="senior-tab" data-bs-toggle="tab" data-bs-target="#senior" type="button" role="tab">
                Senior High
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link fw-bold px-4 rounded-pill shadow-sm" id="extra-tab" data-bs-toggle="tab" data-bs-target="#extra" type="button" role="tab">
                Extra-Curricular
            </button>
        </li>
    </ul>

    <div class="tab-content" id="libraryTabsContent">
        
        <div class="tab-pane fade show active" id="junior" role="tabpanel">
            <div class="row g-4">
                <asp:Repeater ID="rptJunior" runat="server">
                    <ItemTemplate>
                        <div class="col-md-4 col-lg-3">
                            <div class="card h-100 shadow-sm border-0 hover-lift transition-all">
                                <div class="card-body text-center p-4">
                                    <span class="badge bg-success bg-opacity-10 text-success mb-3 px-3 py-2 rounded-pill"><%# Eval("Category") %></span>
                                    <h4 class="card-title font-classic fw-bold text-dark mb-2"><%# Eval("Title") %></h4>
                                    <h6 class="card-subtitle mb-4 text-muted"><%# Eval("Author.Name") %></h6>
                                    <a href="Intro.aspx?id=<%# Eval("ContentId") %>" class="btn btn-outline-primary btn-sm rounded-pill px-4 stretched-link">
                                        View Lesson
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoJunior" runat="server" Text="No books found." Visible="false" CssClass="text-muted w-100 text-center py-5"></asp:Label>
            </div>
        </div>

        <div class="tab-pane fade" id="senior" role="tabpanel">
            <div class="row g-4">
                <asp:Repeater ID="rptSenior" runat="server">
                    <ItemTemplate>
                        <div class="col-md-4 col-lg-3">
                            <div class="card h-100 shadow-sm border-0 hover-lift transition-all">
                                <div class="card-body text-center p-4">
                                    <span class="badge bg-primary bg-opacity-10 text-primary mb-3 px-3 py-2 rounded-pill"><%# Eval("Category") %></span>
                                    <h4 class="card-title font-classic fw-bold text-dark mb-2"><%# Eval("Title") %></h4>
                                    <h6 class="card-subtitle mb-4 text-muted"><%# Eval("Author.Name") %></h6>
                                    <a href="Intro.aspx?id=<%# Eval("ContentId") %>" class="btn btn-outline-primary btn-sm rounded-pill px-4 stretched-link">
                                        View Lesson
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoSenior" runat="server" Text="No books found." Visible="false" CssClass="text-muted w-100 text-center py-5"></asp:Label>
            </div>
        </div>

        <div class="tab-pane fade" id="extra" role="tabpanel">
            <div class="row g-4">
                <asp:Repeater ID="rptExtra" runat="server">
                    <ItemTemplate>
                        <div class="col-md-4 col-lg-3">
                            <div class="card h-100 shadow-sm border-0 hover-lift transition-all">
                                <div class="card-body text-center p-4">
                                    <span class="badge bg-warning bg-opacity-10 text-dark mb-3 px-3 py-2 rounded-pill"><%# Eval("Category") %></span>
                                    <h4 class="card-title font-classic fw-bold text-dark mb-2"><%# Eval("Title") %></h4>
                                    <h6 class="card-subtitle mb-4 text-muted"><%# Eval("Author.Name") %></h6>
                                    <a href="Intro.aspx?id=<%# Eval("ContentId") %>" class="btn btn-outline-primary btn-sm rounded-pill px-4 stretched-link">
                                        View Lesson
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoExtra" runat="server" Text="No books found." Visible="false" CssClass="text-muted w-100 text-center py-5"></asp:Label>
            </div>
        </div>
    </div>

    <style>

        :root {
            --gu-brown-dark: #3e2723;   
            --gu-brown-main: #5d4037;   
            --gu-bamboo: #5c7a6b;      
            --gu-gold: #c5a059;        
            --gu-paper: #fdfbf7;      
        }


        .nav-pills .nav-link {
            color: var(--gu-brown-main) !important;
            background-color: transparent;
            transition: all 0.3s ease;
        }
    
        .nav-pills .nav-link:hover {
            background-color: rgba(93, 64, 55, 0.1) !important;
            color: var(--gu-brown-dark) !important;
        }

        .nav-pills .nav-link.active, .nav-pills .show > .nav-link {
            background-color: var(--gu-brown-dark) !important;
            color: var(--gu-paper) !important;
            box-shadow: 0 4px 10px rgba(62, 39, 35, 0.3) !important;
        }
        .icon-gold {
            color: #D4AF37 !important; 
        }


        .btn-outline-primary {
            color: var(--gu-brown-main) !important;
            border-color: var(--gu-brown-main) !important;
            transition: all 0.3s ease;
        }
        .btn-outline-primary:hover, .btn-outline-primary:focus {
            background-color: var(--gu-brown-main) !important;
            color: var(--gu-paper) !important;
            border-color: var(--gu-brown-main) !important;
            box-shadow: 0 4px 10px rgba(93, 64, 55, 0.3) !important;
        }

        .text-success { color: var(--gu-brown-main) !important; }
        .bg-success { background-color: var(--gu-brown-main) !important; }
        .bg-success.bg-opacity-10 { background-color: rgba(93, 64, 55, 0.1) !important; }

        .text-primary { color: var(--gu-brown-main) !important; }
        .bg-primary { background-color: var(--gu-brown-main) !important; }
        .bg-primary.bg-opacity-10 { background-color: rgba(93, 64, 55, 0.1) !important; }

        .text-warning { color: var(--gu-brown-main) !important; }
        .bg-warning { background-color: var(--gu-brown-main) !important; }
        .bg-warning.bg-opacity-10 { background-color: rgba(93, 64, 55, 0.1) !important; }
        
        .bg-warning.bg-opacity-10.text-dark { color: var(--gu-brown-dark) !important; }

        .hover-lift {
            transition: all 0.3s ease;
        }
        .hover-lift:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(93, 64, 55, 0.15) !important; 
        }
        .transition-all {
            transition: all 0.3s ease;
        }

        .display-4 + p.lead {
            color: var(--gu-brown-main) !important; 
            opacity: 0.8; 
        }

    </style>

</asp:Content>