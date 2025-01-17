using System;
using System.Collections.Generic;

namespace FirstLayer.Models
{
    public partial class Patient
    {
        public Patient()
        {
            Chats = new HashSet<Chat>();
        }

        public int Id { get; set; }
        public DateTime BirthDate { get; set; }

        public string FirstName { get; set; }
        public string LastName { get; set; }

        public virtual ICollection<Chat> Chats { get; set; }
        public virtual ICollection<Booking> Bookings { get; set; }

        public string ApplicationUserId { get; set; }
        public ApplicationUser ApplicationUser { get; set; }
    }
}
