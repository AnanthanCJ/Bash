args () {

  if [ -z "$1" ];
  then 
    echo "No argument given " >&2
    return 1

  else
    echo "Hello, "$1""
    if [[ "$name" =~ "^[a-z]+$" ]]
    then   echo "Tip: Try Capitalizing your name next time"
    fi
  fi
}

args $@
