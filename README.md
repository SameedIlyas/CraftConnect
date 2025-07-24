# CraftConnect - Artisan E-Commerce Platform

## Overview
CraftConnect is a comprehensive e-commerce platform built with ASP.NET Web Forms (.NET Framework 4.7.2) that connects artisans with customers. The platform facilitates product sales, workshop management, and direct customer interactions.

## Features

### Customer Features
- **User Authentication**
  - Sign up/Sign in functionality
  - Password recovery system
  - Profile creation and management
  
- **Shopping Experience**
  - Product browsing and search
  - Shopping cart management
  - Secure checkout with Stripe integration
  - Order confirmation and tracking
  - Best sellers showcase
  
- **Workshop Interaction**
  - Browse available workshops
  - Workshop registration
  - Interactive workshop management
  
- **Communication**
  - Real-time notifications
  - Customer interaction portal
  - Integrated messaging system

### Admin Features
- **User Management**
  - Manage user accounts
  - Edit user details
  - User activity monitoring
  
- **Product Management**
  - Add/Edit/Delete products
  - Product details management
  - Inventory tracking
  
- **Workshop Administration**
  - Workshop creation and scheduling
  - Participant management
  
- **Business Intelligence**
  - Earnings reports
  - Sales analytics
  - Best sellers tracking
  
- **Communication Tools**
  - Send notifications
  - Customer interaction management
  - Bulk messaging capabilities

## Technical Requirements

### Prerequisites
- Visual Studio 2022
- .NET Framework 4.7.2
- SQL Server (LocalDB)
- IIS Express (included with Visual Studio)

### Database
- SQL Server LocalDB
- Database Name: CraftConnect_Database
- Uses Integrated Security

### External Services Integration
- Stripe Payment Gateway
- MailerSend Email Service

## Installation & Setup

1. **Clone the Repository**

2. **Database Setup**
   - Open SQL Server Management Studio
   - Connect to `(localdb)\MSSQLLocalDB`
   - Create database named `CraftConnect_Database`
   - Run the provided database scripts (if any)

3. **Configuration**
   - Update Web.config with your credentials:
     - Stripe keys
     - MailerSend API keys
     - Database connection string (if different)

4. **Build & Run**
   - Open solution in Visual Studio 2022
   - Restore NuGet packages
   - Build the solution
   - Press F5 to run


## Security Notes
- Ensure to update all API keys and passwords
- Remove test credentials before deployment
- Configure proper SSL certificates
- Implement regular security audits

## Deployment
1. Update connection strings
2. Set debug="false" in Web.config
3. Configure IIS settings
4. Deploy using Visual Studio's publishing tools
