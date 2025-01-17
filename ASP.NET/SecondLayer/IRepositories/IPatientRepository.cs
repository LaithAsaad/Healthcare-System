using SecondLayer.IRepositories;
using FirstLayer.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SecondLayer.IRepositories
{
    public interface IPatientRepository : IBaseRepository<Patient>
    {
        public List<Patient> GetPatients();

        Patient GetPatient(int id);
    }
}
