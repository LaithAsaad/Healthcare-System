using SecondLayer.IRepositories;
using FirstLayer.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace SecondLayer.Repositories
{
    public class BaseRepository<Entity> : IBaseRepository<Entity> where Entity : class
    {

        protected readonly HealthCareDBContext _context;
        protected readonly DbSet<Entity> _entitySet;

        public BaseRepository(HealthCareDBContext context)
        {
            _context = context;
            _entitySet = _context.Set<Entity>();
        }
        public void Add(Entity entity)
        {
            _entitySet.Add(entity);
        }

        public void Delete(Entity entity)
        {
            _entitySet.Remove(entity);
        }

        public IEnumerable<Entity> FindByCondition(Expression<Func<Entity, bool>> predicate)
        {
            return _entitySet.Where(predicate);
        }

        public async Task<IEnumerable<Entity>> GetAllAsync()
        {
            return await _entitySet.ToListAsync();
        }

        public IEnumerable<Entity> GetAll()
        {
            return _entitySet.ToList();
        }

        public async Task<Entity> GetByIdAsync(int id)
        {
            return await _entitySet.FindAsync(id);
        }

        public Entity GetById(int id)
        {
            return _entitySet.Find(id);
        }

        public void Update(Entity entity)
        {
            _entitySet.Update(entity);
            _context.Entry(entity).State = EntityState.Modified;
        }
    }
}
