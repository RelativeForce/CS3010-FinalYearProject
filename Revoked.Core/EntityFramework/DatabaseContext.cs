using System;
using Microsoft.EntityFrameworkCore;
using Revoked.Core.Entities;

namespace Revoked.Core.EntityFramework
{
    public sealed class DatabaseContext : DbContext
    {
        internal DatabaseContext() : base() 
        {

        }

        public DbSet<PlayerScore> Scores { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            PlayerScore.Configure(modelBuilder);
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            var connectionString = Environment.GetEnvironmentVariable("DBConnectionString");

            if (connectionString == null)
            {
                optionsBuilder.UseSqlServer("Server=.\\SQLEXPRESS;Database=Revoked;Trusted_Connection=True;MultipleActiveResultSets=true");
                return;
            }
            
            optionsBuilder.UseSqlServer(connectionString);
        }
    }
}
