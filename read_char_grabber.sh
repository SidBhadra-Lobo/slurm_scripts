#!/bin/bash -l
FILE=$( less bashtestfile_2.txt ); 
SNP=301; #position of snp in sequence.
# range_left=251;
# range_right=351;

 for file in "$FILE";
 do
	headers=$( echo "$file" | grep "^>"); #Grab header
    reads=$( echo "$file" | grep "^[ATCGNatcgn]" ); #Grab read

    array1=($reads); 


   for seq in "${!array1[@]}"; # loop through indexes, specifed as !array...
    do

            echo "array1 postion: $seq";
            echo "array1 sequence: ${array1[$seq]}";

            string=$( echo ${array1[$seq]} | sed -e 's/\(.\)/\1" "/g' | sed -e 's/^/"/' | sed -e 's/.$/ /g' ); # pipe current read to sed for 1) add quotes are around every space, 2) add a quote in front of the first char, 3) add a space as the last char.   
            
            echo "string values look like: $string";

            array2=($string);

           for pos in "${!array2[@]}";
            do
                if [[ "$pos" -eq "$SNP" ]]; 
                then 

                    echo "array2 SNP postion: $pos";
                    echo "array2 SNP nucleotide: ${array2[$pos]}";

                    noquotes=$( echo "${array2[$pos]}" | sed 's/"//g' )

                    if [[ "$noquotes" = "T" ]];
                    then
                    newpos=$( echo "${array2[$pos]}" | sed 's/"[ATCG]"/\"\[T\/whatever\]\"/g' );
                    # echo "$newpos";
                    fi

                    if [[ "$noquotes" = "C" ]];
                    then
                    newpos=$( echo "${array2[$pos]}" | sed 's/"[ATCG]"/\"\[C\/whatever\]\"/g' );
                    # echo "$newpos";
                    fi   


                    if [[ "$noquotes" = "G" ]];
                    then
                    newpos=$( echo "${array2[$pos]}" | sed 's/"[ATCG]"/\"\[G\/whatever\]\"/g' );
                    # echo "$newpos";
                    fi     


                    if [[ "$noquotes" = "A" ]];
                    then
                    newpos=$( echo "${array2[$pos]}" | sed 's/"[ATCG]"/\"\[A\/whatever\]\"/g' );
                    # echo "$newpos";
                    fi         

                    array2[301]="$newpos";
                    
                    echo "replaced at postion: $pos";
                    echo "new base: ${array2[$pos]}"; 
                
                fi;

            done;   

        region=("${array2[@]:252:99}");

        output=$( echo "${region[@]}" | sed 's/"//g' | sed 's/ //g' );

        echo "output sequence containing SNP: "$output" ";

 
    done; 
        

done;
############\n 

