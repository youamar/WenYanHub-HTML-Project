<%@ Page Title="Create Zoom" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="EditZoom.aspx.cs" Inherits="WenYanHub.Teacher.EditZoom" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Prevent the icons from being distorted into squares due to interference from the master page font. */
        .fa-solid, .fa-chalkboard-user, .fa-floppy-disk, .fa-video, .fa-clock, .fa-id-card, .fa-key, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
        /* The background extends across the entire surface, and the container automatically aligns in the center. */
        .manage-container { 
            background: #fdfcf9 url('https://www.transparenttextures.com/patterns/papyros.png');
            padding: 40px 0 60px 0; 
            min-height: 90vh; 
        }

        /* Header Section: Completely synchronized dark ink banner of ContentManage */
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

        /* Modern card-style form container */
        .form-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 30px;
        }

        .form-group { margin-bottom: 25px; }

        /* Change the color of the label text to dark brown. */
        .form-group label { 
            display: block; 
            font-weight: 700; 
            color: #2C2420; 
            margin-bottom: 12px; 
            font-size: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Input box style: Synchronous dark brown focus effect */
        .form-control { 
            width: 100%; 
            padding: 14px; 
            border: 1px solid #ddd;
            border-radius: 8px; 
            box-sizing: border-box; 
            font-size: 15px;
            transition: 0.3s;
        }
        .form-control:focus { 
            border-color: #2C2420; 
            outline: none;
            box-shadow: 0 0 8px rgba(44,36,32,0.15); 
        }

        /* The button style is uniformly set as a dark brown background (#2C2420) with pure white text (#FFFFFF). */
        .btn-custom-dark {
            background-color: #2C2420 !important;
            color: #FFFFFF !important;
            border-radius: 8px;
            padding: 15px 35px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: 0.3s;
            border: 1px solid #4A3C31;
            cursor: pointer;
            font-size: 16px;
        }
        .btn-custom-dark:hover {
            background-color: #1a1512 !important;
            transform: translateY(-2px);
            color: #FFFFFF !important;
        }
        /* Required icon color */
        .btn-custom-dark i { color: #FFFFFF !important; }

        .btn-cancel { 
            color: #666; 
            text-decoration: none; 
            margin-left: 20px; 
            font-weight: 600;
            transition: 0.3s;
        }
        .btn-cancel:hover { color: #2C2420; text-decoration: underline; }

        .back-link { color: #2C2420; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; margin-bottom: 20px; transition: 0.3s; }
        .back-link:hover { transform: translateX(-5px); color: #8B0000; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="manage-container">
        <div class="container" style="max-width: 850px;">
            
            <a href="VideoManage.aspx" class="back-link">
                <i class="fa-solid fa-house me-2"></i> Return to Video Archive
            </a>

            <div class="header-banner">
                <div class="header-bg"></div>
                <div class="header-content">
                    <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                        <i class="fa-solid fa-chalkboard-user me-2" style="color: #FFFFFF;"></i> Create or Edit Live Zoom Session 
                    </h2>
                    <p class="lead opacity-75 mb-0 text-white">Coordinate real-time scholar interactions.</p>
                </div>
            </div>

            <div class="form-card">
                <asp:HiddenField ID="hfZoomId" runat="server" />
                
                <div class="form-group">
                    <label><i class="fa-solid fa-video me-2"></i> Session Title *</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" required="true" placeholder="e.g. Weekly Classical Poetry Discussion"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label><i class="fa-solid fa-link me-2"></i> Zoom Join URL *</label>
                    <asp:TextBox ID="txtZoomUrl" runat="server" CssClass="form-control" required="true" placeholder="https://zoom.us/j/..."></asp:TextBox>
                </div>

                <div class="row g-3">
                    <div class="col-md-6 form-group">
                        <label><i class="fa-solid fa-id-card me-2"></i> Meeting ID</label>
                        <asp:TextBox ID="txtMeetingId" runat="server" CssClass="form-control" placeholder="123 456 7890"></asp:TextBox>
                    </div>
                    <div class="col-md-6 form-group">
                        <label><i class="fa-solid fa-key me-2"></i> Passcode</label>
                        <asp:TextBox ID="txtPasscode" runat="server" CssClass="form-control" placeholder="Optional passcode"></asp:TextBox>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-6 form-group">
                        <label><i class="fa-solid fa-clock me-2"></i> Start Time *</label>
                        <asp:TextBox ID="txtStartTime" runat="server" CssClass="form-control" TextMode="DateTimeLocal" required="true"></asp:TextBox>
                    </div>
                    <div class="col-md-6 form-group">
                        <label><i class="fa-solid fa-hourglass-half me-2"></i> Duration (Minutes) *</label>
                        <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" TextMode="Number" required="true" placeholder="60"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label><i class="fa-solid fa-pen-nib me-2"></i> Session Description</label>
                    <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Additional details for the scholars..."></asp:TextBox>
                </div>

                <div style="margin-top: 40px; text-align: center; border-top: 1px solid #f0f0f0; padding-top: 30px;">
                    <%-- The button text is white and the background is dark brown. --%>
                    <button type="submit" class="btn-custom-dark" runat="server" id="btnSaveLink" onserverclick="btnSave_Click">
                        <i class="fa-solid fa-floppy-disk me-2"></i> Save Zoom Session
                    </button>
                    <asp:Button ID="btnSave" runat="server" Style="display:none;" OnClick="btnSave_Click" />
                    
                    <a href="VideoManage.aspx" class="btn-cancel">Cancel</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>