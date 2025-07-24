<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditUser.aspx.cs" Inherits="ELibrary.Admin.EditUser" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Edit User</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        .edit-form {
            max-width: 700px;
            margin: auto;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            padding: 30px;
            background-color: #fff;
            border-radius: 8px;
        }
        body {
            background-color: #f8f9fa;
        }

        .offcanvas-body a {
            font-weight: 500;
            margin-bottom: 10px;
            display: block;
        }

        .offcanvas-body a:hover {
            color: #dc3545;
            text-decoration: none;
        }

        .admin-sidebar-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 1rem;
        }

        .admin-sidebar-header img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }

        .user-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: pointer;
        }

        .user-card:hover {
            transform: scale(1.03);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .role-badge {
            font-size: 0.8rem;
        }
        .edit-form {
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-label {
            font-weight: 500;
        }

        .form-control:invalid {
            border-color: #dc3545;
        }
</style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <header class="bg-dark p-3 d-flex justify-content-between align-items-center text-white">
            <button class="btn btn-outline-light" type="button" data-bs-toggle="offcanvas" data-bs-target="#adminSidebar" aria-controls="adminSidebar">
                <i class="bi bi-list fs-4"></i>
            </button>
            <h4 class="m-0">Admin Panel</h4>
            <asp:Label ID="Label1" runat="server" CssClass="fw-semibold" />
        </header>

        <!-- Offcanvas Sidebar -->
        <div class="offcanvas offcanvas-start bg-light" tabindex="-1" id="adminSidebar" aria-labelledby="adminSidebarLabel">
            <div class="offcanvas-header">
                <div class="admin-sidebar-header">
                    <img src="../images/admin.png" alt="Admin" />
                    <h5 class="mb-0" id="adminSidebarLabel">Admin Menu</h5>
                </div>
                <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas"></button>
            </div>
            <div class="offcanvas-body">
                <a class="nav-link" href="AdminDashboard.aspx"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
                <a class="nav-link" href="ManageUsers.aspx"><i class="bi bi-people-fill me-2"></i>Manage Users</a>
                <a class="nav-link" href="ManageProducts.aspx"><i class="bi bi-box-seam me-2"></i>Manage Products</a>
                <a class="nav-link" href="SendNotification.aspx"><i class="bi bi-bell-fill me-2"></i>Send Notification</a>
                <hr />
                <a class="nav-link text-danger" href="../Logout.aspx"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
            </div>
        </div>

        <div class="container mt-5">
    <h2 class="text-center mb-4">Edit User</h2>

    <asp:Panel ID="pnlEditForm" runat="server" CssClass="edit-form card p-4 shadow">
        <asp:ValidationSummary runat="server" CssClass="text-danger mb-3" />

        <!-- Username -->
        <div class="mb-3">
            <label class="form-label">Username</label>
            <asp:TextBox ID="txtUName" runat="server" CssClass="form-control" required="required" />
            <asp:RequiredFieldValidator ControlToValidate="txtUName" runat="server" CssClass="text-danger" Display="Dynamic" ErrorMessage="Username is required." />
        </div>

        <!-- Full Name -->
        <div class="mb-3">
            <label class="form-label">Full Name</label>
            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" required="required" />
            <asp:RequiredFieldValidator ControlToValidate="txtFullName" runat="server" CssClass="text-danger" Display="Dynamic" ErrorMessage="Full Name is required." />
        </div>

        <!-- Email -->
        <div class="mb-3">
            <label class="form-label">Email</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" required="required" />
            <asp:RequiredFieldValidator ControlToValidate="txtEmail" runat="server" CssClass="text-danger" Display="Dynamic" ErrorMessage="Email is required." />
        </div>

        <!-- Phone -->
        <div class="mb-3">
            <label class="form-label">Phone Number</label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" required="required" />
            <asp:RequiredFieldValidator ControlToValidate="txtPhone" runat="server" CssClass="text-danger" Display="Dynamic" ErrorMessage="Phone Number is required." />
        </div>

        <!-- Country -->
        <div class="mb-3">
            <label class="form-label">Country</label>
            <asp:TextBox ID="txtCountry" runat="server" CssClass="form-control" required="required" />
            <asp:RequiredFieldValidator ControlToValidate="txtCountry" runat="server" CssClass="text-danger" Display="Dynamic" ErrorMessage="Country is required." />
        </div>

        <!-- Role -->
        <div class="mb-3">
            <label class="form-label">Role</label>
            <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlRole_SelectedIndexChanged">
                <asp:ListItem Text="User" Value="User" />
                <asp:ListItem Text="Artisan" Value="Artisan" />
            </asp:DropDownList>
        </div>

        <!-- Is Active -->
        <div class="form-check mb-3">
            <asp:CheckBox ID="chkIsActive" runat="server" CssClass="form-check-input" />
            <label class="form-check-label" for="chkIsActive">Active</label>
        </div>

        <!-- Artisan Section -->
        <asp:Panel ID="pnlArtisan" runat="server" CssClass="artisan-section mt-4" Visible="false">
            <hr />
            <h5 class="mb-3">Artisan Details</h5>

            <div class="mb-3">
                <label class="form-label">Store Name</label>
                <asp:TextBox ID="txtStoreName" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Category</label>
                <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
            </div>

            <div class="mb-3">
                <label class="form-label">Skills</label>
                <asp:TextBox ID="txtSkills" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Approval Status</label>
                <asp:DropDownList ID="ddlApprovalStatus" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Pending" Value="Pending" />
                    <asp:ListItem Text="Approved" Value="Approved" />
                    <asp:ListItem Text="Rejected" Value="Rejected" />
                </asp:DropDownList>
            </div>
        </asp:Panel>

        <!-- Profile Picture -->
        <div class="mb-3">
            <label class="form-label">Profile Picture</label>
            <asp:FileUpload ID="fuProfilePicture" runat="server" CssClass="form-control" />
            <asp:Image ID="imgPreview" runat="server" Width="100" Height="100" CssClass="mt-2 rounded" />
        </div>

        <!-- Submit -->
        <asp:Button ID="btnUpdate" runat="server" Text="Update User" CssClass="btn btn-success w-100 mt-3" OnClick="btnUpdate_Click" />
    </asp:Panel>

    <!-- Message -->
    <asp:Label ID="lblMessage" runat="server" CssClass="text-danger mt-3 d-block text-center" />

    <!-- Error Panel -->
    <asp:Panel ID="pnlError" runat="server" Visible="false">
        <div class="alert alert-danger text-center mt-4">User not found or cannot be edited.</div>
    </asp:Panel>
</div>

    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
