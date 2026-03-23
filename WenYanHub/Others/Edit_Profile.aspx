<%@ Page Title="Edit Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Edit_Profile.aspx.cs" Inherits="WenYanHub.Others.Edit_Profile" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="profile-edit-container">
        <div class="profile-hero-bg" style="background-image: url('../Image/p8.jpeg');"></div>

        <div class="container px-4">
            <div class="profile-content-card shadow-lg">
                
                <div class="profile-header d-flex align-items-end">
                    <div class="avatar-wrapper">
                        <asp:Image ID="imgProfile" runat="server" CssClass="profile-avatar shadow" ImageUrl="~/Image/default_user.png" />
                        <label for="<%= fuProfilePic.ClientID %>" class="btn-edit-photo" title="Change Picture">
                            <i class="fa-solid fa-pencil"></i>
                        </label>
                        <asp:FileUpload ID="fuProfilePic" runat="server" style="display:none;" onchange="previewImage(this);" />
                    </div>
                    <div class="profile-info ms-4 mb-3">
                        <h3 class="fw-bold"><asp:Label ID="lblDisplayUsername" runat="server"></asp:Label></h3>
                        <p class="text-muted mb-0">Personalize your profile information</p>
                    </div>
                    <div class="ms-auto mb-3">
    <asp:LinkButton ID="btnSaveChanges" runat="server" OnClick="btnSaveChanges_Click" 
        CssClass="btn btn-save-custom rounded-pill px-4 shadow-sm">
        Save changes
    </asp:LinkButton>
</div>
                </div>

                <hr class="my-4 opacity-25" />

                <h5 class="text-secondary text-uppercase small ls-2 mb-4 fw-bold">Personal details</h5>
                
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label text-muted small fw-bold">Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control custom-input" ReadOnly="true" placeholder="Enter username"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label text-muted small fw-bold">Email address</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control custom-input" ReadOnly="true" placeholder="example@gmail.com"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label text-muted small fw-bold">Mobile number</label>
                            <asp:TextBox ID="txtContact" runat="server" CssClass="form-control custom-input" placeholder="+60 123456789"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <div class="mt-4">
                    <asp:Label ID="lblStatus" runat="server" CssClass="small"></asp:Label>
                </div>

            </div>
        </div>
    </div>

    <script>
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('<%= imgProfile.ClientID %>').src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>

    <style>
        .profile-edit-container { background-color: #f8f9fa; min-height: 100vh; padding-bottom: 50px; }
        .profile-hero-bg { 
    height: 250px;
    background-size: cover; 
    background-position: center; 
    mask-image: linear-gradient(to bottom, black 70%, transparent 100%);
}
        .profile-content-card { background: white; margin-top: -60px; border-radius: 15px; padding: 40px; position: relative; z-index: 5; }
        
        .avatar-wrapper { position: relative; width: 140px; height: 140px; margin-top: -110px; }
        .profile-avatar { width: 100%; height: 100%; border-radius: 50%; border: 5px solid white; object-fit: cover; background: #fff; }
        
        .btn-edit-photo { 
            position: absolute; bottom: 5px; right: 5px; 
            background: white; width: 35px; height: 35px; 
            border-radius: 50%; display: flex; align-items: center; justify-content: center; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.2); cursor: pointer; transition: 0.3s;
        }
        .btn-edit-photo:hover { background: #f0f0f0; transform: scale(1.1); }
        
        .custom-input { 
            padding: 12px 15px; border-radius: 8px; border: 1px solid #dee2e6; 
            background-color: #fafafa; transition: 0.3s;
        }
        .custom-input:focus { background-color: #fff; border-color: #0d6efd; box-shadow: none; }
        .ls-2 { letter-spacing: 1.5px; }

.btn-save-custom {
    background-color: #5d4037 !important; 
    color: #fdfbf7 !important;          
    border: none !important;
    font-weight: bold;
    transition: all 0.3s ease;
}

.btn-save-custom:hover {
    background-color: #3e2723 !important; 
    color: #ffffff !important;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(62, 39, 35, 0.4) !important;
}

/
.btn-save-custom:active {
    transform: translateY(0);
}

.profile-info h3, 
.form-label, 
.text-secondary.text-uppercase {
    color: #3e2723 !important; 
}

.profile-info p, 
.text-muted {
    color: #5d4037 !important;
}

.custom-input {
    color: #3e2723 !important;
}

.custom-input[readonly] {
    background-color: #f5f0eb !important; 
    color: #8c7b75 !important; 
    border-color: #d7ccc8 !important;
}

hr.opacity-25 {
    border-top: 1px solid #3e2723;
    opacity: 0.1 !important;
}
    </style>
</asp:Content>
