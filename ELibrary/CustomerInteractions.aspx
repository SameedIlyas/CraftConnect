<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerInteractions.aspx.cs" Inherits="ELibrary.CustomerInteractions" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Customer Interactions - CraftConnect</title>
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
                        <li><asp:Label ID="lblUsername" runat="server" CssClass="dropdown-item fw-bold text-muted"></asp:Label></li>
                        <li><hr class="dropdown-divider" /></li>
                        <li><a class="dropdown-item" href="Profile.aspx"><i class="bi bi-person me-2"></i>My Profile</a></li>
                        <li><a class="dropdown-item text-danger" href="Logout.aspx"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Filter Panel -->
        <div class="mb-4">
            <label for="ddlProducts" class="form-label fw-bold">
                <i class="bi bi-filter-circle me-1"></i>Filter by Product:
            </label>
            <asp:DropDownList ID="ddlProducts" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="ddlProducts_SelectedIndexChanged"
                CssClass="form-select shadow-sm border-primary">
                <asp:ListItem Text="-- All Products --" Value="0" />
            </asp:DropDownList>
        </div>

<!-- Average Ratings Section -->
        <asp:Repeater ID="rptAvgRatings" runat="server">
            <HeaderTemplate>
                <h5 class="fw-bold mb-3"><i class="bi bi-star-fill text-warning me-1"></i>Average Ratings</h5>
                <ul class="list-group mb-4">
            </HeaderTemplate>
            <ItemTemplate>
                <li class="list-group-item d-flex justify-content-between align-items-center shadow-sm">
                    <span class="fw-semibold"><%# Eval("ProductName") %></span>
                    <span class="badge bg-primary rounded-pill fs-6">
                        <%# Eval("AverageRating") %>/5
                    </span>
                </li>
            </ItemTemplate>
            <FooterTemplate>
                </ul>
            </FooterTemplate>
        </asp:Repeater>

<!-- No Feedback Panel -->
        <asp:Panel ID="pnlNoFeedback" runat="server" Visible="false" CssClass="alert alert-warning shadow-sm fw-semibold">
            <i class="bi bi-exclamation-triangle me-2"></i>No customer feedback found for your products.
        </asp:Panel>

<!-- Feedback List -->
        <asp:Repeater ID="rptProductFeedback" runat="server" OnItemCommand="rptProductFeedback_ItemCommand">
            <ItemTemplate>
                <div class="card shadow-sm mb-4 border-primary animate__animated animate__fadeIn">
                    <div class="card-header bg-primary text-white">
                        <h6 class="mb-0"><i class="bi bi-box-seam me-2"></i><%# Eval("ProductName") %></h6>
                    </div>
                    <div class="card-body">
                        <p class="mb-1"><i class="bi bi-person-circle me-1"></i><strong>User:</strong> <%# Eval("UserName") %></p>
                        <p class="mb-1"><i class="bi bi-star-fill text-warning me-1"></i><strong>Rating:</strong> <%# Eval("Rating") %>/5</p>
                        <p class="mb-2"><i class="bi bi-chat-left-text me-1"></i><strong>Comment:</strong> <%# Eval("Comment") %></p>

                        <div class="mb-3">
                            <i class="bi bi-reply me-1"></i><strong>Response:</strong><br />
                            <%# string.IsNullOrEmpty(Eval("Response").ToString()) ? "<span class='text-muted'>No response yet</span>" : Eval("Response") %>
                        </div>

                        <div class="mb-2">
                            <label for="txtResponse" class="form-label fw-semibold">Your Response:</label>
                            <asp:TextBox ID="txtResponse" runat="server" TextMode="MultiLine" Rows="3"
                                CssClass="form-control border-info"
                                Text='<%# Eval("Response") %>' />
                            <asp:RequiredFieldValidator ID="rfvResponse" runat="server"
                                ControlToValidate="txtResponse"
                                ErrorMessage="Response cannot be empty."
                                CssClass="text-danger fw-semibold"
                                Display="Dynamic" />
                        </div>

                        <asp:Button ID="btnRespond" runat="server" Text="Send Response"
                            CommandName="Respond"
                            CommandArgument='<%# Eval("Id") %>'
                            CssClass="btn btn-success mt-2 px-4" />
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>


<!-- Success Message Panel -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-success shadow-sm animate__animated animate__fadeInUp">
            <asp:Label ID="lblMessage" runat="server" CssClass="fw-semibold"></asp:Label>
        </asp:Panel>



        <script>
            document.getElementById('toggleSidebarBtn').addEventListener('click', () => {
                document.body.classList.toggle('sidebar-open');
            });
        </script>
        <script>
            window.onload = function () {
                const successPanel = document.querySelector(".alert-success");
                if (successPanel) {
                    setTimeout(() => {
                        successPanel.style.opacity = '0';
                        setTimeout(() => successPanel.style.display = 'none', 400);
                    }, 4000);
                }
            };
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>
