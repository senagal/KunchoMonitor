//before update
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Driver;
using content.Models;
using Microsoft.Extensions.Configuration;

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

        public async Task<List<Content>> SearchAndFilterContent(SearchFilterCriteria criteria)
        {
            var filterBuilder = Builders<Content>.Filter;
            var filter = filterBuilder.Empty;

            if (!string.IsNullOrWhiteSpace(criteria.Title))
            {
                filter = filterBuilder.And(filter, filterBuilder.Regex("Title", new BsonRegularExpression(criteria.Title, "i")));
            }

            if (criteria.Id.HasValue)
            {
                filter = filterBuilder.And(filter, filterBuilder.Eq("Id", criteria.Id));
            }

            if (!string.IsNullOrWhiteSpace(criteria.BodyContains))
            {
                filter = filterBuilder.And(filter, filterBuilder.Regex("Body", new BsonRegularExpression(criteria.BodyContains, "i")));
            }

            return await _contentCollection.Find(filter).ToListAsync();
        }

        public async Task<List<Content>> SearchAndFilterWithPagination(
        string? query,
        int? id,
        int page,
        int pageSize)
        {
            var filter = Builders<Content>.Filter.Empty; 

            if (!string.IsNullOrWhiteSpace(query))
            {
                var regexQuery = new BsonRegularExpression(query, "i");
                var titleFilter = Builders<Content>.Filter.Regex(c => c.Title, regexQuery);
                var bodyFilter = Builders<Content>.Filter.Regex(c => c.Body, regexQuery);

                filter &= Builders<Content>.Filter.Or(titleFilter, bodyFilter);
            }

            if (id.HasValue)
            {
                var idFilter = Builders<Content>.Filter.Eq(c => c.Id, id.Value);
                filter &= idFilter;
            }

            var totalCount = await _contentCollection.CountDocumentsAsync(filter);

            var skip = (page - 1) * pageSize;
            var contents = await _contentCollection.Find(filter)
                                                    .Skip(skip)
                                                    .Limit(pageSize)
                                                    .ToListAsync();

            return contents;
        }

        public async Task<List<Content>> SearchAndFilterWithSorting(string? title, int? id, string sortBy, bool isDescending)
        {
            var filterBuilder = Builders<Content>.Filter;
            var filter = filterBuilder.Empty;

            if (!string.IsNullOrWhiteSpace(title))
            {
                filter = filterBuilder.And(filter, filterBuilder.Regex("Title", new BsonRegularExpression(title, "i")));
            }

            if (id.HasValue)
            {
                filter = filterBuilder.And(filter, filterBuilder.Eq("Id", id));
            }

            var sortDefinition = isDescending
                ? Builders<Content>.Sort.Descending(sortBy)
                : Builders<Content>.Sort.Ascending(sortBy);

            return await _contentCollection.Find(filter).Sort(sortDefinition).ToListAsync();
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

            existingContent.Title = updatedContent.Title; 
        

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

