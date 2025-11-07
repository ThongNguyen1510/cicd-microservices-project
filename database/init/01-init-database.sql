-- Initialize Product Database
USE master;
GO

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ProductDb')
BEGIN
    CREATE DATABASE ProductDb;
END
GO

USE ProductDb;
GO

-- Create Products table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
BEGIN
    CREATE TABLE Products (
        Id INT PRIMARY KEY IDENTITY(1,1),
        Name NVARCHAR(100) NOT NULL,
        Description NVARCHAR(500) NULL,
        Price DECIMAL(18,2) NOT NULL,
        StockQuantity INT NOT NULL DEFAULT 0,
        Category NVARCHAR(50) NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        UpdatedAt DATETIME2 NULL,
        IsActive BIT NOT NULL DEFAULT 1
    );

    -- Create indexes
    CREATE INDEX IX_Products_Category ON Products(Category);
    CREATE INDEX IX_Products_IsActive ON Products(IsActive);
    CREATE INDEX IX_Products_CreatedAt ON Products(CreatedAt);
END
GO

-- Insert seed data
IF NOT EXISTS (SELECT * FROM Products)
BEGIN
    INSERT INTO Products (Name, Description, Price, StockQuantity, Category, CreatedAt, IsActive)
    VALUES 
        ('Laptop', 'High-performance laptop for developers', 1299.99, 50, 'Electronics', GETUTCDATE(), 1),
        ('Wireless Mouse', 'Ergonomic wireless mouse', 29.99, 200, 'Electronics', GETUTCDATE(), 1),
        ('Mechanical Keyboard', 'RGB mechanical keyboard with blue switches', 89.99, 100, 'Electronics', GETUTCDATE(), 1),
        ('USB-C Hub', '7-in-1 USB-C hub with HDMI and Ethernet', 49.99, 150, 'Electronics', GETUTCDATE(), 1),
        ('Webcam', '1080p HD webcam with auto-focus', 79.99, 75, 'Electronics', GETUTCDATE(), 1);
END
GO

PRINT 'Database initialization completed successfully!';
GO
