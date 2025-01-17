using FirstLayer.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SecondLayer.UnitOfWork;

namespace ThirdLayer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SpecializationController : BaseController
    {
        public SpecializationController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
        //[Authorize]
        [HttpGet]
        public async Task<IActionResult> GetSpecialization()
        {
            var spec = await _unitOfWork.specializationRepository.GetAllAsync();
            return Ok(spec);
        }
        [Route("~/Specialization/Add")]
        [HttpPost]
        public IActionResult AddSpecialization([FromBody] Specialization specialization)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                _unitOfWork.specializationRepository.Add(specialization);
                _unitOfWork.SaveChanges();

                return Ok();
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
        [Route("~/Specialization/Get/{id}")]
        [HttpGet]
        public IActionResult GetSpecializationById(int id)
        {
            var spec = _unitOfWork.specializationRepository.GetById(id);
            return Ok(spec);
        }
    }
}
