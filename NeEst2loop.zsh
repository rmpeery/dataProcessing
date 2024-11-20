#!/usr/local/bin/zsh

TYPE=1
echo "done\n"

for FILE in *.txt

do
	echo "$TYPE\n" | echo "$FILE" | ~/Documents/scripts/NeEst/Ne2-1M
	#echo "1" | echo "$FILE" | ./Ne2-1M;
	echo ""
done
