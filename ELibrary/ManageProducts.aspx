<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageProducts.aspx.cs" Inherits="ELibrary.ManageProducts" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Product Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body.sidebar-open {
            margin-left: 250px;
        }

        #sidebar {
            width: 250px;
            background: linear-gradient(135deg, #0d6efd, #00b4d8);
            position: fixed;
            top: 0;
            left: -250px;
            height: 100%;
            z-index: 1040;
            transition: left 0.3s ease-in-out;
            overflow-y: auto;
            padding-top: 60px;
        }

        body.sidebar-open #sidebar {
            left: 0;
        }

        .nav-link {
            color: white;
            padding: 12px 20px;
            transition: 0.3s;
        }

        .nav-link:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        body {
            transition: margin-left 0.3s;
            background-color: #f0f2f5;
        }


        .product-img {
            border-bottom: 1px solid #dee2e6;
            transition: transform 0.3s ease;
        }

        .card:hover .product-img {
            transform: scale(1.03);
        }

        .card:hover {
            box-shadow: 0 8px 16px rgba(0,0,0,0.12);
        }

        .hidden-panel {
            display: none;
        }

        .hidden-panel.visible {
            display: block;
            animation: fadeIn 0.4s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .alert-container .alert {
            padding: 12px;
            border-radius: 5px;
            font-weight: 500;
            transition: opacity 0.5s ease-out;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

                .profile-card, .navbar {
            background-color: #fff;
        }

        .sidebar-logo {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 50%;
        }

        .navbar {
            position: sticky;
            top: 0;
            z-index: 1050;
            border-bottom: 1px solid #e0e0e0;
        }

        .icon-wrapper {
            position: relative;
            margin-right: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Sidebar -->
        <div id="sidebar">
            <div class="text-center text-white">
                <h5 class="fw-bold">CraftConnect</h5>
                <img src="images/cc.jpg" class="sidebar-logo" alt="Logo" />
                <h6 class="fw-bold mt-3">Dashboard</h6>
                <ul class="nav flex-column mt-3">
                    <li class="nav-item"><a href="ArtisanDashboard.aspx" class="nav-link">Overview</a></li>
                    <li class="nav-item"><a href="ManageStore.aspx" class="nav-link">Store</a></li>
                    <li class="nav-item"><a href="ManageProducts.aspx" class="nav-link">Products</a></li>
                    <li class="nav-item"><a href="ManageWorkshops.aspx" class="nav-link">Workshops</a></li>
                    <li class="nav-item"><a href="CustomerInteractions.aspx" class="nav-link">Customers</a></li>
                    <li class="nav-item"><a href="EarningsReports.aspx" class="nav-link">Reports</a></li>
                    <li class="nav-item"><a href="homepage.aspx" class="nav-link">← Back</a></li>
                </ul>
            </div>
        </div>

        <!-- Navbar -->
        <nav class="navbar px-3 py-2 d-flex justify-content-between align-items-center shadow-sm">
            <div>
                <button type="button" class="btn" id="toggleSidebarBtn">
                    <i class="bi bi-list fs-3"></i>
                </button>
                <span class="fs-4 fw-bold ms-2">Dashboard</span>
            </div>
            <div class="d-flex align-items-center">
                <a href="Notifications.aspx" class="text-decoration-none position-relative me-3">
                    <i class="bi bi-bell fs-4"></i>
                </a>
                <div class="dropdown">
                    <a class="d-flex align-items-center text-decoration-none dropdown-toggle" href="#" id="profileDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle fs-4 me-2"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                        <li><asp:Label ID="lblUsername" runat="server" CssClass="dropdown-item fw-bold text-muted"></asp:Label></li>
                        <li><hr class="dropdown-divider" /></li>
                        <li><a class="dropdown-item" href="Profile.aspx"><i class="bi bi-person me-2"></i>My Profile</a></li>
                        <li><a class="dropdown-item text-danger" href="Logout.aspx"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-5">
            <h2 class="mb-4">Product Management</h2>

            <asp:Button ID="btnShowForm" runat="server" Text="Add Product" OnClick="BtnShowForm_Click" CssClass="btn btn-primary mb-3" CausesValidation="false" />

            <asp:Panel ID="pnlAddProduct" runat="server" CssClass="card p-4 mb-4" Visible="false">
                <h4>Add / Edit Product</h4>
                <div class="row g-3">
                    <div class="col-md-6">
                        <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" placeholder="Product Name" required="required" />
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" placeholder="Price (PKR)" TextMode="Number" required="required" min="1" />
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control" placeholder="Quantity" TextMode="Number" required="required" min="1" />
                    </div>
                    <div class="col-md-6">
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" required="required">
                            <asp:ListItem Text="Select Category" Value="" />
                            <asp:ListItem Text="Apparel" Value="Apparel" />
                            <asp:ListItem Text="Footwear" Value="Footwear" />
                            <asp:ListItem Text="Jewellery" Value="Jewellery" />
                            <asp:ListItem Text="Gift" Value="Gift" />
                            <asp:ListItem Text="Home Decor" Value="Home Decor" />
                            <asp:ListItem Text="Accessories" Value="Accessories" />
                            <asp:ListItem Text="Others" Value="Others" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-12">
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Description" required="required" />
                    </div>
                    <div class="col-12">
                        <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-12">
                        <asp:Button ID="btnSave" runat="server" CssClass="btn btn-success" Text="Save Product" OnClick="btnSave_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                            CssClass="btn btn-secondary ms-2"
                            OnClick="btnCancel_Click"
                            CausesValidation="false"
                            UseSubmitBehavior="false" />
                        <asp:HiddenField ID="hfProductId" runat="server" />
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert-container mt-3">
                <asp:Label ID="lblMessage" runat="server" CssClass="alert" />
            </asp:Panel>

            <h4 class="mb-4"><i class="bi bi-box-seam me-1"></i>Available Products</h4>
            <asp:Repeater ID="rptProducts" runat="server">
                <HeaderTemplate>
                    <div class="row g-4">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="col-md-4">
                        <div class="card h-100 shadow animate__animated animate__fadeInUp">
                            <img src='<%# Eval("ImagePath") %>' class="card-img-top product-img rounded-top" alt="Product Image" style="height: 220px; object-fit: cover;" />
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title text-primary"><%# Eval("ProductName") %></h5>
                                <ul class="list-unstyled mb-3">
                                    <li><i class="bi bi-tags me-2 text-secondary"></i><strong>Category:</strong> <%# Eval("CategoryName") %></li>
                                    <li><i class="bi bi-cash-coin me-2 text-success"></i><strong>Price:</strong> PKR <%# Eval("Price") %></li>
                                    <li><i class="bi bi-boxes me-2 text-warning"></i><strong>Stock:</strong> <%# Eval("Quantity") %></li>
                                </ul>
                                <div class="mt-auto d-flex justify-content-between">
                                    <asp:Button runat="server" CommandName="Edit" CommandArgument='<%# Eval("ProductID") %>' Text="Edit" CssClass="btn btn-outline-primary btn-sm w-50 me-1" OnCommand="EditProduct_Command" CausesValidation="false" />
                                    <asp:Button runat="server" CommandName="Delete" CommandArgument='<%# Eval("ProductID") %>' Text="Delete" CssClass="btn btn-outline-danger btn-sm w-50" OnCommand="DeleteProduct_Command" CausesValidation="false" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>

        </div>
    </form>

    <script>
        document.getElementById('toggleSidebarBtn').addEventListener('click', () => {
            document.body.classList.toggle('sidebar-open');
        });

        // Auto-hide alert message after 4 seconds
        window.onload = function () {
            const alertPanel = document.querySelector('.alert-container .alert');
            if (alertPanel) {
                setTimeout(() => {
                    alertPanel.style.opacity = '0';
                    setTimeout(() => {
                        alertPanel.parentElement.style.display = 'none';
                    }, 500);
                }, 4000);
            }
        };
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
