#!/bin/bash -x

echo "Welcome to Gambling"

STAKE_PER_DAY=100
BET_PER_GAME=1

betResult=$((RANDOM%2))
if [ $betResult -eq 1 ]
then
	echo "Won the Bet"
else
	echo "Lost The Bet"
fi
