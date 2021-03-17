#!/bin/bash

# get file name to convert
if [ $# -eq 0 ]; then
    read -p "Enter name of yaml file: " file_name
else
    file_name=$1
    if [ $# -gt 1 ]
    then
        echo 'Too many input parameters. First parameter was used.'
    fi 
fi

#check weather file exist
if [ -f $file_name ]; then 
    echo "File $file_name found."
else
    echo "File $file_name not found."
    exit -1
fi

#create output.csv file or delete existed
output_file="output.csv"
if [ -f output.csv ]; then
    rm output.csv
    printf "" > $output_file
else
    printf "" > $output_file
fi

#save default IFS
OLD_IFS=$IFS
IFS=$'\n'

i=0
field_count=0
for line in `cat $file_name`
do
    #skip line with "-"
    value=`echo ${line} | cut -d " " -f2`
    if [[ $value = "-" ]]; then 
        continue
    fi

    field_name=`echo ${line} | cut -d ":" -f1`
    if [[ i -eq 0 ]]; then
        first_field_name=$field_name
    fi
    if [ $first_field_name == $field_name ] && [[ i -ne 0 ]]; then 
        break
    fi
    field_name=`echo $field_name | tr -d '[:space:]'`
    # echo $field_name
    ((field_count++))
    printf "$field_name" >> output.csv && printf "," >> output.csv 
    ((i++))
done
echo "" >> $output_file
# echo `cat $file_name` >> output.csv
# res=`sed 's/.$//' $output_file`
# echo $res > $output_file

i=0
for line in `cat $file_name`
do
    if [[ i -eq field_count ]]; then
        printf "\n" >> $output_file
        i=0
    fi

    #skip line with "-" character
    value=`echo ${line} | cut -d " " -f2`
    if [[ $value = "-" ]]; then 
        continue
    fi
    field_value=`echo ${line} | cut -d ":" -f2`
    field_value="${field_value:1}"
    
    line_come=`echo $field_value | grep ","` 
    if [ -z $line_come ]; then
        printf "%s" "$field_value" >> $output_file && printf "," >>$output_file
    else
        printf '"' >> $output_file
        printf "%s" "$field_value" >> $output_file 
        printf '"' >> $output_file && printf "," >> $output_file
    fi
    ((i++)) 
done


# for line in `cat $output_file`
# do
#     res+=${line::-1}
#     res+="\n"
#     printf $res > $output_file
# done

# return default value IFS 
IFS=$OLD_IFS