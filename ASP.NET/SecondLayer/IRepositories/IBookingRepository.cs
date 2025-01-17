using FirstLayer.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SecondLayer.IRepositories
{
    public interface IBookingRepository:IBaseRepository<Booking>
    {
        public List<Booking> GetDoctorsWithBooking(int id);
    }
}
