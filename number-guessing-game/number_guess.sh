#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align --tuples-only -c"

RAN_NUMBER=$((RANDOM%1001+1))

echo "Enter your username:"
read NAME

COUNTER=$($PSQL "SELECT COUNT(username) FROM games WHERE username='$NAME'")

if [[ $COUNTER -eq 0 ]]
then
echo "Welcome, $NAME! It looks like this is your first time here."
elif [[ $COUNTER -gt 0 ]]
then
NUM_GUESSES=$($PSQL "SELECT MIN(guesses) FROM games WHERE username='$NAME'")
echo "Welcome back, $NAME! You have played $COUNTER games, and your best game took $NUM_GUESSES guesses."
fi

echo "Guess the secret number between 1 and 1000:"

NOT_FOUND=true
G_COUNT=0

while $NOT_FOUND
do
read GUESSED

if [[ ! $GUESSED =~ ^[0-9]*$ ]]
then
echo "That is not an integer, guess again:"
else

G_COUNT=$((G_COUNT+1))

if [[ $GUESSED -eq $RAN_NUMBER ]]
then

INS_GAME=$($PSQL "INSERT INTO games(username,guesses) VALUES('$NAME',$G_COUNT)")
echo "You guessed it in $G_COUNT tries. The secret number was $RAN_NUMBER. Nice job!"
NOT_FOUND=false

else
if [[ $GUESSED -lt $RAN_NUMBER ]]
then
echo "It's higher than that, guess again:"
else
echo "It's lower than that, guess again:"
fi

fi

fi
done
