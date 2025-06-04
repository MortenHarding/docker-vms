# VMS Docker containers

- [This Repo](#this-repo)
  - [The benefit of this Repo](#the-benefit-of-this-repo)
  - [Prerequisites](#Prerequisites)
- [Install guide](#Install-guide)
  - [Install prerequisites](#install-prerequisites)
  - [Start docker container](#start-docker-container)
  - [Install OpenVMS 7.3](#install-openvms-73)
    - [Connect to OpenVMS 7.3 console](#connect-to-openvms-73-console)
    - [Restore OpenVMS 7.3 to system disk](#restore-openvms-73-to-system-disk)
    - [Boot from system disk](#boot-from-system-disk)
    - [OpenVMS 7.3 install procedure](#openvms-73-install-procedure)
    - [Change boot device](#change-boot-device)
    - [Shutdown openVMS](#shutdown-openvms)
    - [Shutdown docker container](#shutdown-docker-container)
- [Using the installed docker container](#using-the-installed-docker-container)
  - [Start docker container](#start-docker-container)
  - [Connect to the OpenVMS 7.3 console](#connect-to-the-openvms-73-console)


# This Repo

The containers that can be provisioned using the code in this repo contain 2 emulators, SimH and axpbox, that can be used to startup OpenVMS on either VAX or Alpha architecture.
The docker containers are setup to download the ISO files for both OpenVMS 7.3 and OpenVMS 8.4, giving you an easy start for building you own OpenVMS installation.
All that is required is Docker.

## The benefit of this Repo 

Using Docker compose and the [compose.yml](https://github.com/MortenHarding/docker-vms/blob/main/compose.yml) file from this repo, 
you can:
 * Start 2 emulators, SimH for vax/vms and axpbox for vms on the Alpha architecture using one command.
 * The emulators will boot from the mounted install ISO for OpenVMS 7.3 and OpenVMS 8.4.
 * You can now access the OpenVMS install command using telnet 


## Prerequisites

* [Docker](https://www.docker.com/get-started)
* [compose.yml](https://github.com/MortenHarding/docker-vms/blob/main/compose.yml). This is the only file required from github repo [docker-vms](https://github.com/MortenHarding/docker-vms)

# Install guide

## Install prerequisites

* Install [Docker](https://www.docker.com/get-started). 
* Download [compose.yml](https://github.com/MortenHarding/docker-vms/blob/main/compose.yml) into an empty directory.

## Start docker container
This will start VMS vax and alpha emulator

Run the following command from the directory containing [compose.yml](https://github.com/MortenHarding/docker-vms/blob/main/compose.yml).

```sh

docker compose up -d

```

This will 
 - pull the container images from [hub.docker.com](https://hub.docker.com/r/mhardingdk/vms) 
 - pull the ISO file for OpenVMS 7.3 and OpenVMS 8.4
 - start a container for each of the 2 emulators, SimH and axpbox.
 - boot from the ISO files

You can now logon to the session and install OpenVMS 7.3 and OpenVMS 8.4

## Install OpenVMS 7.3

### Connect to OpenVMS 7.3 console

```sh
docker attach vms73
```

In the OpenVMS 7.3 console session you should see the following

```sh
VAX 8600 simulator V4.0-0 Current        git commit id: f3c61c31
./vax8600.ini-13> attach RQ0 /opt/simulators/data/rq0-ra92.dsk
%SIM-INFO: RQ0: Creating new file: /opt/simulators/data/rq0-ra92.dsk
./vax8600.ini-18> attach RQ3 -r /opt/simulators/iso/OpenVMS_VAX_7.3.iso
%SIM-INFO: RQ3: Unit is read only
%SIM-INFO: RQ3: '../iso/OpenVMS_VAX_7.3.iso' Contains ODS2 File system
%SIM-INFO: RQ3: Volume Name: VAXVMS073    Format: DECFILE11B   Sectors In Volume: 1269504
./vax8600.ini-28> set ts ensable
%SIM-ERROR: TS device: Non-existent parameter - ENSABLE
./vax8600.ini-33> attach -a dz 2303
%SIM-INFO: Listening on port 2303
./vax8600.ini-42> attach xu eth0
%SIM-INFO: Eth: opened OS device eth0
./vax8600.ini-45> boot rq3
%SIM-INFO: Loading boot code from internal vmb.exe

%SYSBOOT-I-SYSBOOT Mapping the SYSDUMP.DMP on the System Disk
%SYSBOOT-W-SYSBOOT Can not map SYSDUMP.DMP on the System Disk
%SYSBOOT-W-SYSBOOT Can not map PAGEFILE.SYS on the System Disk

OpenVMS (TM) VAX Version X7G7 Major version id = 1 Minor version id = 0

%WBM-I-WBMINFO Write Bitmap has successfully completed initialization.
PLEASE ENTER DATE AND TIME (DD-MMM-YYYY  HH:MM)
```

When you have connected to the OpenVMS 7.3 console, you will see the above output.
Enter the date & time when prompted.

```sh
PLEASE ENTER DATE AND TIME (DD-MMM-YYYY  HH:MM)  04-JUN-2025 14:36
```

```sh
configuring devices . . .
Now configuring HSC, RF, and MSCP-served devices . . .

Please check the names of the devices which have been configured,
to make sure that ALL remote devices which you intend to use have
been configured.

If any device does not show up, please take action now to make it
available.


Available device  DUA0:                            device type RA92
Available device  DUA1:                            device type RD54
Available device  DUA2:                            device type RD54
Available device  DUA3:                            device type RRD40
Available device  MSA0:                            device type MW_TSU05
Available device  MUA0:                            device type TU81
Available device  MUA1:                            device type TU81
Available device  MUA2:                            device type TU81
Available device  MUA3:                            device type TU81
Available device  MTA0:                            device type TE16
Available device  MTA1:                            device type TE16
Available device  MTA2:                            device type TE16
Available device  MTA3:                            device type TE16
Available device  MTA4:                            device type TE16
Available device  MTA5:                            device type TE16
Available device  MTA6:                            device type TE16
Available device  MTA7:                            device type TE16
```

When all devices are available enter "yes"

```sh

Enter "YES" when all needed devices are available: yes

%BACKUP-I-IDENT, Stand-alone BACKUP T7.2; the date is  4-JUN-2025 14:37:56.01

```

### Restore OpenVMS 7.3 to system disk

Restore OpenVMS 7.3 from the install media to the system disk

```sh

$ backup dua3:vms071.b/save_set dua0:

```

When the backup process has finished and you are asked to enter "yes", halt the system by pressing 'CTRL + E'

```sh
%BACKUP-I-PROCDONE, operation completed.  Processing finished at  4-JUN-2025 14:38:09.35
If you do not want to perform another standalone BACKUP operation,
use the console to halt the system.

If you do want to perform another standalone BACKUP operation, 
ensure the standalone application volume is online and ready.
Enter "YES" to continue: ^E
```

You are now back at the simh emulator prompt

```sh
Simulation stopped, PC: 819C238D (BBC #3,26C(R3),819C23E1)
sim>
```

### Boot from system disk

Boot from the restored system disk

```sh
sim> boot rq0
```

### OpenVMS 7.3 install procedure

Booting from the restored system disk, will start the OpenVMS 7.3 installation procedure

```sh
%SIM-INFO: Loading boot code from internal vmb.exe

%SYSBOOT-I-SYSBOOT Mapping the SYSDUMP.DMP on the System Disk
%SYSBOOT-W-SYSBOOT Can not map SYSDUMP.DMP on the System Disk
%SYSBOOT-I-SYSBOOT Mapping PAGEFILE.SYS on the System Disk
%SYSBOOT-I-SYSBOOT SAVEDUMP parameter not set to protect the PAGEFILE.SYS

   OpenVMS (TM) VAX Version BI73-7G7 Major version id = 1 Minor version id = 0

%WBM-I-WBMINFO Write Bitmap has successfully completed initialization.

           OpenVMS VAX V7.3 Installation Procedure

                         Model: VAX 8650
                 System device: RA92 - _DUA0:
                   Free Blocks: 2854566
                      CPU type: 04-00
```

When prompted, enter the date & time

```sh

* Please enter the date and time (DD-MMM-YYYY HH:MM) 04-jun-2025 14:39

*********************************************************
%SYSTEM-W-TZGMT, your local timezone has defaulted to GMT
%SYSTEM-I-SETTZ, to set your local timezone use:

     $ @SYS$MANAGER:UTC$TIME_SETUP.COM

*********************************************************
On MIN or UPGRADE system startup - CLUE is not run.
%%%%%%%%%%%  OPCOM   4-JUN-2025 14:39:01.15  %%%%%%%%%%%
Operator _OPA0: has been enabled, username SYSTEM

%%%%%%%%%%%  OPCOM   4-JUN-2025 14:39:01.15  %%%%%%%%%%%
Operator status for operator _OPA0:
CENTRAL, PRINTER, TAPES, DISKS, DEVICES, CARDS, NETWORK, CLUSTER, SECURITY,
LICENSE, OPER1, OPER2, OPER3, OPER4, OPER5, OPER6, OPER7, OPER8, OPER9, OPER10,
OPER11, OPER12

%%%%%%%%%%%  OPCOM   4-JUN-2025 14:39:01.18  %%%%%%%%%%%
Logfile has been initialized by operator _OPA0:
Logfile is SYS$SYSROOT:[SYSMGR]OPERATOR.LOG;1

%%%%%%%%%%%  OPCOM   4-JUN-2025 14:39:01.19  %%%%%%%%%%%
Operator status for operator SYS$SYSROOT:[SYSMGR]OPERATOR.LOG;1
CENTRAL, PRINTER, TAPES, DISKS, DEVICES, CARDS, NETWORK, CLUSTER, SECURITY,
LICENSE, OPER1, OPER2, OPER3, OPER4, OPER5, OPER6, OPER7, OPER8, OPER9, OPER10,
OPER11, OPER12

%SYSTEM-I-BOOTUPGRADE, security auditing disabled
%LICENSE-F-EMTLDB, license database contains no license records
%SYSTEM-I-BOOTUPGRADE, security server not started
%%%%%%%%%%%  OPCOM   4-JUN-2025 14:39:01.81  %%%%%%%%%%%
Message from user SYSTEM
%LICENSE-E-NOAUTH, DEC VAX-VMS use is not authorized on this node

-LICENSE-F-NOLICENSE, no license is active for this software product

-LICENSE-I-SYSMGR, please see your system manager


%LICENSE-E-NOAUTH, DEC VAX-VMS use is not authorized on this node
-LICENSE-F-NOLICENSE, no license is active for this software product
-LICENSE-I-SYSMGR, please see your system manager
Startup processing continuing...

%SET-I-INTSET, login interactive limit = 1, current interactive value = 0
%SET-I-INTSET, login interactive limit = 0, current interactive value = 0
%JBC-E-OPENERR, error opening SYS$COMMON:[SYSEXE]QMAN$MASTER.DAT;
-RMS-E-FNF, file not found

    If this system disk is to be used in an OpenVMS Cluster with multiple
    system disks, then each system disk must have a unique volume label.
    Any nodes having system disks with duplicate volume labels will fail
    to boot into the cluster.

    You can indicate a volume label of 1 to 12 characters in length.  If you
    want to use the default name of OVMSVAXSYS, press RETURN in response
    to the next question.
```

- Accept the default volume label OVMSVAXSYS
- Enter "dua3" as the drive holding the distribution media
- Enter "yes" the media is ready

```sh

* Enter the volume label for this system disk [OVMSVAXSYS]: 

* Enter name of drive holding the OpenVMS distribution media: dua3
* Is the OpenVMS media ready to be mounted? [N] y

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

```

The above list shows the possible software you can select to install.
In this guide, it is only the following 3 options that are installed.

- OpenVMS library
- OpenVMS optional
- OpenVMS Help Messages

```sh   

* Do you want to install the OpenVMS library files? (Y/N) y

    Space remaining on system disk:  2802177 blocks

* Do you want to install the OpenVMS optional files? (Y/N) y

    Space remaining on system disk:  2783177 blocks


    The Help Message utility (MSGHLP) provides online explanations
    and user actions for OpenVMS messages in place of the hardcopy
    OpenVMS System Messages and Recovery Procedures Reference Manual,
    which is now separately orderable.

    The MSGHLP database file, MSGHLP$LIBRARY.MSGHLP$DATA,
    consumes approximately 10400 blocks and will be
    placed by default on your system disk in SYS$COMMON:[SYSHLP]
    unless you specify an alternate device when prompted.

* Do you want to install the MSGHLP database? (Y/N) y

    You can install this database on your system disk in SYS$COMMON:[SYSHLP]
    or on an alternate device.  If you specify an alternate device, but no
    directory, MSGHLP$LIBRARY.MSGHLP$DATA is placed in [HELP_MESSAGE].  When
    prompted, take the default of the system disk or specify an alternate
    device using this format:

                           device:[directory]

* Where do you want to install the MSGHLP database?
    [SYS$COMMON:[SYSHLP]] 

    Space remaining on system disk:  2772777 blocks


    The OpenVMS Management Station is a client-server application that
    provides OpenVMS system management capabilities through a client
    application on a personal computer (PC) running Microsoft Windows.

    The server application runs on OpenVMS systems and is automatically
    installed as part of the OpenVMS operating system.

    This option provides the files used to install the PC client software.
    If you want to use the OpenVMS Management Station, you must install
    these optional files on at least one OpenVMS system and then use one or
    both of them to install the PC client on one or more PCs.  There are two
    files:  TNT030_I.EXE for Intel systems (Windows 95 and Windows NT), and
    TNT030_A.EXE for Alpha Windows NT systems.

    The OpenVMS Management Station optional files consume approximately 20000
    blocks and will be placed on your system disk in SYS$COMMON:[TNT.CLIENT].

* Do you want to install the optional OpenVMS Management Station files? (Y/N) n

    You can select DECwindows now, or you can use the DECW$TAILOR utility
    to provide or remove DECwindows support after the installation.

    Some media, TK50s in particular, can be very slow when tailoring on files.
    You might want to select DECwindows now and tailor off unwanted files later.

    NOTE: This kit does NOT contain full DECwindows.
          To obtain full DECwindows, you must also install the separate
          layered product, DECwindows Motif for OpenVMS VAX.
          V1.2-3 is the minimum version of DECwindows Motif for OpenVMS VAX
          that can be used with OpenVMS VAX V7.3.

    The DECwindows components provided in this kit requires approximately
    34400 blocks, broken down as follows:

        o DECwindows base support                    -   4400 blocks
        o DECwindows workstation support             -  23800 blocks
          -  75 dots per inch video fonts            -    (included)
          - 100 dots per inch video fonts (optional) -   6200 blocks

    You must select the DECwindows base support option if
        - you plan to run DECwindows software, or
        - you are installing this kit on
            * a workstation or
            * an OpenVMS Cluster that contains workstations, or
        - you want to provide font files for Xterminals.

    If you are installing this kit on a system that includes Xterminals
    and you do NOT select DECwindows base support, then you will have to use
    the DECW$TAILOR utility to provide font files.

* Do you want the DECwindows base support? (Y/N) n

    Beginning with OpenVMS V7.1, the DECnet-Plus kit is provided with
    the OpenVMS operating system kit.  Compaq strongly recommends that
    DECnet users install DECnet-Plus.  DECnet Phase IV applications are
    supported by DECnet-Plus.

    DECnet Phase IV is also provided as an option.  Support for DECnet
    Phase IV is available through a Prior Version Support Contract.

    If you install DECnet-Plus and TCP/IP you can run DECnet
    applications over a TCP/IP network.  Please see the OpenVMS
    Management Guide for information on running DECnet over TCI/IP.

    If you plan to install DECnet Phase IV do NOT select DECnet-Plus.

* Do you want to install DECnet-Plus? (Y/N) n

* Do you want to install DECnet Phase IV? (Y/N) n

    The following options will be provided:

        OpenVMS library
        OpenVMS optional
        OpenVMS Help Message

    Space remaining on system disk:  2772777 blocks

* Is this correct? (Y/N) y
```

Accept the choices made by entering "y", and the install will begin

```sh

    Restoring OpenVMS library save set ...
%BACKUP-I-STARTVERIFY, starting verification pass

    Restoring OpenVMS optional save set ...
%BACKUP-I-STARTVERIFY, starting verification pass

    Restoring OpenVMS Help Message save set ...
%BACKUP-I-STARTVERIFY, starting verification pass

    Now registering the OpenVMS operating system in the
    POLYCENTER Software Installation product database


The following product will be registered:
    DEC VAXVMS VMS V7.3                    DISK$VAXVMSV73:[VMS$COMMON.]

The following product has been registered:
    DEC VAXVMS VMS V7.3                    Transition (registration)

    You can now remove the distribution kit from DUA3:.



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


    Now we will ask you for new passwords for the following accounts:

        SYSTEM, SYSTEST, FIELD

    Passwords must be a minimum of 8 characters in length.  All passwords
    will be checked and verified.  Any passwords that can be guessed easily
    will not be accepted.

```

You will be asked to enter passwords for the above listed accounts

```sh


* Enter password for SYSTEM: 

* Re-enter for verification: 
%UAF-I-MDFYMSG, user record(s) updated
%VMS-I-PWD_OKAY, account password for SYSTEM verified


* Enter password for SYSTEST: 

* Re-enter for verification: 
%UAF-I-MDFYMSG, user record(s) updated
%VMS-I-PWD_OKAY, account password for SYSTEST verified


    The SYSTEST_CLIG account will be disabled.  You must re-enable
    it before running UETP but do not assign a password.

%UAF-I-PWDLESSMIN, new password is shorter than minimum password length
%UAF-I-MDFYMSG, user record(s) updated


* Enter password for FIELD: 

* Re-enter for verification: 
%UAF-I-MDFYMSG, user record(s) updated
%VMS-I-PWD_OKAY, account password for FIELD verified


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

```

Choose your own NODE name and SYSTEMID (must be above 1024)

```sh

* Please enter the SCSNODE name: vms73

* Please enter the SCSSYSTEMID:  1027

    After the installation finishes, you might want to do one or more of the
    following tasks:

    o DECOMPRESS THE SYSTEM LIBRARIES - To save space, many of the system
      libraries are shipped in a data-compressed format.  If you have
      enough disk space, you can decompress the libraries for faster access.
      To data expand the libraries, type:

        $ @SYS$UPDATE:LIBDECOMP.COM

      If you do not decompress these libraries, you will experience
      slower response to the HELP and LINK commands.

    o BUILD A STANDALONE BACKUP KIT - You can build a standalone backup kit
      using the procedure described in the "Backup Procedures" chapter of
      tye upgrade and installation supplement provided for your VAX computer.

    o TAILOR THE SYSTEM DISK - You might want to review the files provided or
      not provided during this installation.  If you find there are files
      you want to remove from the system disk (TAILOR OFF) or files you want
      to add (TAILOR ON), use the following utilities to perform the
      desired tailoring.

          OpenVMS tailoring:          $ RUN SYS$UPDATE:VMSTAILOR

          DECwindows tailoring:       $ RUN SYS$UPDATE:DECW$TAILOR

      NOTE:  The tailor procedure cannot be used to TAILOR ON or TAILOR OFF
             files located on an alternate disk.


=================================================================
    Continuing with OpenVMS VAX V7.3 Installation Procedure.



    Configuring all devices on the system ...

    If you have Product Authorization Keys (PAKs) to register, you can
    register them now.

```

If you have a license you can register it now.

```sh
* Do you want to register any Product Authorization Keys? (Y/N): n

********************************************************************************

    After the system has rebooted you must register any Product
    Authorization Keys (PAKs) that you have received with this kit.
    You can register these PAKs by executing the following procedure:

        $ @SYS$UPDATE:VMSLICENSE

    See the OpenVMS License Management Utility Manual for any additional
    information you need.

********************************************************************************


%UTC-I-UPDTIME, updating Time Zone information in SYS$COMMON:[SYSEXE]

```

Select your time zone

```sh
    Configuring the Local Time Zone


    TIME ZONE SPECIFICATION -- Main Time Zone Menu

      1) Australia       11) GMT             21) Mexico          31) Turkey
      2) Brazil          12) Greenwich       22) NZ              32) UCT
      3) CET             13) Hong Kong       23) NZ-CHAT         33) US
      4) Canada          14) Iceland         24) Navajo          34) UTC
      5) Chile           15) Iran            25) PRC             35) Universal
      6) Cuba            16) Israel          26) Poland          36) W-SU
      7) EET             17) Jamaica         27) ROC             37) WET
      8) Egypt           18) Japan           28) ROK             38) Zulu
      9) Factory         19) Libya           29) Singapore
     10) GB-Eire         20) MET             30) SystemV

      0) None of the above

Select the number above that best describes your location: 3

You selected CET as your time zone.
Is this correct? (Yes/No) [YES]: yes

    Default Time Differential Factor for standard time is 1:00.
    Default Time Differential Factor for daylight saving time is 2:00.


    The Time Differential Factor (TDF) is the difference between your
    system time and Coordinated Universal Time (UTC).  UTC is similar
    in most repects to Greenwich Mean Time (GMT).

    The TDF is expressed as hours and minutes, and should be entered
    in the hh:mm format.  TDFs for the Americas will be negative
    (-3:00, -4:00, etc.); TDFs for Europe, Africa, Asia and Australia
    will be positive (1:00, 2:00, etc.).

Is Daylight Savings time in effect? (Yes/No): yes

Enter the Time Differential Factor [2:00]: 

    NEW SYSTEM TIME DIFFERENTIAL FACTOR = 2:00.

Is this correct? [Y]: y


********************************************************************************

```

AUTOGEN will now execute, followed by a restart of OpenVMS

```sh

    Running AUTOGEN to compute the new SYSTEM parameters ...

%AUTOGEN-I-BEGIN, GETDATA phase is beginning.
%AUTOGEN-I-NEWFILE, A new version of SYS$SYSTEM:PARAMS.DAT has been created.
        You may wish to purge this file.
%AUTOGEN-I-END, GETDATA phase has successfully completed.
%AUTOGEN-I-BEGIN, GENPARAMS phase is beginning.
%AUTOGEN-I-NEWFILE, A new version of SYS$MANAGER:VMSIMAGES.DAT has been created.
        You may wish to purge this file.
%AUTOGEN-I-NEWFILE, A new version of SYS$SYSTEM:SETPARAMS.DAT has been created.
        You may wish to purge this file.
%AUTOGEN-I-END, GENPARAMS phase has successfully completed.
%AUTOGEN-I-BEGIN, GENFILES phase is beginning.
%SYSGEN-I-EXTENDED, SYS$SYSROOT:[SYSEXE]PAGEFILE.SYS;1 extended
%SYSGEN-I-EXTENDED, SYS$SYSROOT:[SYSEXE]SWAPFILE.SYS;1 extended
%SYSGEN-I-CREATED, SYS$SPECIFIC:[SYSEXE]SYSDUMP.DMP;1 created
%SYSGEN-I-CREATED, DUA0:[SYS0.SYSEXE]ERRORLOG.DMP;1 created

%AUTOGEN-I-REPORT, AUTOGEN has produced some informational messages which
        have been stored in the file SYS$SYSTEM:AGEN$PARAMS.REPORT.  You may
        wish to review the information in that file.

%AUTOGEN-I-END, GENFILES phase has successfully completed.
%AUTOGEN-I-BEGIN, SETPARAMS phase is beginning.
%AUTOGEN-I-END, SETPARAMS phase has successfully completed.
%AUTOGEN-I-BEGIN, REBOOT phase is beginning.

    The system is shutting down to allow the system to boot with the
    generated site-specific parameters and installed images.

    The system will automatically reboot after the shutdown and the
    installation will be complete.



        SHUTDOWN -- Perform an Orderly System Shutdown


%SHUTDOWN-I-BOOTCHECK, performing reboot consistency check...
%SHUTDOWN-I-CHECKOK, basic reboot consistency check completed

%SHUTDOWN-I-OPERATOR, this terminal is now an operator's console
%OPCOM-W-NOOPCOM, the request was not sent, the OPCOM process is not running
%SHUTDOWN-I-DISLOGINS, interactive logins will now be disabled
%SET-I-INTSET, login interactive limit = 0, current interactive value = 0
%SHUTDOWN-I-STOPQUEUES, the queues on this node will now be stopped
%JBC-E-OPENERR, error opening SYS$COMMON:[SYSEXE]QMAN$MASTER.DAT;
-RMS-E-FNF, file not found

SHUTDOWN message from user SYSTEM at  Batch   14:41:30
The system will shut down in 0 minutes; back up SOON.  Please log off.
Reboot system with AUTOGENerated parameters


%SHUTDOWN-I-STOPUSER, all user processes will now be stopped
%SHUTDOWN-I-REMOVE, all installed images will now be removed
%SHUTDOWN-I-DISMOUNT, all volumes will now be dismounted
%OPCOM-W-NOOPCOM, the request was not sent, the OPCOM process is not running
%OPCOM-W-NOOPCOM, the request was not sent, the OPCOM process is not running
%SIM-INFO: Loading boot code from internal vmb.exe
Rebooting...

%SYSBOOT-I-SYSBOOT Mapping the SYSDUMP.DMP on the System Disk
%SYSBOOT-I-SYSBOOT SYSDUMP.DMP on System Disk successfully mapped 
%SYSBOOT-I-SYSBOOT Mapping PAGEFILE.SYS on the System Disk
%SYSBOOT-I-SYSBOOT SAVEDUMP parameter not set to protect the PAGEFILE.SYS

   OpenVMS (TM) VAX Version V7.3     Major version id = 1 Minor version id = 0

%WBM-I-WBMINFO Write Bitmap has successfully completed initialization.

    *****************************************************************

    OpenVMS VAX V7.3

    You have SUCCESSFULLY installed the OpenVMS VAX Operating System.

    The system is now executing the STARTUP procedure.  Please
    wait for the completion of STARTUP before logging in to the
    system.

    *****************************************************************

%STDRV-I-STARTUP, OpenVMS startup begun at  4-JUN-2025 12:42:22.25
%RUN-S-PROC_ID, identification of created process is 00000206
%DCL-S-SPAWNED, process SYSTEM_1 spawned
%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:26.99  %%%%%%%%%%%
Operator _VMS73$OPA0: has been enabled, username SYSTEM

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.00  %%%%%%%%%%%
Operator status for operator _VMS73$OPA0:
CENTRAL, PRINTER, TAPES, DISKS, DEVICES, CARDS, NETWORK, CLUSTER, SECURITY,
LICENSE, OPER1, OPER2, OPER3, OPER4, OPER5, OPER6, OPER7, OPER8, OPER9, OPER10,
OPER11, OPER12

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.00  %%%%%%%%%%%
Logfile has been initialized by operator _VMS73$OPA0:
Logfile is VMS73::SYS$SYSROOT:[SYSMGR]OPERATOR.LOG;1

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.00  %%%%%%%%%%%
Operator status for operator VMS73::SYS$SYSROOT:[SYSMGR]OPERATOR.LOG;1
CENTRAL, PRINTER, TAPES, DISKS, DEVICES, CARDS, NETWORK, CLUSTER, SECURITY,
LICENSE, OPER1, OPER2, OPER3, OPER4, OPER5, OPER6, OPER7, OPER8, OPER9, OPER10,
OPER11, OPER12

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.09  %%%%%%%%%%%
Message from user AUDIT$SERVER on VMS73
%AUDSRV-I-NEWSERVERDB, new audit server database created

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.11  %%%%%%%%%%%
Message from user AUDIT$SERVER on VMS73
%AUDSRV-I-REMENABLED, resource monitoring enabled for journal SECURITY

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.13  %%%%%%%%%%%
Message from user AUDIT$SERVER on VMS73
%AUDSRV-I-NEWOBJECTDB, new object database created

%SET-I-NEWAUDSRV, identification of new audit server process is 0000020C
%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.24  %%%%%%%%%%%
Message from user JOB_CONTROL on VMS73
%JBC-E-OPENERR, error opening SYS$COMMON:[SYSEXE]QMAN$MASTER.DAT;

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.24  %%%%%%%%%%%
Message from user JOB_CONTROL on VMS73
-RMS-E-FNF, file not found

%LICENSE-F-EMTLDB, license database contains no license records
%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.49  %%%%%%%%%%%
Message from user SYSTEM on VMS73
%SECSRV-E-NOPROXYDB, cannot find proxy database file NET$PROXY.DAT
%RMS-E-FNF, file not found

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.49  %%%%%%%%%%%
Message from user SYSTEM on VMS73
%SECSRV-E-NOPROXYDB, cannot find proxy database file NET$PROXY.DAT
%RMS-E-FNF, file not found

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.50  %%%%%%%%%%%
Message from user SYSTEM on VMS73
%SECSRV-I-CIACRECLUDB, security server created cluster intrusion database

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.50  %%%%%%%%%%%
Message from user SYSTEM on VMS73
%SECSRV-I-SERVERSTARTINGU, security server starting up

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.53  %%%%%%%%%%%
Message from user SYSTEM on VMS73
%SECSRV-I-CIASTARTINGUP, breakin detection and evasion processing now starting up

%SMG-W-GBLNOTCRE, global section not created
-SYSTEM-F-GPTFULL, global page table is full
%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.78  %%%%%%%%%%%
Message from user SYSTEM on VMS73
%LICENSE-E-NOAUTH, DEC VAX-VMS use is not authorized on this node

-LICENSE-F-NOLICENSE, no license is active for this software product

-LICENSE-I-SYSMGR, please see your system manager


%LICENSE-E-NOAUTH, DEC VAX-VMS use is not authorized on this node
-LICENSE-F-NOLICENSE, no license is active for this software product
-LICENSE-I-SYSMGR, please see your system manager
Startup processing continuing...

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:27.90  %%%%%%%%%%%
Message from user SYSTEM on VMS73
Warning: DECdtm log file not found (SYS$JOURNAL:SYSTEM$VMS73.LM$JOURNAL)
        %RMS-E-FNF, file not found
        TP server process waiting


%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:28.08  %%%%%%%%%%%
Message from user AUDIT$SERVER on VMS73
Security alarm (SECURITY) and security audit (SECURITY) on VMS73, system id: 1027
Auditable event:          Audit server starting up
Event time:                4-JUN-2025 12:42:28.06
PID:                      00000203        
Username:                 SYSTEM          

%STARTUP-I-AUDITCONTINUE, audit server initialization complete

The OpenVMS VAX system is now executing the site-specific startup commands.

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:28.20  %%%%%%%%%%%
Message from user AUDIT$SERVER on VMS73
Security alarm (SECURITY) and security audit (SECURITY) on VMS73, system id: 1027
Auditable event:          Identifier added
Event time:                4-JUN-2025 12:42:28.19
PID:                      00000203        
Process name:             STARTUP         
Username:                 SYSTEM          
Process owner:            [SYSTEM]
Image name:               VMS73$DUA0:[SYS0.SYSCOMMON.][SYSEXE]AUTHORIZE.EXE
Identifier name:          SYS$NODE_VMS73                  
Identifier value:         %X80010000      
Attributes:               none

%UAF-I-RDBADDMSG, identifier SYS$NODE_VMS73 value %X80010000 added to rights database
%SET-I-INTSET, login interactive limit = 64, current interactive value = 0
  SYSTEM       job terminated at  4-JUN-2025 12:42:28.39

  Accounting information:
  Buffered I/O count:            1532         Peak working set size:    1697
  Direct I/O count:               566         Peak page file size:      5144
  Page faults:                   5063         Mounted volumes:             0
  Charged CPU time:           0 00:00:04.24   Elapsed time:     0 00:00:06.91

 Welcome to OpenVMS (TM) VAX Operating System, Version V7.3    

```

The installation is now complete and you can login with the system acount and password entered previosly

```sh

Username: system

Password: 
%LICENSE-I-NOLICENSE, no license is active for this software product
%LOGIN-S-LOGOPRCON, login allowed from OPA0:
 Welcome to OpenVMS (TM) VAX Operating System, Version V7.3

```
### Change boot device

Change the boot device in the file ```./vms73/data/vax8600.ini``` from rq3 to rq0, to boot from the system disk and not the install media.

### Shutdown openVMS

Shutdown OpenVMS 7.3

```sh

$ shutdown


	SHUTDOWN -- Perform an Orderly System Shutdown
	            on node VMS73


%SHUTDOWN-I-OPERATOR, this terminal is now an operator's console
%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:39.26  %%%%%%%%%%%
Operator status for operator _VMS73$OPA0:
CENTRAL, PRINTER, TAPES, DISKS, DEVICES, CARDS, NETWORK, CLUSTER, SECURITY,
LICENSE, OPER1, OPER2, OPER3, OPER4, OPER5, OPER6, OPER7, OPER8, OPER9, OPER10,
OPER11, OPER12

%SHUTDOWN-I-DISLOGINS, interactive logins will now be disabled
%SET-I-INTSET, login interactive limit = 0, current interactive value = 1
%SHUTDOWN-I-STOPQUEUES, the queues on this node will now be stopped
%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:39.36  %%%%%%%%%%%
Message from user JOB_CONTROL on VMS73
%JBC-E-OPENERR, error opening SYS$COMMON:[SYSEXE]QMAN$MASTER.DAT;

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:39.36  %%%%%%%%%%%
Message from user JOB_CONTROL on VMS73
-RMS-E-FNF, file not found


SHUTDOWN message on VMS73 from user SYSTEM at _VMS73$OPA0:   12:42:39
VMS73 will shut down in 0 minutes; back up LATER.  Please log off node VMS73.
SHUTDOWN

1 terminal has been notified on VMS73.

%SHUTDOWN-I-STOPUSER, all user processes will now be stopped
%SHUTDOWN-I-STOPAUDIT, the security auditing subsystem will now be shut down
%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:42.94  %%%%%%%%%%%
Message from user AUDIT$SERVER on VMS73
Security alarm (SECURITY) and security audit (SECURITY) on VMS73, system id: 1027
Auditable event:          Audit server shutting down
Event time:                4-JUN-2025 12:42:42.94
PID:                      00000210        
Username:                 SYSTEM          

%SHUTDOWN-I-STOPSECSRV, the security server will now be shut down
%SHUTDOWN-I-REMOVE, all installed images will now be removed
%SHUTDOWN-I-DISMOUNT, all volumes will now be dismounted
%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:43.38  %%%%%%%%%%%
Message from user SYSTEM on VMS73
_VMS73$OPA0:, VMS73 shutdown was requested by the operator.

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:43.39  %%%%%%%%%%%
Logfile was closed by operator _VMS73$OPA0:
Logfile was VMS73::SYS$SYSROOT:[SYSMGR]OPERATOR.LOG;1

%%%%%%%%%%%  OPCOM   4-JUN-2025 12:42:43.40  %%%%%%%%%%%
Operator _VMS73$OPA0: has been disabled, username SYSTEM



	SYSTEM SHUTDOWN COMPLETE - use console to halt system

Infinite loop, PC: 9E44E6D3 (BRB 9E44E6D3)
```

### Shutdown docker container

Did you change the the boot device in the file ```./vms73/data/vax8600.ini``` ?

If you did change the boot device to rq0, at next startup it will boot into OpenVMS 7.3 on the system disk

```sh

docker compose down

```

# Using the installed docker container

- [Start docker container](#start-docker-container)

## Connect to the OpenVMS 7.3 console

First attach to the docker container

```sh
docker attach vms73
```

You should now be asked to login to OpenVMS 7.3

```sh
  Accounting information:
  Buffered I/O count:            1532         Peak working set size:    1697
  Direct I/O count:               566         Peak page file size:      5144
  Page faults:                   5063         Mounted volumes:             0
  Charged CPU time:           0 00:00:04.24   Elapsed time:     0 00:00:06.91

 Welcome to OpenVMS (TM) VAX Operating System, Version V7.3    

Username: system

Password: 
%LICENSE-I-NOLICENSE, no license is active for this software product
%LOGIN-S-LOGOPRCON, login allowed from OPA0:
 Welcome to OpenVMS (TM) VAX Operating System, Version V7.3

```