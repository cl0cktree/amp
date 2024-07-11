<%@ page contentType="text/html;charset=Shift_JIS" %>
<%@ page import="com.ek.web.util.*" %>
<%
	String TELR = WebUtil.handleNull(request.getParameter("TELR"));
	String TERM_ID = WebUtil.padding(WebUtil.handleNull(request.getParameter("TERM_ID")), 8, true);
%>
<script>
	var winStatus = "FULLSCREEN=1";	
	var winStatus = "WIDTH=1014, HEIGHT=570, TOP=0, LEFT=0, MENUBAR=1, TOOLBAR=0, LOCATION=0, STATUS=1, DIRECTORIES=0, RESIZABLE=1";
	var mainWindow2 = window.open("about:blank", "mainWindow2", winStatus);
	mainWindow2.focus();
	var doc = mainWindow2.document;
	doc.open();
	doc.writeln("<form name=dataForm method=post>");
	doc.writeln("<input name=templet type=hidden value=main>");
	doc.writeln("<input name=TERM_ID type=hidden value=<%= TERM_ID %>>");
	doc.writeln("<input name=TELR type=hidden value=<%= TELR %>>");
	doc.writeln("<input name=SCRIPTCHECK type=hidden value=1>");
	doc.writeln("</form>");
	doc.close();
	mainWindow2.document.dataForm.submit();
	//window.location.replace('about:blank');
	self.close();
</script>
