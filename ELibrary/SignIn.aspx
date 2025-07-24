<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="SignIn.aspx.cs" Inherits="ELibrary.SignIn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <style>
        .form-container {
            max-width: 500px;
            margin: 40px auto;
            padding: 30px;
            background-color: #fdfdfd;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        label {
            margin-top: 10px;
            display: block;
            font-weight: 600;
        }

        .form-control {
            margin-top: 5px;
            margin-bottom: 15px;
            width: 100%;
            padding: 10px;
            font-size: 15px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 15px;
        }

        .btn-primary, .btn-secondary {
            padding: 10px 20px;
            font-weight: bold;
            border-radius: 6px;
            width: 100%;
            margin-top: 10px;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
            color: white;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .btn-secondary {
            background-color: #6c757d;
            border: none;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }

        .text-center {
            text-align: center;
        }

        .text-danger {
            color: red;
            font-size: 14px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <div class="form-container">
        <h2>Login</h2>

        <asp:Panel ID="pnlLoginForm" runat="server" DefaultButton="btnLogin">
            <label for="txtUsername">Username:</label>
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter your username"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorUserName" runat="server" CssClass="text-danger"
                ErrorMessage="Enter username" ControlToValidate="txtUsername" ForeColor="#CC0000" />

            <label for="txtPassword">Password:</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter your password"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPassword" runat="server" CssClass="text-danger"
                ErrorMessage="Enter password" ControlToValidate="txtPassword" ForeColor="#CC0000" />

            <div class="remember-me">
                <asp:CheckBox ID="chkRememberMe" runat="server" />
                <label for="chkRememberMe">Remember Me</label>
            </div>

            <asp:Button ID="btnLogin" CssClass="btn-primary" runat="server" Text="Login" OnClick="btnLogin_Click" />

            <div class="text-center mt-3">
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/SignUp.aspx">Don't have an account? Sign Up</asp:HyperLink><br />
                <asp:HyperLink ID="HyperLinkForgot" runat="server" NavigateUrl="~/ForgotPassword.aspx" CssClass="btn btn-secondary">Forgot Password?</asp:HyperLink>
            </div>

            <asp:Label ID="Label1" CssClass="text-danger text-center" runat="server" />
        </asp:Panel>
    </div>
</asp:Content>

