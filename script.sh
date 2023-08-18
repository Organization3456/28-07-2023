#!/bin/bash
# find /var/lib/jenkins/jobs/pipeline-for-slack-testing/builds/ -name "*log" -mtime -1 | xargs ls -l | awk '{print $9}' | cut -d "/" -f 8
jwd="/var/lib/jenkins/jobs"
#oneDay=`find . -name "*log" -mtime -1`
#job builds directory
jb="$jwd/pipeline-for-slack-testing/builds"
oneDay="find $jb/ -name "*log" -mtime -1"
#sudo $oneDay $wd/$job >> oneday.txt
sudo $oneDay | xargs ls -l > oneday.txt
for i in $(awk '{print $9}' oneday.txt); do
        #jbl="$i | awk '{print $9}'"
        echo "buil number is $(echo "$i" | cut -d "/" -f 8) and it's status is $(tail -n 1 $i | cut -d ":" -f 2)" >> tempStatus.txt
done

#counting build success rate
suc=`grep -c "SUCCESS" tempStatus.txt`
total=`wc -l oneday.txt | awk '{print $1}'`
rate=`echo "scale=2; $suc / $total * 100" | bc`
echo "total build triggers are $total" >> tempStatus.txt
echo "success rate is $rate" >> tempStatus.txt
