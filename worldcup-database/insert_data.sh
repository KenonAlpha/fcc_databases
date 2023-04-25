#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read A B C D E F
do
if [[ $A != "year" ]]
then

W_EXIST=$($PSQL "SELECT name FROM teams WHERE name='$C'")
O_EXIST=$($PSQL "SELECT name FROM teams WHERE name='$D'")

if [[ -z $W_EXIST ]]
then
echo $($PSQL "INSERT INTO teams(name) VALUES('$C')")
fi

if [[ -z $O_EXIST ]]
then
echo $($PSQL "INSERT INTO teams(name) VALUES('$D')")
fi

WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$C'")
LOSER=$($PSQL "SELECT team_id FROM teams WHERE name='$D'")
INSERT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($A, '$B', $WINNER, $LOSER, $E, $F)")


fi
done
