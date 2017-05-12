Description for the database

Database should contain table "USER_PROGRAMS" here is the script for creation wich I used

CREATE TABLE USER_PROGRAMS (
  ID BIGINT NOT NULL,
  "NAME" VARCHAR(255) COLLATE UNICODE_CI_AI,
  PATH VARCHAR(255) COLLATE UNICODE_CI_AI,
  PARAMS VARCHAR(255) COLLATE UNICODE_CI_AI,
  CREATED_USER_ID BIGINT,
  UPDATED_USER_ID BIGINT,
  CREATED_AT TIMESTAMP,
  UPDATED_AT TIMESTAMP,
  ICON BLOB COLLATE ,
  DESCRIPTION VARCHAR(255) COLLATE UNICODE_CI_AI,
  MONITOR BIGINT,
  TILEWIDTH BIGINT,
  TILEHEIGHT BIGINT,
  STYLEID BIGINT,
  RUNCEONE CHAR(1) COLLATE UNICODE_CI_AI,
  NAME_SHORT VARCHAR(5) COLLATE UNICODE_CI_AI,
  LOGIN_TYPE SMALLINT);

ALTER TABLE USER_PROGRAMS ADD PRIMARY KEY (ID) USING INDEX RDB$PRIMARY244;

Description of fields:
 ID - unique field it has to be integer;
 NAME - string field it just label for Application;
 PATH - string field it should contain full path with program name and it extension
 PARAMS - sting list of parameters thru space for program if it is needed
 RUNCEONE - integer field it should contain 0 for false and 1 for true
 ICON - BLOB field it can contain image file
 NAME_SHORT - string field it should contain two letters as it was in example
 LOGIN_TYPE - it is bitmap field wich contain login type( now it contain EasyLogin 01 value and KeyLogin 10 value)
 TILEWIDTH - useless field and can be deleted from the table or reuse for some other porpuse
 TILEHEIGHT -  useless field and can be deleted from the table or reuse for some other porpuse


Example of record :
 1
 GMS_Maintenance
 c:\Projects\GMS_Maintenance\Win32\Debug\GMS_Maintenance.exe
 Null
 0
 BLOB
 GM
 2                                                             -- it means that the KeyLogin = Yes and EasyLogin = No
 Null
 Null 

In the table "User_Users" you can find the user names list and the role of the user
"USER_ROLES" - there is the role list
"USER_ROLE_PROGRAMS" - there is relations between role and program (please do not try to setup it manualy, it is better to use the configuration)


Also in felixmain.ini you may set in [Common] section (You can make some changes using the configuration window in Option tab)
TileSideSize=200 - default is 300 it is size of Tile for programs
LogoImgPath=img\gms-info2.png default is img\gms-info.png it is the full path to logo picture
ClientImgPath=img\dilly-logo-1455485.png default is img\dilly-logo-1455485.png it is the full path to client logo picture
SoundPath=snd\newmessage1.wav default is snd\newmessage.wav it is file witch is plaing when new messages are avaible

Example of my felixmain.ini

[DataBase]
Server=localhost:C:\DATABASE\FELIX_GLOECKNERIN.FDB
LocalDir=c:\fx-2000\daten\local

[Common]
// 0 = nur Fehler, 1 = inkl. ALLEN SQL Statemnts (achtung, logfiles werden sehr groﬂ)
DebugModus=0
Hotelserver=http://cloud2.gms.info:3000
TileSideSize=300
LogoImgPath=img\gms-info.png
ClientImgPath=img\dilly-logo-1455485.png
SoundPath=snd\newmessage.wav

