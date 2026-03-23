<%@ Page Title="Create Teacher" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CreateTeacher.aspx.cs" Inherits="WenYanHub.Admin.CreateTeacher" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        :root {
            --theme-beige: #E8E2D5;
            --theme-gold: #D4AF37;
            --theme-red: #8B0000;
            --neutral-dark: #212529;
            --bg-white: #FFFFFF;
            --border-color: rgba(33, 37, 41, 0.15);
        }

        .page-canvas { background-color: var(--theme-beige); border-radius: 24px; padding: 35px; margin: 20px; min-height: 75vh; }
        
        .text-neutral { color: var(--neutral-dark) !important; }
        .text-gold { color: var(--theme-gold) !important; }
        .text-red { color: var(--theme-red) !important; }

        .form-control { border: 1px solid var(--border-color); font-weight: 600; color: var(--neutral-dark); }
        .form-control:focus { border-color: var(--theme-gold); box-shadow: none; outline: none; }
        .form-label { font-weight: bold; color: var(--neutral-dark); opacity: 0.6; text-transform: uppercase; font-size: 0.75rem; }

        .btn-outline-gold-custom {
            background: transparent !important;
            border: 2px solid var(--theme-gold) !important;
            color: var(--theme-gold) !important;
            border-radius: 50px;
            padding: 12px 35px;
            font-weight: bold;
            transition: 0.3s;
            font-family: 'Noto Serif SC', serif;
        }
        .btn-outline-gold-custom:hover { background: var(--theme-gold) !important; color: var(--bg-white) !important; transform: translateY(-2px); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-canvas d-flex flex-column align-items-center justify-content-center">
        
        <div class="card shadow-sm border-0 rounded-4 p-5 w-100" style="max-width: 550px; background-color: var(--bg-white);">
            
            <div class="text-center mb-5 border-bottom pb-4" style="border-color: var(--border-color) !important;">
                <i class="bi bi-person-badge text-gold mb-3 d-block" style="font-size: 3rem;"></i>
                <h3 class="fw-bold text-neutral font-classic m-0">Teacher Registration</h3>
                <p class="text-neutral opacity-50 small mt-2 mb-0">Create a secure educator account for WenYanHub.</p>
            </div>

            <div class="mb-3 text-center">
                <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="fw-bold text-red d-block mb-3 p-2 rounded-3" style="border: 1px dashed var(--theme-red);"></asp:Label>
            </div>

            <div class="mb-4">
                <label class="form-label font-sans">Username</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control py-3 px-4 rounded-3" placeholder="Enter teacher username"></asp:TextBox>
            </div>

            <div class="mb-4">
                <label class="form-label font-sans">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control py-3 px-4 rounded-3" placeholder="email@example.com" TextMode="Email"></asp:TextBox>
            </div>

            <div class="mb-5">
                <label class="form-label font-sans">Temporary Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control py-3 px-4 rounded-3" placeholder="••••••••" TextMode="Password"></asp:TextBox>
                <div class="form-text mt-2 small text-neutral opacity-50 fw-bold font-sans"><i class="bi bi-shield-lock me-1"></i> BCrypt hashing applied automatically.</div>
            </div>

            <div class="d-grid gap-3">
                <asp:Button ID="btnCreateTeacher" runat="server" Text="Create Teacher Account" CssClass="btn-outline-gold-custom fs-5" OnClick="btnCreateTeacher_Click" />
                <a href="ManageUsers.aspx" class="text-center text-neutral text-decoration-none small fw-bold font-sans opacity-75 mt-2" style="transition: 0.2s;" onmouseover="this.style.color='#D4AF37'" onmouseout="this.style.color='#212529'">Cancel and Return</a>
            </div>
        </div>

    </div>
</asp:Content>