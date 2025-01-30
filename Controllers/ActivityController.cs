using Microsoft.AspNetCore.Mvc;
using activity.Models;
using content.Services;
using Microsoft.AspNetCore.Authorization;

namespace activity.Controllers
{
    /// <summary>
    /// Controller responsible for managing activities related to content.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ActivityController : ControllerBase
    {
        private readonly IActivityServices _activityService;

        /// <summary>
        /// Initializes a new instance of the <see cref="ActivityController"/> class.
        /// </summary>
        /// <param name="activityService">The service used to manage activities.</param>
        public ActivityController(IActivityServices activityService)
        {
            _activityService = activityService;
        }


        /// <summary>
        /// Retrieves the activity associated with the specified content ID.
        /// </summary>
        /// <param name="contentId">The unique identifier of the content.</param>
        /// <returns>The activity associated with the given content ID, or NotFound if it doesn't exist.</returns>
        [HttpGet("{contentId}")]
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
