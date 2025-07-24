<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="ELibrary.Notifications" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Notifications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet" />
    <style>
        .notification-card {
            transition: transform 0.2s ease-in-out;
        }
        .notification-card:hover {
            transform: scale(1.01);
        }
        .bg-unread {
            background-color: #fff9db;
        }
        .bg-read {
            background-color: #ffffff;
        }
    </style>
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <div class="container py-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="mb-0">
                    <i class="bi bi-bell-fill text-warning"></i> Notifications
                </h3>
                <button type="button" class="btn btn-outline-secondary" onclick="history.back();">
                    <i class="bi bi-arrow-left-circle me-1"></i> Back
                </button>
            </div>

            <asp:Button ID="btnMarkAllRead" runat="server" Text="Mark All as Read" CssClass="btn btn-success mb-4" OnClick="btnMarkAllRead_Click" />

            <asp:Repeater ID="rptNotifications" runat="server">
                <ItemTemplate>
                    <div class='card notification-card animate__animated animate__fadeInUp mb-3 
                                <%# Convert.ToBoolean(Eval("IsRead")) ? "bg-read" : "bg-unread" %>'>
                        <div class="card-body">
                            <p class="card-text mb-2"><i class="bi bi-info-circle-fill text-primary me-1"></i><%# Eval("Message") %></p>
                            <div class="text-end">
                                <small class="text-muted"><i class="bi bi-clock me-1"></i><%# Convert.ToDateTime(Eval("CreatedAt")).ToString("f") %></small>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoNotifications" runat="server" Visible="false">
                <div class="alert alert-info text-center mt-4 animate__animated animate__fadeIn">
                    <i class="bi bi-inbox"></i> No notifications to show.
                </div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>

