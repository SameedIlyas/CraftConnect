<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="ELibrary.Admin.ManageUsers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .user-card {
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .user-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
        }

        .fade-in {
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .role-badge {
            font-size: 0.85rem;
        }
    </style>

    <div class="container mt-4 fade-in">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0">Manage Users</h2>
            <asp:DropDownList 
                ID="ddlUserType" 
                runat="server" 
                CssClass="form-select w-auto" 
                AutoPostBack="true" 
                OnSelectedIndexChanged="ddlUserType_SelectedIndexChanged">
                <asp:ListItem Text="All" Value="All" />
                <asp:ListItem Text="Users" Value="User" />
                <asp:ListItem Text="Artisans" Value="Artisan" />
            </asp:DropDownList>
        </div>

        <!-- Users Grid -->
        <div class="row" runat="server" id="UsersContainer">
            <asp:Repeater ID="rptUsers" runat="server">
                <ItemTemplate>
                    <div class="col-md-4 mb-4">
                        <div class="card user-card shadow-sm fade-in" onclick="location.href='UserDetails.aspx?UserId=<%# Eval("UserId") %>'">
                            <div class="card-body">
                                <h5 class="card-title text-primary"><%# Eval("UName") %></h5>
                                <p class="card-text mb-1"><strong>Email:</strong> <%# Eval("Email") %></p>
                                <span class="badge bg-<%# Eval("Role").ToString() == "Artisan" ? "success" : "secondary" %> role-badge">
                                    <%# Eval("Role") %>
                                </span>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- No Users Panel -->
        <asp:Panel ID="pnlNoUsers" runat="server" Visible="false">
            <div class="alert alert-warning text-center fade-in">No users found for this filter.</div>
        </asp:Panel>
    </div>
</asp:Content>

