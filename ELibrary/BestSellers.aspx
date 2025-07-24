<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="BestSellers.aspx.cs" Inherits="ELibrary.BestSellers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <style>
        .section-title {
            font-size: 2.2rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 40px;
            color: #d63384;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        .card.product {
            border: none;
            border-radius: 20px;
            transition: all 0.3s ease-in-out;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            height: 100%;
        }

        .card.product:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
        }

        .product img {
            height: 220px;
            width: 100%;
            object-fit: cover;
            border-top-left-radius: 20px;
            border-top-right-radius: 20px;
            transition: transform 0.3s ease;
        }

        .card.product:hover img {
            transform: scale(1.03);
        }

        .badge-best {
            position: absolute;
            top: 10px;
            left: 10px;
            background: #ff6f61;
            font-size: 0.85rem;
            padding: 5px 10px;
        }

        .product h5 {
            font-weight: 600;
            color: #333;
        }

        .product .price {
            font-size: 1.2rem;
            color: #28a745;
            font-weight: bold;
        }

        .artisan-name {
            font-size: 0.9rem;
            color: #888;
        }

        @media (max-width: 768px) {
            .product img {
                height: 180px;
            }
        }
    </style>

    <div class="container py-5">
        <h2 class="section-title">Top 10 Best Sellers</h2>
        <div class="row g-4">
            <% if (BestSeller != null && BestSeller.Rows.Count > 0)
               {
                   foreach (System.Data.DataRow row in BestSeller.Rows)
                   {
                       string productId = row["ProductId"].ToString();
                       string name = row["ProductName"].ToString();
                       string description = row["Description"].ToString();
                       string price = row["Price"].ToString();
                       string image = row["ImagePath"].ToString();
                       string artisan = row["SellerName"].ToString();
                       string orders = row["OrderCount"].ToString();
            %>
                <div class="col-sm-6 col-md-4 col-lg-3">
                    <a href='ProductDetails.aspx?id=<%= productId %>' class='text-decoration-none' data-bs-toggle="tooltip" data-bs-placement="top" title="<%= name %> - Rs. <%= price %>">
                        <div class="card product position-relative h-100">
                            <span class="badge badge-best">🔥 <%= orders %> Orders</span>
                            <img src='<%= image %>' class='card-img-top' alt='<%= name %>' />
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title" data-bs-toggle="tooltip" title="<%= name %>"><%= name.Length > 30 ? name.Substring(0, 30) + "..." : name %></h5>
                                <p class="card-text text-muted"><%= description.Length > 60 ? description.Substring(0, 60) + "..." : description %></p>
                                <p class="price mt-auto">Rs. <%= price %></p>
                                <p class="artisan-name">By: <%= artisan %></p>
                            </div>
                        </div>
                    </a>
                </div>
            <%   }
               }
               else
               {
            %>
               <div class="col-12">
                   <div class="alert alert-warning text-center">No top products found.</div>
               </div>
            <% } %>
        </div>
    </div>

    <script>
        // Bootstrap tooltip activation
        document.addEventListener("DOMContentLoaded", function () {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.forEach(function (tooltipTriggerEl) {
                new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
    </script>
</asp:Content>
