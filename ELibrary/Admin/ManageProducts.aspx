<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageProducts.aspx.cs" Inherits="ELibrary.Admin.ManageProducts" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Manage Products</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        .product-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: pointer;
        }

        .product-card:hover {
            transform: scale(1.03);
            box-shadow: 0 6px 14px rgba(0, 0, 0, 0.15);
        }

        .card-img-top {
            height: 200px;
            object-fit: cover;
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

        <div class="container mt-4">
            <h2 class="mb-4">Manage Products</h2>

            <asp:Panel ID="pnlNoProducts" runat="server" Visible="false">
                <div class="alert alert-warning">No products found.</div>
            </asp:Panel>

            <div class="row">
                <asp:Repeater ID="rptProducts" runat="server">
                    <ItemTemplate>
                        <div class="col-md-4 mb-4">
                            <div class="card product-card" onclick="location.href='ProductDetails.aspx?ProductId=<%# Eval("ProductId") %>'">
                               <img src='<%# ResolveUrl("~/") + Eval("ImagePath") %>' class="img-fluid card-img-top" alt="Product Image" />
                                <div class="card-body">
                                    <h5 class="card-title"><%# Eval("ProductName") %></h5>
                                    <p class="card-text text-muted"><%# Eval("SellerName") %></p>
                                    <p class="card-text"><strong>Rs <%# Eval("Price") %></strong></p>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
