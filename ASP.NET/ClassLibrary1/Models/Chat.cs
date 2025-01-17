using System;
using System.Collections.Generic;

namespace FirstLayer.Models
{
    public partial class Chat
    {
        public Chat()
        {
            Messages = new HashSet<Message>();
        }

        public int Id { get; set; }
        public int PatientId { get; set; }
        public int? DoctorId { get; set; }

        public virtual Doctor? Doctor { get; set; }
        public virtual Patient Patient { get; set; } = null!;
        public virtual ICollection<Message> Messages { get; set; }
    }
}
