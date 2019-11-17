using System;
using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Revoked.Core.Entities;
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

        public async Task<JsonResult> OnPostStoreScore([FromBody] PlayerScoreCreateMessage createMessage)
        {
            try
            {
                await _scoreService.StoreScoreAsync(createMessage);

                return new JsonResult(true);
            }
            catch (Exception e)
            {
                Trace.TraceError(e.ToString());

                return new JsonResult(false);
            }
        }

        public JsonResult OnGetTopTen()
        {
            return new JsonResult(_scoreService.ListTop(10));
        }
    }
}
