using FirstLayer.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using SecondLayer.UnitOfWork;
using System.Numerics;
using ThirdLayer.Hubs;
using ThirdLayer.Models;

namespace ThirdLayer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PatientController : BaseController
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly IHubContext<MessageHub> _hubContext;
        public PatientController(IUnitOfWork unitOfWork, UserManager<ApplicationUser> userManager, SignInManager<ApplicationUser> signInManager, IHubContext<MessageHub> hubContext) : base(unitOfWork)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _hubContext = hubContext;
        }
        [HttpPost]
        public async Task<IActionResult> AddpatientAsync(PatientForRegistration patient)
        {
            bool IsPhoneAlreadyRegistered = _userManager.Users.Any(item => item.PhoneNumber == patient.PhoneNumber);
            if (ModelState.IsValid)
            {
                if (!IsPhoneAlreadyRegistered)
                {
                    patient.UserName = patient.FirstName + patient.LastName;
                    var newUser = new ApplicationUser
                    {
                        Id = Guid.NewGuid().ToString(),
                        Email = patient.Email,
                        UserName = patient.UserName,
                        EmailConfirmed = true,
                        PhoneNumber = patient.PhoneNumber,
                        NormalizedUserName = patient.UserName.ToUpper(),
                        NormalizedEmail = patient.Email.ToUpper(),
                    };
                    var result = await _userManager.CreateAsync(newUser, patient.Password);

                    if (result.Succeeded)
                    {
                        var newPatient = new Patient
                        {
                            FirstName = patient.FirstName,
                            LastName = patient.LastName,
                            BirthDate = patient.BirthDate,
                            ApplicationUserId = newUser.Id,
                        };
                        _unitOfWork.patientRepository.Add(newPatient);
                        _unitOfWork.SaveChanges();
                        return Ok(new { patientId = newPatient.Id });
                    }
                    else
                    {
                        // Handle the case where user creation failed
                        return BadRequest(result.Errors.FirstOrDefault());
                    }
                }
                else ModelState.AddModelError(string.Empty, "This number is already taken");
            }
            return BadRequest(new { error = ModelState.Values.SelectMany(v => v.Errors).FirstOrDefault()?.ErrorMessage });
        }

        [Route("~/login/patient")]
        [HttpPost]
        public async Task<IActionResult> Login(LogIn model)
        {
            if (ModelState.IsValid)
            {
                var user = await _userManager.FindByEmailAsync(model.Email);
                if (user != null)
                {
                    var isPatient = _unitOfWork.patientRepository.FindByCondition(p => p.ApplicationUserId.Equals(user.Id)).Any();
                    if (isPatient)
                    {
                        var result = await _signInManager.PasswordSignInAsync(user, model.Password,
                            true, false);
                        if (result.Succeeded)
                        {
                            Patient patient = _unitOfWork.patientRepository.FindByCondition(p => p.ApplicationUserId == user.Id).First();
                            return Ok(new { patientId = patient.Id });
                        }
                        else
                        {
                            ModelState.AddModelError(string.Empty, "Invalid login attempt, incorrect password");
                        }
                    }
                    else
                    {
                        ModelState.AddModelError(string.Empty, "Email not a patient email");
                    }
                }
                else ModelState.AddModelError(string.Empty, "Invalid login attempt, this email is not registered");
            }

            return BadRequest(new { error = ModelState.Values.SelectMany(v => v.Errors).FirstOrDefault()?.ErrorMessage });
        }
        [HttpGet("{id}")]
        public IActionResult GetPatient(int id)
        {
            var patient = _unitOfWork.patientRepository.GetPatient(id);

            if (patient == null)
            {
                return NotFound();
            }

            return Ok(patient);
        }

        [HttpGet]
        public IActionResult GetPatients(int id)
        {
            var patients = _unitOfWork.patientRepository.GetPatients();

            if (patients == null)
            {
                return NotFound();
            }

            return Ok(patients);
        }
        [Route("~/Patient/sendConsultation/{patientId}")]
        [HttpPost]
        public IActionResult SendConsultation(Message message, int patientId)
        {
            var chat = _unitOfWork.chatRepository.FindByCondition(c => c.PatientId == patientId && c.DoctorId == null).FirstOrDefault();
            if (chat != null)
            {
                message.ChatId = chat.Id;
                _unitOfWork.messageRepository.Add(message);
                _unitOfWork.SaveChanges();
                return Ok(message);

            }
            else
            {
                var newchat = new Chat
                {
                    DoctorId = null,
                    PatientId = patientId,
                };
                _unitOfWork.chatRepository.Add(newchat);
                _unitOfWork.SaveChanges();
                if (newchat != null)
                {

                    message.ChatId = newchat.Id;
                    _unitOfWork.messageRepository.Add(message);
                    _unitOfWork.SaveChanges();
                    return Ok(message);
                }
                else
                {
                    return NotFound();
                }
            }
        }

        [Route("~/Patient/sendMessageToDoctor/{patientId}/{doctorId}")]
        [HttpGet]
        public IActionResult SendMessageToDoctor(int patientId, int doctorId)
        {
            var chat = _unitOfWork.chatRepository.FindByCondition(c => c.PatientId == patientId && c.DoctorId == doctorId).FirstOrDefault();
            return Ok(chat);
        }

        [Route("~/Patient/createChat/{patientId}/{doctorId}/{message}")]
        [HttpPost]
        public async Task<IActionResult> CreateChat(int patientId,int doctorId,String message)
        {
            Chat chat = new Chat { PatientId = patientId, DoctorId = doctorId };
            _unitOfWork.chatRepository.Add(chat);
            _unitOfWork.SaveChanges();
            if (chat != null)
            {
                var mesView = SendMessage(chat.Id.ToString(), message);

                var doc = _unitOfWork.doctorRepository.GetById(doctorId);
                var pat = _unitOfWork.patientRepository.GetById(patientId);
                if (doc != null&& pat!=null) {

                    ChatInfo chatInfo = new ChatInfo
                    {
                        ChatId = chat.Id,
                        ChatUserId = doctorId,
                        LastMessageDate = DateTime.Now,
                        UserFirstName = doc.FirstName,
                        UserLastName = doc.LastName,
                        UserImage =doc.Image,
                        UserLastMessage = message,
                        UserGender =doc.Gender,
                        NumberOfUnreadMessage = 1
                    };
                    ChatInfo chatInfo2 = new ChatInfo
                    {
                        ChatId = chat.Id,
                        ChatUserId = patientId,
                        LastMessageDate = DateTime.Now,
                        UserFirstName = pat.FirstName,
                        UserLastName = pat.LastName,
                        UserLastMessage = message,
                        NumberOfUnreadMessage = 1
                    };
                    await _hubContext.Clients.All.SendAsync("getCreatedChat", chatInfo, patientId,doctorId,chatInfo2);
                }
            }
            return Ok(chat);
        }



        [Route("~/Patient/getAllConsultation/{id}")]
        [HttpGet]
        public IActionResult GetAllConsultation(int id)
        {
            var chat = _unitOfWork.chatRepository.FindByCondition(c => c.PatientId == id && c.DoctorId == null).FirstOrDefault();
            if (chat != null)
            {
                var messages = _unitOfWork.messageRepository.FindByCondition(m => m.ChatId == chat.Id);
                return Ok(messages);
            }
            else
            {
                return null;
            }
        }

        [Route("~/Patient/edit")]
        [HttpPost]

        public async Task<IActionResult> EditPatient(PatientProfile patientProfile)
        {
            var user = await _userManager.FindByIdAsync(patientProfile.ApplicationUserId);
            if (user != null)
            {
                if (patientProfile.PhoneNumber != user.PhoneNumber)
                {
                    var token = await _userManager.GenerateChangePhoneNumberTokenAsync(user, patientProfile.PhoneNumber);
                    var result = await _userManager.ChangePhoneNumberAsync(user, patientProfile.PhoneNumber, token);
                    if (!result.Succeeded)
                    {
                        return BadRequest(result.Errors.FirstOrDefault());
                    }
                }
                /*if (patientProfile.Email != user.UserName)
                {
                    var result = await _userManager.SetUserNameAsync(user, patientProfile.UserName);
                    if (!result.Succeeded)
                    {
                        return BadRequest(result.Errors.FirstOrDefault());
                    }

                }*/
                if (patientProfile.Email != user.Email)
                {
                    var token = await _userManager.GenerateChangeEmailTokenAsync(user, patientProfile.Email);
                    var result = await _userManager.ChangeEmailAsync(user, patientProfile.Email, token);
                    if (!result.Succeeded)
                    {
                        return BadRequest(result.Errors.FirstOrDefault());
                    }

                }
                if (ModelState.IsValid)
                {
                    var newPatient = new Patient
                    {
                        Id = patientProfile.Id,
                        BirthDate = patientProfile.BirthDate,
                        ApplicationUserId = patientProfile.ApplicationUserId,
                        FirstName =patientProfile.FirstName,
                        LastName = patientProfile.LastName
                    };

                    _unitOfWork.patientRepository.Update(newPatient);
                    _unitOfWork.SaveChanges();

                    return Ok();
                }
            }
            return BadRequest(new { error = ModelState.Values.SelectMany(v => v.Errors).FirstOrDefault()?.ErrorMessage });

        }

        [Route("~/Booking/Edit")]
        [HttpPost]
        public IActionResult EditBooking(Booking booking)
        {
            bool canBooking = true;

            if (booking.PatientId == null)
            {
                if ((booking.BookingDate - DateTime.Now).TotalHours < 24)
                {
                    ModelState.AddModelError(string.Empty, "Unable to delete booking: The remaining time is less than a day.");
                }
                else
                {
                    _unitOfWork.bookingRepository.Update(booking);
                    _unitOfWork.SaveChanges();
                    return Ok();
                }
            }
            else
            {
                var patientBooking = _unitOfWork.bookingRepository.FindByCondition(b => b.PatientId == booking.PatientId && b.BookingDate.Date >= DateTime.Now.Date);
                foreach (Booking b in patientBooking)
                {
                    if (Math.Abs((booking.BookingDate - b.BookingDate).TotalHours) < 1)
                    {
                        ModelState.AddModelError(string.Empty, "Booking duration must be at least 1 hour apart to allow sufficient time between bookings.");
                        canBooking = false;
                        break;
                    }
                }
                if (canBooking)
                {

                    //_unitOfWork.Dispose();
                    _unitOfWork.bookingRepository.Update(booking);
                    _unitOfWork.SaveChanges();
                    return Ok();
                }


            }
            return BadRequest(new { error = ModelState.Values.SelectMany(v => v.Errors).FirstOrDefault()?.ErrorMessage });

        }
        [Route("~/Booking/GetPatient/{id}")]
        [HttpGet]
        public IActionResult GetBookingFroPatient(int id)
        {
            var bookings = _unitOfWork.bookingRepository.FindByCondition(b => b.DoctorId == id && b.PatientId == null);
            return Ok(bookings);
        }



        //////////////////////////////////////////

        [HttpPost]
        [Route("SendQuestion")]
        public async Task<IActionResult> SendQuestion(String id, String question)
        {
            if (ModelState.IsValid)
            {
                Chat chat = new Chat
                {
                    PatientId = int.Parse(id)
                };
                _unitOfWork.chatRepository.Add(chat);
                _unitOfWork.SaveChanges();
                var Id = chat.Id;
                Message message = new Message
                {
                    MessageContent = question,
                    Date = DateTime.Now,
                    ChatId = Id,
                    ByPatient = true,
                    IsEdited = false,
                    IsRead = false
                };
                _unitOfWork.messageRepository.Add(message);
                _unitOfWork.SaveChanges();

                await _hubContext.Clients.All.SendAsync("sendQuestion", message);
                return Ok();
            }
            return BadRequest();
        }


        [HttpGet]
        [Route("GetMessages/{id}")]
        public async Task<IActionResult> GetMessages(String id)
        {
            var Id = int.Parse(id);
            MessageViewModel messageViewModel;
            List<MessageViewModel> list = new List<MessageViewModel>();
            var messages = _unitOfWork.messageRepository.FindByCondition(message => message.ChatId == Id);
            if (messages != null)
            {
                foreach (var item in messages)
                {
                    messageViewModel = new MessageViewModel
                    {
                        Id = item.Id,
                        MessageContent = item.MessageContent,
                        ByPatient = item.ByPatient,
                        ChatId = item.ChatId,
                        Date = item.Date
                    };
                    list.Add(messageViewModel);
                }
                await _hubContext.Clients.All.SendAsync("getMessages", list);
                return Ok(messages);
            }
            return NotFound();
        }
        [HttpGet]
        [Route("GetChats/{Id}")]
        public async Task<IActionResult> GetChats(String Id)
        {
            int patientId = int.Parse(Id);
            var chats = _unitOfWork.chatRepository.GetChatWithDoctorAndMessages(patientId);
            chats = chats.Where(c => c.DoctorId != null);
            if (chats == null)
            {
                return NotFound("No chats found for the patient.");
            }

            List<ChatInfo> userChats = new List<ChatInfo>();
            foreach (var chat in chats)
            {
                //changes
                var lastMessage = chat?.Messages?.OrderByDescending(msg => msg.Id)?.First();

                if (lastMessage != null)
                {
                    var numberOfUnreadMessages = _unitOfWork.messageRepository.FindByCondition(msg => msg.ChatId == chat.Id && msg.ByPatient == false && msg.IsRead == false).Count();

                    ChatInfo chatForUser = new ChatInfo();

                    // Check for null references before accessing Doctor properties
                    if (chat.Doctor != null)
                    {
                        chatForUser.ChatId = chat.Id;
                        chatForUser.ChatUserId = chat.Doctor.Id;
                        chatForUser.UserFirstName = chat.Doctor.FirstName;
                        chatForUser.UserLastName = chat.Doctor.LastName;
                        chatForUser.UserGender = chat.Doctor.Gender;
                        chatForUser.UserImage = chat.Doctor.Image;

                    }

                    chatForUser.UserLastMessage = lastMessage.MessageContent;
                    chatForUser.LastMessageDate = lastMessage.Date;
                    chatForUser.NumberOfUnreadMessage = numberOfUnreadMessages;

                    userChats.Add(chatForUser);
                }
            }

            await _hubContext.Clients.All.SendAsync("getChats", userChats);
            return Ok(userChats);
        }


        [HttpPost]
        [Route("SendMessage")]
        public async Task<IActionResult> SendMessage(String id, String content)
        {
            var chat = _unitOfWork.chatRepository.GetById(int.Parse(id));
            if (chat != null)
            {
                var message = new Message
                {
                    ChatId = int.Parse(id),
                    MessageContent = content,
                    Date = DateTime.Now,
                    ByPatient = true,
                    IsEdited = false,
                    IsRead = false
                };
                _unitOfWork.messageRepository.Add(message);
                _unitOfWork.SaveChanges();

                var newMessage = _unitOfWork.messageRepository.GetById(message.Id);
                if (newMessage != null)
                {
                    MessageViewModel messageViewModel = new MessageViewModel
                    {
                        Id = newMessage.Id,
                        ChatId = newMessage.ChatId,
                        MessageContent = newMessage.MessageContent,
                        Date = newMessage.Date,
                        ByPatient = newMessage.ByPatient,
                        IsEdited = (bool)newMessage.IsEdited,
                        IsRead = (bool)newMessage.IsRead
                    };
                    await _hubContext.Clients.All.SendAsync("addMessage", messageViewModel);
                    await _hubContext.Clients.All.SendAsync("addedMessage", messageViewModel);
                    //var messages = _unitOfWork.messageRepository.FindByCondition(msg => msg.ChatId == chat.Id);
                    //if(messages.Count()==1)
                    //{
                    //    ChatInfo chatForUser = new ChatInfo {
                    //    ChatId = chat.Id,
                    //    ChatUserId = chat.Doctor.Id,
                    //    UserFirstName = chat.Doctor.FirstName,
                    //    UserLastName = chat.Doctor.LastName,
                    //    UserGender = chat.Doctor.Gender,
                    //    UserImage = chat.Doctor.Image,
                    //    UserLastMessage = newMessage.MessageContent,
                    //    LastMessageDate = newMessage.Date,
                    //    NumberOfUnreadMessage = _unitOfWork.messageRepository.FindByCondition(msg => msg.ChatId == chat.Id && msg.ByPatient == false && msg.IsRead == false).Count()
                    //};
                    //    List<ChatInfo> userChats = new List<ChatInfo>();
                    //    userChats.Add(chatForUser);
                    //    await _hubContext.Clients.All.SendAsync("getChats", userChats);
                    //}
                    return Ok(messageViewModel);
                }
                return NotFound();
            }
            return BadRequest();
        }

        [HttpGet]
        [Route("DeleteMessage/{id}")]
        public async Task<IActionResult> DeleteMessage(String id)
        {
            var message = _unitOfWork.messageRepository.FindByCondition(m => m.Id == int.Parse(id) && m.ByPatient == true).First();
            if (message != null)
            {
                MessageViewModel deletedMessage = new MessageViewModel
                {
                    Id = message.Id,
                    ChatId = message.ChatId,
                    MessageContent = message.MessageContent,
                    Date = message.Date,
                    ByPatient = message.ByPatient
                };
                var chatId = message.ChatId;
                _unitOfWork.messageRepository.Delete(message);
                _unitOfWork.SaveChanges();
                //changes
                var lastMessage = _unitOfWork.messageRepository.FindByCondition(msg => msg.ChatId == chatId).OrderByDescending(msg => msg.Id).First();
                if (lastMessage != null)
                {
                    MessageViewModel messageViewModel = new MessageViewModel
                    {
                        Id = lastMessage.Id,
                        ChatId = lastMessage.ChatId,
                        MessageContent = lastMessage.MessageContent,
                        Date = lastMessage.Date,
                        ByPatient = lastMessage.ByPatient
                    };
                    await _hubContext.Clients.All.SendAsync("deleteMessage", messageViewModel);
                    await _hubContext.Clients.All.SendAsync("deleteMessageHub", deletedMessage);
                    return Ok();
                }
            }
            return NotFound();
        }


        [HttpPost]
        [Route("UpdateMessage")]
        public async Task<IActionResult> UpdateMessage(String id, String content)
        {
            var message = _unitOfWork.messageRepository.FindByCondition(m => m.Id == int.Parse(id) && m.ByPatient == true).First();
            if (message != null)
            {
                var chatId = message.ChatId;
                message.MessageContent = content;
                message.Date = DateTime.Now;
                message.IsEdited = true;
                _unitOfWork.messageRepository.Update(message);
                _unitOfWork.SaveChanges();

                var lastMessage = _unitOfWork.messageRepository.FindByCondition(msg => msg.ChatId == chatId).OrderByDescending(msg => msg.Date).First();
                if (lastMessage != null)
                {
                    MessageViewModel messageViewModel = new MessageViewModel
                    {
                        Id = lastMessage.Id,
                        ChatId = lastMessage.ChatId,
                        MessageContent = lastMessage.MessageContent,
                        Date = lastMessage.Date,
                        ByPatient = lastMessage.ByPatient,
                        IsEdited = (bool)lastMessage.IsEdited
                    };
                    await _hubContext.Clients.All.SendAsync("updateMessage", messageViewModel);
                    var lastChatMessage = _unitOfWork.messageRepository.FindByCondition(msg => msg.ChatId == chatId).OrderByDescending(msg => msg.Id).First();
                    MessageViewModel chatMessageViewModel = new MessageViewModel
                    {
                        Id = lastChatMessage.Id,
                        ChatId = lastChatMessage.ChatId,
                        MessageContent = lastChatMessage.MessageContent,
                        Date = lastChatMessage.Date,
                        ByPatient = lastChatMessage.ByPatient
                    };
                    await _hubContext.Clients.All.SendAsync("getChatMessages", chatMessageViewModel);
                    return Ok();
                }
            }
            return NotFound();
        }

        [HttpGet]
        [Route("UpdateStatus")]
        public async Task<IActionResult> UpdateStatus(String id)
        {

            var message = _unitOfWork.messageRepository.FindByCondition(msg => msg.Id == int.Parse(id) && msg.ByPatient == false && msg.IsRead == false).First();
            if (message != null)
            {
                message.IsRead = true;
                _unitOfWork.SaveChanges();
                MessageViewModel messageViewModel = new MessageViewModel
                {
                    Id = message.Id,
                    ChatId = message.ChatId,
                    MessageContent = message.MessageContent,
                    Date = message.Date,
                    ByPatient = message.ByPatient,
                    IsEdited = (bool)message.IsEdited,
                    IsRead = true
                };

                await _hubContext.Clients.All.SendAsync("updateStatus", message);
                return Ok();
            }
            return NotFound();
        }

        [HttpGet]
        [Route("UpdateMessagesStatus")]
        public async Task<IActionResult> UpdateMessagesStatus(String id)
        {
            var messages = _unitOfWork.messageRepository.FindByCondition(msg => msg.ChatId == int.Parse(id) && msg.ByPatient == true && msg.IsRead == false).ToList();
            if (messages != null)
            {
                List<MessageViewModel> list = new List<MessageViewModel>();
                foreach (var item in messages)
                {
                    item.IsRead = true;
                }
                _unitOfWork.SaveChanges();
                foreach (var item in messages)
                {
                    MessageViewModel messageViewModel = new MessageViewModel
                    {
                        Id = item.Id,
                        ChatId = item.ChatId,
                        MessageContent = item.MessageContent,
                        Date = item.Date,
                        ByPatient = item.ByPatient,
                        IsEdited = (bool)item.IsEdited,
                        IsRead = true
                    };
                    list.Add(messageViewModel);
                }

                await _hubContext.Clients.All.SendAsync("update", list);
                return Ok(list);
            }
            return NotFound();
        }
    }
}
