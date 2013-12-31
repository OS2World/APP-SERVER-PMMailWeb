/*****************************************************************************************************/
/*                                Webinterface for PMMail    MAKE                                    */
/*                              by Peter Lueersen <Peter.Lueersen@web.de>                            */
/*                                              V 1.01                                               */
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
cls
say '*******************************************************************************'
say '*                      Webinterface for PMMail MAKE                           *'
say '*        by Peter Lueersen                          Version 1.01              *'
say '*                  PMMailWEB    (c) Peter LÅersen                             *'
say '*                Email address: Peter@warp-ecs-owl.de                         *'
say '*                  Program URL: www.warp-ecs-owl.de                           *'
say '*                               www.warp-ecs-owl.de/Peter_PMMailWEB.html      *'
say '*******************************************************************************'
rexx2exe pmmailweb.cmd PMMAILWEB.EXE
rexx2exe pmmailconfig.cmd PMMAILCONFIG.EXE
'del ..\PMMAILWEB10A2.zip'
'copy pmmailweb.exe ..\PMMAILWEB.EXE'
'copy pmmailconfig.exe ..\PMMAILCONFIG.EXE'
'copy pmmailconfig.cfg ..\PMMAILCONFIG.CFG'
'del pmmailweb.exe'
'del pmmailconfig.exe'
cd..
'RES\zip.exe -r -D -9 -u -v PMMAILWEB10A2.zip *.*'
