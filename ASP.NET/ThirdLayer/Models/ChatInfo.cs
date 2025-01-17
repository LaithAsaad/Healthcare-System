namespace ThirdLayer.Models
{
    public class ChatInfo
    {
        public ChatInfo() { }
        public int ChatId { get; set; }
        public int ChatUserId { get; set; }
        public String UserFirstName { get; set; }
        public String UserLastName { get; set; }
        public String UserImage { get; set; }
        public bool UserGender { get; set; }
        public String UserLastMessage { get; set; }
        public DateTime LastMessageDate { get; set; }
        public int NumberOfUnreadMessage { get; set; }
    }
}
