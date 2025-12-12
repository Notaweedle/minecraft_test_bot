using System.Text.Json;
using System.Text.Json.Serialization;

namespace Minecraft_Webpage.Data
{
    public class Command
    {
        [JsonPropertyName("command")]
        public string CommandText { get; set; } = string.Empty;

        [JsonPropertyName("description")]
        public string Description { get; set; } = string.Empty;

    }


    public class CommandService
    {
        private readonly string _filePath;

        public CommandService(IWebHostEnvironment env)
        {
            _filePath = Path.Combine(env.ContentRootPath, "Data", "minecraftCommands.json");
        }

        public List<Command> GetCommands()
        {
            if (!File.Exists(_filePath))
                return new List<Command>();

            var json = File.ReadAllText(_filePath);
            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            };
            return JsonSerializer.Deserialize<List<Command>>(json, options) ?? new List<Command>();
        }
    }
}

