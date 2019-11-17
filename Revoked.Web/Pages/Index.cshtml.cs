using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Revoked.Services.Data;
using Revoked.Services.Interfaces;

namespace Revoked.Web.Pages
{
    public class IndexModel : PageModel
    {
        private readonly IScoreService _scoreService;

        public IndexModel(IScoreService scoreService)
        {
            _scoreService = scoreService;
        }

        public void OnGet()
        {
            // Required for page GET
        }

        public async Task OnPostStoreScore([FromBody] PlayerScoreCreateMessage createMessage)
        {
            await _scoreService.StoreScoreAsync(createMessage);
        }

        public JsonResult OnGetTopTen()
        {
            return new JsonResult(_scoreService.ListTop(10));
        }
    }
}
