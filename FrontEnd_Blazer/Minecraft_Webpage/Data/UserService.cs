using Minecraft_Webpage.Data.Player;

namespace Minecraft_Webpage.Data
{
    using Npgsql;
    using Dapper;
    

    public class UserService
    {
        private readonly string _connectionString;
        public UserService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<bool> CreateUserAsync(string username, string password, string minecraftUsername)
        {
            using var connection = new NpgsqlConnection(_connectionString);

            // Hash the password using a secure method
            var passwordHash = BCrypt.Net.BCrypt.HashPassword(password);

            var sql = @"
            INSERT INTO users (username, password, minecraft_username)
            VALUES (@Username, @Password, @MinecraftUsername)
        ";

            var result = await connection.ExecuteAsync(sql, new
            {
                Username = username,
                Password = passwordHash,
                MinecraftUsername = minecraftUsername
            });

            return result > 0;
        }
        public async Task<bool> ValidateUserAsync(string username, string password)
        {
            var user = await GetUserByUsernameAsync(username);
            if (user == null)
                return false;

            // Check the password against the hashed password
            return BCrypt.Net.BCrypt.Verify(password, user.Password);
        }


        public async Task<Player.Player?> GetUserByUsernameAsync(string username)
        {
            using var connection = new NpgsqlConnection(_connectionString);
            return await connection.QueryFirstOrDefaultAsync<Player.Player>(
                "SELECT * FROM users WHERE username = @Username", new { Username = username });
        }
    }

}
