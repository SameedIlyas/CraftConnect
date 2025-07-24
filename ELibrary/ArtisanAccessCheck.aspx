<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ArtisanAccessCheck.aspx.cs" Inherits="ELibrary.ArtisanAccessCheck" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Access Check - CraftConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <div class="container py-5">
            <asp:PlaceHolder ID="phStatus" runat="server" />
        </div>
    </form>
</body>
</html>
