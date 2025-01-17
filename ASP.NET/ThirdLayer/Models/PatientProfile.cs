namespace ThirdLayer.Models
{
    public class PatientProfile
    {
        public int Id { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string ApplicationUserId { get; set; }
        public DateTime BirthDate { get; set; }
    }
}
