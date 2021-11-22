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
    holinn=`echo "${countrieswithholinn}" | grep -E ^"${i}" | awk -F, '{  if($12 > 0) x+=$12; if ($12 > 0) num+=1} END{print x/num}'`
    hilton=`echo "${countrieswithhilton}" | grep -E ^"${i}" | awk -F, '{  if($12 > 0) x+=$12; if ($12 > 0) num+=1} END{print x/num}'`
    printf "CLEANLINESS $i $holinn $hilton \n"
done
mkdir tmp
cat hotels.csv | awk -F, '{if($18>=0) print $0}' > tmp/hotels_right.csv
gnuplot <<- EOF
set terminal png size 300, 400
set output 'c_vs_o.png'
set datafile separator comma
plot 'hotels_right.csv' using 12:18 title 'clean_vs_overall' with points
f(x)=m*x+b
fit f(x) 'hotels.csv' using 12:18 via m,b
set output 'c_vs_o.png' 
plot 'hotels_right.csv' using 12:18 title 'cleaafsf' with points, f(x) title 'fit'
EOF