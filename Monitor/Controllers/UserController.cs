using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
using user.Models;
using content.Services;
using System.Threading.Tasks;

[ApiController]
[Route("api/[controller]")]
public class UsersController : ControllerBase
{
    private readonly IUserServices _userService;

    /// <summary>
    /// Initializes a new instance of the <see cref="UsersController"/> class.
    /// </summary>
    /// <param name="userService">The service used to manage users.</param>
    public UsersController(IUserServices userService)
    {
        _userService = userService;
    }

    /// <summary>
    /// Registers a new user in the system.
    /// </summary>
    /// <param name="newUser">The new user to register.</param>
    /// <returns>A success message indicating that the user was registered.</returns>
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] User newUser)
    {
        await _userService.AddUser(newUser);
        return Ok(new { message = "User registered successfully." });
    }

    /// <summary>
    /// Authenticates a user and returns a JWT token.
    /// </summary>
    /// <param name="loginUser">The login credentials of the user.</param>
    /// <returns>A JWT token if credentials are valid, or an Unauthorized response if invalid.</returns>
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] User loginUser)
    {
        var token = await _userService.Login(loginUser.Username, loginUser.Password);
        if (token == null) return Unauthorized(new { message = "Invalid credentials" });

        return Ok(new { token });
    }

    /// <summary>
    /// Retrieves a list of all users.
    /// </summary>
    /// <returns>A list of all users in the system.</returns>
    [HttpGet("getUsers")]
    [Authorize]
    public async Task<IActionResult> GetAllUsers()
    {
        var users = await _userService.GetAllUsers();
        return Ok(users);
    }

    /// <summary>
    /// Retrieves the user with the specified ID.
    /// </summary>
    /// <param name="id">The unique identifier of the user.</param>
    /// <returns>The user with the given ID, or NotFound if the user doesn't exist.</returns>
    [Authorize]
    [HttpGet("byname/{username}")]
    public async Task<IActionResult> GetUserByUsername(string username)
    {
        if (string.IsNullOrEmpty(username))
        {
            return BadRequest(new { message = "Username cannot be empty" });
        }

        var user = await _userService.GetUserByUsername(username);
        if (user == null)
        {
            return NotFound(new { message = "User not found" });
        }
        return Ok(user);
    }

}
