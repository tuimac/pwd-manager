#!/bin/bash

function config_variable(){
    if [ $# -ne 2 ]; then
        echo 'Need the arguments which are PJT_ROOT_DIR and PORT.'
        exit 1
    fi
    PJT_ROOT_DIR=$1
    PORT=$2
}

function run_flutter() {
    cd $PJT_ROOT_DIR
    flutter run -d web-server --web-hostname=0.0.0.0 --web-port=$PORT
}

function main() {
    config_variable $1 $2
    run_flutter
}


main $1 $2
