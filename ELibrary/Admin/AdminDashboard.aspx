<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="ELibrary.Admin.AdminDashboard" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
        <style>
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
        .artisan-card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s;
        }
        .artisan-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
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
       <div class="container mt-5">
        <h2 class="mb-4 text-center">Artisan Approval Dashboard</h2>

        <!-- Pending Requests Badge -->
        <div class="text-center mb-4">
            <asp:Label ID="lblPendingRequests" runat="server" CssClass="badge bg-danger fs-6 px-4 py-2 rounded-pill shadow-sm"></asp:Label>
        </div>

        <!-- Artisan Cards -->
        <asp:Repeater ID="rptArtisans" runat="server" OnItemCommand="rptArtisans_ItemCommand">
            <ItemTemplate>
                <div class="card shadow-sm mb-4 artisan-card animate__animated animate__fadeIn">
                    <div class="card-body">
                        <h5 class="card-title text-primary fw-bold">
                            <%# Eval("StoreName") %>
                            <span class="badge bg-secondary float-end"><%# Eval("ApprovalStatus") %></span>
                        </h5>
                        <p class="mb-2"><strong>Owner:</strong> <%# Eval("UName") %> (<%# Eval("Email") %>)</p>
                        <p class="mb-2"><strong>Category:</strong> <%# Eval("Category") %></p>
                        <p class="mb-3"><strong>Description:</strong> <%# Eval("Description") %></p>
                        <div class="d-flex justify-content-end gap-2">
                            <asp:Button ID="btnApprove" runat="server" Text="Approve" CssClass="btn btn-success btn-sm"
                                CommandName="Approve" CommandArgument='<%# Eval("ArtisanId") %>' CausesValidation="false" />
                            <asp:Button ID="btnReject" runat="server" Text="Reject" CssClass="btn btn-danger btn-sm"
                                CommandName="Reject" CommandArgument='<%# Eval("ArtisanId") %>' CausesValidation="false" />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <!-- No Requests Panel -->
        <asp:Panel ID="pnlNoRequests" runat="server" Visible="false" CssClass="alert alert-info text-center mt-4">
            No pending artisan requests at the moment.
        </asp:Panel>
    </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
