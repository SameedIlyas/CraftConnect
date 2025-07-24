<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="CreateStore.aspx.cs" Inherits="ELibrary.CreateStore" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server"> </asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <div class="container d-flex justify-content-center align-items-center vh-100">
        <div class="card shadow-lg" style="width: 100%; max-width: 500px;">
            <div class="card-body">

                <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-danger d-none" EnableViewState="true"></asp:Label>

                <asp:Panel ID="pnlSignupForm" runat="server" DefaultButton="btnSignUp">
                    <div class="centre-page">
                        <h3 runat="server" id="headingTitle" class="card-title text-center mb-4">Register as an Artisan</h3>

                        <asp:Label ID="Label1" runat="server" CssClass="text-danger d-block text-center mb-2" EnableViewState="true" />

                        <!-- Registration Panel -->
                        <asp:Panel ID="pnlRegister" runat="server">

                            <!-- Username -->
                            <label>Username</label>
                            <asp:TextBox ID="txtUName" runat="server" CssClass="form-control" Placeholder="e.g. artisan123" />
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUName"
                                ErrorMessage="Username is required" CssClass="text-danger" Display="Dynamic" />

                            <!-- Email -->
                            <label>Your Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Placeholder="name@example.com" TextMode="Email" />
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="text-danger" Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                ErrorMessage="Invalid email format" CssClass="text-danger" Display="Dynamic"
                                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />

                            <!-- Name -->
                            <label>Your Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" Placeholder="John Doe" />
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="Name is required" CssClass="text-danger" Display="Dynamic" />

                            <!-- Password -->
                            <label>Password</label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" />
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required" CssClass="text-danger" Display="Dynamic" />

                            <!-- Confirm Password -->
                            <label>Confirm Password</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" />
                            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Confirm password is required" CssClass="text-danger" Display="Dynamic" />
                            <asp:CompareValidator ID="cvPasswords" runat="server" ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword" ErrorMessage="Passwords do not match" CssClass="text-danger" Display="Dynamic" />

                            <!-- Country -->
                            <label>Country</label>
                            <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Select your country" Value="" Disabled="true" Selected="true" />
                                <asp:ListItem>Pakistan</asp:ListItem>
                                <asp:ListItem>India</asp:ListItem>
                                <asp:ListItem>United States</asp:ListItem>
                                <asp:ListItem>United Kingdom</asp:ListItem>
                                <asp:ListItem>Canada</asp:ListItem>
                                <asp:ListItem>Australia</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvCountry" runat="server" ControlToValidate="ddlCountry" InitialValue="" ErrorMessage="Please select a country" CssClass="text-danger" Display="Dynamic" />

                            <!-- Buttons -->
                            <div class="d-flex justify-content-between mt-3">
                                <asp:Button ID="btnSignUp" runat="server" CssClass="btn btn-primary" Text="Sign Up" OnClick="btnSignUp_Click" />
                                <asp:Button ID="btnAlreadyRegistered" runat="server"
                                    CssClass="btn btn-outline-secondary"
                                    Text="Already Registered?"
                                    OnClick="btnAlreadyRegistered_Click"
                                    UseSubmitBehavior="false"
                                    CausesValidation="false" />
                            </div>
                        </asp:Panel>

                        <!-- Login Panel -->
                        <asp:Panel ID="pnlAlreadyRegistered" runat="server" Visible="false">
                            <!-- Username for Login -->
                            <label>Username</label>
                            <asp:TextBox ID="txtLoginUsername" runat="server" CssClass="form-control" />
                            <asp:RequiredFieldValidator ID="rfvLoginUsername" runat="server" ControlToValidate="txtLoginUsername" ErrorMessage="Username is required" CssClass="text-danger" Display="Dynamic" />

                            <!-- Password -->
                            <label>Password</label>
                            <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="form-control" TextMode="Password" />
                            <asp:RequiredFieldValidator ID="rfvLoginPassword" runat="server" ControlToValidate="txtLoginPassword" ErrorMessage="Password is required" CssClass="text-danger" Display="Dynamic" />

                            <div class="text-end mt-3">
                                <asp:Button ID="btnLogin" runat="server" CssClass="btn btn-success" Text="Continue" OnClick="btnLogin_Click" />
                            </div>
                        </asp:Panel>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        window.onload = function () {
            setTimeout(function () {
                document.getElementById('<%= txtName.ClientID %>').value = '';
                document.getElementById('<%= ddlCountry.ClientID %>').selectedIndex = 0;
            }, 100);
        };
    </script>
</asp:Content>
