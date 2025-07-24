<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="ELibrary.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <style>
        /* Container centering within the available page */
        .centre-page {
            max-width: 400px;
            background-color: #f9f9f9;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 20px auto; /* Centers it horizontally and adds vertical spacing */
            padding: 20px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-top: 5px;
        }

        .col-xs-11 {
            margin-bottom: 10px;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <asp:Panel ID="pnlSignupForm" runat="server" DefaultButton="btnSignup">
        <div class="centre-page">
            <!-- Username -->
            <label class="col-xs-11">UserName:</label>
            <div class="col-xs-11">
                <asp:TextBox ID="txtUname" runat="server" CssClass="form-control" placeholder="Enter Your UserName"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUname" runat="server" ControlToValidate="txtUname"
                    CssClass="text-danger" ErrorMessage="Username is required" Display="Dynamic" />
            </div>

            <!-- Password -->
            <label class="col-xs-11">Password:</label>
            <div class="col-xs-11">
                <asp:TextBox ID="txtPass" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter Your Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPass"
                    CssClass="text-danger" ErrorMessage="Password is required" Display="Dynamic" />
            </div>

            <!-- Confirm Password -->
            <label class="col-xs-11">Confirm Password:</label>
            <div class="col-xs-11">
                <asp:TextBox ID="txtCPass" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm Your Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCPass" runat="server" ControlToValidate="txtCPass"
                    CssClass="text-danger" ErrorMessage="Confirm password is required" Display="Dynamic" />
                <asp:CompareValidator ID="cvPasswords" runat="server"
                    ControlToCompare="txtPass" ControlToValidate="txtCPass"
                    ErrorMessage="Passwords do not match" CssClass="text-danger" Display="Dynamic" />
            </div>

            <!-- Full Name -->
            <label class="col-xs-11">Your Full Name:</label>
            <div class="col-xs-11">
                <asp:TextBox ID="txtFName" runat="server" CssClass="form-control" placeholder="Enter Your Full Name"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFName" runat="server" ControlToValidate="txtFName"
                    CssClass="text-danger" ErrorMessage="Full name is required" Display="Dynamic" />
            </div>

            <!-- Email -->
            <label class="col-xs-11">Email:</label>
            <div class="col-xs-11">
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter Your Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    CssClass="text-danger" ErrorMessage="Email is required" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ErrorMessage="Invalid email format"
                    CssClass="text-danger" Display="Dynamic"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
            </div>

            <!-- Role -->
            <label class="col-xs-11">Register As:</label>
            <div class="col-xs-11">
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Select Role" Value="" />
                    <asp:ListItem Text="User" Value="User" />
                    <asp:ListItem Text="Artisan" Value="Artisan" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvRole" runat="server"
                    ControlToValidate="ddlRole" InitialValue=""
                    CssClass="text-danger" ErrorMessage="Please select a role" Display="Dynamic" />
            </div>

            <!-- Button -->
            <div class="col-xs-11 mt-3">
                <asp:Button ID="btnSignup" CssClass="btn btn-primary" runat="server" Text="SignUp" OnClick="btnSignup_Click" />
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="text-danger mt-2" />
                <asp:Label ID="lblMsg" runat="server" CssClass="text-success mt-2 d-block" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
