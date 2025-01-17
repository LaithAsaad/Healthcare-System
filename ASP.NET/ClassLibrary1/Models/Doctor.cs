using System;
using System.Collections.Generic;

namespace FirstLayer.Models
{
    public partial class Doctor
    {
        public Doctor()
        {
            AvailableTimes = new HashSet<AvailableTime>();
            Chats = new HashSet<Chat>();
        }

        public int Id { get; set; }
        public int SpecializationId { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public bool Gender { get; set; }
        public string? Image { get; set; }

        public virtual Specialization Specialization { get; set; } = null!;
        public virtual Address Address { get; set; } = null!;
        public virtual ICollection<AvailableTime> AvailableTimes { get; set; }
        public virtual ICollection<Chat> Chats { get; set; }
        public virtual ICollection<Booking> Bookings { get; set; }

        public string ApplicationUserId { get; set; }
        public ApplicationUser ApplicationUser { get; set; }
    }
}
