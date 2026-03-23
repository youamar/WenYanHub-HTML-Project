<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WenYanHub.Account.Register" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="auth-wrapper">
        <div class="auth-card">
            
            <h2 class="auth-title">Join WenYan Hub</h2>
            <p class="auth-subtitle">Create your scholar account</p>

            <div class="form-floating mb-3">
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="User"></asp:TextBox>
                <label>Username</label>
            </div>
           <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="txtUsername" 
                ErrorMessage="Username is required" 
                CssClass="text-danger small fw-bold mb-2" 
                Display="Dynamic" ValidationGroup="RegGroup">
            </asp:RequiredFieldValidator>

            <asp:UpdatePanel ID="upEmail" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="input-group mb-1">
                        <div class="form-floating flex-grow-1">
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" style="border-top-right-radius: 0; border-bottom-right-radius: 0;"></asp:TextBox>
                            <label>Email Address</label>
                        </div>
                        <asp:Button ID="btnSendCode" runat="server"
                            Text="Get Code"
                            CssClass="btn btn-outline-secondary"
                            OnClick="btnSendCode_Click"
                            CausesValidation="false"
                            OnClientClick="var btn = this; setTimeout(function() { btn.disabled = true; btn.value = 'Sending...'; }, 10); return true;"
                            style="border-top-left-radius: 0; border-bottom-left-radius: 0;" />
                    </div>
                    <asp:Label ID="lblEmailMsg" runat="server" CssClass="small fw-bold mb-3 d-block" Visible="false"></asp:Label>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="text-danger small fw-bold mt-1" Display="Dynamic" ValidationGroup="RegGroup"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Invalid email format" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" CssClass="text-danger small fw-bold mt-1" Display="Dynamic" ValidationGroup="RegGroup"></asp:RegularExpressionValidator>
                </ContentTemplate>
            </asp:UpdatePanel>

            <div class="form-floating mb-3">
                <asp:TextBox ID="txtOTP" runat="server" CssClass="form-control" placeholder="Code"></asp:TextBox>
                <label>Verification Code</label>
            </div>
            <asp:RequiredFieldValidator ID="rfvOTP" runat="server" ControlToValidate="txtOTP" ErrorMessage="OTP Code is required" CssClass="text-danger small fw-bold mb-2" Display="Dynamic" ValidationGroup="RegGroup"></asp:RequiredFieldValidator>

            <div class="mb-3 position-relative">
                <div class="form-floating position-relative">
                    <asp:TextBox ID="txtPassword" runat="server" 
                        CssClass="form-control pe-5" 
                        TextMode="Password" 
                        placeholder="Pass"
                        onkeyup="checkStrength(this.value)">
                    </asp:TextBox>
                    <label>Password</label>

                    <i class="fa-regular fa-eye password-toggle"
                       onclick="togglePassword('<%= txtPassword.ClientID %>', this)"
                       style="position: absolute; right: 15px; top: 20px; cursor: pointer; color: #6c757d;">
                    </i>
                </div>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required" CssClass="text-danger small fw-bold mb-2" Display="Dynamic" ValidationGroup="RegGroup"></asp:RequiredFieldValidator>
                
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
                    <label>Confirm Password</label>
                </div>
                <asp:CompareValidator ID="cvPass" runat="server" ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword" ErrorMessage="❌ Passwords mismatch" CssClass="text-danger small fw-bold mt-1 ps-1" Display="Dynamic" ValidationGroup="RegGroup"></asp:CompareValidator>
                <asp:RequiredFieldValidator ID="rfvConfirm" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm your password" CssClass="text-danger small fw-bold mt-1 ps-1" Display="Dynamic" ValidationGroup="RegGroup"></asp:RequiredFieldValidator>
            </div>

            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert alert-danger d-block text-center border-0 bg-danger-subtle text-danger-emphasis mb-3"></asp:Label>

            <div class="d-grid mb-3">
                <asp:Button ID="btnRegister" runat="server" Text="Register Now" CssClass="btn btn-auth" OnClick="btnRegister_Click" ValidationGroup="RegGroup" OnClientClick="return enableValidation();" />
            </div>

            <div class="text-center">
                <span class="text-muted small">Already have an account? </span>
                <a href="Login.aspx<%= Request.QueryString["ReturnUrl"] != null ? "?ReturnUrl=" + Server.UrlEncode(Request.QueryString["ReturnUrl"]) : "" %>" class="text-decoration-none fw-bold" style="color: #8b0000;">Login Here</a>
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

        var isSubmitAttempted = false;

        function enableValidation() {
            isSubmitAttempted = true;

            if (typeof Page_ClientValidate === "function") {
                return Page_ClientValidate('RegGroup');
            }

            return true;
        }

        var checkAspNetLoaded = setInterval(function () {

            if (typeof ValidatorUpdateDisplay !== 'undefined' &&
                typeof ValidatorOnChange !== 'undefined') {

                clearInterval(checkAspNetLoaded);

                var originalUpdateDisplay = ValidatorUpdateDisplay;
                var originalOnChange = ValidatorOnChange;

                ValidatorOnChange = function (event) {
                    if (isSubmitAttempted) {
                        originalOnChange(event);
                    }
                };

                ValidatorUpdateDisplay = function (val) {

                    if (!isSubmitAttempted) {
                        val.style.display = "none";
                        return;
                    }

                    originalUpdateDisplay(val);

                    var control = document.getElementById(val.controltovalidate);
                    if (!control) return;

                    var isValid = true;

                    if (typeof Page_Validators !== 'undefined') {
                        for (var i = 0; i < Page_Validators.length; i++) {
                            if (Page_Validators[i].controltovalidate === val.controltovalidate &&
                                !Page_Validators[i].isvalid) {
                                isValid = false;
                                break;
                            }
                        }
                    }

                    if (control.value.trim() === "") {
                        control.classList.remove("is-valid");
                        control.classList.remove("is-invalid");
                        return;
                    }

                    if (isValid) {
                        control.classList.remove("is-invalid");
                        control.classList.add("is-valid");
                    } else {
                        control.classList.remove("is-valid");
                        control.classList.add("is-invalid");
                    }
                };

                if (typeof (Page_Validators) !== "undefined") {
                    for (var i = 0; i < Page_Validators.length; i++) {
                        Page_Validators[i].isvalid = true;
                        Page_Validators[i].style.display = "none";
                    }
                }

                document.addEventListener("DOMContentLoaded", function () {
                    if (typeof (Page_Validators) !== "undefined") {
                        for (var i = 0; i < Page_Validators.length; i++) {
                            Page_Validators[i].style.display = "none";
                        }
                    }
                });
            }

        }, 50);
    </script>
</asp:Content>