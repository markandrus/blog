---
title: Sonify Updated
layout: post
date: 2011-02-24 17:45:50
---
### Code Changes
I made a couple of revisions to Sonify over the last week. Most significantly I replaced GD Library with [SDL](http://www.libsdl.org/). Now Sonify can draw decoded audio into a window and resize its output using [nearest-neighbor scaling](http://www.libsdl.org/libraries.php?match_id=1714.)—preserve those pixels!

<div class="caption">
<img src="/i/sonify.png" alt="Sonify with JackPilot" />
<p>Note: The screenshot above also shows JackPilot—part of the <a href="http://www.jackosx.com/">JACK OS X</a> project.</p>
</div>

Sonify uses Pascal Getreuer’s [colorspace](http://www.math.ucla.edu/~getreuer/colorspace.html) for converting between HSL and RGB color models. Puzzlingly, tests I’ve run show that the conversions I am doing are a bit more than imprecise.

Compare the image above to the two below: the bottom left graphic is the source image; the screenshot above shows the image reconstructed using sine waves in the frequency range of `100-1100 Hz`; and the bottom right screenshot shows the image reconstructed using square waves over the same frequency range. The two instances of Sonify were launched using `./sonify sfy color.png 1000 100 10 sin 2` and `./sonify sfy color.png 1000 100 10 sq 2`.

<div class="caption">
<img src="/i/sonify_compare.png" alt="Left: source image; Right: square wave reconstruction mapped from 100-1100 Hz." />
<p>Left: source image; Right: square wave reconstruction mapped from 100-1100 Hz.</p>
</div>

I am guessing the apparent phase-shift error either comes from imprecision in the data types of my variables or propogates through the colorspace conversions; however, I have yet to examine this.

Instead I spent time over the past couple of days scrubbing and commenting Sonify’s source files. The code I posted below (including the manner of writing to disk, unused variables, and crap I wrote at 4:00 AM) is just horrible, really. But now anyone can peak into the project, get a clear sense of what’s going on, and start hacking, beause...

### GitHub
I just started using GitHub, and [Sonify is my first repo.](https://github.com/markandrus/Sonify)

I was working on a Haskell program for a lab two weeks ago when I accidentally `rm`-ed my source code—some form of version control would have been helpful! Now I plan to use `git` with my future projects and push as many as are worthwhile to GitHub.

Finally, some glitchy images I made while feeding Sonify a wavering synthesizer signal from Ableton Live:

<img src="/i/sonify_synth.png" alt="Sonify glitches" />

It’s fun to see what kind of patterns emerge out of this system.
