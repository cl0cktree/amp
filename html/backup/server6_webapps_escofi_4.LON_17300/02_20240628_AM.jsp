<%@ page import="java.io.*" %>
<%@ page import="java.io.IOException"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="com.ek.util.*" %>
<%@ page import="com.ek.web.core.*" %>
<%@ page import="com.ek.web.util.*" %>
<%@ page import="com.ek.web.xml.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ page import="javax.xml.parsers.*" %>
<%@ page contentType="text/html; charset=Windows-31J" %>


<%!
public String strNullCheck (String sData) {
	return sData == null ? "" : sData;
}

public String AccountNum (String sData) {
	return sData.substring (7, 11) + "-" + sData.substring (11, 13) + "-" + sData.substring (13, 20);
}

public String ProductCode (String sData) {
	return sData.substring (0, 2) + "-" + sData.substring (2, 4) + "-" + sData.substring (4, 7) + "-" + sData.substring (7, 11);
}

public String CLNCode (String sData) {
	return sData.substring (0, 4) + "-" + sData.substring (4, 8) + "-" + sData.substring (8, 10) + "-" + sData.substring (10, 16);
}

//20160331 fx amt mask7  process  
public String makemask7(String strLen, String strData, String subnum ) {
	try {
		int i, j,k;
		String a = null;
		String value = null;
		int num	   = Integer.parseInt(subnum);
		
		i = strLen.indexOf (".");
		if (i > 0) {
			k = Integer.parseInt (strLen.substring (i+1, strLen.length ()));
			a = strData.substring(0,strData.length() - k);

		} else {
			a =strData;
		}
		String strpm = a.substring(0,1);

		if (strpm.compareTo("+") == 0 || strpm.compareTo("-") == 0) a = a.substring(1);
		
		for (j = 0; a.length () > j; j++){
			if (a.charAt (j) != '0')
				break;
		}		
		if (j == a.length ()) return "0";
		
		if(num > 0){      
			if( a.substring (j).length() >num ){
				a = a.substring (j);
				value = makeComa(a.substring(0, a.length() - num))+ "."+a.substring(a.length() - num);
				if (strpm.compareTo("-") == 0) value = "-"+value;
				return value;
			}else {
				a=a.substring(a.length() - num);
			    value = "0."+a;
			    if (strpm.compareTo("-") == 0) value = "-"+value;
				return value;
			}
		}else{
			a = a.substring (j);
			value = makeComa(a);
			if (strpm.compareTo("-") == 0) value = "-"+value;
			return value;
		
		}

	}
	catch (Exception e) {
		return "";
	}

}
//20160331 fx mask7  
public String makeComa (String sData) {

	int i, j;
	i = 0;
	String a = null;
	for (j = sData.length(); j > i + 3; j -=3)
		if (a != null)
			a = sData.substring (j - 3, j) + "," + a;
		else
			a = sData.substring (j - 3, j);
	if (a != null)
			a = sData.substring (i, j) + "," + a;
		else
			a = sData.substring (i, j);

	return a;
}

%>

<%
	System.out.println("=================start!! 02.jsp===========================");
	String xmlFile = request.getSession().getServletContext().getRealPath("/codeXml/4.LON/17300_02out.xml");
	
	String oHeaderFile = request.getSession().getServletContext().getRealPath("/xml/OUT_HEADER.xml");
	
	String SCRIPTCHECK = strNullCheck (request.getParameter("SCRIPTCHECK"));
//	out.println("Script : ["+ SCRIPTCHECK +"]<br>");


	byte [] rcvMsg = null;
	String strOutMessage = null;
/* 20160706
	if ((String) application.getAttribute(request.getRemoteAddr()) != null)	{
		strOutMessage = (String) application.getAttribute(request.getRemoteAddr());
		application.removeAttribute(request.getRemoteAddr());
	} else {
		strOutMessage = null;
	}
*/
        String resultid = request.getParameter("RESULTID");
 		System.out.println("[17300_02]resultid:" + resultid );
        if ( resultid != null ){
        	 strOutMessage = (String) application.getAttribute(resultid);
          	 if( strOutMessage!=null ) application.removeAttribute(resultid);
        }

//	out.println ("out message : " + strOutMessage + "<p>");
	if (strOutMessage != null)
		rcvMsg = strOutMessage.getBytes ("MS932");
	strOutMessage = null;
//	out.println("Msg : ["+ new String(rcvMsg) +"]<br>");

	XmlParse1 xp = null;
	boolean bReceiveOK = false;
	boolean bParsingOK = false;

	if (rcvMsg != null) {
		try {
			xp = new XmlParse1 ();
			xp.init(xmlFile);
			xp.setOutHeaderFile(oHeaderFile);

			String strError = "";
			if (xp.setOutHeader(rcvMsg)) {
				strError = xp.oheader.node_value[34];
			}

			if ("000000".compareTo(strError) == 0) {
				if (xp.parseXml(rcvMsg)) {
					bParsingOK = true;
					bReceiveOK = true;
				} else {
					out.println(xp.getErrorMsg());
					out.println("Parsing Error");
				}
			} else {
				// MQ ERROR
				bReceiveOK = true;
				out.println("MQ Error");
			}
		} catch (Exception e) {
		}
		rcvMsg = null;
	}
%>

<!--------------------->
<!-- start of 02.jsp -->
<!--------------------->
<script>var trInXml = loadXML('/codeXml/4.LON/17300_02in.xml')</script>

<script>
	function initPage() {

		//20160304 fx add start
		var currcode = 	getOHeader("NATIONAL_CODE");
		document.all.f100.value = currcode;

	}

	function checkPage(fieldArray){
		push("p1_1",document.all.f1_1.value);
		push("p1_2",document.all.f1_2.value);
		push("p1_3",document.all.f1_3.value);
		push("p1_4",document.all.f1_4.value);
		push("p1_5",document.all.f1_5.value);
		push("p2_1",document.all.f2_1.value);
		push("p2_2",document.all.f2_2.value);
		push("p2_3",document.all.f2_3.value);
		push("p3_1",document.all.f3_1.value);
		push("p3_2",document.all.f3_2.value);
		push("p3_3",document.all.f3_3.value);
		push("p4",document.all.f4.value);
		push("p5",document.all.f5.value);
		push("p6",document.all.f6.value);
	
		return true;
	}
	function flow() {
		go();	
		setMsg("200007");
	}
	function backScreen(){
		document.all.TRANSACTION.disabled = false;
		reloadInXML('/codeXml/4.LON/17300_01in.xml');
		document.all.TRANSACTION.click();
		document.all.TRANSACTION.disabled = true;
	}
</script>

</script>
<input type='hidden' name='code' value='01'>
<input type='hidden' name='RTN_FLAG' value='1'>
<button id=QUERY onclick="top.execute(document.all.trCode.value, '01')" style='border:1px inset;'><sup>F8</sup>&nbsp;<script>w1('QUERY')</script>
<button id=TRANSACTION type=submit style='margin-left:20' disabled=true><sup>F9</sup>&nbsp;<script>w1('TRANSACTION')</script></button>
<button name='BACKBTN' style=margin-left:40 onclick="backScreen()"><sup>&nbsp;</sup>前画面</button><br>
<p>
<label class="tab_page_label">貸出口座番号</label>
<input type='hidden' name='f1_1' style='width:40px'><input type='hidden' name='f1_2' style='width:40px' ><input name='f1_3' style='width:40px' readonly tabindex='-1'><input name='f1_4' style='width:25px' readonly tabindex='-1'><input name='f1_5' style='width:70px' readonly tabindex='-1'>
<label class="tab_page_label">照会開始日付</label>
<input name='f2_1' style='width:40px' readonly tabindex='-1'><input name='f2_2' style='width:25px' readonly tabindex='-1'><input name='f2_3' style='width:25px' readonly tabindex='-1'> ~

<input name='f3_1' style='width:40px' readonly tabindex='-1'><input name='f3_2' style='width:25px' readonly tabindex='-1'><input name='f3_3' style='width:25px' readonly tabindex='-1'>
<label class="tab_page_label"><script>w1('CURRENCYCD')</script></label>
<input name='f100'  style='width:40px' readonly ></input> <!--20160304fx add ---->
<br>

<input name='f4' type='hidden'>
<input name='f5' type='hidden'>
<input name='f6' type='hidden'>

<%
if (bParsingOK) {
%>
	&nbsp;
	<script>
/*	
	document.all.f1_3.value = <%= xp.xpd.node_value[2] %>;
	document.all.f1_4.value = <%= xp.xpd.node_value[3] %>;
	document.all.f1_5.value = padNumber(<%= xp.xpd.node_value[4] %>, 7);
	document.all.f2_1.value = padNumber(<%= xp.xpd.node_value[5] %>, 4);
	document.all.f2_2.value = padNumber(<%= xp.xpd.node_value[6] %>, 2);
	document.all.f2_3.value = padNumber(<%= xp.xpd.node_value[7] %>, 2);
	document.all.f3_1.value = padNumber(<%= xp.xpd.node_value[8] %>, 4);
	document.all.f3_2.value = padNumber(<%= xp.xpd.node_value[9] %>, 2);
	document.all.f3_3.value = padNumber(<%= xp.xpd.node_value[10]%>, 2);
	document.all.f4.value = <%= xp.xpd.node_value[11]%>;
*/
	restore("f1_1","p1_1");
	restore("f1_2","p1_2");
	restore("f1_3","p1_3");
	restore("f1_4","p1_4");
	restore("f1_5","p1_5");
	restore("f2_1","p2_1");
	restore("f2_2","p2_2");
	restore("f2_3","p2_3");
	restore("f3_1","p3_1");
	restore("f3_2","p3_2");
	restore("f3_3","p3_3");
	restore("f4","p4");
	
	setMsg("200007");
	
	</script>
	<style>
	.xTitle {border:1px outset;background-color:#c0c0c0 }
	.xInput {border:none;text-align:center; }
	</style>
	<table border="0" cellspacing="1" cellpadding="0" bgcolor="black" style="font-size:9pt">
	<tr bgcolor="darkgray">
		<td height="20px" align="center"  class=xTitle nowrap >順番&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;取引日付&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;起算日&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;取引番号&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;取引名称&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;利息区分&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;利息計算開始日&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;利息計算終了日&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;取引元金&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;利息発生日&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;利息発生取引番号&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;計算区分&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;月数&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;日数&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;適用利率&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;手数料区分&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;手数料&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;手数料発生日&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;手数料発生取引番号&nbsp;&nbsp;</td>
	</tr>

<%
	int nCount = Integer.parseInt(xp.xpd.node_value[14]);
	for (int i = 0; i < nCount; i++) {
%>
	<tr bgcolor="white" onDblClick="javascript:SetHiddenField<%= i %>()">
<!--順番-->		<td  height="20px" align="center"  width="50px" nowrap>&nbsp;&nbsp;<%= i + 1 %>&nbsp;&nbsp;</td>			
<!--取引日付-->		<td  align="center"  width="80px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.makeDate(xp.xpd.node_value[i * 19 + 15]) %>&nbsp;&nbsp;</td>
<!--起算日-->		<td  align="center"  width="80px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.makeDate(xp.xpd.node_value[i * 19 + 16]) %>&nbsp;&nbsp;</td>
<!--取引番号-->		<td  align="center"  width="80px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 19 + 17]) %>&nbsp;&nbsp;</td>
<!--取引名称-->		<td  align="left"    width="150px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 19 + 18]) %>&nbsp;&nbsp;</td>
<!--利息区分-->		<td  align="left"  width="200px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 19 + 19]) %>&nbsp;&nbsp;</td>
<!--利息計算開始日-->	<td  align="center"  width="100px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.makeDate(xp.xpd.node_value[i * 19 + 20]) %>&nbsp;&nbsp;</td>
<!--利息計算終了日-->	<td  align="center"  width="100px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.makeDate(xp.xpd.node_value[i * 19 + 21]) %>&nbsp;&nbsp;</td>

<!--取引元金-->		<td  align="right"   width="150px"	nowrap>&nbsp;&nbsp;<%= makemask7( "17.2",xp.xpd.node_value[i * 19 + 22],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td> <!-- fx 20160321---->
<!--利息-->		<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7 ("14.2",xp.xpd.node_value[i * 19 + 23],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>     <!-- fx 20160321---->

<!--利息発生日-->	<td  align="center"  width="100px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.makeDate(xp.xpd.node_value[i * 19 + 28]) %>&nbsp;&nbsp;</td><!-- 20210204 EK Add -->
<!--利息発生取引番号--><td  align="center"  width="80px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 19 + 29]) %>&nbsp;&nbsp;</td><!-- 20210204 EK Add -->

<!--計算区分-->		<td  align="center"  width="80px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 19 + 24]) %>&nbsp;&nbsp;</td>
<!--月数-->		<td  align="right"  width="40px"	nowrap>&nbsp;&nbsp;<%= Integer.parseInt(xp.xpd.node_value[i * 19 + 25]) %>&nbsp;&nbsp;</td>
<!--日数-->		<td  align="right"  width="40px"	nowrap>&nbsp;&nbsp;<%= Integer.parseInt(xp.xpd.node_value[i * 19 + 26]) %>&nbsp;&nbsp;</td>
<!--適用利率-->		<td  align="right"   width="80px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.checkValue ("03", "7.5", xp.xpd.node_value[i * 19 + 27]) %>&nbsp;&nbsp;</td>

<!--手数料区分-->		<td  align="left"  width="200px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 19 + 30]) %>&nbsp;&nbsp;</td><!-- 20210204 EK Add -->
<!--手数料-->		<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7 ("17.2",xp.xpd.node_value[i * 19 + 31],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td><!-- 20210204 EK Add -->
<!--手数料発生日-->	<td  align="center"  width="100px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.makeDate(xp.xpd.node_value[i * 19 + 32]) %>&nbsp;&nbsp;</td><!-- 20210204 EK Add -->
<!--手数料発生取引番号--><td  align="center"  width="80px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 19 + 33]) %>&nbsp;&nbsp;</td><!-- 20210204 EK Add -->
	</tr>

<%
	}
%>
	</table>
<%
}
xp = null;
%>
<br>
