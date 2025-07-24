ALTER TABLE Artisans
ADD
    StoreName NVARCHAR(255),
    Bio NVARCHAR(MAX),
    Category NVARCHAR(100),
    Phone NVARCHAR(50),
    Address NVARCHAR(255),
    ProfileImagePath NVARCHAR(255); -- optional if you want to store profile image path
