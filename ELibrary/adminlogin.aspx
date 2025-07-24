<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeFile="adminlogin.aspx.cs" Inherits="ELibrary.adminlogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <!-- User Icon -->
                        <div class="text-center">
                            <img src="Images/admin.png" alt="User Icon" class="img-fluid" width="100">
                        </div>
                        <!-- Login Header -->
                        <h4 class="text-center mt-3 mb-4 text-primary">Admin Login</h4>
                        <!-- Login Form -->
                        <asp:Panel ID="LoginPanel" runat="server" DefaultButton="btnLogin">
                            <div class="mb-3">
                                <asp:TextBox CssClass="form-control" ID="txtUsername" runat="server" Placeholder="Username"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <asp:TextBox CssClass="form-control" ID="txtPassword" runat="server" TextMode="Password" Placeholder="Password"></asp:TextBox>
                            </div>
                            <div class="d-grid gap-2">
                                <asp:Button CssClass="btn btn-success" ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
