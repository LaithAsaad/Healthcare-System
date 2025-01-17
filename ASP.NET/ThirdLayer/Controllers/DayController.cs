using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SecondLayer.UnitOfWork;

namespace ThirdLayer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DayController : BaseController
    {
        public DayController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        [HttpGet]
        public IActionResult getDay()
        {
            var days = _unitOfWork.dayRepository.GetAll().ToArray();
            return Ok(days);
        }
    }
}

