<%@ Page Title="Evaluate Scholar" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="EvaluateHomework.aspx.cs" Inherits="WenYanHub.Teacher.EvaluateHomework" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
       
        .fa-solid, .fa-house, .fa-scroll, .fa-pen-nib, .fa-file-pdf, .fa-check, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
     
        .manage-container { padding: 40px 0 60px 0; min-height: 80vh; }

      
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

        /* Form card layout */
        .form-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: none;
            margin-bottom: 30px;
        }

        /* Information row style */
        .info-row { 
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px; 
            padding-bottom: 15px; 
            border-bottom: 1px dashed #e0d5c1;
            align-items: center;
        }

        .label-text { color: #888; font-size: 13px; text-transform: uppercase; font-weight: 600; }
        .value-text { color: #2C2420; font-weight: bold; font-size: 18px; }

        .form-label { font-weight: 700; color: #2C2420; margin-bottom: 8px; display: block; }

        /* Input box style: Synchronized dark brown with focus highlight */
        .form-control {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 12px;
            width: 100%;
            transition: 0.3s;
        }
        .form-control:focus {
            border-color: #2C2420;
            box-shadow: 0 0 0 0.2rem rgba(44, 36, 32, 0.1);
            outline: none;
        }

        /* The button style is uniformly set as a dark brown background (#2C2420) with pure white text (#FFFFFF)  */
        .btn-custom-dark {
            background-color: #2C2420 !important;
            color: #FFFFFF !important;
            border-radius: 8px;
            padding: 12px 25px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
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
        /* The mandatory icon is also white. */
        .btn-custom-dark i { color: #FFFFFF !important; }

        .back-link { color: #2C2420; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; margin-bottom: 20px; transition: 0.3s; }
        .back-link:hover { transform: translateX(-5px); color: #8B0000; }
        
        .btn-cancel { color: #666; text-decoration: none; margin-left: 20px; font-weight: 500; }
        .btn-cancel:hover { color: #2C2420; text-decoration: underline; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="manage-container">
        <div class="container" style="max-width: 900px;">
            <a href="SubmissionManage.aspx" class="back-link">
                <i class="fa-solid fa-house me-2"></i> Return to All Submissions
            </a>

            <div class="header-banner">
                <div class="header-bg"></div>
                <div class="header-content">
                    <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                        <i class="fa-solid fa-pen-nib me-2" style="color: #FFFFFF;"></i> Evaluate Submission
                    </h2>
                    <p class="lead opacity-75 mb-0 text-white">Reviewing and grading scholar performance.</p>
                </div>
            </div>

            <div class="form-card">
                <asp:HiddenField ID="hfSubmissionId" runat="server" />
                <asp:HiddenField ID="hfPracticeId" runat="server" />

                <div class="info-row">
                    <div class="d-flex gap-4">
                        <div>
                            <div class="label-text">Scholar Name</div>
                            <div class="value-text"><asp:Literal ID="litStudentName" runat="server"></asp:Literal></div>
                        </div>
                        <div>
                            <div class="label-text">Submitted At</div>
                            <div class="value-text"><asp:Literal ID="litSubmittedAt" runat="server"></asp:Literal></div>
                        </div>
                    </div>
                    <div>
                        <%-- Open Student PDF Button: White Text --%>
                        <asp:HyperLink ID="hlStudentFile" runat="server" Target="_blank" CssClass="btn-custom-dark">
                            <i class="fa-solid fa-file-pdf me-2"></i> Open Student PDF
                        </asp:HyperLink>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-md-4">
                        <label class="form-label">Score (0-99.99)</label>
                        <asp:TextBox ID="txtScore" runat="server" CssClass="form-control" placeholder="e.g. 95.50"></asp:TextBox>
                        <small class="text-muted"></small>
                    </div>
                    <div class="col-md-8">
                        <label class="form-label">Feedback File Link (Google Drive/OneDrive)</label>
                        <asp:TextBox ID="txtFeedbackUrl" runat="server" CssClass="form-control" placeholder="Paste link here..."></asp:TextBox>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Teacher's Comments</label>
                    <asp:TextBox ID="txtComments" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Provide feedback..."></asp:TextBox>
                </div>

                <div class="text-center pt-4 border-top">
                    <%-- "Save Grade & Finish" button: White text --%>
                    <button type="submit" class="btn-custom-dark" runat="server" id="btnSaveLink" onserverclick="btnSave_Click">
                        <i class="fa-solid fa-check me-2"></i> Save Grade & Finish
                    </button>
                    <asp:Button ID="btnSave" runat="server" Style="display:none;" OnClick="btnSave_Click" />
                    <a href="SubmissionManage.aspx" class="btn-cancel">Cancel</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>