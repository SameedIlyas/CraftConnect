<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="ELibrary.Admin.ProductDetails" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Product Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        .card-product {
            max-width: 700px;
            margin: auto;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }

        .product-img {
            max-height: 300px;
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
        .card-product {
            animation: fadeInUp 0.6s ease-in-out;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            overflow: hidden;
        }

        .product-img {
            object-fit: cover;
            height: 300px;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .product-label {
            font-weight: 600;
            color: #555;
        }

        .product-value {
            font-size: 1.1rem;
            color: #333;
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
            <h2 class="text-center mb-4 fw-bold text-primary">Product Details</h2>

            <asp:Panel ID="pnlDetails" runat="server" Visible="false">
                <div class="card card-product mx-auto" style="max-width: 700px;">
                    <img id="imgProduct" runat="server" class="card-img-top product-img" alt="Product Image" />

                    <div class="card-body p-4">
                        <h4 class="card-title text-dark mb-3">
                            <asp:Label ID="lblProductName" runat="server" />
                        </h4>

                        <p><span class="product-label">Store:</span> <span class="product-value">
                            <asp:Label ID="lblStore" runat="server" /></span></p>
                        <p><span class="product-label">Description:</span> <span class="product-value">
                            <asp:Label ID="lblDescription" runat="server" /></span></p>
                        <p><span class="product-label">Category:</span> <span class="product-value">
                            <asp:Label ID="lblCategory" runat="server" /></span></p>
                        <p><span class="product-label">Price:</span> <span class="product-value text-success fw-semibold">Rs
                            <asp:Label ID="lblPrice" runat="server" /></span></p>

                        <asp:Button ID="btnDelete" runat="server"
                            CssClass="btn btn-outline-danger mt-4 w-100"
                            Text="Delete Product"
                            OnClientClick="return confirm('Are you sure you want to delete this product?');"
                            OnClick="btnDelete_Click" />
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div class="alert alert-danger text-center mt-4">⚠️ Product not found.</div>
            </asp:Panel>
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
