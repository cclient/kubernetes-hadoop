#!/bin/bash

/etc/init.d/ssh start

if [[ $1 == "bash" ]]; then
  echo " "
  echo -e "\e[01;32m*\e[00m `date` \e[01;32mShell Bash\e[00m"
  /bin/bash
fi

sleep 31557600
