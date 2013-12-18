#!/bin/bash
#============================================================================================#
# Copyright (C) 2013
# Author: Carlos Alberto Umanzor Arguedas <shadow.x07@gmail.com>
#
# Description
# -----------
# This script is a template for those who want to script procedures in bash
# It provides a good start point
#
# NOTE:
# You can edit this section as you please.
#============================================================================================#


#============================================================================================#
# SCRIPT SETTINGS
#============================================================================================#
ISROOTREQUIRED=1 # Use 0 if you want to run it with non-root users
FORCEARGUMENTSREQUIRED=1 # Use 0 if you want to run it without arguments

#============================================================================================#
# Variables
#============================================================================================#
BN=${0##*/}
MYPID=$(echo $$)
CUSTOMVAR='VALUE'

#============================================================================================#
# ERROR CODES
#============================================================================================#
ROOTISREQUIRED=100
NOPARAMETERSPROVIDED=101
CUSTOM_ERROR2=102

#============================================================================================#
# COMMON FUNCTIONS
#============================================================================================#
exit_usage()
{
	ERRCODE=$1
        cat <<HD!
NAME    ${BN}
        Template bash script

SYNOPSIS
        ${BN} --exampleArgument -a number

DESCRIPTION
        --exampleArgument: When present, it will run the exampleFuntion
	-a: number: When present, it will run the exampleFuntion2
EXAMPLE

	${BN} --exampleArgument
	${BN} -a 1

REPORTING BUGS
        Report bugs to Carlos Umanzor <shadow.x07@gmail.com>

COPYRIGHT
        Copyright  2013
HD!
        exit $ERRCODE
} # end exit_usage()


isRoot() # This method check if the current user is root
{
	if [ "root" != "$( whoami )" ] && [ $ISROOTREQUIRED -eq 1 ] ; then
		echo "${BN} must be run as root"
		exit_usage $ROOTISREQUIRED
        fi
}

waitForBackgroundProcessesToFinish(){ 
    # In case you have to wait for some background operation to finish, this method may help
    # Just invoke this method with N pid, and the method will check all processes to finish
    echo " --- Waiting for PID ${@} to finish ---"
    for pid in "$@"; do
        while kill -0 "$pid"; do
            sleep 0.5
        done
    done
}

#============================================================================================#
# Main methods (I recommend to put your methods here, just to keep everyting in order)
#============================================================================================#

exampleFuntion()
{
	echo "example function executed"
}

exampleFuntion2()
{
	echo "example function 2 executed"
	echo $#
}

#============================================================================================#
# Startup code (This section contains logic that occurs before processing the arguments)
#============================================================================================#

# Checking if the script was executed as root (it may disabled by setting ISROOTREQUIRED as 0)
isRoot

# Check if arguments are set (it may disabled by setting FORCEARGUMENTSREQUIRED as 0)
if [ $# -eq 0 ] && [ $FORCEARGUMENTSREQUIRED -eq 1 ]
  then
  	echo "You need to provide parameters"
    	exit_usage $NOPARAMETERSPROVIDED
fi


#============================================================================================#
# Script argument processing
#============================================================================================#

# Logic taken from http://kirk.webfinish.com/?p=45

for arg
do
    delim=""
    case "$arg" in
    #translate --exampleArgument to -e (short options)
       --exampleArgument) args="${args}-e ";;
       #pass through anything else
       *) [[ "${arg:0:1}" == "-" ]] || delim="\""
           args="${args}${delim}${arg}${delim} ";;
    esac
done
 
#Reset the positional parameters to the short options
eval set -- $args
 
while getopts ":ea:" option 2> /dev/null
do
    case $option in
        e) exampleFuntion;;
        a) exampleFuntion2 ${OPTARG[@]};;
        *) echo $OPTARG is an unrecognized option;;
    esac
done


###
# Finish Bash script with Error CODE 0 = Everything is normal
###
exit 0
