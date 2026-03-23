<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WenYanHub.Account.Login" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success text-center fw-bold shadow-sm mb-4">
        🎉 Registration successful! Please log in with your new account.
    </asp:Panel>

    <div class="auth-wrapper">
        <div class="auth-card">
            
            <h2 class="auth-title">Welcome Back</h2>
            <p class="auth-subtitle">Please sign in to continue</p>

            <div class="form-floating mb-3">
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="User"></asp:TextBox>
                <label>Email or Username</label>
            </div>

            <div class="mb-4 position-relative">
                <div class="form-floating">
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Pass"></asp:TextBox>
                    <label>Password</label>
                </div>
                <i class="fa-regular fa-eye password-toggle" onclick="togglePassword('<%= txtPassword.ClientID %>', this)"></i>
            </div>

            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert alert-danger d-block text-center mb-3 border-0 bg-danger-subtle text-danger-emphasis"></asp:Label>

            <div class="text-end mb-3">
                <a href="ForgotPassword.aspx" class="text-decoration-none small fw-bold text-muted hover-red">Forgot Password?</a>
            </div>

            <div class="d-grid mb-3">
                <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn btn-auth" OnClick="btnLogin_Click" />
            </div>

            <div class="text-center">
                <span class="text-muted small">Don't have an account? </span>
                <a href="Register.aspx<%= Request.QueryString["ReturnUrl"] != null ? "?ReturnUrl=" + Server.UrlEncode(Request.QueryString["ReturnUrl"]) : "" %>" class="text-decoration-none fw-bold" style="color: #8b0000;">Register Free</a>
            </div>

        </div>
    </div>

    <script>
        function togglePassword(inputId, icon) {
            var input = document.getElementById(inputId);
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                input.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }
    </script>

</asp:Content>