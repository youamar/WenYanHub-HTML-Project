<%@ Page Title="Scholars Directory" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AuthorDirectory.aspx.cs" Inherits="WenYanHub.AuthorDirectory" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="text-center mb-5 mt-4">
        <h1 class="display-4 font-classic fw-bold" style="color: #3e2723;">
            <i class="fa-solid fa-feather-pointed me-2 icon-gold"></i> Scholars Directory
        </h1>
        <p class="lead text-muted">Discover the masters behind the classics</p>
    </div>

    <div class="container mb-5">
        <div class="row g-4 justify-content-center">
            
            <asp:Repeater ID="rptAuthors" runat="server">
                <ItemTemplate>
                    <div class="col-md-4 col-lg-3">
                        <div class="card h-100 shadow-sm border-0 hover-lift transition-all" style="background-color: #fdfbf7;">
                            
                            <div class="text-center pt-4 pb-2">
                                <img src='<%# string.IsNullOrEmpty(Eval("Image") as string) ? "https://ui-avatars.com/api/?name=" + Eval("Name") + "&background=3e2723&color=fff&size=128&rounded=false" : Eval("Image") %>' 
                                     class="shadow-sm" 
                                     style="width: 100px; height: 100px; object-fit: cover; border: 3px solid #fff; border-radius: 8px;" 
                                     alt='<%# Eval("Name") %>' />
                            </div>

                            <div class="card-body text-center p-4 pt-2">
                                <span class="badge bg-warning bg-opacity-10 text-dark mb-3 px-3 py-2 border border-warning border-opacity-25 rounded-pill">
                                    <%# Eval("Dynasty") %>
                                </span>
                                
                                <h4 class="card-title font-classic fw-bold text-dark mb-4"><%# Eval("Name") %></h4>
                                
                                <a href="AuthorProfile.aspx?id=<%# Eval("AuthorId") %>" class="btn btn-outline-primary btn-sm rounded-pill px-4 stretched-link">
                                    View Profile
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            
            <asp:Label ID="lblNoAuthors" runat="server" Text="No scholars found in the database yet." Visible="false" CssClass="text-muted w-100 text-center py-5"></asp:Label>
            
        </div>
    </div>

    <style>
        :root {
            --gu-brown-dark: #3e2723;   
            --gu-brown-main: #5d4037;   
            --gu-paper: #fdfbf7;      
        }

        .icon-gold { color: #D4AF37 !important; }

        .btn-outline-primary {
            color: var(--gu-brown-main) !important;
            border-color: var(--gu-brown-main) !important;
            transition: all 0.3s ease;
        }
        .btn-outline-primary:hover, .btn-outline-primary:focus {
            background-color: var(--gu-brown-main) !important;
            color: var(--gu-paper) !important;
            border-color: var(--gu-brown-main) !important;
            box-shadow: 0 4px 10px rgba(93, 64, 55, 0.3) !important;
        }

        .hover-lift { transition: all 0.3s ease; }
        .hover-lift:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(93, 64, 55, 0.15) !important; 
        }
        .transition-all { transition: all 0.3s ease; }
    </style>

</asp:Content>