using FirstLayer.Models;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
namespace ThirdLayer.Hubs
{
    public class PatientHub : Hub
    {
        public void SendPatient(Patient patient)
        {
            Clients.All.SendAsync("sendPatient", patient);
        }

        public void DeletePatient(Patient patient)
        {
            Clients.All.SendAsync("deletePatient", patient);
        }

        public void UpdatePatient(Patient patient)
        {
            Clients.All.SendAsync("updatePatient", patient);
        }

        public void SendDay(Day day)
        {
            Clients.All.SendAsync("sendDay", day);
        }

        //public void AddReply(Message message)
        //{
        //    Clients.All.SendAsync("addReply", message);
        //}
    }
}
