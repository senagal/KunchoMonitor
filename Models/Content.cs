using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System.ComponentModel.DataAnnotations;

namespace content.Models
{
    public class Content
    {
        [BsonId]
        [BsonRepresentation(BsonType.Int32)]
        [Required(ErrorMessage = "ID is required.")]
        [Range(1, int.MaxValue, ErrorMessage = "ID must be a positive integer.")]
        public int? Id { get; set; }

        [Required(ErrorMessage = "Title is required.")]
        [StringLength(100, ErrorMessage = "Title must be a string .")]
        public string? Title { get; set; }

        [Required(ErrorMessage = "Body is required.")]
        [StringLength(100, ErrorMessage = "Title must be a string .")]
        public string? Body { get; set; }
    }
}