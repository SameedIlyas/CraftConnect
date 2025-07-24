<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="SearchResults.aspx.cs" Inherits="ELibrary.SearchResults" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <style>
        .product-card {
            border: none;
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background: #fff;
        }

        .product-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
        }

        .card-img-top {
            height: 220px;
            object-fit: cover;
            transition: all 0.3s ease-in-out;
        }

        .card-body h5 {
            font-weight: 600;
            font-size: 1.1rem;
        }

        .card-body p {
            font-size: 0.9rem;
        }

        .filter-label {
            font-weight: 600;
            font-size: 0.95rem;
        }

        .fade-in {
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            0% {
                opacity: 0;
                transform: translateY(10px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .loader {
            text-align: center;
            padding: 40px;
            font-size: 18px;
            font-weight: 500;
        }
    </style>

    <div class="container mt-4 fade-in">
        <h2 class="mb-4 text-center fw-bold">Search Products</h2>

        <!-- Filters -->
        <div class="row mb-4 g-3">
            <div class="col-md-3">
                <label class="filter-label">Category</label>
                <select id="ddlCategory" class="form-select" onchange="filterProducts()">
                    <option value="">All Categories</option>
                    <option value="Apparel-Men">Apparel - Men</option>
                    <option value="Apparel-Women">Apparel - Women</option>
                    <option value="Apparel-Kids">Apparel - Kids</option>
                    <option value="Footwear-Men">Footwear - Men</option>
                    <option value="Footwear-Women">Footwear - Women</option>
                    <option value="Footwear-Kids">Footwear - Kids</option>
                    <option value="Jewellery">Jewellery</option>
                    <option value="Gift">Gift</option>
                    <option value="Home Decor">Home Decor</option>
                    <option value="Accessories">Accessories</option>
                    <option value="Others">Others</option>
                </select>
            </div>

            <div class="col-md-3">
                <label class="filter-label">Price Range</label>
                <select id="ddlPrice" class="form-select" onchange="filterProducts()">
                    <option value="">All</option>
                    <option value="0-500">Under Rs. 500</option>
                    <option value="500-1000">Rs. 500 - 1000</option>
                    <option value="1000-">Above Rs. 1000</option>
                </select>
            </div>

            <div class="col-md-3">
                <label class="filter-label">Artisan</label>
                <input type="text" id="txtArtisan" class="form-control" onkeyup="filterProducts()" placeholder="e.g. Ali Crafts" />
            </div>
        </div>

        <div id="loadingIndicator" class="loader d-none">Loading products...</div>
        <div id="productResults" class="row g-4"></div>
        <div id="noResults" class="alert alert-warning mt-4 d-none text-center">No products found matching your filters.</div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            filterProducts();
        });

        function filterProducts() {
            const query = new URLSearchParams(window.location.search).get("query") || "";
            const category = document.getElementById("ddlCategory").value;
            const price = document.getElementById("ddlPrice").value;
            const artisan = document.getElementById("txtArtisan").value;

            const resultsDiv = document.getElementById("productResults");
            const noResults = document.getElementById("noResults");
            const loader = document.getElementById("loadingIndicator");

            resultsDiv.innerHTML = "";
            noResults.classList.add("d-none");
            loader.classList.remove("d-none");

            fetch("SearchResults.aspx/GetFilteredProducts", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    query: query,
                    category: category,
                    price: price,
                    artisan: artisan
                })
            })
                .then(response => response.json())
                .then(result => {
                    loader.classList.add("d-none");
                    const data = result.d;

                    if (!Array.isArray(data) || data.length === 0) {
                        noResults.classList.remove("d-none");
                        return;
                    }

                    data.forEach(product => {
                        const description = product.Description.length > 100
                            ? product.Description.substring(0, 100) + "..."
                            : product.Description;

                        const card = `
                            <div class="col-md-4">
                                <div class="card product-card fade-in">
                                    <a href="ProductDetails.aspx?id=${product.ProductId}" class="text-decoration-none text-dark">
                                        <img src="${product.ImagePath}" class="card-img-top" alt="${product.ProductName}" />
                                        <div class="card-body">
                                            <h5 class="card-title">${product.ProductName}</h5>
                                            <p class="card-text text-muted">${description}</p>
                                            <p class="card-text"><strong>Rs. ${product.Price}</strong></p>
                                            <span class="badge bg-info">${product.CategoryName}</span>
                                            <p class="mt-2"><small>By: ${product.SellerName}</small></p>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        `;
                        resultsDiv.innerHTML += card;
                    });
                })
                .catch(err => {
                    loader.classList.add("d-none");
                    console.error("Fetch error:", err);
                });
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server" />
