using System;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Revoked.Core.Entities;

namespace Revoked.Core.Interfaces
{
    public interface IRepository
    {
        Task<T> AddAsync<T>(T newItem) where T : BaseEntity;

        Task<T> FindAsync<T>(Expression<Func<T, bool>> predicate) where T : BaseEntity;

        IQueryable<T> Query<T>() where T : BaseEntity;

        IQueryable<T> Where<T>(Expression<Func<T, bool>> predicate) where T : BaseEntity;

        Task DeleteAsync<T>(T itemToDelete) where T : BaseEntity;
    }
}
