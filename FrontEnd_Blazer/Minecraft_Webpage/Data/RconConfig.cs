using System.ComponentModel.DataAnnotations;

namespace Minecraft_Webpage.Data
{
    public class RconConfig
    {
        [System.ComponentModel.DataAnnotations.Key]
        public int Id { get; set; }          // Primary Key

        [Required]
        public string ServerIp { get; set; }
        [Required]
        [Range(1, 65535, ErrorMessage = "Port must be between 1 and 65535.")]
        public int ServerPort { get; set; }
        [Required]
        public string ServerPassword { get; set; }
    }
}
