<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductPayment.aspx.cs" Inherits="ELibrary.ProductPayment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div class="container mt-5">
        <div class="card p-4 shadow">
            <h3 class="text-center text-success">Processing Payment...</h3>
            <asp:Literal ID="litMessage" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
