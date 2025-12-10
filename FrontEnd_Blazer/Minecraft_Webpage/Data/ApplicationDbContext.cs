using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System;

namespace Minecraft_Webpage.Data
{
    public class ApplicationDbContext : DbContext
    {
        public DbSet<RconConfig> RconConfigs { get; set; }

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }
    }
}
