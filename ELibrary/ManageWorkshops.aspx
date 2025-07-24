<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageWorkshops.aspx.cs" Inherits="ELibrary.ManageWorkshops" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Manage Workshops</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
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
                            <asp:Label ID="lblUsername" runat="server" CssClass="dropdown-item fw-bold text-muted"></asp:Label></li>
                        <li>
                            <hr class="dropdown-divider" />
                        </li>
                        <li><a class="dropdown-item" href="Profile.aspx"><i class="bi bi-person me-2"></i>My Profile</a></li>
                        <li><a class="dropdown-item text-danger" href="Logout.aspx"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>

    <div class="container mt-5">
        <h2 class="text-center mb-4">Manage Your Workshops</h2>

        <!-- Notification Panel -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-info fade show text-center fw-semibold">
            <asp:Label ID="lblMessage" runat="server" />
        </asp:Panel>

        <!-- Workshop Creation Form -->
        <div class="card shadow-sm p-4 mb-5 border-start border-4 border-success animate__animated animate__fadeIn">
            <h4 class="mb-4 text-success"><i class="bi bi-plus-circle me-2"></i>Create / Update Workshop</h4>
            <div class="row g-3">

                <!-- Title -->
                <div class="col-md-6">
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Workshop Title" />
                    <asp:RequiredFieldValidator ControlToValidate="txtTitle" Display="Dynamic" CssClass="text-danger" runat="server" ErrorMessage="Title is required." />
                </div>

                <!-- Category -->
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Select Category" Value="" />
                        <asp:ListItem Text="Art" Value="Art" />
                        <asp:ListItem Text="Crafts" Value="Crafts" />
                        <asp:ListItem Text="Sewing" Value="Sewing" />
                        <asp:ListItem Text="Pottery" Value="Pottery" />
                        <asp:ListItem Text="Woodwork" Value="Woodwork" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlCategory" InitialValue="" CssClass="text-danger" runat="server" ErrorMessage="Category is required." />
                </div>

                <!-- Date -->
                <div class="col-md-6">
                    <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" TextMode="Date" />
                    <asp:RequiredFieldValidator ControlToValidate="txtDate" CssClass="text-danger" runat="server" ErrorMessage="Date is required." />
                </div>

                <!-- Time -->
                <div class="col-md-6">
                    <asp:TextBox ID="txtTime" runat="server" CssClass="form-control" TextMode="Time" />
                    <asp:RequiredFieldValidator ControlToValidate="txtTime" CssClass="text-danger" runat="server" ErrorMessage="Time is required." />
                </div>

                <!-- Duration -->
                <div class="col-md-6">
                    <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" placeholder="Duration (hours)" />
                    <asp:RequiredFieldValidator ControlToValidate="txtDuration" CssClass="text-danger" runat="server" ErrorMessage="Duration is required." />
                </div>

                <!-- Fee -->
                <div class="col-md-6">
                    <asp:TextBox ID="txtFee" runat="server" CssClass="form-control" placeholder="Fee (PKR)" />
                    <asp:RequiredFieldValidator ControlToValidate="txtFee" CssClass="text-danger" runat="server" ErrorMessage="Fee is required." />
                </div>

                <!-- Max Participants -->
                <div class="col-md-6">
                    <asp:TextBox ID="txtMaxParticipants" runat="server" CssClass="form-control" placeholder="Max Participants" />
                    <asp:RequiredFieldValidator ControlToValidate="txtMaxParticipants" CssClass="text-danger" runat="server" ErrorMessage="Max Participants required." />
                </div>

                <!-- Online Toggle -->
                <div class="col-md-6 d-flex align-items-center">
                    <div class="form-check">
                        <asp:CheckBox ID="chkIsOnline" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label ms-2" for="chkIsOnline">Online Workshop</label>
                    </div>
                </div>

                <!-- Location / Link -->
                <div class="col-md-12">
                    <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control" placeholder="Location or Online Link" />
                    <asp:RequiredFieldValidator ControlToValidate="txtLocation" CssClass="text-danger" runat="server" ErrorMessage="Location / Link required." />
                </div>

                <!-- Description -->
                <div class="col-md-12">
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Description" />
                    <asp:RequiredFieldValidator ControlToValidate="txtDescription" CssClass="text-danger" runat="server" ErrorMessage="Description required." />
                </div>

                <!-- Buttons -->
                <div class="col-12 d-flex gap-3 mt-2">
                    <asp:Button ID="btnCreate" runat="server" CssClass="btn btn-success w-50" Text="Create Workshop" OnClick="btnCreate_Click" />
                    <asp:Button ID="btnUpdate" runat="server" CssClass="btn btn-warning w-50" Text="Update Workshop" OnClick="btnUpdate_Click" Visible="false" />
                </div>

                <asp:HiddenField ID="hfWorkshopId" runat="server" />
            </div>
        </div>

        <!-- Workshop Filters -->
        <div class="d-flex justify-content-center gap-3 mb-3">
            <asp:Button ID="btnShowUpcoming" runat="server" Text="Upcoming"
                CssClass="btn btn-primary me-2"
                OnClick="btnShowUpcoming_Click"
                CausesValidation="false" />
            <asp:Button ID="btnShowCompleted" runat="server" Text="Completed"
                CssClass="btn btn-success me-2"
                OnClick="btnShowCompleted_Click"
                CausesValidation="false" />
            <asp:Button ID="btnShowCancelled" runat="server" Text="Cancelled"
                CssClass="btn btn-danger"
                OnClick="btnShowCancelled_Click"
                CausesValidation="false" />
        </div>

        <!-- Hidden field to keep current filter status -->
        <asp:HiddenField ID="hfCurrentStatus" runat="server" />

        <!-- Workshops List -->
        <div class="pb-5"> <!-- ✅ Padding bottom added here -->
            <asp:Repeater ID="rptWorkshops" runat="server" OnItemDataBound="rptWorkshops_ItemDataBound" OnItemCommand="rptWorkshops_ItemCommand">
                <HeaderTemplate>
                    <div class="list-group animate__animated animate__fadeIn">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="list-group-item list-group-item-action shadow-sm rounded mb-2 p-3 d-flex justify-content-between align-items-center bg-white border">
                        <div>
                            <h5 class="mb-1"><%# Eval("Title") %></h5>
                            <p class="mb-1 text-muted">
                                <%# Eval("Date", "{0:yyyy-MM-dd}") %> at <%# Eval("Time") %><br />
                                <%# Eval("IsOnline").ToString() == "True" ? "Online" : "Location: " + Eval("Location") %>
                            </p>
                        </div>
                        <asp:Panel ID="pnlActions" runat="server" CssClass="text-end">
                            <asp:Button runat="server" CssClass="btn btn-outline-secondary btn-sm me-1"
                                CommandName="Edit" CommandArgument='<%# Eval("Id") %>' Text="Edit" CausesValidation="false" />
                            <asp:Button runat="server" CssClass="btn btn-outline-danger btn-sm me-1"
                                CommandName="Cancel" CommandArgument='<%# Eval("Id") %>' Text="Cancel" CausesValidation="false" />
                            <asp:Button runat="server" CssClass="btn btn-outline-success btn-sm"
                                CommandName="Complete" CommandArgument='<%# Eval("Id") %>' Text="Complete" CausesValidation="false" />
                        </asp:Panel>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </div>
                <script>
                    document.getElementById('toggleSidebarBtn').addEventListener('click', () => {
                        document.body.classList.toggle('sidebar-open');
                    });
                </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>

