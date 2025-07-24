<%@ Page Title="Browse Workshops" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="BrowseWorkshop.aspx.cs" Inherits="ELibrary.BrowseWorkshop" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet" />
    <style>
        .filter-box {
            background: #fdfdfd;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .workshop-card {
            border-radius: 12px;
            background: #ffffff;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }

        .workshop-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .filter-label {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .btn-details {
            background-color: #0d6efd;
            color: white;
            font-weight: 600;
            padding: 6px 16px;
            border-radius: 6px;
            text-decoration: none;
        }

        .btn-details:hover {
            background-color: #0b5ed7;
        }

        .badge-mode {
            font-size: 13px;
            padding: 6px 10px;
            border-radius: 20px;
        }

        .badge-online {
            background-color: #198754;
            color: white;
        }

        .badge-offline {
            background-color: #dc3545;
            color: white;
        }

        .location-text {
            color: #6c757d;
            font-size: 14px;
        }
    </style>

    <div class="container mt-5">
        <h2 class="text-center fw-bold mb-4" data-aos="fade-down">Browse Upcoming Workshops</h2>

        <!-- Filter Section -->
        <div class="filter-box" data-aos="fade-up">
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="filter-label">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" AutoPostBack="true" CssClass="form-control" OnSelectedIndexChanged="FilterChanged">
                        <asp:ListItem Text="All Categories" Value="" />
                        <asp:ListItem Text="Art" Value="Art" />
                        <asp:ListItem Text="Crafts" Value="Crafts" />
                        <asp:ListItem Text="Sewing" Value="Sewing" />
                        <asp:ListItem Text="Pottery" Value="Pottery" />
                        <asp:ListItem Text="Woodwork" Value="Woodwork" />
                    </asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <label class="filter-label">Location</label>
                    <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control" Placeholder="City or area" AutoPostBack="true" OnTextChanged="FilterChanged" />
                </div>

                <div class="col-md-3">
                    <label class="filter-label">Mode</label>
                    <asp:DropDownList ID="ddlMode" runat="server" AutoPostBack="true" CssClass="form-control" OnSelectedIndexChanged="FilterChanged">
                        <asp:ListItem Text="All Modes" Value="" />
                        <asp:ListItem Text="Online" Value="Online" />
                        <asp:ListItem Text="Offline" Value="Offline" />
                    </asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <label class="filter-label">Date</label>
                    <asp:DropDownList ID="ddlDate" runat="server" AutoPostBack="true" CssClass="form-control" OnSelectedIndexChanged="FilterChanged" />
                </div>
            </div>
        </div>

        <!-- Workshop Cards -->
        <div class="row">
            <asp:Repeater ID="rptWorkshops" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 mb-4" data-aos="fade-up">
                        <a href='<%# Eval("Id", "WorkshopDetails.aspx?id={0}") %>' style="text-decoration: none; color: inherit;">
                            <div class="workshop-card">
                                <h5 class="fw-bold mb-1"><%# Eval("Title") %></h5>
                                <p class="mb-2"><%# Eval("Description") %></p>

                                <div class="mb-2">
                                    <span class='badge badge-mode <%# Eval("Mode").ToString() == "Online" ? "badge-online" : "badge-offline" %>'>
                                        <%# Eval("Mode") %>
                                    </span>
                                    <%# Eval("IsOnline").ToString() == "False" ? $"<span class='location-text ms-2'>📍 {Eval("Location")}</span>" : "" %>
                                </div>

                                <p class="text-muted mb-2">
                                    <strong>Date:</strong> <%# Eval("Date", "{0:MMM dd, yyyy}") %>
                                </p>

                                <span class="btn-details">View Details</span>
                            </div>
                        </a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 1000,
            once: true
        });
    </script>
</asp:Content>
