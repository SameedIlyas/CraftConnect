<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="ELibrary.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <style>
        .form-wrapper {
            max-width: 450px;
            background-color: #ffffff;
            margin: 50px auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.15);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        label {
            font-weight: 600;
            margin-top: 10px;
            display: block;
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

        .btn-reset {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 6px;
            font-weight: bold;
            width: 100%;
            cursor: pointer;
        }

        .btn-reset:hover {
            background-color: #218838;
        }

        .text-danger {
            color: #dc3545;
        }

        .text-success {
            color: #28a745;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <div class="form-wrapper">
        <h2>Forgot Password</h2>

        <label>Email Address</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter your registered email"></asp:TextBox>

        <asp:Button ID="btnReset" runat="server" Text="Reset Password" CssClass="btn-reset" OnClick="btnReset_Click" />
        <asp:Label ID="lblMsg" runat="server" />
    </div>
</asp:Content>
