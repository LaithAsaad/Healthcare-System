using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FirstLayer.Models
{
    public class DoctorForRegistration : IdentityUser
    {
        public int SpecializationId { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public bool Gender { get; set; }
        public DateTime BirthDate { get; set; }

        [Required]
        public string Password { get; set; }

        [Required]
        [Compare("Password")]
        public string ConfirmPassword { get; set; }
    }
    /* public class UserViewModel : IdentityUser
     {

         [Required]
         public string Password { get; set; }

         [Required]
         [Compare("Password")]
         public string ConfirmPassword { get; set; }
     }

     public class LoginViewModel
     {
         [Required]
         public string Email { get; set; }

         [Required]
         public string Password { get; set; }
     }*/
}
