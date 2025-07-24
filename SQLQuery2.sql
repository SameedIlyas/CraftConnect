CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ArtisanName NVARCHAR(100) NOT NULL,
    ProductName NVARCHAR(200) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    CategoryID INT NOT NULL,
    Description NVARCHAR(MAX),
    ImagePath NVARCHAR(255),
    DateAdded DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
