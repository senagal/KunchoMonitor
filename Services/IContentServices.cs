using content.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace content.Services
{
    public interface IContentServices
    {
        Task<List<Content>> SearchAndFilterContent(SearchFilterCriteria criteria);
        Task<List<Content>> SearchAndFilterWithPagination(string? title, int? id, int page, int pageSize);
        Task<List<Content>> SearchAndFilterWithSorting(string? title, int? id, string sortBy, bool isDescending);
        Task<Content> GetContentById(int id);
        Task<Content> AddContent(Content newContent);
    }
}
//before update