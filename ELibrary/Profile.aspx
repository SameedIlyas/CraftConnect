<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="ELibrary.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <div class="container my-5">
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="alert alert-danger" DisplayMode="BulletList" />

        <asp:Panel ID="pnlProfile" runat="server" CssClass="card shadow-lg border-0 rounded-4 p-4">

            <h2 class="mb-4 fw-bold text-primary text-center">My Profile</h2>

            <!-- Profile Picture -->
            <div class="mb-4 text-center">
                <asp:Image ID="imgProfile" runat="server" CssClass="rounded-circle shadow-sm border border-secondary" Width="150px" Height="150px" />
                <asp:FileUpload ID="fileUploadProfilePic" runat="server" CssClass="form-control mt-3 w-50 mx-auto" />
            </div>

            <!-- Editable Fields -->
            <div class="row g-3">
                <!-- Full Name -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Full Name</label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                        ErrorMessage="Full name is required" CssClass="text-danger" Display="Dynamic" />
                </div>

                <!-- Username -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername"
                        ErrorMessage="Username is required" CssClass="text-danger" Display="Dynamic" />
                    <asp:Label ID="lblUsernameStatus" runat="server" CssClass="text-danger small" />
                </div>

                <!-- Country Dropdown -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Country</label>
                    <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Select your country" Value="" Disabled="true" Selected="True" />
                        <asp:ListItem>Pakistan</asp:ListItem>
                        <asp:ListItem>India</asp:ListItem>
                        <asp:ListItem>United States</asp:ListItem>
                        <asp:ListItem>United Kingdom</asp:ListItem>
                        <asp:ListItem>Canada</asp:ListItem>
                        <asp:ListItem>Australia</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCountry" runat="server" ControlToValidate="ddlCountry"
                        InitialValue="" ErrorMessage="Please select your country" CssClass="text-danger" Display="Dynamic" />
                </div>

                <!-- Phone Number -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Phone Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
                    <asp:RegularExpressionValidator ID="revPhone" runat="server"
                        ControlToValidate="txtPhone"
                        ValidationExpression="^03\d{9}$"
                        ErrorMessage="Enter a valid phone number" CssClass="text-danger" Display="Dynamic" />
                </div>

                <!-- Skills (Only visible to Artisans) -->
                <asp:Panel ID="pnlSkills" runat="server" Visible="false" CssClass="col-12">
                    <label class="form-label fw-semibold">Skills</label>
                    <asp:TextBox ID="txtSkills" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"
                        placeholder="e.g., Pottery, Woodwork, Calligraphy" />
                </asp:Panel>
            </div>

            <!-- Save Button -->
            <div class="mt-4 d-flex justify-content-end">
                <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn btn-primary px-4" OnClick="btnSave_Click" />
            </div>

            <!-- Status Message -->
            <asp:Label ID="lblStatus" runat="server" CssClass="text-success mt-3 fw-semibold d-block text-center" />
        </asp:Panel>
    </div>
</asp:Content>




