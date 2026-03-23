<%@ Page Title="Teacher Peer Forum" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="TeacherForum.aspx.cs" Inherits="WenYanHub.Teacher.TeacherForum" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Fix: Prevent icons from becoming squares  */
        .fa-solid, .fa-regular, .fa-comments, .fa-user-tie, .fa-pencil, .fa-trash, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
        /* Core layout fix: Automatically centers the content, resolving the issue where the content is pushed to the left. */
        .manage-container { padding: 40px 0 60px 0; min-height: 80vh; }

        /* Header Section: Completely synchronized dark ink banner of ContentManage  */
        .header-banner {
            background-color: #1a1513;
            border-radius: 20px;
            padding: 50px 40px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            margin-bottom: 30px;
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

        /* Message input box style */
        .post-box {
            background: white;
            padding: 30px; 
            border-radius: 15px;
            margin-bottom: 40px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: 1px solid #f0f0f0;
        }
        .txt-input {
            width: 100%;
            height: 120px; 
            padding: 15px; 
            border: 1px solid #e0d5c1;
            border-radius: 8px;
            font-size: 16px; 
            margin-bottom: 15px;
            transition: 0.3s;
        }
        .txt-input:focus { border-color: #2C2420; outline: none; box-shadow: 0 0 0 0.2rem rgba(44, 36, 32, 0.1); }

        /* Button style: Dark brown background (#2C2420) + Pure white text */
        .btn-custom-dark {
            background-color: #2C2420 !important;
            color: #FFFFFF !important;
            border-radius: 8px;
            padding: 12px 30px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
        }
        .btn-custom-dark:hover { background-color: #1a1512 !important; transform: translateY(-2px); }

        /* Forum card style */
        .forum-card {
            background: white;
            padding: 30px; 
            border-radius: 15px;
            margin-bottom: 25px; 
            border-left: 6px solid #2C2420;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        .forum-card:hover { transform: scale(1.01); box-shadow: 0 8px 25px rgba(0,0,0,0.1); }

        .card-header { display: flex; justify-content: space-between; border-bottom: 1px dashed #eee; padding-bottom: 15px; margin-bottom: 15px; }
        .author-info { font-weight: bold; color: #2C2420; font-size: 18px; }
        .post-date { color: #999; font-size: 13px; }
        .content-body { color: #444; line-height: 1.8; font-size: 16px; white-space: pre-wrap; }
        
        /* Change the link color to dark brown: Make it uniform. */
        .action-link { text-decoration: none; font-size: 14px; margin-left: 20px; color: #2C2420; font-weight: 600; }
        .action-link:hover { text-decoration: underline; color: #8B0000; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container manage-container">
        
        <div class="header-banner">
            <div class="header-bg"></div>
            <div class="header-content">
                <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                    <i class="fa-solid fa-comments me-2"></i> Teacher Peer Forum
                </h2>
                <p class="lead opacity-75 mb-0 text-white">Share pedagogical wisdom and collaborate with fellow scholars.</p>
            </div>
        </div>

        <div class="post-box">
            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" CssClass="txt-input" placeholder="Share your pedagogical wisdom..."></asp:TextBox>
            <div style="text-align:right;">
                <asp:Button ID="btnPost" runat="server" Text="Post to Forum" CssClass="btn-custom-dark" OnClick="btnPost_Click" />
            </div>
        </div>

        <asp:Panel ID="pnlEdit" runat="server" Visible="false" CssClass="post-box" style="background:#fdfcf9;">
            <h4 class="font-classic fw-bold mb-3" style="color: #2C2420;"><i class="fa-solid fa-pencil me-2"></i> Edit Your Insight</h4>
            <asp:HiddenField ID="hfEditId" runat="server" />
            <asp:TextBox ID="txtEditMessage" runat="server" TextMode="MultiLine" CssClass="txt-input" style="height:100px;"></asp:TextBox>
            <div style="text-align:right;">
                <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" OnClick="btnCancelEdit_Click" CssClass="btn-custom-dark" style="background:#888 !important; margin-right:10px;" />
                <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" OnClick="btnUpdate_Click" CssClass="btn-custom-dark" />
            </div>
        </asp:Panel>

        <asp:Repeater ID="rptMessages" runat="server" OnItemCommand="rptMessages_ItemCommand">
            <ItemTemplate>
                <div class="forum-card">
                    <div class="card-header">
                        <div class="author-info">
                            <i class="fa-solid fa-user-tie me-2" style="color:#2C2420;"></i>
                            Teacher <%# Eval("Teacher.Username") %>
                            <asp:Label runat="server" Visible='<%# Convert.ToInt32(Eval("TeacherId")) == Convert.ToInt32(Session["UserId"]) %>' 
                                Text="(You)" style="font-size:12px; font-weight:normal; color:#888; margin-left:5px;"></asp:Label>
                        </div>
                        <div class="post-meta">
                            <span class="post-date"><i class="fa-regular fa-clock me-1"></i> <%# Eval("CreatedAt", "{0:MMM dd, yyyy HH:mm}") %></span>
                            <asp:PlaceHolder runat="server" Visible='<%# Convert.ToInt32(Eval("TeacherId")) == Convert.ToInt32(Session["UserId"]) %>'>
                                <asp:LinkButton runat="server" CommandName="EditMsg" CommandArgument='<%# Eval("MessageId") %>' CssClass="action-link"><i class="fa-solid fa-pencil me-1"></i> Edit</asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="DeleteMsg" CommandArgument='<%# Eval("MessageId") %>' OnClientClick="return confirm('Delete this insight?');" CssClass="action-link" style="color:#8B0000;"><i class="fa-solid fa-trash me-1"></i> Delete</asp:LinkButton>
                            </asp:PlaceHolder>
                        </div>
                    </div>
                    <div class="content-body"><%# Eval("Content") %></div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>