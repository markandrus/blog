---
title: Timesheet Script
layout: post
date: 2011-05-23 11:33:41
---
While switching from task to task at work–whether it be advising someone on how to send a Word document via email, or doing *real* work (like adding forgotten quotation marks to HTML element attributes)-I often kept track of the time I’d wasted in a sticky note on my desktop.
For anyone unaware, the Mac OS X operating system comes preinstalled with a butt-ugly sticky note application called <a href="http://en.wikipedia.org/wiki/Stickies_(software)">*Stickies*</a>. It’s just a little less shitty than the sticky-notes widget you can find in Exposé.
Anyways, since I’m trying to cozy up to `gnuplot`, and since I can already imagine a beautiful surface plot of my timesheet data-with rows representing weeks of the year, columns representing days, peaks mapping out the hours I’ve worked, etc.-I decided I would finally write a Bash script to keep track of this data in a simple, tab-separated, “`gnuplot`-ready” file.

### Time to start caring
So here she is. Eventually I will add some nice options for summing up hours spent in a day using `awk`, some kind of menu system for querying individual days, and then options for generating beautiful output graphs via `gnuplot`.
{% highlight sh %}
#!/bin/bash
timesheet='timesheet.log'
today=`date "+%a %D"`
seconds=`date +%S`
clock=`date -v-${seconds}S +%H:%M`
create_today=`grep <$timesheet "$today" | wc -l`
case $1 in
	'')
		echo "USAGE: $0 {job}"
		echo "EXAMPLE: $0 overhead"
		exit
		;;
	'in')
		if [ $create_today == '0' ]; then
			echo -e "\n\n# $today" >>$timesheet
		fi
		echo -e "$clock\t\t*in*" >>$timesheet
		;;
	'out')
		echo -e "$clock\t\t*out*" >>$timesheet
		;;
	*)
		time_diff=''
		last_clock=`tail -n 1 $timesheet`
			last_hour=${last_clock:0:2}
			last_min=${last_clock:3:2}
		adjustment="-v-${last_hour}H -v-${last_min}M -v-${seconds}S"
		time_diff=`date $adjustment +%H:%M`
		echo -e "$clock\t[$time_diff]\t$1" >>$timesheet
		;;
	esac
tail -n 1 $timesheet
{% endhighlight %}

### Usage
Just do something like:
{% highlight sh %}
$ ./log.sh in
$ ./log.sh task1
$ ./log.sh task2
$ ./log.sh out
{% endhighlight %}

*It's that simple!*

### Results
The end result is a nice file detailing the hours you’ve spent sitting in front of your computer:

{% highlight sh %}
# Fri 04/29/11 
14:03		*in*
14:12	[00:09]	overhead
14:46	[00:34]	job-1
16:36	[01:50]	task-2
16:41	[00:05]	overhead
17:28	[00:47]	chore-3
17:39	[00:11]	timesheet
17:40		*out*

# Mon 05/02/11
# SICK

# Wed 05/04/11
13:13		*in*
14:56	[01:43]	job-1
15:06	[00:10]	task-2
15:39	[00:33]	job-1
16:05	[00:26]	task-2
16:32	[00:27]	chore-3
16:38	[00:06]	overhead
17:05	[00:27]	job-1
17:05		*out*
{% endhighlight %}
Hooray!
