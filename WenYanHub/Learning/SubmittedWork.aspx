<%@ Page Title="Submitted Work" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SubmittedWork.aspx.cs" Inherits="WenYanHub.Learning.SubmittedWork" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .icon-gold {
    color: #C5A059 !important;
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
        .hover-list-item { transition: all 0.3s ease; border-left: 5px solid transparent !important; cursor: pointer; }
        .hover-list-item:hover { transform: translateX(5px); box-shadow: 0 5px 15px rgba(0,0,0,0.08) !important; border-left: 5px solid #3e2723 !important; background-color: #fffdfa; }
        .nav-pills .nav-link { color: #3e2723 !important; background-color: transparent; border: 1px solid #3e2723; transition: all 0.3s ease; }
        .nav-pills .nav-link.active { background-color: #3e2723 !important; color: #ffffff !important; border-color: #3e2723 !important; }
        .task-detail-pane { background: #ffffff; border: 1px solid #eee; border-top: none; padding: 25px; border-radius: 0 0 15px 15px; }
        .section-title { font-size: 0.9rem; font-weight: bold; color: #3e2723; text-uppercase: uppercase; letter-spacing: 1px; display: block; margin-bottom: 10px; }
        .file-card { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 12px 18px; display: flex; align-items: center; gap: 15px; margin-bottom: 15px; }
        .pdf-icon-bg { background: #e74c3c; color: white; font-size: 0.7rem; font-weight: bold; padding: 3px 6px; border-radius: 4px; }
        
        .feedback-card { background: #fdfaf5 !important; border: 1px solid #d7ccc8 !important; padding: 15px; border-radius: 8px; }

.pdf-icon-bg, 
.fa-file-pdf {
    background-color: #5D4037 !important;
    color: white !important;
}

.section-title {
    color: #3E2723 !important;
    border-bottom: 1px solid #d7ccc8;
}

.info-label { color: #8c7b75 !important; }
.info-value { color: #3E2723 !important; }

.feedback-card strong, 
.score-value, 
[style*="color: #e74c3c"],
.text-danger {
    color: #5d4037 !important; 
}


.hover-list-item i.fa-clock {
    color: #5D4037 !important; 
}

.badge.bg-success, 
.badge.text-bg-success,
.text-success,
.bg-success,
[class*="Graded"],
.badge[style*="background-color"], 
.bg-opacity-10 {
    background-color: #3E2723 !important; 
    color: #ffffff !important;          
    border-color: #3E2723 !important;
    opacity: 1 !important;             
}

.hover-list-item[style*="border-left"], 
.task-detail-pane,
div[style*="border-left"] {
    border-left-color: #3E2723 !important; 
}

.pdf-icon-bg, .fa-file-pdf {
    background-color: #5D4037 !important;
}

.badge.bg-warning,
.badge.text-bg-warning,
[class*="Pending"] {
    background-color: #D7CCC8 !important; 
    color: #5D4037 !important;           
    border: 1px solid #D7CCC8 !important;
}


[onclick*="triggerRemove"],
.text-danger.btn-link {
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
    margin-top: 5px;
}


[onclick*="triggerRemove"]:hover,
.text-danger.btn-link:hover {
    background-color: #5D4037 !important; 
    color: #ffffff !important;          
    box-shadow: 0 4px 8px rgba(93, 64, 55, 0.2);
    transform: translateY(-1px);        
}


[onclick*="ViewGradedWork"], 
.btn-outline-dark.btn-sm,
.task-detail-pane .btn-secondary {
    display: inline-block;
    background-color: #3E2723 !important; 
    color: #ffffff !important;           
    border: 1px solid #3E2723 !important;
    padding: 6px 18px;
    border-radius: 20px;               
    text-decoration: none !important;
    font-size: 0.85rem;
    font-weight: 500;
    transition: all 0.3s ease;
    cursor: pointer;
    margin-top: 5px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

[onclick*="ViewGradedWork"]:hover, 
.btn-outline-dark.btn-sm:hover,
.task-detail-pane .btn-secondary:hover {
    background-color: #5D4037 !important; 
    border-color: #5D4037 !important;
    color: #ffffff !important;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(93, 64, 55, 0.3);
}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="text-center mb-5 mt-4">
        <h1 class="display-5 font-classic fw-bold" style="color: #3e2723;">
    <i class="fa-solid fa-briefcase me-2 icon-gold"></i> My Workspace
</h1>
        <p class="text-muted">Review your tasks and feedback.</p>
    </div>

    <ul class="nav nav-pills justify-content-center mb-5 gap-2" id="statusTabs">
        <li class="nav-item">
            <button class="nav-link active fw-bold px-4 rounded-pill shadow-sm" data-bs-toggle="tab" data-bs-target="#tabAll" type="button">All Work</button>
        </li>
        <li class="nav-item">
            <button class="nav-link fw-bold px-4 rounded-pill shadow-sm" data-bs-toggle="tab" data-bs-target="#tabPending" type="button">Pending</button>
        </li>
        <li class="nav-item">
            <button class="nav-link fw-bold px-4 rounded-pill shadow-sm" data-bs-toggle="tab" data-bs-target="#tabGraded" type="button">Returned</button>
        </li>
    </ul>

    <div class="tab-content">
        <div class="tab-pane fade show active" id="tabAll">
            <asp:Repeater ID="rptAll" runat="server">
                <ItemTemplate>
                    <%# RenderWorkItem(Container.DataItem) %>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoWorkAll" runat="server" Visible="false" CssClass="text-center py-5 text-muted">
                <i class="fa-solid fa-folder-open fa-3x mb-3 opacity-25"></i>
                <p>No work submitted yet.</p>
            </asp:Panel>
        </div>

        <div class="tab-pane fade" id="tabPending">
            <asp:Repeater ID="rptPending" runat="server">
                <ItemTemplate>
                    <%# RenderWorkItem(Container.DataItem) %>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoWorkPending" runat="server" Visible="false" CssClass="text-center py-5 text-muted">
                <i class="fa-solid fa-clock fa-3x mb-3 opacity-25"></i>
                <p>No pending work.</p>
            </asp:Panel>
        </div>

        <div class="tab-pane fade" id="tabGraded">
            <asp:Repeater ID="rptGraded" runat="server">
                <ItemTemplate>
                    <%# RenderWorkItem(Container.DataItem) %>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoWorkGraded" runat="server" Visible="false" CssClass="text-center py-5 text-muted">
                <i class="fa-solid fa-clipboard-check fa-3x mb-3 opacity-25"></i>
                <p>No returned work.</p>
            </asp:Panel>
        </div>
    </div>

    <asp:HiddenField ID="hfSubmissionIdToDelete" runat="server" />
    <asp:Button ID="btnHiddenDelete" runat="server" OnClick="btnHiddenDelete_Click" style="display:none;" />

    <script type="text/javascript">
        function triggerRemove(id) {
            if (confirm('Are you sure you want to remove this submission? This action cannot be undone.')) {
                document.getElementById('<%= hfSubmissionIdToDelete.ClientID %>').value = id;
                document.getElementById('<%= btnHiddenDelete.ClientID %>').click();
            }
        }
    </script>
</asp:Content>