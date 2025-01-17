using FirstLayer.Models;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
namespace ThirdLayer.Hubs
{
    public class DoctorHub : Hub
    {
        public void SendDoctor(Doctor doctor)
        {
            Clients.All.SendAsync("sendDoctor", doctor);
        }

        public void DeleteDoctor(Doctor doctor)
        {
            Clients.All.SendAsync("deleteDoctor", doctor);
        }

        public void UpdateDoctor(Doctor doctor)
        {
            Clients.All.SendAsync("updateDoctor", doctor);
        }

        public void AddReply(Message message)
        {
            Clients.All.SendAsync("addReply", message);
        }

        //public void SendDay(Day day)
        //{
        //    Clients.All.SendAsync("sendDay", day);
        //}
    }
}
