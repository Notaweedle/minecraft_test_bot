namespace Minecraft_Webpage.Data
{
    public class RconConfig
    {
        [System.ComponentModel.DataAnnotations.Key]
        public int Id { get; set; }          // Primary Key
        public string ServerIp { get; set; }
        public int ServerPort { get; set; }
        public string ServerPassword { get; set; }
    }
}
