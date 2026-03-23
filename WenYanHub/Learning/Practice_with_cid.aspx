<%@ Page Title="Specific Practices" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Practice_with_cid.aspx.cs" Inherits="WenYanHub.Learning.Practice_with_cid" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .icon-gold { color: #C5A059 !important; }
        .hover-list-item { transition: all 0.3s ease; border-left: 5px solid transparent !important; cursor: pointer; }
        .hover-list-item:hover { transform: translateX(5px); box-shadow: 0 5px 15px rgba(0,0,0,0.08) !important; border-left: 5px solid #3e2723 !important; background-color: #fffdfa; }
        

        .task-detail-pane { background: #ffffff; border: 1px solid #eee; border-top: none; padding: 25px; border-radius: 0 0 15px 15px; }
        .section-title { font-size: 0.9rem; font-weight: bold; color: #3e2723; text-transform: uppercase; letter-spacing: 1px; display: block; margin-bottom: 10px; border-bottom: 1px solid #d7ccc8; }
        .file-card { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 12px 18px; display: flex; align-items: center; gap: 15px; margin-bottom: 15px; }
        

        .pdf-icon-bg, .fa-file-pdf { background-color: #5D4037 !important; color: white !important; font-size: 0.7rem; font-weight: bold; padding: 3px 6px; border-radius: 4px; }
        

        .feedback-card { background: #fdfaf5 !important; border: 1px solid #d7ccc8 !important; padding: 15px; border-radius: 8px; }
        .feedback-card strong, .score-value { color: #000000 !important; }

      
        .badge.bg-success, .badge.text-bg-success, .badge.bg-primary, .text-primary {
            color: #5D4037 !important;
            background-color: rgba(93, 64, 55, 0.1) !important;
        }

  
        [class*="Graded"] {
            background-color: #3E2723 !important; 
            color: #ffffff !important;
            border: 1px solid #3E2723 !important;
        }

   
        .badge.bg-info, .badge.bg-primary, .badge.text-bg-info, .badge.text-bg-primary, [class*="Pending"] {
            background-color: #D7CCC8 !important; 
            color: #5D4037 !important;
            border: 1px solid #D7CCC8 !important;
        }

     
        .info-label { color: #8c7b75 !important; }
        .info-value { color: #3E2723 !important; }
        .hover-list-item i.fa-clock, .text-danger { color: #5D4037 !important; }

       
        [onclick*="removeSub"], .text-danger.btn-link {
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
        [onclick*="removeSub"]:hover, .text-danger.btn-link:hover {
            background-color: #5D4037 !important;
            color: #ffffff !important;
            box-shadow: 0 4px 8px rgba(93, 64, 55, 0.2);
        }

        .btn-download-feedback, 
        .btn-dark.btn-sm,
        [href*="DownloadFeedback"] {
            display: inline-block;
            background-color: #5D4037 !important; 
            color: #ffffff !important;           
            border: 1px solid #5D4037 !important;
            padding: 6px 16px;
            border-radius: 20px;              
            text-decoration: none !important;
            font-size: 0.8rem;
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .btn-download-feedback:hover, 
        .btn-dark.btn-sm:hover,
        [href*="DownloadFeedback"]:hover {
            background-color: #3E2723 !important; 
            border-color: #3E2723 !important;
            color: #ffffff !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }


        .btn-download-feedback i, 
        [href*="DownloadFeedback"] i {
            color: #ffffff !important;
            margin-right: 5px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="text-center mb-5">
            <h1 class="display-5 font-classic fw-bold" style="color: #3e2723;">
                <i class="fa-solid fa-pen-to-square me-2 icon-gold"></i>Practices for: <asp:Literal ID="litArticleName" runat="server" Text="This Content"></asp:Literal>
            </h1>
            <p class="text-muted">Below are the specific exercises assigned for this classical text.</p>
        </div>

        <asp:FileUpload ID="masterFileUpload" runat="server" style="display:none;" onchange="document.getElementById('btnDoPreUpload').click();" />
        <asp:Button ID="btnDoPreUpload" runat="server" style="display:none;" OnClick="btnDoPreUpload_Click" ClientIDMode="Static" />
        <asp:Button ID="btnFinalSubmit" runat="server" style="display:none;" OnClick="btnFinalSubmit_Click" ClientIDMode="Static" />
        <asp:Button ID="btnRemoveSubmission" runat="server" style="display:none;" OnClick="btnRemoveSubmission_Click" ClientIDMode="Static" />
        <asp:HiddenField ID="hfTargetId" runat="server" />

        <div class="row justify-content-center">
            <div class="col-md-10">
                <asp:Repeater ID="rptSpecificPractices" runat="server">
                    <ItemTemplate>
                        <%# GetItemHtml(Container.DataItem) %>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoData" runat="server" Visible="false" CssClass="text-center py-5">
                    <div class="card border-0 shadow-sm p-5 rounded-4 bg-light">
                        <i class="fa-solid fa-folder-open fa-3x mb-3 text-muted"></i>
                        <p class="text-muted mb-0">No active practices found for this specific content yet.</p>
                        <a href="PracticeSelection.aspx" class="btn btn-link mt-2">Back to Practice Hub</a>
                    </div>
                </asp:Panel>
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