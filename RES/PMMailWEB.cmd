/*****************************************************************************************************/
/*                           Webinterface for PMMail                                                 */
/*                     by Peter Lueersen <Peter@warp-ecs-owl.de>                                     */
/*                                        V 1.00A2                                                   */
/*****************************************************************************************************/
/*                                                                                                   */
/*           Author:       Peter LÅersen                                                             */
/*           Started:      27 February 2011                                                          */
/*           Last revised: 27 Mach 2011                                                              */
/*                                                                                                   */
/*                                                                                                   */
/*****************************************************************************************************/
/* This program is free software                                                                     */
/* you can redistribute it and/or modify it under the terms of the GNU General Public License        */
/* as published by the Free Software Foundation; either version 2 of the License,                    */
/* or (at your option) any later version.                                                            */
/*                                                                                                   */
/* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY          */
/* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.         */
/* See the GNU General Public License for more details.                                              */
/*                                                                                                   */
/* You should have received a copy of the GNU General Public License along with this program         */
/* if not, write to the                                                                              */
/* Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.           */
/*****************************************************************************************************/

/***************************************************/
/* Global Vars 1                                   */
/***************************************************/

Globals.!ext='CMD'                                                                      /*Filetype EXE or CMD                  */
Globals.!ver='1.00A2a'                                                                  /*Versinon                             */

signal on syntax name ShowError                                                         /*On Error goto Errorlog               */

_starttimer:                                                                            /*Start of main routine                */
    CALL Time 'E'

/***************************************************/
/* INSTALLATION                                    */
/***************************************************/

/***************************************************/
/* Globale Variablen from PMMAILWEB.CFG            */
/***************************************************/
Globals.!PMMailPath=''                                                                  /*Path to PMMail                       */
Globals.!MailDataPath=''                                                                /*Path to MailData from PMMail         */
Globals.!HtmlTableColor='WHITE'                                                         /*Table Color                          */
Globals.!Emailmax=25                                                                    /*Max Mails                            */
Globals.!html_body_line='<BODY onload="lade()" bgcolor="#EFEFEF" text="#000000">'       /*The BODY-Tag Line in the html outputs*/
Globals.!Show_HTML='NO'                                                                 /*Text and HTML                        */
Globals.!Lang='EN'                                                                      /*Language Support                     */
Globals.!Log='YES'                                                                      /*Log of Work                          */
Globals.!CGI_BIN='/cgi-bin/'                                                            /*Path to CGI-BIN of the Web-Server    */
Globals.!FreeAccess='0.0.0.0'                                                           /*Free access for IP                   */
Globals.!PMMail_user='USER'                                                             /*User for free access                 */
Globals.!PMMail_password='PASSWORD'                                                     /*Password for access                  */
parse SOURCE Globals.!myos .

/***************************************************/
/* Globale Variablen from CGI Environment          */
/***************************************************/
Globals.!SERVER_SOFTWARE=getEnv('SERVER_SOFTWARE')                                      /*CGI Environment                      */
Globals.!SERVER_NAME=getEnv('SERVER_NAME')                                              /*CGI Environment                      */
Globals.!GATEWAY_INTERFACE=getEnv('GATEWAY_INTERFACE')                                  /*CGI Environment                      */
Globals.!SERVER_PROTOCOL=getEnv('SERVER_PROTOCOL')                                      /*CGI Environment                      */
Globals.!SERVER_PORT=getEnv('SERVER_PORT')                                              /*CGI Environment                      */
Globals.!REQUEST_METHOD=getEnv('REQUEST_METHOD')                                        /*CGI Environment                      */
Globals.!PATH_INFO=getEnv('PATH_INFO')                                                  /*CGI Environment                      */
Globals.!PATH_TRANSLATED=getEnv('PATH_TRANSLATED')                                      /*CGI Environment                      */
Globals.!SCRIPT_NAME=getEnv('SCRIPT_NAME')                                              /*CGI Environment                      */
Globals.!QUERY_STRING=getEnv('QUERY_STRING')                                            /*CGI Environment                      */
Globals.!REMOTE_HOST=getEnv('REMOTE_HOST')                                              /*CGI Environment                      */
Globals.!REMOTE_ADDR=getEnv('REMOTE_ADDR')                                              /*CGI Environment                      */
Globals.!AUTH_TYPE=getEnv('AUTH_TYPE')                                                  /*CGI Environment                      */
Globals.!REMOTE_USER=getEnv('REMOTE_USER')                                              /*CGI Environment                      */
Globals.!REMOTE_IDENT=getEnv('REMOTE_IDENT')                                            /*CGI Environment                      */
Globals.!CONTENT_TYPE=getEnv('CONTENT_TYPE')                                            /*CGI Environment                      */
Globals.!CONTENT_LENGTH=getEnv('CONTENT_LENGTH')                                        /*CGI Environment                      */
Globals.!HTTP_ACCEPT=getEnv('HTTP_ACCEPT')                                              /*CGI Environment                      */
Globals.!HTTP_USER_AGENT=getEnv('HTTP_USER_AGENT')                                      /*CGI Environment                      */

/*****************************************************/
/* Global Vars 2                                     */
/*****************************************************/
if Globals.!SCRIPT_NAME \= '' then
	Globals.!ext=SUBSTR(Globals.!SCRIPT_NAME,length(Globals.!SCRIPT_NAME)-2,3)      /*Type of File (CMD,EXE)               */
Globals.!File='PMMailWEB.'||Globals.!ext                                                /*Name of File                         */
Globals.!CONFIGFile='PMMAILCONFIG.'||Globals.!ext                                       /*Name of CONFIG - File                */
Globals.!LOGFile='PMMailWEB.LOG'                                                        /*Name of DEBUG - File                 */
Globals.!IDFile='PMMailWEB.ID'                                                          /*Name of ID - File                 */
Globals.!myinfo='PMMailWeb Ver.:' || Globals.!ver || ' &copy; 2011 by Peter L&uuml;ersen'  /*Info Topline                         */
Globals.!BOUNDARY=""
foundChar = 0

/*****************************************************/
/* Vars for (STR1UPPER=TRANSLATE(STR1,tabout,taborg))*/
/*****************************************************/
taborg=XRANGE('a','z')
tabout=XRANGE('A','Z')

/*****************************************************/
/* Date's                                            */
/*****************************************************/
/* DATE(S)            : 20110316                     */ 
/* DATE(L)            : 16 March 2011                */
/* DATE(U)            : 03/16/11                     */
/* DATE(O)            : 11/03/16                     */
/* years              : 2011                         */
/* months             : 03                           */
/* days               : 16                           */
/* maildate           : 2011-03-16                   */                  
/*****************************************************/
dates=DATE('S')
datel=DATE('L')
dateu=DATE('U')
dateo=DATE('O')
years=SUBSTR(dates,1,4)
months=SUBSTR(dates,5,2)
days=SUBSTR(dates,7,2)
maildate= years || '-' || months || '-' || days                 

/*****************************************************/
/* PMMal Commands                                    */
/*****************************************************/
Globals.!PMMailSendShutdown=Globals.!PMMailPath || '\BIN\PMMAIL.EXE -cwd ' || Globals.!MailDataPath || ' -send-shutdown'         /*  C:\PMMAIL\BIN\PMMAIL.EXE -cwd C:\PMMAIL\ACCOUNTS -send-shutdown */
Globals.!PMMailSendRead=Globals.!PMMailPath || '\BIN\PMMAIL.EXE -cwd ' || Globals.!MailDataPath || ' -send-shutdown'         /*  C:\PMMAIL\BIN\PMMAIL.EXE -cwd C:\PMMAIL\ACCOUNTS -send-shutdown */
Globals.!PMMailSendSend=Globals.!PMMailPath || '\BIN\PMMAIL.EXE -cwd ' || Globals.!MailDataPath || ' -send-shutdown'         /*  C:\PMMAIL\BIN\PMMAIL.EXE -cwd C:\PMMAIL\ACCOUNTS -send-shutdown */

/*******************************************************************************************************************************/
/*  Start Main                                                                                                                 */
/*******************************************************************************************************************************/

CALL ReadConfig
call HTMLHead
PARSE ARG Command

/* For Apache 2.x   */
STR1=Command
STR1UPPER=TRANSLATE(STR1,tabout,taborg)
/* \ replace, */
if LASTPOS("\",STR1UPPER) > 0 then do
   STR2='\'
   STR3=''
   CALL STR123
END
/* For Apache 2.x   */

ID = 'LEER'
Option1 = 'LEER'
Option2 = 'LEER'
Option3 = 'LEER'
Option4 = 'LEER'
Option5 = 'LEER'
Option6 = 'LEER'

PARSE VALUE STR1 WITH ID '?' Command '?' Option1 '?' Option2 '?' Option3 '?' Option4 '?' Option5 '?' Option6
if Command \= "HELP" then do
	ID_IN = read_ID()
	IF ID_IN \= ID THEN DO
		ID=''
		Command=''
	END
end

/***************************/
/* Show Help always        */         
/***************************/
if Command == "HELP" then do
	ID='ID::HELP'
end

IF Command='' | ID='' THEN DO
        /**************************************************************/
        /* Build new Logfile                                          */
        /**************************************************************/       
        if Globals.!Log='YES' then 
	        call LOG 

        /**************************************************************/
        /* Login                                                      */
        /**************************************************************/
        Command='LEER'
        call delete_ID
        if pos(Globals.!FreeAccess,Globals.!REMOTE_ADDR) =1 then do 
                ID='ID::' || RANDOM() || 'QWERTZUIOP' || RANDOM() || 'ASDFGHJKL' || RANDOM()
                CALL write_ID ID 
                Command='READACCOUNT' 
		Option1 = ''
		Option2 = ''
		Option3 = ''
		Option4 = ''
		Option5 = ''
		Option6 = ''
        end
        if Globals.!FreeAccess='.' then do
                ID='ID::' || RANDOM() || 'QWERTZUIOP' || RANDOM() || 'ASDFGHJKL' || RANDOM()
                CALL write_ID ID 
                Command='READACCOUNT' 
		Option1 = ''
		Option2 = ''
		Option3 = ''
		Option4 = ''
		Option5 = ''
		Option6 = ''
        end
        if Globals.!FreeAccess='0.0.0.0' then
                Command='LEER'
        if Command='LEER' then do
                call HTMLHead
                SAY '<form method="post" autocomplete="off" action="'|| Globals.!CGI_BIN || Globals.!CONFIGFile ||'" name="PMMailWeb login">'
                SAY '<input type="hidden" name="FLOGIN" value="1">'
                SAY '<center>'
                SAY ' <table border="0" cellspacing="10">'
                SAY ' <TR>'
                SAY '  <BR>'
                SAY '  <font face="verdana,arial" SIZE="+2"><b>PMMailWeb login<BR></b></font>'
                SAY '  <BR>'
                SAY '  <BR>'
                if Globals.!Lang='GE' then do
                        SAY '  Anmeldung n&ouml;tig !<BR>'
                        SAY '  Bitte geben Sie Name und Passwort ein.<BR>'
                end
                if Globals.!Lang='EN' then do
                        SAY '  Authorization required !<BR>'
                        SAY '  Please insert your name and password.<BR>'
                end
                SAY '  <td align="right"> Name:</td>'
                SAY '  <td align="left"><input type="text" name="l" size="25"></td>'
                SAY ' </TR>'
                SAY ' <TR>'
                if Globals.!Lang='GE' then
                        SAY '  <td align="right">Passwort:</td>'
                if Globals.!Lang='EN' then
                        SAY '  <td align="right">Password:</td>'
                SAY '  <td align="left"><input type="password" name="p" size="25"></td>'
                SAY ' </TR>'
                SAY ' </table>'
                SAY ' <p><input type="submit" value="Login"></p>'
                SAY ' '
                SAY '</center>'
                SAY '</form>'
                SAY '<p>&nbsp;</p>'
                SAY '<center>'
                SAY '      <td align=center><a href="javascript:help_page()"> Hilfe </a></td>'
                SAY '<BR> '
                SAY 'Powered by '||Globals.!myos
                SAY '</center>'
                SAY '<hr size=1 noshade>'
                SAY '<Font face="verdana,arial" Size="-2">'||Globals.!myinfo || ' </Font>'
                if Globals.!Lang='GE' then
                     SAY '<Font face="verdana,arial" Size="-2"> <A Href="mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB"> Peter@warp-ecs-owl.de</A> Erstellt in 'Format(Time('E'),,2)' Sekunden.</Font><BR>'
                if Globals.!Lang='EN' then
                     SAY '<Font face="verdana,arial" Size="-2"> <A Href="mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB"> Peter@warp-ecs-owl.de</A> Generated in 'Format(Time('E'),,2)' seconds.</Font><BR>'
                SAY '</body>'
                SAY '</html>'
                EXIT
        end
end

SIGNAL UEBERGABE
erg=STREAM(Globals.!LOGFile, 'C', "CLOSE")

IF loaded = 1 THEN CALL SysDropFuncs
EXIT


/*******************************************************************************************************************************/
/*  End Main                                                                                                                   */
/*******************************************************************************************************************************/



/***************************************************/
/* Check command line arguments.                   */
/* Call Functions                                  */
/***************************************************/
UEBERGABE:
/* Call Function    */
IF Command == "ADDRESBOOK"  THEN DO
    CALL MakeBookCSV Option1 Option2
END

IF Command == "INFO" THEN DO
    CALL INFO
END
IF Command == "INFO1" THEN DO
    CALL INFO1
END

IF Command == "READACCOUNT" THEN DO
    CALL READACCOUNT
END

IF Command == "GETACCOUNT" THEN DO
    CALL GETACCOUNT
END

IF Command == "GETGROUP" THEN DO
    CALL GETGROUP
END

IF Command == "GETMAIL" THEN DO
    CALL GETMAIL
END

IF Command == "CONFIG" THEN DO
    CALL CONFIG
END

IF Command == "HELP" THEN DO
    CALL HELP
END

/*End all and exit*/

say '</body></html>'
say ''

RETURN


/***************************************************/
/*Function  LOG Wirte new Logfile                  */
/***************************************************/

LOG:
	if Globals.!Log='YES' then do
           IF ='' THEN
               	erg=SysFileDelete(Globals.!LOGFile)
	        CALL LINEOUT Globals.!LOGFile,'**********************************************************************'
        	CALL LINEOUT Globals.!LOGFile,'Program            : ' || Globals.!myinfo
	        CALL LINEOUT Globals.!LOGFile,'**********************************************************************'
        	CALL LINEOUT Globals.!LOGFile,'ARG                : ' || ID || '#' || Command || '#' || Option1 || '#' || Option2 || '#' || Option3 || '#' || Option4 || '#' || Option5 || '#' || Option6
        	CALL LINEOUT Globals.!LOGFile,'----------------------------------------------------------------------'
        	CALL LINEOUT Globals.!LOGFile,'PMMail_Path        : ' || Globals.!PMMailPath
        	CALL LINEOUT Globals.!LOGFile,'Mail_Data_Path     : ' || Globals.!MailDataPath
        	CALL LINEOUT Globals.!LOGFile,'html_table_color   : ' || Globals.!HtmlTableColor
        	CALL LINEOUT Globals.!LOGFile,'html_body_line     : ' || Globals.!html_body_line
        	CALL LINEOUT Globals.!LOGFile,'Email_Max          : ' || Globals.!Emailmax
        	CALL LINEOUT Globals.!LOGFile,'Show_HTML          : ' || Globals.!Show_HTML
        	CALL LINEOUT Globals.!LOGFile,'CGI_BIN            : ' || Globals.!CGI_BIN
        	CALL LINEOUT Globals.!LOGFile,'Lang               : ' || Globals.!Lang
        	CALL LINEOUT Globals.!LOGFile,'Debug              : ' || Globals.!Log
        	CALL LINEOUT Globals.!LOGFile,'----------------------------------------------------------------------'
        	CALL LINEOUT Globals.!LOGFile,'DATE(S)            : ' || dates
        	CALL LINEOUT Globals.!LOGFile,'DATE(L)            : ' || datel
        	CALL LINEOUT Globals.!LOGFile,'DATE(U)            : ' || dateu
        	CALL LINEOUT Globals.!LOGFile,'DATE(O)            : ' || dateo
        	CALL LINEOUT Globals.!LOGFile,'years              : ' || years
        	CALL LINEOUT Globals.!LOGFile,'months             : ' || months
        	CALL LINEOUT Globals.!LOGFile,'days               : ' || days
        	CALL LINEOUT Globals.!LOGFile,'----------------------------------------------------------------------'
        	CALL LINEOUT Globals.!LOGFile,'File               : ' || Globals.!File         /*Name of File                         */
        	CALL LINEOUT Globals.!LOGFile,'CONFIGFile         : ' || Globals.!CONFIGFile   /*Name of CONFIG - File                */
        	CALL LINEOUT Globals.!LOGFile,'LOGFile            : ' || Globals.!LOGFile      /*Name of DEBUG - File                 */
        	CALL LINEOUT Globals.!LOGFile,'======================================================================'
	end
RETURN

/***************************************************/
/*Functio  READ Config (/cgi-bin/PMMailWEB.CFG)    */
/***************************************************/
ReadConfig:
    /* if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Start ReadConfig' */
    Filename='PMMailWEB.CFG'
    erg=STREAM(Filename, 'C', "QUERY EXISTS")
    if ret\="" then do
       erg=STREAM(Filename, 'C', "OPEN")
       /*Auswerten der Datei*/
       DO WHILE lines(Filename) = 1
        Zeile=LINEIN(Filename)
        if Zeile \= '' then do
                if pos('#',Zeile,1) \= 1 then do
                        pos1=pos('=', Zeile)
                        Option=SUBSTR(Zeile, 1,pos1-1)
                        Option_Value=SUBSTR(Zeile,pos1+1,length(Zeile)-pos1)
                        /*  SAY Option || '==' || Option_Value || '<BR>' */ 
                        if OPTION='PMMail_Path' then
                                Globals.!PMMailPath=Option_Value
                        if OPTION='Mail_Data_Path' then
                                Globals.!MailDataPath=Option_Value
                        if OPTION='html_table_color' then
                                Globals.!HtmlTableColor=Option_Value
                        if OPTION='html_body_line' then
                                Globals.!html_body_line=Option_Value
                        if OPTION='Email_Max' then
                                Globals.!Emailmax=Option_Value
                        if OPTION='Show_HTML' then
                                Globals.!Show_HTML=TRANSLATE(Option_Value,tabout,taborg)
                        if OPTION='Lang' then do
                                 Globals.!Lang='GE'
                                 Lang=TRANSLATE(Option_Value,tabout,taborg)
                                 if Lang='EN' then
                                    Globals.!Lang='EN'
                                 if Lang='GE' then
                                    Globals.!Lang='GE'
                                 if Lang='DE' then
                                    Globals.!Lang='GE'
                        end
                        if OPTION='CGI-BIN_Path' then
                                Globals.!CGI_BIN=Option_Value
                        if OPTION='Debug' then
                                Globals.!Log=TRANSLATE(Option_Value,tabout,taborg)
                        if OPTION='free_access_for_ip' then
                                Globals.!FreeAccess=Option_Value
                        if OPTION='PMMail_user' then
                                Globals.!PMMail_user=Option_Value
                        if OPTION='PMMail_password' then
                                Globals.!PMMail_password=Option_Value
                end
        end
      END
      erg=STREAM(Globals.!IDFile, 'C', "CLOSE")
    end
    if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> End ReadConfig'
RETURN



/***************************************************/
/*Function Write Head of HTML - Page               */
/***************************************************/

HTMLHead:
    if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Start HTMLHead'
    say 'Content-Type: text/html;  charset=ISO-8859-1'
    say ''
    say '<!doctype html public "-//w3c//dtd html 4.0 transitional//en">'
    say '<!-- File automatically generated by ' || Globals.!myinfo || ' on ' || DATE() || ' at ' || TIME('N') || ' -->'
    say '<!-- (C) COPYRIGHT Peter Lueersen 2011                      -->'
    say '<!-- All Rights Reserved                                    -->'
    say '<!-- Licensed Materials - Property of Peter Lueersen        -->'
    SAY '<html>'
    SAY '<head>'
    say '<meta http-equiv="expires" content="0">'
    say '<meta name="author" content="' || Globals.!myinfo || '">'
    say '<meta http-equiv="content-type">'
    say '<meta NAME="Robots" CONTENT="NOINDEX, NOFOLLOW">'
    SAY '<meta http-equiv=content-type content="text/html; charset=UTF-8">'
    SAY '<meta name="Description" content="PMMail - WEB ">'
    SAY '<meta name="Keywords" content="PMMailWEB ,PMMail, Peter Lueersen, eComstation, OS/2">'
    say ''
    SAY '<title> PMMail - WEB </title>'
    say ''
    say '<style type="text/css">'
    say '   a:link { font-family : verdana, arial;font-weight:normal; color:#0000E0; text-decoration:none }'
    say '   a:visited { font-family : verdana, arial;font-weight:normal; color:#0000E0; text-decoration:none }'
    say '   a:hover { font-family : verdana, arial;font-weight:normal; color:#E00000; text-decoration:none }'
    say '   a:active { font-family : verdana, arial;font-weight:normal; color:#E00000; text-decoration:none }'
    say '   a:focus { font-family : verdana, arial;font-weight:normal; color:#00E000; text-decoration:none }'
    say '</style>'
    say ''
    say '<script language="JavaScript">'
    say '<!--'
    say '    function scrollit_r2l(seed)'
    say '    {'
    say '     var msg = "PMMailWeb - Your Mails from  all over the world";'
    say '     var out = " ";'
    say '     var c = 1;'
    say '     if (seed > 100)'
    say '     {'
    say '     seed--;'
    say '     var cmd="scrollit_r2l(" + seed + ")";'
    say '     timerTwo=window.setTimeout(cmd,100);'
    say '     }'
    say '     else if (seed <= 100 && seed > 0)'
    say '     {'
    say '     for (c=0 ; c < seed ; c++)'
    say '     {'
    say '     out+=" ";'
    say '     }'
    say '     out+=msg;'
    say '     seed--;'
    say '     var cmd="scrollit_r2l(" + seed + ")";'
    say '     window.status=out;'
    say '     timerTwo=window.setTimeout(cmd,100);'
    say '     }'
    say '     else if (seed <= 0)'
    say '     {'
    say '     if (-seed < msg.length)'
    say '     {'
    say '     out+=msg.substring(-seed,msg.length);'
    say '     seed--;'
    say '     var cmd="scrollit_r2l(" + seed + ")";'
    say '     window.status=out;'
    say '     timerTwo=window.setTimeout(cmd,100);'
    say '     }'
    say '     else'
    say '     {'
    say '     window.status=" ";'
    say '     timerTwo = window.setTimeout("scrollit_r2l(100)",75);'
    say '     }'
    say '     }'
    say '    }'
    say ''
    say '    function help_page()'
    say '    {'
    say '     var help_page = window.open("' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?HELP?' || '","","scrollbars=yes,menubar=no,height=600,width=800,resizable=yes,toolbar=no,location=no,status=no");'
    say '    }'
    say ''
    say '    function lade()'
    say '    {'
    say '     waitPreloadPage();'
    say '     timerONE=window.setTimeout("scrollit_r2l(100)",500);'
    say '    }'
    say ''
    say '    <!-- PreLoad Wait - Script -->'
    say '    function waitPreloadPage() { //DOM'
    say '    if (document.getElementById){'
    say '    document.getElementById("prepage").style.visibility="hidden";'
    say '    }else{'
    say '    if (document.layers){ //NS4'
    say '    document.prepage.visibility = "hidden";'
    say '    }'
    say '    else { //IE4'
    say '    document.all.prepage.style.visibility = "hidden";'
    say '    }'
    say '    }'
    say '    }'
    say '//-->'
    say '</script>'
    say ''
    say '</head>'
    say ''
    say Globals.!html_body_line
    say ''
    say '<DIV id="prepage" style="position:absolute; font-family:verdana; font-size:40; left:0px; top:0px; background-color:#FAF0E6; layer-background-color:white; height:100%; width:100%;"> '
    say '<TABLE width=100%><TR><TD><CENTER><B>Loading ... ... Please wait!</B></CENTER></TD></TR></TABLE>'
    say '</DIV>'
    say ''
    say '<table align=center width=100% border="0" cellspacing="0" cellpadding="0">'
    say '   <tr>'
    say '   <td align=center> <Font face="verdana,arial"><B>' || Globals.!myinfo || '</B></font><BR></td>'
    say '   </tr>'
    say '</table>'
    say '<hr size=1 noshade>'
    if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> End HTMLHead'
RETURN


/* ================================================================== */
/* Function Show Product Info                                         */
/* ================================================================== */
INFO:
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Start INFO'
        say '<!-- Start INFO //-->'
        /* öberschrift erstellen */
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Abmelden </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Verlassen der Produktinformation</A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID ||  '?INFO1? > Systeminformation</A></td>'
        end
        if Globals.!Lang='EN' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Logout </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Exit  Product Information</A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?INFO1? > System Information</A></td>'
        end
        say '   </tr>'
        say '</table>'
        say '<hr size=1 noshade>'
        say '<br>'
        say '<table align=center width=90% border="1" cellspacing="1" cellpadding="1">'
        say '   <tr bgcolor="'||Globals.!HtmlTableColor||'">'
        say '   <td align=center>'
        say '   <br>'
        say '   <font face="verdana,arial" SIZE=+2><b>PMMailWeb <br></b></font>'
        say '   <br>'
        say '   <br>'
        if Globals.!Lang='GE' then
                say '   <font face="verdana,arial" SIZE=-1>Produktinformation <br></font>'
        if Globals.!Lang='EN' then
                say '   <font face="verdana,arial" SIZE=-1>Product Information <br></font>'
        say '   <br>'
        say '   <font face="verdana,arial">' || Globals.!File || '   Version  ' || Globals.!ver || '<br>'
        say '   <br>'
        say '   '||Globals.!myinfo||'.<br>'
        say '   <br>'
        say '   Program URL:<br>'
        say '   <A Href=http://www.warp-ecs-owl.de> www.warp-ecs-owl.de </A> <br>'
        say '   <A Href=http://www.warp-ecs-owl.de/Peter_PMMailWEB.html> www.warp-ecs-owl.de/Peter_PMMailWEB.html </A> <br>'
        say '   <br>'
        if Globals.!Lang='GE' then do
                say '   PMMailWeb ist freie Software! <br>'
                say '   Aus diesem Grunde wird f&uuml;r PMMailWeb<b> keine Haftung jedweder Art </b>&uuml;bernommen.<br>'
                say '   <br>'
                say '   Fehlerberichte und Vorschl&auml;ge richten Sie bitte an Peter@warp-ecs-owl.de <br>'
        end
        if Globals.!Lang='EN' then do
                say '   PMMailWeb is free software! <br>'
                say '   PMMailWeb comes with absolutely<b> no Warranty</b>.<br>'
                say '   <br>'
                say '   Contact Peter@warp-ecs-owl.de for bug reports and suggestions.<br>'
        end
        say '   <br>'
        say '   </font></td>'
        say '   </tr>'
        say '</table>'
        say '   <font face="verdana,arial"'
        say '<br>'
        say '   </font>'
        say '<hr size=1 noshade>'
        say '<Font face="verdana,arial"; Size="-2">'||Globals.!myinfo || ' ' ||  ' </Font>'
        if Globals.!Lang='GE' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWeb> Peter@warp-ecs-owl.de</A> Erstellt in 'Format(Time('E'),,2)' Sekunden.</Font><BR>'
        if Globals.!Lang='EN' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWeb> Peter@warp-ecs-owl.de</A> Generated in 'Format(Time('E'),,2)' seconds.</Font><BR>'
        say '<!-- End INFO //-->'
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> End INFO'
Return


/***************************************************/
/*Function to show the System Info                 */
/***************************************************/

INFO1:
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Start SYSTEM INFO'
        say '<!-- Start SYSTEM INFO //-->'

        /* öberschrift erstellen */
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Abmelden </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Verlassen der Systeninformation</A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?INFO?' || '> Produktinformation </A></td>'
        end
        if Globals.!Lang='EN' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Logout </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Exit  System Information</A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?INFO?' || '> Product Information </A></td>'
        end
        say '   </tr>'
        say '</table>'
        say '<hr size=1 noshade>'
        say '<br>'
        say '<table align=center width=90% border="1" cellspacing="1" cellpadding="1">'
        say '   <tr bgcolor="'||Globals.!HtmlTableColor||'">'
        say '   <td align=center>'
        say '   <br>'
        if Globals.!Lang='GE' then
                say '   <face="verdana,arial" SIZE=+2><b>Systeminformation <br></b></font>'
        if Globals.!Lang='EN' then
                say '   <face="verdana,arial" SIZE=+2><b>System Information <br></b></font>'
        say '   <br>'
        say '   <font face="verdana,arial">' || Globals.!File || '   Version  ' || Globals.!ver || '<br>'
        say '   <br>'
        say '   '||Globals.!myinfo||'.<br>'
        say '   <br>'
        if Globals.!SERVER_SOFTWARE \= '' then
                SAY '  SERVER SOFTWARE <== ' || Globals.!SERVER_SOFTWARE || '<BR>'
        if Globals.!SERVER_NAME \= '' then
                SAY '      SERVER NAME <== ' || Globals.!SERVER_NAME || '<BR>'
        if Globals.!GATEWAY_INTERFACE \= '' then
                SAY 'GATEWAY INTERFACE <== ' || Globals.!GATEWAY_INTERFACE || '<BR>'
        if Globals.!SERVER_PROTOCOL \= '' then
                SAY '  SERVER PROTOCOL <== ' || Globals.!SERVER_PROTOCOL || '<BR>'
        if Globals.!SERVER_PORT \= '' then
                SAY '      SERVER PORT <== ' || Globals.!SERVER_PORT || '<BR>'
        if Globals.!REQUEST_METHOD \= '' then
                SAY '   REQUEST METHOD <== ' || Globals.!REQUEST_METHOD || '<BR>'
        if Globals.!PATH_INFO \= '' then
                SAY '        PATH INFO <== ' || Globals.!PATH_INFO || '<BR>'
        if Globals.!PATH_TRANSLATED \= '' then
                SAY '  PATH TRANSLATED <== ' || Globals.!PATH_TRANSLATED || '<BR>'
        if Globals.!SCRIPT_NAME \= '' then
                SAY '      SCRIPT NAME <== ' || Globals.!SCRIPT_NAME || '<BR>'
        if Globals.!QUERY_STRING \= '' then
                SAY '     QUERY STRING <== ' || Globals.!QUERY_STRING || '<BR>'
        if Globals.!AUTH_TYPE \= '' then
                SAY '        AUTH TYPE <== ' || Globals.!AUTH_TYPE || '<BR>'
        if Globals.!AUTH_TYPE \= '' then
                SAY '      REMOTE HOST <== ' || Globals.!REMOTE_HOST || '<BR>'
        if Globals.!REMOTE_ADDR \= '' then
                SAY '      REMOTE ADDR <== ' || Globals.!REMOTE_ADDR || '<BR>'
        if Globals.!REMOTE_USER \= '' then
                SAY '      REMOTE USER <== ' || Globals.!REMOTE_USER || '<BR>'
        if Globals.!REMOTE_IDENT \= '' then
                SAY '     REMOTE IDENT <== ' || Globals.!REMOTE_IDENT || '<BR>'
        if Globals.!CONTENT_TYPE \= '' then
                SAY '     CONTENT TYPE <== ' || Globals.!CONTENT_TYPE || '<BR>'
        if Globals.!CONTENT_LENGTH \= '' then
                SAY '   CONTENT LENGTH <== ' || Globals.!CONTENT_LENGTH || '<BR>'
        if Globals.!HTTP_ACCEPT \= '' then
                SAY '      HTTP ACCEPT <== ' || Globals.!HTTP_ACCEPT || '<BR>'
        if Globals.!HTTP_USER_AGENT \= '' then
                SAY '  HTTP USER AGENT <== ' || Globals.!HTTP_USER_AGENT || '<BR>'
        say '   <br>'
        say '   </font></td>'
        say '   </tr>'
        say '</table>'
        say '   <font face="verdana,arial"'
        say '<br>'
        say '   </font>'
        say '<hr size=1 noshade>'
        say '<Font face="verdana,arial"; Size="-2">'||Globals.!myinfo || ' ' ||  ' </Font>'
        if Globals.!Lang='GE' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWeb> Peter@warp-ecs-owl.de</A> Erstellt in 'Format(Time('E'),,2)' Sekunden.</Font><BR>'
        if Globals.!Lang='EN' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWeb> Peter@warp-ecs-owl.de</A> Generated in 'Format(Time('E'),,2)' seconds.</Font><BR>'
        say '<!-- End SYSTEM  INFO //-->'
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> End SYSTEM INFO'
RETURN

/**********************************************************************/
/* Function Read all Accounts and show                                */
/**********************************************************************/
READACCOUNT:
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Start READACCOUNT:'
        say '<!-- Start READACCOUNT //-->'
        /* öberschrift erstellen */
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Abmelden </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?INFO?' || '> Produktinformation </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?CONFIG?' || '> Konfiguration </A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Hilfe </a></td>'
        end
        if Globals.!Lang='EN' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Logout </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?INFO?' || '> Product Information </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?CONFIG?' || '> Configuration </A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Help </a></td>'
        end
        say '   </tr>'
        say '</table>'
        say '<hr size=1 noshade>'
        if Globals.!Lang='GE' then
                say ' Liste aller Accounts <BR>'
        if Globals.!Lang='EN' then
                say ' List of all Accounts <BR>'
        say '<hr size=1 noshade>'

        /* Tabelle mit den Accounts erstellen */
        say '<table align=center width=80% border="2" cellspacing="2" cellpadding="2">'
        rc=SysFileTree(Globals.!MailDataPath || '\*.act', 'account', 'D', '*+***')
        if Globals.!Log='YES' then do
                CALL LINEOUT Globals.!LOGFile,'->   PMMailDataPath       = ' || Globals.!MailDataPath
                CALL LINEOUT Globals.!LOGFile,'->   Account.0            = ' || account.0
        end
        if account.0 > 0 then do
                Call SysStemSort "account.", "D",,,,4
                do i=1 to account.0
                        /*nur den Accountnamen anzeigen*/
                        pos1=lastpos('\', account.i)
                        accountname=SUBSTR(account.i, pos1+1,LENGTH(account.i)-pos1)
                        accountnametranslate=readACCTINI(Globals.!MailDataPath || '\' || accountname)
                        if Globals.!Log='YES' then do
                                CALL LINEOUT Globals.!LOGFile,'->   Account.' || i ||'            = ' || account.i
                                CALL LINEOUT Globals.!LOGFile,'->   Accountname          = ' || accountname
                                CALL LINEOUT Globals.!LOGFile,'->   Accountnametranslate = ' || accountnametranslate
                        end
                        /*und mit link anzeigen */
                        say '   <tr bgcolor="'||Globals.!HtmlTableColor||'">'
			if Globals.!Log='YES' then 
				CALL LINEOUT Globals.!LOGFile,'->   Link                 = ' || Globals.!CGI_BIN || Globals.!File || '?GETACCOUNT?' || accountname
                        say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?GETACCOUNT?' || accountname  || '>' || accountnametranslate || '</A></td>'
                        say '   </tr>'
                end
        end
        say '</table>'
        /* Unterschrift erstellen */
        say '<hr size=1 noshade>'
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Abmelden </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?INFO?' || '> Produktinformation </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?CONFIG?' || '> Konfiguration </A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Hilfe </a></td>'
        end
        if Globals.!Lang='EN' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Logout </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?INFO?' || '> Product Information </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?CONFIG?' || '> Configuration </A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Help </a></td>'
        end
        say '   </tr>'
        say '</table>'
        say '<hr size=1 noshade>'
        say '<Font face="verdana,arial"; Size="-2">'||Globals.!myinfo || ' ' ||  ' </Font>'
        if Globals.!Lang='GE' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB> Peter@warp-ecs-owl.de</A> Erstellt in 'Format(Time('E'),,2)' Sekunden.</Font><BR>'
        if Globals.!Lang='EN' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB> Peter@warp-ecs-owl.de</A> Generated in 'Format(Time('E'),,2)' seconds.</Font><BR>'
        say '</body></html>'
        say ''
        say '<!-- End READACCOUNT //-->'
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> End READACCOUNT:'
RETURN

/* ================================================================== */
/* Read Account and show                                              */
/* ================================================================== */
GETACCOUNT:
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Start GETACCOUNT'
        say '<!-- Start GETACCOUNT //-->'
        accountname = Option1
        accountnametranslate = Globals.!MailDataPath || '\' || accountname
        if Globals.!Log='YES' then do
                CALL LINEOUT Globals.!LOGFile,'->   Accountname          = ' || accountname
                CALL LINEOUT Globals.!LOGFile,'->   Accountnametranslate = ' || accountnametranslate
        end

        /* öberschrift erstellen */
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Abmelden </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Anzeige aller Accounts</A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Hilfe </a></td>'
	end
        if Globals.!Lang='EN' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Logout </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Show Accounts</A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Help </a></td>'
	end
        say '   </tr>'
        say '</table>'
        say '<hr size=1 noshade>'
        if Globals.!Lang='GE' then
                say ' Liste aller Ordner im Account: ' || readACCTINI(accountnametranslate) || ' <BR>'
        if Globals.!Lang='EN' then
                say ' List of all Folders in Account: ' || readACCTINI(accountnametranslate) || ' <BR>'
        say '<hr size=1 noshade>'

        /* Tabelle mit den Gruppen erstellen */
        say '<table align=center width=80% border="2" cellspacing="2" cellpadding="2">'
        rc=SysFileTree(accountnametranslate || '\*.fld', 'group', 'DT', '*+***')
        /* Die Gruppen werden nach Name sotiert (a->z) angezeigt. */
        if group.0 > 0 then do
                Call SysStemSort "group.", "A","I",,,24,1000
                do i=1 to group.0
                        /* nur den Groupnamen anzeigen */
                        pos1=lastpos('\', group.i)
                        groupname=SUBSTR(group.i, pos1+1,LENGTH(group.i) - pos1)
                        groupnametranslate=readFOLDERINI(accountnametranslate || '\' || groupname)
                        if Globals.!Log='YES' then do
                                CALL LINEOUT Globals.!LOGFile,'->   Group.' || i ||'            = ' || group.i
                                CALL LINEOUT Globals.!LOGFile,'->   Groupname          = ' || groupname
                                CALL LINEOUT Globals.!LOGFile,'->   Groupnametranslate = ' || groupnametranslate
                        end
                        /*PrÅfen ob Mails von heute vorhanden sind*/
                        rc=SysFileTree(accountnametranslate || '\' || groupname || '\*.MSG', 'email', 'FT','*****')
                        /* Die mails werden nach Datum sotiert neuste zuerst. */
                        if email.0 > 0 then do
                                Call SysStemSort "email.", "D","I",,,1,15
                                FileDate=SUBSTR(email.1,1,pos('/', email.1,1)+5)
                        end
                        if Globals.!Log='YES' then do
                                CALL LINEOUT Globals.!LOGFile,'->   Email.0            = ' || email.0
				if email.0 > 0 then 
	                                CALL LINEOUT Globals.!LOGFile,'->   Last FileDate      = ' || FileDate
				ELSE
	                                CALL LINEOUT Globals.!LOGFile,'->   Last FileDate      = ' 
			end
                        /* Umlaute und Sonderzeichen ersetzen, */
                        zeile=groupnametranslate
                        CALL HTML
                        CALL UMLAUTE
                        groupname=zeile
                        /*wenn Mails von heute vorhanden sind, dann (@) */
                        if FileDate = dateo & email.0 > 0 then
                                groupnametranslate='(@) '||groupnametranslate
                        /* und mit link anzeigen */
                        say '   <tr bgcolor="'||Globals.!HtmlTableColor||'">'
			if Globals.!Log='YES' then 
				CALL LINEOUT Globals.!LOGFile,'->   Link               = ' || Globals.!CGI_BIN || Globals.!File || '?GETGROUP?' || accountname || '?' ||groupname	
                        say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?GETGROUP?' || accountname || '?' ||groupname || '>' || groupnametranslate || '</A></td>'
                        say '   </tr>'
                end
        end
        say '</table>'
        /* Unterschrift erstellen */
        say '<hr size=1 noshade>'
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Abmelden </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Anzeige aller Accounts</A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Hilfe </a></td>'
	end
        if Globals.!Lang='EN' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Logout </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Show Accounts</A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Help </a></td>'
	end
        say '   </tr>'
        say '</table>'
        say '<hr size=1 noshade>'
        say '<Font face="verdana,arial"; Size="-2">'||Globals.!myinfo || ' ' ||  ' </Font>'
        if Globals.!Lang='GE' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB> Peter@warp-ecs-owl.de</A> Erstellt in 'Format(Time('E'),,2)' Sekunden.</Font><BR>'
        if Globals.!Lang='EN' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB> Peter@warp-ecs-owl.de</A> Generated in 'Format(Time('E'),,2)' seconds.</Font><BR>'
        say '</body></html>'
        say ''
        say '<!-- End GETACCOUNT //-->'
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> End GETACCOUNT'
RETURN


/* ================================================================== */
/* Read Groups im Account and show                                    */
/* ================================================================== */
GETGROUP:
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Start GETGROUP'
        say '<!-- Start GETGROUP //-->'
        Option1Link = Option1
        CommandLink = '?' || ID || '?GETACCOUNT?'
	accountname = REPLACESlash(Option1)
        accountnametranslate = Globals.!MailDataPath || '\' || accountname
	accountnametranslate1 = readACCTINI(accountnametranslate)
        groupname = REPLACESlash(Option2) || '.fld'
        groupnametranslate = readFOLDERINI(accountnametranslate || '\' || groupname)
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'Option1Link -> ' || Option1Link
       /* öberschrift erstellen */
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        pos1=lastpos('/', Option1)
	if pos1 >> 0 then do
           Option1Link=TRANSLATE(Option1,'?','/')
           Option1Link1=TRANSLATE(Option1,'\','/')
           Option1Link=SUBSTR(Option1Link, 1,LENGTH(Option1Link) - 4) 
	   accountnametranslate1 = readFOLDERINI(Globals.!MailDataPath || '\' || Option1Link1)
           CommandLink = '?' || ID || '?GETGROUP?'
	end	
        if Globals.!Lang='GE' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Abmelden </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Anzeige aller Accounts</A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || CommandLink || Option1Link || '> Anzeige der Ordner von ' || accountnametranslate1 || '</A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Hilfe </a></td>'
        end
        if Globals.!Lang='EN' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Logout </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Show Accounts</A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || CommandLink || Option1Link || '> Show Folders from ' || accountnametranslate1 || '</A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Help </a></td>'
        end
        say '   </tr>'
        say '</table>'
        say '<hr size=1 noshade>'
        if Globals.!Lang='GE' then
                say ' Liste aller Ordner / E-Mail von : ' || groupnametranslate || ' <BR>'
        if Globals.!Lang='EN' then
                say ' List of all Folder / E-Mail from : ' || groupnametranslate || ' <BR>'
        say '<hr size=1 noshade>'

        /* Tabelle mit den Gruppen erstellen */
        say '<table align=center width=100% border="2" cellspacing="2" cellpadding="2">'
        accountnametranslate = accountnametranslate || '\' || groupname
        rc=SysFileTree(accountnametranslate  || '\*.fld' , 'group', 'DT', '*+***')
        /* Die Gruppen werden nach Name sotiert (a->z) angezeigt. */
        if group.0 > 0 then do
	        if Globals.!Lang='GE' then do
        	        say '      <td align=center> <A> Neu: </A></td>'
            		say '      <td align=center> <A> Ordner: </A></td>'
        	end       
	        if Globals.!Lang='EN' then do
        		say '      <td align=center> <A> New: </A></td>'
            		say '      <td align=center> <A> Folder: </A></td>'
        	end
                Call SysStemSort "group.", "A","I",,,24,1000
                do i=1 to group.0
                        /* nur den Groupnamen anzeigen */
                        pos1=lastpos('\', group.i)
                        groupname=SUBSTR(group.i, pos1+1,LENGTH(group.i) - pos1)
                        groupname1=SUBSTR(group.i, pos1+1,LENGTH(group.i) - pos1 - 4) 
                        groupnametranslate=readFOLDERINI(accountnametranslate || '\' || groupname)
                        if Globals.!Log='YES' then do
                                CALL LINEOUT Globals.!LOGFile,'->   Group.' || i ||'            = ' || group.i
                                CALL LINEOUT Globals.!LOGFile,'->   Groupname          = ' || groupname
                                CALL LINEOUT Globals.!LOGFile,'->   Groupnametranslate = ' || groupnametranslate
                        end
                        /*PrÅfen ob Mails von heute vorhanden sind*/
                        rc=SysFileTree(accountnametranslate || '\' || groupname || '\*.MSG', 'email', 'FT','*****')
                        /* Die mails werden nach Datum sotiert neuste zuerst. */
                        if email.0 > 0 then do
                                Call SysStemSort "email.", "D","I",,,1,15
                                FileDate=SUBSTR(email.1,1,pos('/', email.1,1)+5)
                        end
                        if Globals.!Log='YES' then do
                                CALL LINEOUT Globals.!LOGFile,'->   Email.0            = ' || email.0
				if email.0 > 0 then 
	                                CALL LINEOUT Globals.!LOGFile,'->   Last FileDate      = ' || FileDate
				ELSE
	                                CALL LINEOUT Globals.!LOGFile,'->   Last FileDate      = ' 
			end
                        /* Umlaute und Sonderzeichen ersetzen, */
                        zeile=groupnametranslate
                        CALL HTML
                        CALL UMLAUTE
                        groupname=zeile
                        /*wenn Mails von heute vorhanden sind, dann (@) */
                        if FileDate = dateo & email.0 > 0 then
                                Zeile='@'
			else
				Zeile=' ' 
                        /* und mit link anzeigen */
                        say '   <tr bgcolor="'||Globals.!HtmlTableColor||'">'
			if Globals.!Log='YES' then 
				CALL LINEOUT Globals.!LOGFile,'->   Link               = ' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?GETGROUP?' || REPLACEBackslash(Option1 || '\' || Option2) || '.FLD?' || groupname1	
                        say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?GETGROUP?' || REPLACEBackslash(Option1 || '\' || Option2) || '.FLD?' || groupname1 || '>' || Zeile || '</A></td>'
                        say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?GETGROUP?' || REPLACEBackslash(Option1 || '\' || Option2) || '.FLD?' || groupname1 || '>' || groupname || '</A></td>'
                        say '   </tr>'
                end
        end
        /* Read all Mails in this Path and show */
        if Globals.!Lang='GE' then do
            say '      <td align=center> <A> Neu: </A></td>'
            say '      <td align=center> <A> Betreff: </A></td>'
            say '      <td align=center> <A> from: </A></td>'
            say '      <td align=center> <A> to: </A></td>'
            say '      <td align=center> <A> Zeit: </A></td>'
        end       
        if Globals.!Lang='EN' then do
            say '      <td align=center> <A> New: </A></td>'
            say '      <td align=center> <A> Subject: </A></td>'
            say '      <td align=center> <A> from: </A></td>'
            say '      <td align=center> <A> to: </A></td>'
            say '      <td align=center> <A> Time: </A></td>'
        end
        MaxCount=1
        DataFile = accountnametranslate ||'\Folder.BAG'
        CALL STREAM DataFile, 'C', 'OPEN'
        DO WHILE LINES(DataFile) = 1  
	    MaxCount=MaxCount+1
            /*                                Read            'ﬁ' Attachments     'ﬁ' Date            'ﬁ' Time            'ﬁ' Subject         'ﬁ'toEmail          'ﬁ'toName           'ﬁ' fromEmail       'ﬁ' fromName        'ﬁ'size'ﬁ' EmailFileName    'ﬁ' */                                  
            PARSE VALUE LINEIN(DataFile) WITH Mail.MaxCount.1 'ﬁ' Mail.MaxCount.2 'ﬁ' Mail.MaxCount.3 'ﬁ' Mail.MaxCount.4 'ﬁ' Mail.MaxCount.5 'ﬁ' Mail.MaxCount.6 'ﬁ' Mail.MaxCount.7 'ﬁ' Mail.MaxCount.8 'ﬁ' Mail.MaxCount.9 'ﬁ'  . 'ﬁ' Mail.MaxCount.11 'ﬁ'
        END
        CALL STREAM DataFile, 'C', 'CLOSE'
        IF Globals.!Emailmax == 0 THEN MinCount=2         /* All */
        IF Globals.!Emailmax == -1 THEN MinCount=2        /* New */
        IF Globals.!Emailmax > 0 THEN DO                  /* Upto */
            MinCount=2
            if MaxCount > Globals.!Emailmax then do 
		MinCount=MaxCount-Globals.!Emailmax
	    end	
        END
	DO MailCount=MaxCount TO MinCount BY -1
                if maildate == Mail.MailCount.3 then do
                        Zeile='@'
                end
                else do
                        Zeile=' '
                        if Globals.!Emailmax == -1 then LEAVE
                end
		MailPathName = REPLACEBackslash(accountnametranslate || '\' || Mail.MailCount.11)
        	say '   <tr bgcolor="'||Globals.!HtmlTableColor||'">'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?GETMAIL?' || MailPathName || '>' || Zeile || '</A></td>'                	    
		Zeile = Mail.MailCount.5 
		CALL UMLAUTE
                CALL UNDERTOSPACE
                say '      <td align=left><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?GETMAIL?' || MailPathName || '>' || Zeile || '</A></td>'
                Zeile = Mail.MailCount.8 
		CALL UMLAUTE
                say '      <td align=left><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?GETMAIL?' || MailPathName || '>' || Zeile || '</A></td>'
                Zeile = Mail.MailCount.6 
		CALL UMLAUTE
                say '      <td align=left><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?GETMAIL?' || MailPathName || '>' || Zeile || '</A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?GETMAIL?' || MailPathName || '>' || Mail.MailCount.3 || ' ' || Mail.MailCount.4  || '</A></td>'
                say '   </tr>'
                if Globals.!Log='YES' then do
			CALL LINEOUT Globals.!LOGFile,'->   Mail.' || MailCount ||'            = ' || Mail.MailCount.1 || ' | ' || Mail.MailCount.2 || ' | ' || Mail.MailCount.3 || ' | ' || Mail.MailCount.4 || ' | ' || Mail.MailCount.5 || ' | ' || Mail.MailCount.6 || ' | ' || Mail.MailCount.7 || ' | ' || Mail.MailCount.8 || ' | ' || Mail.MailCount.9 || ' | ' || '.'  || ' | ' || Mail.MailCount.11 || ' | ' 
                end
	END

	say '</table>'
        /* Unterschrift erstellen */
        say '<hr size=1 noshade>'
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Abmelden </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Anzeige aller Accounts</A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || CommandLink || Option1Link || '> Anzeige der Ordner von ' || accountnametranslate1 || '</A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Hilfe </a></td>'
        end
        if Globals.!Lang='EN' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Logout </A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Show Accounts</A></td>'
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || CommandLink || Option1Link || '> Show Folders from ' || accountnametranslate1 || '</A></td>'
                say '      <td align=center><a href="javascript:help_page()"> Help </a></td>'
        end
        say '   </tr>'
        say '</table>'
        say '<hr size=1 noshade>'
        say '<Font face="verdana,arial"; Size="-2">'||Globals.!myinfo || ' ' ||  ' </Font>'
        if Globals.!Lang='GE' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB> Peter@warp-ecs-owl.de</A> Erstellt in 'Format(Time('E'),,2)' Sekunden.</Font><BR>'
        if Globals.!Lang='EN' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB> Peter@warp-ecs-owl.de</A> Generated in 'Format(Time('E'),,2)' seconds.</Font><BR>'
        say '<BR>'
        say '<!-- End GETGROUP //-->'
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> End GETGROUP'
RETURN

/* ================================================================== */
/* Anzeigen der Email                                                 */
/* ================================================================== */
GETMAIL:
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Start GETMAIL'
        say '<!-- Start GETMAIL //-->'
        call BEEP 900,100
        /* öberschrift erstellen */
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Abmelden </A></td>'
                say '      <td align=center><A Href="javascript:history.back()"> Zur&uuml;ck zur Mailliste </A></td>'
                say '      <td align=center><A Href= "javascript:window.print()">Mail drucken</A></td>'
        end
        if Globals.!Lang='EN' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Logout </A></td>'
                say '      <td align=center><A Href="javascript:history.back()"> Back to Maillist </A></td>'
                say '      <td align=center><A Href= "javascript:window.print()">Print mail</A></td>'
        end
        say '   </tr>'
        say '</table>'
        say '<hr size=1 noshade>'
        emailname = ''
        Dateiname = REPLACESlash(Option1)
        SchreibenZeile=0
        say '<table align=center width=100% border="2" cellspacing="2" cellpadding="2">'
        say '   <tr bgcolor="'||Globals.!HtmlTableColor||'">'
        say '      <td>'

       /* Lesen der Mail, ab jetzt wird die Mail im Speicher gehalten */
        DO Line=1 by 1 while LINES(Dateiname)
                Mail.Line=LINEIN(Dateiname)
        END
        /*LÑnge der Mail*/
        maillength=Line-1

        /* Die Mail bearbeiten */
        xerg=0
        headerength=0
        SchreibenAkt=1
        ZeileSubjekt=''
        ZeileFrom=''
        ZeileDATE=''
        ZeileOld=''
        ZeileDATERECEIVED=''
        /* Header bearbeiten*/
        DO Line=1 to maillength
                Zeile=Mail.Line
                ZeileUPPER=TRANSLATE(Zeile,tabout,taborg)
                /*Wenn =?ISO-8859-1?B? in Zeile dann BASE64*/
                if pos('=?ISO-8859-1?B?',ZeileUPPER,1) > 0 then do
                        ZeileBASE64=SUBSTR(Zeile,pos('=?ISO-8859-1?B?',ZeileUPPER,1)+15,LENGTH(Zeile)-pos('=?ISO-8859-1?B?',ZeileUPPER,1)-15+1-2)
                        ZeileAnfang=SUBSTR(Zeile,1,pos('=?ISO-8859-1?B?',ZeileUPPER,1)-1)
                        Line = Line + 1
                        Zeile=Mail.Line
                        /* Alles in Uppercase*/
                        ZeileUPPER=TRANSLATE(Zeile,tabout,taborg)
                        DO while pos('=?ISO-8859-1?B?',ZeileUPPER,1) > 0
                                ZeileBASE64=ZeileBASE64 || SUBSTR(Zeile,pos('=?ISO-8859-1?B?',ZeileUPPER,1)+15,LENGTH(Zeile)-pos('=?ISO-8859-1?B?',ZeileUPPER,1)-15+1-2)
                                Line = Line + 1
                                Zeile=Mail.Line
                                /* Alles in Uppercase*/
                                ZeileUPPER=TRANSLATE(Zeile,tabout,taborg)
                        end
                        /*Umwandeln*/
                        output_file_name='Base64.txt'
                        erg=SysFileDelete(output_file_name)
                        CALL LINEOUT output_file_name,ZeileBASE64
                        erg=STREAM(output_file_name, 'C', "CLOSE")
                        CALL Base64
                        input_file_name='ASCII.TXT'
                        ZeileASCII=LINEIN(input_file_name)
                        erg=STREAM(input_file_name, 'C', "CLOSE")
                        /*und die Zeile wieder zusammenbauen*/
                        Zeile=ZeileAnfang || ZeileASCII
                        ZeileUPPER=TRANSLATE(Zeile,tabout,taborg)
                        Line=Line-1
                end
                /*Wenn ein Subjekt,... angegeben wurde, dieses anzeigen*/
                if SchreibenZeile=0 then do
                        if pos('SUBJECT:',ZeileUPPER,1) = 1 then do
                               if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Mailline (' || Line || ') : ' || Zeile
                               /* öberschrift erstellen */
                               /* Umlaute und Sonderzeichen ersetzen, */
                               CALL HTML
                               CALL UMLAUTE
                               ZeileSubjekt=  '         '|| Zeile || '<BR>'
                               xerg=xerg+1
                               end
                        if pos('FROM:',ZeileUPPER,1) = 1 then do
                                /* öberschrift erstellen */
                               if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Mailline (' || Line || ') : ' || Zeile
                                /* Umlaute und Sonderzeichen ersetzen, */
                                CALL HTML
                                CALL UMLAUTE
                                ZeileFrom='         '|| Zeile || '<BR>'
                                xerg=xerg+1
                        end
                        if pos('DATE:',ZeileUPPER,1) = 1 then do
                               if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Mailline (' || Line || ') : ' || Zeile
                                /* öberschrift erstellen */
                                /* Umlaute und Sonderzeichen ersetzen, */
                                CALL HTML
                                CALL UMLAUTE
                                ZeileDATE='         '|| Zeile || '<BR>'
                                xerg=xerg+1
                        end
                        /*Mails mit Text*/
                        if pos('CONTENT-TYPE: TEXT/PLAIN',ZeileUPPER,1) = 1 then do
                               if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Mailline (' || Line || ') : ' || Zeile
                                SchreibenAkt=1
                                xerg=xerg+1
                        end

                        /*Mails mit html*/
                        if pos('CONTENT-TYPE: TEXT/HTML',ZeileUPPER,1) = 1 then do
                                SchreibenAkt=2
                                xerg=xerg+1
                        end

                        if pos('X-DATERECEIVED:',ZeileUPPER,1) = 1 then do
                                ZeileDATERECEIVED=  '         '||Zeile || '<BR>'
                                xerg=xerg+1
                        end

                        /*Mails mit n Teilen*/
                        if pos('CONTENT-TYPE: MULTIPART',ZeileUPPER,1) = 1 then do
                                SchreibenZeile=0
                                if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> CONTENT-TYPE: MULTIPART '
                        end 
                        /*Ab jetzt den Trenner suchen*/
                        if SchreibenZeile=0 then do
                        	if LENGTH(Zeile) \=0 then do
                                	/* und jetzt auswerten */
                                        if pos('BOUNDARY',ZeileUPPER,1) > 0 then do
                                	      Globals.!BOUNDARY = SUBSTR(Zeile,pos('BOUNDARY',ZeileUPPER,1)+10,LENGTH(Zeile)-pos('BOUNDARY',ZeileUPPER,1)-10)   
                                              SchreibenZeile=999
					      xerg=5	
                                              if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> MULTIPART BOUNDARY  :' || Globals.!BOUNDARY 
                                        end 
                                end     
                        end
                        
                        if length(Zeile)=0 then do
                           if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Mailline (' || Line || ') : ' || Zeile
                           xerg=5
                        end

                        if xerg = 5 then do
                                say ZeileSubjekt
                                say ZeileFrom
                                say ZeileDATE
                                say ZeileDATERECEIVED
                                say '         <hr size=3>'
                                xerg=0
                                /*Der Text der Mail beginnt immer nach diesen EintrÑgen*/
                                SchreibenZeile=SchreibenAkt
                                headerength=line+1
                                say '         <font face="verdana,arial" >'
                                Zeile=''
                        end
                end
        end

        /*Nachricht beareiten*/
        DO Line=headerength to maillength
                Zeile=Mail.Line
                /*Bonderys nicht anzeigen*/
                if pos(Globals.!BOUNDARY,Zeile,1) > 0 then do
			Line=Line+1
			BOUNDARYFound=1
			Zeile=Mail.Line
                end
                ZeileUPPER=TRANSLATE(Zeile,tabout,taborg)
                /*Nur wenn in der Mail umgeschaltet wird*/
                        /*Mails mit Text*/
                        if pos('CONTENT-TYPE: TEXT/PLAIN',ZeileUPPER,1) = 1 then do
                                SchreibenZeile=1
                                if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> CONTENT-TYPE: TEXT/PLAIN '
                        end 
                        /*Mails mit html*/
                        if pos('CONTENT-TYPE: TEXT/HTML',ZeileUPPER,1) = 1 then do
                                SchreibenZeile=999
                                /* Einstellungen des Users beachten */
                                if Globals.!Show_HTML='YES' then
                                        SchreibenZeile=2
                                if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> CONTENT-TYPE: TEXT/HTML '
                        end
                        /*Mails mit AnhÑngen APPLICATION*/
                        if pos('CONTENT-TYPE: APPLICATION',ZeileUPPER,1) = 1 then do
                                SchreibenZeile=3
				FirstSchreibenZeile=1
                                if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> CONTENT-TYPE: APPLICATION '
                        end
                        /*Mails mit AnhÑngen VIDEO*/
                        if pos('CONTENT-TYPE: VIDEO',ZeileUPPER,1) = 1 then do
                                SchreibenZeile=3
				FirstSchreibenZeile=1
                                if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> CONTENT-TYPE: VIDEO '
                        end


                /*Ab jetzt den Text-Teil anzeigen*/
                if SchreibenZeile=1 then do
                        if LENGTH(Zeile) \=0 then do
                                /* Umlaute und Sonderzeichen ersetzen, */
                                CALL HTML
                                CALL UMLAUTE
                                /* und jetzt ausgeben */
                                if undnocheine=0 then
                                        ZeileOld=''
                                if LASTPOS("=",Zeile) = LENGTH(Zeile) then do
                                        Zeile=SUBSTR(Zeile,1,LENGTH(Zeile)-1)
                                        if LASTPOS("=",Zeile) = LENGTH(Zeile) then do
                                                Zeile=Zeile||'='||'<BR>'
                                                undnocheine=0
                                        end
                                        if LASTPOS("=",Zeile) \= LENGTH(Zeile) then
                                                Zeile=ZeileOld || Zeile
                                                ZeileOld=Zeile
                                                undnocheine=1
                                        end
                                else
                                        undnocheine=0

                                if undnocheine=0 then do
                                        Zeile=ZeileOld || Zeile
                                        ZeileUpper=TRANSLATE(Zeile,tabout,taborg)
                                        posHTTPa = pos("HTTP",ZeileUpper,1)
                                        if posHTTPa \= 0 then do
                                           HTTPeChar= " "
                                           if posHTTPa > 1 then
                                              HTTPeChar=SUBSTR(Zeile,posHTTPa-1,1)
                                           if HTTPeChar="(" then
                                              HTTPeChar=")"
                                           if HTTPeChar="<" then
                                              HTTPeChar=">"
                                           posHTTPe = pos(HTTPeChar,Zeile,posHTTPa+1)
                                           if posHTTPe = 0 then
                                              posHTTPe = LENGTH(Zeile)+1
                                           Zeile=SUBSTR(Zeile,1,posHTTPa-1)||'<A Href='||SUBSTR(Zeile,posHTTPa,posHTTPe-posHTTPa)||'>'||SUBSTR(Zeile,posHTTPa,posHTTPe-posHTTPa)||'</A>'||SUBSTR(Zeile,posHTTPe,length(Zeile)-posHTTPe+1)
                                        end
                                        if posHTTPa = 0 then do
                                           posHTTPa = pos("WWW.",ZeileUpper,1)
                                           if posHTTPa \= 0 then do
                                              HTTPeChar= " "
                                              if posHTTPa > 1 then
                                                 HTTPeChar=SUBSTR(Zeile,posHTTPa-1,1)
                                              if HTTPeChar="(" then
                                                 HTTPeChar=")"
                                              if HTTPeChar="<" then
                                                 HTTPeChar=">"
                                              posHTTPe = pos(HTTPeChar,Zeile,posHTTPa+1)
                                              if posHTTPe = 0 then
                                                 posHTTPe = LENGTH(Zeile)+1
                                              Zeile=SUBSTR(Zeile,1,posHTTPa-1)||'<A Href=HTTP://'||SUBSTR(Zeile,posHTTPa,posHTTPe-posHTTPa)||'>'||SUBSTR(Zeile,posHTTPa,posHTTPe-posHTTPa)||'</A>'||SUBSTR(Zeile,posHTTPe,length(Zeile)-posHTTPe+1)
                                           end
                                        end
                                       say  '             ' || Zeile || '<BR>'
                                end
                        end
                        if LENGTH(Zeile) = 0 then do
                                say '             ' || Zeile || '<BR>'
                                undnocheine=0
                        end
                end

                /*Ab jetzt den html-Teil anzeigen*/
                if SchreibenZeile=2 then do
                        /* Umlaute und Sonderzeichen ersetzen, */
                        CALL UMLAUTE
                        if LENGTH(Zeile) \=0 then do
                                if lastpos('=', Zeile)=LENGTH(Zeile) then
                                        Zeile=SUBSTR(Zeile,1,LENGTH(Zeile)-1)
                                end
                        say Zeile
                        nop
                end

                /*Ab jetzt den Anhangteil bearbeiten*/
                if SchreibenZeile=3 then do
			/*Kopf es Anhangs suchen*/
			if FirstSchreibenZeile=1 then do
				FirstSchreibenZeile=0
                                BOUNDARYFound=0
	                	if pos('NAME=',ZeileUpper,1) > 0 then do
					FileNameAttachment=SUBSTR(Zeile,pos('NAME=',ZeileUpper,1)+6,LENGTH(Zeile)-pos('NAME=',ZeileUpper,1)-6)
                                	if Globals.!Log='YES' then do
					        if ersterdurchlauf=0 then CALL LINEOUT Globals.!LOGFile,'->                End : ' || Line - 2
                                        	CALL LINEOUT Globals.!LOGFile,'-> FileNameAttachment : ' || FileNameAttachment
                                                CALL LINEOUT Globals.!LOGFile,'->              Start : ' || Line + 4
                                        end
                                	say '             Attachment : ' || FileNameAttachment || '<BR>'
                		        ersterdurchlauf=0
                                end
			
			end
			/*Rest bearbeiten*/
                        if BOUNDARYFound=1 then do
                        	if Globals.!Log='YES' then do
                                	CALL LINEOUT Globals.!LOGFile,'->                End : ' || Line - 2
                                end
                        end
                end
        end
        say '         </font>'
        say '      </td>'
        say '   </tr>'
        say '</table>'
        /* Unterschrift erstellen */
        say '<hr size=1 noshade>'
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Abmelden </A></td>'
                say '      <td align=center><A Href="javascript:history.back()"> Zur&uuml;ck zur Mailliste </A></td>'
                say '      <td align=center><A Href= "javascript:window.print()">Mail drucken</A></td>'
        end
        if Globals.!Lang='EN' then do
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '> Logout </A></td>'
                say '      <td align=center><A Href="javascript:history.back()"> Back to Maillist </A></td>'
                say '      <td align=center><A Href= "javascript:window.print()">Print mail</A></td>'
        end
        say '   </tr>'
        say '</table>'
        say '<hr size=1 noshade>'
        say '<Font face="verdana,arial"; Size="-2">'||Globals.!myinfo ||  ' </Font>'
        if Globals.!Lang='GE' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWeb> Peter@warp-ecs-owl.de</A> Erstellt in 'Format(Time('E'),,2)' Sekunden.</Font><BR>'
        if Globals.!Lang='EN' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWeb> Peter@warp-ecs-owl.de</A> Generated in 'Format(Time('E'),,2)' seconds.</Font><BR>'
        call BEEP 900,100
        say '<!-- End GETMAIL //-->'
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> End GETMAIL'

/*say '</body></html>'
say ''*/
return

	
/* ================================================================== */
/* Edit Configuration                                                 */
/* ================================================================== */
CONFIG:
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Start CONFIG'
        /* öberschrift erstellen */
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Verlassen der Konfiguration</A></td>'
        if Globals.!Lang='EN' then
                say '      <td align=center><A Href=' || Globals.!CGI_BIN || Globals.!File || '?' || ID || '?READACCOUNT?' || '> Exit  Configuration</A></td>'
        say '   </tr>'
        say '</table>'
        say '<hr size=1 noshade>'
        say '<br>'
        if Globals.!Lang='GE' then DO
                say '<p>'
                say '   <center><font size=2>Achtung! Keine Umlaute in Datei- oder Verzeichnissnamen verwenden !</font></center>'
                say '<p>'
                say '<table align=center cellpadding=3 cellspacing=0 border=1>'
                say '<tr><td>Option</td><td>Wert</td></tr>'
        END
        if Globals.!Lang='EN' then DO
                say '<p>'
                say '   <center><font size=2>Attention! Dont use german umlaut in file or directory names at time !</font></center>'
                say '<p>'
                say '<table align=center cellpadding=3 cellspacing=0 border=1>'
                say '<tr><td>Option</td><td>Value</td></tr>'
        END

        /*Path to PMMail                       */
        say '<tr bgcolor=white> <form action="' || Globals.!CGI_BIN||Globals.!CONFIGFile||'" method="post" autocomplete="off">'
        say '   <td>&#160;Path to PMMail</td>'
        say '   <td><input type=text name="PMMailPath" value='||Globals.!PMMailPath||' size=60></td>'
        say '   <td><input type=submit value="Set"></td>'
        say '</form> </tr>'

        /*Path to MailData from PMMail         */
        say '<tr bgcolor=white> <form action="' || Globals.!CGI_BIN||Globals.!CONFIGFile||'" method="post" autocomplete="off">'
        say '   <td>&#160;Path to MailData</td>'
        say '   <td><input type=text name="MailDataPath" value='||Globals.!MailDataPath||' size=60></td>'
        say '   <td><input type=submit value="Set"></td>'
        say '</form> </tr>'

        /*Table Color                          */
        say '<tr bgcolor=white> <form action="' || Globals.!CGI_BIN||Globals.!CONFIGFile||'" method="post" autocomplete="off">'
        say '   <td>&#160;Table Color</td>'
        say '   <td><input type=text name="HtmlTableColor" value='||Globals.!HtmlTableColor||' size=60></td>'
        say '   <td><input type=submit value="Set"></td>'
        say '</form> </tr>'

        /*Max Mails                            */
        say '<tr bgcolor=white> <form action="' || Globals.!CGI_BIN||Globals.!CONFIGFile||'" method="post" autocomplete="off">'
        say '   <td>&#160;Max Mails</td>'
        say '   <td><input type=text name="Emailmax" value='||Globals.!Emailmax||' size=60></td>'
        say '   <td><input type=submit value="Set"></td>'
        say '</form> </tr>'

        /*Text and HTML                        */
        say '<tr bgcolor=white> <form action="' || Globals.!CGI_BIN||Globals.!CONFIGFile||'" method="post" autocomplete="off">'
        say '   <td>&#160;Show HTML YES-NO</td>'
        say '   <td><input type=text name="Show_HTML" value='||Globals.!Show_HTML||' size=60></td>'
        say '   <td><input type=submit value="Set"></td>'
        say '</form> </tr>'

        /*Language Support                     */
        say '<tr bgcolor=white> <form action="' || Globals.!CGI_BIN||Globals.!CONFIGFile||'" method="post" autocomplete="off">'
        say '   <td>&#160;Language GE-EN</td>'
        say '   <td><input type=text name="Lang" value='||Globals.!Lang||' size=60></td>'
        say '   <td><input type=submit value="Set"></td>'
        say '</form> </tr>'

        /*Log of Work                          */
        say '<tr bgcolor=white> <form action="' || Globals.!CGI_BIN||Globals.!CONFIGFile||'" method="post" autocomplete="off">'
        say '   <td>&#160;Debug YES-NO</td>'
        say '   <td><input type=text name="Log" value='||Globals.!Log||' size=60></td>'
        say '   <td><input type=submit value="Set"></td>'
        say '</form> </tr>'

        say '</table>'
        say '<hr size=1 noshade>'
        say '<br>'
        say '<Font face="verdana,arial"; Size="-2">'||Globals.!myinfo || ' ' ||  ' </Font>'
        if Globals.!Lang='GE' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB> Peter@warp-ecs-owl.de</A> Erstellt in 'Format(Time('E'),,2)' Sekunden.</Font><BR>'
        if Globals.!Lang='EN' then
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB> Peter@warp-ecs-owl.de</A> Generated in 'Format(Time('E'),,2)' seconds.</Font><BR>'
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> End CONFIG'
RETURN

/* ================================================================== */
/* Help bearbeiten                                                    */
/* ================================================================== */
HELP:
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> Start HELP'
        /* öberschrift erstellen */
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then do
                say '      <td align=center><a href="javascript: self.close()"> Verlassen der Hilfe </A></td>'
                say '   </tr>'
                say '</table>'
                say '<hr size=1 noshade>'
                say '   <font face="verdana,arial" SIZE=+2><b>Hilfe f&uuml;r PMMailWEB <br></b></font>'
                say '   <font face="verdana,arial"'
                say '<br>'
                say 'PMMailWEB ist ein CGI-Webfrontend f&uuml;r den  PMMail - Mailclient.<br>'
                say 'Mit PMMailWEB k&ouml;nnen Sie alle E-mails des PMMail - Mailclient lesen.<br>'
                say '<br>'
                say '<b>Installation:</b> <br>'
                say '<p style="text-indent:0.5cm;">- PMMailWEBXXX.ZIP einem Temp - Verzeichniss entpacken.</p>'
                say '<p style="text-indent:0.5cm;">- PMMailWEB.EXE, PBWCONFIG.EXE and PMMailWEB.CFG in das cgi-bin Verzeichniss kopieren.</p>'
                say '<p style="text-indent:0.5cm;">- PMMailWEB.CFG im cgi-bin Verzeichniss editieren.</p>'
                say '<br>'
                say '<b>Programmstart:</b> <br>'
                say '<p style="text-indent:0.5cm;">- PMMailWEB mit http://&lt;server&gt;/cgi-bin/PMMailWEB.EXE starten.</p>'
                say '<br>'
                say '<hr size=1 noshade>'
                say '<br>'
                say '<b>BEDIENUNG:</b> <br>'
                say '<br>'
                say '<b>Liste aller Accounts</b><br>'
                say '<p">Hier wird die Liste aller Accounts angezeigt. Der Inhalt des Accounts wird nach Auswahl des gew&uuml;nschten Eintrages angezeigt.</p>'
                say '<br>'
                say '<b>Liste aller Ordner / Mails im Account</b><br>'
                say '<p>Hier wird die Liste aller Ordner / Mails im gew&auml;hlten Account angezeigt. Der Inhalt der Ordner / Mails wird nach Auswahl des gew&uuml;nschten Eintrages angezeigt.</p>'
                say '<p>Ein (@) zeigt an, das sich "Neue E-Mails" in dieser Gruppe befinden. "Neue E-Mails" = E-Mails die Heute empfangen wurden.</p>'
                say '<br>'
                say '<b>Liste der letzten XX Emails im Account</b><br>'
                say '<p>Hier wird die Liste der letzten XX E-Mails in der Gruppe angezeigt. Die E-Mal wird nach Auswahl des gew&uuml;nschten Eintrages angezeigt.</p>'
                say '<p>Die neuste E-Mail befindet sich immer am Anfang der Liste.</p>'
                say '<p>Die Maximale-L&auml;nge der Liste XX=(Anzahl der Eintr&auml;ge), wird durch die Angabe der Listenl&auml;nge in der Konfigurationsdatei PMMailWEB.CFG im cgi-bin Verzeichniss bestimmt. Siehe hier Email_Max</p>'
                say '<p>Ein (@) zeigt an, das sich um "Neue E-Mails" in dieser Gruppe handelt. "Neue E-Mails" = E-Mails die Heute empfangen wurden.</p>'
                say '<br>'
                say '<hr size=1 noshade>'
                say '<br>'
                say '<b>Die Testumgebung </b><br>'
        end
        if Globals.!Lang='EN' then do
                say '      <td align=center><a href="javascript: self.close()"> Exit Help </A></td>'
                say '   </tr>'
                say '</table>'
                say '<hr size=1 noshade>'
                say '   <font face="verdana,arial" SIZE=+2><b>Help for PMMailWEB <br></b></font>'
                say '   <font face="verdana,arial"'
                say '<br>'
                say 'PMMailWEB is a cgi web frontend for the Email software PMMail.<br>'
                say 'With PMMailWEB can you see, read all Emails from PMMail.<br>'
                say '<br>'
                say '<b>OPERATION:</b><br>'
                say '<br>'
                say '<b>List of all accounts</b><br>'
                say '<p>Here is the list of all accounts will be displayed. The contents of the account appears after selecting the desired entry.</p>'
                say '<br>'
                say '<B>List of all folders / mails in the account</b><br>'
                say '<p>Here is the list of all folders / mails in the selected account is displayed. The contents of the folders / messages will appear after selecting the desired entry.</p>'
                say '<p>A (@) indicates that there are "new mail" in this group. "New e-mails" = E-mails that were received today.</p>'
                say '<br>'
                say '<b>List of recent emails in the account XX</b><br>'
                say '<p>Here is the list of the last XX e-mail is displayed in the group. The E-time is displayed after selecting the desired entry.</p>'
                say '<p>The latest e-mail is always at the top of the list.</p>'
                say '<p>The maximum length of the list-XX = (number of entries), is defined by specifying the list length in the configuration file in the cgi-bin PMMailWEB.CFG specific directories. See here Email_Max</p>'
                say '<p>A (@) indicates that these are "new mail" in this group. "New e-mails" = E-mails that were received today. </p>'
                say '<br>'
                say '<hr size=1 noshade>'
                say '<br>'
                say '<b>Installation:</b> <br>'
                say '<p style="text-indent:0.5cm;">- Unpack PMMailWEBXXX.ZIP to a Temp - Directory.</p>'
                say '<p style="text-indent:0.5cm;">- Copy PMMailWEB.EXE, PBWCONFIG.EXE and PMMailWEB.CFG to the cgi-bin Directory.</p>'
                say '<p style="text-indent:0.5cm;">- Edit PMMailWEB.CFG in the cgi-bin Directory.</p>'
                say '<br>'
                say '<b>Run the Program:</b> <br>'
                say '<p style="text-indent:0.5cm;">- To start PMMailWEB type http://&lt;server&gt;/cgi-bin/PMMailWEB.EXE.</p>'
                say '<br>'
                say '<hr size=1 noshade>'
                say '<b>Tested with </b><br>'
        end
        say '<br>'
        say '<b>SYSTEM SOFTWARE:</b> <br>'
        say '<p style="text-indent:0.5cm;">eComstation V1.25             www.ecomstation.com www.ecomstation.de</p>'
        say '<p style="text-indent:0.5cm;">eComstation V2.0              www.ecomstation.com www.ecomstation.de</p>'
        say '<p style="text-indent:0.5cm;">PMMail V3.10.04                               os2voice.org          </p>'
        say '<p style="text-indent:0.5cm;">Apache V1.3.42                               www.apache.org         </p>'
        say '<p style="text-indent:0.5cm;">WEB/2 V1.3x                                                         </p>'
        say '<b>BROWSER:</b> <br>'
        say '<p style="text-indent:0.5cm;">Arora 0.11.0       on eComstation </p>'
        say '<p style="text-indent:0.5cm;">Netscape 4.61      on eComstation </p>'
        say '<p style="text-indent:0.5cm;">Firefox 3.X 4.X    on eComstation and Windows </p>'
        say '<p style="text-indent:0.5cm;">Google Chrome      on Windows </p>'
        say '<br>'
        say '<br>'
        say '   </font>'
        say '<hr size=1 noshade>'
        /* Unterschrift erstellen */
        say '<table align=center width=100% border="6" cellspacing="5" cellpadding="5">'
        say '   <tr>'
        if Globals.!Lang='GE' then do
                say '      <td align=center><a href="javascript: self.close()"> Verlassen der Hilfe </A></td>'
                say '   </tr>'
                say '</table>'
                say '<Font face="verdana,arial"; Size="-2">'||Globals.!myinfo || '  ' ||  ' </Font>'
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB> Peter@warp-ecs-owl.de</A> Erstellt in 'Format(Time('E'),,2)' Sekunden.</Font><BR>'
        end
        if Globals.!Lang='EN' then do
                say '      <td align=center><a href="javascript: self.close()"> Exit Help </A></td>'
                say '   </tr>'
                say '</table>'
                say '<Font face="verdana,arial"; Size="-2">'||Globals.!myinfo || ' ' ||  ' </Font>'
                say '<Font face="verdana,arial"; Size="-2"> <A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWEB> Peter@warp-ecs-owl.de</A> Generated in 'Format(Time('E'),,2)' seconds.</Font><BR>'
        end
        if Globals.!Log='YES' then CALL LINEOUT Globals.!LOGFile,'-> End HELP'
RETURN

/***************************************************/
/*Function to create the BookCSV File              */
/***************************************************/

MakeBookCSV:
    PARSE ARG InDirectory OutDirectory
    IF InDirectory \= "" & LASTPOS('\', InDirectory) \= LENGTH(InDirectory) THEN
        InDirectory = InDirectory'\'
    IF OutDirectory \= "" & LASTPOS('\', OutDirectory) \= LENGTH(OutDirectory) THEN
        OutDirectory = OutDirectory'\'

    /* Write HTML - Head                             */
    CALL HTMLHead

    /* Read the books database, create output files. */

    DataFile = InDirectory"BOOKS.DB"

    DO WHILE lines(DataFile) = 1
        PARSE VALUE linein(DataFile) WITH BookName 'ﬁ' . 'ﬁ' . 'ﬁ' BookNumber 'ﬁ'
        CALL MakeFileName BookNumber BookName
        SAY BookNumber'. 'BookName
    END

    /* Now read the address database. */

    DataFile = InDirectory"ADDR.DB"
    DO WHILE lines(DataFile) = 1

        /* PMMail (v1.96...) ADDR.DB format */

        PARSE VALUE linein(DataFile) WITH,
        EMail 'ﬁ' Alias 'ﬁ' Name 'ﬁ' Popup 'ﬁ' Company 'ﬁ' Title 'ﬁ',
        H_Street 'ﬁ' H_Building 'ﬁ' H_City 'ﬁ' H_State 'ﬁ' H_Code 'ﬁ',
        H_Phone 'ﬁ' H_Ext 'ﬁ' H_Fax 'ﬁ',
        B_Street 'ﬁ' B_Building 'ﬁ' B_City 'ﬁ'B_State 'ﬁ' B_Code 'ﬁ',
        B_Phone 'ﬁ' B_Ext 'ﬁ' B_Fax 'ﬁ',
        Notes 'ﬁ' BookNumber 'ﬁ' H_Country 'ﬁ' B_Country 'ﬁ'

        /* Split the name into components FirstName, LastName. */

        comma = 1
        k = LastPos( ',', Name )
        IF k = 0 THEN DO
            k = LastPos( ' ', Name )
            comma = 0
        END

        IF k = 0 THEN DO
            FirstName = STRIP(Name)
            LastName = ""
        END
        ELSE DO
            FirstName = STRIP(LEFT(Name, k-1))
            LastName = STRIP(SUBSTR(Name, k+1))
        END

        IF comma > 0 THEN DO
            temp = FirstName
            FirstName = LastName
            LastName = temp
        END

        /* Some fields might contain commas. */

        LastName = CommaCheck(LastName)
        Name = CommaCheck(Name)
        Alias = CommaCheck(Alias)
        H_Street = CommaCheck(H_Street)
        H_Building = CommaCheck(H_Building)
        H_City = CommaCheck(H_City)
        H_State = CommaCheck(H_State)
        H_Country = CommaCheck(H_Country)
        B_Street = CommaCheck(B_Street)
        B_Building = CommaCheck(B_Building)
        B_City = CommaCheck(B_City)
        B_State = CommaCheck(B_State)
        B_Country = CommaCheck(B_Country)
        Title = CommaCheck(Title)
        Company = CommaCheck(Company)
        Notes = CommaCheck(Notes)

        /* Thunderbird CSV format. */

        result = FirstName','LastName','Name','Alias',',
                 EMail',,'B_Phone' 'B_Ext','H_Phone' 'H_Ext','H_Fax'  'B_Fax',,,',
                 H_Street','H_Building','H_City','H_State','H_Code','H_Country',',
                 B_Street','B_Building','B_City','B_State','B_Code','B_Country',',
                 Title',,'Company',,,,,,,,,,'Notes

        result = TRANSLATE(result, '', '·')

        /* Special case to watch out for: a single entry can be in  */
        /* more than one address book.                              */

        DO WHILE pos(';', BookNumber) \= 0
            PARSE var BookNumber j ';' BookNumber
            ret = lineout( OutputFile.j, result )
        END /* DO */
        ret = lineout( OutputFile.BookNumber, result )

    END
RETURN

/***************************************************/
/*Procedure delete_ID                              */
/***************************************************/
delete_ID: PROCEDURE
	erg=STREAM(Globals.!IDFile, 'C', "QUERY EXISTS")
	if ret\="" then
		ret=SysFileDelete(Globals.!IDFile)
RETURN

/***************************************************/
/*Procedure write_ID                               */
/***************************************************/
write_ID: PROCEDURE
	erg=STREAM(Globals.!IDFile, 'C', "QUERY EXISTS")
	if ret\="" then
		ret=SysFileDelete(Globals.!IDFile)

	erg=STREAM(Globals.!IDFile, 'C', "OPEN")
	CALL LINEOUT Globals.!IDFile, ARG(1)
	erg=STREAM(Globals.!IDFile, 'C', "CLOSE")
RETURN

/***************************************************/
/*Procedure read_ID                                */
/***************************************************/
read_ID: PROCEDURE
	rID = 'LEER'
	erg=STREAM(Globals.!IDFile, 'C', "QUERY EXISTS")
	if ret\="" then do
	        erg=STREAM(Globals.!IDFile, 'C', "OPEN")
		rID = LINEIN(Globals.!IDFile)
	        erg=STREAM(Globals.!IDFile, 'C', "CLOSE")
	end
RETURN rID

/***************************************************/
/* Procedure to put quote marks around a string    */
/* if it contains a comma.                         */
/***************************************************/

CommaCheck: PROCEDURE
    PARSE ARG str
    k = POS( ',', str )
    IF k = 0 THEN RETURN str
    ELSE RETURN '"'||str||'"'


/***************************************************/
/* Function to create the name of an output file,  */
/* creating a backup if necessary.                 */
/***************************************************/

MakeFileName:
    PARSE ARG j BookName

    /* Watch out for characters that can't be part of a file    */
    /* name. To keep things simple I'm also translating spaces. */

    BookName = TRANSLATE(BookName, '__________', ' \/:*?"<>|')

    name = OutDirectory||BookName
    bakname = name'.bak'
    name = name'.csv'
    IF stream(name, 'c', 'query exists') \= "" THEN
        DO
            IF stream(bakname, 'c', 'query exists') \= "" THEN
                '@'del bakname
            '@'rename name bakname
        END
    OutputFile.j = name
    RETURN

/* ================================================================== */
/* =     If Error :(( then show                                     = */
/* ================================================================== */
ShowError:
        if Globals.!Log='YES' then do
                CALL LINEOUT Globals.!LOGFile,'Version......: ' || Globals.!ver
                CALL LINEOUT Globals.!LOGFile,'Linenumber...: ' || sigl
                CALL LINEOUT Globals.!LOGFile,'Linetext.....: ' || sourceline(sigl)
                CALL LINEOUT Globals.!LOGFile,'Errorcode....: ' || rc
                CALL LINEOUT Globals.!LOGFile,'Errortext....: ' || errortext(rc)
                CALL LINEOUT Globals.!LOGFile,'OS-Version...: ' || SysVersion()
                CALL LINEOUT Globals.!LOGFile,'Rexx-Version.: ' || SysUtilVersion()
                erg=STREAM(Globals.!LOGFile, 'C', "CLOSE")
        end
        say '<BR>'
        say '<hr size=1 noshade>'
        say '-Hoops-'
        if Globals.!Lang='GE' then
                say '<font color="#FF0000">Senden Sie diesen Fehlerreport und Email-Datei an :</font><BR>'
        if Globals.!Lang='EN' then
                say '<font color="#FF0000">Send this bug report and the Email-File to :</font><BR>'
        say '<A Href=mailto:Peter@warp-ecs-owl.de?subject=PMMailWeb Error> (Peter Lueersen) Peter@warp-ecs-owl.de</A><BR>'
        say 'Subject : PMMailWeb Error'
        say '<hr size=1 noshade>'
        say 'Version......: ' || Globals.!ver||'<BR>'
        say 'Linenumber...: ' || sigl||'<BR>'
        say 'Linetext.....: ' || sourceline(sigl)||'<BR>'
        say 'Errorcode....: ' || rc||'<BR>'
        say 'Errortext....: ' || errortext(rc)||'<BR>'
        say '<BR>'
        say 'OS-Version...: ' || SysVersion()||'<BR>'
        say 'Rexx-Version.: ' || SysUtilVersion() || '<BR>'
        say '<hr size=1 noshade>'
exit


/***************************************************/
/*Procedure readACCTINI                            */
/***************************************************/
readACCTINI:PROCEDURE
    PARSE ARG AcctDir
    filename = AcctDir'\ACCT.INI'
    /* Get the account name.  It is up to 256 characters long,  */
    /* followed by nulls, and starts 512 or 513 bytes from the  */
    /* start of the ACCT.INI file.                              */
    CALL STREAM AcctINI, 'C', 'OPEN'
    AcctName = CHARIN(filename, 513, 257)
    IF LEFT(AcctName, 1) = 'DE'X THEN AcctName = RIGHT(AcctName, 256)
    ELSE AcctName = LEFT(AcctName, 256)
    AcctName = STRIP(AcctName,,'00'X)
    CALL STREAM filename, 'C', 'CLOSE'
RETURN AcctName

/***************************************************/
/*Procedure readFOLDERINI                          */
/***************************************************/
readFOLDERINI:PROCEDURE
    PARSE ARG FolderDir
    FolderINI = FolderDir||'\Folder.INI'
    CALL STREAM FolderINI, 'C', 'OPEN'
    PARSE VALUE LINEIN(FolderINI) WITH name'ﬁ'.
    FolderName = STRIP(name,,'00'X)
    CALL STREAM FolderINI, 'C', 'CLOSE'
RETURN FolderName

/***************************************************/
/*Procedure readFOLDERBAG                          */
/***************************************************/
readFOLDERBAG:PROCEDURE
    PARSE ARG FolderDir
    count=1
    DataFile = FolderDir||'\Folder.BAG'
    CALL STREAM DataFile, 'C', 'OPEN'
    DO WHILE LINES(DataFile) = 1
	count=count+1
        /*                                Read         'ﬁ' Attachments  'ﬁ' Date         'ﬁ' Time         'ﬁ' Subject      'ﬁ'toE'ﬁ'toN'ﬁ' fromEmail    'ﬁ' fromName     'ﬁ' EmailFileName 'ﬁ' */                                  
        PARSE VALUE LINEIN(DataFile) WITH Mail.count.1 'ﬁ' Mail.count.2 'ﬁ' Mail.count.3 'ﬁ' Mail.count.4 'ﬁ' Mail.count.5 'ﬁ' . 'ﬁ' . 'ﬁ' Mail.count.8 'ﬁ' Mail.count.9 'ﬁ' Mail.count.10 'ﬁ'
    END
    CALL STREAM DataFile, 'C', 'CLOSE'
RETURN count

/***************************************************/
/*Procedure getEnv                                 */
/***************************************************/
getEnv:PROCEDURE
RETURN VALUE(ARG(1),, 'OS2ENVIRONMENT')

/***************************************************/
/*Procedure putEnv                                 */
/***************************************************/
putEnv:PROCEDURE
RETURN VALUE(ARG(1), ARG(2), 'OS2ENVIRONMENT')

/***************************************************/
/*Procedure STR12                                  */
/***************************************************/
STR12:
        posRepStr1=pos(STR2,STR1,1)
        do while posRepStr1\=0
                /* if posRepStr1\=0 then do */
		        foundChar=1
                        if STR3=='ˇ' then
                                STR1=SUBSTR(STR1,1,posRepStr1-1)|| ' ' || SUBSTR(STR1,posRepStr1+LENGTH(STR2),LENGTH(STR1)-posRepStr1-LENGTH(STR2)+1)
                        else do
                                if STR3=='' then
                                        STR1=SUBSTR(STR1,1,posRepStr1-1)||SUBSTR(STR1,posRepStr1+LENGTH(STR2),LENGTH(STR1)-posRepStr1-LENGTH(STR2)+1)
                                else
                                        STR1=SUBSTR(STR1,1,posRepStr1-1)||STR3||SUBSTR(STR1,posRepStr1+LENGTH(STR2),LENGTH(STR1)-posRepStr1-LENGTH(STR2)+1)
                        end
                /* end */
                posRepStr1=pos(STR2,STR1,1)
        end
return

/***************************************************/
/*Procedure STR123                                 */
/***************************************************/
STR123:
        posRepStr1=pos(STR2,STR1UPPER,1)
        do while posRepStr1\=0
                /*if posRepStr1\=0 then do */
		        foundChar=1
                        if STR3=='ˇ' then
                                STR1=SUBSTR(STR1,1,posRepStr1-1)|| ' ' || SUBSTR(STR1,posRepStr1+LENGTH(STR2),LENGTH(STR1)-posRepStr1-LENGTH(STR2)+1)
                        else do
                                if STR3=='' then
                                        STR1=SUBSTR(STR1,1,posRepStr1-1)||SUBSTR(STR1,posRepStr1+LENGTH(STR2),LENGTH(STR1)-posRepStr1-LENGTH(STR2)+1)
                                else
                                        STR1=SUBSTR(STR1,1,posRepStr1-1)||STR3||SUBSTR(STR1,posRepStr1+LENGTH(STR2),LENGTH(STR1)-posRepStr1-LENGTH(STR2)+1)
                        end
               /* end */
                STR1UPPER=TRANSLATE(STR1,tabout,taborg) 
                posRepStr1=pos(STR2,STR1UPPER,1)
        end
return

/* ================================================================== */
/* Unterstrich zu Leerzeichen im Subject wandeln                      */
/* ================================================================== */
UNDERTOSPACE:
         STR1=Zeile
         STR1UPPER=TRANSLATE(STR1,tabout,taborg)
         /* HTML eigene Zeichen */
         /* < */
         STR2='_'
         STR3=' '
         CALL STR12
         Zeile=STR1
return

/* ================================================================== */
/* HTML öbersetzungen in der Email bearbeiten                         */
/* ================================================================== */
HTML:
         STR1=Zeile
         STR1UPPER=TRANSLATE(STR1,tabout,taborg)
         /* HTML eigene Zeichen */
         /* < */
         STR2='<'
         STR3='&lt;'
         CALL STR12
         /* > */
         STR2='>'
         STR3='&gt;'
         CALL STR12
         /* " */
         STR2='"'
         STR3='&quot;'
         CALL STR12
         /*  */
         STR2='=26'
         STR3='&amp;'
         CALL STR12
         Zeile=STR1
         /*  */
         STR2='ISO-8859-1'
         STR3=''
         CALL STR123
         Zeile=STR1
         STR1UPPER=TRANSLATE(STR1,tabout,taborg)
return

/***************************************************/
/*Procedure REPLACEBackslash                       */
/***************************************************/
REPLACEBackslash:PROCEDURE
    PARSE ARG STR1
    STR1UPPER = STR1
    /* \ */
    STR2='\'
    STR3='/'
    CALL STR123
RETURN STR1

/***************************************************/
/*Procedure REPLACESlash                            */
/***************************************************/
REPLACESlash:PROCEDURE
    PARSE ARG STR1
    STR1UPPER = STR1
    /* =5C */
    STR2='/'
    STR3='\'
    CALL STR123
RETURN STR1

/* ================================================================== */
/* Decodes a Base64 file.                                             */
/*                                                                    */
/* Die Daten werden aus der Datei Base64.txt gelesen                  */
/* und in die Datei ASCII.TXT zurÅck geschrieben                      */
/* ================================================================== */
BASE64:
        char_set='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        DO Base64n=0 to 127
                t.Base64n=-1
        END
        DO Base64n=0 to 63
                Base64i=C2D(SUBSTR(char_set,Base64n+1,1))
                t.Base64i=Base64n
        END

        input_file_name='Base64.txt'
        output_file_name='ASCII.TXT'

        Base64i=SysFileDelete(output_file_name)
        input_line=''
        input_line_index=81
        input_eof=0
        DO WHILE (input_eof = 0)
                sextet_num=1
                num_bits=0
                DO WHILE(sextet_num <= 4)
                        DO WHILE((input_eof = 0) & (input_line_index > LENGTH(input_line)))
                                IF LINES(input_file_name) = 0 THEN
                                        input_eof=-1
                                ELSE
                                DO
                                        input_line=LINEIN(input_file_name)
                                        input_line_index=1
                                END
                        END
                        IF input_eof = 0 THEN
                        DO
                                Base64i=C2D(SUBSTR(input_line,input_line_index,1))
                                input_line_index=input_line_index+1
                                t1=t.Base64i
                                IF t1 >= 0 THEN
                                DO
                                        sextet.sextet_num=t1
                                        num_bits=num_bits+6
                                        sextet_num=sextet_num+1
                                END
                        END
                        ELSE
                        DO
                                sextet.sextet_num=0
                                sextet_num=sextet_num+1
                        END
                END
                IF num_bits >= 8 THEN
                DO
                        t1=sextet.1
                        t2=sextet.2
                        CALL CHAROUT output_file_name,D2C(4*t1+t2%16)
                        num_bits=num_bits-8
                END
                IF num_bits >= 8 THEN
                DO
                        t1=sextet.3
                        CALL CHAROUT output_file_name,D2C(16*(t2//16)+(t1%4))
                        num_bits=num_bits-8
                END
                IF num_bits >= 8 THEN
                DO
                        t2=sextet.4
                        CALL CHAROUT output_file_name,D2C(64*(t1//4)+t2)
                END
        END
        erg=STREAM(input_file_name, 'C', "CLOSE")
        erg=STREAM(output_file_name, 'C', "CLOSE")

return



/* ================================================================== */
/* Umlaute und Co in der Email bearbeiten (ISO-8859-1,...)            */
/* ================================================================== */
UMLAUTE:
	foundChar=1
        do while foundChar \= 0  
		foundChar = 0
		STR1=Zeile

          /* UTF-8 ????????? */ 
               	/* · */
                STR2='√ü'
       	        STR3='&szlig;'
               	CALL STR12
               	/* é */
                STR2='é'
       	        STR3='&Auml;'
               	CALL STR12
               	/* Ñ */
                STR2='Ñ'
       	        STR3='&auml;'
               	CALL STR12
               	/* Ñ */
                STR2='√§'
       	        STR3='&auml;'
               	CALL STR12
               	/* ô */
                STR2='ô'
       	        STR3='&Ouml;'
               	CALL STR12
               	/* î */
                STR2='î'
       	        STR3='&ouml;'
               	CALL STR12
               	/* î */
                STR2='√∂'
       	        STR3='&ouml;'
               	CALL STR12
               	/* Å */
                STR2='√º'
       	        STR3='&uuml;'
               	CALL STR12
               	/* ö */
                STR2='ö'
       	        STR3='&Uuml;'
               	CALL STR12
               	/* Å */
                STR2='Å'
       	        STR3='&uuml;'
               	CALL STR12

               	/* - */
                STR2='‚Äì'
       	        STR3='-'
               	CALL STR12
               	/* > */
                STR2='‚Ä∫'
       	        STR3='>'
               	CALL STR12

                STR1UPPER=TRANSLATE(STR1,tabout,taborg)

          /* UTF-8 ????????? */ 
           if LASTPOS("=C2=",STR1UPPER) > 0 then do
               	/* ı */
                STR2='=C2=A7'
       	        STR3='&sect;'
               	CALL STR123
               	/* Ô */
                STR2='=C2=B4'
       	        STR3='&acute;'
               	CALL STR123

           end
           /* UTF-8 ????????? */ 
           if LASTPOS("=C3=",STR1UPPER) > 0 then do
               	/* · */
                STR2='=C3=9F'
       	        STR3='&szlig;'
               	CALL STR123
               	/* é */
                STR2='=C3=84'
       	        STR3='&Auml;'
               	CALL STR123
               	/* Ñ */
                STR2='=C3=A4'
       	        STR3='&auml;'
               	CALL STR123
               	/* ô */
                STR2='=C3=96'
       	        STR3='&Ouml;'
               	CALL STR123
               	/* î */
                STR2='=C3=B6'
       	        STR3='&ouml;'
               	CALL STR123
               	/* Å */
                STR2='=C3=BC'
       	        STR3='&uuml;'
               	CALL STR123
               	/* ö */
                STR2='=C3=9C'
       	        STR3='&Uuml;'
               	CALL STR123
           end




           /* Umlaute und Sonderzeichen ersetzen, */
           if LASTPOS("=",STR1UPPER) > 0 then do
                if LASTPOS("=0",STR1UPPER) > 0 then do
                        /*  */
                        STR2='=09'
                        STR3='ˇ'
                        CALL STR123
	                /* RETURN2 */
        	        STR2='=0A'
                	STR3=''
                	CALL STR123
	                /* RETURN3 */
        	        STR2='=0D'
                	STR3='<BR>'
                	CALL STR123
		end
                if LASTPOS("=2",STR1UPPER) > 0 then do
                        /*  */
                        STR2='=20'
                        STR3='ˇ'
                        CALL STR123
                        /*  */
                        STR2='=21'
                        STR3='!'
                        CALL STR123
                        /*  */
                        STR2='=22'
                        STR3='&quot;'
                        CALL STR123
                        /*  */
                        STR2='=23'
                        STR3='#'
                        CALL STR123
                        /*  */
                        STR2='=24'
                        STR3='$'
                        CALL STR123
                        /*  */
                        STR2='=25'
                        STR3='%'
                        CALL STR123
                        /*  */
                        STR2='=26'
                        STR3='&'
                        CALL STR123
                        /*  */
                        STR2='=27'
                        STR3=' '
                        CALL STR123
                        /* ( */
                        STR2='=28'
                        STR3='('
                        CALL STR123
                        /* ) */
                        STR2='=29'
                        STR3=')'
                        CALL STR123
                        /*  */
                        STR2='=2A'
                        STR3='*'
                        CALL STR123
                        /*  */
                        STR2='=2B'
                        STR3='+'
                        CALL STR123
                        /*  */
                        STR2='=2C'
                        STR3=','
                        CALL STR123
                        /* - */
                        STR2='=2D'
                        STR3='-'
                        CALL STR123
                        /* . */
                        STR2='=2E'
                        STR3='.'
                        CALL STR123
                        /* / */
                        STR2='=2F'
                        STR3='/'
                        CALL STR123
                END
                if LASTPOS("=3",STR1UPPER) > 0 then do
                        /* : */
                        STR2='=30'
                        STR3='0'
                        CALL STR123
                        /* : */
                        STR2='=31'
                        STR3='1'
                        CALL STR123
                        /* : */
                        STR2='=32'
                        STR3='2'
                        CALL STR123
                        /* : */
                        STR2='=33'
                        STR3='3'
                        CALL STR123
                        /* : */
                        STR2='=34'
                        STR3='4'
                        CALL STR123
                        /* : */
                        STR2='=35'
                        STR3='5'
                        CALL STR123
                        /* : */
                        STR2='=36'
                        STR3='6'
                        CALL STR123
                        /* : */
                        STR2='=37'
                        STR3='7'
                        CALL STR123
                        /* : */
                        STR2='=38'
                        STR3='8'
                        CALL STR123
                        /* : */
                        STR2='=39'
                        STR3='9'
                        CALL STR123
                        /* : */
                        STR2='=3A'
                        STR3=':'
                        CALL STR123
                        /* : */
                        STR2='=3B'
                        STR3=';'
                        CALL STR123
                        /* : */
                        STR2='=3C'
                        STR3='&lt;'
                        CALL STR123
                        /* = */
                        STR2='=3D'
                        STR3='='
                        CALL STR123
                        /* : */
                        STR2='=3E'
                        STR3='&gt;'
                        CALL STR123
                        /* : */
                        STR2='=3F'
                        STR3='?'
                        CALL STR123
                end
                        /*  */
                        STR2='=40'
                        STR3='@'
                        CALL STR123
                if LASTPOS("=5",STR1UPPER) > 0 then do
                        /*  */
                        STR2='=5B'
                        STR3='['
                        CALL STR123
                        /*  */
                        STR2='=5C'
                        STR3='\'
                        CALL STR123
                        /*  */
                        STR2='=5D'
                        STR3=']'
                        CALL STR123
                        /*  */
                        STR2='=5E'
                        STR3='^'
                        CALL STR123
                        /*  */
                        STR2='=5F'
                        STR3='_'
                        CALL STR123
                END
                if LASTPOS("=6",STR1UPPER) > 0 then do
                        /*  */
                        STR2='=60'
                        STR3='`'
                        CALL STR123
                END
                if LASTPOS("=7",STR1UPPER) > 0 then do
                        /*  */
                        STR2='=7B'
                        STR3='{'
                        CALL STR123
                        /*  */
                        STR2='=7C'
                        STR3='|'
                        CALL STR123
                        /*  */
                        STR2='=7D'
                        STR3='}'
                        CALL STR123
                        /*  */
                        STR2='=7E'
                        STR3='~'
                        CALL STR123
                END
                if LASTPOS("=8",STR1UPPER) > 0 then do
	                /* ’ */
        	        STR2='=80'
                	STR3='&euro;'
	                CALL STR123
        	        /* Å */
                	STR2='=81'
	                STR3='&uuml;'
        	        CALL STR123
 	                /*  */
        	        STR2='=84'
                	STR3='&auml;'
	                CALL STR123
	                /*  */
        	        STR2='=85'
                	STR3=''
	                CALL STR123
	                /*  */
        	        STR2='=89'
                	STR3='`'
	                CALL STR123
        	        /* é */
                	STR2='=8E'
	                STR3='&Auml;'
        	        CALL STR123
		END
                if LASTPOS("=9",STR1UPPER) > 0 then do
	                /* ' */
        	        STR2='=91'
                	STR3="&prime;"
	                CALL STR123
	                /* ' */
        	        STR2='=92'
                	STR3="&prime;"
	                CALL STR123
	                /*  */
        	        STR2='=93'
                	STR3=''
	                CALL STR123
        	        /* î  */
                	STR2='=94'
	                STR3='&ouml;'
        	        CALL STR123
	               	/* ö */
	                STR2='=9A'
        	        STR3='&Uuml;'
                	CALL STR123
	               	/* · */
	                STR2='=9F'
        	        STR3='&szlig;'
                	CALL STR123
		END
                if LASTPOS("=A",STR1UPPER) > 0 then do
                        /* . */
                        STR2='=A0'
                        STR3='&nbsp;'
                        CALL STR123
                        /* . */
                        STR2='=A1'
                        STR3='&iexcl;'
                        CALL STR123
                        /* . */
                        STR2='=A2'
                        STR3='&cent;'
                        CALL STR123
                        /* . */
                        STR2='=A3'
                        STR3='&pound;'
                        CALL STR123
                        /* . */
                        STR2='=A4'
                        STR3='&curren;'
                        CALL STR123
                        /* . */
                        STR2='=A5'
                        STR3='&yen;'
                        CALL STR123
                        /* . */
                        STR2='=A6'
                        STR3='&brvbar;'
                        CALL STR123
                        /* . */
                        STR2='=A7'
                        STR3='&sect;'
                        CALL STR123
                        /* . */
                        STR2='=A8'
                        STR3='&uml;'
                        CALL STR123
                        /* . */
                        STR2='=A9'
                        STR3='&copy;'
                        CALL STR123
                        /* . */
                        STR2='=AA'
                        STR3='&ordf;'
                        CALL STR123
                        /* . */
                        STR2='=AB'
                        STR3='&laquo;'
                        CALL STR123
                        /* . */
                        STR2='=AC'
                        STR3='&not;'
                        CALL STR123
                        /* . */
                        STR2='=AD'
                        STR3='&shy;'
                        CALL STR123
                        /* . */
                        STR2='=AE'
                        STR3='reg;'
                        CALL STR123
                        /* . */
                        STR2='=AF'
                        STR3='&macr;'
                        CALL STR123
                END
                if LASTPOS("=B",STR1UPPER) > 0 then do
                        /* . */
                        STR2='=B0'
                        STR3='&deg;'
                        CALL STR123
                        /* . */
                        STR2='=B1'
                        STR3='&plusmn;'
                        CALL STR123
                        /* . */
                        STR2='=B2'
                        STR3='&sup2;'
                        CALL STR123
                        /* . */
                        STR2='=B3'
                        STR3='&sup3;'
                        CALL STR123
                        /* . */
                        STR2='=B4'
                        STR3='&acute;'
                        CALL STR123
                        /* . */
                        STR2='=B5'
                        STR3='&micro;'
                        CALL STR123
                        /* . */
                        STR2='=B6'
                        STR3='&para;'
                        CALL STR123
                        /* . */
                        STR2='=B7'
                        STR3='&middot;'
                        CALL STR123
                        /* . */
                        STR2='=B8'
                        STR3='&cedil;'
                        CALL STR123
                        /* . */
                        STR2='=B9'
                        STR3='&sup1;'
                        CALL STR123
                        /* . */
                        STR2='=BA'
                        STR3='&ordm;'
                        CALL STR123
                        /* . */
                        STR2='=BB'
                        STR3='&raquo;'
                        CALL STR123
                        /* . */
                        STR2='=BC'
                        STR3='&frac14;'
                        CALL STR123
                        /* . */
                        STR2='=BD'
                        STR3='&frac12;'
                        CALL STR123
                        /* . */
                        STR2='=BE'
                        STR3='&frac34;'
                        CALL STR123
                        /* . */
                        STR2='=BF'
                        STR3='&iquest;'
                        CALL STR123
                END
                if LASTPOS("=C",STR1UPPER) > 0 then do
                        /* . */
                        STR2='=C0'
                        STR3='&Agrave;'
                        CALL STR123
                        /* . */
                        STR2='=C1'
                        STR3='&Aacute;'
                        CALL STR123
                        /* . */
                        STR2='=C2'
                        STR3='&Acirc;'
                        CALL STR123
                        /* . */
                        STR2='=C3'
                        STR3='&Atilde;'
                        CALL STR123
                        /* . */
                        STR2='=C4'
                        STR3='&Auml;'
                        CALL STR123
                        /* . */
                        STR2='=C5'
                        STR3='&Aring;'
                        CALL STR123
                        /* . */
                        STR2='=C6'
                        STR3='&AElig;'
                        CALL STR123
                        /* . */
                        STR2='=C7'
                        STR3='&Ccedil;'
                        CALL STR123
                        /* . */
                        STR2='=C8'
                        STR3='&Egrave;'
                        CALL STR123
                        /* . */
                        STR2='=C9'
                        STR3='&Eacute;'
                        CALL STR123
                        /* . */
                        STR2='=CA'
                        STR3='&Eacute;'
                        CALL STR123
                        /* . */
                        STR2='=CB'
                        STR3='&Euml;'
                        CALL STR123
                        /* . */
                        STR2='=CC'
                        STR3='&Igrave;'
                        CALL STR123
                        /* . */
                        STR2='=CD'
                        STR3='&Iacute;'
                        CALL STR123
                        /* . */
                        STR2='=CE'
                        STR3='&Icirc;'
                        CALL STR123
                        /* . */
                        STR2='=CF'
                        STR3='&Iuml;'
                        CALL STR123
                END
                if LASTPOS("=D",STR1UPPER) > 0 then do
                        /* . */
                        STR2='=D0'
                        STR3='&ETH;'
                        CALL STR123
                        /* . */
                        STR2='=D1'
                        STR3='&Ntilde;'
                        CALL STR123
                        /* . */
                        STR2='=D2'
                        STR3='&Ograve;'
                        CALL STR123
                        /* . */
                        STR2='=D3'
                        STR3='&Oacute;'
                        CALL STR123
                        /* . */
                        STR2='=D4'
                        STR3='&Ocirc;'
                        CALL STR123
                        /* . */
                        STR2='=D5'
                        STR3='&Otilde;'
                        CALL STR123
                        /* . */
                        STR2='=D6'
                        STR3='&Ouml;'
                        CALL STR123
                        /* . */
                        STR2='=D7'
                        STR3='&times;'
                        CALL STR123
                        /* . */
                        STR2='=D8'
                        STR3='&Oslash;'
                        CALL STR123
                        /* . */
                        STR2='=D9'
                        STR3='&Ugrave;'
                        CALL STR123
                        /* . */
                        STR2='=DA'
                        STR3='&Uacute;'
                        CALL STR123
                        /* . */
                        STR2='=DB'
                        STR3='&Ucirc;'
                        CALL STR123
                        /* . */
                        STR2='=DC'
                        STR3='&Uuml;'
                        CALL STR123
                        /* . */
                        STR2='=DD'
                        STR3='&Yacute;'
                        CALL STR123
                        /* . */
                        STR2='=DE'
                        STR3='&THORN;'
                        CALL STR123
                        /* . */
                        STR2='=DF'
                        STR3='&szlig;'
                        CALL STR123
                END
                if LASTPOS("=E",STR1UPPER) > 0 then do
                        /* . */
                        STR2='=E0'
                        STR3='&agrave;'
                        CALL STR123
                        /* . */
                        STR2='=E1'
                        STR3='&szlig;'
                        CALL STR123
                        /* . */
                        STR2='=E2'
                        STR3='&acirc;'
                        CALL STR123
                        /* . */
                        STR2='=E3'
                        STR3='&atilde;'
                        CALL STR123
                        /* . */
                        STR2='=E4'
                        STR3='&auml;'
                        CALL STR123
                        /* . */
                        STR2='=E5'
                        STR3='&aring;'
                        CALL STR123
                        /* . */
                        STR2='=E6'
                        STR3='&aelig;'
                        CALL STR123
                        /* . */
                        STR2='=E7'
                        STR3='&ccedil;'
                        CALL STR123
                        /* . */
                        STR2='=E8'
                        STR3='&egrave;'
                        CALL STR123
                        /* . */
                        STR2='=E9'
                        STR3='&eacute;'
                        CALL STR123
                        /* . */
                        STR2='=EA'
                        STR3='&ecirc;'
                        CALL STR123
                        /* . */
                        STR2='=EB'
                        STR3='&euml;'
                        CALL STR123
                        /* . */
                        STR2='=EC'
                        STR3='&igrave;'
                        CALL STR123
                        /* . */
                        STR2='=ED'
                        STR3='&iacute;'
                        CALL STR123
                        /* . */
                        STR2='=EE'
                        STR3='&icirc;'
                        CALL STR123
                        /* . */
                        STR2='=EF'
                        STR3='&iuml;'
                        CALL STR123
                END
                if LASTPOS("=F",STR1UPPER) > 0 then do
                        /* . */
                        STR2='=F0'
                        STR3='&eth;'
                        CALL STR123
                        /* . */
                        STR2='=F1'
                        STR3='&ntilde;'
                        CALL STR123
                        /* . */
                        STR2='=F2'
                        STR3='&ograve;'
                        CALL STR123
                        /* . */
                        STR2='=F3'
                        STR3='&oacute;'
                        CALL STR123
                        /* . */
                        STR2='=F4'
                        STR3='&ocirc;'
                        CALL STR123
                        /* . */
                        STR2='=F5'
                        STR3='&otilde;'
                        CALL STR123
                        /* . */
                        STR2='=F6'
                        STR3='&ouml;'
                        CALL STR123
                        /* . */
                        STR2='=F7'
                        STR3='&divide;'
                        CALL STR123
                        /* . */
                        STR2='=F8'
                        STR3='&oslash;'
                        CALL STR123
                        /* . */
                        STR2='=F9'
                        STR3='&ugrave;'
                        CALL STR123
                        /* . */
                        STR2='=FA'
                        STR3='&uacute;'
                        CALL STR123
                        /* . */
                        STR2='=FB'
                        STR3='&ucirc;'
                        CALL STR123
                        /* . */
                        STR2='=FC'
                        STR3='&uuml;'
                        CALL STR123
                        /* . */
                        STR2='=FD'
                        STR3='&yacute;'
                        CALL STR123
                        /* . */
                        STR2='=FE'
                        STR3='&thorn;'
                        CALL STR123
                        /* . */
                        STR2='=FF'
                        STR3='&yuml;'
                        CALL STR123
                END
           END
                /* Sondersachen */
                /* =? */
                STR2='=?'
                STR3=''
                CALL STR123
                /* ?= */
                STR2='?='
                STR3=''
                CALL STR123
                /* ?Q? */
                STR2='?Q?'
                STR3='ˇ'

                /* · */
                STR2='ﬂ'
                STR3='&szlig;'
                CALL STR123
                /* Ñ */
                STR2='‰'
                STR3='&auml;'
                CALL STR123
                /* Å */
                STR2='¸'
                STR3='&uuml;'
                CALL STR123
                /* î */
                STR2='ˆ'
                STR3='&ouml;'
                CALL STR123
                /* ô */
                STR2='÷'
                STR3='&Ouml;'
                CALL STR123                
                /* © */
                STR2='©'
                STR3='&reg;'
                CALL STR123
                /* ı */
                STR2='ß'
                STR3='&sect;'
                CALL STR123

                /* Umlaute und Sonderzeichen ersetzen, */
           if LASTPOS("%",STR1UPPER) > 0 then do
                if LASTPOS("%2",STR1UPPER) > 0 then do
                        /*  */
                        STR2='%20'
                        STR3='ˇ'
                        CALL STR123
                        /*  */
                        STR2='%21'
                        STR3='!'
                        CALL STR123
                        /*  */
                        STR2='%22'
                        STR3='&quot;'
                        CALL STR123
                        /*  */
                        STR2='%23'
                        STR3='#'
                        CALL STR123
                        /*  */
                        STR2='%24'
                        STR3='$'
                        CALL STR123
                        /*  */
                        STR2='%25'
                        STR3='%'
                        CALL STR123
                        /*  */
                        STR2='%26'
                        STR3='&'
                        CALL STR123
                        /*  */
                        STR2='%27'
                        STR3=' '
                        CALL STR123
                        /* ( */
                        STR2='%28'
                        STR3='('
                        CALL STR123
                        /* ) */
                        STR2='%29'
                        STR3=')'
                        CALL STR123
                        /*  */
                        STR2='%2A'
                        STR3='*'
                        CALL STR123
                        /*  */
                        STR2='%2B'
                        STR3='+'
                        CALL STR123
                        /*  */
                        STR2='%2C'
                        STR3=','
                        CALL STR123
                        /* - */
                        STR2='%2D'
                        STR3='-'
                        CALL STR123
                        /* . */
                        STR2='%2E'
                        STR3='.'
                        CALL STR123
                        /* / */
                        STR2='%2F'
                        STR3='/'
                        CALL STR123
                END
                if LASTPOS("%3",STR1UPPER) > 0 then do
                        /* : */
                        STR2='%30'
                        STR3='0'
                        CALL STR123
                        /* : */
                        STR2='%31'
                        STR3='1'
                        CALL STR123
                        /* : */
                        STR2='%32'
                        STR3='2'
                        CALL STR123
                        /* : */
                        STR2='%33'
                        STR3='3'
                        CALL STR123
                        /* : */
                        STR2='%34'
                        STR3='4'
                        CALL STR123
                        /* : */
                        STR2='%35'
                        STR3='5'
                        CALL STR123
                        /* : */
                        STR2='%36'
                        STR3='6'
                        CALL STR123
                        /* : */
                        STR2='%37'
                        STR3='7'
                        CALL STR123
                        /* : */
                        STR2='%38'
                        STR3='8'
                        CALL STR123
                        /* : */
                        STR2='%39'
                        STR3='9'
                        CALL STR123
                        /* : */
                        STR2='%3A'
                        STR3=':'
                        CALL STR123
                        /* : */
                        STR2='%3B'
                        STR3=';'
                        CALL STR123
                        /* : */
                        STR2='%3C'
                        STR3='&lt;'
                        CALL STR123
                        /* = */
                        STR2='%3D'
                        STR3='%'
                        CALL STR123
                        /* : */
                        STR2='%3E'
                        STR3='&gt;'
                        CALL STR123
                        /* : */
                        STR2='%3F'
                        STR3='?'
                        CALL STR123
                end
                        /*  */
                        STR2='%40'
                        STR3='@'
                        CALL STR123
                if LASTPOS("%5",STR1UPPER) > 0 then do
                        /*  */
                        STR2='%5B'
                        STR3='['
                        CALL STR123
                        /*  */
                        STR2='%5C'
                        STR3='\'
                        CALL STR123
                        /*  */
                        STR2='%5D'
                        STR3=']'
                        CALL STR123
                        /*  */
                        STR2='%5E'
                        STR3='^'
                        CALL STR123
                        /*  */
                        STR2='%5F'
                        STR3='_'
                        CALL STR123
                END
                if LASTPOS("%6",STR1UPPER) > 0 then do
                        /*  */
                        STR2='%60'
                        STR3='`'
                        CALL STR123
                END
                if LASTPOS("%7",STR1UPPER) > 0 then do
                        /*  */
                        STR2='%7B'
                        STR3='{'
                        CALL STR123
                        /*  */
                        STR2='%7C'
                        STR3='|'
                        CALL STR123
                        /*  */
                        STR2='%7D'
                        STR3='}'
                        CALL STR123
                        /*  */
                        STR2='%7E'
                        STR3='~'
                        CALL STR123
                END
                if LASTPOS("%A",STR1UPPER) > 0 then do
                        /* . */
                        STR2='%A0'
                        STR3='&nbsp;'
                        CALL STR123
                        /* . */
                        STR2='%A1'
                        STR3='&iexcl;'
                        CALL STR123
                        /* . */
                        STR2='%A2'
                        STR3='&cent;'
                        CALL STR123
                        /* . */
                        STR2='%A3'
                        STR3='&pound;'
                        CALL STR123
                        /* . */
                        STR2='%A4'
                        STR3='&curren;'
                        CALL STR123
                        /* . */
                        STR2='%A5'
                        STR3='&yen;'
                        CALL STR123
                        /* . */
                        STR2='%A6'
                        STR3='&brvbar;'
                        CALL STR123
                        /* . */
                        STR2='%A7'
                        STR3='&sect;'
                        CALL STR123
                        /* . */
                        STR2='%A8'
                        STR3='&uml;'
                        CALL STR123
                        /* . */
                        STR2='%A9'
                        STR3='&copy;'
                        CALL STR123
                        /* . */
                        STR2='%AA'
                        STR3='&ordf;'
                        CALL STR123
                        /* . */
                        STR2='%AB'
                        STR3='&laquo;'
                        CALL STR123
                        /* . */
                        STR2='%AC'
                        STR3='&not;'
                        CALL STR123
                        /* . */
                        STR2='%AD'
                        STR3='&shy;'
                        CALL STR123
                        /* . */
                        STR2='%AE'
                        STR3='reg;'
                        CALL STR123
                        /* . */
                        STR2='%AF'
                        STR3='&macr;'
                        CALL STR123
                END
                if LASTPOS("%B",STR1UPPER) > 0 then do
                        /* . */
                        STR2='%B0'
                        STR3='&deg;'
                        CALL STR123
                        /* . */
                        STR2='%B1'
                        STR3='&plusmn;'
                        CALL STR123
                        /* . */
                        STR2='%B2'
                        STR3='&sup2;'
                        CALL STR123
                        /* . */
                        STR2='%B3'
                        STR3='&sup3;'
                        CALL STR123
                        /* . */
                        STR2='%B4'
                        STR3='&acute;'
                        CALL STR123
                        /* . */
                        STR2='%B5'
                        STR3='&micro;'
                        CALL STR123
                        /* . */
                        STR2='%B6'
                        STR3='&para;'
                        CALL STR123
                        /* . */
                        STR2='%B7'
                        STR3='&middot;'
                        CALL STR123
                        /* . */
                        STR2='%B8'
                        STR3='&cedil;'
                        CALL STR123
                        /* . */
                        STR2='%B9'
                        STR3='&sup1;'
                        CALL STR123
                        /* . */
                        STR2='%BA'
                        STR3='&ordm;'
                        CALL STR123
                        /* . */
                        STR2='%BB'
                        STR3='&raquo;'
                        CALL STR123
                        /* . */
                        STR2='%BC'
                        STR3='&frac14;'
                        CALL STR123
                        /* . */
                        STR2='%BD'
                        STR3='&frac12;'
                        CALL STR123
                        /* . */
                        STR2='%BE'
                        STR3='&frac34;'
                        CALL STR123
                        /* . */
                        STR2='%BF'
                        STR3='&iquest;'
                        CALL STR123
                END
                if LASTPOS("%C",STR1UPPER) > 0 then do
                        /* . */
                        STR2='%C0'
                        STR3='&Agrave;'
                        CALL STR123
                        /* . */
                        STR2='%C1'
                        STR3='&Aacute;'
                        CALL STR123
                        /* . */
                        STR2='%C2'
                        STR3='&Acirc;'
                        CALL STR123
                        /* . */
                        STR2='%C3'
                        STR3='&Atilde;'
                        CALL STR123
                        /* . */
                        STR2='%C4'
                        STR3='&Auml;'
                        CALL STR123
                        /* . */
                        STR2='%C5'
                        STR3='&Aring;'
                        CALL STR123
                        /* . */
                        STR2='%C6'
                        STR3='&AElig;'
                        CALL STR123
                        /* . */
                        STR2='%C7'
                        STR3='&Ccedil;'
                        CALL STR123
                        /* . */
                        STR2='%C8'
                        STR3='&Egrave;'
                        CALL STR123
                        /* . */
                        STR2='%C9'
                        STR3='&Eacute;'
                        CALL STR123
                        /* . */
                        STR2='%CA'
                        STR3='&Eacute;'
                        CALL STR123
                        /* . */
                        STR2='%CB'
                        STR3='&Euml;'
                        CALL STR123
                        /* . */
                        STR2='%CC'
                        STR3='&Igrave;'
                        CALL STR123
                        /* . */
                        STR2='%CD'
                        STR3='&Iacute;'
                        CALL STR123
                        /* . */
                        STR2='%CE'
                        STR3='&Icirc;'
                        CALL STR123
                        /* . */
                        STR2='%CF'
                        STR3='&Iuml;'
                        CALL STR123
                END
                if LASTPOS("%D",STR1UPPER) > 0 then do
                        /* . */
                        STR2='%D0'
                        STR3='&ETH;'
                        CALL STR123
                        /* . */
                        STR2='%D1'
                        STR3='&Ntilde;'
                        CALL STR123
                        /* . */
                        STR2='%D2'
                        STR3='&Ograve;'
                        CALL STR123
                        /* . */
                        STR2='%D3'
                        STR3='&Oacute;'
                        CALL STR123
                        /* . */
                        STR2='%D4'
                        STR3='&Ocirc;'
                        CALL STR123
                        /* . */
                        STR2='%D5'
                        STR3='&Otilde;'
                        CALL STR123
                        /* . */
                        STR2='%D6'
                        STR3='&Ouml;'
                        CALL STR123
                        /* . */
                        STR2='%D7'
                        STR3='&times;'
                        CALL STR123
                        /* . */
                        STR2='%D8'
                        STR3='&Oslash;'
                        CALL STR123
                        /* . */
                        STR2='%D9'
                        STR3='&Ugrave;'
                        CALL STR123
                        /* . */
                        STR2='%DA'
                        STR3='&Uacute;'
                        CALL STR123
                        /* . */
                        STR2='%DB'
                        STR3='&Ucirc;'
                        CALL STR123
                        /* . */
                        STR2='%DC'
                        STR3='&Uuml;'
                        CALL STR123
                        /* . */
                        STR2='%DD'
                        STR3='&Yacute;'
                        CALL STR123
                        /* . */
                        STR2='%DE'
                        STR3='&THORN;'
                        CALL STR123
                        /* . */
                        STR2='%DF'
                        STR3='&szlig;'
                        CALL STR123
                END
                if LASTPOS("%E",STR1UPPER) > 0 then do
                        /* . */
                        STR2='%E0'
                        STR3='&agrave;'
                        CALL STR123
                        /* . */
                        STR2='%E1'
                        STR3='&aacute;'
                        CALL STR123
                        /* . */
                        STR2='%E2'
                        STR3='&acirc;'
                        CALL STR123
                        /* . */
                        STR2='%E3'
                        STR3='&atilde;'
                        CALL STR123
                        /* . */
                        STR2='%E4'
                        STR3='&auml;'
                        CALL STR123
                        /* . */
                        STR2='%E5'
                        STR3='&aring;'
                        CALL STR123
                        /* . */
                        STR2='%E6'
                        STR3='&aelig;'
                        CALL STR123
                        /* . */
                        STR2='%E7'
                        STR3='&ccedil;'
                        CALL STR123
                        /* . */
                        STR2='%E8'
                        STR3='&egrave;'
                        CALL STR123
                        /* . */
                        STR2='%E9'
                        STR3='&eacute;'
                        CALL STR123
                        /* . */
                        STR2='%EA'
                        STR3='&ecirc;'
                        CALL STR123
                        /* . */
                        STR2='%EB'
                        STR3='&euml;'
                        CALL STR123
                        /* . */
                        STR2='%EC'
                        STR3='&igrave;'
                        CALL STR123
                        /* . */
                        STR2='%ED'
                        STR3='&iacute;'
                        CALL STR123
                        /* . */
                        STR2='%EE'
                        STR3='&icirc;'
                        CALL STR123
                        /* . */
                        STR2='%EF'
                        STR3='&iuml;'
                        CALL STR123
                END
                if LASTPOS("%F",STR1UPPER) > 0 then do
                        /* . */
                        STR2='%F0'
                        STR3='&eth;'
                        CALL STR123
                        /* . */
                        STR2='%F1'
                        STR3='&ntilde;'
                        CALL STR123
                        /* . */
                        STR2='%F2'
                        STR3='&ograve;'
                        CALL STR123
                        /* . */
                        STR2='%F3'
                        STR3='&oacute;'
                        CALL STR123
                        /* . */
                        STR2='%F4'
                        STR3='&ocirc;'
                        CALL STR123
                        /* . */
                        STR2='%F5'
                        STR3='&otilde;'
                        CALL STR123
                        /* . */
                        STR2='%F6'
                        STR3='&ouml;'
                        CALL STR123
                        /* . */
                        STR2='%F7'
                        STR3='&divide;'
                        CALL STR123
                        /* . */
                        STR2='%F8'
                        STR3='&oslash;'
                        CALL STR123
                        /* . */
                        STR2='%F9'
                        STR3='&ugrave;'
                        CALL STR123
                        /* . */
                        STR2='%FA'
                        STR3='&uacute;'
                        CALL STR123
                        /* . */
                        STR2='%FB'
                        STR3='&ucirc;'
                        CALL STR123
                        /* . */
                        STR2='%FC'
                        STR3='&uuml;'
                        CALL STR123
                        /* . */
                        STR2='%FD'
                        STR3='&yacute;'
                        CALL STR123
                        /* . */
                        STR2='%FE'
                        STR3='&thorn;'
                        CALL STR123
                        /* . */
                        STR2='%FF'
                        STR3='&yuml;'
                        CALL STR123
                END
                /* Sondersachen */
                /*  */
                STR2='%93'
                STR3=''
                CALL STR123
                /* RETURN2 */
                STR2='%0A'
                STR3=''
                CALL STR123
                /* RETURN3 */
                STR2='%0D'
                STR3='<BR>'
                CALL STR123
                /* =? */
                STR2='%?'
                STR3=''
                CALL STR123
            END 
                /* Fertig  */
                Zeile=STR1
	end    
        /* Fertig Umlaute und Sonderzeichen ersetzen, */
        Zeile=STR1
return


