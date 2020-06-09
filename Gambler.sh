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

function computeCashForMonth()
{
	monthlyCash=0
	read -p "Number of days Gambler Wish to Play in a Month" Days
	for (( i=1; i<=Days; i++ ))
	do
		dailyCash
		monthlyCash=$(( $monthlyCash+$cash ))
	done
	echo "Cash at the end of the month " $monthlyCash
	monthlyInvest=$(( $STAKE_PER_DAY*$Days ))
	if [ $monthlyCash -gt $monthlyInvest ]
	then
		profitAmount=$(( $monthlyCash-$monthlyInvest ))
		echo "Amount won at the end of the month is " $profitAmount
	else
		lostAmount=$(( $monthlyInvest-$monthlyCash ))
		echo "Amount lost at the end of the month is " $lostAmount
	fi
}
computeCashForMonth
