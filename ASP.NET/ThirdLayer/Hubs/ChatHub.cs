using FirstLayer.Models;
using Microsoft.AspNetCore.SignalR;
using System;
using ThirdLayer.Models;

namespace ThirdLayer.Hubs
{
    public class ChatHub : Hub
    {
        public void SendChat(Chat chat)
        {
            Clients.All.SendAsync("sendChat", chat);
        }

        public void DeleteChat(Chat chat)
        {
            Clients.All.SendAsync("deleteChat", chat);
        }

        public void GetChats(List<ChatForUser> userChats)
        {
            Clients.All.SendAsync("getChats", userChats);
        }

        public void UpdateChat(Chat chat)
        {
            Clients.All.SendAsync("updateChat", chat);
        }

        //public void SendQuestion(Chat chat)
        //{
        //    Clients.All.SendAsync("sendQuestion", chat);
        //}

        //public void GetQuestions(List<Chat> chats)
        //{
        //    Clients.All.SendAsync("getQuestions", chats);
        //}

        public void SendAnswer(Chat chat)
        {
            Clients.All.SendAsync("sendAnswer", chat);
        }

        public void SendMessage(Message message)
        {
            Clients.All.SendAsync("sendMessage", message);
        }
    }
}
