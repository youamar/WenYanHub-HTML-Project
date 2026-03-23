<%@ Page Title="Overview" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Intro.aspx.cs" Inherits="WenYanHub.Contents.Intro" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlHero" runat="server" CssClass="position-relative text-white mb-5 shadow-lg overflow-hidden" 
               style="height: 450px; margin-top: -20px; border-bottom: 8px solid #8b0000;">
        
        <div class="hero-overlay" style="position: absolute; top:0; left:0; width:100%; height:100%; background: linear-gradient(to bottom, rgba(62, 39, 35, 0.4), rgba(62, 39, 35, 0.9));"></div>
        
        <div class="container h-100 position-relative z-2 d-flex flex-column justify-content-center align-items-center text-center">
            <span class="badge bg-transparent border border-light mb-3 px-3 py-2 rounded-0 ls-2 text-uppercase">Lesson Overview</span>
            
            <h1 class="display-2 font-classic fw-bold mb-3 text-shadow animate-up" style="letter-spacing: 5px;">
                <asp:Label ID="lblTitle" runat="server"></asp:Label>
            </h1>
            
            <div class="d-flex align-items-center fs-5 opacity-75 font-classic animate-up delay-1">
                <span class="text-warning me-2">✦</span>
                <asp:Label ID="lblDynasty" runat="server"></asp:Label>
                <span class="mx-3">|</span>
                <asp:Label ID="lblAuthor" runat="server"></asp:Label>
                <span class="text-warning ms-2">✦</span>
            </div>
        </div>
    </asp:Panel>

    <div class="container mb-5" style="margin-top: -60px; position: relative; z-index: 10;">
        
        <div class="card border-0 shadow-lg rounded-4 overflow-hidden mb-5" style="background-color: #fdfbf7;">
            
            <div class="bg-white border-bottom px-4 py-3 d-flex justify-content-between align-items-center">
                <a href="Index.aspx" class="text-decoration-none text-secondary hover-gold small fw-bold">
                    <i class="fa-solid fa-chevron-left me-1"></i> LIBRARY
                </a>
                <span class="text-muted small ls-1 opacity-50">CLASSICAL CHINESE LITERATURE</span>
            </div>

            <div class="row g-0">
                <div class="col-lg-7">
                    <div class="p-5 h-100 position-relative">
                        <div class="position-absolute top-0 end-0 p-3 opacity-10" style="font-family: 'KaiTi'; font-size: 10rem; color: #8b0000; line-height: 0.8; pointer-events: none;">文</div>

                        <div class="d-flex align-items-center mb-4 border-bottom pb-3" style="border-color: #d7ccc8 !important;">
                            <h3 class="font-classic fw-bold text-dark mb-0 me-3">
                                <i class="fa-solid fa-scroll me-2 text-danger"></i> Original Text
                            </h3>
                            <button type="button" class="btn btn-outline-secondary rounded-circle btn-sm shadow-sm" id="btnSpeakAll" onclick="speakFullText()" title="Read Full Text" style="width: 35px; height: 35px; transition: all 0.2s;">
                                <i class="fa-solid fa-volume-high"></i>
                            </button>
                        </div>
                        
                        <div class="font-classic fs-5 pe-3" style="color: #4e342e; line-height: 2.2;">
                            <asp:Label ID="lblContentText" runat="server"></asp:Label>
                        </div>

                        <div class="mt-5 pt-4 text-center border-top border-secondary border-opacity-10">
                            <p class="text-muted small mb-3 fst-italic">Encountering difficult words?</p>
                            <asp:HyperLink ID="lnkStartDetailedLearning" runat="server" CssClass="btn btn-dark btn-lg rounded-pill px-5 shadow hover-lift" style="background-color: #3e2723; border: none;">
                                <i class="fa-solid fa-glasses me-2"></i> Start Detailed Analysis
                            </asp:HyperLink>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5 bg-white border-start-lg border-secondary border-opacity-10">
                    <div class="p-4 h-100 d-flex flex-column">
                        
                        <div class="mb-4">
                            <h5 class="fw-bold text-uppercase small ls-1 mb-3" style="color: #3e2723;">
                                <span class="me-2" style="color: #d2b48c; font-family: 'Segoe UI Emoji', sans-serif; font-size: 1.2rem;">🎞️&#xFE0E;</span> Video Story
                            </h5>
                            <div class="ratio ratio-16x9 shadow-sm rounded-3 overflow-hidden bg-dark">
                                <asp:Literal ID="litVideo" runat="server"></asp:Literal>
                                <asp:Panel ID="pnlNoVideo" runat="server" Visible="false" CssClass="d-flex flex-column align-items-center justify-content-center h-100 text-muted">
                                    <i class="fa-regular fa-circle-play fa-2x mb-2 opacity-50"></i>
                                    <small>No guide available</small>
                                </asp:Panel>
                            </div>
                        </div>

                        <div class="mb-4">
                            <h5 class="fw-bold text-uppercase small ls-1 mb-3" style="color: #3e2723;">
                                <span class="me-2" style="color: #d2b48c; font-family: 'Segoe UI Emoji', sans-serif; font-size: 1.2rem;">🏷️&#xFE0E;</span> Genre
                            </h5>
                            <div class="d-inline-block px-4 py-2 shadow-sm" style="background-color: #fdfbf7; border-left: 4px solid #8b0000; border-radius: 4px; border-top: 1px solid #f0eae1; border-right: 1px solid #f0eae1; border-bottom: 1px solid #f0eae1;">
                                <span class="font-classic fs-6 fw-bold" style="color: #5d4037; letter-spacing: 2px;">
                                    <asp:Label ID="lblGenre" runat="server"></asp:Label>
                                </span>
                            </div>
                        </div>

                        <div class="mb-4 d-flex flex-column" style="flex: 1;">
                            <h5 class="fw-bold text-uppercase small ls-1 mb-3" style="color: #3e2723;">
                                <span class="me-2" style="color: #d2b48c; font-family: 'Segoe UI Emoji', sans-serif; font-size: 1.2rem;">📖&#xFE0E;</span> Analysis
                            </h5>
                            <div class="p-4 rounded-3 shadow-sm flex-grow-1 position-relative" style="background-color: #fdfbf7; border: 1px solid #d7ccc8;">
                                <i class="fa-solid fa-quote-left position-absolute opacity-10" style="top: 15px; left: 15px; font-size: 2rem; color: #8b0000;"></i>
                                <div class="font-classic text-secondary position-relative z-1" style="line-height: 2.2; text-align: justify; font-size: 1.05rem; text-indent: 2em;">
                                    <asp:Label ID="lblAnalysis" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <div class="mt-auto p-4 rounded-3 text-center shadow-sm" style="background-color: #fdfbf7; border: 1px dashed #d7ccc8;">
                            <p class="font-classic fs-6 text-secondary mb-0" style="letter-spacing: 1px;">
                                "Reading a hundred times, the meaning will naturally manifest."
                                <br>
                                <small class="fw-bold mt-1 d-block" style="color: #8b0000; opacity: 0.8;">(书读百遍，其义自见)</small>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-lg-6">
                <div class="card border-0 shadow-lg rounded-4 overflow-hidden h-100" style="background-color: #fdfbf7;">
                    <div class="p-5 h-100">
                        <div class="d-flex align-items-center mb-4 border-bottom pb-3" style="border-color: #d7ccc8 !important;">
                            <h4 class="font-classic fw-bold" style="color: #3e2723;">
                                <i class="fa-solid fa-scroll me-2" style="color: #d2b48c;"></i> Teacher's Notes
                            </h4>
                        </div>
                        <div class="custom-scroll pe-2" style="max-height: 480px; overflow-y: auto;">
                            <asp:Repeater ID="rptNotes" runat="server">
                                <ItemTemplate>
                                    <div class="card mb-3 border-0 shadow-sm" style="background-color: rgba(255,255,255,0.5);">
                                        <div class="card-body p-3">
                                            <h6 class="card-subtitle mb-2 text-muted">
                                                <span><i class="fa-solid fa-user-tie me-1"></i> <%# Eval("Teacher.Username") %></span>
                                            </h6>
                                            <div class="card-text mt-2 text-dark" style="line-height: 1.6;">
                                                <%# Eval("NoteContent") %>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:Panel ID="pnlNoNotes" runat="server" Visible="false" CssClass="text-center py-5 text-muted">
                                <i class="fa-solid fa-folder-open fa-3x opacity-25 mb-3"></i>
                                <p class="mb-0">No notes available yet.</p>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-6" id="discuss-box">
                <div class="card border-0 shadow-lg rounded-4 overflow-hidden h-100" style="background-color: #fdfbf7;">
                    <div class="p-5 h-100 d-flex flex-column">
                        <div class="d-flex align-items-center mb-4 border-bottom pb-3" style="border-color: #d7ccc8 !important;">
                            <h4 class="font-classic fw-bold" style="color: #3e2723;">
                                <i class="fa-solid fa-stamp me-2" style="color: #d2b48c;"></i> Discussion
                            </h4>
                        </div>

                        <asp:Panel ID="pnlCommentForm" runat="server" Visible="false" CssClass="mb-4">
                            <div class="bg-white p-3 rounded-3 shadow-sm border border-secondary border-opacity-10">
                                <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control border-0 bg-light" placeholder="Share your insights..."></asp:TextBox>
                                <div class="text-end mt-2">
                                    <asp:Button ID="btnSubmitComment" runat="server" Text="Post Comment" CssClass="btn btn-primary btn-sm px-4 rounded-pill shadow-sm" OnClick="btnSubmitComment_Click" />
                                </div>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnlLoginPrompt" runat="server" CssClass="alert alert-warning text-center py-2 mb-4 rounded-pill shadow-sm">
                            <small>Please <asp:HyperLink ID="lnkLogin" runat="server" CssClass="alert-link fw-bold">Log In</asp:HyperLink> to join the discussion.</small>
                        </asp:Panel>

                        <div class="custom-scroll pe-2 flex-grow-1" style="max-height: 380px; overflow-y: auto;">
                            <asp:Repeater ID="rptComments" runat="server" OnItemCommand="rptComments_ItemCommand">
                                <ItemTemplate>
                                    <div class="d-flex mb-3 border-bottom border-secondary border-opacity-10 pb-3">
                                        <div class="flex-shrink-0">
                                            <div class="rounded-circle bg-secondary text-white d-flex align-items-center justify-content-center fw-bold shadow-sm" style="width: 45px; height: 45px;">
                                                <%# Eval("User.Username").ToString().Substring(0, 1).ToUpper() %>
                                            </div>
                                        </div>
                                        <div class="flex-grow-1 ms-3">
                                            <h6 class="mt-0 fw-bold text-primary mb-1 d-flex justify-content-between align-items-center">
                                                <span>
                                                    <%# Eval("User.Username") %> 
                                                    <small class="text-muted fw-normal ms-2" style="font-size: 0.8rem;"><%# Eval("CreatedAt", "{0:yyyy-MM-dd HH:mm}") %></small>
                                                </span>
                                                
                                                <asp:PlaceHolder ID="phActions" runat="server" Visible='<%# IsMyComment(Eval("UserId")) %>'>
                                                    <div class="dropdown">
                                                        <button class="btn btn-link text-muted p-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                            <i class="fa-solid fa-ellipsis-vertical"></i>
                                                        </button>
                                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 small">
                                                            <li>
                                                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditComment" CommandArgument='<%# Eval("CommentId") %>' CssClass="dropdown-item py-2">
                                                                    <i class="fa-solid fa-pen me-2 text-info"></i> Edit
                                                                </asp:LinkButton>
                                                            </li>
                                                            <li>
                                                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteComment" CommandArgument='<%# Eval("CommentId") %>' CssClass="dropdown-item py-2 text-danger" OnClientClick="return confirm('Delete this comment?');">
                                                                    <i class="fa-solid fa-trash me-2"></i> Delete
                                                                </asp:LinkButton>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </asp:PlaceHolder>
                                            </h6>

                                            <asp:Label ID="lblCommentText" runat="server" Text='<%# Eval("CommentText") %>' CssClass="mb-0 text-dark" style="line-height: 1.5; font-size: 0.95rem;"></asp:Label>
                                            
                                            <asp:Panel ID="pnlEdit" runat="server" Visible="false" CssClass="mt-2 p-2 bg-white rounded shadow-sm border">
                                                <asp:TextBox ID="txtEditComment" runat="server" Text='<%# Eval("CommentText") %>' TextMode="MultiLine" Rows="2" CssClass="form-control form-control-sm border-0 bg-light mb-2"></asp:TextBox>
                                                <div class="text-end">
                                                    <asp:Button ID="btnUpdate" runat="server" Text="Update" CommandName="UpdateComment" CommandArgument='<%# Eval("CommentId") %>' CssClass="btn btn-success btn-sm px-3 rounded-pill" />
                                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CommandName="CancelEdit" CssClass="btn btn-light btn-sm px-3 rounded-pill" />
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlNoComments" runat="server" Visible="false" CssClass="text-center py-5 text-muted">
                                <p class="mb-0">No comments yet. Be the first to share!</p>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container pb-5" id="learning-section">
        <div class="text-center mb-4 border-bottom pb-3">
            <span class="text-muted small text-uppercase ls-2">Next Steps</span>
            <h3 class="font-classic mt-2 text-dark">Continue Exploring</h3>
        </div>
        
        <div class="row justify-content-center g-4">
            <div class="col-md-5">
                <asp:HyperLink ID="lnkChapterLearning" runat="server" CssClass="card card-hover text-decoration-none border-0 shadow-sm h-100" style="background: #fff; border-bottom: 4px solid #3e2723 !important;">
                    <div class="card-body d-flex align-items-center p-4">
                        <div class="rounded-circle d-flex align-items-center justify-content-center me-3 shadow-sm" 
                             style="background-color: #3e2723; width: 65px; height: 65px; min-width: 65px;">
                            <i class="fa-solid fa-book-open" style="font-size: 1.8rem; color: #f5f5dc;"></i>
                        </div>
                        <div>
                            <h5 class="fw-bold text-dark mb-1">Chapter Learning</h5>
                            <span class="text-muted small">Deep dive by topic and paragraphs</span>
                        </div>
                        <i class="fa-solid fa-chevron-right ms-auto opacity-50 fa-lg" style="color: #3e2723;"></i>
                    </div>
                </asp:HyperLink>
            </div>

            <div class="col-md-5">
                <asp:HyperLink ID="lnkQuiz" runat="server" CssClass="card card-hover text-decoration-none border-0 shadow-sm h-100" style="background: #fff; border-bottom: 4px solid #5d4037 !important;">
                    <div class="card-body d-flex align-items-center p-4">
                        <div class="rounded-circle d-flex align-items-center justify-content-center me-3 shadow-sm" 
                             style="background-color: #5d4037; width: 65px; height: 65px; min-width: 65px;">
                            <i class="fa-solid fa-pen-fancy" style="font-size: 1.8rem; color: #f5f5dc;"></i>
                        </div>
                        <div>
                            <h5 class="fw-bold text-dark mb-1">Practice Quiz</h5>
                            <span class="text-muted small">Test your knowledge on this lesson</span>
                        </div>
                        <i class="fa-solid fa-chevron-right ms-auto opacity-50 fa-lg" style="color: #5d4037;"></i>
                    </div>
                </asp:HyperLink>
            </div>
        </div>
    </div>

    <style>
        .text-shadow { text-shadow: 0 4px 15px rgba(0,0,0,0.6); }
        .ls-1 { letter-spacing: 1px; }
        .ls-2 { letter-spacing: 2px; }
        .hover-gold:hover { color: #d4af37 !important; }
        .hover-lift { transition: transform 0.2s; }
        .hover-lift:hover { transform: translateY(-3px); }
        .card-hover { transition: all 0.3s ease; }
        .card-hover:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1) !important; }
        .animate-up { animation: fadeInUp 1s ease-out forwards; opacity: 0; transform: translateY(20px); }
        .delay-1 { animation-delay: 0.3s; }
        @keyframes fadeInUp { to { opacity: 1; transform: translateY(0); } }
        .custom-scroll::-webkit-scrollbar { width: 6px; }
        .custom-scroll::-webkit-scrollbar-track { background: transparent; }
        .custom-scroll::-webkit-scrollbar-thumb { background: #dee2e6; border-radius: 10px; }
        .custom-scroll::-webkit-scrollbar-thumb:hover { background: #adb5bd; }
        .speaker-active { background-color: #8b0000 !important; color: white !important; border-color: #8b0000 !important; }
        .flex-grow-1 h6 span, 
        .flex-grow-1 h6 .text-primary,
        .comment-username { 
            color: #5d4037 !important; 
        }

   
        .dropdown-item.text-danger {
            color: #000000 !important; 
        }


        .dropdown-item.text-danger:hover {
            background-color: #f8f9fa;
            color: #8b0000 !important; 
        }
    </style>

    <script>
        let isReading = false;
        function speakFullText() {
            if (!('speechSynthesis' in window)) { alert("Your browser does not support TTS."); return; }
            const btnSpeak = document.getElementById("btnSpeakAll");
            if (isReading) { window.speechSynthesis.cancel(); isReading = false; btnSpeak.classList.remove("speaker-active"); btnSpeak.innerHTML = '<i class="fa-solid fa-volume-high"></i>'; return; }
            let rawText = document.getElementById("<%= lblContentText.ClientID %>").innerText;
            let cleanText = rawText.trim().replace(/[\r\n]+/g, ' ');
            if (cleanText === "") return;
            window.speechSynthesis.cancel();
            setTimeout(() => {
                let u = new SpeechSynthesisUtterance(cleanText);
                u.lang = 'zh-CN'; u.rate = 0.85;
                u.onend = () => { isReading = false; btnSpeak.classList.remove("speaker-active"); btnSpeak.innerHTML = '<i class="fa-solid fa-volume-high"></i>'; };
                window.speechSynthesis.speak(u);
                isReading = true; btnSpeak.classList.add("speaker-active"); btnSpeak.innerHTML = '<i class="fa-solid fa-stop"></i>';
            }, 50);
        }
        window.onbeforeunload = () => { window.speechSynthesis.cancel(); };
    </script>
</asp:Content>