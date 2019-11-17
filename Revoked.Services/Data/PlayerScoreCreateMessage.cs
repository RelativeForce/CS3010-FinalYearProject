using Revoked.Core.Entities;
using System;

namespace Revoked.Services.Data
{
    public sealed class PlayerScoreCreateMessage
    {
        public string Username { get; set; }
        public long Score { get; set; }
        public string Start { get; set; }
        public string End { get; set; }

        public PlayerScore ToEntity()
        {
            return new PlayerScore
            {
                Username = Username,
                Score = Score,
                Time = DateTime.Parse(End).Subtract(DateTime.Parse(Start))
            };
        }

        public PlayerScoreCreateMessage()
        {
        }
    }
}
