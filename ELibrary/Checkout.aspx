<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="ELibrary.Checkout" MasterPageFile="~/Site1.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet" />

    <style>
        .checkout-section {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            padding: 30px;
        }

        .payment-method-card {
            cursor: pointer;
            border: 2px solid transparent;
            transition: 0.3s ease;
        }

        .payment-method-card.active {
            border-color: #0d6efd;
            background-color: #e7f1ff;
        }

        .form-label {
            font-weight: 600;
        }
    </style>

    <div class="container my-5" data-aos="fade-up">
        <h2 class="text-center text-primary fw-bold mb-4">🧾 Checkout</h2>

        <asp:Panel ID="pnlCheckout" runat="server" CssClass="checkout-section">
            <!-- Cart Summary -->
            <h4 class="mb-3">🛒 Order Summary</h4>
            <asp:Repeater ID="rptCart" runat="server">
                <HeaderTemplate>
                    <div class="table-responsive mb-4">
                        <table class="table table-bordered table-hover">
                            <thead class="table-primary">
                                <tr>
                                    <th>Product</th>
                                    <th>Quantity</th>
                                    <th>Price (PKR)</th>
                                    <th>Total (PKR)</th>
                                </tr>
                            </thead>
                            <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("ProductName") %></td>
                        <td><%# Eval("Quantity") %></td>
                        <td><%# Eval("Price", "{0:N0}") %></td>
                        <td><%# Convert.ToDecimal(Eval("Quantity")) * Convert.ToDecimal(Eval("Price")) %></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                            </tbody>
                        </table>
                    </div>
                </FooterTemplate>
            </asp:Repeater>

            <h5 class="text-end fw-bold text-success">Total: PKR <asp:Label ID="lblTotalAmount" runat="server" /></h5>

            <!-- Shipping Information -->
            <hr />
            <h4 class="mt-4 mb-3">🚚 Shipping Information</h4>
            <div class="mb-3">
                <label class="form-label">Address</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Complete shipping address" TextMode="MultiLine" Rows="3" />
                <asp:RequiredFieldValidator ID="rfvAddress" runat="server"
                    ControlToValidate="txtAddress"
                    CssClass="text-danger"
                    ErrorMessage="Address is required"
                    Display="Dynamic" />
            </div>
            <div class="mb-4">
                <label class="form-label">Phone Number</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="03XX-XXXXXXX" />
                <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                    ControlToValidate="txtPhone"
                    CssClass="text-danger"
                    ErrorMessage="Phone number is required"
                    Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revPhone" runat="server"
                    ControlToValidate="txtPhone"
                    ValidationExpression="^03[0-9]{2}-[0-9]{7}$"
                    ErrorMessage="Enter phone as 03XX-XXXXXXX"
                    CssClass="text-danger"
                    Display="Dynamic" />
            </div>


            <!-- Payment Method -->
            <h4 class="mb-3">💳 Select Payment Method</h4>
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="card payment-method-card p-3" id="codCard" onclick="selectPayment('cod')">
                        <h6 class="fw-bold mb-1">Cash on Delivery</h6>
                        <small>Pay in cash when your order is delivered.</small>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card payment-method-card p-3" id="onlineCard" onclick="selectPayment('online')">
                        <h6 class="fw-bold mb-1">Online Payment</h6>
                        <small>Pay securely using your debit/credit card or wallet.</small>
                    </div>
                </div>
            </div>

            <!-- Hidden field for storing payment choice -->
            <asp:HiddenField ID="hfPaymentMethod" runat="server" Value="cod" />

            <!-- Checkout Button -->
            <div class="text-end mt-4">
                <asp:Button ID="btnCheckout" runat="server" Text="Proceed to Payment" CssClass="btn btn-lg btn-success px-5" OnClick="btnCheckout_Click" />
            </div>
        </asp:Panel>
    </div>

    <!-- AOS + Script for Payment Selection -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({ duration: 1000, once: true });

        function selectPayment(method) {
            document.getElementById('codCard').classList.remove('active');
            document.getElementById('onlineCard').classList.remove('active');

            if (method === 'cod') {
                document.getElementById('codCard').classList.add('active');
                document.getElementById('<%= hfPaymentMethod.ClientID %>').value = 'cod';
            } else {
                document.getElementById('onlineCard').classList.add('active');
                document.getElementById('<%= hfPaymentMethod.ClientID %>').value = 'online';
            }
        }

        // Set default selection on load
        window.onload = () => selectPayment('cod');
    </script>
</asp:Content>
