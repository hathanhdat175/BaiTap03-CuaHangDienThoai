using System.Text.Json.Serialization;
using Microsoft.EntityFrameworkCore;
using PhoneStoreAPI.Entities;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers()
    .AddJsonOptions(o => o.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// DbContext - chuỗi kết nối "PhoneStore" trong appsettings.json
// UseCompatibilityLevel(100): sinh câu SQL chạy được cả trên SQL Server 2008 R2
builder.Services.AddDbContext<PhoneStoreContext>(option =>
    option.UseSqlServer(
        builder.Configuration.GetConnectionString("PhoneStore"),
        sql => sql.UseCompatibilityLevel(100)));

// Cho phép Flutter truy cập API
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");
app.UseStaticFiles();      // phục vụ ảnh điện thoại: http://localhost:5140/images/dt01.png
app.UseAuthorization();
app.MapControllers();

app.Run();
