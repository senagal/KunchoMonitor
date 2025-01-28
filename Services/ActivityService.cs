using MongoDB.Driver;
using activity.Models;
using content.Services;

namespace activity.Services
{
    public class ActivityService : IActivityServices
    {
        private readonly IMongoCollection<Activity> _activityCollection;

        public ActivityService(IConfiguration config)
        {
            var client = new MongoClient(config["MongoDbSettings:ConnectionString"]);
            var database = client.GetDatabase(config["MongoDbSettings:DatabaseName"]);
            _activityCollection = database.GetCollection<Activity>(config["MongoDbSettings:CollectionName"]);
        }

        public async Task<Activity> AddActivity(int contentId){
                var newActivity = new Activity
                {
                    ContentId = contentId,
                    AccessedOn = DateTime.UtcNow
                };

                await _activityCollection.InsertOneAsync(newActivity);
                return newActivity;
                    }
    }
}