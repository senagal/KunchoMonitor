using MongoDB.Driver;
using activity.Models;
using content.Models;
using MongoDB.Bson;
using content.Services;

namespace activity.Services
{
    public class ActivityService : IActivityServices
    {
        private readonly IMongoCollection<Activity> _activityCollection;
        private readonly IMongoCollection<Content> _contentCollection;

        public ActivityService(MongoConnect mongoConnect)
        {
            _activityCollection = mongoConnect.Activities;
            _contentCollection = mongoConnect.Contents;
        }

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

        public async Task<Activity> GetActivityByContentId(int contentId)
        {
            var activity = await _activityCollection
                .Find(a => a.ContentId == contentId)
                .SortByDescending(a => a.AccessedOn) 
                .FirstOrDefaultAsync();

            return activity;
        }

        }
    }