<%@ Page Title="Product Details" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="ELibrary.ProductDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet" />
    <style>
        .review-badge {
            background-color: #ffc107;
            color: #212529;
            border-radius: 12px;
            padding: 4px 10px;
            font-size: 14px;
        }

        .product-card {
            border-radius: 16px;
            background: #ffffff;
            padding: 30px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.05);
        }

        .feedback-box {
            background-color: #f8f9fa;
            border-left: 4px solid #0d6efd;
            padding: 15px;
            border-radius: 10px;
        }

        .form-label {
            font-weight: 600;
        }

        .error-label {
            color: #dc3545;
            font-weight: 500;
            display: none;
        }
    </style>

    <div class="container my-5" data-aos="fade-up">
        <!-- Product Info Card -->
        <asp:Panel ID="pnlDetails" runat="server" CssClass="product-card">
            <div class="row g-4">
                <!-- Image Section -->
                <div class="col-lg-5 text-center">
                    <asp:Image ID="imgProduct" runat="server" CssClass="img-fluid rounded-3 shadow-sm" Style="max-height: 400px;" />
                </div>

                <!-- Details Section -->
                <div class="col-lg-7">
                    <h2 class="fw-bold mb-3 text-primary"><asp:Label ID="lblName" runat="server" /></h2>
                    <div class="mb-2"><strong>Category:</strong> <asp:Label ID="lblCategory" runat="server" CssClass="text-muted" /></div>
                    <div class="mb-2"><strong>Seller:</strong> <asp:Label ID="lblSeller" runat="server" CssClass="text-muted" /></div>
                    <div class="mb-2"><strong>Price:</strong> <span class="text-success fw-bold">PKR <asp:Label ID="lblPrice" runat="server" /></span></div>
                    <div class="mb-2"><strong>Description:</strong> <asp:Label ID="lblDescription" runat="server" CssClass="text-secondary" /></div>
                    <div class="mb-3"><strong>Available Stock:</strong> <asp:Label ID="lblQuantity" runat="server" CssClass="fw-bold" /></div>

                    <div class="mb-3 d-flex align-items-center">
                        <label class="me-2 fw-semibold" for="txtQty">Quantity:</label>
                        <asp:TextBox ID="txtQty" runat="server" CssClass="form-control w-auto" Text="1" TextMode="Number" />
                    </div>

                    <div class="d-flex align-items-center">
                        <asp:Button ID="btnAddToCart" runat="server" Text="🛒 Add to Cart" CssClass="btn btn-lg btn-primary px-4" OnClick="btnAddToCart_Click" />
                        <asp:Label ID="lblStatus" runat="server" CssClass="ms-3 fw-semibold text-success" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- Feedback Section -->
        <div class="card shadow-sm mt-5 border-0 rounded-4 p-4" data-aos="fade-up">
            <h4 class="mb-4 text-primary">Customer Reviews</h4>

            <!-- Existing Feedbacks -->
            <asp:Repeater ID="rptFeedback" runat="server">
                <ItemTemplate>
                    <div class="mb-4 p-3 feedback-box">
                        <div class="d-flex justify-content-between">
                            <strong><%# Eval("UName") %></strong>
                            <span class="review-badge">★ <%# Eval("Rating") %>/5</span>
                        </div>
                        <div class="text-muted small mb-2"><%# Convert.ToDateTime(Eval("SubmittedAt")).ToString("dd MMM yyyy, hh:mm tt") %></div>
                        <p class="mb-1"><%# Eval("Comment") %></p>
                        <asp:PlaceHolder ID="phResponse" runat="server" Visible='<%# !string.IsNullOrEmpty(Eval("Response").ToString()) %>'>
                            <div class="mt-2 ps-3 text-secondary small border-start">
                                <i class="fas fa-reply"></i> <strong>Artisan:</strong> <%# Eval("Response") %>
                            </div>
                        </asp:PlaceHolder>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Add New Feedback -->
            <asp:Panel ID="pnlAddFeedback" runat="server" Visible="false">
                <hr class="my-4" />
                <h5 class="mb-3">Leave Your Review</h5>

                <div class="mb-3">
                    <label class="form-label">Rating (1-5)</label>
                    <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-select w-auto">
                        <asp:ListItem Text="1" Value="1" />
                        <asp:ListItem Text="2" Value="2" />
                        <asp:ListItem Text="3" Value="3" />
                        <asp:ListItem Text="4" Value="4" />
                        <asp:ListItem Text="5" Value="5" />
                    </asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label class="form-label">Your Comment</label>
                    <asp:TextBox ID="txtComment" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" />
                    <span id="commentError" class="error-label">Please write a comment before submitting.</span>
                </div>

                <asp:Button ID="btnSubmitFeedback" runat="server" Text="Submit Feedback" CssClass="btn btn-success" OnClientClick="return validateComment();" OnClick="btnSubmitFeedback_Click" />
                <asp:Label ID="lblFeedbackStatus" runat="server" CssClass="ms-3 text-success fw-semibold" />
            </asp:Panel>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 1000,
            once: true
        });

        function validateComment() {
            const commentBox = document.getElementById('<%= txtComment.ClientID %>');
            const errorLabel = document.getElementById('commentError');
            if (commentBox.value.trim() === "") {
                errorLabel.style.display = "block";
                commentBox.classList.add("is-invalid");
                return false;
            } else {
                errorLabel.style.display = "none";
                commentBox.classList.remove("is-invalid");
                return true;
            }
        }
    </script>
</asp:Content>
