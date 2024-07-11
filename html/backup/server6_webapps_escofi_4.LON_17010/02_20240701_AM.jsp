<%@ page contentType="text/html;charset=Windows-31J" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ek.util.*" %>
<%@ page import="com.ek.web.core.*" %>
<%@ page import="com.ek.web.util.*" %>
<%@ page import="com.ek.web.xml.*" %>


<%!
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
	response.setContentType("text/html; charset=Windows-31J");
	//==============================================================================//
	String xmlFile = request.getSession().getServletContext().getRealPath("/codeXml/4.LON/17010_01out.xml");
	String oHeaderFile = request.getSession().getServletContext().getRealPath("/xml/OUT_HEADER.xml");
	//==============================================================================//
	byte [] rcvMsg = null;
	String strOutMessage = null;

//	if ((String) application.getAttribute(request.getRequestedSessionId()) != null)	{
//		strOutMessage = (String) application.getAttribute(request.getRequestedSessionId());
//		application.removeAttribute(request.getRequestedSessionId());
//	}
//	if ((String) application.getAttribute(request.getSession().getId()) != null)	{
//		strOutMessage = (String) application.getAttribute(request.getSession().getId());
//		application.removeAttribute(request.getSession().getId());
//	}
        String resultid = request.getParameter("RESULTID");
        if ( resultid != null ){
          strOutMessage = (String) application.getAttribute(resultid);
          if( strOutMessage!=null ) application.removeAttribute(resultid);
        }

        System.out.println("[17010]resultid:" + resultid );
//        out.println("result id:" + request.getParameter("RESULTID"));
//        out.println("session id:" + request.getRequestedSessionId() );
	if ( strOutMessage != null ) {
		rcvMsg = strOutMessage.getBytes ("MS932");
               //out.println("[17010]BODY:" + strOutMessage.substring(300) );
	}
	if (rcvMsg != null) {

		System.out.println("[17010]xmlFile:" + xmlFile );
		System.out.println("[17010]oHeaderFile:" + oHeaderFile );

		String strError = "";

		XmlParse1 xp = new XmlParse1();
		xp.init(xmlFile);
		xp.setOutHeaderFile(oHeaderFile);
		if (xp.setOutHeader(rcvMsg)) {
			System.out.println("[17010]oheader.node_value:" + xp.oheader.node_value );
			strError = xp.oheader.node_value[34];
		}

		if ("000000".compareTo(strError) == 0) {
			if (xp.parseXml(rcvMsg)) {	
			
%>


<script>var trInXml = loadXML('/codeXml/4.LON/17010_01out.xml')</script>
<script>var trOutXml = loadXML('/codeXml/4.LON/17010_01out.xml')</script>
<script>

	function initPage() {
		//帳票用アウトプットメッセージ設定
        //20230913 AMP_LOAN文字化け対応
		top.hiddenFrame.resultString='<%=new String(rcvMsg,"MS932")%>';
		
		//項目初期化
		 var accidentRegCnt = <%= XmlUtil.nNullCheck(xp.xpd.node_value[324])%>;
		 if(accidentRegCnt==0){
			document.all['regInfo1'].style.visibility="visible";
			document.all['regInfo2'].style.visibility="hidden";
			document.all['regInfo3'].style.visibility="hidden";
		 }else if(accidentRegCnt==1){
			document.all['regInfo1'].style.visibility="visible";
			document.all['regInfo2'].style.visibility="hidden";
			document.all['regInfo3'].style.visibility="hidden";
		 }else if(accidentRegCnt==2){
			document.all['regInfo1'].style.visibility="visible";
			document.all['regInfo2'].style.visibility="visible";
			document.all['regInfo3'].style.visibility="hidden";
		 }else if(accidentRegCnt>=3){
			document.all['regInfo1'].style.visibility="visible";
			document.all['regInfo2'].style.visibility="visible";
			document.all['regInfo3'].style.visibility="visible";
		}

		disableExecBtn();
		u_enabledField(4,255,true);

              //231222 add
              document.all.feeButton.disabled=true;
              document.all.intButton.disabled=true;                          
<%		
	//20210204 EK Edit Start - Session Varialbe Set
		String BACKBTN_FLAG = "Y" ;
		HttpSession thisSession = request.getSession(true);
		thisSession.setAttribute("BACKBTN_FLAG", BACKBTN_FLAG);
	//20210204 EK Edit End 
%>

		mSelect();

		var i = 0;
		for (i = 0; i < document.all.f310.options.length; i++) {
			if (document.all.f310.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[59]) %>')
				document.all.f310.options[i].selected = true;
			else document.all.f310.options[i].selected = false;
		}
		for (i = 0; i < document.all.f77.options.length; i++) {
			if (document.all.f77.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[112]) %>')
				document.all.f77.options[i].selected = true;
			else document.all.f77.options[i].selected = false;
		}
		for (i = 0; i < document.all.f78.options.length; i++) {
			if (document.all.f78.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[113]) %>')
				document.all.f78.options[i].selected = true;
			else document.all.f78.options[i].selected = false;
		}
		for (i = 0; i < document.all.f411.options.length; i++) {
			if (document.all.f411.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[116]) %>')
				document.all.f411.options[i].selected = true;
			else document.all.f411.options[i].selected = false;
		}
		for (i = 0; i < document.all.f144.options.length; i++) {
			if (document.all.f144.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[192]) %>')
				document.all.f144.options[i].selected = true;
			else document.all.f144.options[i].selected = false;
		}
		for (i = 0; i < document.all.f145.options.length; i++) {
			if (document.all.f145.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[193]) %>')
				document.all.f145.options[i].selected = true;
			else document.all.f145.options[i].selected = false;
		}
		for (i = 0; i < document.all.f148.options.length; i++) {
			if (document.all.f148.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[196]) %>')
				document.all.f148.options[i].selected = true;
			else document.all.f148.options[i].selected = false;
		}
		for (i = 0; i < document.all.f149.options.length; i++) {
			if (document.all.f149.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[197]) %>')
				document.all.f149.options[i].selected = true;
			else document.all.f149.options[i].selected = false;
		}
		for (i = 0; i < document.all.f240.options.length; i++) {
			if (document.all.f240.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[293]) %>')
				document.all.f240.options[i].selected = true;
			else document.all.f240.options[i].selected = false;
		}


		<!-- 市場１～５ -->
		for (i = 0; i < document.all.f350.options.length; i++) {
			if (document.all.f350.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[331]) %>')
				document.all.f350.options[i].selected = true;
			else document.all.f350.options[i].selected = false;
		}
		for (i = 0; i < document.all.f351.options.length; i++) {
			if (document.all.f351.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[332]) %>')
				document.all.f351.options[i].selected = true;
			else document.all.f351.options[i].selected = false;
		}
		for (i = 0; i < document.all.f352.options.length; i++) {
			if (document.all.f352.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[333]) %>')
				document.all.f352.options[i].selected = true;
			else document.all.f352.options[i].selected = false;
		}
		for (i = 0; i < document.all.f353.options.length; i++) {
			if (document.all.f353.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[334]) %>')
				document.all.f353.options[i].selected = true;
			else document.all.f353.options[i].selected = false;
		}
		for (i = 0; i < document.all.f354.options.length; i++) {
			if (document.all.f354.options[i].value == '<%= XmlUtil.nNullCheck(xp.xpd.node_value[335]) %>')
				document.all.f354.options[i].selected = true;
			else document.all.f354.options[i].selected = false;
		}
		<!-- 通貨コード -->
		for (i = 0; i < document.all.f361.options.length; i++) {
			if (document.all.f361.options[i].value == '<%= xp.xpd.node_value[342] %>')
				document.all.f361.options[i].selected = true;
			else document.all.f361.options[i].selected = false;
		}


		document.all.f310.disabled=true;
		document.all.f411.disabled=true;
		document.all.f602.disabled=true;
		document.all.f98_1.disabled=true;
		document.all.f98_2.disabled=true;
		document.all.f907.disabled=true;

		u_addrTrim("f21");

		var f6=document.all.f6.value;
		var f25=document.all.f25.value;
		var f41=document.all.f41.value;
		var f42=document.all.f42.value;
		var f43=document.all.f43.value;
		var f114=document.all.f114.value;
		
		document.all.f6.value=padNumber(f6,2);
		document.all.f25.value=padNumber(f25,2);
		document.all.f41.value=padNumber(f41,10);
		document.all.f42.value=padNumber(f42,10);
		document.all.f43.value=padNumber(f43,10);
		document.all.f114.value=padNumber(f114,2);

		document.all.f121.value = document.all.f121.value == 0 ? "" : padNumber(document.all.f121.value,4);
		document.all.f124.value = document.all.f124.value == 0 ? "" : padNumber(document.all.f124.value,4);
		document.all.f175.value = document.all.f175.value == 00000 ? "" : padNumber(document.all.f175.value,5);
		


		u_zeroCheck("f25","f35","f37","f41","f42","f43","f51","f52","f79","f80","f81","f82","f88","f114","f298","f300");
		u_zeroCheck("f99","f100","f101","f102","f103","f104","f105","f106","f107","f108","f120","f126","f128","f134","f136","f138","f140","f142","f146","f147","f150","f183","f199","f240","f241","f242","f243","f244","f247");
		//,"f151","f152"
		
		set_basic("f79");
		set_basic("f80");

		if(document.all.f114.value=="" || document.all.f114.value=="0") {document.all.f115.value="";}

		if(document.all.f106.value == 'NaN') {
			document.all.f106.value = "";
		}

		//20210204 EK Edit Start
		if((document.all.f365.value == 0) && (document.all.f363.value >= document.all.f910.value)){
			document.all.f365.value = "";
			document.all.f366.value = "";
		}
		//20210204 EK Edit End

		setMsg("200007");
		enableAllBtn();
		document.all.PRINT.disabled=false;
              //20231222 
              if(document.all.f367.value != 0 && document.all.f367.value != " ")
                     document.all.feeButton.disabled=false;
              if(document.all.f368.value != 0 && document.all.f368.value != " ")
                     document.all.intButton.disabled=false;
	}
	function checkPage(fieldArray){
		return true;
	}
	function flow() {
		//20210204 EK Edit Start
		top.document.all.trCode.value= document.all.trCode.value;
		top.document.all.subTitle.innerHTML =top.getTitle(document.all.trCode.value);
		//20210204 EK Edit End
		go();
	}

	function u_setFields(a,b) {
		for(var i=a;i<=b;i++) {
			if(i==111 || i==151 || i==152 || i==186 || i==201) continue;
		set("f"+i,"f"+i);
		}
	}
	function u_enabledField(a,b,c) {
		for(i=a;i<=b;i++) {
			if(i!=147){
				if(!document.all["f"+i]) {
					for(j=1;j<=5;j++) {
						if(!document.all["f"+i+"_"+j]) {break;}
						if(document.all["f"+i+"_"+j].type.indexOf("text")!=-1) {
							document.all["f"+i+"_"+j].readOnly=c;
							document.all["f"+i+"_"+j].tabIndex="-1";
						} else {
							document.all["f"+i+"_"+j].disabled=c;
						}
					}
					continue;
				}
				if(document.all["f"+i].type.indexOf("text")!=-1) {
					document.all["f"+i].readOnly=c;
					document.all["f"+i].tabIndex="-1";
				} else {
					document.all["f"+i].disabled=c;
				}
			}
		}
	}
	function u_addrTrim(field) {
		var obj=document.all[field];
		if(obj.value!="") {
			var addr=obj.value;
			var tmp=addr.split(" ");
			var rStr=trim(tmp[0]);
			for(var i=1;i<tmp.length;i++) {
				var temp=trim(tmp[i]);
				if(temp!="") {
					rStr+=" "+temp;
				}
			}
			obj.value=rStr;
		}
	}

    /*
    d -> formatYYYYMMDD();
    a -> formatAccount();
    c -> formatCounsel();
    z -> formatZip();
    p -> formatProduct();
    f -> .
    */
	function u_formPattern() {
		var flg=arguments[0];
		var args_len=arguments.length;
		for(var i=1;i<args_len;i++) {
			var arg=arguments[i];
			var v_field="f"+arg;
			var v_obj=eval("document.all['"+v_field+"']");
			if(v_obj.length>1) {
				for(k=0;k<v_obj.length;k++) {
					r_dt=v_obj[k].value;
					switch(flg) {
						case "d":
							v_obj[k].value=r_dt.formatYYYYMMDD();
							break;
						case "c":
							v_obj[k].value=r_dt.formatCounsel();
							break;
						case "a":
							v_obj[k].value=r_dt.formatAccount();
							break;
						case "z":
							v_obj[k].value=r_dt.formatZip();
							break;
						case "p":
							v_obj[k].value=r_dt.formatProduct();
							break;
						case "f":
							v_obj[k].value=r_dt.substr(10);
							break;
					}
				}
			} else {
				var r_dt=v_obj.value;
				switch(flg) {
					case "d":
						v_obj.value=r_dt.formatYYYYMMDD();
						break;
					case "c":
						v_obj.value=r_dt.formatCounsel();
						break;
					case "a":
						v_obj.value=r_dt.formatAccount();
						break;
					case "z":
						v_obj.value=r_dt.formatZip();
						break;
					case "p":
						v_obj.value=r_dt.formatProduct();
						break;
					case "f":
						v_obj.value=r_dt.substr(10);
						break;
				}
			}
		}
	}
	function u_elemSize() {
		var siz=arguments[0];
		var args_len=arguments.length;
		for(var i=1;i<args_len;i++) {
			var args=arguments[i];
			var v_field="f"+args;
			var v_obj=eval("document.all['"+v_field+"']");
			if(v_obj.type.indexOf("text")!='-1') {
				v_obj.style.width=siz;
			}
		}
	}
	function u_elem_Size(a,b,c) {
		var e=c-b+1;
		for(var i=0;i<e;i++) {
			var r_field="f"+b;
			var r_obj=eval("document.all['"+r_field+"']");
			if(r_obj.type.indexOf("text")!='-1') {
				r_obj.style.width=a;
			}
			b++;
		}
	}
	function u_zeroCheck() {
		var len=arguments.length;
		for(var i=0;i<len;i++) {
			var obj=document.all[arguments[i]];
			if(parseInt(parseFloat(obj.value))=="0") obj.value="";
		}
	}
	function getCaptPayBackCycl(){
        node =  top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 505 and @CODE_5="+
                <%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[114]) %>+
                " and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
        document.all.f79Lbl.value =  node.getAttribute("CODE_NAME");
	}
/*	function getCaptPayBackCycl(){
        node =  top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 505 and @CODE_5="+
                <%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[114]) %>+
                " and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
        document.all.f79Lbl.value =  node.getAttribute("CODE_NAME");
	}
       */
	function getIntpayBackCycl(){
		node =  top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 504 and @CODE_5="+
		        <%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[115]) %>+
                " and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		document.all.f80Lbl.value =  node.getAttribute("CODE_NAME");
	}
	//帳票出力用 Popup
	function createReportSelectWindow(){
		var url = top.CONTEXT+"/4.LON/17010/process2.jsp";
		var args = this;


		//newWin = window.open(url, "new", "left=400,top=250,width=400,height=300,resizable=no,alwaysRaised=yes,dependent=on");
		//newWin = window.open(url, "new", "left=400,top=250,width=400,height=320,resizable=no,alwaysRaised=yes,dependent=on");
	//20240102 EK Edit Start
		newWin = window.open(url, "new", "left=400,top=250,width=400,height=340,resizable=no,alwaysRaised=yes,dependent=on");
	//20240102 EK Edit End
		newWin.focus();
	}

	function mSelect() {
		/* //origin
		var str= document.all.f361.outerHTML;
		str = str.substring(0,str.indexOf(">")+1);
		var children = top.LNPCURR.selectNodes(".//record[@STA=1 ]");
		str += "<OPTION value=''></OPTION>";
		
		for(var j=0;j<children.length;j++) {
			str += "<OPTION value='" + children[j].getAttribute("CURR_CODE") + "'>" + children[j].getAttribute("CURR_CODE") + "</OPTION>";
		}
		
		str += "</SELECT>";
		document.all.f361.outerHTML = str;
		*/
		var str= document.all.f361.outerHTML;
		str = str.substring(0,str.indexOf(">")+1);
		var node_root = ".//record[@STA=1 ]";
		var children = top.LNPCURR.evaluate(node_root, top.LNPCURR, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);	
		str += "<OPTION value=''></OPTION>";
		
		for(var j=0;j<children.snapshotLength;j++) {
			var child = children.snapshotItem(j);
			str += "<OPTION value='" + child.getAttribute("CURR_CODE") + "'>" + child.getAttribute("CURR_CODE") + "</OPTION>";
			console.log("child : " + child.getAttribute("CURR_CODE"));
		}
		
		str += "</SELECT>";
		document.all.f361.outerHTML = str;

		console.log('children = '+children);
	}

	//20210204 EK Edit Start
	function u_go_17610(){
		var acct='<%=xp.xpd.node_value[13]%>';
		document.all.z1_1.value = acct.substring(0,3);
		document.all.z1_2.value = acct.substring(3,7);
		document.all.z1_3.value = acct.substring(7,11);
		document.all.z1_4.value = acct.substring(11,13);
		document.all.z1_5.value = acct.substring(13,20);
		document.all.z2.value = 99;
		document.all.z3.value = '04';

		document.all.trCode.value = '17610';
		document.all.code.value='02';
		document.all.RTN_FLAG.value = '1';
		reloadInXML('/codeXml/4.LON/17610_01_01in.xml');
		reloadOutXML('/codeXml/4.LON/17610_01out.xml');
		document.all.TRANSACTION.disabled = false;
		if(document.all.TRANSACTION.disabled == false){
			document.all.TRANSACTION.click();
			//20210309 EK Edit Start
			//top.document.all.trCode.value= document.all.trCode.value; 
			//top.document.all.subTitle.innerHTML =top.getTitle(document.all.trCode.value);
			//20210309 EK Edit End
		}
		document.all.TRANSACTION.disabled = true;
	}
	function u_go_17620(){
		var acct='<%=xp.xpd.node_value[13]%>';
		document.all.z1_1.value = acct.substring(0,3);
		document.all.z1_2.value = acct.substring(3,7);
		document.all.z1_3.value = acct.substring(7,11);
		document.all.z1_4.value = acct.substring(11,13);
		document.all.z1_5.value = acct.substring(13,20);
		document.all.z2.value = 99;
		document.all.z3.value = '04';

		document.all.trCode.value = '17620';
		document.all.code.value='02';
		document.all.RTN_FLAG.value = '1';
		reloadInXML('/codeXml/4.LON/17620_01_01in.xml');
		reloadOutXML('/codeXml/4.LON/17620_01out.xml');
		document.all.TRANSACTION.disabled = false;
		if(document.all.TRANSACTION.disabled == false){
			document.all.TRANSACTION.click();
			//20210309 EK Edit Start
			//top.document.all.trCode.value= document.all.trCode.value; //20210309 EK Edit
			//top.document.all.subTitle.innerHTML =top.getTitle(document.all.trCode.value); //20210309 EK Edit
			//20210309 EK Edit End
		}
		document.all.TRANSACTION.disabled = true;
	}
	//20210204 EK Edit End
</script>
<input type='hidden' name='code' value='02'>
<input type='hidden' name='RTN_FLAG' value='1'>
<button id=QUERY onclick="top.execute(document.all.trCode.value, '01')" style='border:1px inset;' disabled><sup>F8</sup>&nbsp;照会</button>
<button id=TRANSACTION type=submit style="margin-left:20px" disabled=true><sup>F9</sup>&nbsp;実行</button>
<!--印刷用サブWindows追加--><label style='width:40px'></label>
<button id=PRINT onclick=createReportSelectWindow()><sup>&nbsp;</sup>&nbsp;印刷</button>

<iframe name=popup width=0 height=0 style="width:0; height:0; border:0;">
</iframe>
<%          /*	out.println("<table border=0 cellspacing=1 cellpadding=0 bgcolor=black>");
				for (int i = 0; i < xp.xpd.node_value.length; i++) {
					out.println("<tr><td width=100 align=center>"+i+"</td><td>&nbsp;'"+xp.xpd.node_value[i]+"'</td></tr>");
				}
				out.println("</table>");	*/

			/*	2020/10/31 Nonbank対応によっ約定返済TAB追加 ngrid0 = 346→355変更	*/
            	int ngrid0 = 355;	
				int ngrid1 = ngrid0 + (XmlUtil.nNullCheck(xp.xpd.node_value[ngrid0])* 4) + 4; //f265
				int ngrid2 = ngrid1 + (XmlUtil.nNullCheck(xp.xpd.node_value[ngrid1])* 4) + 3; //f272
				int ngrid3 = ngrid2 + (XmlUtil.nNullCheck(xp.xpd.node_value[ngrid2])* 4) + 3; //f279
				int ngrid4 = ngrid3 + (XmlUtil.nNullCheck(xp.xpd.node_value[ngrid3])* 5) + 3; //f288
				int ngrid5 = ngrid4 + (XmlUtil.nNullCheck(xp.xpd.node_value[ngrid4])* 4) + 3; //f399
				int ngrid6 = ngrid5 + (XmlUtil.nNullCheck(xp.xpd.node_value[ngrid5])* 7) + 3; //f414
				int ngrid7 = ngrid6 + (XmlUtil.nNullCheck(xp.xpd.node_value[ngrid6])* 4) + 3; //f252
				int ngrid8 = ngrid7 + (XmlUtil.nNullCheck(xp.xpd.node_value[ngrid7])* 3) + 4; //f322
				int ngrid9 = ngrid8 + (XmlUtil.nNullCheck(xp.xpd.node_value[ngrid8])*13) + 4; //f342 //ADD

			/*	out.println("<br><br>");
				out.println("ngrid0 : " + ngrid0+"/'"+xp.xpd.node_value[ngrid0]+"'<br>");
				out.println("ngrid1 : " + ngrid1+"/'"+xp.xpd.node_value[ngrid1]+"'<br>");
				out.println("ngrid2 : " + ngrid2+"/'"+xp.xpd.node_value[ngrid2]+"'<br>");
				out.println("ngrid3 : " + ngrid3+"/'"+xp.xpd.node_value[ngrid3]+"'<br>");
				out.println("ngrid4 : " + ngrid4+"/'"+xp.xpd.node_value[ngrid4]+"'<br>");
				out.println("ngrid5 : " + ngrid5+"/'"+xp.xpd.node_value[ngrid5]+"'<br>");
				out.println("ngrid6 : " + ngrid6+"/'"+xp.xpd.node_value[ngrid6]+"'<br>");
				out.println("ngrid7 : " + ngrid7+"/'"+xp.xpd.node_value[ngrid7]+"'<br>");
				out.println("ngrid8 : " + ngrid8+"/'"+xp.xpd.node_value[ngrid8]+"'<br>");
				out.println("ngrid9 : " + ngrid9+"/'"+xp.xpd.node_value[ngrid9]+"'<br>");	*/

				String strTemp = "";
				int startpoint = 13;
%>
<div style="padding:20px 0">
<table cellpadding='0' cellspacing='0'>
<tr>
	<td><label style='display:inline-block;width:90px'>貸出口座番号</label></td>
	<td><input name='f4' style='width:115px' value="<%= XmlUtil.dataPattern("a",xp.xpd.node_value[startpoint++],0) %>"></td>
	<!--予約取引追加-->
    <td><label style='display:inline-block;width:60px'>予約取引</label></td>
	<td><input name='f801' style='width:130px' readonly tabindex='-1' value="<%= xp.xpd.node_value[307] %>"></td>
	<td><label style='display:inline-block;width:60px'>相談番号</label></td>
	<td><input name='f5' style='width:140px' value="<%= XmlUtil.dataPattern("c",xp.xpd.node_value[startpoint++],0) %>"></td>
	<td><label style='display:inline-block;width:70px;'>状態コード</label></td>
	<td><input name='f6' style='width:25px' value="<%= xp.xpd.node_value[startpoint++] %>"><input name='f7' style='width:calc(100% - 41px); min-width:100px;' value="<%= xp.xpd.node_value[startpoint++] %>"></td>
</tr>
<tr>
	<td><label style='display:inline-block;width:90px'>管理店番</label></td>
	<td colspan='3' ><input name='f8' style='width:40px' value="<%= xp.xpd.node_value[startpoint++] %>"><input name='f9' style='width: calc(100% - 67px); min-width:270px;' value="<%= xp.xpd.node_value[startpoint++] %>"></td>
	<td style='margin-left:25px'><label style='display:inline-block;width:60px;'>情報店</label></td>
	<td colspan='3'><input name='f10' style='width:40px' value="<%= xp.xpd.node_value[startpoint++].trim() %>"><input name='f11' style='width: calc(100% - 56px); min-width:300px;' value="<%= xp.xpd.node_value[startpoint++] %>"></td>
</tr>
<tr>
	<td><label style='display:inline-block;width:90px'>商品コード</label></td>


	<td colspan='6'><input name='f12' style='width:100px' value="<%= XmlUtil.dataPattern("p",xp.xpd.node_value[startpoint++],0) %>"><input name='f13' style='width:480px' value="<%= xp.xpd.node_value[startpoint++] %>"></td>
	<td><label style='display:inline-block;width:65px;'>通貨コード</label><select style='width:61px;' name='f361' disabled=true></select></td> <!-- XmlUtil.nNullCheck(xp.xpd.node_value[333]) !-->


</tr>
</table>
</div>
<!-------------------------------------------------------------------------------------------------->

<div class=TabUI>
<span id=tabItems class='TabItem'>基本情報</span>
<span id=tabItems class='TabItem'>詳細情報1</span>
<span id=tabItems class='TabItem'>詳細情報2</span>
<span id=tabItems class='TabItem'>詳細情報3</span>
<span id=tabItems class='TabItem'>詳細情報4</span>
<span id=tabItems class='TabItem'>貸出登録情報</span>
<span id=tabItems class='TabItem'>優遇金利</span>
<span id=tabItems class='TabItem'>証明書継続発行情報</span>
<span id=tabItems class='TabItem'>分割実行明細情報</span>
<span id=tabItems class='TabItem'>極度取引情報</span>
<span id=tabItems class='TabItem'>不均等返済額情報</span>


<span id=tabItems class='TabItem'>外貨情報</span>
<span id=tabItems class='TabItem'>約定返済</span>


</div>

<style>
<!--
.xTitle {border:1px outset;background-color:#c0c0c0;font-size:9pt }
.xInput {border:none;text-align:center; }
//-->
</style>

<!-- 1st tab : 基本情報 ---------------------------------------------------------------------------->
<%					startpoint = 24;	%>
<div id=tabPages class='TabPage padding_ver_20'>
<table border=0 cellpadding='0' cellspacing='0'>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">顧客番号</label></td>
	<td colspan='3'><input name='f14' style='width:80px' value="<%= XmlUtil.dataPattern("f",xp.xpd.node_value[24],10) %>"><!--顧客名（カナ）--><input name='f15' style='width:620px' value="<%= xp.xpd.node_value[25] %>"></td>
</tr>
<tr>
	<td nowrap>&nbsp;</td>
	<td colspan='3'><!--顧客名（漢字）--><input name='f500' style='margin-left:80px;width:620px' readonly tabindex='-1' value="<%= xp.xpd.node_value[26].trim() %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">生年月日</label></td>
	<td><input name='f16' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[27]) %>"></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">職業コード</label></td>
	<td><input name='f17' style='width:40px' value="<%= xp.xpd.node_value[28].trim() %>"><input name='f18' style='width:215px;' value="<%= xp.xpd.node_value[29].trim() %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">業種コード</label></td>
	<td><input name='f293' style='width:80px' value="<%= xp.xpd.node_value[31].trim() %>" readonly tabindex='-1'><input name='f294' style='width:240px' value="<%= xp.xpd.node_value[32].trim() %>" readonly tabindex='-1'></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">企業体規模</label></td>
	<td><input name='f19' style='width:150px' value="<%= xp.xpd.node_value[30].trim() %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">住所</label></td>
	<td colspan='3'><input name='f20' style='width:80px' value="<%= XmlUtil.dataPattern("z",xp.xpd.node_value[33],0) %>"><input name='f21' style='width:620px' value="<%= xp.xpd.node_value[34].trim() %>"></td>
</tr>
<tr>
	<td>&nbsp;</td>
<%
         // 20151125 20160329 全角特殊文字使える
         //byte[] f521val = xp.xpd.node_value[35].getBytes("MS932");
         //xp.xpd.node_value[35] = new String(f521val);
%>
	<td colspan='3'><input name='f521' style='width:700px' value="<%= xp.xpd.node_value[35].trim() %>" readonly tabindex='-1'></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">電話番号</label></td>
	<td><input name='f22' style='width:110px' value="<%= xp.xpd.node_value[36].trim() %>"></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">取引中止</label></td>
	<td><input name='f25' style='width:25px' value="<%= xp.xpd.node_value[41] %>"><input name='f26' style='width:230px;' value="<%= xp.xpd.node_value[42] %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">引落口座 CIF</label></td>
<%
	String f23 = xp.xpd.node_value[37].trim();
//20181021 String f23 = xp.xpd.node_value[37].substring(10,20);    //CIF →２０Ｂｙｔｅ表示する。
%>
	<td><input name='f23' style='width:150px' value="<%= f23 %>"><input type='hidden' name="f296" style='width:200px' value="<%= xp.xpd.node_value[38] %>"></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">引落口座番号</label></td>
	<td><input name='f24' style='width:150px' readonly value="<%= XmlUtil.dataPattern("a2",xp.xpd.node_value[39],0) %>"></td>
</tr>

<!-- ↓↓↓ 2018/12/05 EK START ↓↓↓ -->
<tr>
	<td></td><td></td>
	<!-- <td nowrap style='text-align:right;'><label>振込先口座番号</label></td> -->
	<td><input name='f700' style='width:150px' readonly value="<%= XmlUtil.dataPattern("a2",xp.xpd.node_value[40],0) %>" type='hidden'></td>
</tr>
<!-- ↑↑↑ 2018/12/05 EK END ↑↑↑ -->

<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">受信ＣＩＦ番号</label></td>
<%
	String f501 = xp.xpd.node_value[43].substring(10,20);
%>
	<td><input name='f501' style='width:80px' value="<%= f501 %>" readonly tabindex='-1'></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">自振契約有無</label></td>
	<td><input type='checkbox' name='f502' style='margin-left:-4px' disabled <%= xp.xpd.node_value[44].compareTo("1") == 0 ? "checked" : "" %>></td>
</tr>
<!--事故登録 情報追加-->
<tr id=regInfo1>
	<td nowrap style='text-align:right;'><label class="tab_page_label">事故情報登録</label></td>
	<td colspan='3'><input name='f901' style='width:40px'  value="<%= xp.xpd.node_value[320] %>" readonly tabindex='-1'><input name='f902' style='width:400px' value="<%=  xp.xpd.node_value[321]%>" readonly tabindex='-1' type=text></td>
</tr>
<tr id="regInfo2" >
	<td nowrap style='text-align:right;'><label></label></td>
	<td colspan='3'><input name='f903' style='width:40px'  value="<%= xp.xpd.node_value[322] %>" readonly tabindex='-1'><input name='f904' style='width:400px' value="<%=  xp.xpd.node_value[323]%>" readonly tabindex='-1' type=text></td>
</tr>
<tr id="regInfo3" >
	<td nowrap style='text-align:right;'><label></label></td>
	<td >他有、詳細は【62300】事故情報登録照会</td>
</tr>
</table>
</div>


<!-- 2nd tab : 詳細情報1 --------------------------------------------------------------------------->
<%					startpoint = 54;	%>
<div id=tabPages class='TabPage padding_ver_20'>
<table cellpadding='0' cellspacing='0' style='margin-left:2px'>
<tr>
	<td nowrap style='text-align:right;'><label>口座区分</label></td>
	<td><input name='f27' style='width:130px' value="<%= xp.xpd.node_value[startpoint++].trim() %>"></td>
	<td nowrap style='text-align:right;'><label>新規区分</label></td>
	<td><input name='f28' style='width:130px' value="<%= xp.xpd.node_value[startpoint++].trim() %>"></td>
	<td nowrap style='text-align:right;'><label>貸出実行方法</label></td>
	<td><input name='f29' style='width:130px' value="<%= xp.xpd.node_value[startpoint++].trim() %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label>稟議区分</label></td>
	<td><input name='f30' style='width:130px' value="<%= xp.xpd.node_value[startpoint++].trim() %>"></td>
	<td nowrap style='text-align:right;'><label>限度区分</label></td>
	<td><input name='f31' style='width:130px' value="<%= xp.xpd.node_value[startpoint++].trim() %>"></td>
	<td nowrap style='text-align:right;'><label>完済区分</label></td>
	<td><select name='f310' style='width:130px' table='LNPCODE' key='740' disabled=true></select></td> <!-- XmlUtil.nNullCheck(xp.xpd.node_value[startpoint++]) !-->
</tr>
<%
					startpoint++; // f32;
%>
<tr>
	<!-- ↓↓↓ 2018/09/28 EK 尹 START ↓↓↓ -->
	<td nowrap style='text-align:right;'><label>承認金額(利用限度額)</label></td>
	<!-- ↑↑↑ 2018/09/28 EK 尹 END ↑↑↑ -->
	<td><input name='f32' style='width:130px;text-align:right' readonly value="<%= makemask7("17.2" ,xp.xpd.node_value[startpoint++] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label>実行金額</label></td>

	<td><input name='f33' style='width:130px;text-align:right' readonly value="<%= makemask7("17.2" ,xp.xpd.node_value[startpoint++] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label>現在残高</label></td>

	<td><input name='f34' style='width:130px;text-align:right' readonly value="<%= makemask7("17.2" ,xp.xpd.node_value[startpoint++] ,xp.oheader.node_value[35]) %>"></td>

</tr>
<%
				int f503 = startpoint++;				// f503
%>
<tr>
    <td nowrap style='text-align:right;'><label>極度種類</label></td>
    <td><input name='f316' style='width:130px' value="<%= xp.xpd.node_value[316].trim() %>" readonly tabindex='-1'></td>
	<td nowrap style='text-align:right;'><label>ボーナス分金額</label></td>

	<td><input name='f307' style='width:130px;text-align:right' value="<%= makemask7("17.2" ,xp.xpd.node_value[94] ,xp.oheader.node_value[35]) %>" readonly tabindex='-1'></td>

	<td nowrap style='text-align:right;'><label>ボーナス残高</label></td>

	<td><input name='f503' style='width:130px;text-align:right' value="<%= makemask7("17.2" ,xp.xpd.node_value[f503] ,xp.oheader.node_value[35]) %>" readonly tabindex='-1'></td>


</tr>
<tr>
	<td nowrap style='text-align:right;'><label>資金使途</label></td>
	<td colspan='5'><input name='f35' style='width:40px' value="<%= xp.xpd.node_value[startpoint++] %>"><input name='f36' style='width:390px' value="<%= xp.xpd.node_value[startpoint++].trim() %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label>勘定コード(B/S)</label></td>
	<td colspan='5'><input name='f37' style='width:80px' value="<%= xp.xpd.node_value[startpoint++] %>"><input name='f38' style='width:350px' value="<%= xp.xpd.node_value[startpoint++].trim() %>">
	<!--自動振替区分--><input type='hidden' name='f39' style='width:80px' value="<%= xp.xpd.node_value[startpoint++].trim() %>"></td>
</tr>
    <!--専決権者コード--><input type='hidden' name='f40' style='width:150px' value="<%= xp.xpd.node_value[startpoint++] %>">
    <!--担保種類--><!--<input name='f41' style='width:80px'></td>-->
<tr>
	<td nowrap style='text-align:right;'><label>担当者番号</label></td>
	<td colspan='5'><input name='f41' style='width:90px' value="<%= xp.xpd.node_value[startpoint] %>"><input name='f41Lbl' style='width:210px' readonly tabindex='-1'>
	<script>
		var code = '<%= xp.xpd.node_value[startpoint++] %>';
		if(code !='9999999999'){
			/* origin
			var node = top.TLMTELR.selectSingleNode("/table/record[@DPT_CD ='"+top.iHeader["DPT_CD"]+
											"' and @TELR='"+code+"']");
			*/
			/*new querySelector path*/
			var node_root = "/table/record[@DPT_CD ='"+top.iHeader["DPT_CD"]+"' and @TELR='"+code+"']";
			var node_xpath_1 = document.evaluate(node_root, top.TLMTELR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			var node = node_xpath_1.singleNodeValue;
			document.all.f41Lbl.value = (node)? node.getAttribute("TELR_NAME"):"";
			
			console.log('var_node = '+node);			
			console.log('node_xpath_1 = '+node_xpath_1.singleNodeValue);			
			console.log('document.all.f41Lbl.value 1 = '+document.all.f41Lbl.value);			
		}
	</script>
	</td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label>管理者行員番号</label></td>
	<td nowrap colspan='5'><input name='f42' style='width:90px' value="<%= xp.xpd.node_value[startpoint] %>"><input name='f42Lbl' style='width:210px' readonly tabindex='-1'>
	<script>
		var code = '<%= xp.xpd.node_value[startpoint++] %>';
		if(code !='9999999999'){
			/*//origin
			var node = top.TLMTELR.selectSingleNode("/table/record[@DPT_CD ='"+top.iHeader["DPT_CD"]+
											"' and @TELR='"+code+"']");
			document.all.f42Lbl.value = (node)? node.getAttribute("TELR_NAME"):"";
			*/
			
			var node_root = "/table/record[@DPT_CD ='"+top.iHeader["DPT_CD"]+"' and @TELR='"+code+"']";
			var node_xpath_2 = document.evaluate(node_root, top.TLMTELR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			var node = node_xpath_2.singleNodeValue;
			document.all.f42Lbl.value = (node)? node.getAttribute("TELR_NAME"):"";
			console.log('document.all.f42Lbl.value 2 = '+document.all.f42Lbl.value);
		}
	</script>
	<label style='width:70px'>承認権者</label>
	<input name='f43' style='width:90px' value="<%= xp.xpd.node_value[startpoint] %>" readonly><input name='f43Lbl' style='width:200px' readonly tabindex='-1'>
	<script>
		var code = '<%= xp.xpd.node_value[startpoint++] %>';
		if(code !='9999999999'){
			/* //origin
			var node = top.TLMTELR.selectSingleNode("/table/record[@DPT_CD ='"+top.iHeader["DPT_CD"]+
											"' and @TELR='"+code+"']");
			document.all.f43Lbl.value = (node)? node.getAttribute("TELR_NAME"):"";
			*/
			
			var node_root = "/table/record[@DPT_CD ='"+top.iHeader["DPT_CD"]+"' and @TELR='"+code+"']";
			var node_xpath_3 = document.evaluate(node_root, top.TLMTELR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			var node = node_xpath_3.singleNodeValue;
			document.all.f43Lbl.value = (node)? node.getAttribute("TELR_NAME"):"";
			console.log('document.all.f43Lbl.value 3 = '+document.all.f43Lbl.value);			
		}
	</script>
	</td>
</tr>
<tr>
	<td colspan='6'>&nbsp;</td>
</tr>
<%
						startpoint++;
						startpoint++;
%>
<tr>
	<td nowrap style='text-align:right;'><label>承認日付</label></td>
	<td><input name='f44' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[startpoint++]) %>"></td>
	<td nowrap style='text-align:right;'><label>実行日</label></td>
	<td><input name='f45' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[startpoint++]) %>"></td>
	<td nowrap style='text-align:right;'><label>承認期限</label></td>
	<td><input name='f46' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[startpoint++]) %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label>最終元金返済日</label></td>
	<td><input name='f47' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[startpoint++]) %>"></td>
	<td nowrap style='text-align:right;'><label>最終利息返済日</label></td>
	<td><input name='f48' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[startpoint++]) %>"></td>
	<td nowrap style='text-align:right;'><label>据置終了日</label></td>
	<td><input name='f49' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[startpoint++]) %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label>最終取引日</label></td>
	<td><input name='f50' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[startpoint++]) %>"></td>
	<td nowrap style='text-align:right;'><label>ボーナス返済月1</label></td>
	<td><input name='f51' style='width:25px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[startpoint++]) %>"></td>
	<td nowrap style='text-align:right;'><label>ボーナス返済月2</label></td>
	<td><input name='f52' style='width:25px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[startpoint++]) %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label>毎回分約定期限</label></td>
	<td><input name='f53' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[startpoint++]) %>"></td>
	<td nowrap style='text-align:right;'><label>ボーナス分約定期限</label></td>
	<td><input name='f54' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[startpoint++]) %>"></td>
	<td nowrap style='text-align:right;'><label>ボーナス分利済日</label></td>
	<td><input name='f55' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[startpoint++]) %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label>利済日</label></td>
	<td><input name='f56' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[startpoint++]) %>"></td>
	<td nowrap style='text-align:right;'><label>初回分割金</label></td>


	<td><input name='f57' style='width:130px;text-align:right' readonly value="<%= makemask7("17.2" ,xp.xpd.node_value[startpoint++] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label>毎回分割金</label></td>

	<td><input name='f58' style='width:130px;text-align:right' readonly value="<%= makemask7("17.2" ,xp.xpd.node_value[startpoint++] ,xp.oheader.node_value[35]) %>"></td>

</tr>
<tr>
	<td nowrap style='text-align:right;'><label>最終分割金</label></td>

	<td><input name='f59' style='width:130px;text-align:right' readonly value="<%= makemask7("17.2" ,xp.xpd.node_value[startpoint++] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label>ボーナス分初回分割金</label></td>

	<td><input name='f60' style='width:130px;text-align:right' readonly value="<%= makemask7("17.2" ,xp.xpd.node_value[startpoint++] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label>ボーナス分毎回分割金</label></td>

	<td><input name='f61' style='width:130px;text-align:right' readonly value="<%= makemask7("17.2" ,xp.xpd.node_value[startpoint++] ,xp.oheader.node_value[35]) %>"></td>

</tr>
<tr>
	<td nowrap style='text-align:right;'><label>ボーナス分最終回分割金</label></td>

	<td colspan='5'><input name='f62' style='width:130px;text-align:right' readonly value="<%= makemask7("17.2" ,xp.xpd.node_value[startpoint++] ,xp.oheader.node_value[35]) %>"></td>

</tr>
<tr><td colspan='6'>&nbsp;</td></tr>
<%
						startpoint++;
%>
<tr>
	<td nowrap style='text-align:right;'><label>約定利息</label></td>


	<td><input name='f63'  style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[95] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label>経過利息</label></td>

	<td><input name='f600' style='width:130px;text-align:right' value="<%= makemask7("14.2" ,xp.xpd.node_value[299] ,xp.oheader.node_value[35]) %>" readonly tabindex='-1'></td>

	<td nowrap style='text-align:right'><label>延滞利息</label></td>

	<td><input name='f64'  style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[96] ,xp.oheader.node_value[35]) %>"></td>

</tr>
<tr>
	<td nowrap style='text-align:right;'><label>毎回分約定未収利息</label></td>

	<td><input name='f66' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[98] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label>未経過利息</label></td>

	<td><input name='f603' style='width:130px;text-align:right' value="<%= makemask7("14.2" ,xp.xpd.node_value[317] ,xp.oheader.node_value[35]) %>" readonly tabindex='-1' ></td>

	<td nowrap style='text-align:right'><label>未払利息</label></td>

	<td><input name='f67' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[99] ,xp.oheader.node_value[35]) %>"></td>

</tr>
<tr>
	<td nowrap style='text-align:right;'><label>未収利息</label></td>

	<td><input name='f65' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[97] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right'><label>減免約定利息</label></td>

	<td><input name='f73' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[105] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label>減免延滞利息</label></td>

	<td><input name='f74' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[106] ,xp.oheader.node_value[35]) %>"></td>


</tr>
<tr>
	<td nowrap style='text-align:right;'><label>ボーナス分約定利息</label></td>

	<td><input name='f68'  style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[100] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label>ボーナス分経過利息</label></td>

	<td><input name='f601' style='width:130px;text-align:right' value="<%= makemask7("14.2" ,xp.xpd.node_value[300] ,xp.oheader.node_value[35]) %>" readonly tabindex='-1' ></td>

	<td nowrap style='text-align:right;'><label>ボーナス分延滞利息</label></td>

	<td><input name='f69'  style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[101] ,xp.oheader.node_value[35]) %>"></td>

</tr>
<tr>
	<td nowrap style='text-align:right;'><label>ボーナス分約定未収利息</label></td>

	<td><input name='f71' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[103] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label>ボーナス分未経過利息</label></td>

	<td><input name='f604' style='width:130px;text-align:right' value="<%= makemask7("14.2" ,xp.xpd.node_value[318] ,xp.oheader.node_value[35]) %>" readonly tabindex='-1' ></td><!--Last Num-->

	<td nowrap style='text-align:right;'><label>ボーナス分未払利息</label></td>

	<td><input name='f72'  style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[104] ,xp.oheader.node_value[35]) %>"></td>

</tr>
<tr>
	<td nowrap style='text-align:right'><label>ボーナス分未収利息</label></td>

	<td><input name='f70'  style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[102] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right'><label>ボーナス分減免延滞利息</label></td>

	<td><input name='f76' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[108] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label>ボーナス分減免約定利息</label></td>

	<td><input name='f75' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[107] ,xp.oheader.node_value[35]) %>"></td>


</tr>
</table>
</div>




<!-- 3rd tab : 詳細情報2 --------------------------------------------------------------------------->
<%					startpoint = 110;	%>
<div id=tabPages class='TabPage padding_ver_20'>
<label class="tab_page_label" style='margin-left:36px'>返済方式コード</label>
<input name='f78_1' style='width:40px' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[110]) %>" readonly tabindex='-1'><input name='f410' style='width:270px'  value="<%= xp.xpd.node_value[111] %>" readonly tabindex='-1'><br>

<label class="tab_page_label" style='margin-left:36px'>元金返済方式</label>
<select name='f77' table='LNPCODE' key='507' disabled=true></select><!-- XmlUtil.nNullCheck(xp.xpd.node_value[103]) !-->
<label class="tab_page_label" style='margin-left:-20px'>利息返済方式</label>
<select name='f78' table='LNPCODE' key='506' disabled=true></select><!-- XmlUtil.nNullCheck(xp.xpd.node_value[104]) !--><br>

<label class="tab_page_label" style='margin-left:36px'>元金返済周期</label>
<input name='f79' style='width:25px' qtype='3110' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[114]) %>"><input name='f79Lbl' style='width:118px' readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:-18px'>利息返済周期</label>
<input name='f80' style='width:25px' qtype='3110' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[115]) %>"><input name='f80Lbl' style='width:118px' readonly tabindex='-1'><br>

<label class="tab_page_label" style='margin-left:36px'>返済方式種類</label>
<select name='f411' table='LNPCODE' key='721' disabled=true></select><!-- XmlUtil.nNullCheck(xp.xpd.node_value[107]) !-->
<!--20180917 eSCOFI Dolpfin対応-->
<label class="tab_page_label" style='margin-left:90px'>次回請求返済日</label>
<input name='f910' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[329]) %>"><br>
<!--20180917 eSCOFI Dolpfin対応-->
<label class="tab_page_label" style='margin-left:36px'>最終一連番号</label>
<input name='f97' style='width:45px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[136]) %>">
<label class="tab_page_label" style='margin-left:80px'>最終変更取引番号</label>
<input name='f98' style='width:45px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[137]) %>">
<label class="tab_page_label" style='margin-left:15px'>分割金適用期限</label>
<input name='f315' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[315]) %>" readonly tabindex='-1'><br>

<label class="tab_page_label" style='margin-left:36px'>旧承認期限</label>
<input name='f87' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[125]) %>">
<label class="tab_page_label" style='margin-left:45px'>分割コード</label>
<input name='f113' style='width:150px' value="<%= xp.xpd.node_value[154].trim() %>"><br>

<label class="tab_page_label" style='margin-left:36px'>約定日</label>
<input name='f81' style='width:25px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[117]) %>">
<!--<label style='margin-left:100px'>利息返済日</label>//-->
<input type='hidden'name='f82' style='width:80px' value="<%= xp.xpd.node_value[118] %>">
<label class="tab_page_label" style='margin-left:100px'>延滞コード</label>
<input name='f88' style='width:25px' value="<%= xp.xpd.node_value[127] %>"><input name='f89' style='width:350px' value="<%= xp.xpd.node_value[128] %>"><br>

<label class="tab_page_label" style='margin-left:36px'>次回元金返済日</label>
<input name='f83' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[121]) %>">
<label class="tab_page_label" style='margin-left:45px'>次回利息返済日</label>
<input name='f84' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[122]) %>">
<label class="tab_page_label" style='margin-left:-20px'>延滞利率</label>
<input name='f92' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[131]) %>">%<br>

<label class="tab_page_label" style='width:134px; margin-left:22px'>次回ボーナス元金返済日</label>
<input name='f85' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[123]) %>">
<label class="tab_page_label" style='width:134px; margin-left:31px'>次回ボーナス利息返済日</label>
<input name='f86' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[124]) %>">
<label class="tab_page_label" style='margin-left:-20px'>延滞開始日</label>
<input name='f94' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[133]) %>"><br>

<label class="tab_page_label" style='width:160px; font-size:11px;'>手数料パターン（繰上げ完済）</label>
<select name='f98_1' disabled="true" style="margin-left:-4px;"><!--table='COMCOMB' key='5090'!--> 
<%
				int ntemp = XmlUtil.nNullCheck(xp.xpd.node_value[138]);
%>
<option value="0" <%= ntemp == 0 ? "selected" : "" %>></option>
<option value="1" <%= ntemp == 1 ? "selected" : "" %>>変動類型</option>
<option value="2" <%= ntemp == 2 ? "selected" : "" %>>経過期間</option>
<option value="3" <%= ntemp == 3 ? "selected" : "" %>>パターンなし</option>
<option value="9" <%= ntemp == 9 ? "selected" : "" %>>違約金</option>
</select>
<label class="tab_page_label" style='width:148px; /*margin-left:13px;*/ font-size:11px;'>手数料パターン（臨時返済）</label>
<select name='f98_2' disabled="true" style="margin-left:-5px;"> <!--table='COMCOMB' key='5090'!--> 
<%
				ntemp = XmlUtil.nNullCheck(xp.xpd.node_value[139]);
%>
<option value="0" <%= ntemp == 0 ? "selected" : "" %>></option>
<option value="1" <%= ntemp == 1 ? "selected" : "" %>>変動類型</option>
<option value="2" <%= ntemp == 2 ? "selected" : "" %>>経過期間</option>
<option value="3" <%= ntemp == 3 ? "selected" : "" %>>パターンなし</option>
<option value="9" <%= ntemp == 9 ? "selected" : "" %>>違約金</option>
</select>
<label class="tab_page_label" style='margin-left:-28px'>元金延滞期間</label>
<input name='f93' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[132]) %>"><br>

<!--特約期間終了日--
<input name='f87_1' style='width:80px' readonly tabindex='-1' value="xp.xpd.node_value[117]">!-->
<label class="tab_page_label" style='margin-left:36px'>延滞帳発送日</label>
<input name='f95' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[134]) %>">
<label class="tab_page_label" style='margin-left:45px'>管理進行状態 </label>
<select name='f90' disabled=true> <!--table='COMCOMB' key='2950'!--> 
<%
				ntemp = XmlUtil.nNullCheck(xp.xpd.node_value[129]);
%>
<option value="0" <%= ntemp == 0 ? "selected" : "" %>></option>
<option value="1" <%= ntemp == 1 ? "selected" : "" %>>期限利益喪失</option>
<option value="2" <%= ntemp == 2 ? "selected" : "" %>>法的手続が着手</option>
<option value="3" <%= ntemp == 3 ? "selected" : "" %>>該当事項無し</option>
</select>
<input type='hidden' name='f91' value="<%= xp.xpd.node_value[129] %>"><br>

<label class="tab_page_label" style='margin-left:36px'>延滞帳発送現況</label>
<input name='f96' style='width:300px' value="<%= xp.xpd.node_value[135] %>"><br>

<label class="tab_page_label" style='margin-left:36px'>条件緩和区分</label>
<input name='f114' style='width:25px' value="<%= xp.xpd.node_value[155] %>"><input name='f115' style='width:275px' value="<%= xp.xpd.node_value[156] %>"><br>

<label class="tab_page_label" style='margin-left:36px'>条件緩和内容</label>
<input name='f116' style='width:600px' value="<%= xp.xpd.node_value[157] %>"><br>
<input style='width:600px; margin-left:165px;' name='f117' value="<%= xp.xpd.node_value[158] %>"><br>

<table cellpadding='0' cellspacing='0' style='margin-left:40px'>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">延滞返済回数</label></td>
	<td><input name='f102' style='width:30px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[143]) %>"></td>
	<td nowrap style='text-align:right;width:203px'><label class="tab_page_label">延滞回数</label></td>
	<td><input name='f103' style='width:30px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[144]) %>"></td>
	<td nowrap style='text-align:right;width:137px'><label class="tab_page_label">延滞のべ回数</label></td>
	<td><input name='f101' style='width:30px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[142]) %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">延滞返済日数</label></td>
	<td><input name='f105' style='width:50px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[146]) %>"></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">延滞日数</label></td>
	<td><input name='f106' style='width:50px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[147]) %>"></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">延滞のべ日数</label></td>
	<td><input name='f104' style='width:50px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[145]) %>"></td>
</tr>
</table>

<label class="tab_page_label" style='margin-left:20px'><b>自由繰上返済情報</b></label><br>
<table cellpadding='0' cellspacing='0' style='margin-left:40px'>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label" style="width:134px;">手数料減免回数</label></td>
	<td><input name='f99' style='width:30px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[140]) %>"></td>
	<td nowrap style='text-align:right;width:224px'><label class="tab_page_label">当月繰上返済回数</label></td>
	<td><input name='f100' style='width:30px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[141]) %>"></td>
	<td nowrap style='text-align:right;width:156px'><label class="tab_page_label">最終自由繰上返済日</label></td>
	<td><input name='f302' style='width:80px' readonly tabindex='-1' value="<%= XmlUtil.makeDate(xp.xpd.node_value[150]) %>"></td>
</tr>
<!--tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">先払控除日数</label></td>
	<td--><input type='hidden' name='f107' style='width:50px' value="<%= xp.xpd.node_value[148] %>"><!--/td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">先払控除残余日数</label></td>
	<td colspan='3'--><input type='hidden' name='f108' style='width:80px' value="<%= xp.xpd.node_value[149] %>"><!--/td>
</tr-->
</table>

<label class="tab_page_label" style='margin-left:20px'><b>自動繰上返済情報</b></label><br>
<table cellpadding='0' cellspacing='0' style='margin-left:40px'>
<tr>
	<td nowrap ><label class="tab_page_label">繰上返済種類</label></td>
	<td><input name='f109' style='width:200px' value="<%= xp.xpd.node_value[151].trim() %>"></td>
	<!--自動繰上開始日,自動繰上終了日追加-->
	<td ><label class="tab_page_label" style='width:100px'>自動繰上開始日</label></td>
	<td><input name='f802' style='width:80px' readonly tabindex='-1' value="<%=  XmlUtil.makeDate(xp.xpd.node_value[308]) %>"></td>
	<td nowrap ><label class="tab_page_label" style='width:80px'>自動繰上終了日</label></td>
	<td><input name='f803' style='width:80px' readonly tabindex='-1' value="<%=  XmlUtil.makeDate(xp.xpd.node_value[309]) %>"></td>
</tr>
<tr>
	<td nowrap><label class="tab_page_label">返済上限金額</label></td>


	<td><input name='f110' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[152] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap><label class="tab_page_label" style='width:100px'>最低引落単位</label></td>

	<td><input name='f112' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[153] ,xp.oheader.node_value[35]) %>"></td>

	<!-- 最低維持残高追加-->
	<td nowrap style='text-align:right;' ><label class="tab_page_label" style='width:80px'>最低維持残高</label></td>

	<td><input name='f905' style='width:130px;text-align:right' value= "<%= makemask7("17" ,xp.xpd.node_value[325] ,xp.oheader.node_value[35]) %>" readonly tabindex='-1'></td>

</tr>
</table>
</div>




<!-- 4th tab : 詳細情報3 --------------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>
<table style='margin-left:5px' cellpadding='0' cellspacing='0'>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label" style="width:134px">担保区分</label></td>
	<td><input name='f118' style='width:250px' value="<%= xp.xpd.node_value[160] %>"></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">担保設定種類</label></td>
	<td><input name='f119' style='width:150px' value="<%= xp.xpd.node_value[161] %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label" style="width:134px">保証人数</label></td>
	<td colspan='3'><input name='f120' style='width:25px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[162]) %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">団体生命コード</label></td>
	<td><input name='f126' style='width:40px' value="<%= xp.xpd.node_value[168] %>"><input name='f295' style='width:350px' value="<%= xp.xpd.node_value[169] %>" readonly tabindex='-1'></td>
<!--<td><input name='f126' style='width:80px' qtype='3154' onpropertychange='getDesc()'><input name='f126Lbl' style='width:150px' readonly tabindex='-1'></td>-->
	<td nowrap style='text-align:right;'><label class="tab_page_label">団体生命契約区分</label></td>
	<td style='align:left'><input name='f127' type=checkbox style='width:30px;margin-left:-9px' <%= xp.xpd.node_value[170].trim().compareTo("y") == 0 ? "checked" : "" %>><label class="tab_page_label" style='margin-left:-50px'> check時 加入</label></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label" style="width:134px">被保険者人数</label></td>
	<td><input name='f128' style='width:40px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[171]) %>"></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">団体生命保険番号</label></td>
	<td><input name='f129' style='width:180px' value="<%= xp.xpd.node_value[172] %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label" style="width:134px">第1団信当初適用額</label></td>

<!-- AP 17.2 -->
	<td><input name='f130' style='width:150px;text-align:right' readonly value="<%= makemask7("17.2" ,xp.xpd.node_value[173] ,xp.oheader.node_value[35]) %>"></td>

	<td nowrap style='text-align:right;'><label class="tab_page_label" style='/*width:80px;*/'>第2団信当初適用額</label></td>

<!-- AP 17.2 -->
	<td><input name='f131' style='width:150px;text-align:right' readonly value="<%= makemask7("17.2" ,xp.xpd.node_value[174] ,xp.oheader.node_value[35]) %>"></td>



</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">特約保障コード</label></td>
	<td><input name='f311' style='width:25px' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[311]) %>" readonly tabindex='-1'><input name='f312' style='width:365px' value="<%= xp.xpd.node_value[312] %>" readonly tabindex='-1'></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">第3団信当初適用額</label></td>

<!-- AP 17.2 -->
	<td style='align:left'><input name='f313' style='width:150px;text-align:right' value="<%= makemask7("17.2" ,xp.xpd.node_value[313] ,xp.oheader.node_value[35]) %>" readonly tabindex='-1'></td>

</tr>
</table>
<br>

<label class="tab_page_label" style="width:134px;"><b>保証会社/保証協会情報</b></label><br>
<table style='margin-left:5px' cellpadding='0' cellspacing='0'>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label" style="width:134px">保証協会種類コード</label></td>
	<td><input name='f121' style='width:40px' qtype='3206' onpropertychange='getDesc()' pop='no' value="<%= xp.xpd.node_value[163].trim() %>"><input name='f121Lbl' style='width:350px' readonly tabindex='-1'>
	<script>
			/* //origin
			var node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 6 and @CODE_5='"+document.all.f121.value+"' and @STA < 40]");
			document.all.f121Lbl.value = (node)? node.getAttribute("CODE_NAME"):"";
			*/
			var node_root = "/table/record[@CODE_KIND = 6 and @CODE_5='"+document.all.f121.value+"' and @STA < 40]";
			var node_xpath_4 = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			var node = node_xpath_4.singleNodeValue;
			document.all.f121Lbl.value = (node)? node.getAttribute("CODE_NAME"):"";
			console.log('document.all.f121Lbl.value = '+document.all.f121Lbl.value);
	</script>
	</td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label" style="width:134px">保証協会口座番号</label></td>
	<td><input name='f122' style='width:150px' value="<%= xp.xpd.node_value[164] %>"></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">保証協会保証番号</label></td>
	<td><input name='f123' style='width:150px' value="<%= xp.xpd.node_value[165] %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label" style="width:134px">保証会社コード</label></td>
	<td><input name='f124' style='width:40px' qtype='3207' onpropertychange='getDesc()' pop='no' value="<%= xp.xpd.node_value[166].trim() %>"><input name='f124Lbl' style='width:350px' readonly tabindex='-1'>
	<script>
			console.log('test_line!!');
			/* //origin
			var node = top.LNPGUAR.selectSingleNode("/table/record[@GUAR_COMP_CODE='"+document.all.f124.value+"' and @DPT_CD ="+top.iHeader["DPT_CD"]+" and @STA < 40]");
			document.all.f124Lbl.value = (node)? node.getAttribute("GUAR_COMP_NAME"):"";
			*/
			
			var node_root = "/table/record[@GUAR_COMP_CODE='"+document.all.f124.value+"' and @DPT_CD ="+top.iHeader["DPT_CD"]+" and @STA < 40]";
			var node_xpath_5 = document.evaluate(node_root, top.LNPGUAR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			var node = node_xpath_5.singleNodeValue;
			document.all.f124Lbl.value = (node)? node.getAttribute("GUAR_COMP_NAME"):"";
			console.log('document.all.f124Lbl.value = '+document.all.f124Lbl.value);			
	</script>
	</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">保証会社保証書番号</label></td>
	<td><input name='f125' style='width:150px' value="<%= xp.xpd.node_value[167] %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">保証料徴求方式</label></td>
	<td><input name='f132' style='width:150px' value="<%= xp.xpd.node_value[175] %>"></td>
</tr>
</table>
<br>
<label class="tab_page_label" style="width:134px">連帯債務者区分</label>
<input name='f133' style='width:100px' value="<%= xp.xpd.node_value[176] %>">
<label class="tab_page_label" style='margin-left:420px'>主債務者債務比率</label>
<input name='f134' style='width:30px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[177]) %>"> %<br>
<label class="tab_page_label" style="width:134px">連帯債務者顧客番号1</label>
<input name='f135' style='width:80px' value="<%= XmlUtil.dataPattern("f",xp.xpd.node_value[178],10) %>"><input name='f303' style='width:450px' value="<%= xp.xpd.node_value[179] %>" readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:-10px'>債務比率１</label>
<input name='f136' style='width:30px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[180]) %>"> %<br>
<label class="tab_page_label" style="width:134px">連帯債務者顧客番号2</label>
<input name='f137' style='width:80px' value="<%= XmlUtil.dataPattern("f",xp.xpd.node_value[181],10) %>"><input name='f304' style='width:450px' value="<%= xp.xpd.node_value[182] %>" readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:-10px'>債務比率２</label>
<input name='f138' style='width:30px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[183]) %>"> %<br>
<label class="tab_page_label" style="width:134px">連帯債務者顧客番号3</label>
<input name='f139' style='width:80px' value="<%= XmlUtil.dataPattern("f",xp.xpd.node_value[184],10) %>"><input name='f305' style='width:450px' value="<%= xp.xpd.node_value[185] %>" readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:-10px'>債務比率３</label>
<input name='f140' style='width:30px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[186]) %>"> %<br>
<label class="tab_page_label" style="width:134px">連帯債務者顧客番号4</label>
<input name='f141' style='width:80px' value="<%= XmlUtil.dataPattern("f",xp.xpd.node_value[187],10) %>"><input name='f306' style='width:450px' value="<%= xp.xpd.node_value[188] %>" readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:-10px'>債務比率４</label>
<input name='f142' style='width:30px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[189]) %>"> %<br>
<br>
	<!-- 振替委託区分追加-->
	<label class="tab_page_label" style='width:134px; margin-left:0'>振替委託区分</label>
	<select name='f907' disabled=true<!--table='COMCOMB' key='5570'!--> >
<%
				ntemp = XmlUtil.nNullCheck(xp.xpd.node_value[326]);
%>
<option value="0" <%= ntemp == 0 ? "selected" : "" %>>自行口座</option>
<option value="1" <%= ntemp == 1 ? "selected" : "" %>>代行者経由他行</option>
<option value="2" <%= ntemp == 2 ? "selected" : "" %>>他行直接引落</option>
</select><br>

	<!-- 振替代行者コード追加-->
	<label class="tab_page_label" style='width:134px; margin-left:0'>振替代行者コード</label>
	<input name='f908' style='width:40px' value="<%= xp.xpd.node_value[327].trim() %>" readonly tabindex='-1'><input name='f909' style='width:350px' value="<%= xp.xpd.node_value[328] %>" readonly tabindex='-1'><br>

</div>





<!-- 5th tab : 詳細情報4 --------------------------------------------------------------------------->
<%					startpoint = 332;	%>
<div id=tabPages class='TabPage padding_ver_20'>

<table border='0' cellspacing='1' cellpadding='0' style="margin-left:50px;">
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">分割元の親の口座番号</label></td>
	<td><input name='f308' style='width:130px' readonly tabindex='-1' value="<%= XmlUtil.dataPattern("a",xp.xpd.node_value[73],0) %>"></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">親の関連口座番号</label></td>
	<td colspan='3'><input name='f309' style='width:130px' readonly tabindex='-1' value="<%= XmlUtil.dataPattern("a",xp.xpd.node_value[74],0) %>"></td>
</tr>
</table><br>

<label style="margin-left:50px"><b>元帳分割関連貸出口座 情報</b></label><br>
<table border='0' cellspacing='1' cellpadding='0' bgcolor='black' style="margin-left:50px;">
<tr>
    <td align="center" class=xTitle width='170px'>関連貸出口座番号</td>
    <td align="center" class=xTitle width='150px'>当初実行額</td>
    <td align="center" class=xTitle width='150px'>貸出残高</td>
    <td align="center" class=xTitle width='100px'>適用利率</td>
</tr>
<%                  int line_count = XmlUtil.nNullCheck(xp.xpd.node_value[ngrid1]);

                    if (line_count == 0) {
%>
<tr bgcolor='white'>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
</tr>
<%                  }
	                int nidx = ngrid1 + 1;
	                for (int i = 0; i < line_count; i++) {
                        String f266 = xp.xpd.node_value[nidx++];
                		String f267 = xp.xpd.node_value[nidx++];
                		String f268 = xp.xpd.node_value[nidx++];
                		String f269 = xp.xpd.node_value[nidx++];
%>
<tr bgcolor="white">
    <td align='center'><%= XmlUtil.dataPattern("a",f266,0) %></td>

    <td align='right' ><%= makemask7("14.2" ,f267 ,xp.oheader.node_value[35]) %>&nbsp;</td>
    <td align='right' ><%= makemask7("14.2" ,f268 ,xp.oheader.node_value[35]) %>&nbsp;</td>

    <td align='right' ><%= XmlUtil.checkValue("03","7.5",f269) %>&nbsp;</td>
</tr>
<%	                }   %>
</table>
<br><br><br><br>


<label style="margin-left:50px"><b>分割申請関連貸出口座 情報</b></label><br>
<table border='0' cellspacing='1' cellpadding='0' bgcolor='black' style="margin-left:50px;">
<tr>
    <td align="center" class=xTitle width='170px'>関連貸出口座番号</td>
    <td align="center" class=xTitle width='150px'>当初実行額</td>
    <td align="center" class=xTitle width='150px'>貸出残高</td>
    <td align="center" class=xTitle width='100px'>適用利率</td>
</tr>
<%                  line_count = XmlUtil.nNullCheck(xp.xpd.node_value[ngrid2]);

	                if (line_count == 0) {
%>
<tr bgcolor='white'>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
</tr>
<%                  }
	                nidx = ngrid2 + 1;
	                for (int i = 0; i < line_count; i++) {
                		String f273 = xp.xpd.node_value[nidx++];
                		String f274 = xp.xpd.node_value[nidx++];
                		String f275 = xp.xpd.node_value[nidx++];
                		String f276 = xp.xpd.node_value[nidx++];
%>
<tr bgcolor="white">
    <td align='center'><%= XmlUtil.dataPattern("a",f273,0) %></td>

    <td align='right' ><%= makemask7("14.2" ,f274 ,xp.oheader.node_value[35]) %>&nbsp;</td>
    <td align='right' ><%= makemask7("14.2" ,f275 ,xp.oheader.node_value[35]) %>&nbsp;</td>

    <td align='right' ><%= XmlUtil.checkValue("03","7.5",f276) %>&nbsp;</td>
</tr>
<%	                }   %>
</table>
<br><br><br><br>


<label style="margin-left:50px"><b>利子補給・段階補給元本管理</b></label><br>
<table border='0' cellspacing='1' cellpadding='0' bgcolor="black" style="margin-left:50px;">
<tr>
    <td align="center" class=xTitle width='170px'>関連貸出口座番号</td>
    <td align="center" class=xTitle width='150px'>当初実行額</td>
    <td align="center" class=xTitle width='150px'>貸出残高</td>
    <td align="center" class=xTitle width='100px'>適用利率</td>
    <td align="center" class=xTitle width='100px'>個人負担率</td>
</tr>
<%	                line_count = XmlUtil.nNullCheck(xp.xpd.node_value[ngrid3]);

	                if (line_count == 0) {
%>
<tr bgcolor="white">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
</tr>
<%                  }
                	nidx = ngrid3 + 1;
                	for (int i = 0; i < line_count; i++) {
                		String f280 = xp.xpd.node_value[nidx++];
                		String f281 = xp.xpd.node_value[nidx++];
                		String f282 = xp.xpd.node_value[nidx++];
                		String f283 = xp.xpd.node_value[nidx++];
                		String f284 = xp.xpd.node_value[nidx++];
%>
<tr bgcolor="white">
    <td align='center'><%= XmlUtil.dataPattern("a",f280,0) %></td>

    <td align='right' ><%= makemask7("14.2" ,f281 ,xp.oheader.node_value[35]) %>&nbsp;</td>
    <td align='right' ><%= makemask7("14.2" ,f282 ,xp.oheader.node_value[35]) %>&nbsp;</td>

    <td align='right' ><%= XmlUtil.checkValue("03","7.5",f283) %>&nbsp;</td>
    <td align='right' ><%= XmlUtil.checkValue("03","7.5",f284) %>&nbsp;</td>
</tr>
<%	                }   %>
</table>
</div>





<!-- 6th tab : 貸出登録情報 ------------------------------------------------------------------------>
<div id=tabPages class='TabPage padding_ver_20'>
<table border=0 cellpadding='0' cellspacing='0'>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">利率区分</label></td>
	<td style='width:250px'>
	    <select name='f143' disabled=true<!--table='COMCOMB' key='880'!--> >
<%
				ntemp = XmlUtil.nNullCheck(xp.xpd.node_value[191]);
%>
    	<option value="0" <%= ntemp == 0 ? "selected" : "" %>></option>
    	<option value="1" <%= ntemp == 1 ? "selected" : "" %>>確定</option>
    	<option value="2" <%= ntemp == 2 ? "selected" : "" %>>預金</option>
    	<option value="3" <%= ntemp == 3 ? "selected" : "" %>>P連動</option>
    	</select></td>
	<td colspan='2'>&nbsp;</td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">変動類型コード</label></td>
	<td><select name='f144' table='LNPCODE' key='607' disabled=true></select></td> <!-- XmlUtil.nNullCheck(xp.xpd.node_value[183]) !-->
	<td nowrap style='text-align:right;'><label class="tab_page_label">基準利率コード</label></td>
	<td><select name='f145' table='LNPCODE' key='608' disabled=true></select></td> <!-- XmlUtil.nNullCheck(xp.xpd.node_value[184]) !-->
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">CAP 特約期間</label></td>
	<td><input name='f146' style='width:40px'  readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[194]) %>"></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">固定金利特約期間</label></td>
	<td><input name='f147' style='width:40px'  readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[195]) %>"></td>
</tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">特約期間終了日</label></td>
    <td colspan='3'><input name='f87_1' style='width:80px' readonly tabindex='-1' value="<%= XmlUtil.makeDate(xp.xpd.node_value[126]) %>"></td>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">次回金利変更日</label></td>
	<td><input name='f504' style='width:80px' readonly tabindex='-1' value="<%= XmlUtil.makeDate(xp.xpd.node_value[119]) %>"></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">次回分割金変更日</label></td>
	<td><input name='f505' style='width:80px' readonly tabindex='-1' value="<%= XmlUtil.makeDate(xp.xpd.node_value[120]) %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">次期変動類型コード</label></td>
	<td><select name='f148' table='LNPCODE' key='607' disabled=true></select></td> <!-- XmlUtil.nNullCheck(xp.xpd.node_value[187]) !-->
	<td nowrap style='text-align:right;'><label class="tab_page_label">次期基準利率コード</label></td>
	<td><select name='f149' table='LNPCODE' key='608' disabled=true></select></td> <!-- XmlUtil.nNullCheck(xp.xpd.node_value[188]) !-->
</tr>
</table>
<input name='f147' type='hidden' style='width:40px' value="<%= xp.xpd.node_value[195] %>">
<input name='f150' type='hidden' style='width:80px' value="<%= xp.xpd.node_value[198] %>">
<br><br>

<label class="tab_page_label"><b>商品利率情報</b></label>
<table cellpadding='0' cellspacing='0' style='margin-left:-10px'>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">プライムレート</label></td>
	<td><input name='f153' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[199]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">商品加算利率</label></td>
	<td><input name='f154' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[200]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">商品減算利率</label></td>
	<td><input name='f155' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[201]) %>">%</td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">初回段階金利</label></td>
	<td><input name='f156' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[202]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">初回SPREAD金利</label></td>
	<td><input name='f157' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[203]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">商品利率</label></td>
	<td><input name='f158' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[204]) %>">%</td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">CAP利率</label></td>
	<td><input name='f159' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[205]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">FLOOR利率</label></td>
	<td><input name='f160' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[206]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">次期SPREAD利率</label></td>
	<td><input name='f161' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[207]) %>">%</td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">期間金利</label></td>
	<td><input name='f162' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[208]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">CAP期間SPREAD</label></td>
	<td><input name='f163' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[209]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">商品固定利率</label></td>
	<td><input name='f297' style='width:80px' readonly tabindex='-1' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[211]) %>">%</td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">顧客CAP</label></td>
	<td colspan='5'><input name='f165' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[212]) %>">%</td>
</tr>
<tr>
	<td colspan='6' style='width:700px'>&nbsp;</td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">確定金利</label></td>
	<td><input name='f164' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[210]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">加算金利</label></td>
	<td><input name='f166' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[213]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">減算金利</label></td>
	<td><input name='f167' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[214]) %>">%</td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">利子補給率</label></td>
	<td><input name='f168' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[215]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">保証料率</label></td>
	<td><input name='f169' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[216]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">団体生命利率</label></td>
	<td><input name='f170' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[217]) %>">%</td>
</tr>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">特約加算利率</label></td>
	<td><input name='f314' style='width:80px' readonly tabindex='-1' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[314]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">預金金利</label></td>
	<td><input name='f171' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[218]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">連動加算金利</label></td>
	<td><input name='f172' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[219]) %>">%</td>
</tr>
<tr>
	<td><label class="tab_page_label">貸越利率</label></td>
	<td><input name='f605' style='width:80px' readonly tabindex='-1' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[319]) %>">%</td>
	<td></td><td></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">適用利率</label></td>
	<td><input name='f173' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[220]) %>">%</td>
</tr>
</table>
<br><br>

<label class="tab_page_label" style='width:193px; margin-left:35px'><b>金利変更による新金利及び新分割金</b></label><br>
<table border='0' cellspacing='1' cellpadding='0' bgcolor="black" style='margin-left:35px;margin-bottom:10px'>
<tr>
    <td align="center" class=xTitle width='100px'>適用日</td>
	<td align="center" class=xTitle width='100px'>適用利率</td>
	<td align="center" class=xTitle width='150px'>毎回分割金</td>
	<td align="center" class=xTitle width='150px'>ボーナス分毎回分割金</td>
</tr>
<%          	    line_count = XmlUtil.nNullCheck(xp.xpd.node_value[ngrid6]);

                	if (line_count == 0) {
%>
<tr bgcolor="white">
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<%                  }

                	nidx = ngrid6 + 1;
                	for (int i = 0; i < line_count; i++) {
                		String f415 = xp.xpd.node_value[nidx++];
                		String f416 = xp.xpd.node_value[nidx++];
                		String f417 = xp.xpd.node_value[nidx++];
                		String f418 = xp.xpd.node_value[nidx++];
%>
<tr bgcolor="white">
	<td align='center'><%= XmlUtil.makeDate(f415) %></td>
	<td align='right' ><%= XmlUtil.checkValue("03","7.5",f416) %>&nbsp;</td>

	<td align='right' ><%= makemask7("17.2" ,f417 ,xp.oheader.node_value[35]) %>&nbsp;</td>
	<td align='right' ><%= makemask7("17.2" ,f418 ,xp.oheader.node_value[35]) %>&nbsp;</td>


</tr>
<%              	}   %>
</table>
</div>





<!-- 7th tab : 優遇金利 ---------------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>
<table cellpadding='0' cellspacing='0'>
<tr>
	<td nowrap style='text-align:right;'><label class="tab_page_label">提携先コード</label></td>
	<td colspan='3'><input name='f176' style='width:45px' qtype='3141' onpropertychange="getDesc()" pop="no"><input name='f176Lbl' style='width:350px' readonly tabindex='-1'>
	<script>
		document.all.f176.value = '<%= xp.xpd.node_value[224].trim() %>';
	</script>
	</td>
	</tr>
<tr>
	<td nowrap style='text-align:right'><label class="tab_page_label">制度番号</label></td>
	<td colspan='3'><input name='f175' style='width:45px' value="<%= xp.xpd.node_value[222] %>"><input name='f175_1' style='width:350px' readonly tabindex='-1' value="<%= xp.xpd.node_value[223] %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right'><label class="tab_page_label">優遇幅パターン</label></td>
	<td colspan='3'><input name='f174_1' style='width:45px' readonly tabindex='-1'><input name='f174' style='width:350px' value="<%= xp.xpd.node_value[226] %>"></td>
	<script>
		var temp216 = '<%= xp.xpd.node_value[225] %>';
		document.all.f174_1.value = parseInt(temp216,10)==0 ? "" : padNumber(temp216,3);
	</script>
</tr>
<tr>
	<td nowrap style='text-align:right'><label class="tab_page_label">取引期間優遇幅番号</label></td>
	<td><input name='f245' style='width:45px'><input name='f246' style='width:410px' value="<%= xp.xpd.node_value[303] %>"></td>
	<script>
		var temp293 = '<%= xp.xpd.node_value[302] %>';
		document.all.f245.value = parseInt(temp293,10)==0 ? "" : padNumber(temp293,3);
	</script>
	<td nowrap style='text-align:right'><label class="tab_page_label">連続延滞猶予回数</label></td>
	<td><input name='f247' style='width:45px;text-align:right' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[304]) %>"></td>
</tr>
<tr>
	<td nowrap style='text-align:right'><label class="tab_page_label" style="width:134px;">ポイント別優遇適用可否</label></td>
	<td><select name='f177' disabled=true> <!--table='COMCOMB' key='4930'!--> 
<%
				ntemp = XmlUtil.nNullCheck(xp.xpd.node_value[227]);
%>
	<option value="0" <%= ntemp == 0 ? "selected" : "" %>>NO</option>
	<option value="1" <%= ntemp == 1 ? "selected" : "" %>>YES</option>
	</select><!--<input name='f177' style='width:80px'>--></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">顧客優遇金利</label></td>
	<td><input name='f178' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[228]) %>">%</td>
</tr>
<tr>
	<td nowrap style='text-align:right'><label class="tab_page_label" style="width:134px;">変動類型別優遇適用可否</label></td>
	<td><select name='f179' disabled=true><!--table='COMCOMB' key='4930'!--> 
<%
				ntemp = XmlUtil.nNullCheck(xp.xpd.node_value[229]);
%>
	<option value="0" <%= ntemp == 0 ? "selected" : "" %>>NO</option>
	<option value="1" <%= ntemp == 1 ? "selected" : "" %>>YES</option>
	</select><!--<input name='f179' style='width:80px'>--></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">変動類型優遇金利</label></td>
	<td><input name='f180' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[230]) %>">%</td>
</tr>
<tr>
	<td nowrap style='text-align:right'><label class="tab_page_label" style="width:134px;">取引期間優遇適用可否</label></td>
	<td><select name='f248' disabled=true> <!--table='COMCOMB' key='4930'!--> 
<%
				ntemp = XmlUtil.nNullCheck(xp.xpd.node_value[305]);
%>
	<option value="0" <%= ntemp == 0 ? "selected" : "" %>>NO</option>
	<option value="1" <%= ntemp == 1 ? "selected" : "" %>>YES</option>
	</select><!--<input name='f248' style='width:80px'>--></td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">取引期間優遇金利</label></td>
	<td><input name='f249' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[306]) %>">%</td>
</tr>
<tr>
	<td nowrap style='text-align:right'><label class="tab_page_label">最大優遇幅</label></td>
	<td><input name='f181' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[231]) %>">%</td>
	<td nowrap style='text-align:right;'><label class="tab_page_label">適用優遇金利</label></td>
	<td><input name='f182' style='width:80px' value="<%= XmlUtil.checkValue("03","7.5",xp.xpd.node_value[232]) %>">%</td>
</tr>
</table><br>
<br>
<label style='margin-left:50px;'><b>変動類型優遇幅パターン</b></label><br>
<table border='0' cellspacing='1' cellpadding='0' bgcolor="black" style='margin-left:50px'>
<tr>
    <td align="center" class=xTitle width='350' colspan=2>変動類型コード</td>
    <td align="center" class=xTitle width='80'>期間</td>
    <td align="center" class=xTitle width='120'>当初優遇幅</td>
    <td align="center" class=xTitle width='120'>期間経過後優遇幅</td>
</tr>
<%                	line_count = XmlUtil.nNullCheck(xp.xpd.node_value[ngrid0]);

                	if (line_count == 0) {
%>
<tr bgcolor="white">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
</tr>
<%                  }

                	nidx = ngrid0 + 1;
                	for (int i = 0; i < line_count; i++) {
                		String f259 = xp.xpd.node_value[nidx++];
                		String f260 = xp.xpd.node_value[nidx++];
                		String f261 = xp.xpd.node_value[nidx++];
                		String f262 = xp.xpd.node_value[nidx++];
%>
<tr bgcolor="white">
		<td align='center' style='width:50px'><%= XmlUtil.nNullCheck(f259) %></td>
		<td align='left' style='width:250px'>&nbsp;&nbsp;&nbsp;<script>
		/* //origin
		var node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = '729' and @CODE_5='"+<%= XmlUtil.nNullCheck(f259) %>+
											"' and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		document.write((node)? node.getAttribute("CODE_NAME"):"");
		*/
		var node_root = "/table/record[@CODE_KIND = '729' and @CODE_5='"+<%= XmlUtil.nNullCheck(f259) %>+"' and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
		var node_xpath_6 = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
		var node = node_xpath_6.singleNodeValue;
		document.all.f124Lbl.value = (node)? node.getAttribute("CODE_NAME"):"";
		console.log('document.all.f124Lbl.value = '+document.all.f124Lbl.value);
		//check value,  cuz : test not enough
		return document.all.f124Lbl.value;		
		
		</script></td>
		<td align='center'><%= XmlUtil.nNullCheck(f260) %></td>
		<td align='right'><%=  XmlUtil.checkValue("03","7.5",f261) %>&nbsp;</td>
		<td align='right'><%=  XmlUtil.checkValue("03","7.5",f262) %>&nbsp;</td>
</tr>
<%              	}   %>
</table>
<br><br>

<label style='margin-left:50px'><b>取引期間優遇幅パターン</b></label><br>
<table border='0' cellspacing='1' cellpadding='0' bgcolor="black" style='margin-left:50px'>
<tr>
    <td align="center" class=xTitle width='100'>期間(FROM)</td>
	<td align="center" class=xTitle width='100'>期間(TO)</td>
	<td align="center" class=xTitle width='100'>優遇幅</td>
</tr>
<%	                line_count = XmlUtil.nNullCheck(xp.xpd.node_value[ngrid7]);

	                if (line_count == 0) {
%>
<tr bgcolor="white">
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<%                  }

                	nidx = ngrid7 + 1;
                	for (int i = 0; i < line_count; i++) {
                		String f253 = xp.xpd.node_value[nidx++];
                		String f254 = xp.xpd.node_value[nidx++];
                		String f255 = xp.xpd.node_value[nidx++];
%>
<tr bgcolor="white">
	<td align='center'><%= XmlUtil.nNullCheck(f253) %></td>
	<td align='center'><%= XmlUtil.nNullCheck(f254) %></td>
	<td align='right'><%= XmlUtil.checkValue("03","7.5",f255) %>&nbsp;</td>
</tr>
<%                  }   %>
</table>
</div>





<!-- 8th tab : 証明書継続発行情報 ------------------------------------------------------------------>
<div id=tabPages class='TabPage padding_ver_20'>
<label style="text-align:left;margin-left:0px"><b>残高証明書</b></label><br>
<!-- Field [187 - 198] -->
<span style="width:100%; height:50px; overflow:0; border:0px solid">
<table width=100% cellspacing=1 cellpadding=2 bgcolor=black style='font-size:9pt'>
	<tr>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>1月</label></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>2月</label></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>3月</label></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>4月</label></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>5月</label></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>6月</label></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>7月</label></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>8月</label></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>9月</label></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>10月</label></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>11月</label></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>12月</label></td>
	</tr>
	<tr>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f187 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[239]) %>" style="width:100%;"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f188 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[240]) %>" style="width:100%;"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f189 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[241]) %>" style="width:100%;"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f190 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[242]) %>" style="width:100%;"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f191 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[243]) %>" style="width:100%;"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f192 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[244]) %>" style="width:100%;"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f193 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[245]) %>" style="width:100%;"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f194 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[246]) %>" style="width:100%;"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f195 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[247]) %>" style="width:100%;"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f196 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[248]) %>" style="width:100%;"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f197 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[249]) %>" style="width:100%;"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f198 readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[250]) %>" style="width:100%;"></td>
	</tr>
</table>
</span><br><br>

<table cellpadding='0' cellspacing='0' style='margin-left:50px;'>
	<tr>
		<td nowrap style='text-align:right;'><label class="tab_page_label">発行枚数</label></td>
		<td><input name='f183' style='width:25px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[234]) %>"></td>
		<td nowrap style='text-align:right;'><label class="tab_page_label">残高証明発行減免額</label></td>

		<td><input name='f185' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[236] ,xp.oheader.node_value[35]) %>"></td>

<!--    <td nowrap style='text-align:right;'><label class="tab_page_label">残高証明書証明日</label></td-->
		<td><input name='f184' type='hidden' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[235]) %>"></td>
	</tr>
	<tr>
		<td nowrap style='text-align:right;'><label class="tab_page_label">残高証明書発行手数料</label></td>
<!--	<td><input name='f186' style='width:150px'></td>-->
		<td><input name='f298' style='width:25px' readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[237]) %>"><input name='f299' style='width:200px' readonly tabindex='-1' value="<%= xp.xpd.node_value[238].trim() %>"></td>
	</tr>
</table><br>

<label style="text-align:left;margin-left:0"><b>利息証明書</b></label><br>
<!-- Field [202 - 237] -->
<span style="width:100%; height:144; overflow:auto; border:0px solid">
<table width=100% cellspacing=1 cellpadding=0 bgcolor=black style='font-size:9pt'>
	<tr style='font-weight:bold'>
		<td align='center' class=xTitle colspan=2>基準月指定</td>
		<td align='center' class=xTitle colspan=2>利息証明書発行期間</td>
		<td align='center' class=xTitle colspan=2>基準月指定</td>
		<td align='center' class=xTitle colspan=2>利息証明書発行期間</td>
	</tr>
	<tr>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>1月</label></td>
		<td align='center' bgcolor=white width=100><input type="checkbox" name=f202   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[255]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[255]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f203   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[256]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f204   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[257]) %>"></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>2月</label></td>
		<td align='center' bgcolor=white width=100><input type="checkbox" name=f205   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[258]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[258]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f206   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[259]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f207   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[260]) %>"></td>
	</tr>
	<tr>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>3月</label></td>
		<td align='center' bgcolor=white><input type="checkbox" name=f208   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[261]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[261]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f209   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[262]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f210   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[263]) %>"></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>4月</label></td>
		<td align='center' bgcolor=white><input type="checkbox" name=f211   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[264]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[264]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f212   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[265]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f213   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[266]) %>"></td>
	</tr>
	<tr>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>5月</label></td>
		<td align='center' bgcolor=white><input type="checkbox" name=f214   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[267]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[267]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f215   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[268]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f216   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[269]) %>"></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>6月</label></td>
		<td align='center' bgcolor=white><input type="checkbox" name=f217   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[270]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[270]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f218   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[271]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f219   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[272]) %>"></td>
	</tr>
	<tr>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>7月</label></td>
		<td align='center' bgcolor=white><input type="checkbox" name=f220   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[273]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[273]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f221   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[274]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f222   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[275]) %>"></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>8月</label></td>
		<td align='center' bgcolor=white><input type="checkbox" name=f223   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[276]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[276]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f224   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[277]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f225   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[278]) %>"></td>
	</tr>
	<tr>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>9月</label></td>
		<td align='center' bgcolor=white><input type="checkbox" name=f226   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[279]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[279]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f227   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[280]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f228   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[281]) %>"></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>10月</label></td>
		<td align='center' bgcolor=white><input type="checkbox" name=f229   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[282]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[282]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f230   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[283]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f231   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[284]) %>"></td>
	</tr>
	<tr>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>11月</label></td>
		<td align='center' bgcolor=white><input type="checkbox" name=f232   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[285]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[285]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f233   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[286]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f234   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[287]) %>"></td>
		<td class=xTitle align='center' bgcolor=white><label style=width:30px>12月</label></td>
		<td align='center' bgcolor=white><input type="checkbox" name=f235   readonly tabindex='-1' value="<%= XmlUtil.nNullCheck(xp.xpd.node_value[288]) %>" <%= XmlUtil.nNullCheck(xp.xpd.node_value[288]) > 0 ? "checked" : "" %>></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f236   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[289]) %>"></td>
		<td align='center' bgcolor=white><input size=10 class=xInput name=f237   readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[290]) %>"></td>
	</tr>
</table>
</span><br><br>

<table cellpadding='0' cellspacing='0' style='margin-left:50px;'>
	<tr>
		<td nowrap style='text-align:right;'><label class="tab_page_label">発行枚数</label></td>
		<td><input name='f199' style='width:25px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[251]) %>"></td>
		<td width='200'></td>
		<td nowrap style='text-align:right;'><label class="tab_page_label">利息証明発行減免額</label></td>

		<td><input name='f200' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[252] ,xp.oheader.node_value[35]) %>"></td>

	</tr>
	<tr>
		<td nowrap style='text-align:right;'><label class="tab_page_label">利息証明書発行手数料</label></td>
<!--	<td colspan='2'><input name='f201' style='width:150px'></td>-->
		<td colspan='3'><input name='f300' style='width:25px' readonly tabindex='-1' value="<%= xp.xpd.node_value[253] %>"><input name='f301' style='width:200px' readonly tabindex='-1' value="<%= xp.xpd.node_value[254].trim() %>"></td>
	</tr>
</table><br>

<label style="text-align:left;margin-left:0"><b>減税証明書</b></label><br>

<table cellpadding='0' cellspacing='0' style="margin-left:50px">
	<tr>
		<td nowrap style='text-align:right;'><label class="tab_page_label">減税証明書最終実行日</label></td>
		<td><input name='f238' style='width:80px' value="<%= XmlUtil.makeDate(xp.xpd.node_value[291]) %>"></td>
		<td width='50'></td>
		<td nowrap style='text-align:right;'><label class="tab_page_label">減税証明書当初貸出額</label></td>

		<td><input name='f239' style='width:130px;text-align:right' readonly value="<%= makemask7("14.2" ,xp.xpd.node_value[292] ,xp.oheader.node_value[35]) %>"></td>

		<!-- 減税証明発行期間追加-->
		<td nowrap style='text-align:right;'><label class="tab_page_label">減税証明発行期間</label></td>
		<td><input name='f804' style='width:30px;text-align:right;' readonly tabindex='-1' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[310]) %>"></td>
	</tr>
	<tr>
		<td nowrap style='text-align:right;'><label class="tab_page_label">減税証明書借入金内訳</label></td>
		<td><select name='f240' table='LNPCODE' key='727' disabled=true></select></td>
		<td>&nbsp;</td>
		<td nowrap style='text-align:right;'><label class="tab_page_label">減税証明書発行事由</label></td>
		<td><select name='f602' disabled=true> <!--table='COMCOMB' key='4714'!--> 
<%
				ntemp = XmlUtil.nNullCheck(xp.xpd.node_value[301]);
%>
			<option value="0" <%= ntemp == 0 ? "selected" : "" %>></option>
			<option value="1" <%= ntemp == 1 ? "selected" : "" %>>年末調整</option>
			<option value="2" <%= ntemp == 2 ? "selected" : "" %>>確定申告</option>
		</select></td>
		<td nowrap style='text-align:right;'><label class="tab_page_label">発行枚数</label></td>
		<td><input name='f241' style='width:25px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[294]) %>"></td>
	</tr>
	<tr>
		<td nowrap style='text-align:right;'><label class="tab_page_label">租税特別措置項</label></td>
		<td><input name='f242' style='width:25px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[295]) %>"></td>
		<td>&nbsp;</td>
		<td nowrap style='text-align:right;'><label class="tab_page_label">租税特別措置号</label></td>
		<td><input name='f243' style='width:25px' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[296]) %>"></td>
		<td nowrap style='text-align:right;'><label class="tab_page_label">賦払期間</label></td>
		<td><input name='f244' style='width:30px;text-align:right;' value="<%= XmlUtil.strZeroNullCheck(xp.xpd.node_value[297]) %>"></td>
	</tr>
</table>
</div>





<!-- 9th tab : 分割実行明細情報 -------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>
<table border='0' cellspacing='1' cellpadding='0' bgcolor="black" style="margin-left:2px;">
	<tr>
		<td align="center" class=xTitle width=80>分割実行回次</td>
		<td align="center" class=xTitle width=100>分割実行予定日</td>
		<td align="center" class=xTitle width=150>分割実行予定金額</td>
		<td align="center" class=xTitle width=100>分割実行日</td>
		<td align="center" class=xTitle width=150>分割実行金額</td>
		<td align="center" class=xTitle width=100>適用金利</td>
		<td align="center" class=xTitle width=100>最終分割実行区分</td>
	</tr>
<%                	line_count = XmlUtil.nNullCheck(xp.xpd.node_value[ngrid5]);

                	if (line_count == 0) {
%>
	<tr bgcolor="white">
		<td height='20px'>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<%                  }
                	nidx = ngrid5 + 1;
                	for (int i = 0; i < line_count; i++) {
                		String f400 = xp.xpd.node_value[nidx++];
                		String f401 = xp.xpd.node_value[nidx++];
                		String f402 = xp.xpd.node_value[nidx++];
                		String f403 = xp.xpd.node_value[nidx++];
                		String f404 = xp.xpd.node_value[nidx++];
                		String f405 = xp.xpd.node_value[nidx++];
                		String f406 = xp.xpd.node_value[nidx++];
%>
	<tr bgcolor="white">
		<td align='center' height='20px'><%= XmlUtil.nNullCheck(f400) %></td>
		<td align='center'><%= XmlUtil.makeDate(f401) %></td>

		<td align='right' ><%= makemask7("14.2" ,f402 ,xp.oheader.node_value[35]) %>&nbsp;</td>

		<td align='center'><%= XmlUtil.makeDate(f403) %></td>

		<td align='right' ><%= makemask7("14.2" ,f404 ,xp.oheader.node_value[35]) %>&nbsp;</td>

		<td align='right' ><%= XmlUtil.checkValue("03","7.5",f405) %>&nbsp;</td>
		<td align='center'><%= f406.trim() %></td>
	</tr>
<%              	}   %>
</table><br>
</div>




<!-- 10th tab : 極度取引情報 ----------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>

<table border="0" cellspacing="1" cellpadding="0" bgcolor="black" style="font-size:9pt">
	<tr bgcolor='darkgary' align='center'>
		<td class=xTitle width='20px'  nowrap height='20px'>&nbsp&nbsp</td>
        <td class=xTitle width='130px' nowrap>極度相談番号</td>
		<td class=xTitle width='120px' nowrap>極度種類</td>
		<td class=xTitle width='90px'  nowrap>科目名</td>
		<td class=xTitle width='80px'  nowrap>状態</td>
		<td class=xTitle width='120px' nowrap>取扱店</td>
		<td class=xTitle width='80px'  nowrap>新規取扱日</td>
		<td class=xTitle width='70px'  nowrap>処理口座数</td>
		<td class=xTitle width='80px'  nowrap>満期日</td>
		<td class=xTitle width='60px'  nowrap>極度利率</td>
		<td class=xTitle width='110px' nowrap>極度限度金額</td>
		<td class=xTitle width='110px' nowrap>極度残高</td>
		<td class=xTitle width='80px'  nowrap>処理日付</td>
		<td class=xTitle width='80px'  nowrap>解除日付</td>
	</tr>
<%	                line_count = XmlUtil.nNullCheck(xp.xpd.node_value[ngrid8]);

                	if (line_count == 0) {
%>
	<tr bgcolor=white>
		<td align='center' height='20px' class=xTitle>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<%                  }
                	nidx = ngrid8 + 1;
                	for (int i = 0; i < line_count; i++) {
                		String f335 = xp.xpd.node_value[nidx++];
                		String f323 = xp.xpd.node_value[nidx++];
                		String f324 = xp.xpd.node_value[nidx++];
                		String f325 = xp.xpd.node_value[nidx++];
                		String f326= xp.xpd.node_value[nidx++];
                		String f327 = xp.xpd.node_value[nidx++];
                		String f338 = xp.xpd.node_value[nidx++];
                		String f329 = xp.xpd.node_value[nidx++];
                		String f330 = xp.xpd.node_value[nidx++];
                		String f331 = xp.xpd.node_value[nidx++];
                		String f332 = xp.xpd.node_value[nidx++];
                		String f333 = xp.xpd.node_value[nidx++];
                		String f334 = xp.xpd.node_value[nidx++];
%>
	<tr bgcolor=white>
		<td align='center' height='20px' class=xTitle ><%= i + 1 %></td>
		<td align='center'><%= XmlUtil.dataPattern("c",f335,0) %></td>
		<td>&nbsp; 		   <%= f323.trim() %></td>
		<td align='center'><%= f324.trim() %></td>
		<td align='center'><%= f325.trim() %></td>
		<td>&nbsp; 		   <%= f326.trim() %></td>
		<td align='center'><%= XmlUtil.makeDate(f327) %></td>
		<td align='right' ><%= XmlUtil.nNullCheck(f338) %>&nbsp;</td>
		<td align='center'><%= XmlUtil.makeDate(f329) %></td>
		<td align='right' ><%= XmlUtil.checkValue("03","7.5",f330) %>&nbsp;</td>

		<td align='right' ><%= makemask7("17.2" ,f331 ,xp.oheader.node_value[35]) %>&nbsp;</td>
		<td align='right' ><%= makemask7("17.2" ,f332 ,xp.oheader.node_value[35]) %>&nbsp;</td>

		<td align='center'><%= XmlUtil.makeDate(f333) %></td>
		<td align='center'><%= XmlUtil.makeDate(f334) %></td>
	</tr>
<%              	}   %>
</table><br>
</div>




<!-- 11th tab : 不均等返済額情報 ------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>

<table border="0" cellspacing="1" cellpadding="0" bgcolor="black" style="font-size:9pt">
	<tr bgcolor='darkgary' align='center'>
	    <td class=xTitle nowrap width='30px' height='20px'>順番</td>
		<td class=xTitle nowrap width='210px'>返済回次(FROM)</td>
		<td class=xTitle nowrap width='210px'>返済回次(TO)</td>
		<td class=xTitle nowrap width='340px'>不均等返済額</td>
	</tr>
<%	                line_count = XmlUtil.nNullCheck(xp.xpd.node_value[ngrid9]);

                	if (line_count == 0) {
%>
	<tr bgcolor=white>
		<td height='20px' class=xTitle>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<%                  }
                	nidx = ngrid9 + 1;
                	for (int i = 0; i < line_count; i++) {
                        String f334 = xp.xpd.node_value[nidx++];
                		String f344 = xp.xpd.node_value[nidx++];
                		String f345 = xp.xpd.node_value[nidx++];
%>
	<tr bgcolor=white >
		<td align='center' height='20px' class=xTitle><%= i + 1 %></td>
        <td align='center'><%= XmlUtil.nNullCheck(f334) %></td>
        <td align='center'><%= XmlUtil.nNullCheck(f344) %></td>

		<td align='right' ><%= makemask7("17.2" ,f345 ,xp.oheader.node_value[35]) %>&nbsp;&nbsp;</td>


	</tr>
<%              	}   %>

</table>
</div>


<!--
f361:CURRENCYCD

f356:SWAPCONTDATE
f357:APPCAMT
f358:EXCONTDATE
f359:SWAPRATE
f360:FXJPYAMT

f350:MARKETCD1
f351:MARKETCD2
f352:MARKETCD3
f353:MARKETCD4
f354:MARKETCD5

f355:IMPTSWAP
-->
<!-- 12th tab : 外貨情報 ------------------------------------------------------------------------>
<div id=tabPages class='TabPage padding_ver_20'>
<table border=0 cellpadding='0' cellspacing='0' style="text-align:left;margin-left:30px">
	<tr>
		<td colspan='2' nowrap style='text-align:left;'><label class="tab_page_label"><b>スワップ契約情報</b></label></td>
		<td colspan='2' nowrap style='text-align:left;'><label class="tab_page_label"><b>参照市場カレンダー</b></label></td>+
	</tr>
	<tr>
		<td colspan='4'>&nbsp;</td>
	</tr>
	<tr>
		<td nowrap style='text-align:left;'><label class="tab_page_label">スワップ契約締結日</label></td>
		<td><input name='f356' style='width:80px;text-align:right;' readonly tabindex='-1' value="<%= XmlUtil.makeDate(xp.xpd.node_value[337]) %>"></td>
		<td nowrap style='text-align:left;'><label class="tab_page_label">市場1</label></td>
		<td><select name='f350' table='LNPCODE' key='753' disabled=true></select></td> <!-- XmlUtil.nNullCheck(xp.xpd.node_value[322]) !-->
	</tr>
	<tr>
		<td nowrap style='text-align:left;'><label class="tab_page_label">申込金額</label></td>
		<td><input name='f357' style='width:130px;text-align:right' value="<%= makemask7("17.2" ,xp.xpd.node_value[338] ,xp.oheader.node_value[35]) %>" readonly tabindex='-1'></td>
		<td nowrap style='text-align:left;'><label class="tab_page_label">市場2</label></td>
		<td><select name='f351' table='LNPCODE' key='753' disabled=true></select></td> <!-- XmlUtil.nNullCheck(xp.xpd.node_value[323]) !-->
	</tr>
	<tr>
		<td nowrap style='text-align:left;'><label class="tab_page_label">為替予約日</label></td>
		<td><input name='f358' style='width:80px;text-align:right;' readonly tabindex='-1' value="<%= XmlUtil.makeDate(xp.xpd.node_value[339]) %>"></td>
		<td nowrap style='text-align:left;'><label class="tab_page_label">市場3</label></td>
		<td><select name='f352' table='LNPCODE' key='753' disabled=true></select></td> <!-- XmlUtil.nNullCheck(xp.xpd.node_value[324]) !-->
	</tr>
	<tr>
		<td nowrap style='text-align:left;'><label class="tab_page_label">スワップレート</label></td>
		<td><input name='f359' style='width:130px;text-align:right' value="<%=XmlUtil.checkValue("03","12.6",xp.xpd.node_value[340]) %>" readonly tabindex='-1'>&nbsp;円 （為替予約金額）</td>
		<td nowrap style='text-align:left;'><label class="tab_page_label">市場4</label></td>
		<td><select name='f353' table='LNPCODE' key='753' disabled=true></select></td> <!-- XmlUtil.nNullCheck(xp.xpd.node_value[325]) !-->
	</tr>
	<tr>
		<td nowrap style='text-align:left;'><label class="tab_page_label">確定円貨金額</label></td>
		<td><input name='f360' style='width:130px;text-align:right' value="<%= XmlUtil.checkValue("02","17.2",xp.xpd.node_value[341]) %>" readonly tabindex='-1'>&nbsp;円</td>
		<td nowrap style='text-align:left;'><label class="tab_page_label">市場5</label></td>
		<td><select name='f354' table='LNPCODE' key='753' disabled=true></select></td> <!-- XmlUtil.nNullCheck(xp.xpd.node_value[326]) !-->
	</tr>
	<tr>
		<td colspan='3' nowrap style='text-align:right;'><label class="tab_page_label">インパクトローン</label></td>
		<td><input type='checkbox' name='f355' style='margin-left:-4px' disabled=true <%= xp.xpd.node_value[336].compareTo("1") == 0 ? "checked" : "" %>>&nbsp;YES</td>
	</tr>
	<tr>
		<td colspan='3' nowrap style='text-align:right;'><label class="tab_page_label">スワップ契約</label></td>
		<td>&nbsp;</td>
	</tr>
</table>
</div>
<!-- 1３th tab : 約定返済 ------------------------------------------------------------------------>
<div id=tabPages class='TabPage padding_ver_20'>
<table border=0 cellpadding='0' cellspacing='0' style="text-align:left;margin-left:30px">

	<tr>
		<td nowrap style='text-align:left;'><label class="tab_page_label">前回約定日</label></td>
		<td><input name='f362' style='width:80px;' readonly tabindex='-1' value="<%= XmlUtil.makeDate(xp.xpd.node_value[344]) %>"></td>
		<td nowrap style='text-align:left;'><label class="tab_page_label">今回約定日</label></td>
		<td><input name='f363' style='width:80px;' readonly tabindex='-1' value="<%= XmlUtil.makeDate(xp.xpd.node_value[345]) %>"></td>
	</tr>
	<tr>
		<td nowrap style='text-align:left;'><label class="tab_page_label">最終約定充当日</label></td>
		<td><input name='f364' style='width:80px;' readonly tabindex='-1' value="<%= XmlUtil.makeDate(xp.xpd.node_value[346]) %>"></td>
	</tr>
	<tr>
		<td nowrap style='text-align:left;'><label class="tab_page_label">今回約定返済額</label></td>
		<td><input name='f365' style='width:130px;text-align:right' value="<%= XmlUtil.checkValue("02","17.2",xp.xpd.node_value[347]) %>" readonly tabindex='-1'></td>
		<td nowrap style='text-align:left;'><label class="tab_page_label">今回約定充当額</label></td>
		<td><input name='f366' style='width:130px;text-align:right' value="<%= XmlUtil.checkValue("02","17.2",xp.xpd.node_value[348]) %>" readonly tabindex='-1'></td>
	</tr>
	<tr>
		<td nowrap style='text-align:left;'><label class="tab_page_label">未収手数料合計</label></td>
		<td><input name='f367' style='width:130px;text-align:right' value="<%= XmlUtil.checkValue("02","17.2",xp.xpd.node_value[349]) %>" readonly tabindex='-1'>
		<!--20210204 EK Button Add-->
		<button name='feeButton' type='button' onclick='u_go_17610()'><sup>&nbsp;</sup><script type="text/javascript">w1('QUERY')</script></td>
		<td nowrap style='text-align:left;'><label class="tab_page_label">未収利息合計</label></td>
		<td><input name='f368' style='width:130px;text-align:right' value="<%= XmlUtil.checkValue("02","17.2",xp.xpd.node_value[350]) %>" readonly tabindex='-1'>
		<!--20210204 EK Button Add-->
		<button name='intButton' type='button' onclick='u_go_17620()'><sup>&nbsp;</sup><script type="text/javascript">w1('QUERY')</script></td>
	</tr>
	<tr>
		<td nowrap style='text-align:left;'><label class="tab_page_label">延滞金額</label></td>
		<td><input name='f369' style='width:130px;text-align:right' value="<%= XmlUtil.checkValue("02","17.2",xp.xpd.node_value[351]) %>" readonly tabindex='-1'></td>
	</tr>

</table>
</div>
<!--20210204 EK Edit Start-->
<input name='z1_1' type='hidden'>
<input name='z1_2' type='hidden'>
<input name='z1_3' type='hidden'>
<input name='z1_4' type='hidden'>
<input name='z1_5' type='hidden'>
<input name='z2'   type='hidden'>
<input name='z3'   type='hidden'>
<input name='z4'   type='hidden'>
<input name='z5_1' type='hidden'>
<input name='z5_2' type='hidden'>
<input name='z5_3' type='hidden'>
<input name='z6_1' type='hidden'>
<input name='z6_2' type='hidden'>
<input name='z6_3' type='hidden'>
<input name='z7'   type='hidden'>
<!--20210204 EK Edit End-->

<%
			}
			else {
				out.println("<p>"+xp.getErrorMsg()+"</p>");
			}
		}
		else {
			out.println("<p>Error Code : '"+strError+"'</p>");
		}
	}
	else {
		out.println("<p>MQ Message is NULL</p>");
	}
%>

