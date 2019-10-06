using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Revoked.Core.EntityFramework
{
    /// <summary>
    /// Required by EntityFramework to initially set up the database locally
    /// </summary>
    public sealed class DatabaseContextFactory : IDesignTimeDbContextFactory<DatabaseContext>
    {
        public DatabaseContext CreateDbContext(string[] args)
        {
            var builder = new DbContextOptionsBuilder();

            var connectionString = Environment.GetEnvironmentVariable("DBConnectionString");

            if (connectionString == null)
            {
                builder.UseSqlServer("Server=.\\SQLEXPRESS;Database=Revoked;Trusted_Connection=True;MultipleActiveResultSets=true");
            }
            else
            {
                builder.UseSqlServer(connectionString);
            }

            return new DatabaseContext(builder.Options);
        }
    }
}
