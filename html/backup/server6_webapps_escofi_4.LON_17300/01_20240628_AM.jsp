<%@ page import="com.ek.web.xml.*" %>
<%@ page contentType="text/html; charset=Windows-31J" %>
<!-- SSO 対応 20181002 -->
<%  String acct_no = "";
    String acct_km = "";
    String acct_br = "";
    String sso = "0";
    String signon = (String)session.getAttribute("SIGNON");
    String accountId = (String)session.getAttribute("ACCTNO");
    String guarantyKbn = (String)session.getAttribute("GUAKBN");
    if( signon!=null && signon=="S" && accountId!="" ){ //20190116
        sso = "1";
    }
    if( sso=="1"&&accountId!=null&&guarantyKbn!=null ){
        if( accountId.length()==20 ){
            acct_no = accountId.substring(accountId.length()-7);
            acct_km = accountId.substring(accountId.length()-9,accountId.length()-7);
            acct_br = accountId.substring(accountId.length()-13,accountId.length()-9);
        }
    }
%>

<%!
public String strNullCheck (String sData) {
	return sData == null ? "" : sData;
}

public int nNullCheck (String sData) {
	return sData == null ? 0 : Integer.parseInt(sData);
}

public long lNullCheck (String sData) {
	return sData == null ? 0 : Long.parseLong(sData);
}

public double dNullCheck (String sData) {
	return sData == null ? 0 : Double.parseDouble(sData);
}

public String CutZeroTime (String sData) {
	return sData.substring (0, 2) + ":" + sData.substring (2, 4);
}

public String UserNum (String sData) {
	return sData.substring (sData.length () - 10, sData.length ());
}

public String AccountNum (String sData) {
	return sData.substring (7, 11) + "-" + sData.substring (11, 13) + "-" + sData.substring (13, 20);
}

public String ProductCode (String sData) {
	return sData.substring (0, 2) + "-" + sData.substring (2, 4) + "-" + sData.substring (4, 7) + "-" + sData.substring (7, 11);
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
	String xmlFile = request.getSession().getServletContext().getRealPath("/codeXml/4.LON/17300_01out.xml");
	System.out.println("xmlFile : "+xmlFile+"<br>");
	String oHeaderFile = request.getSession().getServletContext().getRealPath("/xml/OUT_HEADER.xml");
	System.out.println("header_xmlFile : "+oHeaderFile);
	
	String SCRIPTCHECK = strNullCheck (request.getParameter("SCRIPTCHECK"));
//	out.println("Script : ["+ SCRIPTCHECK +"]<br>");


	
	byte [] rcvMsg = null;
	String strOutMessage = null;
/* 20160706
	if ((String) application.getAttribute(request.getRemoteAddr()) != null)
	{	
		strOutMessage = (String) application.getAttribute(request.getRemoteAddr());
		application.removeAttribute(request.getRemoteAddr());
	}
	else
	{
		strOutMessage = null;
	}
*/
        String resultid = request.getParameter("RESULTID");
 		System.out.println("[17300_01]resultid:" + resultid );
        if ( resultid != null ){
             strOutMessage = (String) application.getAttribute(resultid);
             if( strOutMessage!=null ) application.removeAttribute(resultid);
        }

//		out.println ("out message : " + strOutMessage + "<p>");
	if (strOutMessage != null)
		rcvMsg = strOutMessage.getBytes ("MS932");
	strOutMessage = null;
	
//	out.println("Msg : ["+ new String(rcvMsg) +"]<br>");
	
	XmlParse1 xp = null;
	boolean bReceiveOK = false;
	boolean bParsingOK = false;
	
	if (rcvMsg != null) {
		
		try {
			xp = new XmlParse1();
		
			xp.init(xmlFile);
			xp.setOutHeaderFile(oHeaderFile);
			
			String strError1 = "";
			String strError2 = "";
			if (xp.setOutHeader(rcvMsg)) {
				strError1 = xp.oheader.node_value[34];
				strError2 = xp.oheader.node_value[33];
			}
	
			if ("000000".equals(strError1)) {
				if (xp.parseXml(rcvMsg)) {
					bParsingOK = true;
					bReceiveOK = true;
				} else {
					out.println(xp.getErrorMsg());
				}
			} else if ("E".equals (strError2) || "e".equals (strError2)) {
				;
			} else {
				// MQ ERROR
				bReceiveOK = true;
			}
		} catch (Exception e) {
		}
		rcvMsg = null;
	}
%>

<script>var trInXml = loadXML('/codeXml/4.LON/17300_01in.xml')</script>

<script>
var sys_date;
	function initPage() {
		//firstFocusField=document.all.f1_5;
              firstFocusField=document.all.f1_4;  // 202301013
		lastFocusField=document.all.f4;

		disablePrintBtn();
		sys_date=getIHeader("BIS_DATE");
		document.all.f3_1.value=sys_date.substr(0,4);
		document.all.f3_2.value=sys_date.substr(4,2);
		document.all.f3_3.value=sys_date.substr(6,2);

		<% if(bReceiveOK) {%>
			enablePrintBtn();

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

			setMsg("200007");	//20180119 再修正(分かち計算有りの場合計算根拠案内必要) -> 20231019 AMP_LOAN 対応で復元
//			setMsg("200348");　　　//20231019　AMP_LOAN対応（分かち計算照会を未使用）

			
		<% } else { %>
			setMsg("");
		<% } %>
                //SSO対応 20181002
                var acctkm = "<%= acct_km %>";
                var acctbr = "<%= acct_br %>";
                var ssoflag= "<%= sso %>";
                if( ssoflag=="1" && document.all.f1_5.value=="" ){ //20190116
                document.all.f1_4.value="<%= acct_km %>";
                document.all.f1_5.value="<%= acct_no %>";
                if( acctkm.length==2) document.all.f1_4.value=acctkm;
                if( acctbr.length==4) document.all.f1_3.value=acctbr;
                document.all.f2_1.value=sys_date.substr(0,4);
                document.all.f2_2.value=sys_date.substr(4,2);
                document.all.f2_3.value=sys_date.substr(6,2);
                document.all.f3_1.value=sys_date.substr(0,4);
                document.all.f3_2.value=sys_date.substr(4,2);
                document.all.f3_3.value=sys_date.substr(6,2);
                }
                firstFocusField=document.all.f1_4;

	}
	
	function checkPage(fieldArray){
//		debugInput();
		
		if(!dateCheck("f2_1","f2_2","f2_3")) return false;
		if(!dateCheck("f3_1","f3_2","f3_3")) return false;
		if(!dateCompare("f2_1","f2_2","f2_3","f3_1","f3_2","f3_3")) return false;
		if(!u_currDateComp()) return false;

		document.all.f1_5.value = padNumber(document.all.f1_5.value, 7);//20210204 EK Edit
		fieldArray["f1_5"] =document.all.f1_5.value;					//20210204 EK Edit

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
		push("p4",document.all.f4.value);	<!--SKIPNUM-->
		push("p5",document.all.f5.value);	<!--順番-->
//		push("p6",document.all.f6.value);	<!--分かち計算有無-->//20231019　AMP_LOAN対応（分かち計算照会を未使用）

		push("p1",document.all.p1.value);
		push("p2",document.all.p2.value);
		push("p3",document.all.p3.value);

		return true;
	}
	function flow() {
//		debugOutput();
		if(document.all.RTN_FLAG.value == 1){
			go();
		}else{
            //alert(document.all.f1_4.value+document.all.f1_5.value);
			go("02");
		}
		setMsg("253");
	}
function u_currDateComp() {
	var date1=document.all.f3_1.value+document.all.f3_2.value+document.all.f3_3.value;
	var date2=sys_date.substr(0,4)+sys_date.substr(4,2)+sys_date.substr(6,2);
	if (date1 > date2) {
		alertError("200093");
		setFocus(document.all.f3_1);
		return false;
	}
	return true;
}
</script>
<style>
	label.tab_page_label{display:inline-block;}
	.padding_ver_20{padding:20px 0;}
	.padding_hor_20{padding:0 20px;}
	input{box-sizing:border-box;}
</style>
<input type='hidden' name='code' value='01'>
<input type='hidden' name='RTN_FLAG' value='1'>
<button id=QUERY onclick="top.execute(document.all.trCode.value, '01')" style='border:1px inset;'><sup>F8</sup>&nbsp;照会</button>
<button id=TRANSACTION type=submit style=margin-left:20 onclick="disablePrintBtn();"><sup>F9</sup>&nbsp;実行</button>
<label class="tab_page_label" style='width:40px;'></label>
<button id=PRINT onclick="printPDF('17300_40600','/codeXml/4.LON/17300_01out.xml')"><sup>&nbsp;</sup>&nbsp;印刷</button>
<p>
<table cellpadding='0' cellspacing='0'>
<tr>
	<td><label class="tab_page_label">貸出口座番号</label></td>
	<td><input type='hidden' name='f1_1' style='width:40px'><input type='hidden' name='f1_2' style='width:40px'><input name='f1_3' style='width:40px'><input name='f1_4' style='width:25px'><input name='f1_5' style='width:70px'></td>
	<td><label class="tab_page_label">照会開始日付</label></td>
	<td><input name='f2_1' style='width:40px'><input name='f2_2' style='width:25px'><input name='f2_3' style='width:25px'> ~
		<input name='f3_1' style='width:40px'><input name='f3_2' style='width:25px'><input name='f3_3' style='width:25px'></td>

	<td><label class="tab_page_label"><script>w1('CURRENCYCD')</script></label></td>
	<td><input name='f100'  style='width:40px' readonly ></input><td> <!--20160304fx add ---->

</tr>
<tr>
	<td><label class="tab_page_label">SKIP-CNT</label></td>
	<td><input name='f4' style='width:45px'>
	<label class="tab_page_label" style='width:50px;text-align:right;'>総件数</label>
	<input name='p1' style='width:47px' readonly tabindex='-1'></td>
	<td><label class="tab_page_label">今回表示件数</label></td>
	<td><input name='p2' style='width:45px' readonly tabindex='-1'>件 ~
		<input name='p3' style='width:45px' readonly tabindex='-1'>件</td>
</tr>
</table>
<br>

<input name='f5' type='hidden'>
<input name='f6' type='hidden'>
</p>
<%
if (bParsingOK) {
%>
	&nbsp;
	<script>
	document.all.f4.value = <%= Integer.parseInt(xp.xpd.node_value[11]) %>;
	document.all.p1.value = <%= Integer.parseInt(xp.xpd.node_value[15]) %>;
	document.all.p2.value = <%= Integer.parseInt(xp.xpd.node_value[16]) %>;
	document.all.p3.value = <%= Integer.parseInt(xp.xpd.node_value[17]) %>;

	//20160331 fx add start
	var currcode = 	getOHeader("NATIONAL_CODE");
	document.all.f100.value = currcode;

	</script>
	<style>
	.xTitle {border:1px outset;background-color:#c0c0c0}
	.xInput {border:none;text-align:center; }
	</style>
	<table border="0" cellspacing="1" cellpadding="0" bgcolor="black" style="font-size:9pt;">
	<tr bgcolor="darkgray">
		<td height="20px" width="50px" align="center"  class=xTitle nowrap >順番&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;約定日付&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;取引日付&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;取引時刻&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;起算日&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;取引番号&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;取引名称&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;区分&nbsp;&nbsp;</td>
              <td align="center"  class=xTitle nowrap >&nbsp;&nbsp;口座種類&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;取引区分&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;受付チャネル&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;回次&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;約定利率&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;手数料&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;(合算)更新後残高&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;(合算)取引元利金&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;取引元利金&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;取引元金&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;約定利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;経過利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;延滞利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;約定未収利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;未払利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;戻し利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;減免約定利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;減免延滞利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;未収利息累計&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;更新後残高&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス取引元利金&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス取引元金&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス約定利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス分経過利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス延滞利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス約定未収利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス未払利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス戻し利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス減免約定利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス減免延滞利息&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス未収利息累計&nbsp;&nbsp;</td>
		<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;ボーナス更新後残高&nbsp;&nbsp;</td>
		<!--<td align="center"  class=xTitle nowrap >&nbsp;&nbsp;分かち計算有無&nbsp;&nbsp;</td> //20231019　AMP_LOAN対応（分かち計算照会を未使用）-->
	</tr>

<%
	int nCount = Integer.parseInt(xp.xpd.node_value[20]);
	for (int i = 0; i < nCount; i++) {
%>
		<script>
			function SetHiddenField<%= i %>() {
				<!--順番-->
				document.all.f5.value = '<%= xp.xpd.node_value[i * 42 + 21].trim() %>';
				<!--分かち計算有無-->//20231019　AMP_LOAN対応（分かち計算照会を未使用） START
//				document.all.f6.value = '<%= xp.xpd.node_value[i * 42 + 61].trim() %>';

//				if(document.all.f6.value=='Y') {				
//					document.all.RTN_FLAG.value = '2';
//					reloadInXML('/codeXml/4.LON/17300_02in.xml');
//					reloadOutXML('/codeXml/4.LON/17300_02out.xml');
	
//					enableExecBtn();
//					document.all.TRANSACTION.click();	
//					setMsg("");
//				} //20231019　AMP_LOAN対応（分かち計算照会を未使用） END
			}
		</script>

		<tr bgcolor="white" onDblClick="javascript:SetHiddenField<%= i %>()">
			<td  height="20px" align="center"  width="50px" nowrap>&nbsp;&nbsp;<%= i + 1 %>&nbsp;&nbsp;</td>			
			<td  align="center"  width="80px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.makeDate(xp.xpd.node_value[i * 42 + 22]) %>&nbsp;&nbsp;</td>
			<td  align="center"  width="80px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.makeDate(xp.xpd.node_value[i * 42 + 23]) %>&nbsp;&nbsp;</td>
			<td  align="center"  width="70px"	nowrap>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= CutZeroTime(xp.xpd.node_value[i * 42 + 24]) %>&nbsp;&nbsp;</td>
			<td  align="center"  width="90px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.makeDate(xp.xpd.node_value[i * 42 + 25]) %>&nbsp;&nbsp;</td>
			<td  align="center"  width="90px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 42 + 26].trim()) %>&nbsp;&nbsp;</td>
			<td  align="left"    width="200px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 42 + 27].trim()) %>&nbsp;&nbsp;</td>
			<td  align="left"    width="200px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 42 + 28].trim()) %>&nbsp;&nbsp;</td>
			<td  align="left"    width="100px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 42 + 62].trim()) %>&nbsp;&nbsp;</td>
			<td  align="center"  width="100px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 42 + 30].trim()) %>&nbsp;&nbsp;</td>
			<td  align="center"  width="100px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 42 + 31].trim()) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="50px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.nNullCheck(xp.xpd.node_value[i * 42 + 32]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="90px"	nowrap>&nbsp;&nbsp;<%= XmlUtil.checkValue ("03", "7.5", xp.xpd.node_value[i * 42 + 33]) %>&nbsp;&nbsp;</td>    <!-- fx 20160321---->
			<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 34],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="110px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 35],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 36],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 37],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 38],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 39],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 40],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 41],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 42],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 43],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
		  	<td  align="right"   width="100px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 44],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
	 		<td  align="right"   width="110px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 45],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="110px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 46],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="110px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 47],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="120px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 48],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="120px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 49],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="120px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 50],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="120px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 51],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="130px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 52],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="120px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 53],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="130px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 54],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="120px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 55],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="120px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 56],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="150px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 57],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="150px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 58],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="150px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 59],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<td  align="right"   width="150px"	nowrap>&nbsp;&nbsp;<%= makemask7( "14.2",xp.xpd.node_value[i * 42 + 60],xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>
			<!--<td  align="center"  width="100px"	nowrap>&nbsp;&nbsp;<%= (xp.xpd.node_value[i * 42 + 61].trim())  %>&nbsp;&nbsp;</td> <!-- fx 20160321---->
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
