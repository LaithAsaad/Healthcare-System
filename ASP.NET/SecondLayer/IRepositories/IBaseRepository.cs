using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace SecondLayer.IRepositories
{
    public interface IBaseRepository<Entity> where Entity : class
    {
        void Add(Entity entity);

        void Update(Entity entity);

        void Delete(Entity entity);
        public Task<IEnumerable<Entity>> GetAllAsync();

        IEnumerable<Entity> GetAll();

        IEnumerable<Entity> FindByCondition(Expression<Func<Entity, bool>> predicate);

        Task<Entity> GetByIdAsync(int id);
        Entity GetById(int id);

    }
}

