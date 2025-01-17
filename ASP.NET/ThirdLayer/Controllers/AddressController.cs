using FirstLayer.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SecondLayer.UnitOfWork;

namespace ThirdLayer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AddressController : BaseController
    {
        public AddressController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> GetAddressById(int id)
        {
            Address address = await _unitOfWork.addressRepository.GetByIdAsync(id);

            if (address == null)
            {
                return NotFound();
            }

            return Ok(address);
        }
        [HttpPost]
        public IActionResult EditAddress(Address address) {

            _unitOfWork.addressRepository.Update(address);
            _unitOfWork.SaveChanges();
            return Ok();
        }
    }
}
