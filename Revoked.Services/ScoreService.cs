using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Revoked.Core.Entities;
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

        public async Task StoreScoreAsync(PlayerScoreCreateMessage score)
        {
            var entity = score.ToEntity();

            var result = await _repository.AddAsync(entity);

            if(result == null)
                throw new Exception("Failed to add high score");
        }

        public List<PlayerScoreMessage> ListTop(int numberOfScores)
        {
            if(numberOfScores <= 0)
                throw new ArgumentOutOfRangeException($"{nameof(numberOfScores)} cannot be less than or equal to zero");


            return _repository
                .Query<PlayerScore>()
                .OrderByDescending(hs => hs.Score)
                .Take(numberOfScores)
                .AsEnumerable()
                .Select(ps => new PlayerScoreMessage(ps))
                .ToList();
        }
    }
}
