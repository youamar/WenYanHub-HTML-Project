<%@ Page Title="Detailed Study" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="WenYanHub.Contents.Details" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4 mb-5">
        <div class="mb-3">
            <a href='<%= "Intro.aspx?id=" + Request.QueryString["id"] %>' class="text-decoration-none text-secondary hover-red fw-bold">
                <i class="fa-solid fa-arrow-left me-2"></i> Back to Overview
            </a>
        </div>
        
        <div class="text-center border-bottom pb-4">
            <h1 class="font-classic fw-bold text-dark mb-3" style="letter-spacing: 3px;">
                <asp:Label ID="lblTitle" runat="server"></asp:Label>
            </h1>
            
            <div class="d-flex justify-content-center align-items-center">
                <span class="badge bg-light text-dark border px-3 py-2 me-3" style="font-size: 0.85rem; letter-spacing: 1px;">
                    <asp:Label ID="lblDynasty" runat="server"></asp:Label>
                </span>
                
                <i class="fa-solid fa-feather-pointed text-muted me-2" style="font-size: 0.9rem;"></i>
                <asp:HyperLink ID="lnkAuthor" runat="server" CssClass="text-decoration-none font-classic fs-5 text-danger fw-bold author-link" ToolTip="View Author Profile">
                </asp:HyperLink>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 rounded-4 h-100" style="background-color: #fdfbf7;">
                    <div class="card-body p-4 p-md-5">
                        
                        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom border-secondary-subtle sticky-toolbar bg-transparent">
                            <div class="d-flex align-items-center">
                                <i class="fa-solid fa-book-open-reader text-danger me-2 fa-lg"></i>
                                <h5 class="font-classic fw-bold text-dark mb-0">Original Text</h5>
                            </div>
                            
                            <div class="d-flex gap-3 align-items-center">
                                <div class="form-check form-switch custom-switch">
                                    <input class="form-check-input" type="checkbox" id="toggleTranslation" checked onchange="toggleTranslations()">
                                    <label class="form-check-label small text-muted fw-bold" for="toggleTranslation" style="cursor: pointer;">Show English</label>
                                </div>

                                <div class="btn-group btn-group-sm shadow-sm">
                                    <button type="button" class="btn btn-light border" onclick="changeFontSize(-2)" title="Smaller Text"><i class="fa-solid fa-minus"></i></button>
                                    <button type="button" class="btn btn-light border fw-bold" onclick="resetFontSize()" title="Reset Size">A</button>
                                    <button type="button" class="btn btn-light border" onclick="changeFontSize(2)" title="Larger Text"><i class="fa-solid fa-plus"></i></button>
                                </div>
                            </div>
                        </div>

                        <div class="study-content">
                            <asp:Repeater ID="rptSentences" runat="server">
                                <ItemTemplate>
                                    <div class="sentence-block mb-4 pb-3 border-bottom border-light" style="transition: all 0.2s ease;">
                                        <h4 class="reading-text click-to-read text-dark fw-bold mb-2" onclick="speak(this, true)" title="Tap to listen" style="line-height: 1.8; cursor: pointer;">
                                            <%# Eval("SentenceText") %>
                                        </h4>
                                        <p class="translation-text text-secondary mb-0" style="font-size: 1.05rem; line-height: 1.6;">
                                            <%# Eval("Translate") %>
                                        </p>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card shadow-sm border-0 rounded-4 sticky-top" style="top: 80px; z-index: 10; background-color: #fff;">
                    <div class="card-header bg-white border-bottom pt-4 pb-3 px-4">
                        <h5 class="fw-bold mb-0" style="color: #3e2723;">
                            <i class="fa-solid fa-spell-check text-warning me-2"></i> Vocabulary List
                        </h5>
                    </div>
                    
                    <div class="card-body p-0 custom-scroll" style="max-height: calc(100vh - 150px); overflow-y: auto;">
                        <ul class="list-group list-group-flush">
                            <asp:Repeater ID="rptWords" runat="server">
                                <ItemTemplate>
                                    <li class="list-group-item p-4 vocab-item hover-lift">
                                        <div class="d-flex justify-content-between align-items-baseline mb-1">
                                            <h5 class="text-danger mb-0 fw-bold click-to-read d-inline-block" onclick="speak(this.innerText, false)" style="cursor: pointer;">
                                                <%# Eval("Vocabulary") %>
                                            </h5>
                                            <span class="badge bg-light text-secondary border rounded-pill fw-normal" style="font-size: 0.85rem; letter-spacing: 1px;">
                                                <%# Eval("Pinyin") %>
                                            </span>
                                        </div>
                                        <div class="text-dark mt-2" style="font-size: 0.95rem; line-height: 1.5;">
                                            <%# Eval("Annotations") %>
                                        </div>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ul>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <style>
        /* 💡 Interactive Author Link */
        .author-link { transition: all 0.2s ease-in-out; border-bottom: 1px dashed transparent; }
        .author-link:hover { color: #5c0000 !important; border-bottom: 1px dashed #5c0000; transform: scale(1.05); }

        /* Interactive Reading Styles */
        .click-to-read { transition: color 0.2s, background-color 0.2s; border-radius: 4px; padding: 2px 5px; margin-left: -5px; }
        .click-to-read:hover { background-color: rgba(139, 0, 0, 0.05); color: #8b0000 !important; }
        
        /* Active Reading Highlight */
        .reading-active { background-color: rgba(139, 0, 0, 0.1) !important; color: #8b0000 !important; 
                          border-left: 4px solid #8b0000; padding-left: 10px; margin-left: -14px; }
        
        /* Sentence Block Hover Effect */
        .sentence-block:hover { background-color: rgba(255, 255, 255, 0.5); border-radius: 8px; padding-left: 10px; padding-right: 10px; margin-left: -10px; margin-right: -10px; box-shadow: 0 4px 10px rgba(0,0,0,0.02); }
        
        /* Vocabulary Hover Lift */
        .vocab-item { transition: background-color 0.2s; }
        .vocab-item:hover { background-color: #fdfbf7; }
        
        /* Smooth Fade for Translation Toggle */
        .translation-text { transition: opacity 0.3s ease, height 0.3s ease, margin 0.3s ease; opacity: 1; }
        .translation-hidden { opacity: 0; height: 0; margin: 0 !important; overflow: hidden; }

        .hover-red:hover { color: #8b0000 !important; }
        
        /* Custom Switch Color */
        .custom-switch .form-check-input:checked { background-color: #8b0000; border-color: #8b0000; }

        /* Elegant Scrollbar for Vocab List */
        .custom-scroll::-webkit-scrollbar { width: 6px; }
        .custom-scroll::-webkit-scrollbar-track { background: #f8f9fa; }
        .custom-scroll::-webkit-scrollbar-thumb { background: #d7ccc8; border-radius: 10px; }
        .custom-scroll::-webkit-scrollbar-thumb:hover { background: #8d6e63; }
    </style>

    <script>
        // 1. Text-to-Speech (TTS) Engine
        let currentElement = null;
        function speak(source, isElement) {
            let text = isElement ? source.innerText : source;
            let el = isElement ? source : null;

            if (!('speechSynthesis' in window)) { alert("TTS not supported by your browser."); return; }

            window.speechSynthesis.cancel(); // Stop current speech

            // Remove highlight from previous text
            if (currentElement) { currentElement.classList.remove('reading-active'); }

            // Add highlight to current text
            if (el) {
                currentElement = el;
                currentElement.classList.add('reading-active');
            }

            let u = new SpeechSynthesisUtterance(text.trim());
            u.lang = 'zh-CN';
            u.rate = 0.85; // Slightly slower for better learning

            u.onend = function () {
                if (currentElement) currentElement.classList.remove('reading-active');
            };

            window.speechSynthesis.speak(u);
        }

        // Stop audio if user leaves page
        window.onbeforeunload = function () { window.speechSynthesis.cancel(); };

        // 2. Font Size Controller
        let currentFontSize = 24; // Default starting size for H4
        function changeFontSize(n) {
            currentFontSize = Math.max(16, Math.min(48, currentFontSize + n));
            applyFontSize();
        }
        function resetFontSize() {
            currentFontSize = 24;
            applyFontSize();
        }
        function applyFontSize() {
            document.querySelectorAll('.reading-text').forEach(el => el.style.fontSize = currentFontSize + 'px');
        }

        // 3. Toggle Translation Feature
        function toggleTranslations() {
            const isChecked = document.getElementById('toggleTranslation').checked;
            const translations = document.querySelectorAll('.translation-text');

            translations.forEach(el => {
                if (isChecked) {
                    el.classList.remove('translation-hidden');
                } else {
                    el.classList.add('translation-hidden');
                }
            });
        }
    </script>

</asp:Content>