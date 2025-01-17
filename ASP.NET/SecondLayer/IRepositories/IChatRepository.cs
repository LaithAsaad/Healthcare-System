using SecondLayer.IRepositories;
using FirstLayer.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SecondLayer.IRepositories
{
    public interface IChatRepository : IBaseRepository<Chat>
    {

        public IEnumerable<Chat> GetChatWithDoctorAndMessages(int id);

        public IEnumerable<Chat> GetChatWithPatientAndMessages(int id);
    }
}
