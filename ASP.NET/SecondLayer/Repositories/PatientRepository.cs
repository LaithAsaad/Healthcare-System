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
    public class PatientRepository : BaseRepository<Patient>, IPatientRepository
    {
        public PatientRepository(HealthCareDBContext context) : base(context)
        {
        }
        public Patient GetPatient(int id)
        {
            var patient = _context.Patients
                .Include(d => d.ApplicationUser)
                .FirstOrDefault(d => d.Id == id);

            return patient;
        }

        public List<Patient> GetPatients()
        {
            return _context.Patients.Include(u => u.ApplicationUser).ToList();
        }
    }
}
