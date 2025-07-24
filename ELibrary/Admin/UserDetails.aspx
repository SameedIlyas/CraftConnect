<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserDetails.aspx.cs" Inherits="ELibrary.Admin.UserDetails" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>User Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        .card-profile {
            max-width: 700px;
            margin: auto;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }

        .card-profile:hover {
            transform: translateY(-2px);
            transition: transform 0.2s ease;
        }

        .profile-img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #ddd;
            margin-bottom: 15px;
        }

        .section-heading {
            font-weight: bold;
            margin-top: 20px;
            border-bottom: 1px solid #ccc;
            padding-bottom: 5px;
        }

        .btn-group .btn {
            min-width: 120px;
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <header class="bg-dark p-3 d-flex justify-content-between align-items-center text-white">
            <button class="btn btn-outline-light" type="button" data-bs-toggle="offcanvas" data-bs-target="#adminSidebar" aria-controls="adminSidebar">
                <i class="bi bi-list fs-4"></i>
            </button>
            <h4 class="m-0">Admin Panel</h4>
            <asp:Label ID="lblAdminName" runat="server" CssClass="fw-semibold" />
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
            <h2 class="text-center mb-4">User Details</h2>

            <asp:Panel ID="pnlDetails" runat="server" Visible="false">
                <div class="card card-profile p-4">
                    <div class="card-body text-center">
                        <asp:Image ID="imgProfile" runat="server" CssClass="profile-img" />
                        <h4 class="card-title mb-3"><asp:Label ID="lblUserName" runat="server" /></h4>
                        <p><strong>Full Name:</strong> <asp:Label ID="lblFullName" runat="server" /></p>
                        <p><strong>Email:</strong> <asp:Label ID="lblEmail" runat="server" /></p>
                        <p><strong>Phone:</strong> <asp:Label ID="lblPhone" runat="server" /></p>
                        <p><strong>Role:</strong> <asp:Label ID="lblRole" runat="server" /></p>
                        <p><strong>Country:</strong> <asp:Label ID="lblCountry" runat="server" /></p>
                        <p><strong>Status:</strong> <asp:Label ID="lblActive" runat="server" /></p>
                        <p><strong>Registered On:</strong> <asp:Label ID="lblDate" runat="server" /></p>

                        <asp:Panel ID="pnlArtisan" runat="server" Visible="false">
                            <div class="section-heading text-start mt-4">Artisan Info</div>
                            <p><strong>Store Name:</strong> <asp:Label ID="lblStoreName" runat="server" /></p>
                            <p><strong>Category:</strong> <asp:Label ID="lblCategory" runat="server" /></p>
                            <p><strong>Description:</strong> <asp:Label ID="lblDescription" runat="server" /></p>
                            <p><strong>Skills:</strong> <asp:Label ID="lblSkills" runat="server" /></p>
                            <p><strong>Approval Status:</strong> <asp:Label ID="lblApproval" runat="server" /></p>
                            <p><strong>Joined On:</strong> <asp:Label ID="lblJoined" runat="server" /></p>
                        </asp:Panel>

                        <div class="btn-group mt-4">
                            <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btn btn-primary" OnClick="btnEdit_Click" />
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-danger" OnClick="btnDelete_Click" OnClientClick="return confirm('Are you sure you want to delete this user?');" />
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div class="alert alert-danger text-center">User not found.</div>
            </asp:Panel>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
