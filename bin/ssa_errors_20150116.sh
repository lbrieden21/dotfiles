#!/bin/bash
for tid in `grep ERM3038 etsweb0[1234]*xml_received.log* | grep '16 Jan' | sort -k3 | grep -o '<transactionID>[0-9]\{16\}' | grep -o '[0-9]\{16\}'`
do
	echo "$tid - "
	grep ERM3038 etsweb0[1234]*xml_recieved.log* | grep '16 Jan' | sort -k3 | grep $tid | grep -o 'STN[0-9]\{5\}[A-Z]\|APCN-[0-9][0-9][0-9][0-9]'
done
