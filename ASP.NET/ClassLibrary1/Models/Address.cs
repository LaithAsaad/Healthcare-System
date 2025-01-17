using System;
using System.Collections.Generic;

namespace FirstLayer.Models
{
    public partial class Address
    {
        public int Id { get; set; }
        public string Governorate { get; set; } = null!;
        public string City { get; set; } = null!;
        public string Street { get; set; } = null!;

        public virtual Doctor? IdNavigation { get; set; } = null!;
    }
}
