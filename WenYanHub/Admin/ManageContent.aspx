<%@ Page Title="Manage Content" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageContent.aspx.cs" Inherits="WenYanHub.Admin.ManageContent" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfSelectedIds" runat="server" ClientIDMode="Static" />
    
    <asp:LinkButton ID="btnBulkReject" runat="server" OnClick="btnBulkReject_Click" CssClass="d-none"></asp:LinkButton>
    <asp:LinkButton ID="btnHiddenApprove" runat="server" OnClick="btnBulkApprove_Click" CssClass="d-none"></asp:LinkButton>

    <style>
        :root {
            --theme-beige: #E8E2D5;
            --theme-gold: #D4AF37;
            --theme-red: #8B0000;
            --neutral-dark: #212529;
            --bg-white: #FFFFFF;
            --border-soft: rgba(33, 37, 41, 0.15);
        }

        .text-neutral { color: var(--neutral-dark) !important; }
        .text-gold { color: var(--theme-gold) !important; }
        .text-red { color: var(--theme-red) !important; }

        .page-canvas { background-color: var(--theme-beige); border-radius: 24px; padding: 30px; margin: 20px; min-height: 75vh; }
        
        .btn-outline-dark-custom { background: transparent !important; color: var(--neutral-dark) !important; border: 2px solid var(--neutral-dark) !important; transition: 0.3s; font-weight: bold; border-radius: 50px; padding: 6px 20px;}
        .btn-outline-dark-custom:hover { border-color: var(--theme-gold) !important; color: var(--theme-gold) !important; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .btn-outline-danger-custom { background: transparent !important; color: var(--theme-red) !important; border: 2px solid var(--theme-red) !important; transition: 0.3s; font-weight: bold; border-radius: 50px; padding: 6px 20px;}
        .btn-outline-danger-custom:hover { background: var(--theme-red) !important; color: var(--bg-white) !important; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(139,0,0,0.15); }
        
        .badge-outline-dark { border: 1px solid var(--neutral-dark); color: var(--neutral-dark); background: transparent; font-weight: bold; }
        .badge-outline-red { border: 1px solid var(--theme-red); color: var(--theme-red); background: transparent; font-weight: bold; }
        .badge-outline-gold { border: 1px solid var(--theme-gold); color: var(--theme-gold); background: transparent; font-weight: bold; }

        .hover-drawer { width: 85px; background: var(--bg-white); border-radius: 40px; overflow: hidden; transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1); border: 2px solid var(--neutral-dark) !important; position: sticky; top: 20px; height: calc(100vh - 80px); min-height: 500px; z-index: 100; box-shadow: 0 4px 15px rgba(0,0,0,0.03); }
        .hover-drawer:hover { width: 280px; box-shadow: 0 15px 35px rgba(0,0,0,0.1) !important; z-index: 9999; border-color: var(--theme-gold) !important; border-radius: 24px; }
        .drawer-inner { padding: 20px 10px; width: 280px; display: flex; flex-direction: column; height: 100%; gap: 5px; }
        
        .nav-main-item { display: flex; align-items: center; padding: 8px 10px; border-radius: 50px; cursor: pointer; transition: 0.2s; background: transparent; border: none !important; }
        .nav-main-item:hover { background-color: rgba(33, 37, 41, 0.03); }
        .nav-icon { width: 45px; height: 45px; display: flex; justify-content: center; align-items: center; font-size: 1.4rem; flex-shrink: 0; }
        .nav-text { opacity: 0; margin-left: 5px; white-space: nowrap; transition: 0.2s; color: var(--neutral-dark); }
        .hover-drawer:hover .nav-text { opacity: 1; }
        .hollow-danger:hover { background-color: rgba(139, 0, 0, 0.03); }

        .library-parent .nav-sub-items { display: none; }
        .library-parent.open .nav-sub-items { display: block; }
        .library-parent.open .bi-chevron-down { transform: rotate(180deg); transition: 0.3s; }
        .tier-3-items { display: none; flex-direction: column; gap: 4px; padding-top: 4px; }
        .tier-2-group:hover .tier-3-items { display: flex; animation: slideIn 0.2s ease; }
        @keyframes slideIn { from { opacity: 0; transform: translateX(-5px); } to { opacity: 1; transform: translateX(0); } }
        .nested-item { display: block; padding: 6px 15px; color: var(--neutral-dark); opacity: 0.8; text-decoration: none; font-size: 0.85rem; border-radius: 8px; transition: 0.2s; border: none; }
        .nested-item:hover { opacity: 1; font-weight: bold; padding-left: 20px; color: var(--theme-gold); }

        .fixed-3-col-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
        .fixed-3-col-grid .module-card { height: 260px; min-height: 260px; cursor: pointer; position: relative; border-radius: 16px; }
        .fixed-3-col-grid .card-base-content { 
            display: flex; flex-direction: column; padding: 25px; transition: all 0.3s ease; z-index: 1; 
            background-color: var(--theme-beige) !important;
            border: 2px solid var(--neutral-dark) !important; 
            border-radius: 16px; height: 100%; box-shadow: 0 4px 10px rgba(0,0,0,0.05); 
        }
        .fixed-3-col-grid .card-base-content:hover { transform: translateY(-4px); box-shadow: 0 10px 25px rgba(212, 175, 55, 0.4) !important; filter: brightness(1.05); }
        
        .fixed-3-col-grid .card-tag-zone { display: none; } 
        .fixed-3-col-grid .card-meta-zone { display: flex; flex-direction: column; height: 100%; width: 100%; }
        .fixed-3-col-grid .title-block { text-align: center; margin-bottom: 15px; }
        .fixed-3-col-grid .author-date { display: flex; justify-content: center; gap: 15px; font-size: 0.85rem; margin-top: 8px; }
        .fixed-3-col-grid .desc-block { flex-grow: 1; overflow: hidden; }
        .description-clamp { display: -webkit-box; -webkit-line-clamp: 4; -webkit-box-orient: vertical; overflow: hidden; }

        .list-view-queue { display: flex; flex-direction: column; gap: 16px; }
        .list-view-queue .module-card { height: 160px !important; min-height: 160px !important; cursor: pointer; position: relative; border-radius: 12px; }
        .list-view-queue .card-base-content { 
            display: flex; flex-direction: row; align-items: center; padding: 20px 30px; transition: all 0.3s ease; height: 100%; box-sizing: border-box; 
            background-color: var(--theme-beige) !important; 
            border: 2px solid var(--neutral-dark) !important; 
            border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); 
        }
        .list-view-queue .card-base-content:hover { transform: translateX(4px); box-shadow: 0 8px 15px rgba(212, 175, 55, 0.4) !important; filter: brightness(1.05); }
        
        .list-view-queue .card-tag-zone { position: static; display: flex; flex-direction: column; gap: 8px; width: 170px; flex-shrink: 0; align-items: flex-start; justify-content: center; }
        .list-view-queue .card-meta-zone { display: flex; flex-direction: row; align-items: center; flex-grow: 1; padding: 0; margin-left: 20px; height: 100%; box-sizing: border-box; }
        .list-view-queue .title-block { width: 35%; display: flex; flex-direction: column; align-items: flex-start; justify-content: center; padding-right: 20px; height: 100%; border-right: 1px solid rgba(33,37,41,0.2); text-align: left; margin-bottom: 0; }
        .list-view-queue .author-date { justify-content: flex-start; margin-top: 5px; }
        .list-view-queue .desc-block { width: 65%; padding: 5px 20px; height: 110px; display: block !important; overflow-y: auto !important; margin: 0; box-sizing: border-box; }
        .list-view-queue .description-clamp { -webkit-line-clamp: unset !important; display: block; }
        .list-view-queue .desc-block::-webkit-scrollbar { width: 5px; }
        .list-view-queue .desc-block::-webkit-scrollbar-thumb { background: rgba(33, 37, 41, 0.4); border-radius: 10px; }
        .list-view-queue .hover-preview { display: none !important; } 

        .select-overlay { opacity: 0; pointer-events: none; transition: 0.2s; border-radius: 16px; }
        .selectable-card.selected .card-base-content { border: 3px solid var(--theme-red) !important; transform: scale(0.98); }
        .selectable-card.selected .select-overlay { opacity: 1; }
        .select-check-wrapper { width: 45px; height: 45px; background-color: white; border-radius: 50% !important; display: flex; align-items: center; justify-content: center; border: 2px solid var(--theme-red) !important; flex-shrink: 0; }
        .select-icon-color { color: var(--theme-red) !important; font-size: 1.8rem; line-height: 0; display: flex; align-items: center; }

        .hover-preview { position: absolute; top: 0; left: 0; width: 100%; height: 100%; z-index: 1050; opacity: 0; visibility: hidden; transform: scale(0.95); transition: 0.2s ease-out; pointer-events: none; box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15) !important; border: 2px solid var(--neutral-dark) !important; background: white; border-radius: 1rem; overflow: hidden; }
        .module-card:hover { z-index: 1000; }
        .content-grid-container:not(.hide-previews) .module-card:hover .hover-preview { opacity: 1; visibility: visible; transform: scale(1); pointer-events: auto; }
        .hide-previews .hover-preview { display: none !important; }
        
        .custom-chk-preview { width: 18px; height: 18px; cursor: pointer; transition: 0.2s; border: 2px solid var(--neutral-dark) !important; }
        .custom-chk-preview:checked { background-color: var(--theme-gold) !important; border-color: var(--theme-gold) !important; }
        .form-switch .form-check-input.custom-chk-switch { width: 2.8em !important; height: 1.4em !important; margin-top: 0; cursor: pointer; border: 2px solid var(--neutral-dark) !important; background-color: var(--bg-white); transition: 0.2s; }
        .form-switch .form-check-input.custom-chk-switch:checked { background-color: var(--theme-red) !important; border-color: var(--theme-red) !important; }
        
        * { -webkit-tap-highlight-color: transparent; }
        .user-select-none { -webkit-user-select: none !important; user-select: none !important; }
        input[type="checkbox"]:focus, .form-check-input:focus, .btn:focus, a:focus { box-shadow: none !important; outline: none !important; }
    </style>

    <div class="d-flex align-items-start gap-4 page-canvas">
        <aside class="hover-drawer flex-shrink-0">
            <div class="drawer-inner">
                <div class="nav-section" onclick="window.location.href='ManageContent.aspx?view=pending'">
                    <div class="nav-main-item hollow-danger text-red">
                        <span class="nav-icon"><i class="bi bi-exclamation-triangle"></i></span>
                        <span class="nav-text fw-bold">Pending Approvals</span>
                    </div>
                </div>

                <div class="nav-section library-parent mt-2" id="libraryMenuContainer">
                    <div class="nav-main-item text-neutral" onclick="document.getElementById('libraryMenuContainer').classList.toggle('open')">
                        <span class="nav-icon"><i class="bi bi-book text-gold"></i></span>
                        <span class="nav-text fw-bold d-flex justify-content-between align-items-center w-100 font-classic">
                            Library Classification
                            <i class="bi bi-chevron-down small text-neutral opacity-50 pe-2"></i>
                        </span>
                    </div>
                    
                    <div class="nav-sub-items ps-4 pt-1">
                        <div class="tier-2-group mb-2 position-relative">
                            <a href="ManageContent.aspx?cat=Junior" class="sub-link text-decoration-none d-block text-neutral fw-bold py-1 font-classic">初中 Junior High</a>
                            <div class="tier-3-items ps-3 border-start ms-2 flex-column gap-1 mt-1" style="border-color: rgba(33, 37, 41, 0.15) !important;">
                                <a href="ManageContent.aspx?cat=Junior 1" class="nested-item font-sans">Junior 1</a>
                                <a href="ManageContent.aspx?cat=Junior 2" class="nested-item font-sans">Junior 2</a>
                                <a href="ManageContent.aspx?cat=Junior 3" class="nested-item font-sans">Junior 3</a>
                            </div>
                        </div>
                        
                        <div class="tier-2-group mb-2 position-relative">
                            <a href="ManageContent.aspx?cat=Senior" class="sub-link text-decoration-none d-block text-neutral fw-bold py-1 font-classic">高中 Senior High</a>
                            <div class="tier-3-items ps-3 border-start ms-2 flex-column gap-1 mt-1" style="border-color: rgba(33, 37, 41, 0.15) !important;">
                                <a href="ManageContent.aspx?cat=Senior 1" class="nested-item font-sans">Senior 1</a>
                                <a href="ManageContent.aspx?cat=Senior 2" class="nested-item font-sans">Senior 2</a>
                                <a href="ManageContent.aspx?cat=Senior 3" class="nested-item font-sans">Senior 3</a>
                            </div>
                        </div>

                        <div class="tier-2-group mb-2 position-relative">
                            <a href="ManageContent.aspx?cat=ExtraCurricular" class="sub-link text-decoration-none d-block text-neutral fw-bold py-1 font-classic">课外 Extra Curricular</a>
                        </div>
                    </div>
                </div>

                <div class="nav-section mt-auto border-top pt-3" style="border-color: rgba(33, 37, 41, 0.15) !important;" onclick="window.location.href='ManageContent.aspx?view=rejected'">
                    <div class="nav-main-item hollow-danger text-red">
                        <span class="nav-icon"><i class="bi bi-x-circle"></i></span>
                        <span class="nav-text fw-bold">Rejected Content</span>
                    </div>
                </div>
                
                <div class="nav-section mt-2" onclick="window.location.href='ManageContent.aspx?view=archived'">
                    <div class="nav-main-item text-neutral">
                        <span class="nav-icon opacity-75"><i class="bi bi-archive"></i></span>
                        <span class="nav-text fw-bold">Archived Content</span>
                    </div>
                </div>
                
                <div class="nav-section mt-2" onclick="window.location.href='ManageContent.aspx?view=trash'">
                    <div class="nav-main-item hollow-danger text-red">
                        <span class="nav-icon"><i class="bi bi-trash3"></i></span>
                        <span class="nav-text fw-bold">Trash Bin</span>
                    </div>
                </div>
            </div>
        </aside>

        <section class="flex-grow-1 min-vw-0">
            <div class="bg-white p-4 rounded-4 shadow-sm" style="border: 2px solid var(--neutral-dark) !important;">
                
                <div class="d-flex justify-content-between align-items-center mb-4 px-2 flex-wrap gap-3">
                    <h3 class="fw-bold m-0 text-neutral font-classic">
                        <i class="bi bi-journal-album text-gold me-2"></i> <asp:Literal ID="litTitleHeader" runat="server" />
                    </h3>
                    
                    <% if (Request.QueryString["view"] == "pending") { %>
                        <div class="d-flex gap-3 small border rounded-pill px-3 py-1 shadow-sm bg-white" style="border-color: var(--neutral-dark) !important;">
                            <span class="fw-bold text-red"><i class="bi bi-circle-fill me-1"></i>Over 3 Days</span>
                            <span class="fw-bold text-gold"><i class="bi bi-circle-fill me-1"></i>New (Recent)</span>
                        </div>
                    <% } %>
                </div>
                
                <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 p-3 rounded-4 shadow-sm gap-3" style="background-color: var(--bg-white); border: 2px solid var(--neutral-dark) !important;">
                    <div class="d-flex flex-wrap align-items-center gap-3">
                        
                        <% if (Request.QueryString["view"] != "pending") { %>
                            <div class="d-flex align-items-center gap-2 border-end pe-3 user-select-none" style="border-color: rgba(33, 37, 41, 0.2) !important;">
                                <div>
                                    <label class="fw-bold text-neutral small text-uppercase mb-0 font-sans" style="cursor: pointer;" for="chkPreview">Preview Mode</label>
                                    <div style="font-size: 0.7rem; color: var(--neutral-dark); opacity: 0.7;">Hover cards for replica</div>
                                </div>
                                <input type="checkbox" id="chkPreview" class="form-check-input ms-0 custom-chk-preview" onchange="updateViewMode()" />
                            </div>

                            <div class="form-check form-switch p-0 m-0 d-flex align-items-center gap-2 border-end pe-3 user-select-none" style="border-color: rgba(33, 37, 41, 0.2) !important;">
                                <label class="fw-bold text-neutral small text-uppercase mb-0 font-sans" style="cursor: pointer;" for="chkSelectMode">Select Mode</label>
                                <input type="checkbox" id="chkSelectMode" class="form-check-input ms-0 custom-chk-switch" onchange="updateViewMode()" />
                            </div>
                        <% } else { %>
                            <div class="text-neutral small fw-bold font-sans border-end pe-3" style="border-color: rgba(33, 37, 41, 0.2) !important;">
                                <i class="bi bi-info-circle text-gold me-1"></i> Click a Lesson/Note to edit, or a Practice to open a Quick Ticket.
                            </div>
                        <% } %>

                        <div id="bulkActions" class="<%= Request.QueryString["view"] == "pending" ? "d-none" : "d-none" %> d-flex flex-wrap gap-2 align-items-center ps-1">
                            <asp:LinkButton ID="btnBulkApprove" runat="server" OnClick="btnBulkApprove_Click" CssClass="btn btn-sm action-pill font-classic btn-outline-dark-custom">Approve</asp:LinkButton>
                            <asp:LinkButton ID="btnBulkArchive" runat="server" OnClick="btnBulkArchive_Click" CssClass="btn btn-sm action-pill font-classic btn-outline-dark-custom">Archive</asp:LinkButton>
                            <asp:LinkButton ID="btnBulkRestore" runat="server" OnClick="btnBulkRestore_Click" OnClientClick="return confirm('Restore selected items to the Pending Queue?');" CssClass="btn btn-sm action-pill font-classic btn-outline-dark-custom">Restore</asp:LinkButton>
                            <asp:LinkButton ID="btnBulkDelete" runat="server" OnClick="btnBulkDelete_Click" OnClientClick="return confirm('Move selected to trash?');" CssClass="btn btn-sm action-pill font-classic btn-outline-danger-custom">Trash</asp:LinkButton>
                            <asp:LinkButton ID="btnBulkPermDelete" runat="server" OnClick="btnBulkPermDelete_Click" OnClientClick="return confirm('PERMANENT DELETE?');" CssClass="btn btn-sm action-pill font-classic btn-outline-danger-custom">Delete Forever</asp:LinkButton>
                        </div>
                    </div>
                    
                    <div class="text-neutral opacity-75 small font-sans fw-bold ms-auto mt-2 mt-xl-0">
                        Showing: <span class="text-neutral"><asp:Literal ID="litViewType" runat="server" /></span>
                    </div>
                </div>

                <div id="gridContainer" runat="server" class="fixed-3-col-grid content-grid-container hide-previews">
                    <asp:Repeater ID="rptContent" runat="server">
                        <ItemTemplate>
                            <div class="module-card position-relative selectable-card" 
                                 data-content-id='<%# Eval("TargetContentId") %>' 
                                 data-id='<%# Eval("Id") %>' 
                                 data-title='<%# Eval("Title").ToString().Replace("'", "&apos;") %>'
                                 data-type='<%# Eval("ItemType") %>'
                                 data-author='<%# Eval("AuthorName") %>'
                                 data-date='<%# Eval("CreatedAt", "{0:MMM dd, yyyy}") %>'
                                 data-preview='<%# Eval("PreviewText") != null ? Eval("PreviewText").ToString().Replace("'", "&apos;").Replace("\"", "&quot;") : "" %>'
                                 data-url='<%# Eval("FileUrl") != null ? Eval("FileUrl").ToString() : "" %>'
                                 onclick="handleCardClick(this, event)">
                                
                                <div class="card-base-content overflow-hidden" style='<%# ((bool)Eval("IsPending") ? "border-left: 8px solid " + Eval("PriorityColor") + " !important;" : "") %>'>
                                    
                                    <div class="card-tag-zone">
                                        <asp:PlaceHolder runat="server" Visible='<%# (bool)Eval("IsPending") %>'>
                                            <span class='badge <%# Eval("TypeClass") %> px-3 py-2 fs-6 rounded-pill w-100 text-center font-classic'>
                                                <i class="bi <%# Eval("TypeIcon") %> me-1 text-neutral"></i> <%# Eval("ItemType") %>
                                            </span>
                                            <span class='badge <%# Eval("PriorityBadgeClass") %> px-2 py-2 mt-2 w-100 text-center font-sans'>
                                                <i class="bi bi-lightning me-1"></i> <%# Eval("PriorityText") %>
                                            </span>
                                        </asp:PlaceHolder>
                                    </div>

                                    <div class="card-meta-zone">
                                        <div class="title-block">
                                            <h4 class="fw-bold text-neutral m-0" style="font-family: 'Noto Serif SC', serif; font-size: 1.6rem; letter-spacing: 2px;"><%# Eval("Title") %></h4>
                                            
                                            <div class="author-date text-neutral font-classic">
                                                <span class="text-neutral fw-bold"><i class="bi bi-person me-1"></i> <%# Eval("AuthorName") %></span>
                                                <span class="text-neutral opacity-75"><i class="bi bi-clock me-1"></i> <%# Eval("CreatedAt", "{0:MMM dd, yyyy}") %></span>
                                            </div>
                                        </div>
                                        
                                        <div class="desc-block">
                                            <p class="text-neutral opacity-100 font-classic description-clamp m-0" style="line-height: 1.8; text-indent: 2em; text-align: justify; font-size: 0.95rem; font-weight: 500;">
                                                <%# Eval("PreviewText") %>
                                            </p>
                                        </div>
                                    </div>

                                    <div class="select-overlay position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center">
                                        <div class="select-check-wrapper shadow-sm">
                                            <i class="bi bi-check-lg select-icon-color"></i>
                                        </div>
                                    </div>
                                </div>

                                <div class="hover-preview">
                                    <div class="position-relative d-flex flex-column align-items-center justify-content-center px-2" 
                                         style='<%# "background-image: url(" + (Eval("Picture") != null && !string.IsNullOrEmpty(Eval("Picture").ToString()) ? Eval("Picture") : "../Images/default-hero.jpg") + "); background-size: cover; background-position: center; border-bottom: 2px solid var(--neutral-dark); height: 80px;" %>'>
                                        
                                        <div class="position-absolute w-100 h-100" style="background-color: rgba(33, 37, 41, 0.6);"></div>
                                        
                                        <span class="badge border border-light text-light rounded-0 px-2 py-1 mb-1 position-relative z-1 font-sans bg-transparent" style="font-size: 0.45rem; letter-spacing: 1px;">LESSON OVERVIEW</span>
                                        <h5 class="position-relative z-1 fw-bold mb-1 text-center font-classic text-white w-100 text-truncate px-2" style="letter-spacing: 2px;"><%# Eval("Title") %></h5>
                                        <div class="position-relative z-1 text-gold font-classic" style="font-size: 0.6rem;">✦ 时代 | <%# Eval("AuthorName") %> ✦</div>
                                    </div>
                                    
                                    <div class="p-2 flex-grow-1 d-flex flex-column position-relative bg-white">
                                        <div class="position-absolute" style="right: 8px; top: 8px; font-family: 'KaiTi'; font-size: 3.5rem; color: var(--neutral-dark); opacity: 0.04; line-height: 1; pointer-events: none; z-index: 0;">文</div>
                                        
                                        <div class="d-flex align-items-center mb-1 position-relative z-1 px-1">
                                            <i class="fa-solid fa-scroll text-red me-1" style="font-size: 0.65rem;"></i>
                                            <span class="fw-bold text-neutral font-classic" style="font-size: 0.7rem;">Original Text</span>
                                        </div>
                                        <div class="p-1 px-2 rounded-2 position-relative z-1 flex-grow-1 bg-white mb-1" style="border: 1px dashed rgba(33, 37, 41, 0.2); overflow: hidden;">
                                            <p class="text-neutral m-0 font-classic opacity-75" style="font-size: 0.75rem; line-height: 1.6; text-indent: 1em; text-align: justify; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;"><%# Eval("PreviewText") %></p>
                                        </div>
                                    </div>
                                    
                                    <div class="px-2 pb-2 bg-white text-center">
                                        <span class="badge badge-outline-dark rounded-pill px-3 py-1 shadow-sm w-100">
                                           <i class="bi bi-pencil-square text-gold me-1"></i> VIEW DETAILS
                                        </span>
                                    </div>
                                </div>

                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </section>
    </div>

    <div class="modal fade" id="pendingItemModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content" style="border-radius: 20px; border: 2px solid var(--neutral-dark);">
                <div class="modal-header border-bottom-0 pb-0 pt-4 px-4">
                    <h4 class="modal-title fw-bold font-classic text-neutral" id="modalTitle">Ticket Title</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body row m-0 pt-2 pb-4 px-4">
                    
                    <div class="col-md-8 border-end" style="border-color: rgba(33, 37, 41, 0.15) !important;">
                        <div class="mb-3 text-muted small font-sans">
                            <span id="modalType" class="badge badge-outline-dark me-2">Type</span> 
                            Submitted by <strong id="modalAuthor" class="text-neutral">Author</strong> on <span id="modalDate">Date</span>
                        </div>
                        
                        <h6 class="fw-bold text-neutral font-sans mb-2">Practice Material:</h6>
                        <div class="p-3 rounded-3 mb-3 d-flex flex-column justify-content-center align-items-center text-center" style="background-color: var(--theme-beige); border: 2px dashed var(--neutral-dark); min-height: 120px;">
                            <div id="modalContentPreview" class="text-break font-sans w-100"></div>
                        </div>
                    </div>

                    <div class="col-md-4 d-flex flex-column gap-3 justify-content-center ps-md-4 mt-3 mt-md-0">
                        <h6 class="fw-bold text-neutral font-sans mb-1 text-center">Ticket Actions</h6>
                        
                        <button type="button" class="btn btn-outline-dark-custom w-100 d-flex align-items-center justify-content-center" onclick="approveSingleItem()">
                            <i class="bi bi-check-circle fs-5 me-2"></i> Approve
                        </button>
                        
                        <button type="button" class="btn btn-outline-danger-custom w-100 d-flex align-items-center justify-content-center" onclick="rejectSingleItem()">
                            <i class="bi bi-x-circle fs-5 me-2"></i> Reject
                        </button>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>

    <script>
        let selectedIds = [];
        let currentModalItemId = '';

        document.addEventListener("DOMContentLoaded", function () { updateViewMode(); });

        function updateViewMode() {
            const grid = document.querySelector('.content-grid-container');
            const bulkBar = document.getElementById('bulkActions');
            const previewChk = document.getElementById('chkPreview');
            const selectChk = document.getElementById('chkSelectMode');

            const previewOn = previewChk ? previewChk.checked : false;
            const selectOn = selectChk ? selectChk.checked : false;

            if (grid) {
                if (selectOn || !previewOn) grid.classList.add('hide-previews');
                else grid.classList.remove('hide-previews');

                if (selectOn) { grid.classList.add('select-mode-active'); if (bulkBar) bulkBar.classList.remove('d-none'); }
                else { grid.classList.remove('select-mode-active'); if (bulkBar) bulkBar.classList.add('d-none'); clearSelection(); }
            }
        }

        function handleCardClick(card, event) {
            const selectChk = document.getElementById('chkSelectMode');

            if (selectChk && selectChk.checked) {
                card.classList.toggle('selected');
                const id = card.getAttribute('data-id');
                if (card.classList.contains('selected')) selectedIds.push(id);
                else selectedIds = selectedIds.filter(x => x !== id);
                document.getElementById('hfSelectedIds').value = selectedIds.join(',');
            } else {
                const itemType = card.getAttribute('data-type');
                
                if (itemType === 'Practice Link') {
                    openPracticeModal(card); 
                } else {
                    window.location.href = 'ContentEditor.aspx?ContentId=' + card.getAttribute('data-content-id');
                }
            }
        }

        function openPracticeModal(card) {
            currentModalItemId = card.getAttribute('data-id');
            
            document.getElementById('modalTitle').innerText = card.getAttribute('data-title');
            document.getElementById('modalAuthor').innerText = card.getAttribute('data-author');
            document.getElementById('modalDate').innerText = card.getAttribute('data-date');
            document.getElementById('modalType').innerText = card.getAttribute('data-type');
            
            // 🔥 FIXED: Grab both the text AND the file URL
            const previewText = card.getAttribute('data-preview');
            const fileUrl = card.getAttribute('data-url');
            const previewContainer = document.getElementById('modalContentPreview');
            
            // First add the description
            let htmlContent = `<span>${previewText}</span>`;
            
            // If the URL exists, append a large button underneath the description!
            if (fileUrl && fileUrl.trim() !== '') {
                htmlContent += `<div class="mt-3"><a href="${fileUrl}" target="_blank" class="btn btn-dark rounded-pill px-4 fw-bold"><i class="bi bi-box-arrow-up-right me-2"></i>Open Practice Link</a></div>`;
            }
            
            previewContainer.innerHTML = htmlContent;
            
            const modal = new bootstrap.Modal(document.getElementById('pendingItemModal'));
            modal.show();
        }

        function approveSingleItem() {
            document.getElementById('hfSelectedIds').value = currentModalItemId;
            document.getElementById('<%= btnHiddenApprove.ClientID %>').click();
        }

        function rejectSingleItem() {
            document.getElementById('hfSelectedIds').value = currentModalItemId;
            document.getElementById('<%= btnBulkReject.ClientID %>').click();
        }

        function clearSelection() {
            selectedIds = [];
            const hf = document.getElementById('hfSelectedIds');
            if (hf) hf.value = '';
            document.querySelectorAll('.selectable-card').forEach(c => c.classList.remove('selected'));
        }
    </script>
</asp:Content>