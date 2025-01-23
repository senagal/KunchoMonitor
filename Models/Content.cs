using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace content.Models
{
    public class Content
    {
        [BsonId]
        [BsonRepresentation(BsonType.Int32)]
        public int? Id { get; set; }
        public string? Title { get; set; }
        public string? Body { get; set; }
    }
}
