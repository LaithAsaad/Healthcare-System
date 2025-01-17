using SecondLayer.IRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SecondLayer.UnitOfWork
{
    public interface IUnitOfWork : IDisposable
    {
        void SaveChanges();
        IDoctorRepository doctorRepository { get; }
        IPatientRepository patientRepository { get; }
        ISpecializationRepository specializationRepository { get; }
        IMessageRepository messageRepository { get; }   
        IChatRepository chatRepository { get; }
        IAvailableTimeRepository availableTimeRepository { get; }
        IAddressRepository addressRepository { get; }
        IDayRepository dayRepository { get; }
        IBookingRepository bookingRepository { get; }

    }
}
