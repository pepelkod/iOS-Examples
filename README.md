iOS-Examples
============

Examples of iOS code for others

This has a single static method which will return an SKAction.  This skaction, when run will play a sound at a specified volume.

It has a bug with the WaitForCompletion flag.  I recommend always set this to TRUE until I figure out how to retain the player so that it does not get released while playing.

