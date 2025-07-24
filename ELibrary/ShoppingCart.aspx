<%@ Page Title="Shopping Cart" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ShoppingCart.aspx.cs" Inherits="ELibrary.ShoppingCart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet" />

    <style>
        .cart-title {
            font-weight: 700;
            font-size: 2rem;
            color: #0d6efd;
        }

        .table thead th {
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 14px;
        }

        .btn-update {
            background-color: #0d6efd;
            color: white;
        }

        .btn-update:hover {
            background-color: #0b5ed7;
        }

        .btn-remove {
            background-color: #dc3545;
            color: white;
        }

        .btn-remove:hover {
            background-color: #bb2d3b;
        }

        .fade-in {
            animation: fadeIn 0.8s ease-in-out both;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>

    <div class="container py-5" data-aos="fade-up">
        <h2 class="text-center mb-5 cart-title">🛒 Your Shopping Cart</h2>

        <!-- AJAX UpdatePanel -->
        <asp:UpdatePanel ID="updCart" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <!-- Cart Items Panel -->
                <asp:Panel ID="pnlCart" runat="server" CssClass="shadow-lg rounded-4 p-4 bg-white fade-in">
                    <asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
                        <HeaderTemplate>
                            <div class="table-responsive">
                                <table class="table align-middle table-hover table-bordered bg-light rounded-3">
                                    <thead class="table-primary">
                                        <tr>
                                            <th scope="col">Image</th>
                                            <th scope="col">Product</th>
                                            <th scope="col">Price (PKR)</th>
                                            <th scope="col">Quantity</th>
                                            <th scope="col">Subtotal</th>
                                            <th scope="col">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <img src='<%# Eval("ImagePath") %>' class="img-thumbnail rounded shadow-sm" style="width: 90px; height: 90px; object-fit: cover;" />
                                </td>
                                <td>
                                    <strong><%# Eval("ProductName") %></strong>
                                </td>
                                <td>Rs. <%# Eval("Price", "{0:N0}") %></td>
                                <td>
                                    <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control text-center" Text='<%# Eval("Quantity") %>' Width="70px" TextMode="Number" />
                                </td>
                                <td><strong>Rs. <%# Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Quantity")) %></strong></td>
                                <td>
                                    <asp:Button ID="btnUpdate" runat="server" CommandName="Update" CommandArgument='<%# Eval("ProductID") %>' Text="Update" CssClass="btn btn-sm btn-update mb-1 w-100" />
                                    <asp:Button ID="btnRemove" runat="server" CommandName="Remove" CommandArgument='<%# Eval("ProductID") %>' Text="Remove" CssClass="btn btn-sm btn-remove w-100" />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                    </tbody>
                                </table>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>

                    <!-- Total and Checkout -->
                    <asp:Panel ID="pnlTotal" runat="server" CssClass="text-end mt-4">
                        <h4 class="fw-bold">Total: PKR <asp:Label ID="lblTotal" runat="server" CssClass="text-success" /></h4>
                        <asp:Button ID="btnCheckout" runat="server" Text="Proceed to Checkout" CssClass="btn btn-success btn-lg mt-3 px-5" OnClick="btnCheckout_Click" />
                    </asp:Panel>
                </asp:Panel>

                <!-- Empty Cart Panel -->
                <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="text-center mt-5 fade-in">
                    <h4 class="text-muted mb-3">Your cart is currently empty 🛍️</h4>
                    <a href="Products.aspx" class="btn btn-outline-primary btn-lg">Continue Shopping</a>
                </asp:Panel>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="rptCart" EventName="ItemCommand" />
                <asp:AsyncPostBackTrigger ControlID="btnCheckout" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 1000,
            once: true
        });
    </script>
</asp:Content>
