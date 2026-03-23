<%@ Page Title="Manage Tickets" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewTickets.aspx.cs" Inherits="WenYanHub.Admin.ViewTickets" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ==========================================
           0. ZERO BLUE & FOCUS OVERRIDES
           ========================================== */
        * { -webkit-tap-highlight-color: transparent; }
        .form-control:focus, .btn:focus, a:focus { 
            box-shadow: none !important; 
            outline: none !important; 
            border-color: var(--theme-gold) !important; 
        }
        ::selection { background-color: var(--theme-gold) !important; color: var(--theme-primary) !important; }

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

        /* PAGE CANVAS */
        .page-canvas { background-color: var(--theme-beige); border-radius: 24px; padding: 35px; margin: 20px; min-height: 75vh; }

        /* ==========================================
           2. TABLE & CONTAINER (Strong Black Outline)
           ========================================== */
        .ticket-table-container {
            border: 2px solid var(--neutral-dark) !important; /* 🔥 Strong Black Outline 🔥 */
            border-radius: 16px;
            overflow: hidden;
            background-color: var(--bg-white);
            box-shadow: 0 4px 20px rgba(0,0,0,0.02);
        }
        .ticket-header-row {
            background-color: var(--bg-white);
            border-bottom: 2px solid var(--neutral-dark) !important;
        }
        .ticket-row { 
            cursor: pointer; 
            transition: all 0.2s ease; 
            border-bottom: 1px solid var(--border-soft);
            background-color: var(--bg-white); 
            border-left: 6px solid transparent; 
        }
        .ticket-row:last-child { border-bottom: none; }
        .ticket-row:hover { background-color: rgba(212, 175, 55, 0.03) !important; }
        
        /* Urgent indicator */
        .is-urgent { border-left-color: var(--theme-red) !important; }

        /* ==========================================
           3. STATUS BADGES (Hollow Outlines Only)
           ========================================== */
        .badge-outline { 
            border-radius: 50px; 
            padding: 6px 15px; 
            font-family: 'Segoe UI', sans-serif; 
            font-weight: 700; 
            letter-spacing: 0.5px; 
            width: 110px; 
            text-align: center;
            display: inline-block;
            background-color: transparent;
        }
        
        .badge-outline-dark { border: 2px solid var(--neutral-dark); color: var(--neutral-dark); }
        .badge-outline-gold { border: 2px solid var(--theme-gold); color: var(--theme-gold); }
        .badge-outline-red { border: 2px solid var(--theme-red); color: var(--theme-red); }

        /* ==========================================
           4. NAVIGATION TABS (Hollow Outlines)
           ========================================== */
        .custom-pill { 
            transition: 0.3s; padding: 10px 24px; border-radius: 12px; text-decoration: none; 
            border: 2px solid var(--border-soft); display: flex; align-items: center; gap: 12px;
            background-color: var(--bg-white); color: var(--neutral-dark); 
        }
        .custom-pill:hover { border-color: var(--theme-gold); background-color: rgba(212, 175, 55, 0.02); }
        
        .pill-gold.active { border-color: var(--theme-gold) !important; color: var(--theme-gold) !important; box-shadow: 0 4px 12px rgba(212, 175, 55, 0.15); }
        .pill-gold.active .pill-desc { color: rgba(212, 175, 55, 0.8) !important; }
        
        .pill-dark.active { border-color: var(--neutral-dark) !important; color: var(--neutral-dark) !important; box-shadow: 0 4px 12px rgba(33, 37, 41, 0.1); }
        .pill-dark.active .pill-desc { color: rgba(33, 37, 41, 0.6) !important; }
        
        .pill-red.active { border-color: var(--theme-red) !important; color: var(--theme-red) !important; box-shadow: 0 4px 12px rgba(139, 0, 0, 0.1); }
        .pill-red.active .pill-desc { color: rgba(139, 0, 0, 0.6) !important; }

        .pill-desc { font-size: 0.75rem; font-weight: normal; color: var(--neutral-dark); opacity: 0.6; font-family: 'Segoe UI', sans-serif; }

        /* ==========================================
           5. ACTION BUTTONS (Outline)
           ========================================== */
        .action-pill { border-radius: 50px !important; padding: 8px 15px !important; font-weight: 700; box-shadow: 0 4px 10px rgba(0,0,0,0.05); transition: 0.2s; letter-spacing: 0.5px; font-size: 0.9rem; }
        
        .btn-outline-dark-custom { border: 2px solid var(--neutral-dark) !important; color: var(--neutral-dark) !important; background-color: transparent !important; }
        .btn-outline-dark-custom:hover { border-color: var(--theme-gold) !important; color: var(--theme-gold) !important; transform: translateY(-2px); }

        .btn-outline-danger-custom { border: 2px solid var(--theme-red) !important; color: var(--theme-red) !important; background-color: transparent !important; }
        .btn-outline-danger-custom:hover { background-color: var(--theme-red) !important; color: white !important; transform: translateY(-2px); }

        /* Scrollbar */
        .custom-scroll::-webkit-scrollbar { width: 6px; }
        .custom-scroll::-webkit-scrollbar-thumb { background: rgba(33,37,41,0.2); border-radius: 10px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfSelectedTicket" runat="server" ClientIDMode="Static" />

    <div class="page-canvas mt-2">
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
            <h3 class="fw-bold m-0 text-neutral font-classic"><i class="bi bi-ticket-perforated text-gold me-2"></i> User Support Tickets</h3>
            
            <div class="d-flex gap-3 align-items-center flex-wrap">
                <div class="d-flex gap-3 small border rounded-pill px-3 py-1 bg-white shadow-sm" style="border-color: var(--border-soft) !important;">
                    <span class="fw-bold text-red"><i class="bi bi-circle-fill me-1"></i>Over 2 Days</span>
                    <span class="fw-bold text-gold"><i class="bi bi-circle-fill me-1"></i>New</span>
                </div>
                
                <div class="input-group shadow-sm bg-white" style="width: 300px; border: 2px solid var(--neutral-dark); border-radius: 50px; overflow: hidden; padding: 2px;">
                    <span class="input-group-text bg-white border-0 ps-3 pe-2"><i class="bi bi-search text-neutral opacity-50"></i></span>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-0 py-2 text-neutral fw-bold font-sans shadow-none" placeholder="Search ID or Email..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                </div>
            </div>
        </div>

        <div class="d-flex flex-wrap gap-3 mb-5">
            <a href="ViewTickets.aspx?view=pending" class='custom-pill pill-gold <%= Request.QueryString["view"] == null || Request.QueryString["view"] == "pending" ? "active" : "" %>'>
                <i class="bi bi-clock-history fs-4"></i>
                <div>
                    <div class="fw-bold font-classic" style="line-height: 1;">Pending</div>
                    <div class="pill-desc mt-1">Awaiting Action</div>
                </div>
            </a>
            <a href="ViewTickets.aspx?view=solved" class='custom-pill pill-dark <%= Request.QueryString["view"] == "solved" ? "active" : "" %>'>
                <i class="bi bi-check-circle fs-4"></i>
                <div>
                    <div class="fw-bold font-classic" style="line-height: 1;">Solved</div>
                    <div class="pill-desc mt-1">Resolved Issues</div>
                </div>
            </a>
            <a href="ViewTickets.aspx?view=rejected" class='custom-pill pill-red <%= Request.QueryString["view"] == "rejected" ? "active" : "" %>'>
                <i class="bi bi-x-circle fs-4"></i>
                <div>
                    <div class="fw-bold font-classic" style="line-height: 1;">Rejected</div>
                    <div class="pill-desc mt-1">Dismissed Items</div>
                </div>
            </a>
        </div>

        <div class="ticket-table-container">
            
            <div class="row px-3 py-3 ticket-header-row text-neutral fw-bold small text-uppercase font-sans m-0">
                <div class="col-2">ID</div>
                <div class="col-3">Reporter</div>
                <div class="col-1">Type</div>
                <div class="col-2">Message Snippet</div>
                <div class="col-2">Submitted Date</div>
                <div class="col-2 text-center">Status</div>
            </div>

            <div class="custom-scroll" style="max-height: 55vh; overflow-y: auto;">
                <asp:Repeater ID="rptTickets" runat="server">
                    <ItemTemplate>
                        <div class="row align-items-center px-3 py-3 m-0 ticket-row <%# Eval("UrgencyClass") %>" onclick="openTicketModal(this)">
                            <input type="hidden" class="tk-code" value='<%# Eval("TrackingCode") %>' />
                            <input type="hidden" class="tk-email" value='<%# Eval("ContactEmail") %>' />
                            <input type="hidden" class="tk-date" value='<%# Eval("DateString") %>' />
                            <input type="hidden" class="tk-status" value='<%# Eval("Status") %>' />
                            
                            <div class="tk-message d-none"><%# HttpUtility.HtmlEncode(Eval("Message")) %></div>
                            <input type="hidden" class="tk-reply" value='<%# HttpUtility.HtmlEncode(Eval("AdminReply")) %>' />

                            <div class="col-2 fw-bold text-neutral font-monospace small">#<%# Eval("TrackingCode") %></div>
                            <div class="col-3 text-truncate small fw-bold text-neutral"><i class="bi bi-person-circle text-gold me-1"></i> <%# Eval("ContactEmail") %></div>
                            
                            <div class="col-1 fw-bold text-neutral opacity-75" style="font-family: 'Noto Serif SC', serif;"><%# Eval("Category") %></div>
                            
                            <div class="col-2 fw-bold text-neutral small text-truncate font-sans"><%# Eval("MessageSnippet") %></div>
                            
                            <div class="col-2 text-neutral opacity-50 small fw-bold font-sans"><%# Eval("DateString") %></div>
                            
                            <div class="col-2 d-flex justify-content-center align-items-center">
                                <span class='<%# Eval("StatusBadgeClass") %> shadow-sm'>
                                    <%# Eval("Status") %>
                                </span>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:PlaceHolder ID="phNoTickets" runat="server" Visible="false">
                    <div class="text-center text-neutral opacity-50 py-5 font-classic bg-white border-bottom">
                        <i class="bi bi-inbox fs-1 d-block mb-2 text-gold"></i> 
                        <h5 class="fw-bold">No tickets found.</h5>
                    </div>
                </asp:PlaceHolder>
            </div>
            
            <div class="d-flex justify-content-between align-items-center p-4 border-top bg-white" style="border-color: var(--neutral-dark) !important;">
                <div>
                    <div class="text-neutral small fw-bold font-sans">
                        Showing Page <asp:Literal ID="litCurrentPage" runat="server"></asp:Literal> of <asp:Literal ID="litTotalPages" runat="server"></asp:Literal>
                    </div>
                    <div class="text-neutral opacity-50" style="font-size: 0.75rem;">
                        (Total <asp:Literal ID="litTotalRecords" runat="server"></asp:Literal> tickets)
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <asp:LinkButton ID="btnPrevPage" runat="server" CssClass="btn btn-sm fw-bold px-3 btn-outline-dark-custom font-classic" OnClick="btnPrevPage_Click"><i class="bi bi-chevron-left"></i> Prev</asp:LinkButton>
                    <asp:LinkButton ID="btnNextPage" runat="server" CssClass="btn btn-sm fw-bold px-3 btn-outline-dark-custom font-classic" OnClick="btnNextPage_Click">Next <i class="bi bi-chevron-right"></i></asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ticketModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content rounded-4 shadow-lg p-2 bg-white" style="border: 2px solid var(--neutral-dark);">
                <div class="modal-header border-bottom-0 pb-0">
                    <h4 class="fw-bold mb-0 text-neutral font-classic"><i class="bi bi-ticket-detailed text-gold me-2"></i> Ticket Details</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body pt-3">
                    <div class="mb-4 p-4 rounded-4 shadow-sm bg-white" style="border: 2px dashed rgba(33,37,41,0.2);">
                        <div class="row">
                            <div class="col-6"><div class="text-neutral opacity-50 small fw-bold text-uppercase">Reporter</div><div id="modalEmail" class="text-neutral fw-bold fs-5"></div></div>
                            <div class="col-6"><div class="text-neutral opacity-50 small fw-bold text-uppercase">Submitted On</div><div id="modalDate" class="text-neutral fw-bold fs-5"></div></div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <div class="text-neutral opacity-50 small text-uppercase fw-bold mb-2"><i class="bi bi-chat-left-text me-1"></i> Message Content</div>
                        <div class="p-4 rounded-4 shadow-sm bg-white" style="border: 2px solid var(--neutral-dark); min-height: 120px;">
                            <p id="modalMessage" class="m-0 text-neutral font-classic opacity-75" style="white-space: pre-wrap; line-height: 1.6; font-size: 1.05rem;"></p>
                        </div>
                    </div>

                    <div class="mb-2">
                        <div class="text-neutral opacity-50 small text-uppercase fw-bold mb-2"><i class="bi bi-reply-all-fill me-1"></i> Admin Resolution Note</div>
                        
                        <div id="replyInputWrapper">
                            <asp:TextBox ID="txtAdminReply" runat="server" ClientIDMode="Static" TextMode="MultiLine" Rows="3" CssClass="form-control bg-white font-classic p-3" style="border: 2px solid var(--neutral-dark); border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.02);" placeholder="Write your resolution note here. You can save it as a draft before closing..."></asp:TextBox>
                        </div>

                        <div id="replyDisplayWrapper" class="p-4 rounded-4 shadow-sm bg-white d-none" style="border: 2px solid var(--theme-gold); min-height: 100px;">
                            <p id="modalAdminReplyDisplay" class="m-0 text-neutral font-classic" style="white-space: pre-wrap; line-height: 1.6; font-size: 1.05rem;"></p>
                        </div>
                    </div>

                </div>
                <div class="modal-footer border-top-0 pt-0" id="modalActionGroup">
                    <div class="d-flex gap-2 w-100 mt-2">
                        <asp:LinkButton ID="btnSaveNote" runat="server" OnClick="btnSaveNote_Click" CssClass="btn action-pill btn-outline-dark-custom font-classic flex-grow-1"><i class="bi bi-save me-1"></i> Save Note Only</asp:LinkButton>
                        <asp:LinkButton ID="btnMarkSolved" runat="server" OnClick="btnMarkSolved_Click" CssClass="btn action-pill btn-outline-dark-custom font-classic flex-grow-1"><i class="bi bi-check-circle me-1 text-gold"></i> Mark Solved</asp:LinkButton>
                        <asp:LinkButton ID="btnReject" runat="server" OnClick="btnReject_Click" CssClass="btn action-pill btn-outline-danger-custom font-classic flex-grow-1"><i class="bi bi-x-circle me-1"></i> Reject</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Utility function to decode HTML entities
        function decodeHtml(html) {
            var txt = document.createElement("textarea");
            txt.innerHTML = html;
            return txt.value;
        }

        function openTicketModal(rowElement) {
            document.getElementById('modalEmail').innerText = rowElement.querySelector('.tk-email').value;
            document.getElementById('modalDate').innerText = rowElement.querySelector('.tk-date').value;

            // Safely grab the encoded HTML and decode it for display
            const rawMessage = rowElement.querySelector('.tk-message').innerHTML;
            document.getElementById('modalMessage').innerText = decodeHtml(rawMessage);

            document.getElementById('hfSelectedTicket').value = rowElement.querySelector('.tk-code').value;

            const status = rowElement.querySelector('.tk-status').value.toLowerCase();

            // Safely grab the encoded reply from the hidden input
            const encodedReply = rowElement.querySelector('.tk-reply').value;
            const reply = decodeHtml(encodedReply).trim();

            if (status === 'solved' || status === 'rejected') {
                // Hide input elements and action buttons for closed tickets
                document.getElementById('modalActionGroup').classList.add('d-none');
                document.getElementById('replyInputWrapper').classList.add('d-none');

                // Show the display box
                document.getElementById('replyDisplayWrapper').classList.remove('d-none');
                document.getElementById('modalAdminReplyDisplay').innerText = reply || "No resolution note provided.";
            } else {
                // Restore inputs and action buttons for pending tickets
                document.getElementById('modalActionGroup').classList.remove('d-none');
                document.getElementById('replyInputWrapper').classList.remove('d-none');
                document.getElementById('replyDisplayWrapper').classList.add('d-none');

                // Load any existing draft note into the textbox so the admin can modify it!
                document.getElementById('txtAdminReply').value = reply;
            }

            var myModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('ticketModal'));
            myModal.show();
        }
    </script>
</asp:Content>