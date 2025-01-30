using MongoDB.Driver;
using activity.Models;
using content.Models;
using MongoDB.Bson;
using content.Services;

namespace activity.Services
{
    /// <summary>
    /// Service class to handle operations related to Activity.
    /// </summary>
    public class ActivityService : IActivityServices
    {
        private readonly IMongoCollection<Activity> _activityCollection;
        private readonly IMongoCollection<Content> _contentCollection;

        /// <summary>
        /// Initializes a new instance of the <see cref="ActivityService"/> class.
        /// </summary>
        /// <param name="mongoConnect">The database connection object.</param>
        public ActivityService(MongoConnect mongoConnect)
        {
            _activityCollection = mongoConnect.Activities;
            _contentCollection = mongoConnect.Contents;
        }

        /// <summary>
        /// Adds an activity related to a specific content by its content ID.
        /// </summary>
        /// <param name="contentId">The content's ID.</param>
        /// <returns>
        /// A task that represents the asynchronous operation.
        /// The task result contains the newly added <see cref="Activity"/>.
        /// </returns>
        public async Task<Activity> AddActivity(int contentId)
        {
            var content = await _contentCollection
                .Find(c => c.Id == contentId)
                .FirstOrDefaultAsync();

            var newActivity = new Activity
            {
                ContentId = contentId,
                ContentTitle = content?.Title,
            };

            await _activityCollection.InsertOneAsync(newActivity);
            return newActivity;
        }

        /// <summary>
        /// Retrieves a list of activity logs associated with a content ID.
        /// </summary>
        /// <param name="contentId">The content's ID.</param>
        /// <returns>
        /// A task that represents the asynchronous operation.
        /// The task result contains a list of <see cref="Activity"/> objects.
        /// </returns>
        public async Task<List<Activity>> GetActivitiesByContentId(int contentId)
        {
            var activities = await _activityCollection
                .Find(a => a.ContentId == contentId)
                .SortByDescending(a => a.AccessedOn)
                .ToListAsync();

            return activities;
        }
    }
}
