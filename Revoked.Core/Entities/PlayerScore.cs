using System;

namespace Revoked.Core.Entities
{
    public class PlayerScore : BaseEntity
    {
        public string Username { get; set; }
        public long Score { get; set; }
        public TimeSpan Time { get; set; }
    }
}
