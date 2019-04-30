HandBrake, the well-known DVD ripping and video transcoding tool, was initially
developed for BeOS and had a fully featured BeOS GUI. However, support for
Haiku is not as great as this suggests. BeOS support was dropped in early 2007
([commit c0b2eca](https://github.com/HandBrake/HandBrake/commit/c0b2eca)),
though the GUI was already considered deprecated at this point. The last
HandBrake release which included the BeOS code was
[0.7.1](https://github.com/HandBrake/HandBrake/releases/tag/0.7.1) (Feb 24,
2006).

# What has been done
All versions of HandBrake currently on HaikuPorter are versions that do not
include the BeOS GUI. The only way that HandBrake can be used on Haiku at the
current moment is using the command line tool HandBrakeCLI.

## HaikuBrake

### Background / Upstreaming
Between 2014-2016 kallisti5 attempted to upstream some of his changes to
Handbrake to support Haiku (basic build stuff), but the lead developers on
Handbrake were pretty hostle at the time to any kind of Haiku patches being
accepted upstream.

HaikuBrake was forked to try and make a "Haiku friendly" version of Handbrake,
but after some deep-diving in the code, I kind of gave up. The whole project
is a tangled mess of old vendored libraries glued together with a pretty
frontend.

### Versioning
There has been an attempt to bring the BeOS GUI back to Haiku. @kallisti5's
[HaikuBrake](https://github.com/kallisti5/HaikuBrake) is based on a commit with
a commit message starting with "WinGui: Fix a number of potential...."
([4eb9b19](https://github.com/kallisti5/HaikuBrake/commit/4eb9b19d3758c089fdea16adcf2243cca22de909)
on HaikuBrake and
[feb7340](https://github.com/HandBrake/HandBrake/commit/feb7340) in the offical
HandBrake repo) from December 8, 2012. This commit was on master and descended
from version [0.9.6](https://github.com/HandBrake/HandBrake/releases/tag/0.9.6)
(it is 519 commits ahead, to be precise). Note that the commit acutally
occurred after 0.9.8 in terms of time, but HandBrake branched right after 0.9.6
(at [78052b5](https://github.com/HandBrake/HandBrake/commit/78052b5)) into a
branch moving towards 0.10.0 and a 0.9.x branch. The 0.9.x branch *was not
merged*, but I think that at least some fixes were cherry-picked from 0.9.x to
0.10. The commit HaikuBrake is based on is part of the branch for 0.10.0.

### Fixes
All in all, the code in this repo is changed in the following way: It puts in
the BeOS GUI code, adds a Makefile for that, removes the dependency on the
contrib packages so that system versions of the libraries are used instead, and
"fixes" the BeOS GUI so that it builds. One notable commit is
[86e06dd](https://github.com/kallisti5/HaikuBrake/commit/86e06dd04d93108a8156f2aa73c8fb404ade92ea).
It makes the BeOS code compile again. *However*, this is mainly done by
enclosing all code which does not interface in `#if 0`, disabling a lot of the
functionality to the point of the GUI not being remotely useful anymore. For
instance, audio support is simply dropped (e.g.
[here](https://github.com/kallisti5/HaikuBrake/commit/86e06dd04d93108a8156f2aa73c8fb404ade92ea#diff-a1dffb371a1de8a96b3df30cd292ac0fR899)).
Needless to say, even if the GUI built again with these changes, it basically
was not usable. A checkout of HaikuBrake did not compile on my machine,
apparently due to library version mismatches (though I did not try too hard to
make it work, so it might be possible).

## The HaikuPorts patches
The HaikuPorts patches for version 0.10.2 as of
[005299](https://github.com/haikuports/haikuports/commit/005299) are a mixture
of patches to fix the build of the main library and CLI, some commits from
HaikuBrake, as well as some more patches which seem to address some additional
issues which may have come up due to even more changes. As these patches run
against version 0.10.2, there are a lot of additional incompatibilities due to
API changes, which is why the build of the BeOS code is once again broken.

# What I have done
## Work off of 0.10.2
The Haiku API is mostly stable, but the libhandbrake API is not (this is no
surprise. All software which officially targets libhandbrake is in the
HandBrake repository itself. This includes the .NET bindings as well as the
GUIs for the various platforms. When a breaking API change is made, the
corresponding frontends can immediately be fixed. Unfortunately, right now, the
Haiku code does not have this luxury and [likely won't have it anytime
soon](https://reviews.handbrake.fr/r/480/)). Off of the patchset for 0.10.2,
getting the code to *build* is just a matter of replacing a handful of library
calls with their respective updated versions. However, getting it to *work* is
a different matter entirely: All calls have to be verified to work. You have to
verify what exactly the replacement for a certain library call is and whether
it does anything different or unexpected. Also, a lot of calls and
functionality is currently put in `#if 0`. All of it has to be restored and
updated calls have to be found. A section "Tools" below will go into detail on
how I went about finding these sorts of replacements. I got the code to build
and started fixing a few bugs. However, the library interaction is still
broken. Currently, the most pressing problem is the fact that muxer and encoder
are not set at all, resulting in an empty output.  I will make a pull request
with the handful of improvements I have made once I am done writing this.

## Work off of 0.7.1
I have evaluated the feasibility of the approach of updating the GUI code off
of this version. See below for results; if someone is interested in the changes
that I made to the build system I can upload them here.

# Tools
After fixing a few library calls and getting up to date on HandBrake history,
here are a few techniques that have been successful for me when searching for
things.
## `git`
Git is an extremely useful tool for tracking down library changes. Your best
friend is [`git bisect`](https://git-scm.com/docs/git-bisect). This of course
requires the [actual HandBrake
repository](https://github.com/HandBrake/HandBrake) and not just the download
in the haikuports work folder. If you know that a library call existed back in
0.7.1 but does not exist at master just bisect and look for the commit that
removed it. To check whether it is still there in a specific revision use
`grep` or even better [`ag`](https://git-scm.com/docs/git-bisect). The commit
that removes a specific library call will most likely also change its uses in
the CLI and GUIs, so you know what to replace the call with.

To find out what time and version a revision belings to, use `git show` and
`git describe` and possibly `git merge-base`.
## Usage in the HandBrake repository
The HandBrake repository also contains HandBrakeCLI at test/test.c and also
several GUIs. See how they implemented a certain functionality and adapt the
code for the Haiku GUI.

# What has to be done
## Fix problems with HandBrake itself
There still seem to be bugs in HandBrake which are specific to Haiku but not
related to the BeOS GUI. For example, I do testing with a .iso which works
perfectly fine with HandBrake 0.10.2 on Windows, but crashes HandBrakeCLI on
Haiku. These bugs have to be investigated.

## Get the GUI to work, preferrably on a modern version
There are several ways to go about this.

### Start with a modern version, put in the code, and fix stuff until it works
This is basically what happens in the 0.10.2 patchset. Library calls are
replaced with their successors. However, this causes some problems which are
hard to fix, as sometimes, non-obvious changes have to be reflected in the GUI.
For example,
[16deb21428](https://github.com/HandBrake/HandBrake/commit/16deb21428) (June 3,
2013) introduced a function `hb_global_init` which has to be called before any
other function in the library. If it is not called, the library starts
segfaulting in unpredictable places. As libhandbrake is not intended to be used
outside of its own repository, no documentation exists. At all. It is therefore
impossible to be absolutely sure that you are driving the library correctly.

### Start with a version which supported the GUI and incrementally work upwards from there
This is a multi-step approach: Get the code for version 0.7.1 to work on Haiku
and then update it in rather small steps until it is up to date.  The advantage
of this approach is that "unannounced" breaking changes are more easily found.

However, there is an enormous drawback to this approach: **Dependencies**. On
most platforms, HandBrake automatically pulls in and builds the exact versions
of the libraries it needs. The libraries are built statically and therefore are
put into the executable. However, on Haiku, this approach does not work, as
many of these libraries need Haiku-spacific patches which would need to be
mirrored into the HandBrake code. This is clearly a suboptimal solution, and
instead Haiku opts to simply use the system versions of these libraries (in the
process, all patches HandBrake wanted to make to these libraries are of course
discarded. I wonder if the impact of this has been evaluated, as one would
expect these patches to be somehow required for HandBrake to interact with the
library properly).  However, older versions of HandBrake require older versions
of its dependencies. For each version of HandBrake which is built, a slightly
different API for the libraries is used. For the build to succeed, compatible
versions of the library have to be installed on the system. Here is the list of
specific versions which have to be installed just to get HandBrake 0.7.1 up and
running:

      library | version
--------------|---------
        a52de | 0.7.4
         faac | 1.24
       ffmpeg | 20060201
         lame | 3.96.1
    libdvdcss | 1.2.9
   libdvdread | 20050928
       libogg | 1.1.2
libsamplerate | 0.1.2
    libvorbis | 1.1.1
     mpeg2dec | 20051112
      mpeg4ip | 1.3
         x264 | r401
     xvidcore | 1.1.0

Here is another problem with starting from 0.7.1: It uses a different build
system. Luckily, this looks like it is a minor problem, as it's based on jam.
After telling it to disregard to contrib folder and link against system
libraries, it didn't seem to pose much of a problem, although I never saw it
finish a build due to the dependency problem described above.

### Rewrite the GUI from scratch
Possibly check other GUIs for inspiration.

## Enhance the GUI
The GUI essentially reflects the feature-set of HandBrake about ten years ago.
The library has changed a lot since then, and accordingly, the well-supported
GUIs have added a lot more controls and features. It is probably a good idea to
get those controls into the BeOS GUI as well.

Additionally, the GUI should be updated to use the Layout API.

One could also consider restyling the code, as the current code style is
inconsistent with the rest of HandBrake.
