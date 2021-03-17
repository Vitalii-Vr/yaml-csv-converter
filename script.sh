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
    echo "File $file_name has found."
else
    echo "File $file_name hasn't found."
    exit -1
fi

#create output.csv file or delete existed with the same name
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
for line in `cat $file_name` #process header of file
do
    if [[ $line =~ [a-zA-Z] ]]; then  #skip line without letters
        field_name=`echo ${line} | cut -d ":" -f1` #get first column 
        if [[ i -eq 0 ]]; then # save first field value at first iteration
            first_field_name=$field_name
        fi

        if [ $first_field_name == $field_name ] && [[ i -ne 0 ]]; then  #exit loop if the same field value repeat
            res=`sed 's/.$//' $output_file`
            printf $res > $output_file
            break
        else #continue loop
            field_name+=","
            ((i++))
        fi
        field_name=`echo $field_name | tr -d '[:space:]'` #delete space in field value
        printf "$field_name" >> output.csv 
    fi
done
echo "" >> $output_file

field_count=$i #save count of field
i=0
for line in `cat $file_name` #process field value
do
    if [[ i -eq field_count ]]; then  #newline 
        printf "\n" >> $output_file
        i=0
    fi

    if [[ $line =~ [a-zA-Z] ]]; then #skip line without letters
        if [[ i -ne 0 ]]; then #if neither line without letters and nor last line then add coma
            printf "," >> $output_file
        fi
        field_value=`echo ${line} | cut -d ":" -f2` #get second column 
        field_value="${field_value:1}" #drop first space at line
        
        line_come=`echo $field_value | grep ","` #separate line with coma inside value
        if [ -z $line_come ]; then #nor come inside value
            printf "%s" "$field_value" >> $output_file
        else #come inside value
            printf '"' >> $output_file
            printf "%s" "$field_value" >> $output_file 
            printf '"' >> $output_file 
        fi
        ((i++)) 
    fi
done

echo "Output file $output_file has been created."

# return default value IFS 
IFS=$OLD_IFS