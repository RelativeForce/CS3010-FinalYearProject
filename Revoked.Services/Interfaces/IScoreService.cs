using System.Collections.Generic;
using System.Threading.Tasks;
using Revoked.Services.Data;

namespace Revoked.Services.Interfaces
{
    public interface IScoreService
    {
        Task StoreScoreAsync(PlayerScoreCreateMessage score);

        List<PlayerScoreMessage> ListTop(int numberOfScores);
    }
}
