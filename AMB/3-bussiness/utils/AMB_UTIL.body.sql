create or replace package body AMB_UTIL
as

function generate_guid return varchar2
as

begin
	return SYS_GUID();
end generate_guid;



procedure print_clob(p_clob CLOB,p_style varchar2 default 'HTP')
  AS  
    v_clob_length number:=DBMS_LOB.GETLENGTH(p_clob);  
    v_offset number:=1;  
  BEGIN  
     
    WHILE v_offset < v_clob_length  
    LOOP  
    IF p_style = 'console' then
      DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(p_clob,4000,v_offset));
      v_offset:=v_offset+4000;  
    else
      htp.p(DBMS_LOB.SUBSTR(p_clob,32767,v_offset)); 
      v_offset:=v_offset+32767;  
    end if;
      
    END LOOP;  
END;

procedure set_ajax_header(p_response_type varchar2 default 'text/json')
as
begin
	owa_util.mime_header(p_response_type, FALSE );
	htp.p('Cache-Control: no-cache');
	htp.p('Pragma: no-cache');
	owa_util.http_header_close;
end;


procedure download_file(p_mine varchar2,p_file_clob CLOB,p_filename varchar2)
as
	v_length INTEGER;
begin
	v_length:=DBMS_LOB.GETLENGTH(p_file_clob); 
	owa_util.mime_header( nvl(p_mine,'application/octet'), FALSE );
	htp.p('Content-length: ' || v_length);
	htp.p('Content-Disposition: attachment; filename="'||p_filename||'"');
	owa_util.http_header_close;
	print_clob(p_file_clob);
end;

end AMB_UTIL;