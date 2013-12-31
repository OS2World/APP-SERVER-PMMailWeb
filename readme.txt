***************************************************************************************
*                          PMMailWEB   (c) Peter LÅersen                              *
***************************************************************************************

PMMailWEB ist ein Webfrontend fÅr PMMail. 
Mit PMMailWEB kînnen Sie alle Emails des PMMail Mailclient Åber das Internet mit einem
Webbrowser lesen.

PMMailWEB ist freie Software!
        Aus diesem Grunde wird fÅr PMMailWEB keine Haftung jedweder Art Åbernommen.
        Fehlerberichte und VorschlÑge richten Sie bitte an Peter.Lueersen@web.de

Softwarevoraussetzungen:
        PMMail V3.09.x oder  V3.10.x
        eComstation ab V1.25 oder OS/2 V4             
        Apache V1.3.X oder WEB/2 V1.3x

Installation:
        - PMMAILWEBXXXX.ZIP in einem temporÑren Verzeichnis entpacken.
        - Die Dateien PMMAILWEB.EXE, PMMAILCONFIG.EXE, PMMAILWEB.CFG   
          in das cgi-bin Verzeichnis ihres Webservers kopieren.
        - PMMAILWEB.CFG im cgi-bin Verzeichnis editieren.

Programmstart:
        - PMMailWEB mit http://<server>:<port>/cgi-bin/PMMAILWEB.EXE starten.

Besonderheiten:
        - z.Z. Bestehen noch Probleme bei der Verwendung des Apache/2.XX (OS/2). 
          Aus diesem Grund liegt dem Programmpaket der Apache in der Version 1.3.41 (OS/2)
          bei. Er ist auf Port 88 vorkonfiguriert, so das er sich neben einem schon 
          bestehenden WEB-Server betreiben lÑsst. Ihr finden die benîtigten Dateien im 
          Verzeichnis APACHE. Gestartet wir der WEB-Server Åber startup_Apache.cmd,
          ggf. sind hier noch die Verzeichnisangaben anzupassen. Die EMX runtime 0.9d(04)
          wenn noch nicht vorhanden befindet sich im Verzeichnis EMXRT.

VersionsÅbersicht:

1.00A1: 
	Initial Release  

1.00A2: 
        +: @ for new Mails 
        +: Nur Mails von heute anzeigen.
        +: LOGOFF MenÅeintrag
        +: LOGIN ID
        +: Loding ... ... Please wait
        #: Die Hilfe wird nun in einem eigenen Fenster angezeigt.
        +: WEB/2 kann nun als Webserver verwendet werden.
        -: ExtraRexx.dll wird nicht mehr benîtigt.

1.00A2a:
	#: Fehler bei free_access_for_ip=XXX.YYY.ZZZ. und free_access_for_ip=. behoben

***************************************************************************************
*                          PMMailWEB   (c) Peter Lueersen                             *
***************************************************************************************

PMMailWEB is a frontend for PMMail.
With PMMailWEB you can read all PMMail emails over the Internet with a Web browsers.

PMMailWEB is free software!
        PMMailWEB comes with absolutely no Warranty.
        Contact Peter.Lueersen@web.de for bug reports and suggestions.

Software Requirements:
         PMMail V3.09.x or V3.10.x
         eComstation from V1.25 or OS/2 V4
         Apache v1.3.x or WEB/2 V1.3x

Installation:
        - Unpack PMMAILWEBXXXX.ZIP in a temporary Directory.
        - Copy the files PMMAILWEB.EXE, PMMAILCONFIG.EXE, PMMAILWEB.CFG 
          to the cgi-bin directory of your web server.
        - Edit PMMAILWEB.CFG in the cgi-bin Directory.

Run the Program:
	- To start PMMailWEB type http://<server>:<port>/cgi-bin/PMMAILWEB.EXE.

Extras:
        - There are still problems in the use of Apache/2.XX (OS / 2).
          For this reason, in the program package is Apache Version 1.3.41 (OS / 2).
          He is pre-configured on port 88, so he is already next to a operate existing 
          web server can. You find the required files in the APACHE directory. We started 
          the web server via startup_Apache.cmd. If necessary, here are the directory 
          information to adapt. The EMX runtime 0.9d (04) is, if not already on your
          Box, located in the directory EMXRT.

Version history:

1.00A1 :
        Initial Release

1.00A2 :
        +: @ For new mail
        +: Show only messages from today.
        +: LOGOFF menu
        +; LOGIN ID
        +: Loding ... ... Please wait
        #: The help is now displayed in a separate window.
        +: WEB / 2 can now be used as Web servers.
        -: ExtraRexx.dll is no longer needed.

1.00A2a:
	#: Error on free_access_for_ip=xxx.yyy.zzz. and free_access_for_ip =. fixed.
