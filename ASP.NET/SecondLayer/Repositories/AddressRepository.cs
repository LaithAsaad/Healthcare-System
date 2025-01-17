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
    public class AddressRepository : BaseRepository<Address>, IAddressRepository
    {
        public AddressRepository(HealthCareDBContext context) : base(context)
        {
        }
    }
}
