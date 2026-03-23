<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="WenYanHub.Account.ForgotPassword" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-wrapper">
        <div class="auth-card">
            
            <h2 class="auth-title">Reset Password</h2>
            <p class="auth-subtitle">Verify your identity to create a new password</p>

            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert alert-danger d-block text-center border-0 bg-danger-subtle text-danger-emphasis mb-3"></asp:Label>

            <asp:Panel ID="pnlStep1" runat="server">
                <div class="form-floating mb-3">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" TextMode="Email"></asp:TextBox>
                    <label>Registered Email Address</label>
                </div>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="text-danger small fw-bold d-block mb-3" Display="Dynamic" ValidationGroup="Step1"></asp:RequiredFieldValidator>

                <div class="d-grid mb-3">
                    <asp:Button ID="btnSendOTP" runat="server" Text="Send Recovery Code" CssClass="btn btn-auth" OnClick="btnSendOTP_Click" ValidationGroup="Step1" />
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlStep2" runat="server" Visible="false">
                <div class="alert alert-success text-center small fw-bold mb-4 border-0">
                    <i class="fa-solid fa-envelope-circle-check me-1"></i> Code sent! Please check your inbox.
                </div>

                <div class="form-floating mb-3">
                    <asp:TextBox ID="txtOTP" runat="server" CssClass="form-control" placeholder="Code"></asp:TextBox>
                    <label>6-Digit Verification Code</label>
                </div>
                <asp:RequiredFieldValidator ID="rfvOTP" runat="server" ControlToValidate="txtOTP" ErrorMessage="OTP is required" CssClass="text-danger small fw-bold d-block mb-2" Display="Dynamic" ValidationGroup="Step2"></asp:RequiredFieldValidator>

                <div class="mb-3 position-relative">
                    <div class="form-floating position-relative">
                        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control pe-5" TextMode="Password" placeholder="New Pass" onkeyup="checkStrength(this.value)"></asp:TextBox>
                        <label>New Password</label>
                        <i class="fa-regular fa-eye password-toggle" onclick="togglePassword('<%= txtNewPassword.ClientID %>', this)" style="position: absolute; right: 15px; top: 20px; cursor: pointer; color: #6c757d;"></i>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword" ErrorMessage="New password is required" CssClass="text-danger small fw-bold d-block mb-1" Display="Dynamic" ValidationGroup="Step2"></asp:RequiredFieldValidator>
                    
                    <div class="mt-2">
                        <div class="progress" style="height: 5px;">
                            <div id="strengthBar" class="progress-bar" role="progressbar" style="width: 0%; background-color: #e0e0e0;"></div>
                        </div>
                        <small id="strengthText" class="text-muted mt-1 d-block fw-bold"></small>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="form-floating">
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm"></asp:TextBox>
                        <label>Confirm New Password</label>
                    </div>
                    <asp:CompareValidator ID="cvPass" runat="server" ControlToCompare="txtNewPassword" ControlToValidate="txtConfirmPassword" ErrorMessage="❌ Passwords mismatch" CssClass="text-danger small fw-bold mt-1 ps-1" Display="Dynamic" ValidationGroup="Step2"></asp:CompareValidator>
                    <asp:RequiredFieldValidator ID="rfvConfirm" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm your password" CssClass="text-danger small fw-bold mt-1 ps-1" Display="Dynamic" ValidationGroup="Step2"></asp:RequiredFieldValidator>
                </div>

                <div class="d-grid mb-3">
                    <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" CssClass="btn btn-success fw-bold py-2" OnClick="btnResetPassword_Click" ValidationGroup="Step2" />
                </div>
            </asp:Panel>

            <div class="text-center mt-3">
                <a href="Login.aspx" class="text-decoration-none fw-bold" style="color: #6c757d;"><i class="fa-solid fa-arrow-left me-1"></i> Back to Login</a>
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

        function checkStrength(password) {
            var strengthBar = document.getElementById('strengthBar');
            var strengthText = document.getElementById('strengthText');
            var strength = 0;
            if (password.length >= 8) strength++;
            if (password.match(/[a-z]/)) strength++;
            if (password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;

            if (strength == 0) {
                strengthBar.style.width = '0%'; strengthBar.style.backgroundColor = '#e0e0e0';
                strengthText.innerText = "";
            } else if (strength <= 2) {
                strengthBar.style.width = '30%'; strengthBar.style.backgroundColor = '#dc3545';
                strengthText.innerText = "Weak"; strengthText.style.color = '#dc3545';
            } else if (strength == 3) {
                strengthBar.style.width = '60%'; strengthBar.style.backgroundColor = '#ffc107';
                strengthText.innerText = "Medium"; strengthText.style.color = '#ffc107';
            } else {
                strengthBar.style.width = '100%'; strengthBar.style.backgroundColor = '#198754';
                strengthText.innerText = "Strong"; strengthText.style.color = '#198754';
            }
        }
    </script>
</asp:Content>