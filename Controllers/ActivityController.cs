using Microsoft.AspNetCore.Mvc;
using activity.Models;
using content.Services;
using activity.Services;
using MongoDB.Bson;

namespace activity.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ActivityController : ControllerBase
    {
        private readonly IActivityServices _activityService;  
        public ActivityController(IActivityServices activityService)
        {
            _activityService = activityService;
        }

        [HttpPost("add")]
        public async Task<ActionResult<Activity>> AddActivity(int contentId)
        {
            var activity = await _activityService.AddActivity(contentId);
            return CreatedAtAction(nameof(GetActivity), new { contentId = contentId }, activity);
        }

        [HttpGet("byContentId/{contentId}")]
        public async Task<ActionResult<Activity>> GetActivity(int contentId)
        {
            var activity = await _activityService.GetActivityByContentId(contentId);

            if (activity == null)
            {
                return NotFound();
            }

            return Ok(activity);
        }
    }
}
