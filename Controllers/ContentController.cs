using Microsoft.AspNetCore.Mvc;
using content.Models;
using content.Services;
using activity.Services;

namespace content.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ContentController : ControllerBase
    {
        private readonly IContentServices _contentService;
        private readonly IActivityServices _activityService;

        public ContentController(IContentServices contentService, IActivityServices activityService)
        {
            _contentService = contentService;
            _activityService = activityService;
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
        return NotFound($"Content with ID {id} not found.");
    }

    try
    {
        var newActivity = await _activityService.AddActivity(id);
        Console.WriteLine($"Activity logged for Content ID: {id} at {newActivity.AccessedOn}");
    }
    catch (Exception ex)
    {
        Console.Error.WriteLine($"Failed to log activity: {ex.Message}");
    }

    return Ok(content);
        }
    }
}