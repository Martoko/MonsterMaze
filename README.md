# MonsterMaze

Small demonstration of A* in Ruby, using the GOSU graphical library.


![Screenshot](https://github.com/Martoko/MonsterMaze/blob/master/screenshots/main_screenshot.png)


## Building

Building a standalone executable file is possible for Windows and Mac OS X.
Linux users are expected to run the ruby outputted by "rake build_src".

Runtime dependencies
 - Ruby
 - GOSU

Build dependencies
 - Rake
 - Ocra (Building for Windows only)

#### Windows

Run "rake build_win" to build for OS X.

#### Mac OS X

Run "rake build_osx" to build for OS X.

#### Linux

Run "rake build_src" to gather the source code and images in "bin/ruby".
