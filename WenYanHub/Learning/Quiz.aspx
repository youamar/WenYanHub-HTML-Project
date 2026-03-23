<%@ Page Title="Game Hub" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Quiz.aspx.cs" Inherits="WenYanHub.Learning.Quiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .nav-pills .nav-link {
    color: #3e2723 !important;
    background-color: transparent;
    border: 1px solid #3e2723;
    transition: all 0.3s ease;
}

.nav-pills .nav-link:hover {
    background-color: rgba(62, 39, 35, 0.1) !important;
    color: #3e2723 !important;
}

.nav-pills .nav-link.active {
    background-color: #3e2723 !important;
    color: #ffffff !important;
    border-color: #3e2723 !important;
}
        .hover-lift:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important;
            background-color: #fdfbf7;
        }
        .transition-all { transition: all 0.3s ease; }
        
        .done-badge {
            font-size: 0.65rem;
            padding: 3px 8px;
            background-color: #fdfaf5 !important; 
    color: #8c6b1f !important; 
    border: 1px solid #d7ccc8 !important;
            border-radius: 4px;
            letter-spacing: 1px;
            vertical-align: middle;
            font-family: sans-serif;
            font-weight: bold;
        }

.zoom-card .btn-primary, 
.card-body .btn-primary {
    color: #3e2723 !important; 
    background-color: transparent !important; 
    border: 1px solid #3e2723 !important; 
    transition: all 0.3s ease;
}

.zoom-card .btn-primary:hover, 
.card-body .btn-primary:hover {
    background-color: #3e2723 !important; 
    color: #ffffff !important; 
    border-color: #3e2723 !important;
    box-shadow: 0 4px 10px rgba(62, 39, 35, 0.3) !important;
}

.badge.bg-success, 
.badge.bg-primary {
    background-color: rgba(93, 64, 55, 0.1) !important; 
}

.badge.text-success, 
.badge.text-primary {
    color: #5d4037 !important; 
}

.icon-gold {
    color: #D4AF37 !important; 
}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="text-center mb-5 mt-4">
        <h1 class="display-4 font-classic fw-bold" style="color: #3e2723;">
        <i class="fa-solid fa-book-open me-2 icon-gold"></i> Game Hub
    </h1>
        <p class="lead text-muted">Select a chapter to start your challenge!</p>
    </div>

    <ul class="nav nav-pills justify-content-center mb-5 gap-3" id="gameTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active fw-bold px-5 rounded-pill shadow-sm" id="junior-tab" data-bs-toggle="tab" data-bs-target="#junior" type="button" role="tab">
                Junior High
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link fw-bold px-5 rounded-pill shadow-sm" id="senior-tab" data-bs-toggle="tab" data-bs-target="#senior" type="button" role="tab">
                Senior High
            </button>
        </li>
    </ul>

    <div class="tab-content" id="gameTabsContent">
        
        <div class="tab-pane fade show active" id="junior" role="tabpanel">
            <div class="row g-4">
                <asp:Repeater ID="rptJuniorGames" runat="server">
                    <ItemTemplate>
                        <div class="col-md-4 col-lg-3">
                            <div class="card h-100 shadow-sm border-0 hover-lift transition-all">
                                <div class="card-body text-center p-4">
                                    <span class="badge bg-success bg-opacity-10 text-success mb-3 px-3 py-2 rounded-pill"><%# Eval("Category") %></span>
                                    
                                    <h4 class="card-title font-classic fw-bold text-dark mb-2">
                                        <%# Eval("Title") %>
                                        
                                        <%--If completed, display the DONE marker --%>
                                        <asp:PlaceHolder runat="server" Visible='<%# (bool)Eval("IsDone") %>'>
                                            <span class="ms-1 done-badge">
                                                <i class="fa-solid fa-circle-check"></i> DONE
                                            </span>
                                        </asp:PlaceHolder>
                                    </h4>

                                    <a href="/Learning/Mini_Game.aspx?cid=<%# Eval("ContentId") %>" class="btn btn-primary btn-sm rounded-pill px-4 stretched-link mt-3 shadow-sm">
                                        <%# (bool)Eval("IsDone") ? "Replay Game" : "Start Game" %>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoJunior" runat="server" Text="No games available in Junior High." Visible="false" CssClass="text-muted w-100 text-center py-5"></asp:Label>
            </div>
        </div>

        <div class="tab-pane fade" id="senior" role="tabpanel">
            <div class="row g-4">
                <asp:Repeater ID="rptSeniorGames" runat="server">
                    <ItemTemplate>
                        <div class="col-md-4 col-lg-3">
                            <div class="card h-100 shadow-sm border-0 hover-lift transition-all">
                                <div class="card-body text-center p-4">
                                    <span class="badge bg-primary bg-opacity-10 text-primary mb-3 px-3 py-2 rounded-pill"><%# Eval("Category") %></span>
                                    
                                    <h4 class="card-title font-classic fw-bold text-dark mb-2">
                                        <%# Eval("Title") %>
                                        
                                        <%-- DONE marker --%>
                                        <asp:PlaceHolder runat="server" Visible='<%# (bool)Eval("IsDone") %>'>
                                            <span class="ms-1 done-badge">
                                                <i class="fa-solid fa-circle-check"></i> DONE
                                            </span>
                                        </asp:PlaceHolder>
                                    </h4>

                                    <a href="/Learning/Mini_Game.aspx?cid=<%# Eval("ContentId") %>" class="btn btn-primary btn-sm rounded-pill px-4 stretched-link mt-3 shadow-sm">
                                        <%# (bool)Eval("IsDone") ? "Replay Game" : "Start Game" %>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoSenior" runat="server" Text="No games available in Senior High." Visible="false" CssClass="text-muted w-100 text-center py-5"></asp:Label>
            </div>
        </div>
    </div>

</asp:Content>