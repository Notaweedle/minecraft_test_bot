using Microsoft.AspNetCore.SignalR;
using System.Diagnostics;

namespace Minecraft_Webpage.Data.Player
{
    public class Player :Hub
    {
            public Guid UserId { get; set; } // UUID from PostgreSQL
            public string Username { get; set; } = string.Empty;
            public string Password { get; set; } = string.Empty;
            public string MinecraftUsername { get; set; } = string.Empty;
        }


   
   

}
