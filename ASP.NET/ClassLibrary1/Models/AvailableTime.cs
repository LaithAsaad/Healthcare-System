using System;
using System.Collections.Generic;

namespace FirstLayer.Models
{
    public partial class AvailableTime
    {
        public int Id { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public int DayId { get; set; }
        public int DoctorId { get; set; }
        public bool IsAvailable { get; set; }
        public string? ReasonOfUnavilability { get; set; }

        public virtual Day? Day { get; set; } = null!;
        public virtual Doctor? Doctor { get; set; } = null!;
    }
}
