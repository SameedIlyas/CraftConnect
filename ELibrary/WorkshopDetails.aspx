<%@ Page Title="Workshop Details" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="WorkshopDetails.aspx.cs" Inherits="ELibrary.WorkshopDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet" />

    <style>
        .card-custom {
            border-radius: 16px;
            padding: 30px;
            background: #fff;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
        }

        .card-custom:hover {
            transform: scale(1.02);
        }

        .info-label {
            font-weight: 600;
            color: #495057;
        }

        .value-text {
            font-weight: 500;
        }

        .section-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .badge-mode {
            font-size: 13px;
            padding: 5px 10px;
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

        .alert-custom {
            font-size: 15px;
        }
    </style>

    <div class="container mt-5">
        <!-- Details Card -->
        <asp:Panel ID="pnlDetails" runat="server" Visible="false">
            <div class="card card-custom" data-aos="fade-up">
                <h2 class="section-title text-primary"><asp:Label ID="lblTitle" runat="server" /></h2>
                <p class="mb-3 text-muted"><asp:Label ID="lblDescription" runat="server" /></p>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <p><span class="info-label">Category:</span> <span class="value-text"><asp:Label ID="lblCategory" runat="server" /></span></p>
                    </div>
                    <div class="col-md-6">
                        <p><span class="info-label">Date:</span> <span class="value-text"><asp:Label ID="lblDate" runat="server" /></span></p>
                    </div>
                    <div class="col-md-6">
                        <p><span class="info-label">Time:</span> <span class="value-text"><asp:Label ID="lblTime" runat="server" /></span></p>
                    </div>
                    <div class="col-md-6">
                        <p>
                            <span class="info-label">Mode:</span>
                            <span id="spanMode" runat="server" class="badge badge-mode">
                                <asp:Label ID="lblMode" runat="server" />
                            </span>
                        </p>
                    </div>
                    <div class="col-md-6">
                        <p><span class="info-label">Fee:</span> <span class="value-text">Rs. <asp:Label ID="lblFee" runat="server" /></span></p>
                    </div>
                    <div class="col-md-6">
                        <p><span class="info-label">Max Capacity:</span> <span class="value-text"><asp:Label ID="lblMaxOccupancy" runat="server" /></span></p>
                    </div>
                    <div class="col-md-6">
                        <p><span class="info-label">Current Enrolled:</span> <span class="value-text"><asp:Label ID="lblCurrentOccupancy" runat="server" /></span></p>
                    </div>
                </div>

                <!-- Online Link -->
                <asp:Panel ID="pnlOnlineLink" runat="server" CssClass="alert alert-success alert-custom" Visible="false">
                    <i class="bi bi-link-45deg"></i>
                    <strong>Workshop Link:</strong> <asp:HyperLink ID="lnkWorkshop" runat="server" Target="_blank" />
                </asp:Panel>

                <!-- Offline Location -->
                <asp:Panel ID="pnlLocation" runat="server" CssClass="alert alert-info alert-custom" Visible="false">
                    <i class="bi bi-geo-alt-fill"></i>
                    <strong>Location:</strong> <asp:Label ID="lblLocation" runat="server" />
                </asp:Panel>

                <!-- Enroll Button -->
                <asp:Panel ID="pnlEnroll" runat="server" CssClass="mt-3">
                    <asp:Button ID="btnEnroll" runat="server" CssClass="btn btn-primary px-4 py-2" Text="Enroll Now" OnClick="btnEnroll_Click" />
                    <asp:Label ID="lblEnrollStatus" runat="server" CssClass="text-danger ms-3" />
                </asp:Panel>
            </div>
        </asp:Panel>

        <!-- Error Message -->
        <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger mt-4" Visible="false" data-aos="fade-down">
            <asp:Label ID="lblError" runat="server" />
        </asp:Panel>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 900,
            once: true
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server" />
