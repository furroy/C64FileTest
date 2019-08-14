# C64FileTest
Trying to get KickAss to build and debug a d64 file. I'm trying to make a program run inside a .d64
so it can access files while running.  What I currently have almost works now, but I still have to
manually type RUN once inside the debugger.

From command line I run  ./d.cmd in this folder.

Giving any command line args to C64Debugger seems to mess it up.  If I run with only
C64Debugger disk1.d64 it all loads up and just have to type RUN.  Adding any of the
-autorundisk or -alwaysjmp or -autojmp commands makes it not even load in the first program.


If I run LOAD"HIRED SWORD II",8 and RUN it launches and you can see the screen flash that it's working, but I
can't figure out how to make it just run automatically...

Using ./vice.cmd it runs in VICE with no issues.
