using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using ProductApi.Data;
using ProductApi.Models;
using ProductApi.Services;
using Xunit;

namespace ProductApi.Tests.Services;

public class ProductServiceTests
{
    private ApplicationDbContext GetInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        var context = new ApplicationDbContext(options);
        context.Database.EnsureCreated();
        return context;
    }

    [Fact]
    public async Task GetAllProductsAsync_ReturnsAllActiveProducts()
    {
        // Arrange
        var context = GetInMemoryDbContext();
        var logger = new Mock<ILogger<ProductService>>();
        var service = new ProductService(context, logger.Object);

        // Act
        var products = await service.GetAllProductsAsync();

        // Assert
        Assert.NotNull(products);
        Assert.Equal(3, products.Count()); // Seeded data
    }

    [Fact]
    public async Task GetProductByIdAsync_ExistingId_ReturnsProduct()
    {
        // Arrange
        var context = GetInMemoryDbContext();
        var logger = new Mock<ILogger<ProductService>>();
        var service = new ProductService(context, logger.Object);

        // Act
        var product = await service.GetProductByIdAsync(1);

        // Assert
        Assert.NotNull(product);
        Assert.Equal("Laptop", product.Name);
    }

    [Fact]
    public async Task GetProductByIdAsync_NonExistingId_ReturnsNull()
    {
        // Arrange
        var context = GetInMemoryDbContext();
        var logger = new Mock<ILogger<ProductService>>();
        var service = new ProductService(context, logger.Object);

        // Act
        var product = await service.GetProductByIdAsync(999);

        // Assert
        Assert.Null(product);
    }

    [Fact]
    public async Task CreateProductAsync_ValidProduct_ReturnsCreatedProduct()
    {
        // Arrange
        var context = GetInMemoryDbContext();
        var logger = new Mock<ILogger<ProductService>>();
        var service = new ProductService(context, logger.Object);

        var newProduct = new Product
        {
            Name = "Test Product",
            Description = "Test Description",
            Price = 99.99m,
            StockQuantity = 10,
            Category = "Test"
        };

        // Act
        var createdProduct = await service.CreateProductAsync(newProduct);

        // Assert
        Assert.NotNull(createdProduct);
        Assert.True(createdProduct.Id > 0);
        Assert.Equal("Test Product", createdProduct.Name);
        Assert.True(createdProduct.IsActive);
    }

    [Fact]
    public async Task UpdateProductAsync_ExistingProduct_ReturnsUpdatedProduct()
    {
        // Arrange
        var context = GetInMemoryDbContext();
        var logger = new Mock<ILogger<ProductService>>();
        var service = new ProductService(context, logger.Object);

        var updateData = new Product
        {
            Name = "Updated Laptop",
            Description = "Updated Description",
            Price = 1499.99m,
            StockQuantity = 25,
            Category = "Electronics"
        };

        // Act
        var updatedProduct = await service.UpdateProductAsync(1, updateData);

        // Assert
        Assert.NotNull(updatedProduct);
        Assert.Equal("Updated Laptop", updatedProduct.Name);
        Assert.Equal(1499.99m, updatedProduct.Price);
        Assert.NotNull(updatedProduct.UpdatedAt);
    }

    [Fact]
    public async Task UpdateProductAsync_NonExistingProduct_ReturnsNull()
    {
        // Arrange
        var context = GetInMemoryDbContext();
        var logger = new Mock<ILogger<ProductService>>();
        var service = new ProductService(context, logger.Object);

        var updateData = new Product
        {
            Name = "Updated Product",
            Price = 99.99m
        };

        // Act
        var result = await service.UpdateProductAsync(999, updateData);

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task DeleteProductAsync_ExistingProduct_ReturnsTrue()
    {
        // Arrange
        var context = GetInMemoryDbContext();
        var logger = new Mock<ILogger<ProductService>>();
        var service = new ProductService(context, logger.Object);

        // Act
        var result = await service.DeleteProductAsync(1);

        // Assert
        Assert.True(result);
        
        // Verify soft delete
        var product = await context.Products.FindAsync(1);
        Assert.NotNull(product);
        Assert.False(product.IsActive);
    }

    [Fact]
    public async Task DeleteProductAsync_NonExistingProduct_ReturnsFalse()
    {
        // Arrange
        var context = GetInMemoryDbContext();
        var logger = new Mock<ILogger<ProductService>>();
        var service = new ProductService(context, logger.Object);

        // Act
        var result = await service.DeleteProductAsync(999);

        // Assert
        Assert.False(result);
    }

    [Fact]
    public async Task GetProductsByCategoryAsync_ExistingCategory_ReturnsProducts()
    {
        // Arrange
        var context = GetInMemoryDbContext();
        var logger = new Mock<ILogger<ProductService>>();
        var service = new ProductService(context, logger.Object);

        // Act
        var products = await service.GetProductsByCategoryAsync("Electronics");

        // Assert
        Assert.NotNull(products);
        Assert.Equal(3, products.Count());
        Assert.All(products, p => Assert.Equal("Electronics", p.Category));
    }

    [Fact]
    public async Task GetProductsByCategoryAsync_NonExistingCategory_ReturnsEmptyList()
    {
        // Arrange
        var context = GetInMemoryDbContext();
        var logger = new Mock<ILogger<ProductService>>();
        var service = new ProductService(context, logger.Object);

        // Act
        var products = await service.GetProductsByCategoryAsync("NonExistent");

        // Assert
        Assert.NotNull(products);
        Assert.Empty(products);
    }
}
