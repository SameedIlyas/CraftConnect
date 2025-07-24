<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SendNotifications.aspx.cs" Inherits="ELibrary.Admin.SendNotifications" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Send Notifications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        .form-container {
            max-width: 600px;
            margin: 40px auto;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
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
            .form-container {
        max-width: 600px;
        margin: 0 auto;
        animation: fadeInDown 0.6s ease-in-out;
        padding: 30px;
        border-radius: 12px;
        background-color: #f8f9fa;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
    }

    @keyframes fadeInDown {
        from {
            opacity: 0;
            transform: translateY(-20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .form-label {
        font-weight: 600;
    }
    </style>
</head>
<body>
    <form id="form1" runat="server">
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

        <div class="form-container">
            <h3 class="mb-4 text-primary text-center"><i class="bi bi-megaphone-fill me-2"></i>Send Notification</h3>

            <div class="mb-3">
                <label for="ddlUsers" class="form-label">Select User</label>
                <asp:DropDownList ID="ddlUsers" runat="server" CssClass="form-select" AppendDataBoundItems="true">
                    <asp:ListItem Text="-- Select User or All --" Value="" />
                    <asp:ListItem Text="All" Value="All" />
                </asp:DropDownList>
            </div>

            <div class="mb-3">
                <label for="txtMessage" class="form-label">Message <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" />
                <asp:RequiredFieldValidator ID="rfvMessage" runat="server"
                    ControlToValidate="txtMessage"
                    Display="Dynamic"
                    ErrorMessage="Message cannot be empty."
                    CssClass="text-danger"
                    ValidationGroup="SendGroup" />
            </div>

            <asp:Button ID="btnSend" runat="server" Text="Send Notification"
                CssClass="btn btn-success w-100"
                ValidationGroup="SendGroup"
                OnClick="btnSend_Click" />

            <asp:Label ID="lblResult" runat="server" CssClass="mt-3 d-block text-success fw-semibold text-center" />
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
