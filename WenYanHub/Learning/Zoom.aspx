<%@ Page Title="Live Classes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ZoomLink.aspx.cs" Inherits="WenYanHub.Learning.ZoomLink" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .font-classic i.text-primary { color: #3e2723 !important; }
        
        .zoom-card { transition: all 0.3s ease; border-left: 5px solid #3e2723 !important; }
        .zoom-card:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
        
        .detail-pane { background: #fdfbf7; border-top: 1px solid #dee2e6; padding: 20px; border-radius: 0 0 15px 15px; }
        .info-label { font-size: 0.8rem; color: #6c757d; text-uppercase: uppercase; letter-spacing: 1px; font-weight: bold; }
        .info-value { font-size: 1rem; color: #212529; font-weight: 500; }

        .btn-zoom { background-color: #3e2723; color: white; border-radius: 20px; padding: 5px 20px; font-weight: bold; }
        .btn-zoom:hover { background-color: #5d4037; color: white; }

        .text-primary, .btn-outline-primary { color: #3e2723 !important; border-color: #3e2723 !important; }
        .bg-primary.bg-opacity-10 { background-color: rgba(62, 39, 35, 0.1) !important; }
        .btn-outline-primary:hover { background-color: #3e2723 !important; color: white !important; }

        .detail-pane a.text-primary { color: #5d4037 !important; }
        .detail-pane a.text-primary:hover { color: #3e2723 !important; text-decoration: underline !important; }

        .info-value.text-danger { 
            color: black !important; 
        }

                .icon-gold {
    color: #D4AF37 !important; 
}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="text-center mb-5 mt-4">
        <h1 class="display-5 font-classic fw-bold" style="color: #3e2723;"><i class="fa-solid fa-book-open me-2 icon-gold"></i> Zoom Live Sessions</h1>
        <p class="text-muted" style="color: #3e2723;">Join our live Classical Chinese interactive classes.</p>
    </div>

    <div class="container" style="max-width: 900px;">
        <asp:Repeater ID="rptZoomSessions" runat="server">
            <ItemTemplate>
                <div class="card mb-3 border-0 shadow-sm rounded-4 overflow-hidden zoom-card">
                    <div class="card-body p-4 d-flex align-items-center justify-content-between">
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center mb-1">
                                <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-3 small">Upcoming</span>
                                <small class="text-muted ms-3"><i class="fa-solid fa-user-tie me-1"></i> <%# Eval("TeacherName") %></small>
                            </div>
                            <h3 class="font-classic fw-bold mt-2 mb-1" style="color: #2C2420;"><%# Eval("Title") %></h3>
                            <p class="text-secondary mb-0 small" style="max-width: 600px;"><%# Eval("Description") %></p>
                        </div>
                        <div class="ms-4">
                            <button type="button" class="btn btn-outline-primary rounded-pill px-4 btn-sm fw-bold shadow-sm" 
                                    data-bs-toggle="collapse" data-bs-target="#details_<%# Eval("ZoomSessionId") %>">
                                View More
                            </button>
                        </div>
                    </div>

                    <div class="collapse" id="details_<%# Eval("ZoomSessionId") %>">
                        <div class="detail-pane">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <div class="info-label">Meeting Link</div>
                                        <a href='<%# Eval("ZoomJoinUrl") %>' target="_blank" class="text-primary fw-bold text-decoration-none">
                                            <i class="fa-solid fa-arrow-up-right-from-square me-1"></i>Click here to join meeting
                                        </a>
                                    </div>
                                    <div class="d-flex gap-4">
                                        <div>
                                            <div class="info-label">Meeting ID</div>
                                            <div class="info-value"><%# Eval("MeetingId") %></div>
                                        </div>
                                        <div>
                                            <div class="info-label">Passcode</div>
                                            <div class="info-value"><%# Eval("Passcode") %></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 border-start ps-md-4">
                                    <div class="mb-3">
                                        <div class="info-label">Start Time</div>
                                        <div class="info-value text-danger">
                                            <i class="fa-regular fa-calendar-days me-1"></i><%# Eval("StartTime", "{0:yyyy-MM-dd HH:mm}") %>
                                        </div>
                                    </div>
                                    <div>
                                        <div class="info-label">Duration</div>
                                        <div class="info-value"><%# Eval("DurationMinutes") %> Minutes</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoSessions" runat="server" Visible="false" CssClass="text-center py-5">
            <i class="fa-solid fa-calendar-xmark fa-3x text-muted opacity-25 mb-3"></i>
            <h5 class="text-muted">No upcoming Zoom sessions at the moment.</h5>
            <p class="small text-muted">Please check back later for new schedules.</p>
        </asp:Panel>
    </div>
</asp:Content>