using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Revoked.Core.Interfaces;
using Revoked.Services.Data;
using Revoked.Services.Interfaces;

namespace Revoked.Services
{
    public sealed class ScoreService : IScoreService
    {
        private readonly IRepository _repository;

        public ScoreService(IRepository repository)
        {
            _repository = repository;
        }

        public async Task StoreScoreAsync(PlayerScore score)
        {
            var entity = score.ToEntity();

            var result = await _repository.AddAsync(entity);

            if(result == null)
                throw new Exception("Failed to add high score");
        }

        public List<PlayerScore> ListTop(int numberOfScores)
        {
            return _repository
                .Query<Core.Entities.PlayerScore>()
                .OrderByDescending(hs => hs.Score)
                .Take(numberOfScores)
                .AsEnumerable()
                .Select(ps => new PlayerScore(ps))
                .ToList();
        }
    }
}
