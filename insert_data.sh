#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  # insert data for teams table
  if [[ $WINNER != "winner" ]] # do not take first row of data
  then
    WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'") # check if team already exists in table
    if [[ -z $WINNER_NAME ]] #if TEAM_NAME doesn't exist, to create new data row
    then # insert new unique team into table
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) values('$WINNER')")
      if [[ $INSERT_WINNER_NAME == "INSERT 0 1" ]] # check that insertion is successful
      then
        echo Inserted into teams, $WINNER
      fi
    fi
  fi

  if [[ $OPPONENT != "opponent" ]] # do not take first row of data
  then
    OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'") # check if team already exists in table
    if [[ -z $OPPONENT_NAME ]] #if TEAM_NAME doesn't exist, to create new data row
    then # insert new unique team into table
      INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) values('$OPPONENT')")
      if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]] # check that insertion is successful
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi

  # insert data for games table
  if [[ $YEAR != 'year' ]] # do not take the first row of data
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'") # grab ID for winning team based on winning team name
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'") # grab ID for opponent team based on opponent team name
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME == "INSERT 0 1" ]] # check that insertion is successful
    then
      echo Inserted $ROUND $YEAR game between $WINNER and $OPPONENT
    else
      echo Game insert unsucessful
    fi
  fi
done