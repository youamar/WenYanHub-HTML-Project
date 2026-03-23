<%@ Page Title="Edit Content" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ContentEditor.aspx.cs" Inherits="WenYanHub.Admin.ContentEditor" ValidateRequest="false" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style>
        :root {
            --theme-beige: #E8E2D5;
            --theme-gold: #D4AF37;
            --theme-red: #8B0000;
            --neutral-dark: #212529; 
            --bg-white: #FFFFFF;
            --border-color: rgba(33, 37, 41, 0.15);
        }
        
        .text-neutral { color: var(--neutral-dark) !important; }
        .text-gold { color: var(--theme-gold) !important; }
        .text-red { color: var(--theme-red) !important; }

        .page-canvas { background-color: var(--theme-beige); border-radius: 24px; padding: 30px; margin: 20px; min-height: 75vh; }
        
        /* HOLLOW BUTTONS */
        .btn-outline-dark-custom { background: transparent !important; color: var(--neutral-dark) !important; border: 2px solid var(--neutral-dark) !important; transition: 0.3s; font-weight: bold; }
        .btn-outline-dark-custom:hover { border-color: var(--theme-gold) !important; color: var(--theme-gold) !important; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .btn-outline-danger-custom { background: transparent !important; color: var(--theme-red) !important; border: 2px solid var(--theme-red) !important; transition: 0.3s; font-weight: bold; }
        .btn-outline-danger-custom:hover { background: var(--theme-red) !important; color: var(--bg-white) !important; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(139,0,0,0.15); }

        .badge-outline-gold { border: 1px solid var(--theme-gold); color: var(--theme-gold); background: transparent; font-weight: bold; }
        .badge-outline-dark { border: 1px solid var(--neutral-dark); color: var(--neutral-dark); background: transparent; font-weight: bold; }

        .inline-edit-dark { border: 2px dashed rgba(255,255,255,0.2); border-radius: 8px; padding: 5px; transition: all 0.3s; cursor: text; }
        .inline-edit-dark:hover { border-color: var(--theme-gold); background-color: rgba(255,255,255,0.05); }
        .inline-edit-dark:focus { border-color: var(--theme-gold); background-color: rgba(0,0,0,0.5); outline: none; }

        .inline-edit-light { border: 2px dashed var(--border-color); border-radius: 8px; padding: 10px; transition: all 0.3s; cursor: text; }
        .inline-edit-light:hover { border-color: var(--theme-gold); background-color: rgba(212, 175, 55, 0.02); }
        .inline-edit-light:focus { border-color: var(--theme-gold); background-color: #fff; outline: none; }

        .author-link { transition: all 0.2s; border-bottom: 1px dashed transparent; }
        .author-link:hover { color: var(--theme-gold) !important; border-bottom: 1px dashed var(--theme-gold); }
        .content-indented { text-indent: 2em; text-align: justify; }

        .custom-scroll::-webkit-scrollbar { width: 6px; }
        .custom-scroll::-webkit-scrollbar-thumb { background: rgba(33, 37, 41, 0.2); border-radius: 10px; }
    </style>

    <asp:HiddenField ID="hfTitle" runat="server" />
    <asp:HiddenField ID="hfContentText" runat="server" />
    <asp:HiddenField ID="hfAnalysis" runat="server" />
    <asp:HiddenField ID="hfSecondaryText" runat="server" />

    <div class="page-canvas mt-2">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <a href="ManageContent.aspx" class="btn btn-outline-dark-custom rounded-pill">
                <i class="fa-solid fa-arrow-left me-2"></i> Back to Library
            </a>
            
            <div class="d-flex gap-3 align-items-center">
                <asp:PlaceHolder ID="phPendingActions" runat="server" Visible="false">
                    <div class="badge-outline-gold px-3 py-2 rounded-pill small me-2">
                        <i class="bi bi-hourglass-split me-1"></i> Needs Approval
                    </div>
                    <asp:Button ID="btnApproveLesson" runat="server" Text="✓ Approve Lesson" CssClass="btn btn-outline-dark-custom rounded-pill px-4" style="border-color: #2E7D32 !important; color: #2E7D32 !important;" OnClick="btnApproveLesson_Click" />
                    <asp:Button ID="btnRejectLesson" runat="server" Text="✗ Reject" CssClass="btn btn-outline-danger-custom rounded-pill px-4" OnClick="btnRejectLesson_Click" OnClientClick="return confirm('Are you sure you want to completely reject this lesson submission?');" />
                    <div class="border-end mx-1" style="height: 30px; border-color: var(--border-color) !important;"></div>
                </asp:PlaceHolder>

                <asp:Button ID="btnSaveAll" runat="server" Text="💾 Save All Changes" CssClass="btn btn-outline-dark-custom btn-lg rounded-pill px-5" OnClientClick="return captureInlineEdits();" OnClick="btnSaveAll_Click" />
            </div>
        </div>

        <div class="bg-white border rounded-4 d-flex align-items-center p-3 mb-4 shadow-sm" style="border-color: var(--border-color) !important;">
            <div class="rounded-circle d-flex justify-content-center align-items-center me-3 flex-shrink-0" style="width: 42px; height: 42px; border: 2px solid var(--theme-gold);">
                <i class="fa-solid fa-wand-magic-sparkles fs-6 text-gold"></i>
            </div>
            <div>
                <h6 class="fw-bold mb-1 text-neutral">Interactive Inline Editor</h6>
                <p class="mb-0 text-neutral opacity-75 small">
                    Hover over areas with dashed borders. <strong class="text-neutral">Click directly on the text</strong> to edit. Changes are captured when you click "Save All Changes".
                </p>
            </div>
        </div>

        <div id="pnlHero" runat="server" class="position-relative text-white mb-5 shadow-sm overflow-hidden rounded-top-4 border" style="height: 450px; border-bottom: 8px solid var(--theme-red) !important; border-color: var(--border-color) !important; background-size: cover; background-position: center;">
            <div style="position: absolute; top:0; left:0; width:100%; height:100%; background: rgba(33, 37, 41, 0.7);"></div>
            <div class="container h-100 position-relative z-2 d-flex flex-column justify-content-center align-items-center text-center">
                <span class="badge bg-transparent border border-light mb-3 px-3 py-2 rounded-0 text-uppercase" style="letter-spacing: 2px;">Lesson Overview</span>
                <div class="mb-1"><span class="badge border border-gold text-gold rounded-pill px-3 py-1 bg-transparent"><i class="fa-solid fa-pencil-alt me-1"></i> Click title below to edit</span></div>
                <h1 id="editTitle" contenteditable="true" class="display-2 font-classic fw-bold mb-3 inline-edit-dark" style="letter-spacing: 5px; min-width: 300px;">
                    <asp:Literal ID="litTitle" runat="server"></asp:Literal>
                </h1>
                <div class="d-flex align-items-center fs-5 opacity-75 font-classic">
                    <span class="text-gold me-2">✦</span>
                    <asp:Label ID="lblDynasty" runat="server"></asp:Label>
                    <span class="mx-3">|</span>
                    <asp:HyperLink ID="lnkAuthor" runat="server" CssClass="text-white author-link"></asp:HyperLink>
                    <span class="text-gold ms-2">✦</span>
                </div>
            </div>
        </div>

        <div class="container-fluid px-0 mb-5" style="margin-top: -60px; position: relative; z-index: 10;">
            <div class="card border border-neutral shadow-sm rounded-4 overflow-hidden bg-white">
                <div class="bg-white border-bottom px-4 py-3 d-flex justify-content-between align-items-center" style="border-color: var(--border-color) !important;">
                    <span class="text-neutral small fw-bold"><i class="fa-solid fa-chevron-left me-1"></i> LIBRARY</span>
                    <span class="text-neutral small opacity-50" style="letter-spacing: 1px;">CLASSICAL CHINESE LITERATURE</span>
                </div>

                <div class="row g-0">
                    <div class="col-lg-7">
                        <div class="p-5 h-100 position-relative">
                            <div class="position-absolute top-0 end-0 p-3 opacity-10" style="font-family: 'KaiTi'; font-size: 10rem; color: var(--neutral-dark); line-height: 0.8; pointer-events: none;">文</div>
                            
                            <div class="d-flex align-items-center mb-4 border-bottom pb-3 position-relative" style="border-color: var(--border-color) !important; z-index: 2;">
                                <h3 class="font-classic fw-bold text-neutral mb-0 me-2 d-flex align-items-center">
                                    <i class="fa-solid fa-scroll me-2 text-red"></i> Original Text
                                </h3>
                                <button type="button" class="btn btn-sm border rounded-circle shadow-sm me-3" id="btnSpeakAll" onclick="speakFullText()" title="Read Full Text" style="width: 32px; height: 32px; background: transparent; border-color: var(--neutral-dark) !important;">
                                    <i class="fa-solid fa-volume-high text-neutral"></i>
                                </button>
                                <span class="badge border border-neutral text-neutral px-2 py-1 bg-transparent"><i class="fa-solid fa-pencil-alt text-gold me-1"></i> Editable Area</span>
                            </div>
                            
                            <div id="editContentText" contenteditable="true" class="font-classic fs-5 pe-3 inline-edit-light content-indented position-relative text-neutral" style="line-height: 2.2; min-height: 200px; z-index: 2;">
                                <asp:Literal ID="litContentText" runat="server"></asp:Literal>
                            </div>

                            <div class="mt-5 pt-4 text-center border-top position-relative" style="border-color: var(--border-color) !important; z-index: 60;">
                                <p class="text-neutral opacity-75 small mb-3 fst-italic">Encountering difficult words?</p>
                                <a href='ContentDetailsEditor.aspx?ContentId=<%= Request.QueryString["ContentId"] %>' class="btn btn-outline-dark-custom btn-lg rounded-pill px-5">
                                    <i class="fa-solid fa-glasses text-gold me-2"></i> Start Detailed Analysis Editor
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-5 bg-white border-start" style="border-color: var(--border-color) !important;">
                        <div class="p-4 h-100 d-flex flex-column">
                            
                            <div class="mb-4">
                                <h5 class="fw-bold text-uppercase small mb-3 d-flex align-items-center text-neutral" style="letter-spacing: 1px;">
                                    <i class="fa-solid fa-film text-gold me-2 fs-5"></i> Video Story
                                    <span class="badge bg-transparent border text-neutral ms-auto" style="border-color: var(--border-color) !important; text-transform: none; letter-spacing: 0;"><i class="fa-solid fa-link text-gold me-1"></i> Paste URL Below</span>
                                </h5>
                                <asp:TextBox ID="txtVideoUrl" runat="server" CssClass="form-control mb-3 text-neutral" style="border: 2px solid var(--border-color);" placeholder="https://www.youtube.com/embed/..."></asp:TextBox>
                                <div class="ratio ratio-16x9 shadow-sm rounded-3 overflow-hidden bg-dark">
                                    <asp:Literal ID="litVideo" runat="server"></asp:Literal>
                                </div>
                            </div>

                            <div class="mb-4">
                                <h5 class="fw-bold text-uppercase small mb-3 d-flex align-items-center text-neutral" style="letter-spacing: 1px;">
                                    <i class="fa-solid fa-tags text-gold me-2 fs-5"></i> Genre
                                    <span class="badge bg-transparent border text-neutral ms-3" style="border-color: var(--border-color) !important; text-transform: none; letter-spacing: 0;"><i class="fa-solid fa-pencil-alt text-gold me-1"></i> Editable</span>
                                </h5>
                                <div class="d-inline-block px-4 py-2 inline-edit-light bg-white" style="border-left: 4px solid var(--theme-red);">
                                    <asp:TextBox ID="txtGenre" runat="server" CssClass="form-control border-0 bg-transparent font-classic fs-6 fw-bold p-0 m-0 text-neutral" style="letter-spacing: 2px; box-shadow: none; min-width: 150px;"></asp:TextBox>
                                </div>
                            </div>

                            <div class="mb-4 d-flex flex-column" style="flex: 1;">
                                <h5 class="fw-bold text-uppercase small mb-3 d-flex align-items-center text-neutral" style="letter-spacing: 1px;">
                                    <i class="fa-solid fa-book-open text-gold me-2 fs-5"></i> Analysis
                                    <span class="badge bg-transparent border text-neutral ms-3" style="border-color: var(--border-color) !important; text-transform: none; letter-spacing: 0;"><i class="fa-solid fa-pencil-alt text-gold me-1"></i> Editable</span>
                                </h5>
                                <div class="p-4 rounded-3 inline-edit-light clearfix bg-white">
                                    <div style="float: left; font-family: Georgia, serif; font-size: 4.5rem; font-weight: bold; color: var(--theme-red); line-height: 0.7; margin-right: 8px; margin-top: 5px;">“</div>
                                    <div id="editAnalysis" contenteditable="true" class="font-classic text-neutral opacity-75" style="line-height: 2.2; text-align: justify; font-size: 1.05rem; outline: none; min-height: 100px;">
                                        <asp:Literal ID="litAnalysis" runat="server"></asp:Literal>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="p-4 p-md-5 rounded-4 border mb-5 bg-white" style="border-color: var(--border-color) !important;">
            <div class="text-center mb-4">
                <span class="badge-outline-dark rounded-pill px-3 py-1 mb-3"><i class="fa-solid fa-shield-halved text-gold me-1"></i> Global Feedback</span>
                <h3 class="font-classic fw-bold text-neutral" style="letter-spacing: 1px;">Moderation Control</h3>
            </div>

            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="card border rounded-4 h-100 bg-white" style="border-color: var(--border-color) !important;">
                        <div class="p-4 h-100 d-flex flex-column">
                            <div class="d-flex flex-column mb-4 border-bottom pb-3" style="border-color: var(--border-color) !important;">
                                <h4 class="font-classic fw-bold m-0 text-neutral"><i class="fa-solid fa-scroll text-gold me-2"></i> Teacher's Notes</h4>
                                <p class="text-neutral opacity-75 small mt-2 mb-0">Review and approve contextual notes submitted by teachers.</p>
                            </div>
                            
                            <div class="custom-scroll pe-2 flex-grow-1" style="max-height: 380px; overflow-y: auto;">
                                <ul class="list-group list-group-flush">
                                    <asp:Repeater ID="rptNotes" runat="server" OnItemCommand="rptNotes_ItemCommand">
                                        <ItemTemplate>
                                            <li class="list-group-item px-0 py-4 border-bottom bg-transparent" style="border-color: var(--border-color) !important;">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <div class="border rounded-2 d-flex justify-content-center align-items-center flex-shrink-0 text-neutral" style="width: 28px; height: 28px; border-color: var(--theme-gold) !important;">
                                                            <i class="fa-solid fa-person-chalkboard text-gold"></i>
                                                        </div>
                                                        <span class="fw-bold text-neutral lh-1 m-0"><%# Eval("TeacherName") %></span>
                                                        <span class="badge <%# Eval("StatusClass") %> rounded-pill px-2" style="font-size: 0.7rem;"><%# Eval("Status") %></span>
                                                    </div>
                                                    <small class="text-neutral opacity-50 m-0 lh-1" style="font-size: 0.75rem;"><%# Eval("CreatedAt", "{0:yyyy-MM-dd HH:mm}") %></small>
                                                </div>
                                                <p class="mb-3 text-neutral ps-5" style="font-size: 0.95rem; line-height: 1.5;"><%# Eval("NoteContent") %></p>
                                                <div class="text-end pe-1">
                                                    <asp:LinkButton ID="btnApproveNote" runat="server" CommandName="Approve" CommandArgument='<%# Eval("NoteId") %>' Visible='<%# Eval("IsPending") %>' CssClass="btn btn-sm btn-outline-dark-custom rounded-pill px-3 fw-bold me-1"><i class="bi bi-check-lg me-1"></i> Approve</asp:LinkButton>
                                                    <asp:LinkButton ID="btnRejectNote" runat="server" CommandName="Reject" CommandArgument='<%# Eval("NoteId") %>' CssClass="btn btn-sm btn-outline-danger-custom rounded-pill px-3 fw-bold" OnClientClick="return confirm('Permanently delete this note?');"><i class="fa-regular fa-trash-can me-1"></i> Remove</asp:LinkButton>
                                                </div>
                                            </li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                                <asp:PlaceHolder ID="phNoNotes" runat="server" Visible="false">
                                    <div class="text-center py-5 text-neutral opacity-50 h-100 d-flex flex-column justify-content-center align-items-center">
                                        <i class="fa-solid fa-folder fa-3x mb-3 text-gold"></i>
                                        <p class="mb-0 small">No notes submitted yet.</p>
                                    </div>
                                </asp:PlaceHolder>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card border rounded-4 h-100 bg-white" style="border-color: var(--border-color) !important;">
                        <div class="p-4 h-100 d-flex flex-column">
                            <div class="d-flex flex-column mb-4 border-bottom pb-3" style="border-color: var(--border-color) !important;">
                                <h4 class="font-classic fw-bold m-0 text-neutral"><i class="fa-solid fa-stamp text-gold me-2"></i> Discussion</h4>
                                <p class="text-neutral opacity-75 small mt-2 mb-0">Monitor student discussions. Censor inappropriate comments.</p>
                            </div>
                            
                            <div class="custom-scroll pe-2 flex-grow-1" style="max-height: 380px; overflow-y: auto;">
                                <ul class="list-group list-group-flush">
                                    <asp:Repeater ID="rptComments" runat="server" OnItemCommand="rptComments_ItemCommand">
                                        <ItemTemplate>
                                            <li class="list-group-item px-0 py-4 border-bottom bg-transparent" style="border-color: var(--border-color) !important;">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <div class="border rounded-circle d-flex justify-content-center align-items-center fw-bold flex-shrink-0 text-neutral" style="width: 28px; height: 28px; font-size: 0.8rem; border-color: var(--neutral-dark) !important;">
                                                            <%# Eval("UserInitial") %>
                                                        </div>
                                                        <span class="fw-bold text-neutral lh-1 m-0"><%# Eval("Username") %></span>
                                                    </div>
                                                    <small class="text-neutral opacity-50 m-0 lh-1" style="font-size: 0.75rem;"><%# Eval("CreatedAt", "{0:yyyy-MM-dd HH:mm}") %></small>
                                                </div>
                                                <p class="mb-2 text-neutral ps-5" style="font-size: 0.95rem; line-height: 1.5;"><%# Eval("CommentText") %></p>
                                                <div class="text-end pe-1">
                                                    <asp:LinkButton ID="btnCensorComment" runat="server" CommandName="Censor" CommandArgument='<%# Eval("CommentId") %>' CssClass="btn btn-sm btn-outline-danger-custom px-3 rounded-pill fw-bold" Visible='<%# !(bool)Eval("IsCensored") %>' OnClientClick="return confirm('Replace this comment with [Admin Removed] warning?');"><i class="fa-solid fa-shield-slash me-1"></i> Censor</asp:LinkButton>
                                                </div>
                                            </li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                                <asp:PlaceHolder ID="phNoComments" runat="server" Visible="false">
                                    <div class="text-center py-5 text-neutral opacity-50 h-100 d-flex flex-column justify-content-center align-items-center">
                                        <i class="fa-solid fa-comments fa-3x mb-3 text-gold"></i>
                                        <p class="mb-0 small">No comments yet.</p>
                                    </div>
                                </asp:PlaceHolder>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let isReading = false;
        function speakFullText() {
            if (!('speechSynthesis' in window)) { alert("Your browser does not support TTS."); return; }
            const btnSpeak = document.getElementById("btnSpeakAll");
            if (isReading) {
                window.speechSynthesis.cancel();
                isReading = false;
                btnSpeak.style.color = "var(--neutral-dark)";
                return;
            }
            let rawText = document.getElementById('editContentText').innerText;
            let cleanText = rawText.trim().replace(/[\r\n]+/g, ' ');
            if (cleanText === "") return;
            window.speechSynthesis.cancel();
            setTimeout(() => {
                let u = new SpeechSynthesisUtterance(cleanText);
                u.lang = 'zh-CN'; u.rate = 0.85;
                u.onend = function () { isReading = false; btnSpeak.style.color = "var(--neutral-dark)"; };
                window.speechSynthesis.speak(u);
                isReading = true;
                btnSpeak.style.color = "var(--theme-red)";
            }, 50);
        }
        window.onbeforeunload = function () { window.speechSynthesis.cancel(); };

        function captureInlineEdits() {
            document.getElementById('<%= hfTitle.ClientID %>').value = document.getElementById('editTitle').innerText;
            document.getElementById('<%= hfContentText.ClientID %>').value = document.getElementById('editContentText').innerHTML;
            document.getElementById('<%= hfAnalysis.ClientID %>').value = document.getElementById('editAnalysis').innerHTML;
            document.getElementById('<%= hfSecondaryText.ClientID %>').value = document.getElementById('editSecondaryText') ? document.getElementById('editSecondaryText').innerHTML : '';
            return confirm("Save all changes to the database?");
        }
    </script>
</asp:Content>