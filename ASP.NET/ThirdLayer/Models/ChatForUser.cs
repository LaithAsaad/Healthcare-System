namespace ThirdLayer.Models
{
    public class ChatForUser
    {
        public ChatForUser() { }
        public int PatientId { get; set; }
        public String UserFirstName { get; set; }
        public String UserLastName { get; set; }
        public String UserImage { get; set; }
        public bool UserGender { get; set; }
        public String UserLastMessage { get; set; }
        public int MessageId { get; set; }

    }
}
