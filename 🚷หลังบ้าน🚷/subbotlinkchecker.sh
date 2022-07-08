#!/bin/bash

#COOKIEID="47"
LINEHAUL="$1"
#CORELINK="$1"

#MAINLINK=`grep "MAINLINK$1" ./subbotlinehaul.conf`
#MAINLINK=${MAINLINK##*MAINLINK$1=}

CORELINK=`grep "CORELINK$1" ./subbotlinehaul.conf`
CORELINK=${CORELINK##*CORELINK$1=}

#โมดูลรับค่ารหัสคำตอบในลิงค์จริง
for (( i = 1 ; i <= 8000; i++ ))
do
	#โมดูลรันข้อมูลลิงค์จริง
	IP=74.125.197.$(($RANDOM%77 + 90))
	#LINKDATA=`curl --max-redirs 0 --basic --max-time 3 --insecure --resolve docs.google.com:443:$IP --ipv4 --silent "$MAINLINK/viewform" -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:95.0) Gecko/20100101 Firefox/95.0' -H "$COOKIE"`
	LINKDATA=`curl --max-redirs 0 --basic --max-time 3 --insecure --ipv4 --silent "https://docs.google.com/forms/d/e/$CORELINK/viewform" -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:95.0) Gecko/20100101 Firefox/95.0'`
	#LINKDATA=`cat KMLC.txt`
	#LINKDATA=`wget -qO- "https://docs.google.com/forms/d/e/$CORELINK/viewform"`
	#LINKDATA=`wget -qO- "https://docs-google-com.translate.goog/forms/d/e/$CORELINK/viewform?_x_tr_sl=en&_x_tr_tl=th&_x_tr_hl=th"`
	LINKDATASTATUS=`echo $LINKDATA | grep -c "ทรานสปอร์ต"`
	#echo $LINKDATASTATUS
		if (( $LINKDATASTATUS >= 1 )); then
		linkopenmsg="ได้รับข้อมูลลิงค์เวลา "$(date)
		LINKOPENLOG=`echo $linkopenmsg | tee -a ./subbot.log`

		COREDATA=`sed -n 9p <<< "$LINKDATA"`
		COREDATA=$( sed 's/.*PUBLIC\(.*\?\)version.*/\1/' <<< "$COREDATA" )


		#LINKDATACHECK2=`echo $LINKDATA | grep -c "อะไร"`
		#if (( $LINKDATACHECK2 >= 1 )); then
		#	linkcheck2msg="ลิงค์มีคำถามกันบอท "$(date)
		#	LINKCHECK2LOG=`echo $linkcheck2msg | tee -a ./subbot.log`
		#	LINKCHECK2ONLINELOG=`wget -q --no-cache --spider "https://docs-google-com.translate.goog/forms/d/e/1FAIpQLSem1LiRHBaM0lBvgtx8cGfejB1j6_zIpNkMkbJRVJ47S_ahEg/formResponse?entry.317877501=$1&entry.300038431=$linkcheck2msg&_x_tr_sl=en&_x_tr_tl=th&_x_tr_hl=th&_x_tr_pto=nui,elem"`
		#	exit 0
		#fi

		LINKDATACHECK3=`echo $LINKDATA | grep -c "คำตอบของคุณ"`
		if (( $LINKDATACHECK3 > 3 )); then
			linkcheck3msg="ลิงค์มีช่องใส่คำตอบมากกว่า 3 "$(date)
			LINKCHECK3LOG=`echo $linkcheck3msg | tee -a ./subbot.log`
			LINKCHECK3ONLINELOG=`wget -q --no-cache --spider "https://docs-google-com.translate.goog/forms/d/e/1FAIpQLSem1LiRHBaM0lBvgtx8cGfejB1j6_zIpNkMkbJRVJ47S_ahEg/formResponse?entry.317877501=$1&entry.300038431=$linkcheck3msg&_x_tr_sl=en&_x_tr_tl=th&_x_tr_hl=th&_x_tr_pto=nui,elem"`
			exit 0
		fi

		LINKDATACHECK4=`echo $LINKDATA | grep -c "เลือก"`
		if (( $LINKDATACHECK4 > 2 )); then
			linkcheck4msg="ลิงค์มีตัวเลือกคำตอบมากกว่า 2 "$(date)
			LINKCHECK4LOG=`echo $linkcheck4msg | tee -a ./subbot.log`
			LINKCHECK4ONLINELOG=`wget -q --no-cache --spider "https://docs-google-com.translate.goog/forms/d/e/1FAIpQLSem1LiRHBaM0lBvgtx8cGfejB1j6_zIpNkMkbJRVJ47S_ahEg/formResponse?entry.317877501=$1&entry.300038431=$linkcheck4msg&_x_tr_sl=en&_x_tr_tl=th&_x_tr_hl=th&_x_tr_pto=nui,elem"`
			exit 0
		fi
		
		QUESTIONDATACLEAR=`rm ./questiondata.txt`

		#ตัดส่วนที่ไม่จำเป็นออก
		#LINKDATA=${LINKDATA##*viewform?usp=embed_facebook}
		#LINKDATA=${LINKDATA:24297:50000}

		#LINKDATA=${LINKDATA%reportabuse?source*}
		#LINKDATA=$( sed 's/.*viewform?usp=embed_facebook\(.*\?\)reportabuse?source.*/\1/' <<< "$LINKDATA" )

		USERLINKID=$( sed 's/.*"ทะเบียนรถ",null\(.*\?\)789]+.*/\1/' <<< "$COREDATA" )
		USERLINKID=${USERLINKID%,null,1*}
		USERLINKID=${USERLINKID##*,\[\[}

		AREALINKID=$( sed 's/.*"พื้นที่",null\(.*\?\)"BKK.*/\1/' <<< "$COREDATA" )
		AREALINKID=${AREALINKID%,\[\[*}
		AREALINKID=${AREALINKID##*,\[\[}

		COMPANYLINKID=$( sed 's/.*"บริษัท",null\(.*\?\)ทรานสปอร์ต.*/\1/' <<< "$COREDATA" )
		COMPANYLINKID=${COMPANYLINKID%,\[\[\"*}
		COMPANYLINKID=${COMPANYLINKID##*,\[\[}

		DRIVERLINKID=$( sed 's/.*"ชื่อพนักงานขับรถ",null\(.*\?\)กขฃค.*/\1/' <<< "$COREDATA" )
		DRIVERLINKID=${DRIVERLINKID%,null,1*}
		DRIVERLINKID=${DRIVERLINKID##*,\[\[}

		PHONELINKID=$( sed 's/.*"เบอร์โทรศัพท์",null\(.*\?\)"เบอร์โทรศัพท์ไม่ถูกต้อง".*/\1/' <<< "$COREDATA" )
		PHONELINKID=${PHONELINKID%,null,1,null*}
		PHONELINKID=${PHONELINKID##*,\[\[}

		ANSWERLINKDATA=$( sed 's/.*ตอบทุกครั้ง"]\(.*\?\)ลงคิวเรียบร้อย.*/\1/' <<< "$COREDATA" )
		#ANSWERLINKID=${ANSWERLINKID%,\"*}
		#ANSWERLINKID=${ANSWERLINKID%,\"*}
		ANSWERLINKID=${ANSWERLINKDATA##*,\[\[}
		ANSWERLINKID=${ANSWERLINKID%,null,1*}

		#ANSWERDATA=${ANSWERLINKDATA%\",null,-3*}
		#ANSWERDATA=${ANSWERDATA##*\[\"}

		ANSWERDATASAVE=`echo $ANSWERLINKDATA | tee -a ./questiondata.txt`

		#echo $COREDATA
		#echo $ANSWERDATA
		#echo $ANSWERLINKID
		echo $USERLINKID" "$AREALINKID" "$COMPANYLINKID" "$DRIVERLINKID" "$PHONELINKID" "$ANSWERLINKID
		
		#killall subbotlinkchecker.sh*
		exit 0 
	fi
done