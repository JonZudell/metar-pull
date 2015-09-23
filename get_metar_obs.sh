#!/bin/bash
startdate=$1
enddate=$2

dates=()
hour_dates=()
for (( date="$startdate"; date != enddate; )); do
    dates+=( "$date" )
    date="$(date --date="$date + 1 days" +'%Y%m%d')"

    for i in {00..23}; do 
        hour_dates+=(${dates[-1]}_"$i"00) 
    done
done

for hour in ${hour_dates[@]}; do
    wget --output-document=/climate/data/metar/$hour-metar.dat "https://madis-data.ncep.noaa.gov/madisPublic1/cgi-bin/madisXmlPublicDir?rdr=&time="$hour"_0000&minbck=-59&minfwd=0&recwin=3&dfltrsel=0&state=AK&latll=0.0&lonll=0.0&latur=90.0&lonur=0.0&stanam=&stasel=0&pvdrsel=0&varsel=1&qcsel=99&xml=4&csvmiss=1&nvars=RAWMTR"
    wait
done
