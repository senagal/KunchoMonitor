using MongoDB.Driver;
using user.Models;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using content.Services;

/// <summary>
/// Service class to handle user-related operations like authentication and registration.
/// </summary>
public class UserService : IUserServices
{
    private readonly IMongoCollection<User> _users;
    private readonly string _jwtSecret = "dund=und00?ndundundanaddddaoelelel!!elelele@";

    /// <summary>
    /// Initializes a new instance of the <see cref="UserService"/> class.
    /// </summary>
    /// <param name="dbContext">The database connection object.</param>
    public UserService(MongoConnect dbContext)
    {
        _users = dbContext.Users;
    }

    /// <summary>
    /// Registers a new user in the system.
    /// </summary>
    /// <param name="newUser">The user details.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    public async Task AddUser(User newUser)
    {
        newUser.Id = MongoDB.Bson.ObjectId.GenerateNewId();
        await _users.InsertOneAsync(newUser);
    }

    /// <summary>
    /// Authenticates a user by username and password.
    /// </summary>
    /// <param name="username">The username.</param>
    /// <param name="password">The password.</param>
    /// <returns>A task representing the asynchronous operation, with a <see cref="User"/> object if authenticated.</returns>
    public async Task<User> AuthenticateUserAsync(string username, string password)
    {
        return await _users.Find(u => u.Username == username && u.Password == password).FirstOrDefaultAsync();
    }

    /// <summary>
    /// Logs in a user by generating a JWT token.
    /// </summary>
    /// <param name="username">The username.</param>
    /// <param name="password">The password.</param>
    /// <returns>A task representing the asynchronous operation, with the generated JWT token.</returns>
    public async Task<string> Login(string username, string password)
    {
        var user = await AuthenticateUserAsync(username, password);
        if (user == null) return null;

        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes(_jwtSecret);

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[] {
                new Claim(ClaimTypes.Name, user.Username),
                new Claim(ClaimTypes.Role, user.Role)
            }),
            Expires = DateTime.UtcNow.AddHours(2),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }

    /// <summary>
    /// Retrieves a user by their ID.
    /// </summary>
    /// <param name="userId">The ID of the user to retrieve.</param>
    /// <returns>A task representing the asynchronous operation, with the <see cref="User"/> object.</returns>
    public async Task<User> GetUserByUsername(string username)
    {
        return await _users.Find(u => u.Username == username).FirstOrDefaultAsync();
    }
    /// <summary>
    /// Retrieves all users from the system.
    /// </summary>
    /// <returns>A task representing the asynchronous operation, with a list of <see cref="User"/> objects.</returns>
    public async Task<List<User>> GetAllUsers()
    {
        return await _users.Find(_ => true).ToListAsync();
    }
}
