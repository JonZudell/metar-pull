#!/bin/bash
startdate=$1
enddate=$2

dates=()
hour_dates=()
for (( date="$startdate"; date != enddate; )); do
    dates+=( "$date" )
    date="$(date --date="$date + 1 days" +'%Y%m%d')"

    pids=()
    for i in {00..23}; do 
        hour=(${dates[-1]}_"$i"00) 
        dest_file=/climate/data/metar/$hour-metar.dat
        wget -q --output-document=$dest_file "https://madis-data.ncep.noaa.gov/madisPublic1/cgi-bin/madisXmlPublicDir?rdr=&time="$hour"_0000&minbck=-59&minfwd=0&recwin=3&dfltrsel=0&state=AK&latll=0.0&lonll=0.0&latur=90.0&lonur=0.0&stanam=&stasel=0&pvdrsel=0&varsel=1&qcsel=99&xml=4&csvmiss=1&nvars=RAWMTR" &
        pids+=( "$!" )
    done
    for pid in ${pids[@]}; do
        wait $pid
    done
done
