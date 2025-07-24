<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageStore.aspx.cs" Inherits="ELibrary.ManageStore" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Manage Store - CraftConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet" />
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

        .dashboard-card {
            border-left: 5px solid #0d6efd;
            border-radius: 12px;
            background-color: #f8f9fa;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .fade-anim {
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
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
    </style>
</head>
<body class="bg-light">
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

        <div class="container py-5 fade-anim">
            <h2 class="mb-4 text-center">Manage Your Store</h2>
            <asp:Label ID="lblStatusMessage" runat="server" CssClass="alert alert-info d-block mb-4 text-center" Visible="false"></asp:Label>


            <asp:PlaceHolder ID="phStoreContent" runat="server" />

            <asp:Panel ID="pnlStoreDetails" runat="server" Visible="false" CssClass="card p-4 shadow-sm">
                <div class="mb-3">
                    <label class="form-label">Store Name</label>
                    <asp:TextBox ID="txtStoreName" runat="server" CssClass="form-control" required="true" />
                </div>
                <div class="mb-3">
                    <label class="form-label">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" required="true">
                        <asp:ListItem Text="Select a Category" Value="" />
                        <asp:ListItem Text="Apparel" Value="Apparel" />
                        <asp:ListItem Text="Footwear" Value="Footwear" />
                        <asp:ListItem Text="Jewellery" Value="Jewellery" />
                        <asp:ListItem Text="Gift" Value="Gift" />
                        <asp:ListItem Text="Home Decor" Value="Home Decor" />
                        <asp:ListItem Text="Accessories" Value="Accessories" />
                        <asp:ListItem Text="Others" Value="Others" />
                    </asp:DropDownList>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" required="true" />
                </div>
                <div class="mb-3">
                    <label class="form-label">Phone Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="03XXXXXXXXX"
    required="true" pattern="03[0-9]{9}" oninvalid="this.setCustomValidity('Enter a valid 11-digit number starting with 03')"
    oninput="setCustomValidity('')" />
                </div>
                <div class="mb-3">
                    <strong>Approval Status:</strong> <asp:Label ID="lblStatus" runat="server" CssClass="fw-bold" />
                </div>
                <asp:Button ID="btnUpdateStore" runat="server" CssClass="btn btn-primary" Text="Update Store Info" OnClick="btnEditStore_Click" />
            </asp:Panel>

            <asp:Panel ID="pnlProducts" runat="server" Visible="false" CssClass="mt-5">
                <h4>Your Products</h4>
                <asp:Repeater ID="rptProducts" runat="server">
                    <HeaderTemplate>
                        <div class="row fw-bold border-bottom py-2">
                            <div class="col-6">Product Name</div>
                            <div class="col-6">Price</div>
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="row border-bottom py-2">
                            <div class="col-6"><%# Eval("ProductName") %></div>
                            <div class="col-6">Rs <%# Eval("Price") %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>

            <asp:Panel ID="pnlNoStore" runat="server" Visible="false">
                <div class="alert alert-info text-center">
                    <p>You haven't created a store yet.</p>
                    <a href="ProfileCreation.aspx" class="btn btn-success">Create Store</a>
                </div>
            </asp:Panel>
        </div>

        <script>
            document.getElementById('toggleSidebarBtn').addEventListener('click', () => {
                document.body.classList.toggle('sidebar-open');
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
        <script>AOS.init({ duration: 1000, once: true });</script>
    </form>
</body>
</html>
