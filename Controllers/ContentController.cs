//before update

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
            return CreatedAtAction(nameof(GetContentById), new { id = content.Id }, content);
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

        [HttpGet("search")]
        public async Task<ActionResult<List<Content>>> SearchAndFilterContent(
     [FromQuery] string? query,    // This will be the query parameter to search in both title and body
     [FromQuery] int? id,          // Optionally filter by ID
     [FromQuery] int page = 1,     // Pagination: page number
     [FromQuery] int pageSize = 10) // Pagination: number of items per page
        {
            // Perform the search and filter based on the query (title or body) and other params
            var contents = await _contentService.SearchAndFilterWithPagination(query, id, page, pageSize);

            if (contents == null || contents.Count == 0)
            {
                return NotFound("No matching content found.");
            }

            return Ok(contents);
        }

    }
}
