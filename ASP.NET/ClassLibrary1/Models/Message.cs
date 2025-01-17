using System;
using System.Collections.Generic;

namespace FirstLayer.Models
{
    public partial class Message
    {
        public int Id { get; set; }
        public int ChatId { get; set; }
        public string MessageContent { get; set; } = null!;
        public DateTime Date { get; set; }
        public bool ByPatient { get; set; }
        public bool? IsEdited { get; set; }
        public bool? IsRead { get; set; }
        public virtual Chat? Chat { get; set; } = null!;
    }
}
