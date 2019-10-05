using System;
using System.Linq.Expressions;
using Moq;
using Revoked.Core.Interfaces;
using Revoked.Services.Data;
using Xunit;

namespace Revoked.Services.Tests
{
    public class ScoreServiceShould
    {
        private readonly Mock<IRepository> _repositoryMock;

        public ScoreServiceShould()
        {
            _repositoryMock = new Mock<IRepository>(MockBehavior.Strict);
        }

        [Fact]
        public async void ShouldAddScoreToRepositoryWhenScoreIsValid()
        {
            const string username = "test username";
            const long points = 5453;
            var time = new TimeSpan(0, 10, 0);

            var score = new PlayerScore
            {
                Username = username,
                Score = points,
                Time = time
            };

            Expression<Func<Core.Entities.PlayerScore, bool>> entityCheck = ps =>
                ps.Score == points &&
                ps.Time == time &&
                ps.Username == username;

            _repositoryMock
                .Setup(m => m.AddAsync(It.Is(entityCheck)))
                .ReturnsAsync(new Core.Entities.PlayerScore())
                .Verifiable();

            var service = NewService();

            await service.StoreScoreAsync(score);

            _repositoryMock.Verify(m => m.AddAsync(It.Is(entityCheck)), Times.Once);
        }

        [Fact]
        public async void ShouldThrowExceptionWhenScoreIsValid()
        {
            const string username = "test username";
            const long points = 5453;
            var time = new TimeSpan(0, 10, 0);

            var score = new PlayerScore
            {
                Username = username,
                Score = points,
                Time = time
            };

            Expression<Func<Core.Entities.PlayerScore, bool>> entityCheck = ps =>
                ps.Score == points &&
                ps.Time == time &&
                ps.Username == username;

            _repositoryMock
                .Setup(m => m.AddAsync(It.Is(entityCheck)))
                .ReturnsAsync((Core.Entities.PlayerScore) null)
                .Verifiable();

            var service = NewService();

            try
            {
                await service.StoreScoreAsync(score);

                Assert.False(true, "Should not reach this line");
            }
            catch (Exception e)
            {
                Assert.Equal("Failed to add high score", e.Message);
            }
            

            _repositoryMock.Verify(m => m.AddAsync(It.Is(entityCheck)), Times.Once);
        }

        public ScoreService NewService()
        {
            return new ScoreService(_repositoryMock.Object);
        }
    }
}
