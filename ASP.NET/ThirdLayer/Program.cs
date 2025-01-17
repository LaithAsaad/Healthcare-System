using SecondLayer.IRepositories;
using SecondLayer.Repositories;
using SecondLayer.UnitOfWork;
using FirstLayer.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using System.Security.Authentication;
using System.Text.Json.Serialization;
using ThirdLayer.Hubs;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<HealthCareDBContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddTransient(typeof(IBaseRepository<>), typeof(BaseRepository<>));

builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();

/*builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
    // Consider setting DefaultIgnoreCondition as well to avoid trying to serialize null values
    options.JsonSerializerOptions.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;
});*/

builder.Services.AddSignalR();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

builder.Services.AddIdentity<ApplicationUser, IdentityRole>(configs =>
{
    configs.User.RequireUniqueEmail = true;
    configs.SignIn.RequireConfirmedPhoneNumber = false;
    configs.SignIn.RequireConfirmedEmail = false;
    //configs.Tokens.ProviderMap.Add("Phone", new TokenProviderDescriptor(typeof(PhoneTokenProvider<>)));
}).AddRoles<IdentityRole>()
.AddEntityFrameworkStores<HealthCareDBContext>()
.AddDefaultTokenProviders();

builder.Services.AddControllersWithViews()
                .AddJsonOptions(x => x.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles);

/*builder.Services.AddHttpClient("MyHttpClient", client =>
{
    client.DefaultRequestHeaders.Add("User-Agent", "MyHttpClient");
}).ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler
{
    SslProtocols = SslProtocols.Tls12 | SslProtocols.Tls13
});*/

// Add services to the container.






builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseCors("AllowAll");

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseRouting();
app.UseAuthorization();
app.UseAuthentication();

app.MapControllers();

app.UseEndpoints(endpoints =>
{
    endpoints.MapControllers();
    endpoints.MapHub<MessageHub>("/MessageHub");
    endpoints.MapHub<DayHub>("/DayHub");
    endpoints.MapHub<ChatHub>("/ChatHub");
    endpoints.MapHub<DoctorHub>("/DoctorHub");
    endpoints.MapHub<PatientHub>("/PatientHub");
    endpoints.MapHub<SpecializationHub>("/SpecializationHub");
});

app.Run();
