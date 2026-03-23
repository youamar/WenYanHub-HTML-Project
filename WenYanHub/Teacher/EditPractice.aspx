<%@ Page Title="Edit Practice" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="EditPractice.aspx.cs" Inherits="WenYanHub.Teacher.EditPractice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Icon font protection */
        .fa-solid, .fa-scroll, .fa-pen-nib, .fa-floppy-disk, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        
        /* Layout fix: Automatic centering */
        .edit-container { padding: 40px 0 60px 0; max-width: 900px; margin: 0 auto; }

        /* Header Section: Dark Brown Background (#2C2420) */
        .header-banner {
            background-color: #1a1513;
            border-radius: 20px;
            padding: 40px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            margin-bottom: 30px;
            text-align: center;
        }
        .header-bg {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.7), rgba(20, 15, 12, 0.9)), 
                              url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg');
            background-size: cover; z-index: 1;
        }
        .header-content { position: relative; z-index: 2; }
        .header-content i { color: #FFFFFF !important; font-size: 24px; }

        /* Form card */
        .form-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: none;
        }

        .form-label { font-weight: 700; color: #2C2420; margin-bottom: 8px; display: block; }

        .form-control { border-radius: 8px; border: 1px solid #ddd; padding: 12px; width: 100%; transition: 0.3s; }
        .form-control:focus { border-color: #2C2420; box-shadow: 0 0 0 0.2rem rgba(44, 36, 32, 0.1); outline: none; }

        /* Save button: Synchronize the dark brown gradient style of EditNote.aspx */
        .btn-submit-modern {
            background: linear-gradient(135deg, #2C2420 0%, #4A3C31 100%);
            color: #FFFFFF !important;
            padding: 14px 40px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: 0.3s;
            box-shadow: 0 4px 15px rgba(44, 36, 32, 0.2);
        }
        .btn-submit-modern:hover { transform: translateY(-2px); opacity: 0.9; }
        
        /* Button icon: Set to white */
        .btn-submit-modern i { color: #FFFFFF !important; margin-right: 10px; }

        /* Cancel button: Synchronize the text link style of EditNote.aspx */
        .btn-cancel { 
            color: #666; 
            text-decoration: none; 
            margin-left: 20px; 
            font-weight: 500;
            transition: 0.3s;
        }
        .btn-cancel:hover { color: #2C2420; }

        .link-box { background: #fdf5e6; padding: 20px; border-radius: 8px; border: 1px dashed #d4af37; margin-top: 20px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container edit-container">
        
        <div class="header-banner">
            <div class="header-bg"></div>
            <div class="header-content">
                <h2 class="font-classic fw-bold mb-0 text-white">
                    <i class="fa-solid fa-pen-nib me-2"></i> Upload or Edit Practice 
                </h2>
            </div>
        </div>

        <div class="form-card">
            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert d-block mb-3 p-3 rounded-3 shadow-sm"></asp:Label>
            <asp:HiddenField ID="hfPracticeId" runat="server" />

            <div class="row g-4 mb-4">
                <div class="col-md-7">
                    <label class="form-label">Practice Title *</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" required="true"></asp:TextBox>
                </div>
                <div class="col-md-5">
                    <label class="form-label">Due Date *</label>
                    <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control" TextMode="Date" required="true"></asp:TextBox>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
            </div>

            <div class="link-box">
                <label class="form-label"><i class="fa-solid fa-link me-2"></i> Google Drive PDF Link *</label>
                <asp:TextBox ID="txtQuestionLink" runat="server" CssClass="form-control" placeholder="Paste link here..."></asp:TextBox>
            </div>

            <div class="text-center pt-5 border-top mt-4">
                <button type="submit" class="btn-submit-modern" runat="server" id="btnSaveLink" onserverclick="btnSave_Click">
                    <i class="fa-solid fa-floppy-disk"></i> Save Practice
                </button>
                <asp:Button ID="btnSave" runat="server" Style="display:none;" OnClick="btnSave_Click" />
                <a href="PracticeManage.aspx" class="btn-cancel">Cancel</a>
            </div>
        </div>
    </div>
</asp:Content>