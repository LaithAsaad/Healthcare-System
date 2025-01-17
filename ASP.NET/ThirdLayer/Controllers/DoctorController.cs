using FirstLayer.Models;
//using Microsoft.AspNet.Identity;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.SignalR.Protocol;
using SecondLayer.UnitOfWork;
using System.Numerics;
using System.Reflection;
using ThirdLayer.Hubs;
using ThirdLayer.Models;

namespace ThirdLayer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DoctorController : BaseController
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly IHubContext<DoctorHub> _hubContext;
        private readonly IHubContext<MessageHub> _hubMessage;
        public DoctorController(IUnitOfWork unitOfWork, UserManager<ApplicationUser> userManager, SignInManager<ApplicationUser> signInManager, IHubContext<MessageHub> hubMessage, IHubContext<DoctorHub> hubContext) : base(unitOfWork)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _hubMessage = hubMessage;
            _hubContext = hubContext;
        }
        [Route("~/reg/doctor")]
        [HttpPost]
        public async Task<IActionResult> AddDoctorAsync(DoctorForRegistration doctor)
        {
            bool IsPhoneAlreadyRegistered = _userManager.Users.Any(item => item.PhoneNumber == doctor.PhoneNumber);
            if (ModelState.IsValid)
            {
                if (!IsPhoneAlreadyRegistered)
                {
                    doctor.UserName = doctor.FirstName + doctor.LastName;
                    var newUser = new ApplicationUser
                    {
                        Id = Guid.NewGuid().ToString(),
                        Email = doctor.Email,
                        UserName = doctor.UserName,
                        EmailConfirmed = true,
                        PhoneNumber = doctor.PhoneNumber,
                        NormalizedUserName = doctor.UserName.ToUpper(),
                        NormalizedEmail = doctor.Email.ToUpper(),
                    };
                    var result = await _userManager.CreateAsync(newUser, doctor.Password);

                    if (result.Succeeded)
                    {
                        var newDoctor = new Doctor
                        {
                            Gender = doctor.Gender,
                            FirstName = doctor.FirstName,
                            LastName = doctor.LastName,
                            SpecializationId = doctor.SpecializationId,
                            Image = null,
                            ApplicationUserId = newUser.Id,
                            BirthDate = doctor.BirthDate
                        };
                        _unitOfWork.doctorRepository.Add(newDoctor);
                        _unitOfWork.SaveChanges();

                        var doctorAddress = new Address
                        {
                            Id = newDoctor.Id,
                            City = "",
                            Governorate = "",
                            Street = ""
                        };
                        _unitOfWork.addressRepository.Add(doctorAddress);
                        _unitOfWork.SaveChanges();
                        return Ok(new { doctorId = newDoctor.Id });
                    }
                    else
                    {
                        return BadRequest(result.Errors.FirstOrDefault());
                    }
                }
                else ModelState.AddModelError(string.Empty, "This number is already taken");
            }
            return BadRequest(new { error = ModelState.Values.SelectMany(v => v.Errors).FirstOrDefault()?.ErrorMessage });
        }

        [Route("~/login/doctor")]
        [HttpPost]
        public async Task<IActionResult> Login(LogIn model)
        {
            if (ModelState.IsValid)
            {
                var user = await _userManager.FindByEmailAsync(model.Email);
                if (user != null)
                {
                    var isDoctor = _unitOfWork.doctorRepository.FindByCondition(d => d.ApplicationUserId.Equals(user.Id)).Any();
                    if (isDoctor)
                    {
                        var result = await _signInManager.PasswordSignInAsync(user, model.Password,
                            true, false);
                        if (result.Succeeded)
                        {
                            Doctor doctor = _unitOfWork.doctorRepository.FindByCondition(d => d.ApplicationUserId == user.Id).First();
                            return Ok(new { doctorId = doctor.Id });
                        }
                        else
                        {
                            ModelState.AddModelError(string.Empty, "Invalid login attempt, incorrect password");
                        }
                    }
                    else
                    {
                        ModelState.AddModelError(string.Empty, "Email not a doctor email");
                    }
                }
                else ModelState.AddModelError(string.Empty, "Invalid login attempt, this email is not registered");
            }

            return BadRequest(new { error = ModelState.Values.SelectMany(v => v.Errors).FirstOrDefault()?.ErrorMessage });
        }

        [HttpGet("{id}")]
        public IActionResult GetDoctor(int id)
        {
            var doctor = _unitOfWork.doctorRepository.GetDoctor(id);

            if (doctor == null)
            {
                return NotFound();
            }

            return Ok(doctor);
        }
        [Route("~/Doctor/GetAllDoctorInfo")]
        [HttpGet]
        public IActionResult GetDoctors()
        {
            var doctors = _unitOfWork.doctorRepository.GetDoctors();

            if (doctors == null)
            {
                return NotFound();
            }

            return Ok(doctors);
        }
        [Route("~/Doctor/GetDoctorWithAddress/{id}")]
        [HttpGet]
        public IActionResult GetDoctorsWithAddress(int id)
        {
            var doctors = _unitOfWork.doctorRepository.GetDoctorsWithAddress(id).ToList();

            if (doctors == null)
            {
                return NotFound();
            }

            return Ok(doctors);
        }
        [Route("~/Doctor/GetDoctorWithBooking/{id}")]
        [HttpGet]
        public IActionResult GetDoctorsWithBooking(int id)
        {
            var doctors = _unitOfWork.bookingRepository.GetDoctorsWithBooking(id).ToList();

            if (doctors == null)
            {
                return NotFound();
            }

            return Ok(doctors);
        }
        [Route("~/Doctor/edit")]
        [HttpPost]

        public async Task<IActionResult> EditDoctor(DoctorProfile doctorProfile)
        {
            var user = await _userManager.FindByIdAsync(doctorProfile.ApplicationUserId);
            if (user != null)
            {
                if (doctorProfile.PhoneNumber != user.PhoneNumber)
                {
                    var token = await _userManager.GenerateChangePhoneNumberTokenAsync(user, doctorProfile.PhoneNumber);
                    var result = await _userManager.ChangePhoneNumberAsync(user, doctorProfile.PhoneNumber, token);
                    if (!result.Succeeded)
                    {
                        return BadRequest(result.Errors.FirstOrDefault());
                    }
                }
                if (doctorProfile.Email != user.Email)
                {
                    var token = await _userManager.GenerateChangeEmailTokenAsync(user, doctorProfile.Email);
                    var result = await _userManager.ChangeEmailAsync(user, doctorProfile.Email, token);
                    if (!result.Succeeded)
                    {
                        return BadRequest(result.Errors.FirstOrDefault());
                    }

                }
                if (ModelState.IsValid)
                {
                    var newDoctor = new Doctor
                    {
                        Id = doctorProfile.Id,
                        Gender = doctorProfile.Gender,
                        FirstName = doctorProfile.FirstName,
                        LastName = doctorProfile.LastName,
                        SpecializationId = doctorProfile.SpecializationId,
                        Image = doctorProfile.Image,
                        ApplicationUserId = doctorProfile.ApplicationUserId,
                        BirthDate = doctorProfile.BirthDate,
                    };

                    _unitOfWork.doctorRepository.Update(newDoctor);
                    _unitOfWork.SaveChanges();

                    return Ok();
                }
            }
            return BadRequest(new { error = ModelState.Values.SelectMany(v => v.Errors).FirstOrDefault()?.ErrorMessage });

        }

        [Route("~/Doctor/sendMessageToDoctor/{patientId}/{doctorId}")]
        [HttpGet]
        public IActionResult replyToConsultations(int patientId, int doctorId)
        {
            var chat = _unitOfWork.chatRepository.FindByCondition(c => c.PatientId == patientId && c.DoctorId == doctorId).FirstOrDefault();
            return Ok(chat);
        }

        [Route("~/Doctor/createChat/{patientId}/{doctorId}/{message}")]
        [HttpPost]
        public async Task<IActionResult> CreateChat(int patientId, int doctorId, String message)
        {
            Chat chat = new Chat { PatientId = patientId, DoctorId = doctorId };
            _unitOfWork.chatRepository.Add(chat);
            _unitOfWork.SaveChanges();
            if (chat != null)
            {
                PatientController patientController =  new PatientController(_unitOfWork, _userManager, _signInManager, _hubMessage);
                var mesView = patientController.SendMessage(chat.Id.ToString(), message);


                var patient = _unitOfWork.patientRepository.GetById(patientId);
                if (patient != null)
                {

                    ChatInfo chatInfo = new ChatInfo
                    {
                        ChatId = chat.Id,
                        ChatUserId = patientId,
                        LastMessageDate = DateTime.Now,
                        UserFirstName = patient.FirstName,
                        UserLastName = patient.LastName,
                        UserLastMessage = message,
                        NumberOfUnreadMessage = 0
                    };
                    await _hubMessage.Clients.All.SendAsync("getCreatedChat", chatInfo, doctorId);
                }
            }
            return Ok(chat);
        }

        [Route("~/Doctor/getAvailable/{id}")]
        [HttpGet]
        public async Task<IActionResult> GetAllAvailableTime(int id)
        {
            var list = _unitOfWork.availableTimeRepository.FindByCondition(a => a.DoctorId == id);
            return Ok(list);
        }

        // error you should pass available time model it's just test
        [Route("~/Doctor/addAvailable")]
        [HttpPost]
        public IActionResult AddAvailableTime(AvailableTime availableTime)
        {
            if (availableTime.Id == 0)
            {
                _unitOfWork.availableTimeRepository.Add(availableTime);
            }
            else
            {
                _unitOfWork.availableTimeRepository.Update(availableTime);
            }
            _unitOfWork.SaveChanges();
            return Ok();
        }

        [Route("~/Doctor/deleteAvailable/{id}")]
        [HttpPost]
        public IActionResult DeleteAvailableTime(int id)
        {
            var availableTime = _unitOfWork.availableTimeRepository.GetById(id);
            if (availableTime == null)
            {
                return NotFound("Available time not found.");
            }
            else
            {
                _unitOfWork.availableTimeRepository.Delete(availableTime);
                _unitOfWork.SaveChanges();
                return Ok();
            }
        }

        [Route("~/Booking/GetDcotor/{id}")]
        [HttpGet]
        public IActionResult GetBookingFroDoctor(int id)
        {
            var bookings = _unitOfWork.bookingRepository.FindByCondition(b => b.DoctorId == id);
            return Ok(bookings);
        }
        [Route("~/Booking/Add")]
        [HttpPost]
        public IActionResult AddBooking(Booking booking)
        {
            _unitOfWork.bookingRepository.Add(booking);
            _unitOfWork.SaveChanges();
            return Ok(booking);

        }

        [Route("~/Booking/Delete")]
        [HttpPost]
        public IActionResult DeleteBooking(Booking booking)
        {
            if (booking != null)
            {
                _unitOfWork.bookingRepository.Delete(booking);
                _unitOfWork.SaveChanges();
                return Ok();
            }

            else
            {
                return BadRequest();
            }

        }
        [Route("~/Doctor/DeleteMessageAfterAnswer/{id}")]
        [HttpPost]
        public IActionResult DeleteMessageAfterAnswer(int id)
        {
            var message = _unitOfWork.messageRepository.GetById(id);
            if(message != null)
            {
                _unitOfWork.messageRepository.Delete(message);
                _unitOfWork.SaveChanges();
                return Ok();
            }
            else
            {
                return NotFound();
            }
        }

        ///////////////////////////////////////////



        [HttpPost]
        [Route("SendAnswer")]
        public async Task<IActionResult> SendQuestion(String doctorId, String chatId, String answer)
        {
            if (ModelState.IsValid)
            {
                Chat chat = _unitOfWork.chatRepository.GetById(int.Parse(chatId));
                chat.DoctorId = int.Parse(doctorId);
                _unitOfWork.chatRepository.Update(chat);
                _unitOfWork.SaveChanges();
                var Id = chat.Id;
                Message message = new Message
                {
                    MessageContent = answer,
                    Date = DateTime.Now,
                    ChatId = Id,
                    ByPatient = false
                };
                _unitOfWork.messageRepository.Add(message);
                _unitOfWork.SaveChanges();

                await _hubContext.Clients.All.SendAsync("sendAnswer", chat);
                return Ok();
            }
            return BadRequest();
        }


        [HttpGet]
        [Route("GetQuestions")]
        public async Task<IActionResult> GetQuestions()
        {

            var messages = _unitOfWork.messageRepository.GetAll().ToList();
            if (messages != null)
            {
                List<ChatForUser> wantedMessages = new List<ChatForUser>();

                Chat chat;
                Patient patient;
                foreach (var message in messages)
                {
                    chat = _unitOfWork.chatRepository.GetById(message.ChatId);

                    if (chat.DoctorId == null)
                    {

                        patient = _unitOfWork.patientRepository.GetById(chat.PatientId);
                        var instance = new ChatForUser
                        {
                            PatientId = patient.Id,
                            UserFirstName = patient.FirstName,
                            UserLastName = patient.LastName,
                            UserLastMessage = message.MessageContent,
                            MessageId = message.Id,
                            UserImage = "unknown.png",
                            UserGender = true
                        };
                        wantedMessages.Add(instance);
                    }
                }
                //wantedMessages.ToList();
                //await _hubContext.Clients.All.SendAsync("getQuestions", wantedMessages);
                return Ok(wantedMessages);
            }
            return NotFound();
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
                    ByPatient = false,
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
                    await _hubMessage.Clients.All.SendAsync("addMessage", messageViewModel);
                    await _hubMessage.Clients.All.SendAsync("addedMessage", messageViewModel);
                    return Ok(newMessage);
                }
                return NotFound();
            }
            return BadRequest();
        }


        [HttpGet]
        [Route("GetChats/{Id}")]
        public async Task<IActionResult> GetChats(String Id)
        {
            int doctortId = int.Parse(Id);
            var chats = _unitOfWork.chatRepository.GetChatWithPatientAndMessages(doctortId);
            //chats = chats.Where(c => c.DoctorId != null);
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
                    var numberOfUnreadMessages = _unitOfWork.messageRepository.FindByCondition(msg => msg.ChatId == chat.Id && msg.ByPatient == true && msg.IsRead == false).Count();

                    ChatInfo chatForUser = new ChatInfo();

                    // Check for null references before accessing Doctor properties

                    chatForUser.ChatId = chat.Id;
                    chatForUser.ChatUserId = chat.PatientId;
                    chatForUser.UserFirstName = chat.Patient.FirstName;
                    chatForUser.UserLastName = chat.Patient.LastName;
                    chatForUser.UserGender = false;
                    chatForUser.UserImage = "unknown.png";



                    chatForUser.UserLastMessage = lastMessage.MessageContent;
                    chatForUser.LastMessageDate = lastMessage.Date;
                    chatForUser.NumberOfUnreadMessage = numberOfUnreadMessages;

                    userChats.Add(chatForUser);
                }
            }

            await _hubMessage.Clients.All.SendAsync("getChats", userChats);
            return Ok(userChats);
        }


        //nice
        [HttpGet]
        [Route("DeleteMessage/{id}")]
        public async Task<IActionResult> DeleteMessage(String id)
        {
            var message = _unitOfWork.messageRepository.FindByCondition(m => m.Id == int.Parse(id) && m.ByPatient == false).FirstOrDefault();
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

                var lastMessage = _unitOfWork.messageRepository.FindByCondition(msg => msg.ChatId == chatId).OrderByDescending(msg => msg.Date).First();
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
                    await _hubMessage.Clients.All.SendAsync("deleteMessage", messageViewModel);
                    await _hubMessage.Clients.All.SendAsync("deleteMessageHub", deletedMessage);
                    return Ok();
                }

            }
            return NotFound();
        }

        [HttpPost]
        [Route("UpdateMessage")]
        public async Task<IActionResult> UpdateMessage(String id, String content)
        {
            var message = _unitOfWork.messageRepository.FindByCondition(m => m.Id == int.Parse(id) && m.ByPatient == false).First();
            if (message != null)
            {
                var chatId = message.ChatId;
                message.MessageContent = content;
                message.Date = DateTime.Now;
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
                        ByPatient = lastMessage.ByPatient
                    };
                    await _hubMessage.Clients.All.SendAsync("updateMessage", messageViewModel);
                    return Ok();
                }
            }
            return NotFound();
        }

        [HttpGet]
        [Route("UpdateStatus")]
        public async Task<IActionResult> UpdateStatus(String id)
        {
            var message = _unitOfWork.messageRepository.FindByCondition(msg => msg.Id == int.Parse(id) && msg.ByPatient == true && msg.IsRead == false).First();
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


                await _hubMessage.Clients.All.SendAsync("updateStatus", message);
                return Ok();
            }
            return NotFound();
        }

        [HttpGet]
        [Route("UpdateMessagesStatus")]
        public async Task<IActionResult> UpdateMessagesStatus(String id)
        {
            var messages = _unitOfWork.messageRepository.FindByCondition(msg => msg.ChatId == int.Parse(id) && msg.ByPatient == false && msg.IsRead == false).ToList();
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
                await _hubMessage.Clients.All.SendAsync("update", list);
                return Ok(list);
            }
            return NotFound();
        }



    }
}
