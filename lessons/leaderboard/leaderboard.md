The NFL has tasked you with building a program that tracks game results as the season progresses. In this assignment, you will build a Ruby application that prints a leaderboard when your code runs. (For the non-sports fans, a leaderboard is a scoreboard that shows the name, number of wins, and number of losses for each team in the league.) Using the data defined in `leaderboard.rb`, print the following information for each team:

- Team name
- Team's rank (based on who was the most wins). (Teams with the same numbers of wins can be ranked in any order!)
- Team's total number of wins
- Team's total number of losses

Additionally, teams should be ordered by rank (teams with more wins are ranked and listed higher).

####Tips:
- Consider reorganizing the information into your own data structure, if you can think of a way to do it that better fits your needs!
- Focus on organizing your code well.
- Use methods as much as possible!

###Extra Credit Option 1: Making it Pretty!

Format your output such that your leaderboard prints looking (at least approxomitely) like this:

```
--------------------------------------------------
| Name      Rank      Total Wins    Total Losses |
| Patriots  1         3             0            |
| Broncos   2         1             1            |
| Colts     3         0             2            |
| Steelers  4         0             1            |
--------------------------------------------------
```

###Extra Credit Option 2: Retrieving More Data

Write a method that takes in a team name, and prints the following information:

- Team's name
- Team's rank
- Team's total number of wins and losses
- Details of each game the team has played (including the name of the opposing team and the score for each team)
