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
            if (Environment.GetEnvironmentVariable("Environment") == "Production")
            {
                optionsBuilder.UseSqlServer(@"Live database connection string");
            }
            else
            {
                optionsBuilder.UseSqlServer(@"Server=.\;Database=Revoked;Trusted_Connection=True;MultipleActiveResultSets=true");
            }
        }
    }
}
