<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderConfirmation.aspx.cs" Inherits="ELibrary.OrderConfirmation" MasterPageFile="~/Site1.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet" />

    <style>
        .card-section {
            background: #fff;
            border-radius: 16px;
            padding: 35px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.07);
            transition: 0.3s ease;
        }

        .card-section:hover {
            transform: scale(1.01);
        }

        .section-heading {
            font-weight: 700;
            color: #0d6efd;
        }

        .table th, .table td {
            vertical-align: middle;
        }

        .btn-primary {
            font-weight: 600;
        }

        .badge-status {
            font-size: 0.9rem;
            padding: 6px 12px;
            border-radius: 20px;
        }

        .order-icon {
            font-size: 2rem;
            color: #28a745;
        }
    </style>

    <div class="container my-5" style="max-width: 850px;" data-aos="zoom-in-up">
        <div class="card-section">
            <div class="text-center mb-4">
                <div class="order-icon mb-2">✅</div>
                <h2 class="text-success fw-bold">Order Confirmed!</h2>
                <p class="text-muted">Thank you for your purchase! Your order has been successfully placed.</p>
            </div>

            <!-- Order Summary -->
            <div class="mb-4">
                <h5 class="section-heading mb-3">🧾 Order Summary</h5>
                <p><strong>Order ID:</strong> <asp:Label ID="lblOrderID" runat="server" CssClass="text-dark fw-semibold" /></p>
                <p><strong>Date:</strong> <asp:Label ID="lblOrderDate" runat="server" /></p>
                <p><strong>Status:</strong>
                    <asp:Label ID="lblStatus" runat="server" CssClass="badge badge-status bg-info text-dark" />
                </p>
            </div>

            <!-- Shipping Info -->
            <div class="mb-4">
                <h5 class="section-heading mb-3">📦 Shipping Information</h5>
                <p><strong>Address:</strong> <asp:Label ID="lblAddress" runat="server" /></p>
                <p><strong>Phone:</strong> <asp:Label ID="lblPhone" runat="server" /></p>
            </div>

            <!-- Order Items -->
            <div class="mb-4">
                <h5 class="section-heading mb-3">🛍️ Ordered Items</h5>
                <asp:Repeater ID="rptItems" runat="server">
                    <HeaderTemplate>
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped">
                                <thead class="table-light">
                                    <tr>
                                        <th>Product</th>
                                        <th>Quantity</th>
                                        <th>Unit Price</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("ProductName") %></td>
                            <td><%# Eval("Quantity") %></td>
                            <td>PKR <%# Eval("UnitPrice", "{0:N0}") %></td>
                            <td>PKR <%# (Convert.ToInt32(Eval("Quantity")) * Convert.ToDecimal(Eval("UnitPrice"))).ToString("N0") %></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                                </tbody>
                            </table>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>

            <!-- Total -->
            <div class="text-end mb-4">
                <h5 class="fw-bold text-success">Total Paid: PKR <asp:Label ID="lblTotal" runat="server" /></h5>
            </div>

            <!-- CTA -->
            <div class="text-center">
                <a href="Products.aspx" class="btn btn-primary btn-lg px-4">🛍️ Continue Shopping</a>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({ duration: 1000, once: true });
    </script>
</asp:Content>
