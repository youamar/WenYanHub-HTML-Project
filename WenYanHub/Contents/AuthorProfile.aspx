<%@ Page Title="Author Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AuthorProfile.aspx.cs" Inherits="WenYanHub.AuthorProfile" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <style>
        /* Custom Page Styles */
        .author-card {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            text-align: center;
            padding: 25px;
            transition: all 0.3s ease;
        }
        .author-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .author-img {
            width: 160px;
            height: 160px;
            border-radius: 50%; /* Circular Image */
            object-fit: cover;
            border: 4px solid #f8f9fa;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            margin-bottom: 20px;
        }
        .bio-text {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #555;
            text-align: justify;
        }

        
        
        .work-item-single:hover p.text-muted {
            color: #555 !important;
        }

        .work-icon-box {
            width: 45px;
            height: 45px;
            background-color: #f8f9fa;
            color: #6c757d;
            border: 1px solid #e9ecef;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }
        .read-text {
            color: #adb5bd;
            transition: all 0.3s ease;
        }
        
        .work-item-single {
            border-left: 4px solid transparent;
            transition: all 0.3s ease;
            background-color: #fff;
        }
        .work-item-single:hover {
            background-color: #fdfbf7;
            border-left: 4px solid #28a745;
            padding-left: 30px !important;
            text-decoration: none;
        }
        
        .work-item-single:hover .work-icon-box {
            background-color: #28a745;
            color: #fff;
            border-color: #28a745;
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3) !important;
        }
        .work-item-single:hover .read-text {
            color: #28a745;
        }
    </style>

    <div class="container mt-5 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            
            <a href="javascript:history.back()" class="btn btn-outline-secondary rounded-pill">
                <i class="fa fa-arrow-left mr-1"></i> Go Back
            </a>
            
            <span class="text-muted">Classical Chinese Learning Platform</span>
            
        </div>

        <div class="row">
            <div class="col-lg-4 mb-4">
                <div class="author-card sticky-top" style="top: 90px; z-index: 1;">
                    <asp:Image ID="imgAuthor" runat="server" CssClass="author-img" ImageUrl="~/Images/default_author.png" AlternateText="Author Portrait" />
                    
                    <h2 class="font-weight-bold text-dark mb-2">
                        <asp:Label ID="lblName" runat="server" Text="Author Name"></asp:Label>
                    </h2>
                    
                    <div class="mb-3">
                        <span class="badge badge-dynasty">
                            <asp:Label ID="lblDynasty" runat="server" Text="Dynasty"></asp:Label>
                        </span>
                    </div>

                    <hr class="my-4" />

                    <div class="row text-center">
                        <div class="col-12">
                            <h3 class="text-primary font-weight-bold mb-0">
                                <asp:Label ID="lblWorksCount" runat="server" Text="0"></asp:Label>
                            </h3>
                            <small class="text-uppercase text-muted" style="letter-spacing: 1px;">Collected Works</small>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-white border-bottom-0 pt-4 px-4">
                        <h4 class="mb-0 text-primary border-left border-primary pl-3" style="border-width: 4px !important;">
                            <i class="fa fa-history mr-2"></i>Biography
                        </h4>
                    </div>
                    <div class="card-body px-4 pb-4">
                        <div class="bio-text">
                            <asp:Literal ID="litBio" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>

                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white border-bottom-0 pt-4 px-4">
                        <h4 class="mb-0 text-success border-left border-success pl-3" style="border-width: 4px !important;">
                            <i class="fa fa-scroll mr-2"></i>Selected Works
                        </h4>
                    </div>
                    <div class="card-body p-0">
                        <div class="list-group list-group-flush">
                            
                            <asp:Repeater ID="rptWorks" runat="server">
                                <ItemTemplate>
                                    <a href='/Contents/Intro.aspx?id=<%# Eval("ContentId") %>' 
                                       class="list-group-item list-group-item-action work-item-single py-4 px-4 d-flex flex-column flex-md-row justify-content-between align-items-md-center">
                                        
                                        <div class="mb-3 mb-md-0" style="flex: 1;">
                                            <div class="d-flex align-items-center mb-2">
                                                <h5 class="mb-0 text-dark font-weight-bold mr-3" style="font-family: 'Noto Serif SC', serif;">
                                                    <%# Eval("Title") %>
                                                </h5>
                                                <span class="badge badge-light border text-muted">
                                                    <%# Eval("Category") %>
                                                </span>
                                            </div>
                                            <p class="text-muted small mb-0 pr-md-5" style="line-height: 1.6; font-style: italic;">
                                                <i class="fa fa-quote-left opacity-25 mr-1"></i>
                                                <%# GetExcerpt(Eval("ContentText")) %>
                                                <i class="fa fa-quote-right opacity-25 ml-1"></i>
                                            </p>
                                        </div>

                                        <div class="d-flex align-items-center work-action-area">
                                            <span class="read-text small font-weight-bold mr-3 text-uppercase" style="letter-spacing: 2px;">Read</span>
                                            <div class="work-icon-box rounded-circle d-flex align-items-center justify-content-center shadow-sm">
                                                <i class="fa fa-arrow-right"></i>
                                            </div>
                                        </div>
                                        
                                    </a>
                                </ItemTemplate>
                            </asp:Repeater>
                            
                            <asp:Panel ID="pnlNoWorks" runat="server" Visible="false" CssClass="text-center py-5">
                                <i class="fa fa-folder-open text-muted fa-3x mb-3 opacity-50"></i>
                                <p class="text-muted">No works found for this author.</p>
                            </asp:Panel>
                            
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>