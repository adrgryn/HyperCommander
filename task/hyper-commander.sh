#! /usr/bin/env bash
echo "Hello" $USER"!"
echo ""
while true; do
    echo "------------------------------"
    echo "| Hyper Commander            |"
    echo "| 0: Exit                    |"
    echo "| 1: OS info                 |"
    echo "| 2: User info               |"
    echo "| 3: File and Dir operations |"
    echo "| 4: Find Executables        |"
    echo "------------------------------"

    read -r option

    if [[ "$option" = 0 ]]; then
	echo "Farewell!"
	break
    elif [[ "$option" = 1 ]]; then
	os_info=$(uname -s)
	node_name=$(uname -n)
	echo "host-name $node_name/$os_info"
    elif [[ "$option" = 2 ]]; then
	user_info=$(whoami)
	echo "$user_info"

    elif [[ "$option" = 3 ]]; then
	while true; do

            echo "The list of files and directories:"
            arr=(*)
            for item in "${arr[@]}"; do
                if [[ -f "$item" ]]; then
                    echo "F $item"
                elif [[ -d "$item" ]]; then 
                    echo "D $item"
                fi
	    done
            echo "---------------------------------------------------"
            echo "| 0 Main menu | 'up' To parent | 'name' To select |"
            echo "---------------------------------------------------"

	    read -r sub_option
	    
	    if echo "${arr[@]}" | grep -wq "$sub_option"; then
                  for item in "${arr[@]}"; do
                  	if [ "$item" == "$sub_option" ]; then
                  	    if [[ -d "$sub_option" ]]; then
                  	    	cd "$sub_option" || exit 1
                  	    	echo ""
                  	    	echo "The list of files and directories:"
                  	    	arr1=(*)
                  	    	for item in "${arr1[@]}"; do
                		    if [[ -f "$item" ]]; then
                    		         echo "F $item"
                		    elif [[ -d "$item" ]]; then 
                                        echo "D $item"
                                    fi
	    			done

	    		    elif [[ -f "$sub_option" ]]; then
	    		    	while true; do
	    			    echo "---------------------------------------------------------------------"
	    			    echo "| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"
	    			    echo "---------------------------------------------------------------------"
	    			    read -r user_input
	    			    if [ "$user_input" == 1 ]; then
	    			        rm "$sub_option"
	    			        echo $sub_option "has been deleted."
	    			        break
	    			    elif [ "$user_input" == 2 ]; then
	    			        echo "Enter the new file name:"
	    			        read -r new_file_name
	    			        mv "$sub_option" "$new_file_name"
	    			        echo $sub_option "has been renamed as" $new_file_name
	    			        break
				    elif [ "$user_input" == 3 ]; then
				        chmod u=rw,g=rw,o=rw "$sub_option"
				        echo "Permissions have been updated."
				        ls -l "$sub_option"
				        break
				    elif [ "$user_input" == 4 ]; then 
				        chmod u=rw,g=rw,o=r "$sub_option"
				        echo "Permissions have been updated."
				        ls -l "$sub_option"
				        break
				    fi
				done
	    		     fi
	    		fi
	    	  done		    	
	    elif [[ "$sub_option" == "up" ]]; then
	        cd ..
                arr2=(*)
                for item in "${arr2[@]}"; do
                    if [[ -f "$item" ]]; then
                    	echo "F $item"
                    elif [[ -d "$item" ]]; then 
                        echo "D $item"
                    fi
	    	done

	    elif [[ "$sub_option" = 0 ]]; then
                 break
            else
            	echo "Invalid input!"
            fi
	 
	done 
	
    elif [[ "$option" = 4 ]]; then
	echo "Enter an executable name:"
	read -r excecutable_name
	if command -v "$excecutable_name" > /dev/null; then
	    executable_location=$(which "$excecutable_name")
	    echo "Located in: $executable_location"
	    
	    echo "Enter arguments:"
	    read -r arguments
	    
	    "$executable_location" $arguments
	    
	else
	    echo "The executable with that name does not exist!:"
	fi
    else
	echo "Invalid option!"
    fi
done

