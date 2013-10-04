#!/bin/ksh
# ymd2yd converts yyyymmdd to yyyyddd
# usage ymd2yd 19980429

#yeardays function
yeardays ( ) {
# return the number of days in a year
# usage yeardays yyyy
	
# if there is no argument on the command line, then assume that a"
# yyyy is being piped in
	
	if [ $# = 0 ]
	then
	read y
	else
	y=$1
	fi
	
	# a year is a leap year if it is even divisible by 4
	# but not evenly divisible by 100
	# unless it is evenly divisible by 400
	
	# if it is evenly divisible by 400 it must be a leap year
	a=`expr $y % 400`
	if [ $a = 0 ]
	then
	echo 366
	exit
	fi
	
#if it is evenly divisible by 100 it must not be a leap year
	a=`expr $y % 100`
	if [ $a = 0 ]
	then
	echo 365
	exit
	fi
	
# if it is evenly divisible by 4 it must be a leap year
	a=`expr $y % 4`
	if [ $a = 0 ]
	then
	echo 366
	exit
	fi
	
# otherwise it is not a leap year
	echo 365

}

#monthdays function
monthdays( ) {
# calculates the number of days in a month 
# usage monthdays yyyy mm
# or monthdays yyyymmdd
	
# if there are no command line arguments then assume that a yyyymmdd is being
# piped in and read the value.
# if there is only one argument assume it is a yyyymmdd on the command line
# other wise it is a yyyy and mm on the command line

	if [ $# = 0 ]
	then
		read ymd
	elif [ $# = 1 ] 
		then
		ymd=$1
	else
		ymd=`expr \( $1 \* 10000 \) + \( $2 \* 100 \) + 1`
	fi

# extract the year and the month
	
	y=`expr $ymd / 10000` ;
	m=`expr \( $ymd % 10000 \) / 100` ;
	
	
# 30 days hath september etc.
	case $m in
	1|3|5|7|8|10|12) echo 31 ; exit ;;
	4|6|9|11) echo 30 ; exit ;;
	*) ;;
	esac
	
# except for month 2 which depends on whether the year is a leap year
# Use yeardays to get the number of days in the year and return a value
# accordingly.
	diy=`yeardays $y`
	
	case $diy in
	365) echo 28 ; exit ;;
	366) echo 29 ; exit ;;
	esac

}



ymd2yd() {

# if there is no command line argument, then assume that the date"
# is coming in on a pipe and use read to collect it
	
	if [ $# = 0 ]
	then
	read dt
	else
	dt=$1
	fi
	
# break the yyyymmdd into separate parts for year, month and day"
	
	y=`expr $dt / 10000`
	m=`expr \( $dt % 10000 \) / 100`
	d=`expr $dt % 100`
	
# add the days in each month up to (but not including the month itself)
# into the days. For example if the date is 19980203 then extract the
# number of days in January and add it to 03. If the date is June 14, 1998"
# then extract the number of days in January, February, March, April and May"
# and add them to 14.
	
	x=1
	while [ `expr $x \< $m` = 1 ]
	do
	md=`monthdays $y $x`
	d=`expr $d + $md`
	x=`expr $x \+ 1`
	done
	
# combine the year and day back together again and you have the julian date.
	
	jul=`expr \( $y \* 1000 \) + $d`
	echo $jul
}

usage () {
	 echo "Usage:"
	 echo " juldif jul1 jul2"
	 echo ""
	 echo " Calculates the day difference between"
	 echo " two julian dates (jul1 -jul2)"
	 echo " where a julian date is in the form of yyyyddd."
 }

 juldiff () {
	if [ $# != 2 ]
 	then
	   usage
 	   exit
 	fi
 
# This process subtracts arg2 from arg1. If arg2 is larger
# then reverse the arguments. The calculations are done, and
# then the sign is reversed
 	if [ `expr $1 \< $2` = 1 ]
 	then
 		echo "if"
 	jul1=$2
 	  jul2=$1
 	else
 		jul1=$1
 		jul2=$2
 	  fi
 
# Break the dates in to year and day portions
 	yyyy1=`expr $jul1 / 1000`
 	yyyy2=`expr $jul2 / 1000`
 	ddd1=`expr $jul1 % 1000`
 	ddd2=`expr $jul2 % 1000`
 
# Subtract days
 	res=`expr $ddd1 - $ddd2`
 
# Then add days in year until year2 matches year1
 	while [ `expr $yyyy2 \< $yyyy1` = 1 ]
	do
 	  diy=`yeardays $yyyy2`
 	  res=`expr $res + $diy`
	  yyyy2=`expr $yyyy2 + 1`
 	done
 
# if argument 2 was larger than argument 1 then 
# the arguments were reversed before calculating
# adjust by reversing the sign
 	if [ `expr $1 \< $2` = 1 ]
 	then
	 res=`expr $res \* -1`
	fi
 
# and output the results
 	echo $res
}


#!/bin/sh

check_number() {

n="$1"
val1=1	
#re='^[0-9]+$'

	if test "$n" -gt 0 
		then	val1=0
	else
		val1=1
	fi

echo $val1

}

# Define your function here
Run_reten () {
#   echo "Hello World $1 "

#$output = "output"
cd "$1"
#echo `pwd`
for dir in `ls -l  |grep  '^d' | awk '{ print $9 }'`
    do
          cd "$1/${dir}"
        #echo "Dir:"${dir}
	echo "Directory:"`pwd` 
        #echo "Dir:"${dir}

	#Run_reten $1/${dir}
	valid_reten=1
	#echo `ls -1`
	#output=`echo ${dir} |cut -c1-10 ` 
	#echo $output
	year=`echo ${dir} |cut -c1-4`
	
	#echo "Year:"$year
	month=`echo ${dir} |cut -c6-7`
	mday=`echo ${dir} |cut -c9-10`
	
	#echo "Year:"$year" month:"$month " day:"$mday
	valid_year=`check_number $year`
	#echo "Valid Year:"$valid_year

	if test "$mday" -lt 32 -a "$mday" -gt 0
		then	valid_reten=0
	else
		valid_reten=1
	fi
	
	if test "$month" -lt 13 -a "$month" -gt 0
		then	valid_reten=0
	else
		valid_reten=1
	fi

	#echo "Valid Retention:"$valid_reten

	if  test  "$valid_reten" -eq 0  
		then	echo "directory valid Retention"
		datef=`echo ${dir}|cut -c 1-4`
		datef=$datef`echo ${dir}|cut -c 6-7`
		datef=$datef`echo ${dir}|cut -c 9-10`
		dateone=`ymd2yd $datef`
		echo "File Date:"$dateone "Current Date:"$curdate
		
		balance=`juldiff $curdate $dateone`

		echo "Balance:"$balance

		if test "$balance" -gt 31
			then echo "rm -rf "`pwd` >> /root/test/rmtest
			#echo  "CP -R "`pwd`  "`pwd`"bkp"
		fi

	 else
	       echo "directory not  valid"
	fi  


	
	#if [ "$dir" = "true" ] then
       # cd ..
       Run_reten $1/${dir}
    done
	cd ..
}

curdate=`date '+%Y%m%d'`
curdate=`ymd2yd $curdate`

Run_reten /root/test

#filedate="2013-10-03"
#datef=`echo $filedate|cut -c 1-4`
#datef=$datef`echo $filedate|cut -c 6-7`
#datef=$datef`echo $filedate|cut -c 9-10`
#echo $datef

curdate=`date '+%Y%m%d'`
#echo "Current Date:"$curdate
dateone="20131222"
#echo "File Date:"$dateone

dateone=`ymd2yd $dateone`
curdate=`ymd2yd $curdate`

#echo "firstdate:$curdate"
#echo "seconddate:$dateone"

balance=`juldiff $curdate $dateone`

#echo "Balance:$balance"

if test "$balance" -gt 30 
	then	echo "POSITIVE"
else
	echo "Negative"
fi

