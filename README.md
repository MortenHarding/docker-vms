[OpenVMS](http://en.wikipedia.org/wiki/OpenVMS)  is an operating system originally developed by  [DEC](http://en.wikipedia.org/wiki/Digital_Equipment_Corporation)  (Digital Equipment Corporation), a company acquired by  [Compaq](http://en.wikipedia.org/wiki/Compaq)  which was then acquired by  [HP](http://en.wikipedia.org/wiki/Hewlett-Packard)  for the  [VAX](http://en.wikipedia.org/wiki/VAX)  platform.  
  
Although development started in the mid-1970s into the 1980s, OpenVMS is still very much alive with up-to version 7.3 available for VAX, and continued development in 8.x for  [DEC Alpha](http://en.wikipedia.org/wiki/DEC_Alpha)  and now Intel  [Itanium](http://en.wikipedia.org/wiki/Itanium)  architectures. Even Oracle, who acquired DEC's  [Rdb](http://en.wikipedia.org/wiki/Oracle_Rdb)  RDBMS have  [stated](http://www.oracle.com/technology/products/rdb/htdocs/rdb7/rdb_statement_of_direction.html)  that they will continue to support and develop Rdb, creating a lesser gap between it and Oracle Database systems.  
  
[SIMH](http://en.wikipedia.org/wiki/SIMH)  is a set of emulators for various systems and is developed by Bob Supnik, who is a former engineer for DEC. One of the systems it is able to emulate is the VAX. This is what we're interested in. An excellent feature of SIMH (among many) is that it supports networking (albeit experimental support; I've had no problems so far).  
  
If you are unable to install OpenVMS, consider looking at  ~~[http://deathrow.vistech.net](http://deathrow.vistech.net/)  (Beave's former OpenVMS cluster)~~ [PolarHome](http://www.polarhome.com/) where you can get a taste of OpenVMS without installation.  
  
So, we're going to install OpenVMS within SIMH's VAX emulator. There are a few prerequisites, some of which may be difficult to meet:

-   [SIMH w/ Networking](http://simh.trailing-edge.com/)  (  [win32](http://simh.trailing-edge.com/sources/simhv38-0-exe-ether.zip)  /  [macOS](http://macappstore.org/simh/))
-   [WinPcap](http://www.winpcap.org/)  (for win32 SIMH networking)
-   A  [HP User Society (Formerly DECUS)](http://en.wikipedia.org/wiki/DECUS)  membership (hint:  [Connect Deutschland](https://www.connect-community.de/Membership/application)  has no fee for basic membership. Site is in German)
-  [HPE OpenVMS Hobbyist Registration](https://www.hpe.com/h41268/live/index_e.aspx?qid=24548)  (For your license PAKs)
-   [OpenVMS 7.3 VAX Media](http://mirrors.pdp-11.ru/_vax__/_VMS/_distrib/7.X/)

DECUS membership is required to be able to register licenses for your hobbyist system. Some chapters may issue your membership number straight away online, others will send you a membership card in the post.

When HPE exit the OpenVMS game and VSI fully take over, there is no guarantee that the hobbyist program will be continued, though I heard from Hari at HPE that they are interested in fostering the program for their own VMS version.
  
**!!! Mac OS X Note !!!**  
  
The binaries linked to in the prerequisites may fail on your system.  
On Mac OS X 10.5.5 (Intel) they caused problems for me, so you should  install Apple Xcode and compile from source. Follow [this guide](https://web.archive.org/web/20090312034321/http://64.223.189.234/node/922) if using GCC 4.x.  
  
**!!!**  
  
**Getting Ready**  
  
I'll assume that you have already received the OpenVMS VAX and additional license paks via E-mail. The licenses aren't required to install OpenVMS - but without them you will have a very limited installation.  
  
Start off by creating a directory somewhere, be this _~/OpenVMS_, _C:\OpenVMS_, _/Users/int16h/OpenVMS_ or wherever you please. Copy the VAX emulator from SIMH to this directory, as well as **ka655.bin**. If you have an ISO image of the installation media, copy those there too (I will be using an ISO for this tutorial).  
  
**Configuring SIMH::VAX**  
  
SIMH needs to know how much RAM and other virtual hardware you will be attaching. Although you could do this from the SIMH prompt, it's not very practical so we will create a config file named **openvms.ini**. Below is a commented config which will suit our needs, but you will need to customize it for your own use.

    ; Load CPU microcode
    load -r ka655.bin
    ;
    ; Set memory allocation to 64M
    set cpu 64m
    ;
    ; We will have 2 DEC RA92 disk drives, about 1.5G capacity.
    set rq0 ra92
    set rq1 ra92
    ;
    ; rq3 will be a CD-ROM drive
    set rq3 cdrom
    ;
    ; Attach the devices to files, these will be our virtual disks
    attach rq0 d0.dsk
    attach rq1 d1.dsk
    ;
    ; Attach the CD-ROM drive to our installation media ISO (use 'dd' ;)
    attach -r rq3 OpenVMS73.iso
    ;
    ; We don't need rl and ts devices, so we can disable them.
    ;
    set rl disable
    set ts disable
    ;
    ; Attach Ethernet to a network interface. This will work in 'bridged'
    ; mode. Make sure to define a fake MAC address if using Windows.
    ; Unlike Linux, *BSD etc Windows does not have a nice, logical alias
    ; for network interfaces.
    ;
    ; Windows Example:
    ;set xq mac=08-00-2B-AA-BB-CC
    ;attach xq \Device\NPF_{9622ACD6-7383-4C42-B8F3-FBFA22573B71}
    ;
    ; Linux/*BSD/UNIX Example:
    ;attach xq eth0
    ;
    ; Mac OS X:
    ;attach xq en0
    ;
    ; Uncomment the following if you'd prefer to telnet into SIMH
    ; from another machine rather than use the local console, 6969=port.
    ;
    ;set telnet 6969
    ;
    ;
    ; Boot the system:
    ;
    boot cpu

Save this file, and make sure you're in the directory you created in a terminal.  
  
**Installing OpenVMS**  
  

    Run: **./vax openvms.ini**
    
    sh-3.2# ./vax openvms.ini 
    VAX simulator V3.8-0
    RQ: unit is read only
    Eth: opened en0
    
    KA655-B V5.3, VMB 2.7
    Performing normal system tests.
    40..39..38..37..36..35..34..33..32..31..30..29..28..27..26..25..
    24..23..22..21..20..19..18..17..16..15..14..13..12..11..10..09..
    08..07..06..05..04..03..
    Tests completed.
    
    >>>

Good. The system has booted and is now awaiting further instructions. Those of you familiar with Sun SPARC hardware may recognise an initial firmware prompt like this. From here, we will boot our virtual CD-ROM with **boot dua3**.

    >>>boot dua3
    (BOOT/R5:0 DUA3
      2..
    -DUA3
      1..0..
    
    %SYSBOOT-I-SYSBOOT Mapping the SYSDUMP.DMP on the System Disk
    %SYSBOOT-W-SYSBOOT Can not map SYSDUMP.DMP on the System Disk
    %SYSBOOT-W-SYSBOOT Can not map PAGEFILE.SYS on the System Disk
       OpenVMS (TM) VAX Version X7G7 Major version id = 1 Minor version id = 0
    %WBM-I-WBMINFO Write Bitmap has successfully completed initialization.
    PLEASE ENTER DATE AND TIME (DD-MMM-YYYY  HH:MM)  09-JAN-2009 20:11
    
    OpenVMS installation will now probe your system for available devices. Once it has finished enumerating your devices, it will prompt you to enter "**YES**".
    
    Configuring devices . . .
    Now configuring HSC, RF, and MSCP-served devices . . .
    
    Please check the names of the devices which have been configured,
    to make sure that ALL remote devices which you intend to use have
    been configured.
    
    If any device does not show up, please take action now to make it
    available.
    
    Available device  DUA0:                            device type RA92
    Available device  DUA1:                            device type RA92
    Available device  DUA2:                            device type RD54
    Available device  DUA3:                            device type RRD40
    Available device  DYA0:                            device type RX02
    Available device  DYA1:                            device type RX02
    Available device  MUA0:                            device type TK50
    Available device  MUA1:                            device type TK50
    Available device  MUA2:                            device type TK50
    Available device  MUA3:                            device type TK50
    
    Enter "YES" when all needed devices are available:  YES
    %BACKUP-I-IDENT, Stand-alone BACKUP T7.2; the date is  9-JAN-2009 20:15:24.42

You will now be dropped at what looks like a shell-prompt. OpenVMS and OpenVMS components are generally installed by extracting backup archives. This of course comes from the days when tape drives were more common. Let's extract the backup saveset to our first drive with "**backup dua3:vms073.b/save_set dua0:**":

    $ backup dua3:vms073.b/save_set dua0:
    
    %BACKUP-I-PROCDONE, operation completed.  Processing finished at  9-JAN-2009 20:20:00.82
    If you do not want to perform another standalone BACKUP operation,
    use the console to halt the system.
    
    If you do want to perform another standalone BACKUP operation, 
    ensure the standalone application volume is online and ready.
    Enter "YES" to continue: 

This will take a short time, and you won't be informed until it is complete. We are finished with this for now, so you may press CTRL-E to halt our system and drop you at the SIMH prompt. Now we boot the system again with "**boot cpu**":

    Simulation stopped, PC: 839ABD46 (BEQL 839ABDB4)
    sim> boot cpu
    
    KA655-B V5.3, VMB 2.7
    Performing normal system tests.
    40..39..38..37..36..35..34..33..32..31..30..29..28..27..26..25..
    24..23..22..21..20..19..18..17..16..15..14..13..12..11..10..09..
    08..07..06..05..04..03..
    Tests completed.

Great. Now this time, instead of booting **dua3**, we will boot our first virtual hard disk where we just installed the backup to - **dua0**:

    >>>set boot dua0
    >>>boot
    (BOOT/R5:0 DUA0
    
      2..
    -DUA0
      1..0..
    
    %SYSBOOT-I-SYSBOOT Mapping the SYSDUMP.DMP on the System Disk
    %SYSBOOT-W-SYSBOOT Can not map SYSDUMP.DMP on the System Disk
    %SYSBOOT-I-SYSBOOT Mapping PAGEFILE.SYS on the System Disk
    %SYSBOOT-I-SYSBOOT SAVEDUMP parameter not set to protect the PAGEFILE.SYS
       OpenVMS (TM) VAX Version BI73-7G7 Major version id = 1 Minor version id = 0
    %WBM-I-WBMINFO Write Bitmap has successfully completed initialization.
    
               OpenVMS VAX V7.3 Installation Procedure
    
                     Model: VAXserver 3900 Series
                     System device: RA92 - _DUA0:
                       Free Blocks: 2854566
                          CPU type: 10-01
    
    * Please enter the date and time (DD-MMM-YYYY HH:MM) 09-JAN-2009 20:36

As you can see, we are now entering the real OpenVMS installation and it reports that we are using a VAXServer 3900, the system disk is a DEC RA92 and we have 2854566 blocks free. Enter the current date+time, then hit enter.  
  
You'll see quite a few messages scrolling up the screen, one which may seem quite alarming is:

    %%%%%%%%%%%  OPCOM   9-JAN-2009 20:36:08.92  %%%%%%%%%%%
    Message from user SYSTEM
    %LICENSE-E-NOAUTH, DEC VAX-VMS use is not authorized on this node
    -LICENSE-F-NOLICENSE, no license is active for this software product
    -LICENSE-I-SYSMGR, please see your system manager

During the install, we will enter our license for DEC VAX-VMS; So just ignore this for now. Let's continue:

If this system disk is to be used in an OpenVMS Cluster with multiple system disks, then each system disk must have a unique volume label. Any nodes having system disks with duplicate volume labels will fail to boot into the cluster.

       You can indicate a volume 
       label of 1 to 12 characters in length.
       If you want to use the default name of
       OVMSVAXSYS, press RETURN in response to
       the next question.
    
    * Enter the volume label for this system disk [OVMSVAXSYS]: 

For this tutorial, I won't cover setting up a cluster so just leave the default.

    * Enter name of drive holding the OpenVMS distribution media: DUA3
    * Is the OpenVMS media ready to be mounted? [N] Y
    %MOUNT-I-MOUNTED, VAXVMS073 mounted on _DUA3:
    
       Select optional software you want to install.  You can install one
       or more of the following OpenVMS or DECwindows components:
    
        o OpenVMS library                              -  52200 blocks
        o OpenVMS optional                             -  19000 blocks
        o OpenVMS Help Message                         -  10400 blocks
        o OpenVMS Management Station                   -  20000 blocks
        o DECwindows base support                      -   4400 blocks
        o DECwindows workstation support               -  23800 blocks
              -  75 dots per inch video fonts          -    (included)
              - 100 dots per inch video fonts          -   6200 blocks
        o DECnet-Plus networking                       -  80000 blocks
        o DECnet Phase IV networking                   -    800 blocks
    
    	    Space remaining on system disk:  2854377 blocks

You can go ahead and install everything if you have space, I imagine you will want to see everything OpenVMS has to offer at some point - so it's best to install these sets now rather than later.

    * Do you want to install the OpenVMS library files? (Y/N) Y
    
       	Space remaining on system disk:  2802177 blocks
    
    * Do you want to install the OpenVMS optional files? (Y/N) Y
    
        Space remaining on system disk:  2783177 blocks
    
    ~~
    
    * Do you want to install the MSGHLP database? (Y/N) Y
    
    ~~ 
    
    * Where do you want to install the MSGHLP database?
        [SYS$COMMON:[SYSHLP]] [ENTER]
    
    ~~
    
    * Do you want to install the optional OpenVMS Management Station files? (Y/N) Y
    
    ~~
    
    * Do you want the DECwindows base support? (Y/N) Y
    
    ~~
    
    * Do you want to install DECwindows workstation support? (Y/N) Y
    
    ~~
    
    * Do you want 100 dots per inch video fonts installed? (Y/N) Y
    
    ~~
    
    * Do you want to install DECnet-Plus? (Y/N) Y
    
    ~~
    
        The following options will be provided:
    
            OpenVMS library
            OpenVMS optional
            OpenVMS Help Message
            OpenVMS Management Station Software -- PC files
            DECwindows base support
            DECwindows workstation support with:
                -  75 dots per inch video fonts
                - 100 dots per inch video fonts
            DECnet-Plus
    
        Space remaining on system disk:  2638377 blocks
    
    * Is this correct? (Y/N) Y

Phew! Now, at last - the backup save sets will be extracted/restored. This will take some time, enough for a cigarette at least. When it completes, you'll be presented with some useful information regarding OpenVMS Clusters:

    In an OpenVMS Cluster, you can run multiple systems sharing all files
       except PAGEFILE.SYS, SWAPFILE.SYS, SYSDUMP.DMP, and VAXVMSSYS.PAR.
    
       Cluster configuration cannot be done at this time because no network
       is present.  In order to configure a cluster you must FIRST do one
       or both of the following:
    
       o Install DECnet-Plus (or DECnet Phase IV), or
       o Execute SYS$STARTUP:LAN$STARTUP.COM by removing the
          comment delimiter ("!") from the line
    
              $! @SYS$STARTUP:LAN$STARTUP
    
         in SYS$MANAGER:SYSTARTUP_VMS.COM.
    
       Then configure the cluster by executing the following command:
    
                 @ @SYS$MANAGER:CLUSTER_CONFIG
    
       See the OpenVMS System Manager's Manual: Essentials for more information.

For future reference, you should keep a copy of such messages for future configuration of components.

    	* Do you want DECwindows Motif as the default windowing system? (Y/N) Y
    
       Now we will ask you for new passwords for the following accounts:
    
            SYSTEM, SYSTEST, FIELD
    
       Passwords must be a minimum of 8 characters in length.  All passwords
       will be checked and verified.  Any passwords that can be guessed easily
       will not be accepted.

Now, this is the equivalent of setting your root password on a UNIX-like Operating System. Make sure to set a decent password for SYSTEM and different passwords for SYSTESY and FIELD. You could make them all the same if you're not planning on allowing anyone else to access your new OpenVMS system.

    * Enter password for SYSTEM: 
    * Re-enter for verification: 
    %UAF-I-MDFYMSG, user record(s) updated
    %VMS-I-PWD_OKAY, account password for SYSTEM verified

You'll see similar messages for the remaining accounts.

    Creating RIGHTS database file, SYS$SYSTEM:RIGHTSLIST.DAT
    Ignore any "-SYSTEM-F-DUPIDENT, duplicate identifier" errors.
    
    %UAF-I-RDBCREMSG, rights database created
    %UAF-I-RDBADDMSGU, identifier DEFAULT value [000200,000200] added to rights database
    %UAF-I-RDBADDMSGU, identifier FIELD value [000001,000010] added to rights database
    %UAF-I-RDBADDMSGU, identifier SYSTEM value [000001,000004] added to rights database
    %UAF-I-RDBADDMSGU, identifier SYSTEST value [000001,000007] added to rights database
    %UAF-E-RDBADDERRU, unable to add SYSTEST_CLIG value [000001,000007] to rights database
    -SYSTEM-F-DUPIDENT, duplicate identifier
    %UAF-I-NOMODS, no modifications made to system authorization file
    %UAF-I-RDBDONEMSG, rights database modified
    
    Creating MODPARAMS.DAT database file, SYS$SYSTEM:MODPARAMS.DAT

These UAF messages confirm that the rights database has been created, and the system users have been added. We will use the UAF (User Authorization File) tool later to add a normal user.  
  
Next you'll be prompted for the SCSNODE name and SCSSYSTEMID for your VMS node, as this is your first installation and not part of a cluster - enter what you like (within reason, the SCSSYSTEMID should be between 1025 and 65535).

    * Please enter the SCSNODE name: CGXVAX
    
    * Please enter the SCSSYSTEMID:  1025

Now you should have your OpenVMS licenses/PAKs (Product Authorization Keys) ready.

Continuing with OpenVMS VAX V7.3 Installation Procedure.

        Configuring all devices on the system ...
    
        If you have Product Authorization Keys (PAKs) to register, you can
        register them now.
    
    * Do you want to register any Product Authorization Keys? (Y/N): Y
    
        VMS License Management Utility Options:
    
            1. REGISTER a Product Authorization Key
    ~~
    
    Enter one of the above choices [1]: 1
    Do you have your Product Authorization Key? [YES]: YES
    
    Find your PAK for "VAX-VMS". This PAK will be entered manually by extracting the information from each field and entering them when prompted... For future PAKs, you may copy-paste the command straight from your e-mail.
    
     
    Here is a list of the license information just entered:
    
                         Issuer:  OPENVMS_HOBBYIST
                  Authorization:  DECUS-XXX-#########-#######
                   Product Name:  VAX-VMS
                       Producer:  DEC
                          Units:  0
                   Release Date:  
                        Version:  
               Termination Date:  ##-XXX-####
                   Availability:  
                       Activity:  A
                        Options:  NO_SHARE
                          Token:  
                    Hardware ID:  
                       Checksum:  #-XXXX-XXXX-XXXX-XXXX
    
    Is that correct? [YES]:YES
    Registering VAX-VMS license in SYS$COMMON:[SYSEXE]LMF$LICENSE.LDB...
    
    Do you want to LOAD this license on this system? [YES]:
    %LICENSE-I-LOADED, DEC VAX-VMS was successfully loaded with 0 units
    
    You may enter some other PAKs now, or wait until later. I will install others later. Enter '99 [enter]' to exit the license management utility.
    
    ********************************************************************************
    
        After the system has rebooted you should register any additional
        Product Authorization Keys (PAKs) you have, or receive in the
        future, by executing the following procedure:
    
            $ @SYS$UPDATE:VMSLICENSE
    
        See the OpenVMS License Management Utility Manual for any additional
        information you need.
    
    ********************************************************************************

Another piece of useful information to remember for later. Now, you'll be prompted to set your time zone. Follow the prompts until you're asked to provide information about DECnet-Plus, then respond as follows:

    * Enter name of drive holding the DECnet-Plus kit: DUA3
    * Is DUA3: ready to be mounted? [N] y
    
    The following product has been selected:
        DEC VAXVMS DECNET_OSI V7.3             Layered Product
    
    ~~
    
    This product requires one of two PAKs: DVNETEND or DVNETRTG.
    
    Do you want the defaults for all options? [YES] YES

This set isn't required, but as we had had chosen to install everything earlier - we may as well. Installation will run for a few minutes, then OpenVMS Installation will run AUTOGEN to update the system. This will take a couple of minutes, then the system will be rebooted - dropping you back at the SIMH prompt. Start the system back up:

    sim> boot cpu
    
    KA655-B V5.3, VMB 2.7
    Performing normal system tests.
    40..39..38..37..36..35..34..33..32..31..30..29..28..27..26..25..
    24..23..22..21..20..19..18..17..16..15..14..13..12..11..10..09..
    08..07..06..05..04..03..
    Tests completed.
    
    >>>boot
    (BOOT/R5:0 DUA0
    
    Soon you will see:
    
    *****************************************************************
    
    OpenVMS VAX V7.3
    
    You have SUCCESSFULLY installed the OpenVMS VAX Operating System.
    
    The system is now executing the STARTUP procedure.  Please
    wait for the completion of STARTUP before logging in to the
    system.
    
    *****************************************************************
    
    %STDRV-I-STARTUP, OpenVMS startup begun at  9-JAN-2009 21:56:36.10
    
    ~~~
    
    %SET-I-INTSET, login interactive limit = 64, current interactive value = 0
      SYSTEM       job terminated at  9-JAN-2009 21:57:04.05
    
      Accounting information:
      Buffered I/O count:            1621         Peak working set size:    1624
      Direct I/O count:               613         Peak page file size:      5504
      Page faults:                   5578         Mounted volumes:             0
      Charged CPU time:           0 00:00:24.99   Elapsed time:     0 00:00:31.61

Congratulations! You have installed OpenVMS 7.3 \o/. Now after all those pages of instructions and console-pastes, we'll proceed to configure OpenVMS a little bit.  
  
**Configuring OpenVMS**  
  
So, you are now presented with some information about your new system. Where do you go from here? Press **enter** and you'll see a welcome-banner followed by a prompt for you to login. Enter '**SYSTEM**' as the username, and the password you set during installation.

    Username: SYSTEM
    Password: 
     Welcome to OpenVMS (TM) VAX Operating System, Version V7.3
    $ 

At this point, I can see all you UNIX-like OS users gagging to explore the system and run commands such as 'uptime' and 'uname -a' to show off to all your friends. Well, I'm extremely sorry to disappoint you (and perhaps wasted your time so far!) but OpenVMS is not UNIX or in fact similar to any derivatives in any way. You can throw any hopes of POSIX compatibility out the window, too (well, there _is_ a POSIX compatibility interface/set for OpenVMS but we won't go into that ;).  
  
To satisfy the needs of your e-penis, you may run "**sh sys**" or in its full form: "**show system**". The "show" command is used to spit out a variety of information, many embedded devices such as routers have similar functions.

    $ sh sys
    OpenVMS V7.3  on node CGXVAX   9-JAN-2009 22:17:25.96  Uptime  0 00:21:04
      Pid    Process Name    State  Pri      I/O       CPU       Page flts  Pages
    00000201 SWAPPER         HIB     16        0   0 00:00:00.21         0      0   
    00000205 CONFIGURE       HIB      8        5   0 00:00:00.06       112    175   
    00000206 LANACP          HIB     12       33   0 00:00:00.25       366    788   
    00000208 IPCACP          HIB     10        6   0 00:00:00.03        99    177   
    00000209 ERRFMT          HIB      8       44   0 00:00:00.14       153    234   
    0000020B OPCOM           HIB      8       48   0 00:00:00.19       304    150   
    0000020C AUDIT_SERVER    HIB     10      133   0 00:00:00.53       569    815   
    0000020D JOB_CONTROL     HIB     10       30   0 00:00:00.12       191    342   
    0000020E SECURITY_SERVER HIB     10       35   0 00:00:00.43       766   1349   
    00000211 SYSTEM          CUR      7       97   0 00:00:00.62       869    498   

This isn't too different from what you'd see in a screen-dump of the 'top' command on UNIX-like systems.  
  
Now, let's get back on track. OpenVMS uses [DCL (DIGITAL Command Language)](http://en.wikipedia.org/wiki/DIGITAL_Command_Language), a scripting language developed by DIGITAL for their Operating Systems. You may think of it as the OpenVMS equivalent of BASH in that it's used as a "shell"/CLI as well as a normal scripting language.  
  
So far, we have used DUA3 (our virtual CD-ROM drive) and DUA0 (Our first hard disk), now we will initialise DUA1, our second virtual hard disk. It is good practice to keep system files on one disk, and data on others. This is especially useful for when/if you need to reinstall the Operating System, you can keep your users' data. Let's initialise the disk now and mount it:

    $ initialize dua1: DATA
    $ mount/system dua1 data
    %MOUNT-I-MOUNTED, DATA mounted on _CGXVAX$DUA1:

**n.B. Remember to have around another 1.5G of space free for this else bad things will happen. On initialisation of the new volume, the file d1.dsk grew to 719M**  
  
This is what you don't want to happen, else you'll need to boot the system again:

    $ initialize dua1: DATA
    RQ I/O error: No space left on device
    I/O error, PC: 83430D36 (ASHL #1,R3,R0)
    sim> 

Now that we have a new disk initialised and mounted, we will edit the site-specific startup file "**sys$manager:systartup_vms.com**" and add the mount command above so we don't have to manually mount the volume at each startup. We will need to let OpenVMS know that we are using a VT100-compatible terminal so we can use the full-screen VMS editor "edit" properly:

    $ set term/vt100
    $ edit sys$manager:systartup_vms.com

There's no right or wrong place to put this command really, but I like to mount volumes just before DECnet is setup+started. A general rule is to mount any additional volumes first, before running any startup processes which may rely on the volume being available:

    $! To start a batch queue, remove the comment delimiter ($!) from the
    $! following command line.
    $!
    $!$ START /QUEUE SYS$BATCH
    $!
    $ mount/system dua1: data
    $!
    $! In order to use asynchronous DECnet Phase IV on OpenVMS VAX systems only,
    $! remove the comment delimiter ($!) from the next two lines.
    
    Press CTRL-Z to save and quit 'EDIT'.
    
    409 lines written to file SYS$COMMON:[SYSMGR]SYSTARTUP_VMS.COM;2
    $ 

You may be wondering why ";2" is appended to the filename. OpenVMS stores multiple revisions of files as they are updated/edited. Some other operating systems and/or filesystems work in this manner including Novell Netware. You shouldn't have any problems with this, until you try and delete a file - OpenVMS will ask you to specify which revision you'd like to delete ;).  
  
**Adding Users**  
  
As in UNIX-like systems, OpenVMS has user and group IDs, however, unlike UNIX - they are not entities you can reference separately. The UID and GID-like values are an exclusive singleton, which is called a UIC (User Identification Code), the format of a UIC is [###,###] - where the first part is the group, and the second is the user. By default, users added to the UAF are disabled. We will now add our first user, whose 'home' directory is on our new disk, will have full system privileges and won't be disabled:

    $ set def sys$system
    $ r authorize
    UAF> add int16h/password=t3mp123/owner="int16h"/dev=dua1/dir=[int16h]/uic=[200,201]/flag=nodisuser/priv=all
    %UAF-I-ADDMSG, user record successfully added
    ~~

**set def** - This is short for "set default", which is the equivalent of the "cd" command on UNIX-like operating systems. Navigating around an OpenVMS system may take some getting used to, just think of it as the step after moving from DOS to UNIX. In this case:
	

> sys$system

is an alias for 

> **CGXVAX$DUA0:[SYS0.SYSCOMMON.][SYSEXE]**

 
  
**r authorize** - "r" is the shortened command for run. We need to be in the sys$system logical directory to run 'authorize' as this is where SYSUAF.DAT is stored.  
  
So, basically we are adding the user 'int16h', with initial password of 't3mp123' (this will be changed at first-login), owner is the user's real-name, dev is the device where the user's initial/home directory will reside, dir is the name of the directory on 'dev', uic is the user's UIC (groupid,uid - default group is 200), we have added the nodisuser flag to ensure the account isn't disabled, and finally we have given the uses all privileges on the system.  
  
After you run the 'add' line at the UAF prompt, your screen will fill with security notices. You should get used to them while connected to the system console, anything important you update on the system will trigger such alerts.  
  
Now, at the UAF prompt, type 'exit'. UAF will inform you that the User Authorisation file and rights database have been modified:

    UAF> exit
    %UAF-I-DONEMSG, system authorization file modified
    %UAF-I-RDBDONEMSG, rights database modified

Great! Now you have a 'normal' user you can login as, and gain full privs if you need them! Well, not quite. We need to manually create the user's directory and set the correct permissions:

    $ create/dir dua1:[int16h]
    $ set directory/owner=int16h dua1:[int16h]

Here you can see that we use the **create** command to create our new directory, then **set** to set the owner of the directory. DCL is quite flexible and efficient, most of the time you can turn a few commands into one longer command.

    $ create/dir dua1:[int16h]/owner=[int16h]

As you can see, DCL commands are quite logical and natural - it's just getting used to them which can be a problem when you usually spend your time in a UNIX shell.  
  
Now that we have added our user, and created a home-directory for it - you can logout and try to login with those credentials. Use "lo" (or "logout") to log out of the system.

    $ logout
      SYSTEM       logged out at  9-JAN-2009 23:43:01.47
    
     Welcome to OpenVMS (TM) VAX Operating System, Version V7.3    
    
    Username: int16h
    Password: 
     Welcome to OpenVMS (TM) VAX Operating System, Version V7.3
    
    Your password has expired; you must set a new password to log in
    
    New password: 
    Verification: 

As we are still using the system console, you will be notified of a "System UAF record modification" security event because we changed the password of a user.  
  
Now that we're logged in, we want to enable our full system privileges. This is done by running "**set proc/priv=all**". This is like running "su" on a UNIX-like system, except that we will still be the same user - just with "superuser" powers.

    $ set proc/priv=all

[Phil Wherry](http://www.wherry.com/) was a great help with the following, as before reading his tips - I had never installed OpenVMS and additional components from scratch, only used existing systems. We are going to be installing the OpenVMS TCP/IP stack+programs, this will require us to modify resource allocations within the system. We need to edit **modparams.dat** in **sys$system**:

    $ set def sys$system
    $ edit modparams.dat

The following lines should be added to the end of the file, save+exit by pressing CTRL-Z:

    ADD_GBLPAGES=10000
    ADD_GBLSECTIONS=100
    ADD_NPAGEDYN=800000
    ADD_NPAGEVIR=800000
    MIN_SPTREQ=6000

Now, these changes to the system won't take affect straight away. You may remember earlier on that the OpenVMS Installation ran "AUTOGEN" to update the system. We will now run it manually:

    $ set def sys$update
    $ @autogen getdata reboot nofeedback
    
    %AUTOGEN-I-BEGIN, GETDATA phase is beginning.
    %AUTOGEN-I-NEWFILE, A new version of SYS$SYSTEM:PARAMS.DAT has been created.
            You may wish to purge this file.
    %AUTOGEN-I-END, GETDATA phase has successfully completed.
    %AUTOGEN-I-BEGIN, GENPARAMS phase is beginning.
    %AUTOGEN-I-NEWFILE, A new version of SYS$MANAGER:VMSIMAGES.DAT has been created.
            You may wish to purge this file.
    
    ~~

After many more messages, the system will shutdown and you will be back at the SIMH prompt. "**boot cpu**" then "**boot dua0**" again. To bring up the system again. Finally, login with your user-account and "**set proc/priv=all**". We will then set some additional system parameters and shutdown the system again. As Phil said, these two processes could be done with only 1 reboot - but it's more clear this way and will help remind you that a reboot /is/ required after such alterations to the system.

    $ set proc/priv=all
    $ r sys$system:sysgen
    SYSGEN>  SET INTSTKPAGES 20
    SYSGEN>  WRITE CURRENT
    SYSGEN>  EXIT
    $ @sys$system:shutdown

Bring up the system again, and login.  
  
**Installing the OpenVMS TCP/IP Stack+Programs**  
  
Multiuser operating systems these days are mostly useless without a TCP/IP stack, and a way for remote users to login. Now we will install the PAK for TCP/IP and install it.

    $ set proc/priv=all
    $ mount/over=id dua3:
    MOUNT-I-WRITELOCK, volume is write locked
    %MOUNT-I-MOUNTED, VAXVMS073 mounted on _CGXVAX$DUA3:
    $ set def dua3:[tcpip_vax051.kit]

Traditionally, CD-ROMs are mounted by specifying the device and volume-ID. Providing the "/over=id" parameter instructs mount to mount the volume, ignoring the name of the volume. If you now execute "DIR" ("DIRECTORY"), you can see the contents of ua3:[tcpip_vax051.kit]:

    $ dir
    Directory DUA3:[TCPIP_VAX051.KIT]
    
    DEC-VAXVMS-TCPIP-V0501-15-1.PCSI;1      
    
    Total of 1 file.

As you can see, there is 1 file in this directory and it has a .PCSI extension. This is handled by the POLYCENTER Software Installation Utility. OpenVMS applications generally come in 1 of 3 kit formats:

-   **PCSI** - These are installed with the "product install" command
-   **VMSINSTAL** - These are 1 or more files with a sequential extension beginning with .A
-   **Self-Extracting** - The extension can vary, usually something like SFX_AXPEXE, SFX_I64EXE or SFX_VAXEXE

Anyway, to get back to our installation - we first need to install the **UCX** PAK. Refer to your OpenVMS Hobbyist e-mail with your licenses and paste it in:

    $ $ LICENSE REGISTER UCX -
    _$ /ISSUER=OPENVMS_HOBBYIST -
    _$ /AUTHORIZATION=DECUS-XXX-#########-####### -
    _$ /PRODUCER=DEC -
    _$ /UNITS=0 -
    _$ /TERMINATION_DATE=##-XXX-####  -
    _$ /ACTIVITY=CONSTANT=100 -
    _$ /CHECKSUM=#-XXXX-XXXX-XXXX-XXXX
    
    $ license load UCX
    %LICENSE-I-LOADED, DEC UCX was successfully loaded with 0 units

Proceed to install the kit by issuing: "**product install ***" this will scan the current directory for all packages to install - as there is only one, we don't need to select which we want and don't want:

    $ product install *
    
    The following product has been selected:
        DEC VAXVMS TCPIP V5.1-15               Layered Product
    
    Do you want to continue? [YES] YES
    
    When prompted, go for the default options.
    
    The following product will be installed to destination:
        DEC VAXVMS TCPIP V5.1-15               DISK$OVMSVAXSYS:[VMS$COMMON.]
    
    Portion done: 0% ~
    %PCSI-I-PRCOUTPUT, output from subprocess follows ...
    % - HELP has been updated. You may purge SYS$COMMON:[SYSHLP]HELPLIB.HLB 
    % 
    %PCSI-I-PRCOUTPUT, output from subprocess follows ...
    % TCPIP-W-PCSI_INSTALL 
    % - Execute SYS$MANAGER:TCPIP$CONFIG.COM to proceed with configuration of
    %   Compaq TCP/IP Services.
    % 
    Portion done: 100%
    
    The following product has been installed:
        DEC VAXVMS TCPIP V5.1-15               Layered Product
    
    DEC VAXVMS TCPIP V5.1-15: Compaq TCP/IP Services for OpenVMS.

Excellent. We now have TCP/IP Services installed as well as a PAK loaded so we can actually use it (remember how I mentioned limitations if you didn't have licenses earlier?).  
  
As recommended by the installation, we will run 
	

    SYS$MANGER:TCPIP$CONFIG.COM

 
 to configure TCP/IP on our system.

    $ @sys$manager:tcpip$config
    
    TCP/IP Network Configuration Procedure
    
    This procedure helps you define the parameters required
    to run Compaq TCP/IP Services for OpenVMS on this system. 
    
    *CLS*
    
    Compaq TCP/IP Services for OpenVMS Configuration Menu
    
    	Configuration options:
    
    		 1  -  Core environment
    		 2  -  Client components   
    		 3  -  Server components   
    		 4  -  Optional components
    
    		 5  -  Shutdown Compaq TCP/IP Services for OpenVMS
    		 6  -  Startup Compaq TCP/IP Services for OpenVMS
    		 7  -  Run tests
    
    		 A  -  Configure options 1 - 4
    		[E] -  Exit configuration procedure
    
    Enter configuration option: 

We start by configuring the core environment. I won't paste all menus here, just the prompts to save space.

    Enter configuration option: 1
    
    	DOMAIN Configuration
    
    	Enter Internet domain: cgx.org.uk
    
    Enter configuration option: 2
    
    	QE0 is the Ethernet device XQA0:
    
    	QE0 has not been configured
    
    	Compaq TCP/IP Services for OpenVMS Interface QE0 Configuration Menu
    
    	Configuration options:
    
    		 1  -  Configure interface manually       
    		 2  -  Let DHCP configure interface       
    
    		[E] -  Exit menu (Do not configure interface QE0)
    
    Enter configuration option: 1
    Enter fully qualified host name: cgxvax.cgx.org.uk
    Enter Internet address for cgxvax: 10.0.0.200
    Enter Internet network mask for cgxvax [255.0.0.0]: [enter]
    Enter broadcast mask for cgxvax [10.255.255.255]: [enter]
    * Is the above correct [YES]: YES

We have now set the domain for our system, as well as manually configured the ethernet interface manually. You can configure this as you please of course.  
  
Next we'll configure basic routing. At the moment, we wouldn't really want to use our system as a router, though the Compaq TCP/IP services does support a variety of protocols.

    * Do you want to configure dynamic ROUTED or GATED routing [NO]: NO
    
    	A default route has not been configured.
    * Do you want to configure a default route [YES]: YES
    Enter your Default Gateway host name or address: 10.0.0.1
    
    	10.0.0.1 is not in the local host database.
    	If you want to enter the default gateway in the local host
    	database, enter its host name. Otherwise, enter .
    
    Enter the Default Gateway host name []: [ENTER]
    
    Next, to resolve hostnames we will need to specify a nameserver.
    
    Enter configuration option: 4
    Enter your BIND server name: 10.0.0.1
    Enter remote BIND server name []: [enter]
    Enter next BIND server name: [enter]
    
    Enter configuration option: E
    
    Now that the core configuration is complete, we can enable telnet:
    
    Enter configuration option: 2
    Enter configuration option: 6
    TELNET Configuration
    
    Service is not defined in the TCPIP$SERVICE database.
    Service is not enabled.
    Service is stopped.
    
    	TELNET configuration options:
    
    		 1 - Enable service on this node
    
    		[E] - Exit TELNET configuration
    
    Enter configuration option: 1
    Creating TELNET Service entry

You should enable FTP from the client menu also, then exit to the main menu. Once at the main menu, chose option #6 to startup TCP/IP services.

    6 - Startup Compaq TCP/IP Services for OpenVMS
    
    Begin Startup...
    
    %TCPIP-I-INFO, TCP/IP Services startup beginning at 10-JAN-2009 01:30:04.47
    %TCPIP-I-INFO, creating UCX compatibility file SYS$COMMON:[SYSEXE]UCX$SERVICE.DAT
    %TCPIP-I-NORMAL, timezone information verified

More messages will follow, you will then be prompted to "Press Resturn to continue". Finally exit, and press 'Y' when prompted to start your services (if not already started). You should now be able to connect to your system using telnet and FTP (though, not from the host system! This is a flaw in winpcap/libpcap not in OpenVMS or SIMH).  
  
Finally, add 

> `$ @sys$startup:tcpip$startup`

 to the '**sys$manager:systartup_vms.com**' file to enable TCP/IP services to run at boot-time.  
  
Stay tuned for part 2, where we will learn more about OpenVMS, DCL and installing more software including 3rd-party products from [Process Software](http://www.process.com/) as well as useful tools you're familiar with such as [wget](http://www.gnu.org/software/wget/).  
  
**References and Links**

-   [http://en.wikipedia.org](http://en.wikipedia.org/)
-   [http://simh.trailing-edge.com](http://simh.trailing-edge.com/)
-   [http://www.openvmshobbyist.com](http://www.openvmshobbyist.com/)
-   [http://connect-community.de](http://connect-community.de/)
-   [http://www.wherry.com](http://www.wherry.com/)
-   [http://64.223.189.234](https://web.archive.org/web/20090312034321/http://64.223.189.234/)  (HoffmanLabs)

