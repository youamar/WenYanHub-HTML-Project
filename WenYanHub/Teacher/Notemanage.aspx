<%@ Page Title="Manage Notes" Language="C#" MasterPageFile="Teacher.Master" AutoEventWireup="true" CodeBehind="NoteManage.aspx.cs" Inherits="WenYanHub.Teacher.NoteManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Enforce the use of the FontAwesome font for icons */
        .fa-solid, .fa-house, .fa-scroll, i { 
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important; 
        }

        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        
        /* Layout: Automatic Centering */
        .manage-container { padding: 40px 0 60px 0; min-height: 80vh; }

        /* Header Section: Dark Hero Style */
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
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.7), rgba(20, 15, 12, 0.9)), 
                              url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg');
            background-size: cover; background-position: center;
            z-index: 1;
        }
        .header-content { position: relative; z-index: 2; text-align: center; }

        /* Modern card layout */
        .table-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: none;
            margin-bottom: 30px;
        }

        /* Button style: Dark brown background (#2C2420) */
        .btn-custom-dark {
            background-color: #2C2420 !important;
            color: #FFFFFF !important;
            border-radius: 8px;
            padding: 12px 25px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex; align-items: center;
            transition: 0.3s;
            border: 1px solid #4A3C31;
        }
        .btn-custom-dark:hover { background-color: #1a1512 !important; transform: translateY(-2px); color: #FFFFFF !important; }

        /* Table style: Dark brown header + All capital letters */
        .modern-grid { width: 100% !important; margin-top: 20px; border: none !important; }
        .modern-grid th {
            background-color: #2C2420 !important;
            color: #FFFFFF !important;
            padding: 15px !important;
            border: none !important;
            font-weight: 600;
            text-transform: uppercase; /* Require header rows to be in uppercase. */
        }
        .modern-grid td { padding: 15px !important; border-bottom: 1px solid #f0f0f0 !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container manage-container">
        <div class="header-banner">
            <div class="header-bg"></div>
            <div class="header-content">
                <h2 class="font-classic ls-2 fw-bold mb-2 text-white">
                    <i class="fa-solid fa-scroll me-2" style="color: #FFFFFF;"></i> Scholar Notes Archive
                </h2>
                <p class="lead opacity-75 mb-0 text-white">Reviewing and organizing study insights.</p>
            </div>
        </div>

        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert alert-success d-block mb-4 p-3 rounded-3 shadow-sm"></asp:Label>

        <div class="table-card">
            <div class="d-flex justify-content-end mb-4">
                <a href="EditNote.aspx" class="btn-custom-dark">＋ Create New Note</a>
            </div>

            <asp:GridView ID="gvNotes" runat="server" AutoGenerateColumns="False" CssClass="table modern-grid" 
                DataKeyNames="NoteId" OnRowCommand="gvNotes_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="ID">
                        <ItemStyle Width="80px" HorizontalAlign="Center" Font-Bold="true" />
                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="RELATED LESSON">
                        <ItemTemplate><b><%# Eval("Content.Title") %></b></ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="STATUS">
                        <ItemTemplate>
                            <span class="badge" style="background-color: #f4db9a; color: #2C2420;">
                                <%# string.IsNullOrEmpty(Eval("Approved")?.ToString()) ? "Pending" : Eval("Approved") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:BoundField DataField="UpdatedAt" HeaderText="LAST UPDATED" DataFormatString="{0:yyyy-MM-dd}" />
                    
                    <asp:TemplateField HeaderText="ACTIONS">
                        <ItemTemplate>
                            <div class="d-flex gap-3">
                                <asp:HyperLink ID="hlEdit" runat="server" NavigateUrl='<%# "EditNote.aspx?id=" + Eval("NoteId") %>' 
                                    CssClass="text-decoration-none fw-bold" style="color: #2C2420;">Edit</asp:HyperLink>
                                
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteNote" CommandArgument='<%# Eval("NoteId") %>' 
                                    OnClientClick="return confirm('Confirm deletion?');" 
                                    CssClass="text-decoration-none fw-bold" style="color: #2C2420;">Delete</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>