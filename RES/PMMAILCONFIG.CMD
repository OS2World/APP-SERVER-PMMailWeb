/*****************************************************************************************************/
/*                               Config for PMMailWeb                                                */
/*                     by Peter Lueersen <Peter@warp-ecs-owl.de>                                     */
/*                                        V 1.00A2                                                   */
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
Globals.!ver='1.00A2'                                                                   /*Versinon                             */

signal on syntax name ShowError                                                         /*On Error goto Errorlog               */

_starttimer:                                                                            /*Start of main routine                */
    CALL Time 'E'

/***************************************************/
/* INSTALLATION                                    */
/***************************************************/


/***************************************************/
/* Globale Variablen from PMMAILWEB.CFG            */
/***************************************************/
Globals.!PMMailPath='C:\PMMail'                                                         /*Path to PMMail                       */
Globals.!MailDataPath='C:\PMMail\Accounts'                                              /*Path to MailData from PMMail         */
Globals.!HtmlTableColor='WHITE'                                                         /*Table Color                          */
Globals.!Emailmax='25'                                                                  /*Max Mails                            */
Globals.!html_body_line='<BODY onload="lade()" bgcolor="#EFEFEF" text="#000000">'       /*The BODY-Tag Line in the html outputs*/
Globals.!Show_HTML='YES'                                                                /*Text and HTML                        */
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

/***************************************************/
/*           Feste Globale Variablen 2             */
/***************************************************/
if Globals.!SCRIPT_NAME \= '' then
	Globals.!ext=SUBSTR(Globals.!SCRIPT_NAME,length(Globals.!SCRIPT_NAME)-2,3)
Globals.!File='PMMailWEB.'||Globals.!ext                                                /*Name of File                         */
Globals.!CONFIGFile='PMMAILCONFIG.'||Globals.!ext                                       /*Name of CONFIG - EXE File            */
Globals.!CFGFilename='PMMailWEB.CFG'                                                    /*Name of CONFIG - File                */   
Globals.!LOGFile='PMMailWEB.LOG'                                                        /*Name of DEBUG - File                 */
Globals.!IDFile='PMMailWEB.ID'                                                          /*Name of ID - File                    */
Globals.!myinfo='PMMailWeb  &copy; 2011 by Peter L&uuml;ersen'                          /*Info Topline                         */
GLobals.!TEMPFile='PMMAILWEB.TMP'

/*Hilfsvariablen fuer (STR1UPPER=TRANSLATE(STR1,tabout,taborg))*/
taborg=XRANGE('a','z')
tabout=XRANGE('A','Z')

Zeile = ''
Antwort = ''
pull Zeile
CALL UMLAUTE
Antwort=Zeile

/*Lesen der Config (/cgi-bin/PMMailWEB.CFG)*/
erg=STREAM(Globals.!CFGFilename, 'C', "QUERY EXISTS")
if ret\="" then do
       erg=STREAM(Globals.!CFGFilename, 'C', "OPEN")
       /*Auswerten der Datei*/
       DO WHILE lines(Globals.!CFGFilename) = 1
        Zeile=LINEIN(Globals.!CFGFilename)
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
      erg=STREAM(Globals.!CFGFilename, 'C', "CLOSE")
end



parse value Antwort with Antwort1 "&" Antwort2 "&" Antwort3
if LENGTH(Antwort1)>0 then do
	pos1=pos('=', Antwort1)
	Option1=SUBSTR(Antwort1, 1,pos1-1)
	Wert1=SUBSTR(Antwort1, pos1+1,LENGTH(Antwort1)-pos1)
end
if LENGTH(Antwort2)>0 then do
	pos1=pos('=', Antwort2)
	Option2=SUBSTR(Antwort2, 1,pos1-1)
	Wert2=SUBSTR(Antwort2, pos1+1,LENGTH(Antwort2)-pos1)
end
if LENGTH(Antwort3)>0 then do
	pos1=pos('=', Antwort3)
	Option3=SUBSTR(Antwort3, 1,pos1-1)
	Wert3=SUBSTR(Antwort3, pos1+1,LENGTH(Antwort3)-pos1)
end

if Globals.!Log='YES' then do
        CALL LINEOUT Globals.!LOGFile,' ->šbergabe   : ' || Antwort
        CALL LINEOUT Globals.!LOGFile,'      Option1 : ' || Option1
        CALL LINEOUT Globals.!LOGFile,'      Wert1   : ' || Wert1
        CALL LINEOUT Globals.!LOGFile,'      Option2 : ' || Option2
        CALL LINEOUT Globals.!LOGFile,'      Wert2   : ' || Wert2
        CALL LINEOUT Globals.!LOGFile,'      Option3 : ' || Option3
        CALL LINEOUT Globals.!LOGFile,'      Wert3   : ' || Wert3
end

erg=STREAM(Globals.!LOGFile, 'C', "CLOSE")

if Option1='FLOGIN' then do
	/* OK und jetzt noch alles anzeigen */
	say 'Content-Type: text/html;  charset=ISO-8859-1'
	say ''
	say '<!doctype html public "-//w3c//dtd html 4.0 transitional//en">'
	say '<!-- File automatically generated by ' || Globals.!CONFIGFile || ' Ver.:' || Globals.!ver || ' on ' || DATE() || ' at ' || TIME('N') || ' -->'
	say '<!-- (C) COPYRIGHT Peter Lueersen 2011                      -->'
	say '<!-- All Rights Reserved                                    -->'
	say '<!-- Licensed Materials - Property of Peter Lueersen        -->'
            say '<html>'
            say '<head>'
            say '<meta http-equiv="expires" content="0">'
	say '<meta name="author" content="Peter Lueersen">'
	say '<meta http-equiv="content-type">'
	say '<meta NAME="Robots" CONTENT="NOINDEX, NOFOLLOW">'
	if Wert1=1 then do
		if (Wert2=TRANSLATE(Globals.!PMMail_user,tabout,taborg)) then do
	         	if (Wert3=TRANSLATE(Globals.!PMMail_password,tabout,taborg)) then do
				/* OK und jetzt noch alles anzeigen */
				LoginID='ID::' || RANDOM() || 'QWERTZUIOP' || RANDOM() || 'ASDFGHJKL' || RANDOM()
                                CALL write_ID LoginID
        			say '<meta http-equiv="refresh" content="0;URL=' || Globals.!CGI_BIN || Globals.!File || '?' || LoginID || '?READACCOUNT?">'
        			say '</head>'
			end
			else do
				/* OK und jetzt noch alles anzeigen */
        			say '<meta http-equiv="refresh" content="0;URL=' || Globals.!CGI_BIN || Globals.!File || '">'
        			say '</head>'
			end

		end
		else do
			/* OK und jetzt noch alles anzeigen */
        		say '<meta http-equiv="refresh" content="0;URL=' || Globals.!CGI_BIN || Globals.!File || '">'
        		say '</head>'
		end
	end
end
else do
	if Globals.!Log='YES' then do
        	CALL LINEOUT Globals.!LOGFile,'**********************************************************************'
	        CALL LINEOUT Globals.!LOGFile,'Config Version.....: ' || Globals.!Ver
        	CALL LINEOUT Globals.!LOGFile,' '
	        CALL LINEOUT Globals.!LOGFile,'OLD :'
        	CALL LINEOUT Globals.!LOGFile,' PMMail_Path       : ' || Globals.!PMMailPath
	        CALL LINEOUT Globals.!LOGFile,' Mail_Data_Path    : ' || Globals.!MailDataPath
        	CALL LINEOUT Globals.!LOGFile,' html_table_color  : ' || Globals.!HtmlTableColor
	        CALL LINEOUT Globals.!LOGFile,' html_body_line    : ' || Globals.!html_body_line
	        CALL LINEOUT Globals.!LOGFile,' Email_Max         : ' || Globals.!Emailmax
	        CALL LINEOUT Globals.!LOGFile,' Show_HTML         : ' || Globals.!Show_HTML
	        CALL LINEOUT Globals.!LOGFile,' CGI_BIN           : ' || Globals.!CGI_BIN
	        CALL LINEOUT Globals.!LOGFile,' Lang              : ' || Globals.!Lang
	        CALL LINEOUT Globals.!LOGFile,' Debug             : ' || Globals.!Log
	end

	if Option1='PMMailPath' then Globals.!PMMailPath=Wert1
	if Option1='MAILDATAPATH' then Globals.!MailDataPath=Wert1
	if Option1='HTMLTABLECOLOR' then Globals.!HtmlTableColor=Wert1
	if Option1='EMAILMAX' then Globals.!Emailmax=Wert1
	if Option1='SHOW_HTML' then Globals.!Show_HTML=Wert1
	if Option1='LANG' then Globals.!Lang=Wert1
	if OPtion1='CGI_BIN' then Globals.!CGI_BIN=Wert1
	if Option1='LOG' then Globals.!Log=Wert1

	Dateiname='PMMailWeb.CFG'
	call SysFileDelete Dateiname

	CALL LINEOUT Dateiname,'##################################################################################'
	CALL LINEOUT Dateiname,'#  PMMailWeb Configuration File                                Version 1.2       #'
	CALL LINEOUT Dateiname,'#  (c) Peter Lueersen 2011                                Peter@warp-ecs-owl.de  #'
	CALL LINEOUT Dateiname,'##################################################################################'
	CALL LINEOUT Dateiname,' '
	CALL LINEOUT Dateiname,'#Define >your< PMMail directory here.'
	CALL LINEOUT Dateiname,'PMMail_Path='||Globals.!PMMailPath
	CALL LINEOUT Dateiname,' '
	CALL LINEOUT Dateiname,'#Define >your< PMMail - MailData directory here.'
	CALL LINEOUT Dateiname,'Mail_Data_Path='||Globals.!MailDataPath
	CALL LINEOUT Dateiname,' '
	CALL LINEOUT Dateiname,'#Define >your< Language (EN/GE) for PMMailWeb here.'
	CALL LINEOUT Dateiname,'Lang='||Globals.!Lang
	CALL LINEOUT Dateiname,' '
	CALL LINEOUT Dateiname,'#Define >your< Max Mail-Count (25) for PMMailWeb here. 0 = Show all eMails.'
	CALL LINEOUT Dateiname,'# -1 = Show eMails only from today.'
	CALL LINEOUT Dateiname,'Email_Max='||Globals.!Emailmax
	CALL LINEOUT Dateiname,' '
	CALL LINEOUT Dateiname,'#The backgroundcolor for tables in the html outputs.Set >your< backgroundcolor here.'
	CALL LINEOUT Dateiname,'html_table_color='||Globals.!HtmlTableColor
	CALL LINEOUT Dateiname,' '
	CALL LINEOUT Dateiname,'#The BODY-Tag Line in the html outputs. Set >your< backgroundcolor here.'
	CALL LINEOUT Dateiname,'html_body_line=<BODY onload="lade()" bgcolor="#FAF0E6" text="#000000">'
	CALL LINEOUT Dateiname,' '
	CALL LINEOUT Dateiname,'#If the Mail has Text and HTML then <No> -> show Text <Yes> -> show Text and HTML'
	CALL LINEOUT Dateiname,'Show_HTML='||Globals.!Show_HTML
	CALL LINEOUT Dateiname,' '
	CALL LINEOUT Dateiname,'#Define >your< cgi-bin directory here.'
	CALL LINEOUT Dateiname,'CGI_BIN='||Globals.!CGI_BIN
	CALL LINEOUT Dateiname,' '
	CALL LINEOUT Dateiname,'#If the Debug-Option is needed  then <Yes> -> Debug PMMailWeb.LOG <No> -> No DEBUG'
	CALL LINEOUT Dateiname,'Debug='||Globals.!Log
	CALL LINEOUT Dateiname,' '
	CALL LINEOUT Dateiname,'#Needed username and password for login: (SINGLE MODE ONLY !!!)'
	CALL LINEOUT Dateiname,'PMMail_user='||Globals.!PMMail_user
	CALL LINEOUT Dateiname,'PMMail_password='||Globals.!PMMail_password
	CALL LINEOUT Dateiname,' '
	CALL LINEOUT Dateiname,'#You can define a ip or ip-range that have free access and dont need enter'
	CALL LINEOUT Dateiname,'#the username/password. Its nice for your private network.'
	CALL LINEOUT Dateiname,'#       free_access_for_ip=192.168.202.'
	CALL LINEOUT Dateiname,'#The example give alle hosts from 192.168.202.1 to 192.168.202.255 free access.'
	CALL LINEOUT Dateiname,'#Set to 0.0.0.0 when you not like this feature. Set never simple to . = free access for all =;)'
	CALL LINEOUT Dateiname,'free_access_for_ip='||Globals.!FreeAccess

	if Globals.!Log='YES' then do
	        CALL LINEOUT Globals.!LOGFile,' '
	        CALL LINEOUT Globals.!LOGFile,'NEW :'
	        CALL LINEOUT Globals.!LOGFile,' PMMail_Path       : ' || Globals.!PMMailPath
	        CALL LINEOUT Globals.!LOGFile,' Mail_Data_Path    : ' || Globals.!MailDataPath
	        CALL LINEOUT Globals.!LOGFile,' html_table_color  : ' || Globals.!HtmlTableColor
	        CALL LINEOUT Globals.!LOGFile,' html_body_line    : ' || Globals.!html_body_line
        	CALL LINEOUT Globals.!LOGFile,' Email_Max         : ' || Globals.!Emailmax
	        CALL LINEOUT Globals.!LOGFile,' Show_HTML         : ' || Globals.!Show_HTML
        	CALL LINEOUT Globals.!LOGFile,' CGI_BIN           : ' || Globals.!CGI_BIN
	        CALL LINEOUT Globals.!LOGFile,' Lang              : ' || Globals.!Lang
        	CALL LINEOUT Globals.!LOGFile,' Debug             : ' || Globals.!Log
	end
	erg=STREAM(Globals.!LOGFile, 'C', "CLOSE")

	/* OK und jetzt noch alles anzeigen */
        say 'Content-Type: text/html;  charset=ISO-8859-1'
        say ''
        say '<!doctype html public "-//w3c//dtd html 4.0 transitional//en">'
        say '<!-- File automatically generated by PMMailWebConfig Ver.:' || Globals.!ver || ' on ' || DATE() || ' at ' || TIME('N') || ' -->'
        say '<!-- (C) COPYRIGHT Peter Lueersen 2011                      -->'
        say '<!-- All Rights Reserved                                    -->'
        say '<!-- Licensed Materials - Property of Peter Lueersen        -->'
        say '<html>'
        say '<head>'
        say '<meta http-equiv="expires" content="0">'
        say '<meta name="author" content="Peter Lueersen">'
        say '<meta http-equiv="content-type">'
        say '<meta NAME="Robots" CONTENT="NOINDEX, NOFOLLOW">'
        LoginID=read_ID() 
        say '<meta http-equiv="refresh" content="0;URL=' || Globals.!CGI_BIN || Globals.!File || '?' || LoginID || '?CONFIG?">'
        say '</head>'
end

IF loaded = 1 THEN CALL SysDropFuncs
/* End of main routine */
EXIT

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
write_ID:PROCEDURE
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
read_ID:PROCEDURE
	erg=STREAM(Globals.!IDFile, 'C', "QUERY EXISTS")
	if ret\="" then do
	        erg=STREAM(Globals.!IDFile, 'C', "OPEN")
		ID = LINEIN(Globals.!IDFile)
	        erg=STREAM(Globals.!IDFile, 'C', "CLOSE")
	end
RETURN ID

/* ================================================================== */
/* Umlaute und Co in der Email bearbeiten (ISO-8859-1),...            */
/* ================================================================== */
UMLAUTE:
                STR1=Zeile
                STR1UPPER=TRANSLATE(STR1,tabout,taborg)
                /* Umlaute und Sonderzeichen ersetzen, */
                if LASTPOS("%2",STR1UPPER) > 0 then do
                        /*  */
                        STR2='%20'
                        STR3='ÿ'
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
                /* Õ */
                STR2='%80'
                STR3='&euro;'
                CALL STR123
                /*  */
                STR2='%84'
                STR3=''
                CALL STR123
                /*  */
                STR2='%93'
                STR3=''
                CALL STR123
                /* Sondersachen */
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
                /* ?= */
                STR2='?='
                STR3=''
                CALL STR123
                /* ?Q? */
                STR2='?Q?'
                STR3='ÿ'
                CALL STR123
                /* Fertig Umlaute und Sonderzeichen ersetzen, */
                Zeile=STR1
return

STR123:
        posRepStr1=pos(STR2,STR1UPPER,1)
        do while posRepStr1\=0
                if posRepStr1\=0 then do
                        if STR3='ÿ' then
                                STR1=SUBSTR(STR1,1,posRepStr1-1)|| ' ' || SUBSTR(STR1,posRepStr1+LENGTH(STR2),LENGTH(STR1)-posRepStr1-LENGTH(STR2)+1)
                        else do
                                if STR3='' then
                                        STR1=SUBSTR(STR1,1,posRepStr1-1)||SUBSTR(STR1,posRepStr1+LENGTH(STR2),LENGTH(STR1)-posRepStr1-LENGTH(STR2)+1)
                                else
                                        STR1=SUBSTR(STR1,1,posRepStr1-1)||STR3||SUBSTR(STR1,posRepStr1+LENGTH(STR2),LENGTH(STR1)-posRepStr1-LENGTH(STR2)+1)
                        end
                end
                STR1UPPER=TRANSLATE(STR1,tabout,taborg)
                posRepStr1=pos(STR2,STR1UPPER,1)
        end
return
