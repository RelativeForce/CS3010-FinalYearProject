using System;
using Microsoft.EntityFrameworkCore;

namespace Revoked.Core.Entities
{
    public class PlayerScore : BaseEntity
    {
        public string Username { get; set; }
        public long Score { get; set; }
        public TimeSpan Time { get; set; }

        public static void Configure(ModelBuilder builder)
        {
            builder.Entity<PlayerScore>().HasKey(ps => ps.Id);
        }
    }
}
