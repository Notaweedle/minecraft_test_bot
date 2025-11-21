using Microsoft.AspNetCore.SignalR;
using System.Diagnostics;

namespace Minecraft_Webpage.Data.Player
{
    public class Player :Hub
    {
        public Guid ID = Guid.Empty;
        public string UserName = string.Empty;

        public Player(string username)
        {
            UserName = username;
            ID = Guid.NewGuid();
        }
        public async Task SendMessage_ID(this Player player, string message)
        {

            await Clients.All.SendAsync("ReceiveMessage", player.UserName, message);
            Debug.WriteLine($"{player.UserName},{message},{player.ID}");
        }
    }

   

}
