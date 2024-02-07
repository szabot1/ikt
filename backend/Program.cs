using backend.Auth;
using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using Stripe;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(
        policy =>
        {
            policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
        });
});

var dbBuilder = new NpgsqlDataSourceBuilder(builder.Configuration.GetConnectionString("DefaultConnection"));
dbBuilder.MapEnum<UserRole>();
var db = dbBuilder.Build();

builder.Services.AddDbContext<GameStoreContext>(options => options.UseNpgsql(db));

builder.Services.Configure<JwtConfig>(builder.Configuration.GetSection("JWT"));
builder.Services.Configure<StripeConfig>(builder.Configuration.GetSection("Stripe"));

var stripeConfig = builder.Configuration.Get<StripeConfig>()!;
StripeConfiguration.ApiKey = stripeConfig.SecretKey;

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
.AddScheme<JwtBearerOptions, JwtAuthorization>(JwtBearerDefaults.AuthenticationScheme, options => { }); ;

builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors();

app.UseAuthorization();

app.MapControllers();

app.Run();
