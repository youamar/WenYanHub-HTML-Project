<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="WenYanHub.Admin.AdminDashboard" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;700&display=swap" rel="stylesheet" />

    <style>
        /* 🔥 FIX: Restored Beige Fill to Dashboard Canvas */
        .dashboard-canvas {
            background-color: var(--theme-secondary) !important; 
            border-radius: 24px;
            padding: 35px;
            min-height: calc(100vh - 120px);
        }

        .dash-card { 
            background: var(--bg-white) !important; 
            border-radius: 20px; 
            padding: 28px; 
            border: 1px solid rgba(44, 36, 32, 0.1); 
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1); 
            cursor: pointer; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
        }
        .dash-card:hover { 
            transform: translateY(-6px); 
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.08), 0 5px 15px rgba(0, 0, 0, 0.03) !important; 
            border-color: var(--theme-accent); 
        }
        .dash-icon { font-size: 2.5rem; color: var(--theme-primary); opacity: 0.15; transition: 0.3s; }
        .dash-card:hover .dash-icon { opacity: 0.6; transform: scale(1.1); color: var(--theme-accent) !important; }
        
        .dot { height: 10px; width: 10px; border-radius: 50%; display: inline-block; margin-right: 8px; animation: blink 2s infinite; }
        @keyframes blink { 0% { opacity: 1; } 50% { opacity: 0.2; } 100% { opacity: 1; } }
        
        .task-item { transition: 0.2s; cursor: pointer; border: 1px solid rgba(44, 36, 32, 0.1); }
        .task-item:hover { background-color: #f8f9fa !important; transform: scale(1.02); border-color: var(--theme-accent) !important; }
        
        .pulse-item { transition: 0.2s; cursor: pointer; }
        .pulse-item:hover { background-color: #f8f9fa; padding-left: 10px !important; border-radius: 8px; border-color: transparent !important; }
        .last-border-0:last-child { border-bottom: none !important; }
        
        .custom-scroll::-webkit-scrollbar { width: 5px; }
        .custom-scroll::-webkit-scrollbar-thumb { background: rgba(44, 36, 32, 0.2); border-radius: 10px; }
        
        /* 🔥 FIX: "Review Full Queue" is now a hollow outline! No dark fills! */
        .btn-outline-hollow { 
            background-color: transparent !important; 
            color: var(--theme-primary) !important; 
            border: 2px solid var(--theme-primary) !important;
            transition: 0.3s; 
        }
        .btn-outline-hollow:hover { 
            border-color: var(--theme-accent) !important;
            color: var(--theme-accent) !important;
            transform: translateY(-2px); 
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05); 
        }

        /* 🔥 FIX: Ticket Badges are strictly Hollow Outlines */
        .badge-outline-red { border: 1px solid var(--semantic-danger); color: var(--semantic-danger); background: transparent; font-weight: bold; }
        .badge-outline-gold { border: 1px solid var(--theme-accent); color: var(--theme-accent); background: transparent; font-weight: bold; }
        .badge-outline-dark { border: 1px solid var(--theme-primary); color: var(--theme-primary); background: transparent; font-weight: bold; }

    </style>

    <div class="dashboard-canvas container-fluid w-100 mt-2">
        
        <div class="d-flex justify-content-between align-items-end mb-4 border-bottom pb-4" style="border-color: rgba(44, 36, 32, 0.1) !important;">
            <div>
                <h2 class="font-classic fw-bold mb-1 text-theme-primary" style="letter-spacing: 1px;">
                    <i class="fa-solid fa-scroll text-theme-accent me-2"></i> System Insights
                </h2>
                <p class="mb-0 fw-bold font-sans text-theme-primary opacity-75">Overview of platform statistics and moderation actions.</p>
            </div>
            
            <div class="d-flex gap-4 align-items-center bg-white px-4 py-2 rounded-pill shadow-sm" style="border: 2px solid var(--theme-primary) !important;">
                <div class="text-end border-end pe-4" style="border-color: rgba(44, 36, 32, 0.2) !important;">
                    <div class="text-theme-primary opacity-75 small fw-bold text-uppercase font-sans" style="letter-spacing: 1px;">System Status</div>
                    <div class="live-indicator small fw-bold font-sans text-semantic-danger">
                        <span class="dot" style="background-color: var(--semantic-danger);"></span> LIVE MONITORING
                    </div>
                </div>
                <div class="text-start font-classic">
                    <div class="text-theme-primary opacity-75 small fw-bold text-uppercase font-sans" style="letter-spacing: 1px;">Server Date</div>
                    <div class="fw-bold text-theme-primary fs-6"><%= DateTime.Now.ToString("MMM dd, yyyy") %></div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-4">
                <div class="d-flex flex-column gap-4">
                    <div class="dash-card" onclick="location.href='ManageUsers.aspx'" style="border-bottom: 4px solid var(--theme-accent) !important;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p class="text-theme-primary opacity-75 small fw-bold text-uppercase font-sans mb-1" style="letter-spacing: 1px;">Total User Database</p>
                                <h1 class="display-4 font-classic fw-bold mb-0 text-theme-primary"><asp:Literal ID="litUsers" runat="server">0</asp:Literal></h1>
                            </div>
                            <div class="dash-icon"><i class="bi bi-people-fill"></i></div>
                        </div>
                        <div class="mt-3 fw-bold font-sans small border-top pt-3 text-theme-primary opacity-75" style="border-color: rgba(44, 36, 32, 0.1) !important;">
                            Total registered accounts including Admins, Teachers, and Members.
                        </div>
                    </div>

                    <div class="dash-card" onclick="location.href='ManageContent.aspx?view=pending'" style="border-bottom: 4px solid var(--semantic-danger) !important;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p class="text-theme-primary opacity-75 small fw-bold text-uppercase font-sans mb-1" style="letter-spacing: 1px;">Total Pending Queue</p>
                                <h1 class="display-4 font-classic fw-bold mb-0 text-semantic-danger"><asp:Literal ID="litPending" runat="server">0</asp:Literal></h1>
                            </div>
                            <div class="dash-icon text-semantic-danger opacity-50"><i class="bi bi-file-earmark-medical-fill"></i></div>
                        </div>
                        <div class="mt-3 small fw-bold font-sans border-top pt-3 text-theme-primary opacity-75" style="border-color: rgba(44, 36, 32, 0.1) !important;">
                            Lessons currently awaiting review.
                            <div class="mt-2"><asp:Literal ID="litOverdueContent" runat="server"></asp:Literal></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="dash-card h-100 d-flex flex-column" style="max-height: 520px; border-bottom: 4px solid var(--theme-primary);">
                    <div class="pb-3 mb-3 border-bottom" style="border-color: rgba(44, 36, 32, 0.1) !important;">
                        <h6 class="font-classic fw-bold text-uppercase small text-theme-primary mb-1" style="letter-spacing: 1px;">
                            <i class="bi bi-shield-lock-fill me-2 text-semantic-danger"></i>Urgent Pending Approvals
                        </h6>
                        <div class="fw-bold font-sans text-theme-primary opacity-75" style="font-size: 0.75rem;">Oldest submissions (Pending > 3 days) capped at 5 records.</div>
                    </div>
                    
                    <div class="flex-grow-1 custom-scroll px-1" style="overflow-y: auto;">
                        <asp:Repeater ID="rptUrgentContent" runat="server">
                            <ItemTemplate>
                                <div class="task-item border-start border-4 rounded-3 p-3 mb-3 bg-white" onclick="location.href='ManageContent.aspx?view=pending'" style="border-left-color: var(--semantic-danger) !important;">
                                    <div class="font-classic fw-bold text-theme-primary text-truncate mb-1 fs-6"><%# Eval("Title") %></div>
                                    <div class="text-theme-primary opacity-75 small fw-bold font-sans">
                                        Submitted by <span class="text-theme-accent"><%# Eval("AuthorName") %></span> • <%# Eval("DaysOld") %> days ago
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:PlaceHolder ID="phNoPending" runat="server" Visible="false">
                            <div class="text-center py-5">
                                <i class="bi bi-check-circle fs-1 text-theme-primary opacity-25"></i>
                                <div class="text-theme-primary opacity-75 small mt-2 font-classic fw-bold">Queue is crystal clear.</div>
                            </div>
                        </asp:PlaceHolder>
                    </div>
                    <div class="pt-3">
                        <button type="button" onclick="location.href='ManageContent.aspx'" class="btn w-100 rounded-pill py-2 fw-bold font-classic btn-outline-hollow" style="letter-spacing: 1px;">Review Full Queue</button>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="dash-card h-100 d-flex flex-column" style="max-height: 520px; border-bottom: 4px solid var(--theme-primary);">
                    <div class="pb-3 mb-3 border-bottom" style="border-color: rgba(44, 36, 32, 0.1) !important;">
                        <h6 class="font-classic fw-bold text-uppercase small text-theme-primary mb-1" style="letter-spacing: 1px;">
                            <i class="bi bi-lightning-charge-fill text-theme-accent me-2"></i>Recent Ticket Activity
                        </h6>
                        <div class="fw-bold font-sans text-theme-primary opacity-75" style="font-size: 0.75rem;">Latest support tickets and bug reports capped at 5 records.</div>
                    </div>

                    <div class="flex-grow-1 custom-scroll px-1" style="overflow-y: auto;">
                        <asp:Repeater ID="rptRecentTickets" runat="server">
                            <ItemTemplate>
                                <div class="pulse-item mb-3 p-2 rounded-3 border-bottom last-border-0" onclick="location.href='ViewTickets.aspx'" style="border-color: rgba(44, 36, 32, 0.1) !important;">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class='badge <%# Eval("CategoryClass") %> rounded-pill font-sans' style="font-size: 0.65rem; letter-spacing: 0.5px; padding: 4px 8px;"><%# Eval("Category") %></span>
                                        <span class="text-theme-primary opacity-75 fw-bold small font-sans" style="font-size: 0.65rem;"><%# Eval("TimeAgo") %></span>
                                    </div>
                                    <div class="small text-theme-primary text-truncate font-classic fw-bold" style="font-size: 0.95rem;"><%# Eval("MessageSnippet") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:PlaceHolder ID="phNoTickets" runat="server" Visible="false">
                            <div class="text-center py-5 text-theme-primary opacity-50 small font-classic fw-bold">No new reports.</div>
                        </asp:PlaceHolder>
                    </div>
                    
                    <div class="rounded-4 p-3 mt-3" style="background-color: transparent; border: 1px dashed rgba(44, 36, 32, 0.2);">
                        <div class="d-flex align-items-center gap-3">
                            <div class="fs-4 text-theme-accent"><i class="fa-solid fa-hourglass-end"></i></div>
                            <div class="small fw-bold font-sans text-theme-primary" style="line-height: 1.3;">Tickets older than 30 days are automatically purged.</div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>