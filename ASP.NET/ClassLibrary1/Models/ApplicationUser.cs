using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FirstLayer.Models
{
    public class ApplicationUser : IdentityUser<String>
    {
        //[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        //public override int Id { get; set; }
        public virtual Doctor Doctor { get; set; }
        public virtual Patient Patient { get; set; }
    }
}
