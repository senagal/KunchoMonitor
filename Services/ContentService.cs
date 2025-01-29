using System.Collections.Generic;
using System.Linq;
using MongoDB.Driver;
using content.Models;

namespace content.Services
{
    public class ContentService : IContentServices
    {
        private readonly IMongoCollection<Content> _contentCollection;

        public ContentService(IConfiguration config)
        {
            var client = new MongoClient(config["MongoDbSettings:ConnectionString"]);
            var database = client.GetDatabase(config["MongoDbSettings:DatabaseName"]);
            _contentCollection = database.GetCollection<Content>(config["MongoDbSettings:CollectionName"]);
        }

        public async Task<Content> GetContentById(int id)
        {
            return await _contentCollection.Find(p => p.Id == id).FirstOrDefaultAsync();
        }

        public async Task<Content> AddContent(Content newContent)
        {
            await _contentCollection.InsertOneAsync(newContent);
            return newContent;
        }

        public async Task<Content> UpdateContent(int id, Content updatedContent)
{
    var existingContent = await _contentCollection.Find(p => p.Id == id).FirstOrDefaultAsync();
    if (existingContent == null)
        return null;

    // Update the properties you have in the Content model
    existingContent.Title = updatedContent.Title; 
    // You can add more properties that exist in your model here

    var filter = Builders<Content>.Filter.Eq(p => p.Id, id);
    var updateResult = await _contentCollection.ReplaceOneAsync(filter, existingContent);

    return updateResult.IsAcknowledged ? existingContent : null;
}


        public async Task<bool> DeleteContent(int id)
        {
            var filter = Builders<Content>.Filter.Eq(p => p.Id, id);
            var deleteResult = await _contentCollection.DeleteOneAsync(filter);
            return deleteResult.DeletedCount > 0;
        }
    }
}
