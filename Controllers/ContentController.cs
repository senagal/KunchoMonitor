using Microsoft.AspNetCore.Mvc;
using content.Models;
using content.Services;
using activity.Services;
using Microsoft.AspNetCore.Authorization;

namespace content.Controllers
{
    /// <summary>
    /// Controller responsible for managing content-related operations.
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ContentController : ControllerBase
    {
        private readonly IContentServices _contentService;
        private readonly IActivityServices _activityService;

        /// <summary>
        /// Initializes a new instance of the <see cref="ContentController"/> class.
        /// </summary>
        /// <param name="contentService">The service used to manage content.</param>
        /// <param name="activityService">The service used to log activities.</param>
        public ContentController(IContentServices contentService, IActivityServices activityService)
        {
            _contentService = contentService;
            _activityService = activityService;
        }

        /// <summary>
        /// Adds new content to the system.
        /// </summary>
        /// <param name="newContent">The content to add.</param>
        /// <returns>The newly created content.</returns>
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

        /// <summary>
        /// Retrieves the content with the specified ID.
        /// </summary>
        /// <param name="id">The unique identifier of the content.</param>
        /// <returns>The content with the given ID, or NotFound if it doesn't exist.</returns>
        [HttpGet("{id}")]
        public async Task<ActionResult<Content>> GetContentById(int id)
        {
            // Input validation
            if (id <= 0)
            {
                return BadRequest("Invalid ID. ID must be a positive integer.");
            }

            var content = await _contentService.GetContentById(id);

            if (content == null)
            {
                return NotFound($"Content with ID {id} not found.");
            }

            try
            {
                // Log activity when content is retrieved
                var newActivity = await _activityService.AddActivity(id);
            }
            catch (Exception ex)
            {
                var errorMessage = $"Failed to log activity for Content ID {id}: {ex.Message}";
                return StatusCode(500, new { message = errorMessage });
            }

            return Ok(content);
        }

        /// <summary>
        /// Deletes the content with the specified ID.
        /// </summary>
        /// <param name="id">The unique identifier of the content to delete.</param>
        /// <returns>No content response if deletion is successful, or NotFound if content doesn't exist.</returns>
        
        [HttpPut("{id}")]
        public async Task<ActionResult<Content>> UpdateContent(int id, Content updatedContent)
        {
            var content = await _contentService.UpdateContent(id, updatedContent);

            if (content == null)
            {
                return NotFound($"Content with ID {id} not found.");
            }

            return Ok(content);
        }
        
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteContent(int id)
        {
            var isDeleted = await _contentService.DeleteContent(id);

            if (!isDeleted)
            {
                return NotFound($"Content with ID {id} not found.");
            }

            return NoContent();
        }

        /// <summary>
        /// Searches and filters content based on specified query parameters with pagination support.
        /// </summary>
        /// <param name="query">The search query string.</param>
        /// <param name="id">The content ID filter (optional).</param>
        /// <param name="page">The page number for pagination (defaults to 1).</param>
        /// <param name="pageSize">The number of results per page (defaults to 10).</param>
        /// <returns>A list of content matching the search and filter criteria.</returns>
        [HttpGet("search")]
        public async Task<ActionResult<List<Content>>> SearchAndFilterContent(
            [FromQuery] string? query,
            [FromQuery] int? id,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 10)
        {
            var contents = await _contentService.SearchAndFilterWithPagination(query, id, page, pageSize);

            if (contents == null || contents.Count == 0)
            {
                return NotFound("No matching content found.");
            }

            return Ok(contents);
        }
    }
}
