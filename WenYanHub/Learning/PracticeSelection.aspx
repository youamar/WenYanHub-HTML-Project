<%@ Page Title="Practice Hub" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PracticeSelection.aspx.cs" Inherits="WenYanHub.Learning.PracticeSelection" %>

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
/* Mouse hover */
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
        .section-title { font-size: 0.9rem; font-weight: bold; color: #3e2723; text-transform: uppercase; letter-spacing: 1px; display: block; margin-bottom: 10px; }
        .file-card { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 12px 18px; display: flex; align-items: center; gap: 15px; margin-bottom: 15px; }
        .pdf-icon-bg { background: #e74c3c; color: white; font-size: 0.7rem; font-weight: bold; padding: 3px 6px; border-radius: 4px; }
        .feedback-card { background: #fffdf0; border: 1px solid #ffeeba; padding: 15px; border-radius: 8px; }

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
[style*="color: #e74c3c"] {
    color: #000000 !important; 
}


.hover-list-item i.fa-clock,
.text-danger,
[style*="color: #e74c3c"],
[style*="color: red"] {
    color: #5D4037 !important; 
}


[class*="Graded"] {
    background-color: #3E2723 !important; 
    color: #ffffff !important;
    border: 1px solid #3E2723 !important;
}

.badge.bg-info,
.badge.bg-primary,
.badge.text-bg-info,
.badge.text-bg-primary,
[class*="Pending"] {
    background-color: #D7CCC8 !important; 
    color: #5D4037 !important;           
    border: 1px solid #D7CCC8 !important;
}

[onclick*="removeSub"], 
.task-detail-pane a.text-danger.btn-link {
    display: inline-block;
    color: #5D4037 !important;          
    background-color: transparent !important; 
    border: 1px solid #5D4037 !important; 
    padding: 5px 15px;
    border-radius: 20px;                 
    text-decoration: none !important;    
    font-size: 0.85rem;
    font-weight: 500;
    transition: all 0.3s ease;
    cursor: pointer;
}

[onclick*="removeSub"]:hover, 
.task-detail-pane a.text-danger.btn-link:hover {
    background-color: #5D4037 !important; 
    color: #ffffff !important;           
    box-shadow: 0 4px 8px rgba(93, 64, 55, 0.2);
    transform: translateY(-1px);
}

[onclick*="removeSub"], 
[onclick*="removeAssignment"],
.text-danger.btn-link {
    display: inline-block;
    color: #5D4037 !important;           
    background-color: transparent !important; 
    border: 1px solid #5D4037 !important; 
    padding: 4px 12px;
    border-radius: 20px;                
    text-decoration: none !important;    
    font-size: 0.8rem;
    font-weight: 500;
    transition: all 0.3s ease;
    cursor: pointer;
}


[onclick*="removeSub"]:hover, 
[onclick*="removeAssignment"]:hover,
.text-danger.btn-link:hover {
    background-color: #5D4037 !important; 
    color: #ffffff !important;         
    box-shadow: 0 4px 8px rgba(93, 64, 55, 0.2);
}

.badge.bg-success, 
.badge.text-bg-success,
.badge.bg-primary,
.text-primary {
    color: #5D4037 !important;
    background-color: rgba(93, 64, 55, 0.1) !important;
}

.btn-dark, 
[value*="View Returned Work"], 
[onclick*="ViewReturnedWork"] {
    background-color: #3E2723 !important; 
    color: #ffffff !important;           
    border: 1px solid #3E2723 !important;
    padding: 6px 18px;
    border-radius: 20px;              
    font-size: 0.85rem;
    font-weight: 500;
    transition: all 0.3s ease;
    cursor: pointer;
    box-shadow: 0 2px 5px rgba(0,0,0,0.15);
}

.btn-dark:hover, 
[value*="View Returned Work"]:hover, 
[onclick*="ViewReturnedWork"]:hover {
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
        <i class="fa-solid fa-pen-to-square me-2 icon-gold"></i> Practice Hub
    </h1>
        <p style="color: #5d4037 !important;">Master Classical Chinese through content-synchronized exercises.</p>
    </div>

    <asp:FileUpload ID="masterFileUpload" runat="server" style="display:none;" onchange="document.getElementById('btnDoPreUpload').click();" />
    <asp:Button ID="btnDoPreUpload" runat="server" style="display:none;" OnClick="btnDoPreUpload_Click" ClientIDMode="Static" />
    <asp:Button ID="btnFinalSubmit" runat="server" style="display:none;" OnClick="btnFinalSubmit_Click" ClientIDMode="Static" />
    <asp:Button ID="btnRemoveSubmission" runat="server" style="display:none;" OnClick="btnRemoveSubmission_Click" ClientIDMode="Static" />
    <asp:HiddenField ID="hfTargetId" runat="server" />

    <ul class="nav nav-pills justify-content-center mb-5 gap-2">
        <li class="nav-item"><button class="nav-link active fw-bold px-4 rounded-pill shadow-sm" data-bs-toggle="tab" data-bs-target="#junior" type="button">Junior High</button></li>
        <li class="nav-item"><button class="nav-link fw-bold px-4 rounded-pill shadow-sm" data-bs-toggle="tab" data-bs-target="#senior" type="button">Senior High</button></li>
        <li class="nav-item"><button class="nav-link fw-bold px-4 rounded-pill shadow-sm" data-bs-toggle="tab" data-bs-target="#extra" type="button">Extra-Curricular</button></li>
    </ul>

    <div class="tab-content">
        <div class="tab-pane fade show active" id="junior">
            <div class="container">
                <asp:Repeater ID="rptJunior" runat="server"><ItemTemplate><%# GetItemHtml(Container.DataItem) %></ItemTemplate></asp:Repeater>
                <asp:Panel ID="pnlNoJunior" runat="server" Visible="false" CssClass="text-center py-5 text-muted">No Junior practices found.</asp:Panel>
            </div>
        </div>
        <div class="tab-pane fade" id="senior">
            <div class="container">
                <asp:Repeater ID="rptSenior" runat="server"><ItemTemplate><%# GetItemHtml(Container.DataItem) %></ItemTemplate></asp:Repeater>
                <asp:Panel ID="pnlNoSenior" runat="server" Visible="false" CssClass="text-center py-5 text-muted">No Senior practices found.</asp:Panel>
            </div>
        </div>
        <div class="tab-pane fade" id="extra">
            <div class="container">
                <asp:Repeater ID="rptExtra" runat="server"><ItemTemplate><%# GetItemHtml(Container.DataItem) %></ItemTemplate></asp:Repeater>
                <asp:Panel ID="pnlNoExtra" runat="server" Visible="false" CssClass="text-center py-5 text-muted">No Extra-Curricular practices found.</asp:Panel>
            </div>
        </div>
    </div>

    <script>
        function triggerUpload(pid) {
            document.getElementById('<%= hfTargetId.ClientID %>').value = pid;
            document.getElementById('<%= masterFileUpload.ClientID %>').click();
        }
        function finalSubmit(pid) {
            document.getElementById('<%= hfTargetId.ClientID %>').value = pid;
            document.getElementById('btnFinalSubmit').click();
        }
        function removeSub(pid) {
            if(confirm('Are you sure you want to remove this submission?')) {
                document.getElementById('<%= hfTargetId.ClientID %>').value = pid;
                document.getElementById('btnRemoveSubmission').click();
            }
        }
    </script>
</asp:Content>