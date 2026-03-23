<%@ Page Title="Assignment Task" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Practice.aspx.cs" Inherits="WenYanHub.Learning.Practice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .task-header { border-bottom: 1px solid #eee; padding-bottom: 20px; margin-bottom: 30px; }
        .section-title { font-size: 1.1rem; font-weight: bold; color: #3e2723; margin-bottom: 15px; display: block; }
        .file-card { 
            background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; 
            padding: 12px 18px; display: flex; justify-content: space-between; 
            align-items: center; margin-bottom: 10px;
        }
        .pdf-icon-bg { background: #e74c3c; color: white; font-size: 0.75rem; font-weight: bold; padding: 4px 8px; border-radius: 4px; }
        .file-name-text { color: #333; font-weight: 500; text-decoration: none; }
        
        .btn-new { background: white; border: 1px dashed #adb5bd; color: #0067b8; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: bold; }
        .btn-submit { background: #3e2723; color: white; border: none; padding: 10px 30px; border-radius: 20px; font-weight: bold; transition: 0.3s; }
        .btn-submit:hover { background: #5d3a35; transform: scale(1.05); }
        .btn-remove { color: #d9534f; font-size: 0.85rem; text-decoration: none; cursor: pointer; margin-left: 15px; }
        
        .feedback-card { background: #fffdf0; border: 1px solid #ffeeba; padding: 20px; border-radius: 8px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="task-header">
            <h1 class="display-5 font-classic fw-bold"><asp:Literal ID="litArticleTitle" runat="server"></asp:Literal></h1>
            <div class="d-flex justify-content-between text-muted mt-2">
                <div>
                    <i class="fa-solid fa-user-tie me-1"></i> Created by: <strong><asp:Literal ID="litTeacherName" runat="server"></asp:Literal></strong>
                </div>
                <span>Due: <asp:Literal ID="litDueDate" runat="server"></asp:Literal></span>
            </div>
        </div>

        <div class="mb-4">
            <span class="section-title">Instructions</span>
            <p class="text-secondary"><asp:Literal ID="litDescription" runat="server"></asp:Literal></p>
        </div>

        <div class="mb-5">
            <span class="section-title">Reference materials</span>
            <div class="file-card" style="max-width: 500px;">
                <div class="file-main">
                    <div class="pdf-icon-bg">PDF</div>
                    <asp:HyperLink ID="lnkQuestionFile" runat="server" CssClass="file-name-text" Target="_blank">Practice_Questions.pdf</asp:HyperLink>
                </div>
            </div>
        </div>

        <hr />

        <div class="mt-4">
            <span class="section-title">My work (Max 1 PDF)</span>
            
            <asp:PlaceHolder ID="phUploadArea" runat="server">
                <asp:FileUpload ID="fileInput" runat="server" style="display: none;" onchange="this.form.submit();" />
                <button type="button" class="btn-new" onclick="document.getElementById('<%= fileInput.ClientID %>').click();">
                    <i class="fa-solid fa-plus"></i> Upload PDF
                </button>
            </asp:PlaceHolder>

            <asp:Panel ID="pnlWorkPreview" runat="server" Visible="false" class="mt-3">
                <div class="file-card" style="max-width: 600px;">
                    <div class="file-main">
                        <div class="pdf-icon-bg">PDF</div>
                        <asp:Label ID="lblFileName" runat="server" CssClass="file-name-text"></asp:Label>
                        <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn-remove" OnClick="btnRemove_Click">Remove</asp:LinkButton>
                    </div>
                    <asp:Label ID="lblSubmitStatus" runat="server" CssClass="badge bg-info"></asp:Label>
                </div>
                
                <div class="mt-3">
                    <asp:Button ID="btnFinalSubmit" runat="server" Text="Submit Assignment" CssClass="btn-submit" OnClick="btnFinalSubmit_Click" Visible="false" />
                </div>
            </asp:Panel>
            
            <asp:Label ID="lblMsg" runat="server" CssClass="d-block mt-2"></asp:Label>
        </div>

        <asp:Panel ID="pnlFeedback" runat="server" Visible="false" class="mt-5">
            <hr />
            <span class="section-title">Teacher's Feedback</span>
            <div class="feedback-card">
                <h5>Score: <span class="text-danger"><asp:Literal ID="litScore" runat="server"></asp:Literal> / 100</span></h5>
                <p class="mt-3"><strong>Comments:</strong> <br /><asp:Literal ID="litComments" runat="server"></asp:Literal></p>
                <asp:HyperLink ID="lnkFeedbackFile" runat="server" CssClass="btn btn-sm btn-outline-dark mt-2" Target="_blank">Download Feedback File</asp:HyperLink>
            </div>
        </asp:Panel>
    </div>
</asp:Content>