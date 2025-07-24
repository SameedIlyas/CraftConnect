<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ELibrary.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
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
                <p>
                    Showcase a wide variety of artisan-crafted products with categories for home decor, jewelry, clothing, and more
                </p>
            </div>

            <div class="col-md-4 text-center">
                <img src="images/online-training.png" alt="Search Books" class="img-fluid mb-3" style="width: 150px;">
                <h4>Skill Workshops</h4>
                <p>
                    Join interactive sessions led by master artisans to learn unique crafting techniques and unleash your creativity.
                </p>
            </div>

            <div class="col-md-4 text-center">
                <img src="images/shopping-bag.png" alt="Defaulter List" class="img-fluid mb-3" style="width: 150px;">
                <h4>Easy & Secure Shopping </h4>
                <p>
                    Intuitive cart, secure payment options, and real-time order tracking for a seamless shopping journey.
                </p>
            </div>
        </div>
    </div>
</section>

<section>
    <img src="Images/home2.jpg" alt="Home Banner" class="img-fluid w-100" style="height: 300px; object-fit: cover;">
</section>

<section class="py-5">
    <div class="container">
        <div class="row">
            <div class="col-12 text-center mb-4">
                <h2>Our Process</h2>
                <p><b>We have a Simple 3 Step Process</b></p>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4 text-center">
                <img src="Images/user.png" alt="Sign Up" class="img-fluid mb-3" style="width: 150px;">
                <h4>Profile Authentication</h4>
                <p>
                    Verify user and artisan identities to ensure a safe and trusted community.
                </p>
            </div>

            <div class="col-md-4 text-center">
                <img src="images/order.png"  class="img-fluid mb-3" style="width: 150px;">
                <h4>Product Quality Check</h4>
                <p>
                   Maintain high standards by reviewing and approving all product listings.
                </p>
            </div>

            <div class="col-md-4 text-center">
                <img src="images/credit-card.png"  class="img-fluid mb-3" style="width: 150px;">
                <h4>Secure Payment Validation</h4>
                <p>
                    Protect transactions with encrypted payment processing for peace of mind.
                </p>
            </div>
        </div>
    </div>
</section>
</asp:Content>