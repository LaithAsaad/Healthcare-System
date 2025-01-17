using FirstLayer.Models;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
namespace ThirdLayer.Hubs
{
    public class SpecializationHub : Hub
    {
        public void SendSpecialization(Specialization specialization)
        {
            Clients.All.SendAsync("sendSpecialization", specialization);
        }

        public void DeleteSpecialization(Specialization specialization)
        {
            Clients.All.SendAsync("deleteSpecialization", specialization);
        }

        public void UpdateSpecialization(Specialization specialization)
        {
            Clients.All.SendAsync("updateSpecialization", specialization);
        }
    }
}
