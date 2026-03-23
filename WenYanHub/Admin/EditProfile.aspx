<%@ Page Title="Edit Profile" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs" Inherits="WenYanHub.Admin.EditProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ==========================================
           0. ZERO BLUE & FOCUS OVERRIDES
           ========================================== */
        * { -webkit-tap-highlight-color: transparent; }
        .form-control:focus, .form-select:focus, .btn:focus, a:focus { 
            box-shadow: none !important; 
            outline: none !important; 
            border-color: var(--theme-gold) !important; 
        }
        ::selection { background-color: var(--theme-gold) !important; color: var(--bg-white) !important; }

        /* ==========================================
           1. STRICT PALETTE VARIABLES
           ========================================== */
        :root {
            --theme-beige: #E8E2D5;
            --theme-gold: #D4AF37;
            --theme-red: #8B0000;
            --neutral-dark: #212529; /* Strict Black/Grey Neutral */
            --bg-white: #FFFFFF;
            --border-soft: rgba(33, 37, 41, 0.15);
        }

        .text-neutral { color: var(--neutral-dark) !important; }
        .text-gold { color: var(--theme-gold) !important; }
        .text-red { color: var(--theme-red) !important; }

        .font-classic { font-family: 'Noto Serif SC', serif; }
        .font-sans { font-family: 'Segoe UI', Tahoma, sans-serif; }

        /* ==========================================
           2. CANVAS & PROFILE CARDS (Black Outlines)
           ========================================== */
        .dashboard-canvas { 
            background-color: var(--theme-beige) !important; 
            border-radius: 24px; 
            padding: 35px;
            margin: 20px;
            min-height: 75vh;
        }
        
        .profile-card { 
            background: var(--bg-white); 
            border-radius: 20px; 
            padding: 35px; 
            border: 2px solid var(--neutral-dark) !important; 
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.02); 
            height: 100%;
        }
        
        /* Avatar Image with Gold Border */
        .avatar-preview { 
            width: 180px; 
            height: 180px; 
            object-fit: cover; 
            border: 4px solid var(--theme-gold); 
            padding: 4px;
            box-shadow: 0 10px 25px rgba(212, 175, 55, 0.15); 
            background: var(--bg-white); 
            transition: all 0.3s ease; 
            margin-bottom: 20px;
        }
        .avatar-preview:hover {
            transform: scale(1.02);
            box-shadow: 0 15px 35px rgba(212, 175, 55, 0.25);
        }

        /* ==========================================
           3. ACTION BUTTONS (Hollow Outlines)
           ========================================== */
        .btn-outline-dark-custom { 
            background: transparent !important; 
            color: var(--neutral-dark) !important; 
            border: 2px solid var(--neutral-dark) !important; 
            transition: 0.3s; font-weight: bold; border-radius: 50px; padding: 10px 24px; 
            text-decoration: none; display: inline-block; text-align: center;
        }
        .btn-outline-dark-custom:hover { border-color: var(--theme-gold) !important; color: var(--theme-gold) !important; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        
        .btn-outline-danger-custom { 
            background: transparent !important; 
            color: var(--theme-red) !important; 
            border: 2px solid var(--theme-red) !important; 
            transition: 0.3s; font-weight: bold; border-radius: 50px; padding: 10px 24px; 
            text-decoration: none; display: inline-block; text-align: center;
        }
        .btn-outline-danger-custom:hover { background: var(--theme-red) !important; color: var(--bg-white) !important; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(139,0,0,0.15); }

        /* ==========================================
           4. ELEGANT FORMS (Black Outlines & Dashed Readonly)
           ========================================== */
        .form-label { font-weight: 800; color: var(--neutral-dark); opacity: 0.5; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; margin-bottom: 8px; }
        
        .form-control { 
            border: 2px solid var(--neutral-dark) !important; 
            border-radius: 12px;
            padding: 12px 16px;
            color: var(--neutral-dark);
            font-weight: 700;
            background: var(--bg-white);
            transition: 0.2s;
        }
        .form-control:focus { border-color: var(--theme-gold) !important; }
        
        .form-control[readonly] {
            background-color: rgba(33, 37, 41, 0.02) !important;
            border-style: dashed !important;
            color: var(--neutral-dark);
            opacity: 0.8;
            cursor: not-allowed;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="dashboard-canvas mt-2">
        <div class="d-flex justify-content-between align-items-end mb-4 border-bottom pb-4" style="border-color: var(--border-soft) !important;">
            <div>
                <h2 class="font-classic fw-bold mb-1 text-neutral"><i class="bi bi-person-badge-fill text-gold me-2"></i> Account Settings</h2>
                <p class="mb-0 fw-bold font-sans text-neutral opacity-75">Update your profile picture, contact details, and security credentials.</p>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-4">
                <div class="profile-card text-center d-flex flex-column align-items-center">
                    <h5 class="font-classic fw-bold text-neutral mb-2 w-100 text-start">Profile Picture</h5>
                    <p class="text-neutral opacity-75 small font-sans mb-4 border-bottom pb-3 w-100 text-start" style="border-color: var(--border-soft) !important;">Upload a clear image so users can identify you.</p>
                    
                    <asp:Image ID="imgAvatar" runat="server" CssClass="rounded-circle avatar-preview mb-3" ImageUrl="~/Images/default-avatar.png" />
                    
                    <div class="mb-4 text-start w-100 mt-2">
                        <label class="form-label">Upload New Image</label>
                        <asp:FileUpload ID="fuProfilePic" runat="server" CssClass="form-control font-sans" accept=".png,.jpg,.jpeg" onchange="previewAvatar(this);" />
                        <small class="text-neutral opacity-75 d-block mt-2 font-sans fw-bold"><i class="bi bi-info-circle text-gold me-1"></i> Max size: 2MB. Format: JPG, PNG.</small>
                    </div>

                    <div class="mt-auto w-100">
                        <asp:Button ID="btnUploadPic" runat="server" Text="Update Picture" CssClass="btn-outline-dark-custom w-100 font-classic" OnClick="btnUploadPic_Click" />
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="profile-card d-flex flex-column gap-5">
                    
                    <div>
                        <h5 class="font-classic fw-bold text-neutral mb-2">Personal Information</h5>
                        <p class="text-neutral opacity-75 small font-sans mb-4 border-bottom pb-3" style="border-color: var(--border-soft) !important;">
                            <i class="bi bi-lock-fill text-gold me-1"></i> Username and Email are locked for system security. You may update your contact number below.
                        </p>
                        
                        <div class="row g-4 mb-4 font-sans">
                            <div class="col-md-6">
                                <label class="form-label">Username (Read-Only)</label>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email Address (Read-Only)</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Account Role</label>
                                <asp:TextBox ID="txtRole" runat="server" CssClass="form-control text-gold" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Contact Number <span class="text-neutral opacity-50 text-lowercase ms-1">(Optional)</span></label>
                                <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" placeholder="+60 12-345 6789"></asp:TextBox>
                            </div>
                        </div>

                        <div class="text-end">
                            <asp:Button ID="btnSaveInfo" runat="server" Text="Save Contact Info" CssClass="btn-outline-dark-custom font-classic" OnClick="btnSaveInfo_Click" />
                        </div>
                    </div>

                    <div>
                        <h5 class="font-classic fw-bold text-neutral mb-2"><i class="bi bi-shield-check text-gold me-2"></i> Security Settings</h5>
                        <p class="text-neutral opacity-75 small font-sans mb-4 border-bottom pb-3" style="border-color: var(--border-soft) !important;">Ensure your account remains secure. Password must be at least 8 characters with 1 uppercase and 1 lowercase letter.</p>
                        
                        <div class="row g-4 font-sans mb-4">
                            <div class="col-md-4">
                                <label class="form-label">Current Password</label>
                                <asp:TextBox ID="txtOldPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">New Password</label>
                                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="revNewPassword" runat="server" ControlToValidate="txtNewPassword" 
                                    ValidationExpression="^(?=.*[a-z])(?=.*[A-Z]).{8,}$" 
                                    ErrorMessage="* Min 8 chars, 1 Upper, 1 Lower." 
                                    ValidationGroup="PasswordGroup" CssClass="text-red small fw-bold mt-2 d-block" Display="Dynamic">
                                </asp:RegularExpressionValidator>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Confirm Password</label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="text-end">
                            <asp:Button ID="btnChangePassword" runat="server" ValidationGroup="PasswordGroup" Text="Update Password" CssClass="btn-outline-danger-custom font-classic" OnClick="btnChangePassword_Click" />
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <script>
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('<%= imgAvatar.ClientID %>').src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</asp:Content>