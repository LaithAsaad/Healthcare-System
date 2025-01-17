using System.ComponentModel.DataAnnotations;

namespace ThirdLayer.Models
{
    public class LogIn
    {
        [Required]
        public string Email { get; set; }

        [Required]
        public string Password { get; set; }
    }
}
