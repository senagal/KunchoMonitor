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
    /// <summary>
    /// Service class to handle operations related to content management.
    /// </summary>
    public class ContentService : IContentServices
    {
        private readonly IMongoCollection<Content> _contentCollection;

        /// <summary>
        /// Initializes a new instance of the <see cref="ContentService"/> class.
        /// </summary>
        /// <param name="config">Configuration settings for MongoDB connection.</param>
        public ContentService(IConfiguration config)
        {
            var client = new MongoClient(config["MongoDbSettings:ConnectionString"]);
            var database = client.GetDatabase(config["MongoDbSettings:DatabaseName"]);
            _contentCollection = database.GetCollection<Content>(config["MongoDbSettings:CollectionName"]);
        }

        /// <summary>
        /// Searches and filters content based on the provided criteria.
        /// </summary>
        /// <param name="criteria">Search filter criteria containing title, ID, and body content.</param>
        /// <returns>A task representing the asynchronous operation, with a list of <see cref="Content"/> items.</returns>
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

        /// <summary>
        /// Searches, filters, and applies pagination to content.
        /// </summary>
        /// <param name="query">Search query for title or body content.</param>
        /// <param name="id">Optional content ID to filter by.</param>
        /// <param name="page">Page number for pagination.</param>
        /// <param name="pageSize">Number of items per page.</param>
        /// <returns>A task representing the asynchronous operation, with a list of <see cref="Content"/> items.</returns>
        public async Task<List<Content>> SearchAndFilterWithPagination(string? query, int? id, int page, int pageSize)
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

        /// <summary>
        /// Retrieves a content item by its ID.
        /// </summary>
        /// <param name="id">The ID of the content to retrieve.</param>
        /// <returns>A task representing the asynchronous operation, with the <see cref="Content"/> item as the result.</returns>
        public async Task<Content> GetContentById(int id)
        {
            return await _contentCollection.Find(p => p.Id == id).FirstOrDefaultAsync();
        }

        /// <summary>
        /// Adds a new content item to the collection.
        /// </summary>
        /// <param name="newContent">The new content object to add.</param>
        /// <returns>A task representing the asynchronous operation, with the added <see cref="Content"/> item.</returns>
        public async Task<Content> AddContent(Content newContent)
        {
            await _contentCollection.InsertOneAsync(newContent);
            return newContent;
        }

        /// <summary>
        /// Updates an existing content item by its ID.
        /// </summary>
        /// <param name="id">The ID of the content to update.</param>
        /// <param name="updatedContent">The updated content data.</param>
        /// <returns>A task representing the asynchronous operation, with the updated <see cref="Content"/> item.</returns>
        public async Task<Content> UpdateContent(int id, Content updatedContent)
        {
            await _contentCollection.ReplaceOneAsync(p => p.Id == id, updatedContent);
            return updatedContent;
        }

        /// <summary>
        /// Deletes a content item by its ID.
        /// </summary>
        /// <param name="id">The ID of the content to delete.</param>
        /// <returns>A task representing the asynchronous operation, indicating if the deletion was successful.</returns>
        public async Task<bool> DeleteContent(int id)
        {
            var filter = Builders<Content>.Filter.Eq(p => p.Id, id);
            var deleteResult = await _contentCollection.DeleteOneAsync(filter);
            return deleteResult.DeletedCount > 0;
        }
    }
}