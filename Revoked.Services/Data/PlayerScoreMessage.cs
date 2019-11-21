using Revoked.Core.Entities;

namespace Revoked.Services.Data
{
    public sealed class PlayerScoreMessage
    {
        public string Username { get; set; }
        public long Score { get; set; }
        public string Time { get; set; }
        public int Position { get; set; }

        public PlayerScoreMessage(PlayerScore playerScore, int position)
        {
            Position = position;
            Username = playerScore.Username;
            Score = playerScore.Score;
            Time = playerScore.Time.ToString(@"hh\:mm\:ss");

        }

        public PlayerScoreMessage()
        {
        }
    }
}
