<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WorkshopPaymentSuccess.aspx.cs" Inherits="ELibrary.WorkshopPaymentSuccess" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Workshop Payment Confirmation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="card shadow-lg border-0 rounded-4">
                        <div class="card-body text-center p-5">
                            <h2 class="text-success mb-3">
                                <i class="bi bi-check-circle-fill"></i> Payment Successful!
                            </h2>
                            <asp:Label ID="litMessage" runat="server" CssClass="fs-5 text-secondary d-block mb-4" />
                            <asp:Button ID="btnViewWorkshop" runat="server" Text="View Workshop Details"
                                CssClass="btn btn-primary px-4" OnClick="btnViewWorkshop_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Bootstrap Icons CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.js"></script>
</body>
</html>
