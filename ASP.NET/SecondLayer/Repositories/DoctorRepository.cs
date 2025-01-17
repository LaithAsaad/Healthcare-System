using SecondLayer.Repositories;
using FirstLayer.Models;
using SecondLayer.IRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace SecondLayer.Repositories
{
    public class DoctorRepository : BaseRepository<Doctor>, IDoctorRepository
    {
        public DoctorRepository(HealthCareDBContext context) : base(context)
        {
        }

        public Doctor GetDoctor(int id)
        {
            var doctor = _context.Doctors
                .Include(d => d.ApplicationUser)
                .FirstOrDefault(d => d.Id == id);

            return doctor;
        }

        public List<Doctor> GetDoctors()
        {
            return _context.Doctors.Include(u => u.ApplicationUser).ToList();
        }

        public List<Doctor> GetDoctorsWithAddress(int id)
        {
            return _context.Doctors.Include(u => u.Address).Where(d => d.SpecializationId == id).ToList();
        }

    }
}
