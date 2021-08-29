@echo off
rem
rem   Define the variables for running builds from this source library.
rem
set srcdir=syo
set buildname=
call treename_var "(cog)source/syo" sourcedir
set libname=syo
set fwname=
call treename_var "(cog)src/%srcdir%/debug_%libname%.bat" tnam
make_debug "%tnam%"
call "%tnam%"
