Welcome to the second part of  [Getting Started with OpenVMS and SIMH](OpenVMS_and_SIMH_pt1.html). This article assumes that you have already followed  [part 1](OpenVMS_and_SIMH_pt1.html)  or have at least installed  **OpenVMS VAX 7.3**  on a system, with  **dua0** containing the OS,  **dua1**  containing user-directories, and TCP/IP services are functional. If in doubt, have a quick read over what we did in the first part. For this part, we will install and use  **UNZIP**,  **wget**,  **Compaq C** and the  **WASD**  HTTP server.  
  
Although I'd /love/ to throw you in at the deep-end, I think the transition to OpenVMS will be easier if we introduce a couple of utilities you may be familiar with and break you in gently. This is a bit of a 'ghetto' guide to OpenVMS 7.3, and is primarily for users learning through SIMH - so, we will use the easiest methods of retrieving and installing what we need (despite them not being the most traditional methods).  
  
**UNZIP & WGET**  
  
These two utilities, in my opinion, are extremely useful when getting started with OpenVMS 7.3 in SIMH. The main reason being that you will find many 3rd-party applications will be ZIP archived, and nowadays - HTTP is much more common for files than FTP. WGET, although slightly bloated, is one of the most popular utilities in the UNIX(-like) world for grabbing files over HTTP and FTP. Although you should be ashamed for bringing it and similar utilities into your nice, clean, OpenVMS installation - it will aid you in the transition from UNIX to OpenVMS by providing some niceties you have become accustomed to having. So, let's grab 'wget' first. Login to your OpenVMS system as a normal user, and type '**sh def**'. This is short for '**SHOW DEFAULT**' and is like the '**pwd**' command on UNIX/Unix-like systems. It will display the current directory you are in. If you followed the first tutorial on installing OpenVMS in SIMH, you should see something like the following:  

    $ sh def
      DUA1:[INT16H]

This means that you are in a directory named "**INT16H**" at the root of the **DUA1:** drive. We will discover more about how directories are addressed in a moment.  
  
We should create a directory for our downloaded files to live in. Looking at the above '**path**', how would you expect a full path to '**DOWNLOADS**' within the '**INT16H**' directory to look? On a Unix-like system, you would probably expect something like '**/home/int16h/downloads**' - but this is not UNIX.  
  
For clarity, we will create a directory using its full path using the '**create**' command like when we created the user-directory:

    $ create/dir dua1:[INT16H.DOWNLOADS]

As you can see, we first reference the device, then the path from there is [enclosed], with each directory separated by a period/dot/full-stop. This is probably more similar to AmigaDOS than any other modern operating systems you may have came across.  
  
You will receive no confirmation of the command's success, but if it did not succeed - you will receive an error message. To see that your new directory does actually exist, run '**dir**' (**DIRECTORY**), which will provide you with a directory-listing, similar to that below.

    $ dir
    
    Directory DUA1:[INT16H]
    
    DOWNLOADS.DIR;1
    	
    Total of 1 file.	

We can now move into this directory by issuing the "**set def**" (**SET DEFAULT**) command. You could pass '**dua1:[INT16H.DOWNLOADS]**' as the path to change to, but as we are in the directory where our target directory exists - that wouldn't be the quickest path. Instead, run '**set def [.DOWNLOADS]**' - the '.' before '**DOWNLOADS**' tells the system that we want to change to a directory named '**DOWNLOADS**' within the current directory. Although it may be tempting to issue '**set def DOWNLOADS**' or '**set def [DOWNLOADS]**' but this wouldn't work how you may expect:

    $ set def [.DOWNLOADS]
    $ sh def
      DUA1:[INT16H.DOWNLOADS]
    
    $ set def dua1:[INT16H.DOWNLOADS]
    $ sh def
      DUA1:[INT16H.DOWNLOADS]

As you can see from either command above, we are now in the correct directory. If you were to change to '[DOWNLOADS]' instead of [.DOWNLOADS] we would receive:

    $ set def [DOWNLOADS]
    $ sh def
      DUA1:[DOWNLOADS]
    %DCL-I-INVDEF, DUA1:[DOWNLOADS] does not exist

This is because '**[DOWNLOADS]**' would take us to '**DUA1:[DOWNLOADS]**' which doesn't currently exist.  
  
It would be quite useful if we knew how to go back a directory. In many operating systems, '**cd ..**' would allow you to do this, but as you know - we use '**set def** ('**SET DEFAULT**'), and rather than '**..**' we use '**[-]**'. So, we will move back into your 'home' directory now:

    $ set def [-]
    $ sh def
      DUA1:[INT16H]

Now that you know how to create directories and navigate around the data disk, we will create one more directory, naming it "BIN" - so store programs you want for your own use.

    $ create/dir [.BIN]

Change directory to [.BIN] and we shall download the UNZIP utility.

    $ set def [.BIN]

Available for OpenVMS is a wide range of freeware utilities and applications, usually made available from the ~~[OpenVMS Freeware CDs](https://web.archive.org/web/20090312034329/http://www.openvms.compaq.com/openvms/freeware/)~~. These are available as large zip files from Compaq (HP) or alternatively, you can browse and download programs from the Freeware CDs as well as many others via ~~[SAIC.com's](https://web.archive.org/web/20090312034329/http://www.saic.com/)  [OpenVMS Freeware Archive](https://web.archive.org/web/20090312034329/http://mvb.saic.com/).~~ The problem is, many of them are zipped - and we do not have the means to unzip these archives.  
  
Luckily, many FTP sites contain useful tools such as UNZIP in a compiled executable for Alpha, ia64 and VAX; suitable for running straight away. Such sites include [Process.com](https://web.archive.org/web/20090312034329/http://www.process.com/) and the ~~[SAIC OpenVMS Freeware Archive](https://web.archive.org/web/20090312034329/http://mvb.saic.com/)~~ mentioned above. We will be using SAIC's archive so that you can get used to the structure of the Freeware CDs.  
  
Use the 'FTP' client supplied with OpenVMS to connect to **mvb.saic.com** and login Anonymously:

    $ ftp mvb.saic.com
    220 mvb.saic.com MultiNet FTP Server Process V5.2(16) at Tue 13-Jan-2009 6:38AM-PST
    Connected to mvb.saic.com. 
    Name (mvb.saic.com:int16h): Anonymous
    331 Anonymous user ok. Send real ident as password.
    Password: 
    230-
    230-    Greetings, and welcome to the DECUS tape archives here at Mvb.Saic.Com. 
    230-    This archive contains submissions of the VMS and L&T; SIGs of the U.S.
    230-    DECUS chapter.  The entire SIG tape collection of the VMS (nee VAX) SIG
    230-    and the Languages and Tools SIG are available here.  There are also a
    230-    few extras here such as the Info-VAX archive, Freeware V4.0 & V5.0 disks,
    230-    x11r6, Tex, ISO9660, etc.  There is also a mirror of the VMS freeware
    230-    archive at Process Software (in the [.PROCESS] directory) and a mirror
    230-    of the DECWindows archive at CENA (in the [.DECWINDOWS] directory).
    230-
    230-    FTP access to this system is available 24 hours a day, 7 days a week.
    230-
    230-    N.B. This is a VMS system.  However, the FTP server is set to use Unix
    230-    syntax in order to accomodate all of the "the world is unix" ftp
    230-    clients out there.  To return to VMS syntax, issue the command: cd []
    230-
    230-Guest User INT16H logged into /disk$misc/decus at Tue 13-Jan-2009 6:38AM-PST, job 36903.
    230 Directory and access restrictions apply
    FTP> 

You will see that we logged in as user **Anonymous** and we gave our ident (username) as the password. As you connect to more FTP servers running OpenVMS, you will notice that the 'Anonymous' login will always require your ident - rather than an e-mail address like many other servers nowadays.  
  
The utilities we will be downloading are located in **[.FREEWAREV80.000tools.vax_images]**. Although the server has been set to use UNIX syntax by default (as we were informed by the MOTD), we can still navigate through the server like a normal OpenVMS system. Let's go to the directory we require now.

    FTP> sh def
    257 "DISK$MISC:[DECUS]" is current directory.
    FTP> set def [.FREEWAREV80.000tools.vax_images]
    250 Connected to DISK$MISC:[DECUS.FREEWAREV80.000TOOLS.VAX_IMAGES].

Let's have a look at which tools are available before we go downloading:

    FTP> dir
    200 Port 192.8 at Host 79.64.146.144 accepted.
    150 List started.
    
    DISK$MISC:[DECUS.FREEWAREV80.000TOOLS.VAX_IMAGES]
    
    BZIP2.EXE;1               156   9-APR-2001 02:11 [BERRYMAN] (RE,RE,RE,RE)
    DECODE_64.EXE;1            11   6-MAY-1997 11:33 [BERRYMAN] (RE,RE,RE,RE)
    GZIP.EXE;1                 93  23-FEB-2001 10:36 [BERRYMAN] (RE,RE,RE,RE)
    UNZIP.EXE;1               208  20-JUL-2006 17:34 [BERRYMAN] (RE,RE,RE,RE)
    VMSTAR.EXE;1               59  27-SEP-2003 03:37 [BERRYMAN] (RE,RE,RE,RE)
    ZIP.EXE;1                 137  20-JUL-2006 17:35 [BERRYMAN] (RE,RE,RE,RE)
    
    
    Total of 664 blocks in 6 files.
    
    226 Transfer completed.
    542 bytes received in 00:00:00.03 seconds (17.64 Kbytes/s)

You may download any utilities you will require, but for now we will just grab ZIP.EXE and UNZIP.EXE. Remember to switch to binary mode for transfers though, else you won't be able to execute the files:

    FTP> binary
    200 Type I ok.
    FTP> get ZIP.EXE
    200 Port 192.9 at Host 79.xxx.xxx.xxx accepted.
    150 IMAGE retrieve of DISK$MISC:[DECUS.FREEWAREV80.000TOOLS.VAX_IMAGES]ZIP.EXE;1 (70144 bytes) started.
    226 Transfer completed.  70144 (8) bytes transferred.
    local: DUA1:[INT16H.BIN]ZIP.EXE;1  remote: ZIP.EXE
    70144 bytes received in 00:00:01.34 seconds (51.11 Kbytes/s)
    FTP> get UNZIP.EXE
    200 Port 192.10 at Host 79.xxx.xxx.xxx accepted.
    150 IMAGE retrieve of DISK$MISC:[DECUS.FREEWAREV80.000TOOLS.VAX_IMAGES]UNZIP.EXE;1 (106496 bytes) started.
    226 Transfer completed.  106496 (8) bytes transferred.
    local: DUA1:[INT16H.BIN]UNZIP.EXE;1  remote: UNZIP.EXE
    106496 bytes received in 00:00:01.56 seconds (66.66 Kbytes/s)
    FTP> 

If you have any problems retrieving directory listings, downloading files etc - you can adjust the PASV/PASSIVE FTP settings with the '**passive**' command. Type "**exit**" to disconnect and terminate FTP. Using the '**r**' ('**RUN**') command, we can check that the binaries/images will run successfully:

    $ r unzip.exe
    UnZip 5.52 of 28 February 2005, by Info-ZIP.  For more details see: unzip -v.
    ~

Perfect! Or is it? Let's try to run unzip.exe again, but this time we'll append '-v' to it.

    $ r unzip.exe -v
    %DCL-W-MAXPARM, too many parameters - reenter command with fewer parameters

That's not very useful, not for running a command which requires parameters anyway. OpenVMS has an extremely useful online help system (online as in live, within the OS). Let's have a brief look at that now and hope we can discover why we can't use '**RUN**' how we would like:

    $ help run
    
    RUN
    
         Executes an image within the context of your process (see Image).
         If you are invoking an image requiring one or more parameters,
         you must use the Automatic Foreign Command format or the Foreign
         Command format.
    
         Creates a subprocess or a detached process to run an image and
         deletes the process when the image completes execution (see
         Process).
    
      Additional information available:
    
      Image      Process
    
    RUN Subtopic? 

We have established that '**run**' won't let us use programs which require argc/argv-style parameters, and now the help system has informed us that we must use the **Automatic Foreign Command** format or the **Foreign Command** format. Foreign Commands are usually programs which aren't native to OpenVMS and as such don't comply with how OpenVMS expects applications to be run - or can be any programs/commands outside of DCL. For example the '**RUN**' command, if issued without a filename as a parameter, will prompt you to enter a filename. This is not the case with the vast majority of programs which have been ported from UNIX and other systems. To exit from the help system, press **CTRL-Z**.  
  
To be able to run these commands, we will define a **symbol**. A symbol is a symbolic name or alias for a string, the result isn't unlike setting environment variables in other operating systems. **==** is used for global symbols, and prepended a colon (':') is used for strings. Here are a couple of examples of setting symbols:

    $ A == 1
    $ B :== bee

The online help system can tell us the format used for setting symbols:

         symbol-name =[=] expression
    
       symbol-name[bit-position,size] =[=] replacement-expression

Using the '**SHOW**' command, you can display the value of any single symbol or all of them at once:

    $ show symbol A
      A = 1   Hex = 00000001  Octal = 00000000001
    
    $ show symbol/all
      A = 1   Hex = 00000001  Octal = 00000000001
      B = "BEE"

These can be used like variables, aliases for commands etc. If we wanted to create a symbol called '**ls**' which had the string value "**DIR**" associated with it, we could use '**ls**' in place of '**DIR**':

    $ ls :== DIR
    $ sh symbol ls
      LS = "DIR"
    $ ls
    
    Directory DUA1:[INT16H.BIN]
    
    UNZIP.EXE;1         ZIP.EXE;1           
    
    Total of 2 files.

This is all very useful, but it doesn't quite let us run our Foreign Commands yet. Try creating a symbol which will point to '**DUA1:[INT16H.BIN]UNZIP.EXE**', then issue your new symbol as a command:

    $ unzip :== DUA1:[INT16H.BIN]UNZIP.EXE
    $ unzip
    %DCL-W-IVVERB, unrecognized command verb - check validity and spelling \DUA1\

We need to flag the symbol as being associated with a foreign command, so it will treat it as such. This is done by adding '$' at the beginning of the 'path':

    $ unzip :== $DUA1:[INT16H.BIN]UNZIP.EXE
    $ sh symbol unzip
      UNZIP == "$DUA1:[INT16H.BIN]UNZIP.EXE"

Now let's try running 'unzip' again, and then try issuing the '-v' parameter.

    $ unzip
    UnZip 5.52 of 28 February 2005, by Info-ZIP.  For more details see: unzip -v.
    ~

    $ unzip -v
    UnZip 5.52 of 28 February 2005, by Info-ZIP.  Maintained by C. Spieler.  Send
    bug reports using http://www.info-zip.org/zip-bug.html; see README for details.
    
    Latest sources and executables are at ftp://ftp.info-zip.org/pub/infozip/ ;
    see ftp://ftp.info-zip.org/pub/infozip/UnZip.html for other sites.
    
    Compiled with VAX C for VMS (V5.4-2 VAX) on Feb 28 2005.

Congratulations, you can now unzip files. Usually you would put system utilities somewhere such as 

    SYS$SYSTEM

this is a logical name which points to '**SYS$SYSROOT:[SYSEXE]**' which has another logical name ;). If you would like to see a list of defined logical names, you may run '**show logical/all**'.  
  
Because it's not ideal to create symbols for every Foreign Command program you wish to use, OpenVMS now has something comparable to the $PATH environment variable - '**dcl$path**'. This is defined with the '**define**' command, and will allow you to set one or more directories to be in your "path" for running Foreign Commands. To enable us to run any executables from our [.BIN] directory, we shall add it to '**dcl$path**' now:

    $ define dcl$path dua1:[INT16H.BIN]

You can check that it is working by running "zip" from the command-line.  
  
Finally we have acquired the ZIP and UNZIP utilities, but have also learned some basic but important OpenVMS commands. Next we will download 'wget', another utility from the UNIX world, and install it into our personal 'BIN' directory.  
  
**Wget - the web-getter** Wget for OpenVMS is available from [AntiNode.info](http://www.antinode.info/dec/index.html) amongst other places, as are a few other utilities you may find useful. We will be downloading a ZIP file to our DOWNLOADS directory, extracting it, then copying the wget binary to BIN:

    $ set def [-.DOWNLOADS]
    $ ftp antinode.info
    
    220-   Antinode FTP Server.  Please be nice.
    220 alp.antinode.info FTP Server (Version 5.4) Ready.
    Connected to alp.antinode.info. 
    
    Name (alp.antinode.info:int16h): Anonymous
    331 Guest login OK, send ident as password.
    Password: 
    230 Guest login OK, access restrictions apply.
    
    FTP> set def [.WGET.wget-1_10_2c_vms]
    250-CWD command successful.
    250 New default directory is SYS$SYSDEVICE:[ANONYMOUS.WGET.WGET-1_10_2C_VMS]
    
    FTP> binary
    200 TYPE set to IMAGE.
    
    FTP> get WGET-1_10_2C_VMS.ZIP
    200 PORT command successful.
    150 Opening data connection for SYS$SYSDEVICE:[ANONYMOUS.WGET.WGET-1_10_2C_VMS]WGET-1_10_2C_VMS.ZIP;
     	(79.xxx.xxx.xxx,49166) (3171539 bytes)
    226 Transfer complete.
    local: DUA1:[INT16H.DOWNLOADS]WGET-1_10_2C_VMS.ZIP;1  remote: WGET-1_10_2C_VMS.ZIP
    3171539 bytes received in 00:00:54.61 seconds (56.71 Kbytes/s)
    
    FTP> exit
    221 Goodbye.

We will now extract '**WGET-1_10_2C_VMS.ZIP**'. Run '**unzip WGET-1_10_2C_VMS.ZIP**'. You will see a lot of files extracting, but we only need one - **WGET.EXE** from **[.wget-1_10_2c_vms.src.vax]**. We will copy it to our BIN directory:

    $ unzip WGET-1_10_2C_VMS.ZIP
    inflating: ~~
    $ copy [.wget-1_10_2c_vms.src.vax]WGET.EXE DUA1:[INT16H.BIN]WGET.EXE

Now you can run 'wget' for times of laziness.

    $ wget
    dua1:[int16h.bin]wget.exe;1: missing URL
    Usage: dua1:[int16h.bin]wget.exe;1 [OPTION]... [URL]...

Try `dua1:[int16h.bin]wget.exe;1 --help' for more options.

  

## Installing Supplemental Software

A supplemental disc is available for OpenVMS 7.3, this contains developer tools which can be essential if you want a fully-functional learning system. This will give us an opportunity to make use of our recently-installed 'wget' utility. While still in [.DOWNLOADS], create a new directory called SUPP, change to this dir then use 'wget' to retrieve your ZIP:

    $ create/dir SUPP
    $ set def [.SUPP]
    
    $ wget "https://mirrors.pdp-11.ru/_vax__/_VMS/_distrib/7.X/Openvms%20Vax%2073%20Supplement.zip"
    --22:24:46--  https://mirrors.pdp-11.ru/_vax__/_VMS/_distrib/7.X/Openvms%20Vax%2073%20Supplement.zip
               => `Openvms Vax 73 Supplement.zip'
    Resolving ... xxx.xxx.xxx.xxx
    Connecting to ...|xxx.xxx.xxx.xxx|:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 54,545,839 (52M) [application/zip]
    100%[====================================>] 54,545,839   231.87K/s    ETA 00:00
    
    22:28:10 (261.50 KB/s) - `Openvms Vax 73 Supplement.zip' saved [54545839/54545839]

Unzip the file, and have a look at the contents. Unzipping will probably take some time.

    $ unzip OpenVMS-VAX-7_3-Supplement.zip
    Archive:  DUA1:[INT16H.SUPP]OPENVMS-VAX-7_3-SUPPLEMENT.ZIP;1
      inflating: aacrt060.a              
    ~
    
    $ dir
    
    Directory DUA1:[INT16H.SUPP]
    
    AACRT060.A;1        BASIC039.A;1        BASIC039.B;1        BASIC039.C;1       
    BASIC039.D;1        BASIC039.E;1        CC064.A;1           CC064.B;1          
    DCPSVAX021.A;1      DCPSVAX021.B;1      DCPSVAX021.C;1      DEC-VAXVMS-FORTRAN-V0606-201-1.PCSI;1
    DECSET124.A;1       DECSET124.B;1       DECSET124.C;1       DECSET124.D;1      
    DECSET124.E;1       DECSET124.F;1       DECSET124.G;1       DECSET124.H;1      
    DECSET124.I;1       DECSET124.J;1       DECSET124.K;1       DTC010.A;1         
    DTC010.B;1          DTRA072.A;1         DTRA072.B;1         DTRA072.C;1        
    FORT066.A;1         OPENVMS-VAX-7_3-SUPPLEMENT.ZIP;1        PASCAL058.A;1      
    PASCAL058.B;1       PASCAL058.C;1       PASCAL058.D;1       VMSI18N073.A;1     
    VMSI18N073.B;1      VMSI18N073.C;1      
    
    Total of 37 files.

Ok, so you've waited for this archive to decompress - and now you are presented with 37 files. You will notice that most of the files end in a one-letter extension, the two exceptions being the .ZIP and .PCSI files. Lets delete the ZIP file to save space.

    $ delete DEC-VAXVMS-FORTRAN-V0606-201-1.PCSI;1

You should get used to using full filenames, including the revision appendage(;#) when working with files in OpenVMS. Back to our supplements! When you registered for your hobbyist PAKs, I hope you chose every one which was available as you will need licenses/PAKs for C, PASCAL, FORTRAN and anything else you'd like to install. Check your e-mail and look for the PAK which begins with: '**$ LICENSE REGISTER C -**'. Paste it into your terminal, and load it:

    $ $ LICENSE REGISTER C /ISSUER=OPENVMS_HOBBYIST /AUTHORIZATION=DECUS-XXX-#########-#######
     /PRODUCER=DEC /UNITS=0 /TERMINATION_DATE=##-XXX-#### /ACTIVITY=CONSTANT=100
     /CHECKSUM=#-XXXX-XXXX-XXXX-XXXX
    
    $ license load C
    %LICENSE-I-UNLOADED, DEC C has been unloaded
    %LICENSE-I-LOADED, DEC C was successfully loaded with 0 units

We now have a license installed and loaded for C. Now we may install it safely, without complaints. When installing 'system' software, it is often preferred it is done as the '**SYSTEM**' user. Issue '**lo**' to logout of the system, then re-login as SYSTEM:

    $ lo
    Connection closed by foreign host.N-2009 00:44:44.56
    cgxlap:~ int16h$ 
    cgxlap:~ int16h$ telnet 10.0.0.69
    Trying 10.0.0.69...
    Connected to 10.0.0.69.
    Escape character is '^]'.
    
    
     Welcome to OpenVMS (TM) VAX Operating System, Version V7.3    
    
    Username: SYSTEM
    Password: 
     Welcome to OpenVMS (TM) VAX Operating System, Version V7.3
        Last interactive login on Friday, 26-DEC-2008 19:26
    
    Now we will change into the directory where our supplements are stored, and install Compaq C.
    
    $ set def DUA1:[INT16H.SUPP]
    $ @SYS$UPDATE:VMSINSTAL CC064 DUA1:[INT16H.SUPP]
            OpenVMS VAX Software Product Installation Procedure V7.3
    
    It is 14-JAN-2009 at 00:52.
    
    Enter a question mark (?) at any time for help.
    
    * Are you satisfied with the backup of your system disk [YES]? 
    
    The following products will be processed:
    
      CC V6.4
            Beginning installation of CC V6.4 at 00:52
    
    %VMSINSTAL-I-RESTORE, Restoring product save set A ...
    
    **WARNING!** If you downloaded these sets and you are not using an original CD/ISO, it's likely they do not have the correct attributes set for VMSINSTAL to acknowledge them. You may receive messages like:
    
    %BACKUP-F-NOTSAVESET, DUA1:[INT16H.SUPP]CC064.A;1 is not a BACKUP save set
    %VMSINSTAL-E-NOSAVESET, Save set  A  cannot be restored.
    
    This may sound quite serious, but usually - as mentioned above, it's due to incorrect file attributes. This can be fixed quite easily:
    
    $ SET FILE/ATT=(LRL:32256,MRS:32256,RFM:FIX) CC064.*;*
    $ @SYS$UPDATE:VMSINSTAL CC064 DUA1:[INT16H.SUPP]
    
    Installation should now continue, most of the answers to questions will be quite easy to answer; If in doubt - answer 'YES' to any questions regarding installing something.
    
            Product:      C
            Producer:     DEC
            Version:      6.4
            Release Date: 05-JAN-2001
    
    * Does this product have an authorization key registered and loaded? YES
    
    As we have already installed and loaded our PAK, you should answer 'YES' here.
    
        The file SYS$STARTUP:CCXX$STARTUP.COM contains commands to be
        executed at system startup to allow for the best compilation
        performance.  You may want to invoke this command file from your
        system's site specific start up file.  This command file does not
        have to be invoked for correct operation of Compaq C.

Again, these kind of installation notes can be very useful. In this case it's not crucial to perform this task for the product to function, but sometimes there will be additional steps you must take.  
  

## Installing WASD VMS Hypertext Services

[WASD](http://wasd.vsm.com.au/) is **the** HTTP server package exclusive to OpenVMS. We're going to compile and install it now so you can test out the compiler you just installed. There are architecture-specific packages we could use to install WASD, but I'm sure you're eager to let it compile while you go make some coffee. We'll start by downloading **htroot930.zip** from [wasd.vsm.com.au/wasd/](http://wasd.vsm.com.au/wasd/); make sure you are in your **DOWNLOADS**directory. After the transfer has completed, logout and then login as the SYSTEM user.

    $ wget http://wasd.vsm.com.au/wasd/htroot930.zip
    $ lo

Because we have not covered the **LOGIN.COM** file yet, added our dcl$path to it and have not installed our utilities in [BIN] to a system-wide directory... we will have to manually set dcl$path. After this, we will change to the root of **dua1** using **DUA1:[000000]** as the path, and will finally unzip WASD there, and begin the installation.

    $ SET DEF dua1:[000000]
    $ UNZIP dua1:[INT16H.DOWNLOADS]HTROOT930.ZIP

Extraction will take some time, it will result in the directory **dua1:[HT_ROOT]** being created. As per the WASD [ReadMe](http://wasd.vsm.com.au/wasd/htroot930.txt) file - we may now proceed to install WASD.

    $ @DUA1:[HT_ROOT]INSTALL
    
    %DCL-S-SPAWNED, process SYSTEM_1 spawned
    %DCL-S-ATTACHED, terminal now attached to process SYSTEM_1
    
          WASD VMS Hypertext Services, Copyright (C) 1996-2008 Mark G.Daniel.
      This package (all associated programs), comes with ABSOLUTELY NO WARRANTY.
       This is free software, and you are welcome to redistribute it under the
     conditions of the GNU GENERAL PUBLIC LICENSE, version 3, or any later version.
                        http://www.gnu.org/licenses/gpl.txt
    
                   ************************************************
                   *  INSTALL WASD VMS HYPERTEXT SERVICES v9.3.0  *
                   ************************************************
    
    All sections may be individually declined before making any modifications.
    In this sense the install may be undertaken step-by-step or sections repeated.
    The first section is COMPILING/LINKING, after which you will be able to quit.
    In a mixed architecture cluster (including both Alpha and VAX systems) the
    compile/link section must be performed on both!
    
    Press RETURN to continue: 
    
                                 *******************
                                 *  BUILD PACKAGE  *
                                 *******************
    
    Package executables must be built.
    
      0. skip this step
      1. compiling from source, then linking
      2. linking (separate package) object modules
    
    Select build method [0]: 1
    
                       **************************************
                       *  NO SSL TOOLKIT COULD BE LOCATED!  *
                       **************************************
    
    None of the following SSL toolkits could be located.
    
      o  OpenSSL toolkit
      o  VMS SSL product (HP)
      o  WASD OpenSSL package
      o  Jean-Fran?ois Pi?ronne (OpenSSL toolkit)
    
    A non-SSL version of the server will be built.
    
    Press RETURN to continue: 
    
                             **************************
                             *  BUILDING EXECUTABLES  *
                             **************************
    
    %DCL-I-IGNQUAL, qualifiers appearing before this item were ignored
     \VERSION\
    Compaq C V6.4-005 on OpenVMS VAX V7.3    
    
    --- HTTPD ---
    
    P1=BUILD
    Building for "VAX" architecture
    Without SSL
    $ IF JUST .NES. "" THEN GOTO 
    $!
    $ DELETE [.OBJ_VAX]*.*;*
    %DELETE-W-SEARCHFAIL, error searching for HT_ROOT:[SRC.HTTPD.OBJ_VAX]*.*;*
    -RMS-E-FNF, file not found
    $!
    $ ADMIN:   CC /DECC /STAND=RELAXED_ANSI /PREFIX=ALL /OPTIMIZE /NODEBUG /NOWARNING 
    	/FLOAT=D_FLOAT /DEFINE=(WASD_VMS_V6,WATCH_CAT=1,WATCH_MOD=0,WASD_ACME=0) 
    	/OBJ=[.OBJ_VAX]Admin    Admin.c

You *could* install one of the listed SSL toolkits, but we don't really need SSL encryption for our little test (emulated) box at the moment. As previously mentioned, this will take some time - so find something constructive to do while you wait. I suggest looking for VAX or Alpha hardware on an auction site ;-).  
  
Eventually the build will finish. We have some more steps to do though:

                                ********************
                                *  BUILD FINISHED  *
                                ********************
    
                              ************************
                              *  SERVER QUICK-CHECK  *
                              ************************
    
    This executes the package demonstration procedure, allowing the basic package
    to be evaluated or checked.  You may run this at any time to again check the
    package for basic functionality using @HT_ROOT:[INSTALL]DEMO.COM
    
    Execute the demonstration procedure? [NO]: NO
    
                            ****************************
                            *  CONTINUE INSTALLATION?  *
                            ****************************
    
    Continue the installation? [NO]: YES
    
    %SECHAN-I-RDBADDMSG, identifier WASD_HTTP_SERVER value 80010001 added to rights database
    %SECHAN-I-RDBADDMSG, identifier WASD_HTTP_NOBODY value 80010002 added to rights database
    %SECHAN-I-RDBADDMSG, identifier WASD_IGNORE_THIS value 80010003 added to rights database
    
                         **********************************
                         *  CREATE/MODIFY SERVER ACCOUNT  *
                         **********************************
    
    The 'server' account HTTP$SERVER is the one the HTTPd process executes as.
    It is considered a security advantage to script using a different account.
    
    It must have a unique UIC, preferably in a group of it's own.
    DO NOT choose the SYSTEM group ([1,*]) or other privileged group, or [3nn,*]
    which is reserved to OpenVMS!
    
    Note: [077,1] is a suggested UIC.
    You will be shown whether the entered uic exists before continuing.
    Entering "NONE" OR "0" skips account creation/modification.
    
    [077,1]: 077,1
    
    %UAF-W-BADSPC, no user matches specification
    
    If no user matched the specification then the UIC is available!
    Choices: YES, create the account using this UIC.  NO, select another.
    
    [NO]: YES

The server account "HTTP$SERVER" must have a unique home directory.

The default is a reasonable location for most sites.

If another device is preferred or already in place, out of the package tree,
then that can be specified and used.  The directory name should remain as
[HTTP$SERVER] however.  Package security settings are applied to this.

You will be shown whether the home area already exists before continuing.
Entering "NONE" OR "0" exits this dialog.

    [HT_ROOT:]: HT_ROOT
    
    The area HT_ROOT:[HTTP$SERVER] currently exists.
    Continue to use this?
    
    [NO]: YES
    
    HTTP$SERVER account created, setting ...
    %UAF-I-MDFYMSG, user record(s) updated
    %UAF-I-MDFYMSG, user record(s) updated
    %UAF-I-MDFYMSG, user record(s) updated
    %UAF-I-MDFYMSG, user record(s) updated
    %UAF-I-GRANTMSG, identifier WASD_HTTP_SERVER granted to HTTP$SERVER
    
    Username: HTTP$SERVER                      Owner:  WASD Server
    Account:                                   UIC:    [77,1] ([HTTP$SERVER])
    CLI:      DCL                              Tables: DCLTABLES
    Default:  HT_ROOT:[HTTP$SERVER]
    LGICMD:   LOGIN.COM
    Flags:  DisNewMail DisMail
    Primary days:   Mon Tue Wed Thu Fri        
    Secondary days:                     Sat Sun
    Primary   000000000011111111112222  Secondary 000000000011111111112222
    Day Hours 012345678901234567890123  Day Hours 012345678901234567890123
    Network:  ##### Full access ######            ##### Full access ######
    Batch:    ##### Full access ######            ##### Full access ######
    Local:    -----  No access  ------            -----  No access  ------
    Dialup:   -----  No access  ------            -----  No access  ------
    Remote:   -----  No access  ------            -----  No access  ------
    Expiration:            (none)    Pwdminimum:  6   Login Fails:     0
    Pwdlifetime:         90 00:00    Pwdchange:      (pre-expired) 
    Last Login:            (none) (interactive),            (none) (non-interactive)
    Maxjobs:         0  Fillm:       300  Bytlm:      5000000
    Maxacctjobs:     0  Shrfillm:      0  Pbytlm:           0
    Maxdetach:       0  BIOlm:      2000  JTquota:       4000
    Prclm:         100  DIOlm:      1000  WSdef:         1000
    Prio:            4  ASTlm:      2000  WSquo:         4000
    Queprio:         0  TQElm:       100  WSextent:     20000
    CPU:        (none)  Enqlm:       500  Pgflquo:     500000
    Authorized Privileges: 
      NETMBX    TMPMBX
    Default Privileges: 
      NETMBX    TMPMBX
    Identifier                         Value           Attributes
      WASD_HTTP_SERVER                 %X80010001      
    
    Press RETURN to continue: 

What is displayed at the end may be a lot to take in. It's what user-accounts look like from UAF. There are a lot of different fields here which will be discussed at a later time, for now all you need to know that a user has been created for the server: **HTTP$SERVER** with a UIC of **[77,1]**. Hit RETURN to continue, and you will be presented with another prompt for creating an additional user - **HTTP$NOBODY**, which is used for the execution of DCL & DECnet scripts. The defaults will be fine for us.

~

    Note: [076,1] is a suggested UIC.
    You will be shown whether the entered uic exists before continuing.
    Entering "NONE" OR "0" skips account creation/modification.
    
    [076,1]: 
    [NO]: YES
    [HT_ROOT:]:         
    
    The area HT_ROOT:[HTTP$NOBODY] currently exists.
    Continue to use this?
    
    [NO]: YES
    Press RETURN to continue: 
    
              ********************************************************
              *  GRANT WASD_HTTP_NOBODY TO OTHER SCRIPTING ACCOUNTS  *
              ********************************************************
    If you have other accounts that script using files contained in the general
    scripting areas ([CGI-BIN], [AXP-BIN], [IA64-BIN] or [VAX-BIN]) you almost
    certainly will need to grant the WASD_HTTP_NOBODY rights identifer to allow
    those accounts access to the files in the scripting directories.
    
    If you use a scripting account (HTTP$NOBODY) separate to the server account
    (HTTP$SERVER) you should never, and should never need to, grant the
    WASD_HTTP_NOBODY identifier to the server account.  The idea is to isolate the
    two environments as much as possible.
    
    Account name? []: *ENTER*
    
                            *****************************
                            *  (RE)SECURE THE PACKAGE?  *
                            *****************************
    
    Begin to make changes to files and security settings in the package.
    
    Secure the package? [NO]: YES
    
                       **************************************
                       *  SETTING PACKAGE FILE PROTECTIONS  *
                       **************************************
    
    Please be patient, this may take some (considerable) time ...
    
    PROGRESS: 100...200...300...
    
    We can proceed with with the installation, just install everything - I'm sure you'll want to play with all the different scripts at some point.
    
    	                       *****************************
    	                        *  SERVER WRITE TO [LOCAL]  *
    	                        *****************************
    
    	To allow updating of configuration files located in HT_ROOT:[LOCAL] via the
    	Server Administration interface, the [LOCAL] directory must have a specific
    	access control entry added.  Note that write access cannot occur unless
    	HTTPD$AUTH path access is also configured.
    
    	Allow server write access to [LOCAL]? [NO]: YES
    ~
                              *************************
                              *  HTTPD SUPPORT FILES  *
                              *************************
    
    Copies files from HT_ROOT:[EXAMPLE]
    
      STARTUP.COM           to    HT_ROOT:[STARTUP]
      SHUTDOWN.COM          to    HT_ROOT:[STARTUP]
      STARTUP_DECNET.COM    to    HT_ROOT:[STARTUP]
      STARTUP_LOCAL.COM     to    HT_ROOT:[STARTUP]
      STARTUP_SERVER.COM    to    HT_ROOT:[STARTUP]
    
      HTTPD$AUTH.CONF       to    HT_ROOT:[LOCAL]
      HTTPD$CONFIG.CONF     to    HT_ROOT:[LOCAL]
      HTTPD$MAP.CONF        to    HT_ROOT:[LOCAL]
      HTTPD$MSG.CONF        to    HT_ROOT:[LOCAL]
    
    Copy the files? [NO]: YES
    
    	                        *****************************
    	                        *  INSTALL PACKAGE SCRIPTS  *
    	                        *****************************
    
    	The procedure HT_ROOT:[INSTALL]SCRIPTS.COM installs package scripts.
    	It prompts for selected groups of scripts to be installed or removed.  More
    	information is available when using the procedure.  Scripts available with this
    	release of the package will not be available for use by the server until this
    	procedure is performed.
    
    	You can execute the procedure now or do it later manually.
    
    	Execute the procedure now? [NO]: YES
    
    	                        ****************************
    	                        *  SERVER UTILITY SCRIPTS  *
    	                        ****************************
    
    	PCACHE.EXE ......... proxy cache reporting and maintainance script
    	PROXYMUNGE.EXE ..... reverse-proxy URL rewriting for HTML and CSS
    	QDLOGSTATS.EXE ..... Quick and Dirty LOG STATisticS
    
    	Install these scripts? [NO]: YES
    
    	                         ************************
    	                          *  USEFUL VMS SCRIPTS  *
    	                          ************************
    
    	Conan The Librarian ..... Help and Text Library access
    	HyperReader ............. Online Documentation, Bookreader and BNU access
    	HyperSPI ................ System Performance Information
    	hyperDISK ............... graphical disk usage report
    	SHOW ...................  provides system information (must be enabled)
    
    	Install these scripts? [NO]: YES
    
    	                       *****************************
    	                        *  DOCUMENT/FILE SEARCHING  *
    	                        *****************************
    
    	QUERY and EXTRACT are scripts that can be used to perform ad hoc searching of
    	HTML and plain-text documents and files, returning all or partial documents.
    	The scope of where they can search should be carefully controlled but they can
    	be very useful.  Check script source descriptive prologue for more detail.
    
    	Install these scripts? [NO]: YES
    
    	                   ***************************************
    	                   *  CGIPLUS/RTE DEMONSTRATION SCRIPTS  *
    	                   ***************************************
    
    	The CGIplus demonstration scripts are examples of how to create persistent
    	scripting using DCL and the C language.  See the "Scripting Overview" document
    	for further information on CGIplus.
    
    	Includes the CGIsapi (ISAPI) environment and demonstration DLL.
    
    	Includes the RTE (Run Time Environment) example interpreter.
    
    	Install these scripts? [NO]: YES
    
                          	   *******************************
    	                       *  DCL DEMONSTRATION SCRIPTS  *
    	                       *******************************
    
    	The DCL demonstration scripts are examples of CGI scripting using DCL.
    
    	CGI_SYMBOLS.COM ....... displays the CGI variables available to a script
    	CGIUTL.EXE ............ utility for assisting with DCL scripts
    	COOKIE_DEMO.COM ....... an example of cookie manipulation using DCL.
    	FORMWORK.EXE .......... HTML form data validation and CSV processor
    	IPCTICKLER.EXE ........ script programmer  education tool
    	TMAILER.EXE ........... email using a template
    
    	Some include using the CGIUTL utility within the DCL environment.
    
    	Install these scripts? [NO]: YES
    
    	                         ***************************
    	                         *  MISCELLANEOUS SCRIPTS  *
    	                         ***************************
    
    	Calendar ........ simple calendar maker
    	Charset ......... displays the browser character set
    	Colors .......... displays fonts with different fore/background colors
    	Fetch ........... can get pages and other resources from HTTP servers
    	gList ........... list and display graphics in a directory
    
    	Install these scripts? [NO]: YES
    
    	                  **************************************
    	                   *  OSU/DECNET DEMONSTRATION SCRIPTS  *
    	                   **************************************
    
    	These are some OSU demonstration scripts (from the OSU package).
    	There are also WASD-specific CGI DECnet script examples.
    
    	Install these scripts? [NO]: YES
    
    	                      ********************************
    	                      *  JAVA DEMONSTRATION CLASSES  *
    	                      ********************************
    
    	The JAVA.COM java script wrapper procedure and example Java classes.
    
    	Install these scripts? [NO]: YES

Well done! You now have a working HTTP server installed on your system. You can start it up now by running its startup file.

    $ set def DUA1:[HT_ROOT.STARTUP]
    $ @startup.com
    %WASD-I-STARTUP, begin
    %WASD-I-STARTUP, using non-SSL image
    %HTTPD-S-PROC_ID, identification of created process is 00000218
    %WASD-I-STARTUP, end

Everything appears to be in order, let's have a look at the running processes:

    $ show system/full
    OpenVMS V7.3  on node CGXVAX  14-JAN-2009 20:28:15.61  Uptime  1 21:25:15
            VAXserver 3900 Series
      Pid    Process Name    State  Pri      I/O       CPU       Page flts  Pages
    00000201 SWAPPER         HIB     16        0   0 00:00:00.15         0      0   
             [SYSTEM]                                                           0Kb
    00000205 CONFIGURE       HIB      8        5   0 00:00:00.06       112    175   
             [SYSTEM]                                                          87Kb
    00000206 LANACP          HIB     12       41   0 00:00:00.11       354    712   
             [SYSTEM]                                                         356Kb
    00000208 IPCACP          HIB     10        6   0 00:00:00.10        99    177   
             [SYSTEM]                                                          88Kb
    00000209 ERRFMT          HIB      8     1475   0 00:00:00.41       146    227   
             [1,6]                                                            113Kb
    0000020B OPCOM           HIB      8      264   0 00:00:00.31       328    180   
             [SYSTEM]                                                          90Kb
    0000020C AUDIT_SERVER    HIB     10       96   0 00:00:01.00       528    919   
             [SYSTEM]                                                         459Kb
    0000020D JOB_CONTROL     HIB     10       48   0 00:00:00.17       192    343   
             [SYSTEM]                                                         171Kb
    0000020E SECURITY_SERVER HIB     10       32   0 00:00:03.05      1869   1509   
             [SYSTEM]                                                         754Kb
    0000020F TP_SERVER       HIB      9    10886   0 00:00:44.46       205    317   
             [SYSTEM]                                                         158Kb
    00000210 TCPIP$INETACP   HIB     10      155   0 00:00:00.53       757    855   
             [SYSTEM]                                                         427Kb
    00000214 INT16H          LEF      9      120   0 00:00:00.37       714    512   
             [INT16H]                                                         256Kb
    00000216 SYSTEM          CUR      5    20474   0 00:02:13.67      7147    336   
             [SYSTEM]                                                         168Kb
    00000218 HTTPd:80        HIB      6      840   0 00:00:05.02      3764   3091   
             [HTTP$SERVER]                                                   1545Kb

Excellent. Not only is WASD HTTPd running, it's running as the user it should be - **HTTP$SERVER**. Try opening a browser and accessing your new server. Many of the demo scripts+functions won't work for security reasons - you will be able to enable what you like later on when you configure and customize your server. For now, you can run '**DEMO.COM**' from '**DUA1:[HT_ROOT.INSTALL]**' which will start a demonstration server up on port 7080 in "promiscuous" mode. This should allow you to test the examples included with WASD. Be warned though, some scripts will cause the demo instance to die due the 'SYSTEM' account's **AST quota**. Quotas and the UAF will be explained later.

