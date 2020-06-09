#!/bin/bash -x

echo "Welcome to Gambling"

STAKE_PER_DAY=100
BET_PER_GAME=1

read -p "Enter the percent at which gambler can resign for the day" percent
maxLimit=$(( $STAKE_PER_DAY + ($percent*$STAKE_PER_DAY/100) ))
minLimit=$(( $STAKE_PER_DAY - ($percent*$STAKE_PER_DAY/100) ))

function dailyCash()
{
	cash=$STAKE_PER_DAY
	while [ $cash -gt $minLimit ] && [ $cash -lt $maxLimit ]
	do
		betResult=$((RANDOM%2))
		if [ $betResult -eq 1 ]
		then
			cash=$(( $cash+$BET_PER_GAME ))
			echo "Won the Bet"
		else
			cash=$(( $cash-$BET_PER_GAME ))
			echo "Lost The Bet"
		fi
	done
	echo "cash at the end of the day " $cash
}
dailyCash

