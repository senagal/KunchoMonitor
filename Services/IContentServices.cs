using System.Collections.Generic;
using content.Models;
using activity.Models;

namespace content.Services
{
    public interface IContentServices
    {
        Task<Content> GetContentById(int id);
        Task<Content> AddContent(Content newContent);
        Task<Content> UpdateContent(int id, Content updatedContent);  // Added
        Task<bool> DeleteContent(int id);  // Added
    }

    public interface IActivityServices
    {
        Task<Activity> AddActivity(int contentId);
    }
}
