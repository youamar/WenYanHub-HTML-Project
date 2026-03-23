<%@ Page Title="Content Control" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ContentControl.aspx.cs" Inherits="WenYanHub.Admin.ContentControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ==========================================
           0. ZERO BLUE & FOCUS OVERRIDES
           ========================================== */
        * { -webkit-tap-highlight-color: transparent; }
        .form-control:focus, .form-select:focus, .btn:focus, a:focus { 
            box-shadow: none !important; 
            outline: none !important; 
            border-color: var(--theme-gold) !important; 
        }
        ::selection { background-color: var(--theme-gold) !important; color: var(--bg-white) !important; }

        /* ==========================================
           1. STRICT PALETTE VARIABLES
           ========================================== */
        :root {
            --theme-beige: #E8E2D5;
            --theme-gold: #D4AF37;
            --theme-red: #8B0000;
            --neutral-dark: #212529; /* Strict Black/Grey Neutral */
            --bg-white: #FFFFFF;
            --border-soft: rgba(33, 37, 41, 0.15);
        }

        .text-neutral { color: var(--neutral-dark) !important; }
        .text-gold { color: var(--theme-gold) !important; }
        .text-red { color: var(--theme-red) !important; }

        .font-classic { font-family: 'Noto Serif SC', serif; }
        .font-sans { font-family: 'Segoe UI', Tahoma, sans-serif; }

        .page-canvas { background-color: var(--theme-beige); border-radius: 24px; padding: 35px; margin: 20px; min-height: 75vh; }

        /* ==========================================
           2. CUSTOM TOAST NOTIFICATIONS
           ========================================== */
        .toast-container { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 9999; width: auto; min-width: 300px; pointer-events: none; }
        .custom-toast { 
            background: var(--neutral-dark); 
            padding: 16px 24px; border-radius: 12px; 
            box-shadow: 0 10px 30px rgba(33,37,41,0.3); 
            font-weight: 600; display: flex; align-items: center; justify-content: center; 
            opacity: 0; transform: translateY(-20px); transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); 
            color: var(--bg-white);
        }
        .custom-toast.show { opacity: 1; transform: translateY(0); }
        .toast-success { border-left: 6px solid var(--theme-gold); }
        .toast-success i { color: var(--theme-gold); }
        .toast-danger { background-color: var(--theme-red); border-left: 6px solid #FFF; }

        /* ==========================================
           3. TABS (Tabs Above The Line)
           ========================================== */
        .nav-tabs { border-bottom: 2px solid var(--neutral-dark); gap: 10px; margin-bottom: 0 !important; border-top: none; border-left: none; border-right: none; }
        .nav-tabs .nav-link { 
            color: var(--neutral-dark); opacity: 0.6; 
            font-family: 'Noto Serif SC', serif; font-weight: 700; 
            border: 2px solid transparent; border-bottom: none; padding: 12px 30px; border-radius: 16px 16px 0 0; font-size: 1.1rem; transition: 0.3s; 
            background: transparent; display: flex; align-items: center;
        }
        .nav-tabs .nav-link:hover { opacity: 1; color: var(--theme-gold); background: rgba(212, 175, 55, 0.05); }
        .nav-tabs .nav-link.active { 
            opacity: 1;
            color: var(--bg-white) !important; 
            background: var(--theme-gold) !important; 
            border: 2px solid var(--theme-gold) !important;
            border-bottom: 2px solid var(--theme-gold) !important;
            margin-bottom: -2px; 
        }

        /* Tab Content Box */
        .tab-content-wrapper {
            border: 2px solid var(--neutral-dark);
            border-top: none;
            border-radius: 0 0 20px 20px;
            background-color: var(--bg-white);
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
        }

        /* ==========================================
           4. UNIFORM FILTER BANNER (Descriptions below tabs)
           ========================================== */
        .filter-banner {
            border: 2px solid var(--border-soft);
            border-radius: 12px;
            padding: 1rem 1.5rem;
            background-color: var(--bg-white);
            margin-bottom: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        /* ==========================================
           5. ELEGANT TABLES & BLACK OUTLINES
           ========================================== */
        .control-table-container {
            border: 2px solid var(--neutral-dark) !important;
            border-radius: 16px;
            overflow: hidden;
            background-color: var(--bg-white);
        }
        .control-table th { 
            font-size: 0.8rem; letter-spacing: 1px; color: var(--neutral-dark); opacity: 0.8;
            border-bottom: 2px solid var(--neutral-dark) !important; padding: 1.2rem 1.5rem; background: var(--bg-white); font-weight: 700; text-transform: uppercase;
            font-family: 'Noto Serif SC', serif;
        }
        .control-table td { padding: 1.2rem 1.5rem; vertical-align: middle; border-bottom: 1px solid var(--border-soft); color: var(--neutral-dark); font-weight: 600; }
        .control-table tr:hover { background-color: rgba(33, 37, 41, 0.02); }
        .control-table tr:last-child td { border-bottom: none; }

        .pagination-container {
            border-top: 2px solid var(--neutral-dark) !important;
            background-color: var(--bg-white);
            padding: 1rem 1.5rem;
        }

        /* ==========================================
           6. HOLLOW BUTTONS (Side-by-Side Flex Nowrap)
           ========================================== */
        .btn-outline-dark-custom { 
            border: 2px solid var(--neutral-dark) !important; 
            color: var(--neutral-dark) !important; 
            background-color: transparent !important; 
            font-weight: bold; border-radius: 50px; padding: 6px 16px; transition: 0.3s; white-space: nowrap;
        }
        .btn-outline-dark-custom:hover { border-color: var(--theme-gold) !important; color: var(--theme-gold) !important; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(0,0,0,0.05); }

        .btn-outline-danger-custom { 
            border: 2px solid var(--theme-red) !important; 
            color: var(--theme-red) !important; 
            background-color: transparent !important; 
            font-weight: bold; border-radius: 50px; padding: 6px 16px; transition: 0.3s; white-space: nowrap;
        }
        .btn-outline-danger-custom:hover { background-color: var(--theme-red) !important; color: var(--bg-white) !important; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(139,0,0,0.15); }

        .elegant-select {
            border: 2px solid var(--neutral-dark) !important;
            border-radius: 50px !important;
            padding: 8px 24px;
            background-color: var(--bg-white) !important;
            color: var(--neutral-dark) !important;
            font-weight: 700; font-family: 'Segoe UI', sans-serif;
            transition: 0.2s; cursor: pointer;
        }
        .elegant-select:focus { border-color: var(--theme-gold) !important; outline: none; }

        .badge-outline-dark { background: transparent !important; border: 1px solid var(--neutral-dark); color: var(--neutral-dark) !important; font-weight: bold; }
        .badge-outline-red { background: transparent !important; border: 1px solid var(--theme-red); color: var(--theme-red) !important; font-weight: bold; }
        .badge-outline-gold { background: transparent !important; border: 1px solid var(--theme-gold); color: var(--theme-gold) !important; font-weight: bold; }
        
        .hover-gold:hover { color: var(--theme-gold) !important; text-decoration: underline !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <asp:HiddenField ID="hfActiveTab" runat="server" Value="video" ClientIDMode="Static" />

    <div class="toast-container">
        <div id="toastMessage" class="custom-toast shadow-lg"><i id="toastIcon" class="me-2"></i><span id="toastText"></span></div>
    </div>

    <div class="page-canvas mt-2">
        
        <div class="mb-4">
            <h2 class="fw-bold m-0 font-classic text-neutral" style="font-size: 2.2rem;">
                <i class="bi bi-shield-lock-fill text-gold me-3"></i> Content Control
            </h2>
        </div>

        <ul class="nav nav-tabs" id="controlTabs" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" id="video-tab" data-bs-toggle="tab" data-bs-target="#video" type="button" role="tab" onclick="document.getElementById('hfActiveTab').value = 'video'">
                    <i class="bi bi-play-btn-fill me-2"></i> Video Moderation
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" id="zoom-tab" data-bs-toggle="tab" data-bs-target="#zoom" type="button" role="tab" onclick="document.getElementById('hfActiveTab').value = 'zoom'">
                    <i class="bi bi-camera-video-fill me-2"></i> Zoom Oversight
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" id="comments-tab" data-bs-toggle="tab" data-bs-target="#comments" type="button" role="tab" onclick="document.getElementById('hfActiveTab').value = 'comments'">
                    <i class="bi bi-chat-square-quote-fill me-2"></i> Teacher Comments
                </button>
            </li>
        </ul>

        <div class="tab-content tab-content-wrapper" id="controlTabsContent">
            
            <div class="tab-pane fade show active" id="video" role="tabpanel">
                
                <div class="filter-banner">
                    <div class="d-flex align-items-center text-neutral opacity-75 small fw-bold font-sans">
                        <i class="bi bi-play-circle-fill me-2 text-red fs-5"></i> Manage video submissions and review uploads.
                    </div>
                    <div class="d-flex gap-3">
                        <asp:DropDownList ID="ddlVideoStatus" runat="server" CssClass="form-select elegant-select" AutoPostBack="true" OnSelectedIndexChanged="btnSearchVideos_Click">
                            <asp:ListItem Text="Show Pending Only" Value="Pending" />
                            <asp:ListItem Text="Show Approved Only" Value="Approved" />
                            <asp:ListItem Text="Show Hidden Only" Value="Hidden" />
                            <asp:ListItem Text="Show All Videos" Value="All" />
                        </asp:DropDownList>
                    </div>
                </div>

                <asp:UpdatePanel ID="upVideo" runat="server"><ContentTemplate>
                    <div class="control-table-container">
                        <div class="table-responsive mb-0">
                            <table class="table control-table table-borderless mb-0 w-100 font-sans">
                                <thead><tr><th style="width: 8%;">ID</th><th style="width: 12%;">Date</th><th style="width: 25%;">Lesson Topic</th><th style="width: 20%;">Student</th><th style="width: 10%;">Status</th><th class="text-center" style="width: 25%;">Actions</th></tr></thead>
                                <tbody>
                                    <asp:Repeater ID="rptVideos" runat="server" OnItemCommand="rptVideos_ItemCommand">
                                        <ItemTemplate>
                                            <tr>
                                                <td class="text-neutral opacity-50 small fw-bold">#<%# Eval("RecordId") %></td>
                                                <td class="text-neutral small fw-bold"><%# Eval("CreatedAt", "{0:MMM dd}") %></td>
                                                <td><a href='<%# Eval("RecordLink") %>' target="_blank" class="text-neutral text-decoration-none fw-bold hover-gold"><%# Eval("ContentTitle") %></a></td>
                                                <td class="text-neutral opacity-75 fw-bold"><i class="bi bi-person-circle text-gold me-1"></i> <%# Eval("StudentName") %></td>
                                                <td><span class="badge rounded-pill px-3 py-1 fw-bold <%# Eval("BadgeClass") %> font-classic" style="letter-spacing: 0.5px;"><%# Eval("Status") %></span></td>
                                                
                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center gap-2 flex-nowrap">
                                                        <asp:LinkButton ID="btnApprove" runat="server" CommandName="Approve" CommandArgument='<%# Eval("RecordId") %>' CssClass="btn-outline-dark-custom" Visible='<%# Eval("Status").ToString() != "Approved" %>'><i class="bi bi-check2 me-1"></i> Approve</asp:LinkButton>
                                                        <asp:LinkButton ID="btnReject" runat="server" CommandName="Reject" CommandArgument='<%# Eval("RecordId") %>' CssClass="btn-outline-danger-custom" Visible='<%# Eval("Status").ToString() != "Hidden" %>'><i class="bi bi-eye-slash me-1"></i> Hide</asp:LinkButton>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <asp:PlaceHolder ID="phNoVideos" runat="server" Visible="false">
                                        <tr><td colspan="6" class="text-center py-5 text-neutral opacity-50 font-classic"><i class="bi bi-camera-video-off fs-1 mb-3 text-gold"></i><h5 class="fw-bold">No videos match this filter.</h5></td></tr>
                                    </asp:PlaceHolder>
                                </tbody>
                            </table>
                        </div>
                        <asp:Panel ID="pnlVideoPagination" runat="server" CssClass="d-flex justify-content-between align-items-center pagination-container">
                            <span class="text-neutral small fw-bold font-sans">Page <asp:Literal ID="litVideoPage" runat="server"></asp:Literal> of <asp:Literal ID="litVideoTotal" runat="server"></asp:Literal></span>
                            <div class="d-flex gap-2">
                                <asp:Button ID="btnVideoPrev" runat="server" Text="« Prev" CssClass="btn btn-sm btn-outline-dark-custom" OnClick="btnVideoPrev_Click" />
                                <asp:Button ID="btnVideoNext" runat="server" Text="Next »" CssClass="btn btn-sm btn-outline-dark-custom" OnClick="btnVideoNext_Click" />
                            </div>
                        </asp:Panel>
                    </div>
                </ContentTemplate></asp:UpdatePanel>
            </div>

            <div class="tab-pane fade" id="zoom" role="tabpanel">
                
                <div class="filter-banner">
                    <div class="d-flex align-items-center text-neutral opacity-75 small fw-bold font-sans">
                        <i class="bi bi-camera-video-fill me-2 fs-5"></i> Monitor Active & Scheduled Zoom Sessions.
                    </div>
                </div>

                <asp:UpdatePanel ID="upZoom" runat="server"><ContentTemplate>
                    <div class="control-table-container">
                        <div class="table-responsive mb-0">
                            <table class="table control-table table-borderless mb-0 w-100 font-sans">
                                <thead><tr><th>Scheduled For</th><th>Meeting Topic</th><th>Host</th><th class="text-center">Action</th></tr></thead>
                                <tbody>
                                    <asp:Repeater ID="rptZoom" runat="server" OnItemCommand="rptZoom_ItemCommand">
                                        <ItemTemplate>
                                            <tr>
                                                <td class="text-neutral fw-bold"><i class="bi bi-calendar-event text-gold me-2"></i> <%# Eval("ScheduledDate", "{0:MMM dd, HH:mm}") %></td>
                                                <td class="text-neutral fw-bold"><%# Eval("Title") %></td>
                                                <td class="text-neutral opacity-75 fw-bold"><i class="bi bi-person-circle me-1"></i> <%# Eval("TeacherName") %></td>
                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center gap-2 flex-nowrap">
                                                        <asp:LinkButton ID="btnCancelZoom" runat="server" CommandName="DeleteZoom" CommandArgument='<%# Eval("ZoomSessionId") %>' CssClass="btn-outline-danger-custom" OnClientClick="return confirm('Cancel this Zoom session?');">
                                                            <i class="bi bi-trash3 me-1"></i> Cancel
                                                        </asp:LinkButton>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <asp:PlaceHolder ID="phNoZoom" runat="server" Visible="false">
                                        <tr><td colspan="4" class="text-center py-5 text-neutral opacity-50 font-classic"><i class="bi bi-camera-video-off fs-1 mb-3 text-gold"></i><h5 class="fw-bold">No scheduled sessions found.</h5></td></tr>
                                    </asp:PlaceHolder>
                                </tbody>
                            </table>
                        </div>
                        <asp:Panel ID="pnlZoomPagination" runat="server" CssClass="d-flex justify-content-between align-items-center pagination-container">
                            <span class="text-neutral small fw-bold font-sans">Page <asp:Literal ID="litZoomPage" runat="server"></asp:Literal> of <asp:Literal ID="litZoomTotal" runat="server"></asp:Literal></span>
                            <div class="d-flex gap-2">
                                <asp:Button ID="btnZoomPrev" runat="server" Text="« Prev" CssClass="btn btn-sm btn-outline-dark-custom" OnClick="btnZoomPrev_Click" />
                                <asp:Button ID="btnZoomNext" runat="server" Text="Next »" CssClass="btn btn-sm btn-outline-dark-custom" OnClick="btnZoomNext_Click" />
                            </div>
                        </asp:Panel>
                    </div>
                </ContentTemplate></asp:UpdatePanel>
            </div>

            <div class="tab-pane fade" id="comments" role="tabpanel">
                
                <div class="filter-banner">
                    <div class="d-flex align-items-center text-neutral opacity-75 small fw-bold font-sans">
                        <i class="bi bi-chat-square-quote-fill me-2 text-gold fs-5"></i> Moderate Teacher Feedback.
                    </div>
                    <div class="d-flex gap-3">
                        <asp:DropDownList ID="ddlCommentStatus" runat="server" CssClass="form-select elegant-select" AutoPostBack="true" OnSelectedIndexChanged="btnSearchComments_Click">
                            <asp:ListItem Text="Show Visible Only" Value="Visible" />
                            <asp:ListItem Text="Show Hidden Only" Value="Hidden" />
                            <asp:ListItem Text="Show All Comments" Value="All" />
                        </asp:DropDownList>
                        
                        <asp:DropDownList ID="ddlTeachers" runat="server" CssClass="form-select elegant-select" style="min-width: 250px;"></asp:DropDownList>
                        <asp:Button ID="btnSearchComments" runat="server" Text="Filter" CssClass="btn btn-outline-dark-custom" OnClick="btnSearchComments_Click" />
                    </div>
                </div>

                <asp:UpdatePanel ID="upComments" runat="server"><ContentTemplate>
                    <div class="control-table-container">
                        <div class="table-responsive mb-0">
                            <table class="table control-table table-borderless mb-0 w-100 font-sans">
                                <thead><tr><th style="width: 5%;">SID</th><th style="width: 12%;">Graded At</th><th style="width: 15%;">Teacher</th><th style="width: 25%;">Practice</th><th style="width: 25%;">Comment</th><th class="text-center" style="width: 18%;">Action</th></tr></thead>
                                <tbody>
                                    <asp:Repeater ID="rptComments" runat="server" OnItemCommand="rptComments_ItemCommand">
                                        <ItemTemplate>
                                            <tr>
                                                <td class="text-neutral opacity-50 fw-bold small">#<%# Eval("SubmissionId") %></td>
                                                <td class="text-neutral small fw-bold"><%# Eval("GradedAt", "{0:MMM dd}") %></td>
                                                <td class="text-neutral fw-bold"><i class="bi bi-person-badge text-gold me-1"></i> <%# Eval("TeacherName") %></td>
                                                <td class="text-neutral fw-bold"><%# Eval("PracticeTitle") %></td>
                                                <td class="text-neutral opacity-75 fst-italic">"<%# Eval("CommentText") %>"</td>
                                                
                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center gap-2 flex-nowrap">
                                                        <asp:LinkButton ID="btnHide" runat="server" CommandName="DeleteComment" CommandArgument='<%# Eval("SubmissionId") %>' 
                                                            CssClass="btn-outline-danger-custom btn-sm" 
                                                            OnClientClick="return confirm('Hide this comment?');"
                                                            Visible='<%# !(bool)Eval("IsFeedbackHidden") %>'>
                                                            <i class='bi bi-eye-slash me-1'></i> Hide
                                                        </asp:LinkButton>

                                                        <asp:LinkButton ID="btnUnhide" runat="server" CommandName="UnhideComment" CommandArgument='<%# Eval("SubmissionId") %>' 
                                                            CssClass="btn-outline-dark-custom btn-sm" 
                                                            OnClientClick="return confirm('Restore this comment?');"
                                                            Visible='<%# (bool)Eval("IsFeedbackHidden") %>'>
                                                            <i class='bi bi-arrow-counterclockwise me-1'></i> Restore
                                                        </asp:LinkButton>

                                                        <asp:LinkButton ID="btnPermDelete" runat="server" CommandName="PermDelete" CommandArgument='<%# Eval("SubmissionId") %>' 
                                                            CssClass="btn-outline-danger-custom btn-sm" 
                                                            OnClientClick="return confirm('PERMANENTLY DELETE this comment? This cannot be undone!');"
                                                            Visible='<%# (bool)Eval("IsFeedbackHidden") %>'>
                                                            <i class='bi bi-trash3 me-1'></i> Delete
                                                        </asp:LinkButton>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <asp:PlaceHolder ID="phNoComments" runat="server" Visible="false">
                                        <tr><td colspan="6" class="text-center py-5 text-neutral opacity-50 font-classic"><i class="bi bi-chat-square-quote fs-1 mb-3 text-gold"></i><h5 class="fw-bold">No comments match this filter.</h5></td></tr>
                                    </asp:PlaceHolder>
                                </tbody>
                            </table>
                        </div>
                        <asp:Panel ID="pnlCommentPagination" runat="server" CssClass="d-flex justify-content-between align-items-center pagination-container">
                            <span class="text-neutral small fw-bold font-sans">Page <asp:Literal ID="litCommentPage" runat="server"></asp:Literal> of <asp:Literal ID="litCommentTotal" runat="server"></asp:Literal></span>
                            <div class="d-flex gap-2">
                                <asp:Button ID="btnCommentPrev" runat="server" Text="« Prev" CssClass="btn btn-sm btn-outline-dark-custom" OnClick="btnCommentPrev_Click" />
                                <asp:Button ID="btnCommentNext" runat="server" Text="Next »" CssClass="btn btn-sm btn-outline-dark-custom" OnClick="btnCommentNext_Click" />
                            </div>
                        </asp:Panel>
                    </div>
                </ContentTemplate></asp:UpdatePanel>
            </div>

        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var activeTab = document.getElementById('hfActiveTab').value;
            if (activeTab) {
                var triggerEl = document.querySelector('button[data-bs-target="#' + activeTab + '"]');
                if (triggerEl) { new bootstrap.Tab(triggerEl).show(); }
            }
        });

        function showToast(message, type) {
            const toast = document.getElementById('toastMessage');
            const icon = document.getElementById('toastIcon');
            const text = document.getElementById('toastText');
            toast.className = 'custom-toast shadow-lg show ' + (type === 'success' ? 'toast-success' : 'toast-danger');
            icon.className = type === 'success' ? 'bi bi-check-circle-fill' : 'bi bi-exclamation-triangle-fill';
            text.innerText = message;
            setTimeout(() => { toast.classList.remove('show'); }, 4000);
        }
    </script>
</asp:Content>