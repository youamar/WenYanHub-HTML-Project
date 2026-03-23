<%@ Page Title="Update Profile" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="UpdateProfile.aspx.cs" Inherits="WenYanHub.Teacher.UpdateProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Prevent the icons from being distorted into squares due to interference from the master page font. */
        .fa-solid, .fa-user-gear, .fa-floppy-disk, .fa-camera, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
        /* Layout: Use standard containers for automatic centering */
        .manage-container { padding: 40px 0 60px 0; min-height: 80vh; }

        /* Header Section: Dark ink banner synchronizing with ContentManage */
        .header-banner {
            background-color: #1a1513;
            border-radius: 20px;
            padding: 50px 40px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            margin-bottom: 30px;
            max-width: 900px; /* Limit the width to achieve alignment */
            margin-left: auto;
            margin-right: auto;
        }
        .header-bg {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.7), rgba(20, 15, 12, 0.9)), 
                              url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg');
            background-size: cover; background-position: center;
            z-index: 1;
        }
        .header-content { position: relative; z-index: 2; text-align: center; }

        /* Modification: The width of the form card is the same as that of the banner, achieving perfect alignment. */
        .profile-card {
            background: white;
            border-radius: 15px;
            padding: 45px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: none;
            max-width: 900px; /* Consistent with the header-banner */
            margin: 0 auto;   /* Force the level to be centered */
        }

        .avatar-section { text-align: center; margin-bottom: 40px; }
        .avatar-preview { 
            width: 140px; height: 140px; border-radius: 50%; 
            border: 4px solid #2C2420; 
            object-fit: cover; background: #f8f8f8;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .form-label { display: block; font-weight: 700; color: #2C2420; margin-bottom: 10px; text-transform: uppercase; font-size: 14px; letter-spacing: 1px; }

        .form-control { 
            width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 8px;
            box-sizing: border-box; margin-bottom: 25px; transition: 0.3s;
        }
        .form-control:focus { border-color: #2C2420; outline: none; box-shadow: 0 0 0 0.2rem rgba(44, 36, 32, 0.1); }

        .readonly-box { background: #f9f9f9; color: #888; cursor: not-allowed; }

        /* Submit button: Dark brown background (#2C2420) + Pure white text (#FFFFFF) */
        .btn-update-modern { 
            background: #2C2420 !important;
            color: #FFFFFF !important; 
            padding: 16px; border: 1px solid #4A3C31;
            font-weight: 600; cursor: pointer; width: 100%; border-radius: 8px;
            font-size: 16px; transition: 0.3s; display: inline-flex; align-items: center; justify-content: center;
        }
        .btn-update-modern:hover { background: #1a1512 !important; transform: translateY(-2px); }
        .btn-update-modern i { color: #FFFFFF !important; }

        .deco-line { border: 0; border-top: 1px dashed #e0d5c1; margin: 30px 0; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="manage-container">
        <div class="container">
            
            <div class="header-banner">
                <div class="header-bg"></div>
                <div class="header-content">
                    <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                        <i class="fa-solid fa-user-gear me-2" style="color: #FFFFFF;"></i> Profile Settings
                    </h2>
                    <p class="lead opacity-75 mb-0 text-white">Update your identity within the Classical Archive.</p>
                </div>
            </div>

            <div class="profile-card">
                <div class="avatar-section">
                    <asp:Image ID="imgAvatar" runat="server" CssClass="avatar-preview" ImageUrl="~/Images/default-avatar.png" />
                    <div class="mt-2 text-muted small"><i class="fa-solid fa-camera me-1"></i> Current Portrait</div>
                </div>

                <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="alert alert-info d-block text-center mb-4"></asp:Label>

                <div class="row">
                    <div class="col-md-6">
                        <label class="form-label">Username (Fixed)</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control readonly-box" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email Address (Fixed)</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control readonly-box" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="deco-line"></div>

                <div class="form-group">
                    <label class="form-label">Upload New Portrait Scroll</label>
                    <asp:FileUpload ID="fuProfilePic" runat="server" CssClass="form-control" />
                </div>

                <div class="form-group">
                    <label class="form-label">Contact Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Enter contact phone..."></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label">Update Access Secret (Password)</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Keep blank to retain current secret"></asp:TextBox>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn-update-modern" runat="server" id="btnUpdateLink" onserverclick="btnUpdate_Click">
                        <i class="fa-solid fa-floppy-disk me-2"></i> Save All Changes
                    </button>
                    <asp:Button ID="btnUpdate" runat="server" Style="display:none;" OnClick="btnUpdate_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>