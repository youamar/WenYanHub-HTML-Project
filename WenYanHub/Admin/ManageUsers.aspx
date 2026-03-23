<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="WenYanHub.Admin.ManageUsers" %>

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
            --border-color: rgba(33, 37, 41, 0.15);
        }

        .text-neutral { color: var(--neutral-dark) !important; }
        .text-gold { color: var(--theme-gold) !important; }
        .text-red { color: var(--theme-red) !important; }

        .font-classic { font-family: 'Noto Serif SC', serif; }
        .font-sans { font-family: 'Segoe UI', Tahoma, sans-serif; }

        /* PAGE CANVAS */
        .page-canvas { background-color: var(--theme-beige); border-radius: 24px; padding: 35px; margin: 20px; min-height: 75vh; }

        /* ==========================================
           2. HOLLOW BUTTONS & BADGES
           ========================================== */
        .btn-outline-dark-custom { 
            background: transparent !important; 
            color: var(--neutral-dark) !important; 
            border: 2px solid var(--neutral-dark) !important; 
            transition: 0.3s; font-weight: bold; border-radius: 50px; padding: 8px 24px; 
            text-decoration: none; display: inline-flex; align-items: center; justify-content: center;
        }
        .btn-outline-dark-custom:hover { border-color: var(--theme-gold) !important; color: var(--theme-gold) !important; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        
        .btn-outline-danger-custom { 
            background: transparent !important; 
            color: var(--theme-red) !important; 
            border: 2px solid var(--theme-red) !important; 
            transition: 0.3s; font-weight: bold; border-radius: 50px; padding: 8px 24px; 
            text-decoration: none; display: inline-flex; align-items: center; justify-content: center;
        }
        .btn-outline-danger-custom:hover { background: var(--theme-red) !important; color: var(--bg-white) !important; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(139,0,0,0.15); }

        /* Action Icons for Table Rows */
        .btn-icon-dark {
            width: 38px; height: 38px; border-radius: 50%; border: 2px solid var(--neutral-dark); color: var(--neutral-dark); background: transparent; display: inline-flex; align-items: center; justify-content: center; transition: 0.3s;
        }
        .btn-icon-dark:hover { border-color: var(--theme-gold); color: var(--theme-gold); transform: translateY(-2px); }
        
        .btn-icon-danger {
            width: 38px; height: 38px; border-radius: 50%; border: 2px solid var(--theme-red); color: var(--theme-red); background: transparent; display: inline-flex; align-items: center; justify-content: center; transition: 0.3s;
        }
        .btn-icon-danger:hover { background: var(--theme-red); color: var(--bg-white); transform: translateY(-2px); }

        /* Hollow Badges */
        .badge-outline-dark { border: 1px solid var(--neutral-dark); color: var(--neutral-dark); background: transparent; font-weight: bold; }
        .badge-outline-red { border: 1px solid var(--theme-red); color: var(--theme-red); background: transparent; font-weight: bold; }
        .badge-outline-gold { border: 1px solid var(--theme-gold); color: var(--theme-gold); background: transparent; font-weight: bold; }

        /* ==========================================
           3. TABLE STYLING
           ========================================== */
        .user-table-container {
            border: 2px solid var(--neutral-dark) !important;
            border-radius: 16px;
            overflow: hidden;
            background-color: var(--bg-white);
            box-shadow: 0 4px 20px rgba(0,0,0,0.02);
        }
        .user-table th { 
            font-size: 0.8rem; letter-spacing: 1px; color: var(--neutral-dark); opacity: 0.8;
            border-bottom: 2px solid var(--neutral-dark) !important; padding: 1.2rem 1.5rem; background: var(--bg-white); font-weight: 700; text-transform: uppercase;
        }
        .user-table td { padding: 1.2rem 1.5rem; vertical-align: middle; border-bottom: 1px solid var(--border-color); color: var(--neutral-dark); font-weight: 600; }
        .user-table tr:hover { background-color: rgba(33, 37, 41, 0.02); }
        .user-table tr:last-child td { border-bottom: none; }

        /* Filter Checkboxes */
        .elegant-filter input[type="checkbox"] { width: 18px; height: 18px; cursor: pointer; margin-top: 0; border: 2px solid var(--neutral-dark); transition: 0.2s; }
        .elegant-filter input[type="checkbox"]:checked { background-color: var(--theme-gold); border-color: var(--theme-gold); }
        .elegant-filter label { cursor: pointer; padding-top: 2px; }

        /* ELEGANT MODAL INPUTS */
        .modal-input-outline {
            border: 2px solid var(--neutral-dark) !important;
            border-radius: 12px !important;
            padding: 12px 16px;
            background-color: transparent !important;
            color: var(--neutral-dark) !important;
            font-weight: 700;
            transition: 0.2s;
        }
        .modal-input-outline:focus {
            border-color: var(--theme-gold) !important;
        }
        .modal-input-outline[readonly] {
            border-style: dashed !important;
            opacity: 0.6;
            cursor: not-allowed;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfEditUserId" runat="server" ClientIDMode="Static" />

    <div class="page-canvas">
        
        <div class="d-flex justify-content-between align-items-center mb-4 px-2 flex-wrap gap-3">
            <div>
                <h3 class="fw-bold mb-1 text-neutral font-classic"><i class="bi bi-people-fill text-gold me-2"></i> User Management</h3>
                <p class="text-neutral opacity-75 small mb-0 font-sans fw-bold">Manage permissions, accounts, and system access.</p>
            </div>
            
            <div class="d-flex gap-3 align-items-center flex-wrap">
                
                <div class="input-group shadow-sm bg-white" style="width: 450px; border: 2px solid var(--neutral-dark); border-radius: 50px; overflow: hidden; padding: 4px;">
                    <span class="input-group-text bg-white border-0 ps-3 pe-2"><i class="bi bi-search text-neutral opacity-50"></i></span>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-0 py-2 text-neutral fw-bold font-sans shadow-none" placeholder="Search user by name or email..." AutoPostBack="true" OnTextChanged="ApplyFilters"></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn fw-bold font-classic text-neutral px-4" style="border: none !important; transition: 0.2s;" onmouseover="this.style.color='var(--theme-gold)'" onmouseout="this.style.color='var(--neutral-dark)'" OnClick="ApplyFilters" />
                </div>
                
                <asp:LinkButton ID="btnAddUser" runat="server" OnClientClick="openAddModal(); return false;" CssClass="btn-outline-dark-custom shadow-sm font-classic">
                    <i class="bi bi-person-plus text-gold me-2 fs-5"></i> Add User
                </asp:LinkButton>
            </div>
        </div>

        <div class="d-flex align-items-center bg-white p-2 px-4 rounded-pill shadow-sm mb-4 d-inline-flex gap-4 elegant-filter" style="border: 2px solid var(--neutral-dark) !important; width: fit-content;">
            <span class="text-neutral opacity-75 small fw-bold text-uppercase border-end pe-4 font-sans" style="border-color: rgba(33, 37, 41, 0.2) !important;">
                <i class="bi bi-funnel text-gold me-1"></i> Filter Roles
            </span>
            
            <div class="d-flex align-items-center gap-2">
                <asp:CheckBox ID="chkFilterAdmin" runat="server" Checked="true" AutoPostBack="true" OnCheckedChanged="ApplyFilters" CssClass="form-check-input m-0" />
                <label class="fw-bold small text-neutral mb-0 me-3 font-sans" onclick="document.getElementById('<%= chkFilterAdmin.ClientID %>').click()">Admin</label>
            </div>

            <div class="d-flex align-items-center gap-2">
                <asp:CheckBox ID="chkFilterTeacher" runat="server" Checked="true" AutoPostBack="true" OnCheckedChanged="ApplyFilters" CssClass="form-check-input m-0" />
                <label class="fw-bold small text-neutral mb-0 me-3 font-sans" onclick="document.getElementById('<%= chkFilterTeacher.ClientID %>').click()">Teacher</label>
            </div>

            <div class="d-flex align-items-center gap-2">
                <asp:CheckBox ID="chkFilterMember" runat="server" Checked="true" AutoPostBack="true" OnCheckedChanged="ApplyFilters" CssClass="form-check-input m-0" />
                <label class="fw-bold small text-neutral mb-0 font-sans" onclick="document.getElementById('<%= chkFilterMember.ClientID %>').click()">Member</label>
            </div>
        </div>

        <div class="user-table-container mb-4">
            <table class="table user-table w-100 m-0 font-sans">
                <thead>
                    <tr class="font-classic">
                        <th style="width: 25%;">Username</th>
                        <th style="width: 15%;">User Role</th>
                        <th style="width: 25%;">Email Address</th>
                        <th style="width: 20%;">Joined Date</th>
                        <th style="width: 15%;" class="text-end pe-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td class="fw-bold text-neutral">
                                    <div class="d-flex align-items-center gap-3">
                                        <img src='<%# Eval("ProfilePic") %>' alt="Avatar" style="width: 35px; height: 35px; object-fit: cover; border-radius: 50%; border: 2px solid var(--neutral-dark);" />
                                        <%# Eval("Username") %>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge px-3 py-1 rounded-pill <%# Eval("RoleBadgeClass") %> font-classic" style="letter-spacing: 0.5px;">
                                        <%# Eval("Role") %>
                                    </span>
                                </td>
                                <td class="text-neutral opacity-75 small fw-bold"><%# Eval("MailAddress") %></td>
                                <td class="text-neutral opacity-75 small fw-bold"><%# Eval("JoinedDate") %></td>
                                
                                <td class="text-end pe-4">
                                    <div class="d-inline-flex gap-2">
                                        <button type="button" class="btn-icon-dark shadow-sm" 
                                                onclick='openEditModal("<%# Eval("UserId") %>", "<%# Eval("Username") %>", "<%# Eval("Role") %>", "<%# Eval("MailAddress") %>")'
                                                title="Edit User">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteUser" CommandArgument='<%# Eval("UserId") %>' 
                                                        OnClientClick="return confirm('Are you sure you want to permanently delete this user?');" 
                                                        CssClass="btn-icon-danger shadow-sm" title="Delete User">
                                            <i class="bi bi-trash3"></i>
                                        </asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
            
            <asp:PlaceHolder ID="phNoUsers" runat="server" Visible="false">
                <div class="text-center py-5 text-neutral opacity-50 font-classic bg-white">
                    <i class="bi bi-people fs-1 d-block mb-3"></i>
                    <h5 class="fw-bold">No users found matching your criteria.</h5>
                </div>
            </asp:PlaceHolder>

            <asp:Panel ID="pnlPagination" runat="server" CssClass="d-flex justify-content-between align-items-center p-4 border-top bg-white" style="border-top: 2px solid var(--neutral-dark) !important;">
                <div>
                    <div class="text-neutral small fw-bold font-sans">
                        Showing Page <asp:Literal ID="litCurrentPage" runat="server"></asp:Literal> of <asp:Literal ID="litTotalPages" runat="server"></asp:Literal>
                    </div>
                    <div class="text-neutral opacity-50" style="font-size: 0.75rem;">
                        (Limited to 10 users per page)
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <asp:LinkButton ID="btnPrevPage" runat="server" CssClass="btn-outline-dark-custom px-3 py-1 font-classic shadow-sm" OnClick="btnPrevPage_Click">
                        <i class="bi bi-chevron-left me-1"></i> Prev
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnNextPage" runat="server" CssClass="btn-outline-dark-custom px-3 py-1 font-classic shadow-sm" OnClick="btnNextPage_Click">
                        Next <i class="bi bi-chevron-right ms-1"></i>
                    </asp:LinkButton>
                </div>
            </asp:Panel>
        </div>
    </div>

    <div class="modal fade" id="addUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 shadow-lg bg-white" style="border: 2px solid var(--neutral-dark) !important;">
                <div class="modal-header border-bottom p-4" style="border-color: rgba(33, 37, 41, 0.15) !important;">
                    <h5 class="modal-title fw-bold text-neutral font-classic"><i class="bi bi-person-plus text-gold me-2"></i> Create New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 p-md-5">
                    
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-neutral opacity-75 text-uppercase font-sans">Email Address</label>
                        <asp:TextBox ID="txtAddEmail" runat="server" CssClass="form-control font-sans modal-input-outline" placeholder="example@email.com"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAddEmail" runat="server" ControlToValidate="txtAddEmail" ErrorMessage="* Email is required" ValidationGroup="AddUserGroup" CssClass="text-red small fw-bold mt-1" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revAddEmail" runat="server" ControlToValidate="txtAddEmail" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ErrorMessage="* Invalid email format" ValidationGroup="AddUserGroup" CssClass="text-red small fw-bold mt-1" Display="Dynamic"></asp:RegularExpressionValidator>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-bold text-neutral opacity-75 text-uppercase font-sans">Display Username</label>
                        <asp:TextBox ID="txtAddUsername" runat="server" CssClass="form-control font-sans modal-input-outline" placeholder="Enter username"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAddUsername" runat="server" ControlToValidate="txtAddUsername" ErrorMessage="* Username is required" ValidationGroup="AddUserGroup" CssClass="text-red small fw-bold mt-1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-neutral opacity-75 text-uppercase font-sans">Temporary Password</label>
                        <asp:TextBox ID="txtAddPassword" runat="server" CssClass="form-control font-sans modal-input-outline" placeholder="Min 8 chars, 1 Upper, 1 Lower"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAddPassword" runat="server" ControlToValidate="txtAddPassword" ErrorMessage="* Password is required" ValidationGroup="AddUserGroup" CssClass="text-red small fw-bold mt-1" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revAddPassword" runat="server" ControlToValidate="txtAddPassword" 
                            ValidationExpression="^(?=.*[a-z])(?=.*[A-Z]).{8,}$" 
                            ErrorMessage="* Must be at least 8 chars with 1 uppercase and 1 lowercase letter." 
                            ValidationGroup="AddUserGroup" CssClass="text-red small fw-bold mt-1" Display="Dynamic">
                        </asp:RegularExpressionValidator>
                        <small class="text-neutral opacity-50 fw-bold d-block mt-2 font-sans"><i class="bi bi-shield-lock me-1"></i> Bcrypt hashed automatically.</small>
                    </div>

                    <div class="mb-5">
                        <label class="form-label small fw-bold text-neutral opacity-75 text-uppercase font-sans">Initial User Role</label>
                        <asp:DropDownList ID="ddlAddRole" runat="server" CssClass="form-select font-sans modal-input-outline">
                            <asp:ListItem Value="Member">Member</asp:ListItem>
                            <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                            <asp:ListItem Value="Admin">Admin</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <asp:LinkButton ID="btnCreateUser" runat="server" ValidationGroup="AddUserGroup" OnClick="btnCreateUser_Click" CssClass="btn-outline-dark-custom w-100 py-3 font-classic fs-5">
                        Create Account
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 shadow-lg bg-white" style="border: 2px solid var(--neutral-dark) !important;">
                <div class="modal-header border-bottom p-4" style="border-color: rgba(33, 37, 41, 0.15) !important;">
                    <h5 class="modal-title fw-bold text-neutral font-classic"><i class="bi bi-pencil-square text-gold me-2"></i> Modify User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 p-md-5">
                    
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-neutral opacity-75 text-uppercase font-sans">Email Address (Login ID)</label>
                        <asp:TextBox ID="txtEditEmail" runat="server" CssClass="form-control font-sans modal-input-outline" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-bold text-neutral opacity-75 text-uppercase font-sans">Display Username</label>
                        <asp:TextBox ID="txtEditUsername" runat="server" CssClass="form-control font-sans modal-input-outline" ReadOnly="true"></asp:TextBox>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-neutral opacity-75 text-uppercase font-sans">Reset Password (Optional)</label>
                        <asp:TextBox ID="txtEditPassword" runat="server" CssClass="form-control font-sans modal-input-outline" placeholder="Leave blank to keep current password"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="revEditPassword" runat="server" ControlToValidate="txtEditPassword" 
                            ValidationExpression="^(?=.*[a-z])(?=.*[A-Z]).{8,}$" 
                            ErrorMessage="* Must be at least 8 chars with 1 uppercase and 1 lowercase letter." 
                            ValidationGroup="EditUserGroup" CssClass="text-red small fw-bold mt-1" Display="Dynamic">
                        </asp:RegularExpressionValidator>
                    </div>

                    <div class="mb-5">
                        <label class="form-label small fw-bold text-neutral opacity-75 text-uppercase font-sans">User Role</label>
                        <asp:DropDownList ID="ddlEditRole" runat="server" CssClass="form-select font-sans modal-input-outline">
                            <asp:ListItem Value="Member">Member</asp:ListItem>
                            <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                            <asp:ListItem Value="Admin">Admin</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <asp:LinkButton ID="btnSaveUser" runat="server" ValidationGroup="EditUserGroup" OnClick="btnSaveUser_Click" CssClass="btn-outline-dark-custom w-100 py-3 font-classic fs-5">
                        Save Changes
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

    <script>
        let editModalInstance;
        let addModalInstance;

        document.addEventListener("DOMContentLoaded", function() {
            editModalInstance = new bootstrap.Modal(document.getElementById('editUserModal'));
            addModalInstance = new bootstrap.Modal(document.getElementById('addUserModal'));
            
            document.getElementById('editUserModal').addEventListener('hidden.bs.modal', function () {
                document.getElementById('<%= txtEditPassword.ClientID %>').value = '';
            });
        });

        function openAddModal() { addModalInstance.show(); }

        function openEditModal(userId, username, role, email) {
            document.getElementById('hfEditUserId').value = userId;
            document.getElementById('<%= txtEditUsername.ClientID %>').value = username;
            document.getElementById('<%= txtEditEmail.ClientID %>').value = email;
            document.getElementById('<%= ddlEditRole.ClientID %>').value = role;
            document.getElementById('<%= txtEditPassword.ClientID %>').value = '';
            editModalInstance.show();
        }
    </script>
</asp:Content>