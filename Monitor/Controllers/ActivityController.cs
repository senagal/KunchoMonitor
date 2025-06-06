using Microsoft.AspNetCore.Mvc;
using activity.Models;
using content.Services;
using Microsoft.AspNetCore.Authorization;

namespace activity.Controllers
{
    /// <summary>
    /// Provides API endpoints for managing activities associated with content.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ActivityController : ControllerBase
    {
        private readonly IActivityServices _activityService;

        /// <summary>
        /// Initializes a new instance of the <see cref="ActivityController"/> class with the specified activity service.
        /// </summary>
        /// <param name="activityService">The service used to manage and retrieve activities.</param>
        public ActivityController(IActivityServices activityService)
        {
            _activityService = activityService;
        }

        /// <summary>
        /// Retrieves the list of activities associated with the specified content ID.
        /// </summary>
        /// <param name="contentId">The unique identifier of the content.</param>
        /// <returns>
        /// An <see cref="ActionResult"/> containing a list of activities associated with the given content ID 
        /// if they exist; otherwise, a <see cref="NotFoundResult"/> indicating no activities were found.
        /// </returns>
        /// <response code="200">Returns the list of activities for the specified content ID.</response>
        /// <response code="404">Indicates no activities were found for the specified content ID.</response>
        [HttpGet("{contentId}")]
        public async Task<ActionResult<List<Activity>>> GetActivitiesByContentId(int contentId)
        {
            var activities = await _activityService.GetActivitiesByContentId(contentId);

            if (activities == null || activities.Count == 0)
            {
                return NotFound($"No activities found for Content ID {contentId}.");
            }

            return Ok(activities);
        }
    }
}
