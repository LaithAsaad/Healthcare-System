namespace ThirdLayer.Models
{
    public class MessageViewModel
    {
        public int Id { get; set; }
        public int ChatId { get; set; }
        public string MessageContent { get; set; }
        public DateTime Date { get; set; }
        public bool ByPatient { get; set; }
        public bool IsEdited { get; set; }
        public bool IsRead { get; set; }
    }
}
