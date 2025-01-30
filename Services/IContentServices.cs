using System.Collections.Generic;
using content.Models;
using activity.Models;
using user.Models;

namespace content.Services
{
        public interface IContentServices
        {
            Task<List<Content>> SearchAndFilterWithPagination(
                string? query,
                int? id,
                int page,
                int pageSize);
            Task<List<Content>> SearchAndFilterContent(SearchFilterCriteria criteria);
            Task<Content> GetContentById(int id);
            Task<Content> AddContent(Content newContent);
            Task<Content> UpdateContent(int id, Content updatedContent);
            Task<bool> DeleteContent(int id);
        }
        public interface IActivityServices
        {
            Task<Activity> AddActivity(int contentId);
            Task<List<Activity>> GetActivitiesByContentId(int contentId);
        }
        public interface IUserServices
        {
            Task<User> AuthenticateUserAsync(string username, string password);
            Task<string> Login(string username, string password);
            Task AddUser(User newUser);
            Task<User> GetUserByUsername(string username);
            Task<List<User>> GetAllUsers();
        }
    
}
