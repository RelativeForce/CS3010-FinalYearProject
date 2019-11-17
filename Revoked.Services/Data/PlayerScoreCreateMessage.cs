using Revoked.Core.Entities;
using System;
using System.Diagnostics;

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
            try
            {
                return new PlayerScore
                {
                    Username = Username,
                    Score = Score,
                    Time = DateTime.Parse(End).Subtract(DateTime.Parse(Start))
                };
            }
            catch (Exception e)
            {
                Trace.TraceError(e.ToString());
                throw new ArgumentException($"Failed to parse {nameof(PlayerScore)}");
            }
            
        }

        public PlayerScoreCreateMessage()
        {
        }
    }
}
