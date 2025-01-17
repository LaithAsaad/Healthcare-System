using FirstLayer.Models;
using Microsoft.EntityFrameworkCore;
using SecondLayer.IRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SecondLayer.Repositories
{
    public class BookingRepository : BaseRepository<Booking>, IBookingRepository
    {
        public BookingRepository(HealthCareDBContext context) : base(context)
        {
        }

        public List<Booking> GetDoctorsWithBooking(int id)
        {
            return _context.Bookings.Include(u => u.Doctor).Where(b => b.PatientId == id).ToList();
        }
    }
}
