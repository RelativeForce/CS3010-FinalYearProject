using Revoked.Core.Entities;
using System;

namespace Revoked.Services.Data
{
    public sealed class PlayerScoreCreateMessage
    {
        public string Username { get; set; }
        public long Score { get; set; }
        public DateTime Start { get; set; }
        public DateTime End { get; set; }

        public PlayerScore ToEntity()
        {
            return new PlayerScore
            {
                Username = Username,
                Score = Score,
                Time = End.Subtract(Start)
            };
        }

        public PlayerScoreCreateMessage()
        {
        }
    }
}
