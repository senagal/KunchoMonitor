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
    }
}