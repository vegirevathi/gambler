#!/bin/bash -x

echo "Welcome to Gambling"

STAKE_PER_DAY=100
BET_PER_GAME=1

read -p "Enter the percent at which gambler can resign for the day" percent
read -p "Number of days Gambler Wish to Play in a Month" Days

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
		else
			cash=$(( $cash-$BET_PER_GAME ))
		fi
	done
	echo "cash at the end of the day " $cash
}

function computeCashForMonth()
{
	totalAmount=0
	wins=0
	lost=0
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

function winOrLossDays()
{
   computeCashForMonth
   declare -A dailyData=([i]=cash)
   echo "([${!dailyData[@]}]=${dailyData[@]})"
}
declare -A dailyDataOutput="$(winOrLossDays)"

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

function conditionForContinuation()
{
	isValid=1
	while [ $isValid ]
	do
		computeCashForMonth
		if [ $profitAmount -gt 0 ]
		then
			echo "continue for next month"
			break
		else
			stopGambling="true"
			echo "Stop it for this month"
		fi
	done
}
conditionForContinuation
echo Days: ${!dailyDataOutput[@]}
echo totalAmount: ${dailyDataOutput[@]}
