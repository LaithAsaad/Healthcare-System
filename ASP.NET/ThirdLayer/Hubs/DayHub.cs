using FirstLayer.Models;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

namespace ThirdLayer.Hubs
{
    public class DayHub : Hub
    {
       

        public void DeleteDay (Day day) 
        {
            Clients.All.SendAsync("deleteDay", day);
        }

        public void UpdateDay(Day day)
        {
            Clients.All.SendAsync("updateDay", day);
        }

        public void SendDay(Day day)
        {
            Clients.All.SendAsync("sendDay", day);
        }

            public void AddMessage(Message message)
        {
            Clients.All.SendAsync("addMessage", message);
        }

        public void AddMes(Day message)
        {
            Clients.All.SendAsync("addMes", message);
        }
    }
}
