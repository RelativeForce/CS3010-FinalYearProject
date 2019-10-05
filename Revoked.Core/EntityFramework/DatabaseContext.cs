using System;
using Microsoft.EntityFrameworkCore;
using Revoked.Core.Entities;

namespace Revoked.Core.EntityFramework
{
    public sealed class DatabaseContext : DbContext
    {
        public DatabaseContext(DbContextOptions options) : base(options) 
        {

        }

        public DbSet<PlayerScore> Scores { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            PlayerScore.Configure(modelBuilder);
        }
    }
}
