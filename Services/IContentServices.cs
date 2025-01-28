using System.Collections.Generic;
using content.Models;
using activity.Models;

namespace content.Services
{
    public interface IContentServices
    {
        
        Task<Content> GetContentById(int Id);
        Task<Content> AddContent(Content newContent);
        
    }
    public interface IActivityServices
    {
        Task<Activity> AddActivity(int ContentId);
    }
}