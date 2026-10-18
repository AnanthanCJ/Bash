printer() 
{
counter="$1"
while [[ "$counter" -ge 1 ]];
  do
     echo "$counter"
     if [[ "$counter" -eq 1 ]];
     then echo "Liftoff!"

     fi;
     counter=$(( counter - 1 ))
  done
 }

printer "$1"
