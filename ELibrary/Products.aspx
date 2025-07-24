<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="ELibrary.Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <style>
        .product-card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background-color: #fff;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        }

        .product-image {
            height: 220px;
            object-fit: cover;
            width: 100%;
        }

        .card-body h5 {
            font-weight: 600;
        }

        .card-text {
            font-size: 14px;
            color: #555;
        }

        .out-of-stock {
            color: #e63946;
            font-weight: bold;
        }

        .filter-box {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }

        .filter-title {
            font-weight: 600;
            margin-bottom: 10px;
        }

        .filter-box select,
        .filter-box input {
            margin-bottom: 10px;
        }
    </style>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <div class="container mt-5">
        <h2 class="mb-4 text-center fw-bold">Explore Unique Artisanal Products</h2>

        <!-- Filters -->
        <div class="row mb-5">
            <div class="col-md-3 filter-box">
                <div class="filter-title">Filter By</div>

                <label for="ddlSort">Sort by</label>
                <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-select mb-2" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                    <asp:ListItem Text="Default" Value="" />
                    <asp:ListItem Text="Price: Low to High" Value="asc" />
                    <asp:ListItem Text="Price: High to Low" Value="desc" />
                </asp:DropDownList>

                <label for="ddlCategory">Category</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select mb-2" AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged" />

                <label for="ddlSeller">Seller</label>
                <asp:DropDownList ID="ddlSeller" runat="server" CssClass="form-select mb-2" AutoPostBack="true" OnSelectedIndexChanged="ddlSeller_SelectedIndexChanged" />

                <label for="ddlPrice">Price</label>
                <asp:DropDownList ID="ddlPrice" runat="server" CssClass="form-select mb-2" AutoPostBack="true" OnSelectedIndexChanged="ddlPrice_SelectedIndexChanged">
                    <asp:ListItem Text="All" Value="" />
                    <asp:ListItem Text="Below PKR 1000" Value="1000" />
                    <asp:ListItem Text="PKR 1000 - 3000" Value="1000-3000" />
                    <asp:ListItem Text="Above PKR 3000" Value="3000" />
                </asp:DropDownList>
            </div>

            <div class="col-md-9">
                <div class="row">
                    <asp:Repeater ID="rptProducts" runat="server">
                        <ItemTemplate>
                            <div class="col-md-6 col-lg-4 mb-4 d-flex align-items-stretch">
                                <div class="card product-card w-100">
                                    <a href='<%# "ProductDetails.aspx?id=" + Eval("ProductID") %>' style="text-decoration: none; color: inherit;">
                                        <img src='<%# Eval("ImagePath") %>' alt="Product" class="product-image" />
                                        <div class="card-body">
                                            <h5 class="card-title"><%# Eval("ProductName") %></h5>
                                            <p class="card-text mb-1"><strong>Price:</strong> PKR <%# Eval("Price") %></p>
                                            <p class="card-text mb-1"><strong>Seller:</strong> <%# Eval("SellerName") %></p>
                                            <p class="card-text mb-1"><strong>Category:</strong> <%# Eval("CategoryName") %></p>
                                            <p class='<%# Convert.ToInt32(Eval("Quantity")) == 0 ? "out-of-stock" : "" %>'>
                                                <%# Convert.ToInt32(Eval("Quantity")) == 0 ? "Out of Stock" : "In Stock: " + Eval("Quantity") %>
                                            </p>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </ItemTemplate>
                        <HeaderTemplate><div class="row"></HeaderTemplate>
                        <FooterTemplate></div></FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


