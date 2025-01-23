using Microsoft.AspNetCore.Mvc;
using content.Models;
using content.Services;

namespace content.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ContentController : ControllerBase
    {
        private readonly IContentServices _contentService;

        public ContentController(IContentServices contentService)
        {
            _contentService = contentService;
        }

        [HttpPost]
        public async Task<ActionResult> AddContent(Content newContent)
        {
            if (newContent == null)
            {
                return BadRequest("You entered empty values. Try again.");
            }
            var content = await _contentService.AddContent(newContent);
            return CreatedAtAction(nameof(GetContentById), new { id = content.Id },content);

        }
        [HttpGet("{id}")]
        public async Task<ActionResult<Content>> GetContentById(int id)
        {
            var content = await _contentService.GetContentById(id);
            if (content == null)
            {
                return NotFound($"Content not found.");
            }
            return Ok(content);
        }
    }
}