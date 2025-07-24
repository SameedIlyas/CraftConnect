<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ArtisanDashboard.aspx.cs" Inherits="ELibrary.ArtisanDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Artisan Dashboard</title>
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

        .edit-btn, .cancel-btn {
            margin-right: 5px;
        }

        .fade-anim {
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
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
    <form id="form2" runat="server">
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

        <!-- Dashboard Stats -->
        <div class="container mt-5">
            <div class="row g-3" data-aos="fade-up">
                <div class="col-md-6 col-lg-4 fade-anim">
                    <div class="card dashboard-card p-4 text-center">
                        <h6 class="fw-bold text-muted">Total Orders</h6>
                        <asp:Label ID="lblTotalOrders" runat="server" CssClass="fs-4 text-primary"></asp:Label>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 fade-anim">
                    <div class="card dashboard-card p-4 text-center">
                        <h6 class="fw-bold text-muted">Earnings</h6>
                        <asp:Label ID="lblEarnings" runat="server" CssClass="fs-4 text-warning"></asp:Label>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4 fade-anim">
                    <div class="card dashboard-card p-4 text-center">
                        <h6 class="fw-bold text-muted">Pending</h6>
                        <asp:Label ID="lblPendingOrders" runat="server" CssClass="fs-4 text-danger"></asp:Label>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-end mb-3 mt-4 fade-anim">
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" CssClass="form-select w-auto" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                    <asp:ListItem Text="All" Value="" />
                    <asp:ListItem Text="Processing" Value="Processing" />
                    <asp:ListItem Text="Out for Delivery" Value="Out for Delivery" />
                    <asp:ListItem Text="Completed" Value="Completed" />
                </asp:DropDownList>
            </div>

            <div class="fade-anim">
                <asp:GridView ID="gvRecentOrders" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-hover" DataKeyNames="OrderID" OnRowEditing="gvRecentOrders_RowEditing" OnRowCancelingEdit="gvRecentOrders_RowCancelingEdit" OnRowUpdating="gvRecentOrders_RowUpdating">
                    <Columns>
                        <asp:BoundField DataField="OrderID" HeaderText="Order ID" ReadOnly="True" />
                        <asp:BoundField DataField="CustomerName" HeaderText="Customer" ReadOnly="True" />
                        <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="{0:N2}" ReadOnly="True" />
                        <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" ReadOnly="True" />
                        <asp:TemplateField HeaderText="Status">
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlStatus" runat="server">
                                    <asp:ListItem Text="Processing" />
                                    <asp:ListItem Text="Out for Delivery" />
                                    <asp:ListItem Text="Completed" />
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <%# Eval("Status") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn btn-sm btn-outline-primary edit-btn"><i class="bi bi-pencil-square"></i></asp:LinkButton>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" CssClass="btn btn-sm btn-success me-2"><i class="bi bi-check-circle"></i></asp:LinkButton>
                                <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CssClass="btn btn-sm btn-secondary cancel-btn"><i class="bi bi-x-circle"></i></asp:LinkButton>
                            </EditItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div aria-live="polite" aria-atomic="true" class="position-relative">
                <div class="toast-container position-fixed bottom-0 end-0 p-3">
                    <div id="updateToast" class="toast align-items-center text-bg-success border-0 fade-anim" role="alert">
                        <div class="d-flex">
                            <div class="toast-body">Order status updated successfully!</div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.getElementById('toggleSidebarBtn').addEventListener('click', () => {
                document.body.classList.toggle('sidebar-open');
            });
            function showToast() {
                var toastElement = document.getElementById('updateToast');
                var toast = new bootstrap.Toast(toastElement);
                toast.show();
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
        <script>AOS.init({ duration: 1000, once: true });</script>
    </form>
</body>
</html>
