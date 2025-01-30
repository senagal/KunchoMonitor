using MongoDB.Driver;
using content.Models;
using user.Models;

public class MongoConnect
{
    private readonly IMongoDatabase _database;

    public MongoConnect()
    {
        var client = new MongoClient("mongodb://localhost:27017");
        _database = client.GetDatabase("KunchoMonitor");
    }

    public IMongoCollection<User> Users => _database.GetCollection<User>("Users");
    public IMongoCollection<Content> Contents => _database.GetCollection<Content>("Contents");
}
