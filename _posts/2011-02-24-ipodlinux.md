---
title: iPodLinux
layout: post
date: 2011-02-24 17:25:43
---
What is iPodLinux? Before the iPod Touch, iPhone, Android, and others, iPL offered iPod owners a chance to run homebrew code on their portable devices. Since then [iPodLinux.org](http://ipodlinux.org) has expired, and the project is practically dead. Nevertheless it was a fun time when you could load the entire Wikipedia on your iPod or play [Doom](http://www.youtube.com/watch?v=Ra6rqKSqBSk).

Below is a screenshot of Podzilla2, a graphical shell for iPodLinux, running my module Drum Machine. Drum Machine is coded in C, and provides 4 samples, 4 patterns, and 32 steps. Like other Podzilla modules, it is generally compiled into the main executable along with other modules.

<div class="caption">
<img src="/i/podzilla2.png" alt="Podzilla 2 with Drum Machine" />
<p>Podzilla2 emulator running Drum Machine</p>
</div>

The screenshots show Podzilla2, running under OS X. I originally wrote this under Fedora around October 2008, but I rediscovered the source code and built it for the desktop. You may download the source code [here](http://rvvs89.ucc.asn.au/ipl/nightly/src/xpod-drum_machine-src.tar.gz).

Note: Building this may be tricky. Building Podzilla2 itself may be tricky since the documentation on it is scattered across the net, but the links below should suffice.
* Build Podzilla2 following the instructions at [http://ipl.derpapst.eu/wiki/Building_Podzilla](http://ipl.derpapst.eu/wiki/Building_Podzilla).
* `tar xzvf xpod-drum_machine-src.tar.gz` in the `modules` di­rec­tory of the Podzil­la2 source.
* Attempt to rebuild Podzilla2 with Drum Machine
* Notice all the errors and attempt solutions
* Successfully build Podzilla2 with Drum Machine

So prepare to hack. I haven't really bothered with this since high school, but it will still work with some effort.
