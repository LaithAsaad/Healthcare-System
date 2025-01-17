using SecondLayer.Repositories;
using FirstLayer.Models;
using SecondLayer.IRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SecondLayer.Repositories
{
    public class AvailableTimeRepository : BaseRepository<AvailableTime>, IAvailableTimeRepository
    {
        public AvailableTimeRepository(HealthCareDBContext context) : base(context)
        {
        }
    }
}
