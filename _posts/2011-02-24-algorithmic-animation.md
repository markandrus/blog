---
title: Algorithmic Animation
layout: post
date: 2011-02-24 17:32:12
---
I started the code that would ultimately generate the video below on Christmas, 2009, at my cousin's home, and I have made subsequent revisions since. For example, in September I needed to spawn particles based on an initial mask, such as text. Most recently I rewrote the particle class to record particles' `x` and `y` position in terms of `t` time.

<embed allowfullscreen="true" allowscriptaccess="always" height="385" src="http://www.youtube.com/v/Jrfsy6XgqUY?fs=1&amp;hl=en_US&amp;rel=0&amp;hd=1" type="application/x-shockwave-flash" width="640" />

My animation code, written in Java, spits out a sequence of PNG images, i.e. `frame000.png frame001.png ... frame899n.png`.

For a while I used [Ffmpeg](http://ffmpeg.org/) to convert these sequences into AVI files:

{% highlight sh %}
ffmpeg -r 30 -i frame%03.png out.avi
{% endhighlight %}

So `900` frames of `1080p` video would generate a fat `30` second AVI.

When I chose to combine these sequences by hand, I started compositing them in After Effects.

<embed allowfullscreen="true" allowscriptaccess="always" height="385" src="http://www.youtube.com/v/jqfXs8Iuzng?fs=1&amp;hl=en_US&amp;rel=0&amp;hd=1" type="application/x-shockwave-flash" width="640" />

I doubt H264 can ever really encode these in an attractive way that loads quickly. Case in point, the above video consistently loads painfully slow for me (at least at `720p`).

Also, I’ve been debating whether or not to release this code, since I consider it more of a tool for my own video art production. But I decided why not release the code I have been hacking at for a while now. It’s not clean or elegant because I don’t care for it to be right now, but if you want to play with it have at it:
* [aag.zip](/f/aag.zip)
You will also need:
* [Filters](http://www.jhlabs.com/ip/filters/Filters.zip) from JH Labs.
* [Parallel Java Library](http://www.cs.rit.edu/~ark/pj.shtml#download) from RIT.

Rad.
