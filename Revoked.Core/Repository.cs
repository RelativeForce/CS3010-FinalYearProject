using System;
using System.Diagnostics;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Revoked.Core.Entities;
using Revoked.Core.EntityFramework;
using Revoked.Core.Interfaces;

namespace Revoked.Core
{
    public sealed class Repository : IRepository
    {
        private readonly DatabaseContext _dbContext;

        public Repository(DatabaseContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<T> AddAsync<T>(T newItem) where T : BaseEntity
        {
            try
            {
                var entry = await _dbContext.Set<T>().AddAsync(newItem);

                await _dbContext.SaveChangesAsync();

                return entry.Entity;
            }
            catch (Exception e)
            {
                Trace.TraceError(e.ToString());
                return null;
            }
        }

        public async Task<T> FindAsync<T>(Expression<Func<T, bool>> predicate) where T : BaseEntity
        {
            try
            {
                return await _dbContext.Set<T>().FirstOrDefaultAsync(predicate);
            }
            catch (Exception e)
            {
                Trace.TraceError(e.ToString());
                return null;
            }
        }

        public IQueryable<T> Query<T>() where T : BaseEntity
        {
            try
            {
                return _dbContext.Set<T>();
            }
            catch (Exception e)
            {
                Trace.TraceError(e.ToString());
                return null;
            }
        }

        public IQueryable<T> Where<T>(Expression<Func<T, bool>> filter) where T : BaseEntity
        {
            try
            {
                return _dbContext.Set<T>().Where(filter);
            }
            catch (Exception e)
            {
                Trace.TraceError(e.ToString());
                return null;
            }
        }

        public async Task DeleteAsync<T>(T itemToDelete) where T : BaseEntity
        {
            try
            {
                _dbContext.Set<T>().Remove(itemToDelete);

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception e)
            {
                Trace.TraceError(e.ToString());
            }
        }
    }
}
