using SecondLayer.IRepositories;
using FirstLayer.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SecondLayer.IRepositories
{
    public interface IDoctorRepository : IBaseRepository<Doctor>
    {
        public List<Doctor> GetDoctors();
        public List<Doctor> GetDoctorsWithAddress(int id);

        Doctor GetDoctor(int id);

    }
}
