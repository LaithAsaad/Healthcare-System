using FirstLayer.Models;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using ThirdLayer.Models;

namespace ThirdLayer.Hubs
{
    public class MessageHub : Hub
    {
        public async Task TriggerApi(bool isPatient, String id)
        {
            
            using (var client = new HttpClient())
            {
                
                if (isPatient)
                {
                    var response = await client.GetAsync($"https://localhost:44324/api/Patient/UpdateStatus?id={id}");
                    if (response.IsSuccessStatusCode)
                    {
                        // The request was successful
                        Console.WriteLine("UpdateStatus API was called successfully.");
                    }
                    else
                    {
                        // The request failed
                        Console.WriteLine("Failed to call UpdateStatus API.");
                    }
                }
                else
                {
                    var response = await client.GetAsync($"https://localhost:44324/api/Doctor/UpdateStatus?id={id}");
                    if (response.IsSuccessStatusCode)
                    {
                        // The request was successful
                        Console.WriteLine("UpdateStatus API was called successfully.");
                    }
                    else
                    {
                        // The request failed
                        Console.WriteLine("Failed to call UpdateStatus API.");
                    }
                }
                
            }
        }

        public async Task TriggerChatApi(bool isPatient, String id)
        {
            using (var client = new HttpClient())
            {

                if (isPatient)
                {
                    var response = await client.GetAsync($"https://localhost:44324/api/Doctor/UpdateMessagesStatus?id={id}");
                    if (response.IsSuccessStatusCode)
                    {
                        // The request was successful
                        Console.WriteLine("UpdateStatus API was called successfully.");
                    }
                    else
                    {
                        // The request failed
                        Console.WriteLine("Failed to call UpdateStatus API.");
                    }
                }
                else
                {
                    var response = await client.GetAsync($"https://localhost:44324/api/Patient/UpdateMessagesStatus?id={id}");
                }

            }
        }

            public void DeleteMessage(MessageViewModel message)
        {
            Clients.All.SendAsync("deleteMessage", message);
        }

        public void GetMessages(List<MessageViewModel> messages)
        {
            Clients.All.SendAsync("getMessages", messages);
        }

        public void UpdateMessage(MessageViewModel message)
        {
            Clients.All.SendAsync("updateMessage", message);
        }

        public void UpdateStatus(List<MessageViewModel> messages)
        {
            Clients.All.SendAsync("updateStatus", messages);
        }
        public void Update(List<MessageViewModel> messages)
        {
            Clients.All.SendAsync("update", messages);
        }

        public void GetChatMessages(MessageViewModel message)
        {
            Clients.All.SendAsync("getChatMessages", message);
        }

        public async Task SendMessage(MessageViewModel message)
        {
            await Clients.All.SendAsync("addMessage", message);
        }

        public async Task AddedMessage(MessageViewModel message)
        {
            await Clients.All.SendAsync("addedMessage", message);
        }

        public async Task DeleteMessageHub(MessageViewModel message)
        {
            await Clients.All.SendAsync("deleteMessageHub", message);
        }

        public void GetCreatedChat(ChatInfo chat, int id,int id2, ChatInfo chat2)
        {
            Clients.All.SendAsync("getCreatedChat", chat, id, id2,chat2);
        }
    }
}
