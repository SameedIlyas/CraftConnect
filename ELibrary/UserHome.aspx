<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserHome.aspx.cs" Inherits="ELibrary.UserHome" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>User Home</title>
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
         #carouselExampleControls {
      margin-top: 20px; 
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
                                <a class="nav-link" href="ShoppingCart.aspx"><i class="fas fa-shopping-cart fa-lg"></i></a>
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


        <hr />
        <asp:Label ID="lblSuccess" runat="server" CssClass="text-success fw-bold d-block text-center"></asp:Label>


        <!-- Slider Section -->
        <div id="carouselExampleControls" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="images/pic1.jpg" class="d-block w-100" alt="Home Banner" style="object-fit: cover; max-height: 70vh;">
                </div>
                <div class="carousel-item">
                    <img src="images/slide2.jpg" class="d-block w-100" alt="Slide 2" style="object-fit: cover; max-height: 70vh;">
                </div>
                <div class="carousel-item">
                    <img src="images/slide3.jpg" class="d-block w-100" alt="Slide 3" style="object-fit: cover; max-height: 70vh;">
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>

        <!-- Feature Section -->
        <section class="py-5">
            <div class="container">
                <div class="row">
                    <div class="col-12 text-center mb-4">
                        <h2>Our Features</h2>
                        <p><b>Our 3 Primary Features</b></p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 text-center">
                        <img src="images/hand-made.png" alt="Inventory Management" class="img-fluid mb-3" style="width: 150px;">
                        <h4>Unique Handmade Products</h4>
                        <p>Showcase a variety of artisan-crafted products with categories for home decor, jewelry, clothing, and more</p>
                    </div>
                    <div class="col-md-4 text-center">
                        <img src="images/online-training.png" alt="Search Books" class="img-fluid mb-3" style="width: 150px;">
                        <h4>Skill Workshops</h4>
                        <p>Join interactive sessions led by master artisans to learn unique crafting techniques.</p>
                    </div>
                    <div class="col-md-4 text-center">
                        <img src="images/shopping-bag.png" alt="Defaulter List" class="img-fluid mb-3" style="width: 150px;">
                        <h4>Easy & Secure Shopping</h4>
                        <p>Intuitive cart, secure payment options, and real-time order tracking for a seamless shopping journey.</p>
                    </div>
                </div>
            </div>
        </section>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

