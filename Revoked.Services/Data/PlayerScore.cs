using System;

namespace Revoked.Services.Data
{
    public sealed class PlayerScore
    {
        public string Username { get; set; }
        public long Score { get; set; }
        public TimeSpan Time { get; set; }

        public Core.Entities.PlayerScore ToEntity()
        {
            return new Core.Entities.PlayerScore
            {
                Username = Username,
                Score = Score,
                Time = Time
            };
        }

        public PlayerScore(Core.Entities.PlayerScore playerScore)
        {
            Username = playerScore.Username;
            Score = playerScore.Score;
            Time = playerScore.Time;
        }
    }
}
