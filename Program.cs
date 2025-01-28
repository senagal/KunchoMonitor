using activity.Services;
using content.Services;
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddSingleton<IContentServices, ContentService>();
builder.Services.AddSingleton<IActivityServices, ActivityService>();
// For example, in Program.cs (for .NET 6+)

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
