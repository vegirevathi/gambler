#!/bin/bash -x

echo "Welcome to Gambling"

STAKE_PER_DAY=100
BET_PER_GAME=1
declare -A gambling

read -p "Enter the percent at which gambler can resign for the day" percent
maxLimit=$(( $STAKE_PER_DAY + ($percent*$STAKE_PER_DAY/100) ))
minLimit=$(( $STAKE_PER_DAY - ($percent*$STAKE_PER_DAY/100) ))

function dailyCash()
{
	cash=$STAKE_PER_DAY
	wins=0
	lost=0
	while [ $cash -gt $minLimit ] && [ $cash -lt $maxLimit ]
	do
		betResult=$((RANDOM%2))
		if [ $betResult -eq 1 ]
		then
			cash=$(( $cash+$BET_PER_GAME ))
		else
			cash=$(( $cash-$BET_PER_GAME ))
		fi
	done
	echo "cash at the end of the day " $cash
}
dailyCash

function computeCashForMonth()
{
	totalAmount=0
	wins=0
	lost=0
	read -p "Number of days Gambler Wish to Play in a Month" Days
	for (( i=1; i<=Days; i++ ))
	do
		dailyCash
		 if [ $cash -eq $maxLimit ]
         then
				totalAmount=$(( totalAmount+maxLimit ))
				dailyResult["Day"]=$totalAmount
            echo "Won for the day $i"
				(( wins++ ))
				
         else
				totalAmount=$(( totalAmount-minLimit ))
				dailyResult["Day"]=$totalAmount
            echo "Lost for the day $i"
            (( lost++ ))
    	fi
		echo "Winning days" $wins
		echo "Loosing days" $lost
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


function luckyAndUnluckyDay()
{
	computeCashForMonth
	echo "For Luckiest Day"
	for element in ${dailyResult[@]}
	do
		echo $element " : " ${dailyResult[@]}
	done | sort -n | tail -1

	echo "For Unluckiest Day"
	for element in ${!dailyResult[@]}
	do
		echo $element " : " ${dailyResult[@]}
	done | sort -n | head -1
}
luckyAndUnluckyDay
