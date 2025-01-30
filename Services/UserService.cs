using MongoDB.Driver;
using user.Models;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using content.Services;

public class UserService : IUserServices
{
    private readonly IMongoCollection<User> _users;
    private readonly string _jwtSecret = "dund=und00?ndundundanaddddaoelelel!!elelele@";

    public UserService(MongoConnect dbContext)
    {
        _users = dbContext.Users;
    }

    public async Task AddUser(User newUser)
    {
        newUser.Id = MongoDB.Bson.ObjectId.GenerateNewId();
        await _users.InsertOneAsync(newUser);
    }

    public async Task<User> AuthenticateUserAsync(string username, string password)
    {
        return await _users.Find(u => u.Username == username && u.Password == password).FirstOrDefaultAsync();
    }

    public async Task<string> Login(string username, string password)
    {
        var user = await AuthenticateUserAsync(username, password);
        if (user == null) return null;
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes(_jwtSecret);

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[]
            {
                new Claim(ClaimTypes.Name, user.Username),
                new Claim(ClaimTypes.Role, user.Role)
            }),
            Expires = DateTime.UtcNow.AddHours(2),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }

    public async Task<User> GetUserById(string userId)
    {
        return await _users.Find(u => u.Id.ToString() == userId).FirstOrDefaultAsync();
    }

    public async Task<List<User>> GetAllUsers()
    {
        return await _users.Find(_ => true).ToListAsync();
    }
}
    
