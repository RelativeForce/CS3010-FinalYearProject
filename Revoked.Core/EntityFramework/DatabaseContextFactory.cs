using Microsoft.EntityFrameworkCore.Design;

namespace Revoked.Core.EntityFramework
{
    public sealed class DatabaseContextFactory : IDesignTimeDbContextFactory<DatabaseContext>
    {
        public DatabaseContext CreateDbContext(string[] args)
        {
            return new DatabaseContext();
        }
    }
}
