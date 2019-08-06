@echo off
rem
rem   Define the variables for running builds from this source library.
rem
set srcdir=syn
set buildname=
call treename_var "(cog)source/syn" sourcedir
set libname=syn
set fwname=
make_debug "C:\embed\src\syn\debug_syn.bat"
call "C:\embed\src\syn\debug_syn.bat"
