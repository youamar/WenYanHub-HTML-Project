<%@ Page Title="Feedback & Support" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="WenYanHub.Others.FeedbackPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        
        <div class="text-center mb-5">
            <h1 class="display-4 font-classic fw-bold text-dark">Support Center</h1>
            <p class="text-muted">Report errors, ask questions, or track your existing tickets.</p>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-lg rounded-4 overflow-hidden" style="background-color: #fdfbf7;">
                    
                    <div class="card-header bg-white border-bottom p-0">
                        <ul class="nav nav-tabs nav-justified border-0" id="feedbackTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button runat="server" id="btnTabSubmit" class="nav-link active fw-bold py-3 text-dark border-0 rounded-0" data-bs-toggle="tab" data-bs-target=".tab-submit" type="button" role="tab">
                                    <i class="fa-solid fa-paper-plane me-2 text-danger"></i> Submit Feedback
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button runat="server" id="btnTabTrack" class="nav-link fw-bold py-3 text-dark border-0 rounded-0" data-bs-toggle="tab" data-bs-target=".tab-track" type="button" role="tab">
                                    <i class="fa-solid fa-magnifying-glass me-2 text-primary"></i> Track Ticket
                                </button>
                            </li>
                        </ul>
                    </div>

                    <div class="card-body p-5">
    
                        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert text-center mb-4 font-classic fw-bold shadow-sm">
                            <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
                        </asp:Panel>

                        <div class="tab-content" id="feedbackTabsContent">
        
                            <div runat="server" id="divTabSubmit" class="tab-pane fade show active tab-submit" role="tabpanel">
                                <h4 class="font-classic text-dark mb-4 border-bottom pb-2">We value your input</h4>
            
                                <div class="mb-3">
                                    <label class="form-label text-muted small">Your Email (Required for tracking)</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" required="true" placeholder="scholar@example.com"></asp:TextBox>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted small">Category</label>
                                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Translation Error" Value="Error"></asp:ListItem>
                                        <asp:ListItem Text="Content Request" Value="Request"></asp:ListItem>
                                        <asp:ListItem Text="Website Bug" Value="Bug"></asp:ListItem>
                                        <asp:ListItem Text="Other" Value="Other"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-muted small">Related Page URL (Optional)</label>
                                    <asp:TextBox ID="txtSourceUrl" runat="server" CssClass="form-control" placeholder="Paste the link of the article here if applicable..."></asp:TextBox>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label text-muted small">Message</label>
                                    <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" required="true" placeholder="Describe the issue in detail..."></asp:TextBox>
                                </div>
                                <div class="d-grid">
                                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Ticket" 
                                        CssClass="btn btn-dark btn-lg font-classic" style="background-color: #3e2723;" 
                                        OnClick="btnSubmit_Click" 
                                        UseSubmitBehavior="false" 
                                        OnClientClick="if(this.form.checkValidity()){ this.disabled=true; this.value='Submitting...'; __doPostBack(this.name, ''); }" />
                                </div>
                            </div>

                            <div runat="server" id="divTabTrack" class="tab-pane fade tab-track" role="tabpanel">
                                <h4 class="font-classic text-dark mb-4 border-bottom pb-2">Manage Existing Ticket</h4>
            
                                <div class="input-group mb-4 shadow-sm">
                                    <asp:TextBox ID="txtTrackingCode" runat="server" CssClass="form-control" placeholder="Enter Tracking Code (e.g. WYH-XXXXX)"></asp:TextBox>
                                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" UseSubmitBehavior="false" />
                                </div>

                                <asp:Panel ID="pnlTicketDetails" runat="server" Visible="false" CssClass="p-4 border rounded bg-white shadow-sm position-relative">
    
                                <div class="position-absolute top-0 end-0 m-3">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="badge bg-warning text-dark fs-6"></asp:Label>
                                </div>
    
                                <h5 class="text-dark fw-bold mb-1">Ticket: <asp:Label ID="lblDisplayCode" runat="server"></asp:Label></h5>
                                <p class="text-muted small border-bottom pb-3 mb-3">Submitted on: <asp:Label ID="lblDate" runat="server"></asp:Label></p>

                                <div class="mb-4">
                                    <label id="lblMessageHeader" runat="server" class="form-label text-muted small">Your Message</label>
                                    <asp:TextBox ID="txtEditMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                </div>

                                <asp:Panel ID="pnlAdminReply" runat="server" Visible="false" CssClass="mb-4 p-3 bg-light border-start border-4 border-success rounded">
                                    <h6 class="text-success fw-bold mb-2">
                                        <i class="fa-solid fa-reply me-2"></i>Admin Response
                                    </h6>
                                    <div class="text-dark">
                                        <asp:Literal ID="litAdminReply" runat="server"></asp:Literal>
                                    </div>
                                </asp:Panel>

                                <div class="d-flex justify-content-between mb-2">
                                    <asp:Button ID="btnDelete" runat="server" Text="Withdraw" CssClass="btn btn-outline-danger" 
                                                OnClientClick="if(!confirm('Are you sure you want to withdraw this ticket?')) return false;" 
                                                OnClick="btnDelete_Click" UseSubmitBehavior="false" />
        
                                    <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" CssClass="btn btn-success" 
                                                OnClick="btnUpdate_Click" UseSubmitBehavior="false" />
                                </div>

                                <asp:Label ID="lblLockNotice" runat="server" CssClass="text-danger small d-block text-center mt-3" Visible="false">
                                    <i class="fa-solid fa-lock me-1"></i> This ticket is already being processed and cannot be modified or withdrawn.
                                </asp:Label>

                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .nav-tabs .nav-link.active {
            border-bottom: 3px solid #8b0000 !important;
            color: #8b0000 !important;
            background-color: transparent !important;
        }
        .nav-tabs .nav-link {
            transition: all 0.3s ease;
        }
    </style>
</asp:Content>