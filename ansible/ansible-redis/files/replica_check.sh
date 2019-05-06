#!/bin/bash

for i in {1..5};
 do
  sleep 10;

   SERVER=192.168.14.70
   PORT=6379
   result=$(ping -c 2 -W  1 -q $SERVER | grep transmitted)
   pattern="0 received"
   if [[ $result =~ $pattern ]];
        then redis-cli -a Password123 SLAVEOF NO ONE
   fi
   S1=$(redis-cli -a Password123 info replication | grep role:master)
   S2=$(redis-cli -a Password123 info replication | grep role:slave)
   S3=$(redis-cli -h 192.168.14.70 -p 6379 -a Password123 info replication | grep role:master)
   state=`nmap -p $PORT $SERVER | grep "$PORT" | grep open`

  if [ -z "$state" ];
   then
    echo "Port closed"

      if [ -z "$S1" ] ;
       then
         echo "Not master"
         redis-cli -a Password123 SLAVEOF NO ONE
       else
         echo "Master"
      fi

   else

      if [ -z "$S2" ] ;
       then

         if [ -z "$S3" ] ;
           then
             echo "OK master"
           else
            echo "Not Slave"
            service redis restart
         fi

       else

         if [ -z "$S3" ] ;
           then
             echo "OK Slave 1"
             redis-cli -a Password123 SLAVEOF NO ONE
           else
            echo "Not Master"
            service redis restart
         fi

      fi

    echo "Port open"
  fi

done

exit 0

