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
    public class ChatRepository : BaseRepository<Chat>, IChatRepository
    {
        public ChatRepository(HealthCareDBContext context) : base(context)
        {

        }
        public HealthCareDBContext CurrDbContext
        {
            get { return _context as HealthCareDBContext; }     // Casting the Context of the base Repository to PosSystemContext
        }

        public IEnumerable<Chat> GetChatWithDoctorAndMessages(int patientId)
        {
            return CurrDbContext.Chats
                .Include(c => c.Doctor)
        .Include(c => c.Messages)
        .Where(c => c.PatientId == patientId)
        .ToList();
        }

        public IEnumerable<Chat> GetChatWithPatientAndMessages(int doctorId)
        {
            return CurrDbContext.Chats
                .Include(c => c.Patient)
        .Include(c => c.Messages)
        .Where(c => c.DoctorId == doctorId)
        .ToList();
        }
    }
}
