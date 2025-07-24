<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SellOnline.aspx.cs" Inherits="ELibrary.SellOnline" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="datatables/css/dataTables.dataTables.min.css" rel="stylesheet" />
    <link href="fontawesome/css/all.css" rel="stylesheet" />
    <script src="bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="bootstrap/js/popper.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
    
    <style>
        .search-profile {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-left: auto;
            margin-right: auto;
        }

        .search-bar-container {
            display: flex;
            align-items: center;
            border-radius: 25px;
            background-color: #ffffff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            padding: 5px 10px;
        }

        .search-bar-container .search-icon {
            font-size: 18px;
            color: gray;
            margin-right: 8px;
        }

        .search-bar-container .search-bar {
            border: none;
            outline: none;
            padding: 5px;
            width: 200px;
            font-size: 14px;
        }

        .craft-connect-text {
            font-size: 24px;
            font-weight: bold;
            font-family: 'Poppins', sans-serif;
            color: white;
        }

        .craft-connect-text .highlight {
            color: #ffb74d;
        }

        /* New styles for beautifying the navigation links */
        .nav-custom .nav-link {
            font-weight: 600;
            text-transform: uppercase;
            color: #d63384; /* Bootstrap pink */
            transition: all 0.3s ease-in-out;
            letter-spacing: 0.5px;
            position: relative;
        }

        .nav-custom .nav-link:hover {
            color: #6f42c1; /* Purple on hover */
            text-decoration: none;
        }

        .nav-custom .nav-link::after {
            content: "";
            display: block;
            width: 0;
            height: 2px;
            background: #d63384;
            transition: width 0.3s ease-in-out;
            margin-top: 3px;
        }

        .nav-custom .nav-link:hover::after {
            width: 100%;
        }
    </style>
</head>
<body>
    <form id="form2" runat="server">
        <div>
            <!-- Navigation Bar -->
            <nav class="navbar navbar-expand-lg navbar-dark" style="background-color:palevioletred;">
                <div class="container-fluid">
                    <a class="navbar-brand" href="#">
                        <img src="images/logo.png" class="rounded-circle mb-3" width="45" height="35">
                        <span class="craft-connect-text">Craft<span class="highlight">Connect</span></span>
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <div class="search-profile">
                            <div class="search-bar-container">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" class="search-bar" placeholder="Search" />
                            </div>
                        </div>
                        <ul class="navbar-nav ms-auto">
                            <li class="nav-item">
                                <a class="nav-link" href="ShopingCart.aspx"><i class="fas fa-shopping-cart fa-lg"></i></a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="profileDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user fa-lg"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
                                    <% if (Session["UserId"] != null)
                                    { %>
                                    <li><span class="dropdown-item disabled fw-bold"><%= Session["Username"] %></span></li>
                                    <li><a class="dropdown-item" href="Profile.aspx">My Profile</a></li>
                                    <li><a class="dropdown-item" href="Notifications.aspx">Notifications</a></li>
                                    <li><a class="dropdown-item text-danger" href="Logout.aspx">Log Out</a></li>
                                    <% }
                                    else
                                    { %>
                                    <li><a class="dropdown-item" href="SignIn.aspx">Sign In</a></li>
                                    <li><a class="dropdown-item" href="SignUp.aspx">Sign Up</a></li>
                                    <% } %>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>

            <!-- Navigation Links -->
            <div class="container text-center mt-3">
                <ul class="nav justify-content-center">
                    <li class="nav-item"><a class="nav-link" href="homepage.aspx">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="AboutUs.aspx">About Us</a></li>
                    <li class="nav-item"><a class="nav-link" href="TermsandCondition.aspx">Terms and Conditions</a></li>
                    <li class="nav-item"><a class="nav-link" href=" BrowseWorkshop.aspx">Workshop</a></li>
                    <li class="nav-item"><a class="nav-link" href=" Products.aspx">Products</a></li>
                </ul>
            </div>
        </div>
 <!-- Banner Section -->
<div class="container-fluid px-0 my-3">
    <div class="position-relative text-center">
        <img src="images/img1.jpg" class="img-fluid w-100 rounded" alt="Sell Your Crafts" style="max-height: 400px; object-fit: cover;">

        <!-- Centered Text and Button -->
        <div class="position-absolute top-50 start-50 translate-middle text-white">
            <h2 class="mb-3">Start Your Handmade Craft Store</h2>
            <a href="CreateStore.aspx" class="btn btn-warning btn-lg">Open a New Store</a>
        </div>
    </div>
</div>

<!-- 3 Column Info Section -->
<div class="container my-5">
    <div class="row text-center">
        <!-- Column 1: Open a New Shop -->
        <div class="col-md-4 mb-4">
            <img src="images/store.png" alt="Open Shop" style="width: 80px; height: 80px;" class="mb-3">
            <h4>Open a New Shop</h4>
            <p>Start your own online store and showcase your handmade creations to the world.</p>
        </div>

        <!-- Column 2: Sell Products -->
        <div class="col-md-4 mb-4">
            <img src="images/sell.png" alt="Sell Products" style="width: 80px; height: 80px;" class="mb-3">
            <h4>Sell Products</h4>
            <p>Upload, manage, and sell your handcrafted items easily through our platform.</p>
        </div>

        <!-- Column 3: Get Quick Commission -->
        <div class="col-md-4 mb-4">
            <img src="images/money.png" alt="Commission" style="width: 80px; height: 80px;" class="mb-3">
            <h4>Get Quick Commission</h4>
            <p>Earn money effortlessly with fast and reliable commission payouts.</p>
        </div>
    </div>
</div>

     <!-- Steps to Open CraftConnect Shop -->
<div class="container my-5">
    <h2 class="text-center mb-5">Steps to Open Your <span class="text-warning">CraftConnect Shop</span></h2>
    <div class="row row-cols-1 row-cols-md-3 g-4 text-center">

        <!-- Step 1 -->
        <div class="col">
            <div class="p-3 border rounded h-100 shadow-sm">
                <div class="step-badge bg-warning text-white rounded-circle mx-auto mb-3">
                    <span>01</span>
                </div>
                <i class="bi bi-person-plus-fill fs-1 text-warning mb-2"></i>
                <h5>Register as a Seller</h5>
                <p class="small">Create your account to start selling your crafts online.</p>
            </div>
        </div>

        <!-- Step 2 -->
        <div class="col">
            <div class="p-3 border rounded h-100 shadow-sm">
                <div class="step-badge bg-warning text-white rounded-circle mx-auto mb-3">
                    <span>02</span>
                </div>
                <i class="bi bi-person-lines-fill fs-1 text-warning mb-2"></i>
                <h5>Complete Your Profile</h5>
                <p class="small">Fill in details like your store name, bio, and address.</p>
            </div>
        </div>

        <!-- Step 3 -->
        <div class="col">
            <div class="p-3 border rounded h-100 shadow-sm">
                <div class="step-badge bg-warning text-white rounded-circle mx-auto mb-3">
                    <span>03</span>
                </div>
                <i class="bi bi-shield-check fs-1 text-warning mb-2"></i>
                <h5>Shop Approval</h5>
                <p class="small">Our team will verify your details and approve your shop.</p>
            </div>
        </div>

        <!-- Step 4 -->
        <div class="col">
            <div class="p-3 border rounded h-100 shadow-sm">
                <div class="step-badge bg-warning text-white rounded-circle mx-auto mb-3">
                    <span>04</span>
                </div>
                <i class="bi bi-speedometer2 fs-1 text-warning mb-2"></i>
                <h5>Go to Dashboard</h5>
                <p class="small">Manage your listings, orders, and performance insights.</p>
            </div>
        </div>

        <!-- Step 5 -->
        <div class="col">
            <div class="p-3 border rounded h-100 shadow-sm">
                <div class="step-badge bg-warning text-white rounded-circle mx-auto mb-3">
                    <span>05</span>
                </div>
                <i class="bi bi-box-seam fs-1 text-warning mb-2"></i>
                <h5>Create a Product</h5>
                <p class="small">Add your handmade products with images and pricing.</p>
            </div>
        </div>

        <!-- Step 6 -->
        <div class="col">
            <div class="p-3 border rounded h-100 shadow-sm">
                <div class="step-badge bg-warning text-white rounded-circle mx-auto mb-3">
                    <span>06</span>
                </div>
                <i class="bi bi-check-circle-fill fs-1 text-warning mb-2"></i>
                <h5>Product Approval</h5>
                <p class="small">Our team will review and publish your product online.</p>
            </div>
        </div>
    </div>
</div>

<!-- Step Badge Style -->
<style>
    .step-badge {
        width: 60px;
        height: 60px;
        font-size: 1.2rem;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
    }
</style>



        <footer class="bg-dark text-white pt-4">
            <div class="container">
                <div class="row">
                    <!-- About Section -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <h5>About Our store</h5>
                        <p>Discover the beauty of handmade artistry. Connect with skilled artisans, explore unique crafts, and enjoy a secure, seamless shopping experience</p>
                    </div>
                    <!-- Links Section -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <h5>Quick Links</h5>
                        <ul class="list-unstyled">
                            <li><a href="homepage.aspx" class="text-white text-decoration-none">Home</a></li>
                            <li><a href="#" class="text-white text-decoration-none">Categories</a></li>
                            <li><a href="#" class="text-white text-decoration-none">Best Sellers</a></li>
                            <li><a href="SellOnline.aspx" class="text-white text-decoration-none">Sell Online</a></li>
                            <li><a href="#" class="text-white text-decoration-none">New Arrivals</a></li>
                            <li><a href="#" class="text-white text-decoration-none">Contact</a></li>
                        </ul>
                    </div>
                    <!-- Contact Section -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <h5>Contact Us</h5>
                        <ul class="list-unstyled">
                            <li><i class="bi bi-telephone-fill"></i> +123-456-7890</li>
                            <li><i class="bi bi-envelope-fill"></i> support@craftconnect.com</li>
                            <li><i class="bi bi-geo-alt-fill"></i> 123 CraftConnect, Bringing Artisans and Enthusiasts Together</li>
                        </ul>
                    </div>
                </div>
                <div class="row mt-4">
                    <div class="col text-center">
                        <a href="#" class="text-white me-3"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="text-white me-3"><i class="bi bi-twitter"></i></a>
                        <a href="#" class="text-white me-3"><i class="bi bi-instagram"></i></a>
                        <a href="#" class="text-white"><i class="bi bi-linkedin"></i></a>
                    </div>
                </div>
                <div class="row mt-4">
                    <div class="col text-center">
                        <p class="mb-0">&copy;  Craftonnect. All rights reserved.</p>
                    </div>
                </div>
            </div>
        </footer>

        <!-- Bootstrap 5 Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </form>
</body>
</html>



