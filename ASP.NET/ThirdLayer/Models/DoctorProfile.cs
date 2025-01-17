using System.ComponentModel.DataAnnotations;

namespace ThirdLayer.Models
{
    public class DoctorProfile
    {
        public int Id { get; set; }
        public int SpecializationId { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public bool Gender { get; set; }
        public string Image { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string ApplicationUserId { get; set; }
        public DateTime BirthDate { get; set; }

    }
}
