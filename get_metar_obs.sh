#!/bin/bash
startdate=$1
enddate=$2

for (( date="$startdate"; date != enddate; )); do
    date="$(date --date="$date + 1 days" +'%Y%m%d')"
    files=()
    pids=()
    for i in {00..23}; do 
        year=${date:0:4}
        month=${date:4:2}
        day=${date:6:2}
        hour=("$date"_"$i"00) 
        dest_file=/climate/data/metar/$hour.dat.gz
        if ! [ -s $dest_file ]
        then
            #https://madis-data.ncep.noaa.gov/madisPublic1/data/archive/2001/07/01/point/metar/netcdf/
            wget -q --output-document=$dest_file "https://madis-data.ncep.noaa.gov/madisPublic1/data/archive/"$year"/"$month"/"$day"/point/metar/netcdf/"$hour".gz" &
            pids+=( "$!" )
            files+=( "$dest_file" )
        fi
    done
    for pid in ${pids[@]}; do
        wait $pid
    done
    status=false
    for f in ${files[@]}; do
        if [ -s $f ]
        then
            status=true
        fi
    done
    if $status
    then
        date="$(date --date="$date - 1 days" +'%Y%m%d')"
    fi
done
