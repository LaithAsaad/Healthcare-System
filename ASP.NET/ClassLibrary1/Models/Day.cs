using System;
using System.Collections.Generic;

namespace FirstLayer.Models
{
    public partial class Day
    {
        public Day()
        {
            AvailableTimes = new HashSet<AvailableTime>();
        }

        public int Id { get; set; }
        public string Name { get; set; } = null!;

        public virtual ICollection<AvailableTime> AvailableTimes { get; set; }
    }
}
