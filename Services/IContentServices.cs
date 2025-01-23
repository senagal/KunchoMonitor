using System.Collections.Generic;
using content.Models;

namespace content.Services
{
    public interface IContentServices
    {
        
        Task<Content> GetContentById(int Id);
        Task<Content> AddContent(Content newContent);
        
    }
}