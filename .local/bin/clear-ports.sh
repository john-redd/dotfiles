#!/bin/bash

ports=('3333' '3334' '3335' '3336' '3337' '3338' '3339' '3340' '9000')

for zone in "${ports[@]}"
do
  lsof -t -i :$zone | xargs kill
done

