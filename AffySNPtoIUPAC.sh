#!/usr/bin bash
## USE: chmod +x AffySNPtoIUPAC.sh; ./AffySNPtoIUPAC.sh

cp temp.txt temp.str;
perl -i.bak -pe "s/A\/A/A/g" temp.str;
perl -i.bak -pe "s/A\/T/W/g" temp.str;
perl -i.bak -pe "s/A\/G/R/g" temp.str;
perl -i.bak -pe "s/A\/C/M/g" temp.str;
perl -i.bak -pe "s/T\/A/W/g" temp.str;
perl -i.bak -pe "s/T\/T/T/g" temp.str;
perl -i.bak -pe "s/T\/G/K/g" temp.str;
perl -i.bak -pe "s/T\/C/Y/g" temp.str;
perl -i.bak -pe "s/G\/A/R/g" temp.str;
perl -i.bak -pe "s/G\/T/K/g" temp.str;
perl -i.bak -pe "s/G\/G/G/g" temp.str;
perl -i.bak -pe "s/G\/C/S/g" temp.str;
perl -i.bak -pe "s/C\/A/M/g" temp.str;
perl -i.bak -pe "s/C\/T/Y/g" temp.str;
perl -i.bak -pe "s/C\/G/S/g" temp.str;
perl -i.bak -pe "s/C\/C/C/g" temp.str;
perl -i.bak -pe "s/N\/N/N/g" temp.str;

