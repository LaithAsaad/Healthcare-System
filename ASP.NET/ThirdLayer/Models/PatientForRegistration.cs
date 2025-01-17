using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace ThirdLayer.Models
{
    public class PatientForRegistration : IdentityUser
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public DateTime BirthDate { get; set; }

        [Required]
        public string Password { get; set; }

        [Required]
        [Compare("Password")]
        public string ConfirmPassword { get; set; }
    }
}
