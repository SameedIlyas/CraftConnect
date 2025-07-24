<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProfileCreation.aspx.cs" Inherits="ELibrary.ProfileCreation" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Profile Setup</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body { transition: margin-left 0.3s; }
        body.sidebar-open { margin-left: 250px; }
        #sidebar {
            width: 250px; background-color: cadetblue; position: fixed;
            top: 0; left: -250px; height: 100%; z-index: 1040;
            transition: left 0.3s ease-in-out; overflow-y: auto; padding-top: 60px;
        }
        body.sidebar-open #sidebar { left: 0; }
        .profile-card {
            max-width: 700px; margin: auto;
            background-color: #f8f9fa; border-left: 4px solid #0d6efd; border-radius: 12px;
        }
        .navbar {
            background-color: #ffffff; border-bottom: 1px solid #ddd;
            position: sticky; top: 0; z-index: 1050;
        }
        .sidebar-logo, .profile-img {
            width: 100px; height: 100px; object-fit: cover; border-radius: 50%;
        }
        .nav-link { color: white; text-align: left; padding-left: 20px; }
        .nav-link:hover { background-color: rgba(255, 255, 255, 0.2); }
        .profile-icon { font-size: 1.8rem; color: #0d6efd; }
        .sidebar-content { color: white; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Sidebar -->
        <div id="sidebar">
            <div class="text-center sidebar-content">
                <h5 class="fw-bold">CraftConnect</h5>
                <img src="images/cc.jpg" class="sidebar-logo" alt="Logo" />
                <h6 class="fw-bold mt-3">Dashboard</h6>
                <ul class="nav flex-column mt-2">
                    <li class="nav-item"><a href="ArtisanDashboard.aspx" class="nav-link">Dashboard Overview</a></li>
                    <li class="nav-item"><a href="ManageStore.aspx" class="nav-link">Store Management</a></li>
                    <li class="nav-item"><a href="Workshops.aspx" class="nav-link">Workshop Management</a></li>
                    <li class="nav-item"><a href="CustomerInteractions.aspx" class="nav-link">Customer Interaction</a></li>
                    <li class="nav-item"><a href="EarningsReports.aspx" class="nav-link">Earnings & Reports</a></li>
                    <li class="nav-item"><a href="homepage.aspx" class="nav-link">Back to Website</a></li>
                </ul>
            </div>
        </div>

        <!-- Navbar -->
        <nav class="navbar px-3 py-2 d-flex justify-content-between align-items-center">
            <div>
                <button type="button" class="btn" id="toggleSidebarBtn"><i class="bi bi-list fs-3"></i></button>
                <span class="fs-4 fw-bold ms-2">Artisan Dashboard</span>
            </div>
            <div><i class="bi bi-person-circle profile-icon"></i></div>
        </nav>

        <!-- Profile Card -->
        <div class="container my-5">
            <div class="card shadow profile-card px-3 py-3">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="mb-0">
                            <asp:Label ID="lblName" runat="server" Text=""></asp:Label></h4>
                        <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btn btn-primary" />
                    </div>

                    <asp:Label ID="lblStatusMessage" runat="server" CssClass="text-success"></asp:Label>

                    <asp:ValidationSummary ID="vsErrors" runat="server" CssClass="text-danger" ValidationGroup="StoreValidation" HeaderText="Please correct the following errors:" />

                    <div class="row g-3 mt-2">
                        <div class="col-md-9 ps-3">
                            <div><strong>Address:</strong>
                                <asp:Label ID="lblAddress" runat="server" Text=""></asp:Label></div>
                            <div><strong>Email:</strong>
                                <asp:Label ID="lblEmail" runat="server" Text=""></asp:Label></div>
                            <div>
                                <strong>Profile URL:</strong>
                                <asp:HyperLink ID="lnkProfileUrl" runat="server" NavigateUrl="#">#</asp:HyperLink>
                            </div>

                            <div class="mt-3">
                                <label for="txtStoreName">Store Name</label>
                                <asp:TextBox ID="txtStoreName" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="rfvStoreName" runat="server" ControlToValidate="txtStoreName"
                                    ErrorMessage="Store name is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="StoreValidation" />
                            </div>

                            <div class="mt-3">
                                <label for="txtDescription">Description</label>
                                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" CssClass="form-control" Rows="3" />
                                <asp:RequiredFieldValidator ID="rfvDescription" runat="server" ControlToValidate="txtDescription"
                                    ErrorMessage="Description is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="StoreValidation" />
                            </div>

                            <div class="mt-3">
                                <label for="ddlCategory">Category</label>
                                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Select" Value="" />
                                    <asp:ListItem Text="Apparel" Value="Apparel" />
                                    <asp:ListItem Text="Footwear" Value="Footwear" />
                                    <asp:ListItem Text="Jewellery" Value="Jewellery" />
                                    <asp:ListItem Text="Gift" Value="Gift" />
                                    <asp:ListItem Text="Home Decor" Value="Home Decor" />
                                    <asp:ListItem Text="Accessories" Value="Accessories" />
                                    <asp:ListItem Text="Other" Value="Other" />
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory"
                                    InitialValue="" ErrorMessage="Please select a category." CssClass="text-danger" Display="Dynamic" ValidationGroup="StoreValidation" />
                            </div>

                            <div class="mt-3">
                                <asp:Button ID="btnSubmitRequest" runat="server" Text="Submit for Approval"
                                    CssClass="btn btn-success" OnClick="btnSubmitRequest_Click" ValidationGroup="StoreValidation" />
                            </div>

                            <div class="mt-3">
                                <strong>Approval Status:</strong>
                                <asp:Label ID="lblApprovalStatus" runat="server" CssClass="fw-bold text-primary"></asp:Label>
                            </div>

                            <!-- Add Products Button (Only if approved) -->
                            <asp:Button ID="btnAddProducts" runat="server" CssClass="btn btn-primary mt-4" Text="Add Products" OnClick="btnAddProducts_Click" />
                        </div>

                        <div class="col-md-3 text-center">
                            <asp:Image ID="imgProfile" runat="server" CssClass="profile-img" ImageUrl="~/images/Profilep.png" />
                            <asp:FileUpload ID="fileUpload" runat="server" CssClass="d-none" />
                            <asp:Button ID="btnUpload" runat="server" CssClass="d-none" OnClick="btnUpload_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <script>
            const toggleBtn = document.getElementById('toggleSidebarBtn');
            toggleBtn.addEventListener('click', () => {
                document.body.classList.toggle('sidebar-open');
            });

            const image = document.getElementById('<%= imgProfile.ClientID %>');
            const fileInput = document.getElementById('<%= fileUpload.ClientID %>');
            image.addEventListener('click', () => fileInput.click());
            fileInput.addEventListener('change', () => {
                document.getElementById('<%= btnUpload.ClientID %>').click();
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>
