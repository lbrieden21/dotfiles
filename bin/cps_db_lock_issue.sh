#!/bin/bash

studids=`grep -A5 --color=never 'Query Failed: Lock' $PRODLOGS/web0[1234]*error* | grep -A2 --color=never 'INSERT INTO Transactions' | grep --color=never 'VALUES' | grep -o --color=never '[0-9]\+,$' | tr -d , `

for sid in $studids
do
	grep $sid /chroot/ets_ect_live/home/ets_ect_live/archive/*TXEACPS*.log
done
