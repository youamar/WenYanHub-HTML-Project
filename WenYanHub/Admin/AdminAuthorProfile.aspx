<%@ Page Title="Edit Author" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminAuthorProfile.aspx.cs" Inherits="WenYanHub.Admin.AdminAuthorProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        :root {
            --theme-beige: #E8E2D5;
            --theme-gold: #D4AF37;
            --theme-red: #8B0000;
            --neutral-dark: #212529;
            --bg-white: #FFFFFF;
        }

        .page-canvas {
            background-color: var(--theme-beige);
            border-radius: 24px;
            padding: 35px;
            margin: 20px;
            min-height: calc(100vh - 120px);
        }

        .author-card {
            background: var(--bg-white);
            border: 1px solid rgba(33,37,41,0.15);
            border-radius: 20px;
            overflow: hidden;
        }

        /* Image Border is Gold */
        .author-img-preview { 
            width: 160px; height: 160px; border-radius: 50%; 
            object-fit: cover; border: 4px solid var(--theme-gold); 
            box-shadow: 0 8px 25px rgba(212, 175, 55, 0.2); 
        }

        /* 🔥 FIX: HOLLOW ACTION BUTTON IS RED 🔥 */
        .btn-outline-danger-custom {
            background: transparent !important;
            border: 2px solid var(--theme-red) !important;
            color: var(--theme-red) !important;
            border-radius: 50px;
            padding: 10px 35px;
            font-weight: bold;
            transition: 0.2s;
            font-family: 'Noto Serif SC', serif;
        }
        .btn-outline-danger-custom:hover { background: var(--theme-red) !important; color: var(--bg-white) !important; transform: translateY(-2px); }

        .btn-hollow-dark-pill {
            border: 2px solid var(--neutral-dark);
            color: var(--neutral-dark);
            background: transparent;
            border-radius: 50px;
            padding: 6px 20px;
            font-weight: bold;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: 0.2s;
        }
        .btn-hollow-dark-pill:hover { border-color: var(--theme-gold); color: var(--theme-gold); }

        /* 🔥 FIX: Textboxes are Neutral Dark, Focus is Gold (Not Red) 🔥 */
        .form-label { font-weight: bold; color: var(--neutral-dark); opacity: 0.6; text-transform: uppercase; font-size: 0.75rem; }
        .form-control { border: 1px solid rgba(33,37,41,0.1); font-weight: 600; color: var(--neutral-dark); }
        .form-control:focus { border-color: var(--theme-gold); box-shadow: none; }
        
        .text-neutral { color: var(--neutral-dark) !important; }
        .text-gold { color: var(--theme-gold) !important; }
        .text-red { color: var(--theme-red) !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-canvas mt-2">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <asp:HyperLink ID="lnkBack" runat="server" CssClass="btn-hollow-dark-pill">
                <i class="bi bi-arrow-left me-2"></i> Back to Editor
            </asp:HyperLink>
            
            <h3 class="fw-bold m-0 font-classic text-neutral"><i class="bi bi-person-badge text-gold me-2"></i> Author Profile Editor</h3>
        </div>

        <div class="row g-4">
            <div class="col-lg-4">
                <div class="author-card p-4 text-center h-100 shadow-sm">
                    <asp:Image ID="imgPreview" runat="server" CssClass="author-img-preview mb-4" ImageUrl="~/Images/default_author.png" />
                    
                    <div class="text-start">
                        <label class="form-label">Image URL Source</label>
                        <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control rounded-3 mb-3 shadow-sm" placeholder="Paste URL..."></asp:TextBox>

                        <label class="form-label">Historical Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control rounded-3 mb-3 shadow-sm font-classic fw-bold fs-5"></asp:TextBox>

                        <label class="form-label">Dynasty / Era</label>
                        <asp:TextBox ID="txtDynasty" runat="server" CssClass="form-control rounded-3 mb-3 font-classic"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="author-card p-4 h-100 d-flex flex-column shadow-sm">
                    <h5 class="fw-bold font-classic text-neutral mb-3 border-bottom pb-3"><i class="bi bi-feather text-gold me-2"></i> Historical Biography</h5>
                    
                    <asp:TextBox ID="txtBiography" runat="server" TextMode="MultiLine" Rows="12" 
                        CssClass="form-control rounded-4 p-4 flex-grow-1 mb-4 font-classic" 
                        style="resize: none; line-height: 1.8; text-indent: 2em; text-align: justify; background: #fcfcfc;"></asp:TextBox>

                    <div class="text-end">
                        <asp:Button ID="btnSave" runat="server" Text="Update Author Profile" CssClass="btn-outline-danger-custom shadow-sm" OnClick="btnSave_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-4">
            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert border-success text-success d-block fw-bold text-center rounded-4 bg-white shadow-sm"></asp:Label>
        </div>
    </div>
</asp:Content>