/* Generated Code (IMPORT) */
/* Source File: States.xlsx */
/* Source Path: /home/u63735743/sasuser.v94 */
/* Code generated on: 4/24/25, 4:33 PM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u63735743/sasuser.v94/States.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);