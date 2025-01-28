using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace activity.Models
{
    public class Activity
    {
        [BsonId]
        public ObjectId Id { get; set; } = ObjectId.GenerateNewId();
        public int ContentId { get; set; }
        public DateTime AccessedOn { get; set; } = DateTime.UtcNow;
    }
}