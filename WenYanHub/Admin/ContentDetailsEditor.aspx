<%@ Page Title="Edit Details" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ContentDetailsEditor.aspx.cs" Inherits="WenYanHub.Admin.ContentDetailsEditor" ValidateRequest="false" %>

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
        .font-classic { font-family: 'Noto Serif SC', serif; }
        .font-sans { font-family: 'Segoe UI', Tahoma, sans-serif; }

        .page-canvas { background-color: var(--theme-beige); border-radius: 24px; padding: 30px; margin: 20px; min-height: 75vh; }

        .btn-outline-dark-custom { background: transparent !important; color: var(--neutral-dark) !important; border: 2px solid var(--neutral-dark) !important; transition: 0.3s; font-weight: bold; }
        .btn-outline-dark-custom:hover { border-color: var(--theme-gold) !important; color: var(--theme-gold) !important; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(0,0,0,0.05); }

        .badge-outline-dark { border: 1px solid var(--neutral-dark); color: var(--neutral-dark); background: transparent; font-weight: bold; }

        .editable-wrapper { position: relative; border: 2px dashed transparent; transition: all 0.3s ease; }
        .editable-wrapper:hover { border-color: var(--theme-gold) !important; background: rgba(212, 175, 55, 0.02) !important; }
        
        .edit-trigger-btn {
            position: absolute; top: -15px; right: -15px; background: var(--bg-white); color: var(--theme-gold); border: 2px solid var(--theme-gold);
            width: 42px; height: 42px; border-radius: 50%; display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 10px rgba(212, 175, 55, 0.3); opacity: 0; transform: scale(0.8);
            transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); z-index: 50;
        }
        .editable-wrapper:hover .edit-trigger-btn { opacity: 1; top: -10px; right: -10px; transform: scale(1); }
        .edit-trigger-btn:hover { background: var(--theme-gold); color: white; }

        .click-to-read { transition: color 0.2s; cursor: pointer; }
        .click-to-read:hover { color: var(--theme-red) !important; }
        .reading-active { color: var(--theme-red) !important; border-left: 4px solid var(--theme-red); padding-left: 10px; margin-left: -14px; }
        
        .sentence-block:hover { background-color: rgba(255,255,255,0.5); border-radius: 8px; padding-left: 10px; padding-right: 10px; margin-left: -10px; margin-right: -10px; }
        .translation-text { transition: opacity 0.3s ease, height 0.3s ease, margin 0.3s ease; opacity: 1; }
        .translation-hidden { opacity: 0; height: 0; margin: 0 !important; overflow: hidden; }
        .custom-switch .form-check-input:checked { background-color: var(--theme-gold); border-color: var(--theme-gold); }
        .custom-scroll::-webkit-scrollbar { width: 6px; }
        .custom-scroll::-webkit-scrollbar-thumb { background: rgba(33, 37, 41, 0.2); border-radius: 10px; }
    </style>

    <div class="page-canvas mt-2">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <a href='ContentEditor.aspx?ContentId=<%= Request.QueryString["ContentId"] %>' class="btn btn-outline-dark-custom rounded-pill font-sans">
                <i class="fa-solid fa-arrow-left me-2"></i> Back to Overview Editor
            </a>
        </div>

        <div class="bg-white border rounded-4 d-flex align-items-center p-3 shadow-sm mb-5" style="border-color: var(--border-color) !important;">
            <div class="rounded-circle d-flex justify-content-center align-items-center me-3 flex-shrink-0 text-neutral" style="width: 42px; height: 42px; border: 2px solid var(--neutral-dark);">
                <i class="fa-solid fa-wand-magic-sparkles fs-6 text-gold"></i>
            </div>
            <div>
                <h6 class="fw-bold mb-1 text-neutral">Interactive Line-by-Line Editor</h6>
                <p class="mb-0 text-neutral opacity-75 small">
                    Hover over the Sentence or Vocabulary cards and <strong class="text-neutral">click the floating gold pencil icon</strong> to modify translations and annotations.
                </p>
            </div>
        </div>

        <div class="text-center border-bottom pb-4 mb-5" style="border-color: var(--border-color) !important;">
            <h1 class="fw-bold text-neutral mb-3 font-classic" style="letter-spacing: 3px;">
                <asp:Label ID="lblTitle" runat="server"></asp:Label>
            </h1>
            <div class="d-flex justify-content-center align-items-center">
                <span class="badge-outline-dark px-3 py-2 me-3 rounded-pill" style="font-size: 0.85rem; letter-spacing: 1px;">
                    <asp:Label ID="lblDynasty" runat="server"></asp:Label>
                </span>
                <i class="fa-solid fa-feather-pointed text-gold me-2" style="font-size: 0.9rem;"></i>
                <asp:HyperLink ID="lnkAuthor" runat="server" CssClass="text-decoration-none font-classic fs-5 text-neutral fw-bold" ToolTip="Edit Author Profile"></asp:HyperLink>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card shadow-sm border rounded-4 h-100 editable-wrapper bg-white" style="border-color: var(--border-color) !important;">
                    <button type="button" class="edit-trigger-btn" data-bs-toggle="modal" data-bs-target="#editSentencesModal" title="Edit Sentences & Translations"><i class="fa-solid fa-pencil"></i></button>

                    <div class="card-body p-4 p-md-5">
                        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom" style="border-color: var(--border-color) !important;">
                            <div class="d-flex align-items-center">
                                <i class="fa-solid fa-book-open-reader text-red me-2 fa-lg"></i>
                                <h5 class="fw-bold text-neutral mb-0 font-classic">Original Text</h5>
                            </div>
                            <div class="form-check form-switch custom-switch">
                                <input class="form-check-input border-neutral" type="checkbox" id="toggleTranslation" checked onchange="toggleTranslations()">
                                <label class="form-check-label small text-neutral fw-bold opacity-75" for="toggleTranslation" style="cursor: pointer;">Show English</label>
                            </div>
                        </div>

                        <asp:UpdatePanel ID="upDisplaySentences" runat="server" UpdateMode="Always">
                            <ContentTemplate>
                                <div class="study-content">
                                    <asp:Repeater ID="rptSentences" runat="server">
                                        <ItemTemplate>
                                            <div class="sentence-block mb-4 pb-3 border-bottom" style="border-color: rgba(33, 37, 41, 0.1) !important;">
                                                <h4 class="reading-text click-to-read text-neutral fw-bold mb-2 font-classic" onclick="speak(this, true)" title="Tap to listen" style="line-height: 1.8;">
                                                    <%# Eval("SentenceText") %>
                                                </h4>
                                                <p class="translation-text text-neutral opacity-75 mb-0" style="font-size: 1.05rem; line-height: 1.6;">
                                                    <%# Eval("Translate") %>
                                                </p>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card shadow-sm border rounded-4 sticky-top editable-wrapper mb-4 bg-white" style="top: 20px; z-index: 10; border-color: var(--border-color) !important;">
                    <button type="button" class="edit-trigger-btn" data-bs-toggle="modal" data-bs-target="#editVocabModal" title="Edit Vocabulary"><i class="fa-solid fa-pencil"></i></button>

                    <div class="card-header bg-white border-bottom pt-4 pb-3 px-4" style="border-color: var(--border-color) !important;">
                        <h5 class="fw-bold mb-0 text-neutral font-classic">
                            <i class="fa-solid fa-spell-check text-gold me-2"></i> Vocabulary List
                        </h5>
                    </div>
                    
                    <asp:UpdatePanel ID="upDisplayVocab" runat="server" UpdateMode="Always">
                        <ContentTemplate>
                            <div class="card-body p-0 custom-scroll" style="max-height: calc(100vh - 150px); overflow-y: auto;">
                                <ul class="list-group list-group-flush">
                                    <asp:Repeater ID="rptWords" runat="server">
                                        <ItemTemplate>
                                            <li class="list-group-item p-4 bg-transparent border-bottom" style="border-color: rgba(33, 37, 41, 0.1) !important;">
                                                <div class="d-flex justify-content-between align-items-baseline mb-1">
                                                    <h5 class="text-red mb-0 fw-bold click-to-read d-inline-block font-classic" onclick="speak(this.innerText, false)">
                                                        <%# Eval("Vocabulary") %>
                                                    </h5>
                                                    <span class="badge-outline-dark rounded-pill px-2 py-1 fw-normal font-sans" style="font-size: 0.75rem; letter-spacing: 1px;">
                                                        <%# Eval("Pinyin") %>
                                                    </span>
                                                </div>
                                                <div class="text-neutral opacity-75 mt-2 font-sans" style="font-size: 0.95rem; line-height: 1.5;">
                                                    <%# Eval("Annotations") %>
                                                </div>
                                            </li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editSentencesModal" data-bs-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header bg-white border-bottom" style="border-color: var(--border-color) !important;">
                    <h5 class="modal-title fw-bold text-neutral font-classic"><i class="fa-solid fa-book-open-reader text-red me-2"></i> Edit Sentences & Translations</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4 bg-white">
                    <asp:UpdatePanel ID="upSentencesGrid" runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="gvSentences" runat="server" CssClass="table table-bordered table-hover align-middle" 
                                AutoGenerateColumns="False" DataKeyNames="SentenceId" 
                                OnRowEditing="gvSentences_RowEditing" OnRowUpdating="gvSentences_RowUpdating" OnRowCancelingEdit="gvSentences_RowCancelingEdit">
                                <Columns>
                                    <asp:CommandField ShowEditButton="True" ControlStyle-CssClass="btn btn-sm btn-outline-dark-custom" />
                                    <asp:TemplateField HeaderText="Classical Text" ItemStyle-Width="40%">
                                        <ItemTemplate><%# Eval("SentenceText") %></ItemTemplate>
                                        <EditItemTemplate><asp:TextBox ID="txtClassical" runat="server" Text='<%# Bind("SentenceText") %>' CssClass="form-control border-neutral" TextMode="MultiLine" Rows="3"></asp:TextBox></EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="English Translation" ItemStyle-Width="50%">
                                        <ItemTemplate><%# Eval("Translate") %></ItemTemplate>
                                        <EditItemTemplate><asp:TextBox ID="txtEnglish" runat="server" Text='<%# Bind("Translate") %>' CssClass="form-control border-neutral" TextMode="MultiLine" Rows="3"></asp:TextBox></EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editVocabModal" data-bs-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header bg-white border-bottom" style="border-color: var(--border-color) !important;">
                    <h5 class="modal-title fw-bold text-neutral font-classic"><i class="fa-solid fa-spell-check text-gold me-2"></i> Edit Vocabulary</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4 bg-white">
                    <asp:UpdatePanel ID="upVocabGrid" runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="gvVocab" runat="server" CssClass="table table-bordered table-hover align-middle" 
                                AutoGenerateColumns="False" DataKeyNames="WordId" 
                                OnRowEditing="gvVocab_RowEditing" OnRowUpdating="gvVocab_RowUpdating" OnRowCancelingEdit="gvVocab_RowCancelingEdit">
                                <Columns>
                                    <asp:CommandField ShowEditButton="True" ControlStyle-CssClass="btn btn-sm btn-outline-dark-custom" />
                                    <asp:TemplateField HeaderText="Word" ItemStyle-Width="20%">
                                        <ItemTemplate><%# Eval("Vocabulary") %></ItemTemplate>
                                        <EditItemTemplate><asp:TextBox ID="txtVocab" runat="server" Text='<%# Bind("Vocabulary") %>' CssClass="form-control border-neutral"></asp:TextBox></EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Pinyin" ItemStyle-Width="20%">
                                        <ItemTemplate><%# Eval("Pinyin") %></ItemTemplate>
                                        <EditItemTemplate><asp:TextBox ID="txtPinyin" runat="server" Text='<%# Bind("Pinyin") %>' CssClass="form-control border-neutral"></asp:TextBox></EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Meaning" ItemStyle-Width="50%">
                                        <ItemTemplate><%# Eval("Annotations") %></ItemTemplate>
                                        <EditItemTemplate><asp:TextBox ID="txtMeaning" runat="server" Text='<%# Bind("Annotations") %>' CssClass="form-control border-neutral" TextMode="MultiLine" Rows="2"></asp:TextBox></EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentElement = null;
        function speak(source, isElement) {
            let text = isElement ? source.innerText : source;
            let el = isElement ? source : null;
            if (!('speechSynthesis' in window)) { return; }
            window.speechSynthesis.cancel();
            if (currentElement) { currentElement.classList.remove('reading-active'); }
            if (el) { currentElement = el; currentElement.classList.add('reading-active'); }
            let u = new SpeechSynthesisUtterance(text.trim());
            u.lang = 'zh-CN'; u.rate = 0.85;
            u.onend = function () { if (currentElement) currentElement.classList.remove('reading-active'); };
            window.speechSynthesis.speak(u);
        }
        function toggleTranslations() {
            const isChecked = document.getElementById('toggleTranslation').checked;
            document.querySelectorAll('.translation-text').forEach(el => {
                if (isChecked) el.classList.remove('translation-hidden');
                else el.classList.add('translation-hidden');
            });
        }
    </script>
</asp:Content>