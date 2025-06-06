using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace user.Models
{
    public class User
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public ObjectId Id { get; set; } = ObjectId.GenerateNewId();
        public string? Username { get; set; }
        public string? Password { get; set; }
        public string? Role { get; set; }
    }
}