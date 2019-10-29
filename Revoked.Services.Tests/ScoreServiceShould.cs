using System;
using System.Collections.Generic;
using System.Linq;
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

        #region StoreScoreAsync Tests

        [Fact]
        public async void ShouldAddScoreToRepositoryWhenScoreIsValid()
        {
            const string username = "test username";
            const long points = 5453;
            var start = DateTime.Now;
            var end = DateTime.Now.AddDays(1);

            var score = new PlayerScoreCreateMessage
            {
                Username = username,
                Score = points,
                Start = start,
                End = end
            };

            Expression<Func<Core.Entities.PlayerScore, bool>> entityCheck = ps =>
                ps.Score == points &&
                ps.Time == end.Subtract(start) &&
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
            var start = DateTime.Now;
            var end = DateTime.Now.AddDays(1);

            var score = new PlayerScoreCreateMessage
            {
                Username = username,
                Score = points,
                Start = start,
                End = end
            };

            Expression<Func<Core.Entities.PlayerScore, bool>> entityCheck = ps =>
                ps.Score == points &&
                ps.Time == end.Subtract(start) &&
                ps.Username == username;

            _repositoryMock
                .Setup(m => m.AddAsync(It.Is(entityCheck)))
                .ReturnsAsync((Core.Entities.PlayerScore)null)
                .Verifiable();

            var service = NewService();

            await Assert.ThrowsAsync<Exception>(async () => { await service.StoreScoreAsync(score); });

            _repositoryMock.Verify(m => m.AddAsync(It.Is(entityCheck)), Times.Once);
        }

        #endregion

        #region ListTop Tests

        [Theory]
        [InlineData(0)]
        [InlineData(-1)]
        [InlineData(-10)]
        public void ShouldThrowExceptionWhenNumberOfScoresIsLessThanOrEqualToZero(int numberOfScores)
        {
            var service = NewService();

            Assert.Throws<ArgumentOutOfRangeException>(() => { service.ListTop(numberOfScores); });
        }

        [Fact]
        public void ShouldReturnTestScoresInCorrectOrder()
        {
            var testScores = new List<Core.Entities.PlayerScore>();
            const int numberOfScores = 10;
            const int topCount = numberOfScores - 2;

            for (var i = 0; i < numberOfScores; i++)
            {
                testScores.Add(new Core.Entities.PlayerScore
                {
                    Score = i,
                    Id = i,
                    Time = new TimeSpan(numberOfScores - i),
                    Username = "user " + i
                });
            }

            _repositoryMock
                .Setup(m => m.Query<Core.Entities.PlayerScore>())
                .Returns(testScores.AsQueryable())
                .Verifiable();

            var service = NewService();

            var result = service.ListTop(topCount);

            Assert.Equal(topCount, result.Count);

            var orderedTestScores = testScores.OrderByDescending(hs => hs.Score).ToList();

            for (var s = 0; s < topCount; s++)
            {
                Assert.Equal(orderedTestScores[s].Username, result[s].Username);

                s++;
            }
        }

        #endregion

        public ScoreService NewService()
        {
            return new ScoreService(_repositoryMock.Object);
        }
    }
}
