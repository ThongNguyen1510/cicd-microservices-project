using Microsoft.EntityFrameworkCore;
using ProductApi.Data;
using ProductApi.Services;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Configure Serilog
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .WriteTo.File("logs/productapi-.txt", rollingInterval: RollingInterval.Day)
    .CreateLogger();

builder.Host.UseSerilog();

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() 
    { 
        Title = "Product API", 
        Version = "v1",
        Description = "A microservice API for managing products with SQL Server backend"
    });
});

// Configure Database
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));

// Register services
builder.Services.AddScoped<IProductService, ProductService>();

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Add health checks
builder.Services.AddHealthChecks()
    .AddDbContextCheck<ApplicationDbContext>();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Product API V1");
        c.RoutePrefix = string.Empty; // Swagger at root
    });
}

// Apply migrations and seed data
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var context = services.GetRequiredService<ApplicationDbContext>();
        
        // Wait for SQL Server to be ready
        var retryCount = 0;
        var maxRetries = 10;
        while (retryCount < maxRetries)
        {
            try
            {
                await context.Database.MigrateAsync();
                Log.Information("Database migration completed successfully");
                break;
            }
            catch (Exception ex)
            {
                retryCount++;
                Log.Warning(ex, "Database migration attempt {RetryCount} failed. Retrying...", retryCount);
                await Task.Delay(5000); // Wait 5 seconds before retry
                
                if (retryCount >= maxRetries)
                {
                    Log.Error(ex, "Database migration failed after {MaxRetries} attempts", maxRetries);
                    throw;
                }
            }
        }
    }
    catch (Exception ex)
    {
        Log.Error(ex, "An error occurred while migrating the database");
        throw;
    }
}

app.UseSerilogRequestLogging();

app.UseCors("AllowAll");

app.UseAuthorization();

app.MapControllers();
app.MapHealthChecks("/health");

Log.Information("Product API starting...");

app.Run();

// Make the implicit Program class public for testing
public partial class Program { }
