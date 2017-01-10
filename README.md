vigraidl
========

Use the power of the computer vision library VIGRA by means of the Interactive Data Language (IDL). The interaction between both (c++ and IDL) worlds is realized by using IDL's CALL_EXTERNAL function and the vigra_c wrapper library.


1. Prerequisites
-----------------------------------

For Linux and Mac OS X, the vigra Computer Vision library needs to be installed. I recommend the use of a version > 1.11.0. The easiest way to do so, is using your favorite package manager under linux or using MacPorts und  Mac OS X. Otherwise you need to pay attention to install all the needed dependencies on your own.

<b>Attention:</b> Under linux (Ubuntu) I encountered an installation problem of the vigra, such that `vigra-config --libs` pointed to a non-existing file. I was able to solve this by copying the necessary binary to the right position:
> sudo cp /usr/local/lib/libvigraimpex.* /usr/lib/x86_64-linux-gnu

Note, that for Windows, you also need to have installed the MS VC-Runtime (2010) in order to get these binaries running.
 
2. Installation
-----------------------------------

Since IDL does not handle your own programs in a sophisticated way, you may just copy the vigraIDL directory to any working path of choice. 

3. Auto-build of the c-wrapper
-----------------------------------

To start the initialization and to execute the examples, you first start IDL and then perform the actions described below:

Change the working directory to the vigraidl dir, e.g.:
>  CD, "/Users/seppke/development/vigraidl"

Compile all included functions:
> .COMPILE vigraidl

Check the installation and build the vigra_c wrapper if neccessary (usually only needed once!):
> CHECK_INSTALL

You may then open the examples provided with the vigraidl (file: "examples.pro") and run the corresponding procedure.

Enjoy the functionality of VIGRA when working with IDL!
