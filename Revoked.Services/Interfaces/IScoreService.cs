using System.Collections.Generic;
using System.Threading.Tasks;
using Revoked.Services.Data;

namespace Revoked.Services.Interfaces
{
    public interface IScoreService
    {
        Task StoreScoreAsync(PlayerScore score);

        List<PlayerScore> ListTop(int numberOfScores);
    }
}
