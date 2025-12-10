using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Minecraft_Webpage.Components;
using Minecraft_Webpage.Data;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

// API
builder.Services.AddScoped(sp =>
<<<<<<< Updated upstream
    new HttpClient { BaseAddress = new Uri("http://localhost:3050/") });
=======
    new HttpClient { BaseAddress = new Uri("http://localhost:3000/") });
builder.Services.AddScoped<CommandService>();
builder.Services.AddHttpClient();  
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

var app = builder.Build();

app.UseHttpsRedirection();
app.UseAntiforgery();
app.MapStaticAssets();
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();


app.Run();