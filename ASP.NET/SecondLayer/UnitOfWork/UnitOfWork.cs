using SecondLayer.IRepositories;
using SecondLayer.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FirstLayer.Models;

namespace SecondLayer.UnitOfWork
{
    public class UnitOfWork : IUnitOfWork, IDisposable
    {

        private readonly HealthCareDBContext _context;
        public IDoctorRepository doctorRepository { get; }

        public IPatientRepository patientRepository { get; }

        public ISpecializationRepository specializationRepository { get; }

        public IMessageRepository messageRepository { get; }

        public IChatRepository chatRepository { get; }

        public IAvailableTimeRepository availableTimeRepository { get; }

        public IAddressRepository addressRepository { get; }


        public IDayRepository dayRepository { get; }
        public IBookingRepository bookingRepository { get; }

        //private bool _disposed;

        public UnitOfWork(HealthCareDBContext context)
        {
            _context = context;
            doctorRepository = new DoctorRepository(context);
            patientRepository = new PatientRepository(context);
            specializationRepository = new SpecializationRepository(context);
            messageRepository = new MessageRepository(context);
            chatRepository = new ChatRepository(context);
            addressRepository = new AddressRepository(context);
            availableTimeRepository = new AvailableTimeRepository(context);
            dayRepository = new DayRepository(context); 
            bookingRepository = new BookingRepository(context);
        }

        

        public void Dispose()
        {
            _context.Dispose();
        }

        public void SaveChanges()
        {
            _context.SaveChanges();
        }
    }
}
