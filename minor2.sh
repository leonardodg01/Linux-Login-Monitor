 #!/bin/bash
#Leonardo Grimaldo
#3600.003
#10/1/2021
#Program that checks who logs in and logs out of current cse machine


touch temp1.txt #creates temp1.txt
touch temp2.txt #creates temp2.txt
touch temp3.txt #holds differences from temp1
touch temp4.txt #holds changes from temp2
test=0 #holds if temp1.txt and temp2.txt are different
who | cut -d " " -f 1 > temp1.txt #assigns initial state of who to temp1.txt
cCheck=0 #amount of times ^C is pressed

date
echo 'initial users who logged in: '


while IFS= read -r line; #prints temp1.txt which contains all user initially logged in
do
	echo "$line logged in"
done < temp1.txt

cat temp1.txt > temp2.txt #copies data in temp1 to temp2

while true
do
	sleep 10 #Waits 10 seconds before running again
	who | cut -d " " -f 1 > temp1.txt

	date
	echo -n  "# of users:" #prints date and user logged in
	wc -l < temp1.txt


	diff temp1.txt temp2.txt | grep -- ">" > temp3.txt #adds changes from temp2
	diff temp1.txt temp2.txt | grep -- "<" > temp4.txt #adds changes from temp1

	if [[ -s temp3.txt ]]
	then #prints out new users
        	echo -n " Logged out"
		cat temp3.txt  #prints temp1.txt which contains all user initially logged in
		cat temp1.txt > temp2.txt

	elif [[ -s temp4.txt ]] #prints out users that logged out
	then
		echo -n " Logged in"
		cat temp4.txt
		cat temp1.txt > temp2.txt

	fi

	if [[ $cCheck == 2 ]] #exits if ^C is pressed twice
	then
		exit
	fi

	#increments cCheck when ^C is pressed
	trap 'echo \(SIGINT\) ignored. enter ^C 1 more time to terminate program.; let cCheck=$cCheck+1' SIGINT
done
