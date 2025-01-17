using System;
using System.Collections.Generic;

namespace FirstLayer.Models
{
    public partial class Specialization
    {
        public Specialization()
        {
            Doctors = new HashSet<Doctor>();
        }

        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public string Image { get; set; } = null!;

        public virtual ICollection<Doctor> Doctors { get; set; }
    }
}
