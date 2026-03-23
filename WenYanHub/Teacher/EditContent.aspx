<%@ Page Title="Edit Content" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="EditContent.aspx.cs" Inherits="WenYanHub.Teacher.EditContent" validateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Make sure that the icons are displayed properly. */
        .fa-solid, .fa-scroll, .fa-pen-nib, .fa-book, .fa-floppy-disk, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
        /* Layout fix: Use Container for automatic centering */
        .edit-container { padding: 40px 0 60px 0; }

        /* Header Section: Replicating the Default Page Style */
        .header-banner {
            background-color: #1a1513;
            border-radius: 20px;
            padding: 50px 40px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            margin-bottom: 30px;
            text-align: center;
        }
        .header-bg {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.7), rgba(20, 15, 12, 0.9)), 
                              url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg');
            background-size: cover; background-position: center;
            z-index: 1;
        }
        .header-content { position: relative; z-index: 2; }

        /* Modern card layout */
        .form-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: none;
        }

        /* Unified icon color: Dark Brown (#2C2420) */
        .unified-icon { color: #2C2420 !important; margin-right: 10px; }

        .form-label { color: #2C2420; font-weight: 700; margin-bottom: 8px; display: block; font-size: 14px; }
        .section-divider {
            color: #2C2420;
            border-left: 5px solid #2C2420;
            padding-left: 15px;
            margin: 40px 0 20px;
            font-weight: bold;
        }

        .form-control-modern { border-radius: 8px; border: 1px solid #dee2e6; padding: 12px 15px; width: 100%; }

        /* Button style synchronization: Dark brown background, pure white text */
        .btn-submit-modern {
            background-color: #2C2420;
            color: #FFFFFF !important;
            padding: 14px 35px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            transition: 0.3s;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
        }
        .btn-submit-modern:hover { background-color: #1a1512; transform: translateY(-2px); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container edit-container">
        
        <div class="header-banner">
            <div class="header-bg"></div>
            <div class="header-content">
                <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                    <i class="fa-solid fa-pen-nib me-2" style="color: #FFFFFF;"></i> Upload or Edit Content
                </h2>
                <p class="lead opacity-75 mb-0">Refine the ancient scrolls for modern scholars.</p>
            </div>
        </div>

        <div class="form-card">
            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert d-block mb-4 p-3 rounded-3"></asp:Label>
            <asp:HiddenField ID="hfContentId" runat="server" />

            <div class="row g-4">
                <div class="col-md-6">
                    <label class="form-label">Title *</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control-modern" required="true"></asp:TextBox>
                </div>
                
                <div class="col-md-6">
                    <label class="form-label">Author Selection</label>
                    <asp:DropDownList ID="ddlAuthor" runat="server" CssClass="form-control-modern mb-2"></asp:DropDownList>
                    <div class="row g-2">
                        <div class="col-6"><asp:TextBox ID="txtNewAuthor" runat="server" CssClass="form-control-modern" placeholder="New Name"></asp:TextBox></div>
                        <div class="col-6"><asp:TextBox ID="txtNewDynasty" runat="server" CssClass="form-control-modern" placeholder="Dynasty"></asp:TextBox></div>
                    </div>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Category</label>
                    <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control-modern" placeholder="Junior High"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Genre</label>
                    <asp:TextBox ID="txtGenre" runat="server" CssClass="form-control-modern" placeholder="记"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Status</label>
                    <div class="p-2 border border-dashed rounded-3" style="background-color: #fffdf5;">
                        <asp:CheckBox ID="chkIsExtra" runat="server" Text="&nbsp; Extracurricular" Font-Bold="true" ForeColor="#2C2420" />
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Picture URL</label>
                    <asp:TextBox ID="txtPicture" runat="server" CssClass="form-control-modern" placeholder="https://..."></asp:TextBox>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Video URL</label>
                    <asp:TextBox ID="txtVideo" runat="server" CssClass="form-control-modern" placeholder="YouTube Link"></asp:TextBox>
                </div>
            </div>

            <h4 class="section-divider font-classic">
                <i class="fa-solid fa-scroll unified-icon"></i> Script & Analysis
            </h4>
            <div class="mb-4">
                <label class="form-label">Content Text *</label>
                <asp:TextBox ID="txtContentText" runat="server" CssClass="form-control-modern" TextMode="MultiLine" Rows="8" required="true"></asp:TextBox>
            </div>
            <div class="mb-4">
                <label class="form-label">Analysis / Background</label>
                <asp:TextBox ID="txtAnalysis" runat="server" CssClass="form-control-modern" TextMode="MultiLine" Rows="4"></asp:TextBox>
            </div>

            <h4 class="section-divider font-classic">
                <i class="fa-solid fa-book unified-icon"></i> Annotations & Translations
            </h4>
            <div class="row g-4 mb-5">
                <div class="col-md-6">
                    <label class="form-label">Vocabulary (Word | Meaning)</label>
                    <asp:TextBox ID="txtWordsBulk" runat="server" CssClass="form-control-modern" TextMode="MultiLine" Rows="6"></asp:TextBox>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Sentences (Sentence | Translation)</label>
                    <asp:TextBox ID="txtSentencesBulk" runat="server" CssClass="form-control-modern" TextMode="MultiLine" Rows="6"></asp:TextBox>
                </div>
            </div>

            <div class="text-center pt-4 border-top">
                <button type="submit" class="btn-submit-modern" runat="server" id="btnSaveLink" onserverclick="btnSave_Click">
                    <i class="fa-solid fa-floppy-disk me-2" style="color: #FFFFFF;"></i> Save & Submit for Approval
                </button>
                <asp:Button ID="btnSave" runat="server" Style="display:none;" OnClick="btnSave_Click" />
                <a href="ContentManage.aspx" class="ms-3 text-muted text-decoration-none">Cancel</a>
            </div>
        </div>
    </div>
</asp:Content>