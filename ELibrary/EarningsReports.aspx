<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EarningsReports.aspx.cs" Inherits="ELibrary.EarningsReports" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Earnings and Reports</title>
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

        .dashboard-card {
            border-left: 4px solid #0d6efd;
            border-radius: 12px;
        }

        body {
            transition: margin-left 0.3s;
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
                        <li>
                            <asp:Label ID="Label1" runat="server" CssClass="dropdown-item fw-bold text-muted"></asp:Label></li>
                        <li>
                            <hr class="dropdown-divider" />
                        </li>
                        <li><a class="dropdown-item" href="Profile.aspx"><i class="bi bi-person me-2"></i>My Profile</a></li>
                        <li><a class="dropdown-item text-danger" href="Logout.aspx"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Filter Panel -->
        <div class="row mb-4">
            <div class="col-md-3">
                <label class="form-label fw-bold"><i class="bi bi-calendar-month me-1"></i>Month:</label>
                <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged"></asp:DropDownList>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-bold"><i class="bi bi-calendar me-1"></i>Year:</label>
                <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged"></asp:DropDownList>
            </div>
        </div>

        <!-- Earnings Summary Card -->
        <div class="card shadow-sm border-success mb-4 animate__animated animate__fadeIn">
            <div class="card-body bg-light">
                <h5 class="card-title text-success"><i class="bi bi-cash-coin me-1"></i>Total Earnings</h5>
                <p class="fs-4 fw-bold text-dark">Rs. <asp:Label ID="lblTotalEarnings" runat="server" /></p>
                <hr />
                <p class="mb-1"><i class="bi bi-easel2 me-1 text-primary"></i><strong>Workshop Revenue:</strong> Rs. <asp:Label ID="lblWorkshopRevenue" runat="server" /></p>
                <p><i class="bi bi-bag-check me-1 text-warning"></i><strong>Product Sales Revenue:</strong> Rs. <asp:Label ID="lblProductRevenue" runat="server" /></p>
            </div>
        </div>

        <!-- Workshop History -->
        <h4 class="mb-3"><i class="bi bi-clock-history me-1"></i>Workshop History</h4>
        <asp:Repeater ID="rptWorkshops" runat="server">
            <HeaderTemplate>
                <div class="table-responsive animate__animated animate__fadeInUp">
                    <table class="table table-hover table-striped table-bordered align-middle">
                        <thead class="table-light text-center">
                            <tr>
                                <th>Title</th>
                                <th>Date</th>
                                <th>Fee</th>
                                <th>Participants</th>
                                <th>Total Revenue</th>
                            </tr>
                        </thead>
                        <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr class="text-center">
                    <td><%# Eval("Title") %></td>
                    <td><%# Eval("Date", "{0:yyyy-MM-dd}") %></td>
                    <td>Rs. <%# Eval("Fee") %></td>
                    <td><%# Eval("Participants") %></td>
                    <td>Rs. <%# Convert.ToDecimal(Eval("Fee")) * Convert.ToInt32(Eval("Participants")) %></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                        </tbody>
                    </table>
                </div>
            </FooterTemplate>
        </asp:Repeater>

        <!-- No Data Panel -->
        <asp:Panel ID="pnlNoWorkshops" runat="server" CssClass="alert alert-info animate__animated animate__fadeIn" Visible="false">
            <i class="bi bi-info-circle me-1"></i>No completed workshops found for the selected period.
        </asp:Panel>


        <script>
            document.getElementById('toggleSidebarBtn').addEventListener('click', () => {
                document.body.classList.toggle('sidebar-open');
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>

