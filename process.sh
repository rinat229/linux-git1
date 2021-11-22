cat $1 | awk -F, '
{if ($18 >= 0) x+=$18; if ($18 >= 0) num+=1}
END{print "RATING_AVG", x/num}'
v=`cat $1 | awk -F, '{split($1, countries, "_"); countries1 = countries[1]; print countries1}' | sort -u | tr ' ' '\n' | sort -u | tr '\n' ' '`

for i in $v
do
    printf "HOTELNUMBER $i " ; cat $1 | awk -F, '{print $1}' | grep -c ^$i
done
countrieswithholinn=`cat $1 | grep -E "holiday_inn" `
countrieswithhilton=`cat $1 | grep -E "hilton" `
v=`cat $1 | awk -F, '{split($1, countries, "_"); countries1 = countries[1]; print countries1}' | sort -u | tr ' ' '\n' | sort -u | tr '\n' ' '`
for i in $v
do
    holinn=`echo "${countrieswithholinn}" | grep -E ^"${i}" | awk -F, '{  x+=$12} END{print x/NR, x}'`
    hilton=`echo "${countrieswithhilton}" | grep -E ^"${i}" | awk -F, '{  x+=$12} END{print x/NR, x}'`
    printf "CLEANLINESS $i $holinn $hilton \n"
done
