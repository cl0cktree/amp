<%@ page contentType="text/html;charset=Windows-31J" %>
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
<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ek.web.util.WebUtil"%>
<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
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

public String CutZero (String sData) {
	int i;
	for (i = 0; sData.length () > i; i++)
		if (sData.charAt (i) != '0')
			break;
	if (i == sData.length ()) return "0";

	return sData.substring (i);
}

public String CutZeroDate (String sData) {
	int i;
	for (i = 0; sData.length () > i; i++)
		if (sData.charAt (i) != '0')
			break;
	if (i == sData.length ()) return "0";

	return sData.substring (i, i + 4) + "-" + sData.substring (i + 4, i +6) + "-" + sData.substring (i + 6, i + 8);
}

public String UserNum (String sData) {
	return sData.substring (sData.length () - 10, sData.length ());
}

public String AccountNum (String sData) {
	return sData.substring (7, 11) + "-" + sData.substring (11, 13) + "-" + sData.substring (13, 20);
}

public String ProductCode (String sData) {
       /* 20160330 */
       System.out.println("ProductCode:["+sData+"]<BR>");
       if( sData.length()>=11 ){
	   return sData.substring (0, 2) + "-" + sData.substring (2, 4) + "-" + sData.substring (4, 7) + "-" + sData.substring (7, 11);}
       return "";
}

public String CutZeroMoney (String sData) {
	int i, j;
	for (i = 0; sData.length () > i; i++)
		if (sData.charAt (i) != '0')
			break;
	if (i == sData.length ()) return "0";

	String a = null;
	for (j = sData.length()-2; j > i + 3; j -=3)
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

public String ZeroCheck(String strData) {
	try {
		int ntemp = Integer.parseInt(strData);

		if (ntemp == 0) return "";
		else return strData;
	}
	catch (Exception e) {
		return "";
	}
}

public String ZeroTrim(String strData) {
	try {
		int ntemp = Integer.parseInt(strData);

		if (ntemp == 0) return "";
		else return Integer.toString(ntemp);
	}
	catch (Exception e) {
		return "";
	}
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
<%	response.setContentType("text/html; charset=Windows-31J");

String f4_1 = "";
String f4_2 = "";
String f4_3 = "";
String f4_4 = "";
String f4_5 = "";
String f7 = "";
String f9_1 = "";
String f9_2 = "";
String f9_3 = "";
String f10 = "";
String f11 = "";
String f12 = "";
String f13 = "";
String f14 = "";
String f15 = "";
String f16 = "";
String f17 = "";
String f18 = "";
String f19 = "";
String f20 = "";
String f21_1 = "";
String f21_2 = "";
String f21_3 = "";
String f21_4 = "";
String f21_5 = "";
String f96 = "";
String f97 = "";
String f22 = "";
String f23 = "";
String f24 = "";
String f25 = "";
String f98 = "";
String f99 = "";
String f101 = "";
String f102 = "";
String f106 = "";
String f107 = "";
String f108 = "";
String f109 = "";
String f29 = "";
String f6 = "";
String f26 = "";
String f27 = "";
String f28 = "";
String f30 = "";
String f31 = "";
String f32 = "";
String f33 = "";
String f34 = "";
String f35 = "";
String f36 = "";
String f37 = "";
String f38 = "";
String f39 = "";
String f40 = "";
String f41 = "";
String f42 = "";
String f43 = "";
String f44 = "";
String f45 = "";
String f46 = "";
String f47 = "";
String f48 = "";
String f50 = "";
String f51 = "";
String f52 = "";
String f54 = "";
String f55 = "";
String f56 = "";
String f57_1 = "";
String f57_2 = "";
String f57_3 = "";
String f58 = "";
String f59 = "";
String f60 = "";
String f61_1 = "";
String f61_2 = "";
String f61_3 = "";
String f62 = "";
String f63 = "";
String f64 = "";
String f66 = "";
String f67 = "";
String f68 = "";
String f69 = "";
String f70 = "";
String f71 = "";
String f460 = "";
String f75 = "";
String f76 = "";
String f77 = "";
String f79 = "";
String f80 = "";
String f150 = "";
String f81 = "";
String f82 = "";
String f83 = "";
String f84 = "";
String f85 = "";
String f86_1 = "";
String f86_2 = "";
String f86_3 = "";
String f87_1 = "";
String f87_2 = "";
String f87_3 = "";
String f88_1 = "";
String f88_2 = "";
String f88_3 = "";
String f89_1 = "";
String f89_2 = "";
String f89_3 = "";
String f90_1 = "";
String f90_2 = "";
String f90_3 = "";
String f111 = "";
String f510 = "";
String f401 = "";
String f402 = "";
String f403 = "";
String f53 = "";
String f404 = "";
String f405 = "";
String f406 = "";
String f408 = "";
String f408Lbl = "";
String f407 = "";
String f407Lbl = "";
String f500 = "";
String f500Lbl = "";
String f409 = "";
String f410 = "";
String f411 = "";
String f412 = "";
String f413_1 = "";
String f413_2 = "";
String f413_3 = "";
String f414 = "";
String f415_1 = "";
String f415_2 = "";
String f415_3 = "";
String f416 = "";
String f417_1 = "";
String f417_2 = "";
String f417_3 = "";
String f418 = "";
String f419_1 = "";
String f419_2 = "";
String f419_3 = "";
String f413 = "";
String f415 = "";
String f417 = "";
String f419 = "";
String f420 = "";
String f421 = "";
String f422 = "";
String f423 = "";
String f424 = "";
String f425 = "";
String f426 = "";
String f426Lbl = "";
String f435 = "";
String f436 = "";

// 2013.3.16 実行代わり金振込処理対応 本多 START
String f444 = "";
String f444_1 = "";
String f444_2 = "";
String f444_3 = "";
String f444_4 = "";
String f444_1Lbl = "";
String f444_2Lbl = "";
String f444_3Lbl = "";
String f508 = "";
String f508_1 = "";
String f508_2 = "";
String f508_3 = "";
String f508_4 = "";
String f508_1Lbl = "";
String f508_2Lbl = "";
String f508_3Lbl = "";
String f509 = "";
// 2013.3.16 実行代わり金振込処理対応 本多 END

String f445_1 = "";
String f445_3 = "";
String f445_2 = "";

String f446 = "";
String f447 = "";
String f448 = "";
String f449 = "";
String f450 = "";
String f451 = "";
String f452 = "";
String f455 = "";
String f456 = "";
String f501 = "";
String f502 = "";
String f453 = "";
String f454 = "";
String f74 = "";
String f442 = "";
String f443 = "";
String f438 = "";
String f441 = "";
String f457 = "";
String f296Lbl = "";
String f297Lbl = "";
String f223Lbl = "";
String f409Lbl = "";
String f6Lbl = "";
String f9Lbl = "";
String f10Lbl = "";
String f11Lbl = "";
String f12Lbl = "";
String f503 = "";
String f504 = "";
String f505 = "";
String f458 = "";
String f506 = "";
String f507 = "";

int nLoop7 = 0;		//7th tab grid count
int nLoop8 = 0;		//8th tab grid count

/* 6th tab grid */
String [] f428 = null;
String [] f429 = null;
String [] f430 = null;
String [] f431 = null;

/* 7th tab grid */
String [] f131 = null;
String [] f132 = null;
String [] f133 = null;
String [] f134 = null;
String [] f135 = null;
String [] f136 = null;
String [] f137 = null;
String [] f138 = null;
String [] f139 = null;
String [] f140 = null;
String [] f141 = null;
String [] f142 = null;

/* 8th tab grid */
String f151 = "";
String f152 = "";
String [] f153 = null;
String [] f154 = null;
String [] f155 = null;

/* 9th tab */
String f601 = "";
String f602 = "";
String f603 = "";
String f604 = "";
String f605 = "";
String f606 = "";
String f607 = "";
String f608 = "";

/* 20200331 EK Edit Start 3rd tab */
String f461 = "";
/* 20200331 EK Edit End 3rd tab */

	byte [] rcvMsg = null;
	String strOutMessage = null;
/* 20160706
	if ((String) application.getAttribute(request.getRemoteAddr()) != null) {
		strOutMessage = (String) application.getAttribute(request.getRemoteAddr());
		application.removeAttribute(request.getRemoteAddr());
	}
*/
        String resultid = request.getParameter("RESULTID");
 System.out.println("[13300_02]resultid:" + resultid );
        if ( resultid != null ){
          strOutMessage = (String) application.getAttribute(resultid);
          if( strOutMessage!=null ) application.removeAttribute(resultid);
        }

	if ( strOutMessage != null ) {
		//rcvMsg = strOutMessage.getBytes ();
                // 20160330
		rcvMsg = strOutMessage.getBytes ("MS932");
	}
	//==============================================================================//
	String xmlFile = request.getSession().getServletContext().getRealPath("/codeXml/4.LON/13300_01out.xml");
	String oHeaderFile = request.getSession().getServletContext().getRealPath("/xml/OUT_HEADER.xml");
	//==============================================================================//
	if (rcvMsg != null) {

		String strError = "";

		XmlParse1 xp = new XmlParse1();
		XmlParse oxp = new XmlParse();
		xp.init(xmlFile);
		xp.setOutHeaderFile(oHeaderFile);
		
		if (xp.setOutHeader(rcvMsg)) {
			strError = xp.oheader.node_value[34];
		}
		if ("000000".compareTo(strError) == 0) {
			if (xp.parseXml(rcvMsg)) {
				/* LOANCNAPINFO */
/*				
out.println("f507:["+xp.xpd.node_value[220]+"]<BR>");

//out.println("Tot_lengh:["+xp.xpd.node_value.length+"]<BR>");
//out.println("f507:["+xp.xpd.node_value[220]+"]<BR>");
//out.println("f42:["+xp.xpd.node_value[88]+"]<BR>");


int ilen = xp.xpd.node_value.length;
//out.println("[315]-->["+xp.xpd.node_value[315]+"]<BR>");
//out.println("[316]-->["+xp.xpd.node_value[316]+"]<BR>");

//out.println("ilen--------------------------------->"+ilen+"<BR>");	
//for(int i=219; i<226; i++){
for(int i=0; i<ilen; i++){
	out.println("["+i+"]-->["+xp.xpd.node_value[i]+"]<BR>");
}

int ilen = xp.xpd.node_value.length;
for(int i=0; i<ilen; i++){
	out.println("["+i+"]-->["+xp.xpd.node_value[i]+"]<BR>");
}
*/	
				f4_1 = xp.xpd.node_value[8].trim();
				f4_2 = xp.xpd.node_value[9].trim();
				f4_3 = xp.xpd.node_value[10].trim();
				f4_4 = xp.xpd.node_value[11].trim();
				f4_5 = xp.xpd.node_value[12].trim();

				//20160331 fx add
				//f6 = CutZeroMoney(xp.xpd.node_value[14]);
				f6   = makemask7("17.2",xp.xpd.node_value[14],xp.oheader.node_value[35]);

				f7 = xp.xpd.node_value[16].trim();
				f9_1 = xp.xpd.node_value[18].trim();
				f9_2 = xp.xpd.node_value[19].trim();
				f9_3 = xp.xpd.node_value[20].trim();
				f10 = xp.xpd.node_value[21].trim();
				f11 = xp.xpd.node_value[22].trim();
				f12 = xp.xpd.node_value[23].trim();
				f13 = xp.xpd.node_value[24].trim();
				f14 = xp.xpd.node_value[25].trim();
				f15 = xp.xpd.node_value[26];
				f501 = xp.xpd.node_value[27].trim();
				f16 = xp.xpd.node_value[28];
				f17 = xp.xpd.node_value[29];
				f18 = xp.xpd.node_value[30];
				f19 = ZeroCheck(xp.xpd.node_value[31]);
				f20 = xp.xpd.node_value[32];
				f21_1 = xp.xpd.node_value[33].trim();
				f21_2 = xp.xpd.node_value[34].trim();
				f21_3 = xp.xpd.node_value[35].trim();
				f21_4 = xp.xpd.node_value[36].trim();
				f21_5 = xp.xpd.node_value[37].trim();
				f22 = ZeroCheck(xp.xpd.node_value[38]);
				f502 = xp.xpd.node_value[39].trim();
				f23 = ZeroCheck(xp.xpd.node_value[40]);
				f24 = xp.xpd.node_value[41];
				f25 = xp.xpd.node_value[42];

				/* LOANCNAPINFO */
				f26 = xp.xpd.node_value[44].trim();
				f27 = xp.xpd.node_value[45].trim();
				f28 = xp.xpd.node_value[46];
				f29 = xp.xpd.node_value[47];

				f30 = xp.xpd.node_value[49];
				f31 = ZeroTrim(xp.xpd.node_value[50]);
				f32 = ZeroTrim(xp.xpd.node_value[51]);
	
				f33 = ZeroTrim(xp.xpd.node_value[52]);
				f34 = ZeroTrim(xp.xpd.node_value[53]);
				f35 = ZeroTrim(xp.xpd.node_value[54]);
				f36 = ZeroTrim(xp.xpd.node_value[55]);
				f37 = ZeroTrim(xp.xpd.node_value[56]);
				f39 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[57]);
				f38 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[58]);
				f40 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[59]);
				f41 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[60]);
				f42 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[61]);
				f43 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[62]);
				f44 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[63]);
				f45 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[64]);
				f46 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[65]);
				f47 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[66]);
				f48 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[67]);
				f52 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[69]);
				f55 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[70]);
				f50 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[71]);
				f51 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[72]);
				f53 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[73]);
				f54 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[74]);
				f56 = xp.xpd.node_value[76];
				f57_1 = xp.xpd.node_value[77].trim();
				f57_2 = xp.xpd.node_value[78].trim();
				f57_3 = xp.xpd.node_value[79].trim();
				f58 = ZeroTrim(xp.xpd.node_value[80]);
				f59 = xp.xpd.node_value[81];
				f60 = xp.xpd.node_value[82];
				f61_1 = xp.xpd.node_value[83].trim();
				f61_2 = xp.xpd.node_value[84].trim();
				f61_3 = xp.xpd.node_value[85].trim();
				f62 = ZeroTrim(xp.xpd.node_value[86]);
				f63 = xp.xpd.node_value[87];
				f64 = xp.xpd.node_value[88].trim();
				if (Integer.parseInt(f30) != 0 ) {
					if ( (Integer.parseInt(f64) > 28) && (Integer.parseInt(f64) <= 31) ) {
						f64 = "32";
					}
				} else f64 = "";
				f66 = xp.xpd.node_value[90];
				f67 = xp.xpd.node_value[91];
				f68 = xp.xpd.node_value[92];
				f69 = xp.xpd.node_value[93];
				f70 = xp.xpd.node_value[94];
				f71 = xp.xpd.node_value[95];
				f460= xp.xpd.node_value[96];
            //  f72
			//  f73
				f74 = xp.xpd.node_value[99];

				//20160331 fx add
				f75   = makemask7("17.2",xp.xpd.node_value[100],xp.oheader.node_value[35]);

				f76 = xp.xpd.node_value[101];
				f77 = ZeroTrim(xp.xpd.node_value[102]);
			//  f78
				f79 = CutZeroMoney(xp.xpd.node_value[104]);
				f80 = CutZeroMoney(xp.xpd.node_value[105]);
				f150= xp.xpd.node_value[106];
				f81 = xp.xpd.node_value[107].trim();
				f82 = xp.xpd.node_value[108].trim();
				f83 = xp.xpd.node_value[109].trim();
				f84 = xp.xpd.node_value[110].trim();
				f85 = ZeroCheck(xp.xpd.node_value[111]);
				f86_1 = xp.xpd.node_value[112].trim();
				f86_2 = xp.xpd.node_value[113].trim();
				f86_3 = xp.xpd.node_value[114].trim();
				f87_1 = xp.xpd.node_value[115].trim();
				f87_2 = xp.xpd.node_value[116].trim();
				f87_3 = xp.xpd.node_value[117].trim();
				f88_1 = xp.xpd.node_value[118].trim();
				f88_2 = xp.xpd.node_value[119].trim();
				f88_3 = xp.xpd.node_value[120].trim();
				f89_1 = xp.xpd.node_value[121].trim();
				f89_2 = xp.xpd.node_value[122].trim();
				f89_3 = xp.xpd.node_value[123].trim();
				f90_1 = xp.xpd.node_value[124].trim();
				f90_2 = xp.xpd.node_value[125].trim();
				f90_3 = xp.xpd.node_value[126].trim();

				//20160429 fx add
				f421 =  makemask7("17.2",xp.xpd.node_value[127],xp.oheader.node_value[35]);
				f422 =  makemask7("17.2",xp.xpd.node_value[128],xp.oheader.node_value[35]);
				f423 =  makemask7("17.2",xp.xpd.node_value[129],xp.oheader.node_value[35]);
				f424 =  makemask7("17.2",xp.xpd.node_value[130],xp.oheader.node_value[35]);
				f425 =  makemask7("17.2",xp.xpd.node_value[131],xp.oheader.node_value[35]);

				f96 = xp.xpd.node_value[132];
				f97 = xp.xpd.node_value[133].trim();
				f96 = xp.xpd.node_value[132];
				f97 = xp.xpd.node_value[133].trim();

				/* BONDPROPERTYINFO */
				f98 = xp.xpd.node_value[135];
				f99 = xp.xpd.node_value[136];
				f101 = xp.xpd.node_value[137];
				f102 = xp.xpd.node_value[138];
				f106 = xp.xpd.node_value[143].trim();
				f107 = xp.xpd.node_value[144].trim();
				f108 = xp.xpd.node_value[145].trim();
				f109 = xp.xpd.node_value[146].trim();
            //  f110
				f111 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[148]);
				f510 = xp.xpd.node_value[149];
				f435 = xp.xpd.node_value[150].trim();
				f436 = CutZeroMoney(xp.xpd.node_value[151]);
				f426 = ZeroCheck(xp.xpd.node_value[152]);
				f426Lbl =xp.xpd.node_value[153];
				f401 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[154]);
				f402 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[155]);
				f403 = xp.xpd.node_value[156];
				f404 = xp.xpd.node_value[157];
				f405 = xp.xpd.node_value[158];
				f406 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[159]);
				f407 = ZeroCheck(xp.xpd.node_value[160]);
				f407Lbl = xp.xpd.node_value[161].trim();
				f408 = ZeroCheck(xp.xpd.node_value[162]);
			//  f408Lbl
				f500 = ZeroCheck(xp.xpd.node_value[164]);
			//	f500Lbl
				f409 = xp.xpd.node_value[166].trim();
				f410 = CutZeroMoney(xp.xpd.node_value[167]);
				f411 = CutZeroMoney(xp.xpd.node_value[168]);
				f412 = xp.xpd.node_value[169];
				f413_1 = xp.xpd.node_value[170].trim();
				f413_2 = xp.xpd.node_value[171].trim();
				f413_3 = xp.xpd.node_value[172].trim();
				f413 = xp.xpd.node_value[173].trim();
				f414 = XmlUtil.checkValue("02","3",xp.xpd.node_value[174]);
				f415_1 = xp.xpd.node_value[175].trim();
				f415_2 = xp.xpd.node_value[176].trim();
				f415_3 = xp.xpd.node_value[177].trim();
				f415 = xp.xpd.node_value[178].trim();
				f416 = XmlUtil.checkValue("02","3",xp.xpd.node_value[179]);
				f417_1 = xp.xpd.node_value[180].trim();
				f417_2 = xp.xpd.node_value[181].trim();
				f417_3 = xp.xpd.node_value[182].trim();
				f417 = xp.xpd.node_value[183].trim();
				f418 = XmlUtil.checkValue("02","3",xp.xpd.node_value[184]);
				f419_1 = xp.xpd.node_value[185].trim();
				f419_2 = xp.xpd.node_value[186].trim();
				f419_3 = xp.xpd.node_value[187].trim();
				f419 = xp.xpd.node_value[188].trim();
				f420 = XmlUtil.checkValue("02","3",xp.xpd.node_value[189]);
				f438 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[190]);
			//  f439
            //  f440
				f441 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[193]);
				f442 = xp.xpd.node_value[194].trim();
				f443 = xp.xpd.node_value[195].trim();
				f448 = xp.xpd.node_value[196].trim();
				f449 = xp.xpd.node_value[197].trim();
				f450 = xp.xpd.node_value[198].trim();
				f451 = xp.xpd.node_value[199].trim();
				f452 = xp.xpd.node_value[200].trim();
				f455 = xp.xpd.node_value[201].trim();
				f456 = xp.xpd.node_value[202].trim();
				
				// 2013.3.16 実行代わり金振込処理対応 本多 START
				/*f444 = xp.xpd.node_value[203].trim();
				if(f444 == ""){
					f444 = "000";
				}*/
				f444 = "000";
				f444_1 = xp.xpd.node_value[204].trim();
				f444_2 = xp.xpd.node_value[205].trim();
				f444_3 = xp.xpd.node_value[206].trim();
				f444_4 = xp.xpd.node_value[207].trim();
				//f508 = xp.xpd.node_value[208].trim();
				f508 = "000";
				f508_1 = xp.xpd.node_value[209].trim();
				f508_2 = xp.xpd.node_value[210].trim();
				f508_3 = xp.xpd.node_value[211].trim();
				f508_4 = xp.xpd.node_value[212].trim();
				f509 = xp.xpd.node_value[213].trim();
				
				f445_1 = xp.xpd.node_value[214].trim();
				f445_3 = xp.xpd.node_value[215].trim();
				f445_2 = xp.xpd.node_value[216].trim();
				f446 = xp.xpd.node_value[217];
				f447 = xp.xpd.node_value[218];
				f453 = xp.xpd.node_value[219];
				f454 = xp.xpd.node_value[220];
				f457 = xp.xpd.node_value[221];
				f503 = CutZero(xp.xpd.node_value[222]);
				f504 = CutZeroMoney(xp.xpd.node_value[223]);
				f505 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[224]);
				f458 = xp.xpd.node_value[225];
//20090519				
				f506 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[226]);
				f507 = ZeroTrim(xp.xpd.node_value[227]);
				// 2013.3.16 実行代わり金振込処理対応 本多 END
				
				if(f507.equals("7200")) {
					f64 = xp.xpd.node_value[88].trim();

					f75   = makemask7("17.2",xp.xpd.node_value[100],xp.oheader.node_value[35]);//20160331 fx add

					f76 = xp.xpd.node_value[101];
					f77 = xp.xpd.node_value[102];
				}

//20160331 fx add 
				f601   = (makemask7("17.2",xp.xpd.node_value[228],xp.oheader.node_value[35]) == "0")?"":makemask7("17.2",xp.xpd.node_value[228],xp.oheader.node_value[35]);
				f602   = (makemask7("17.2",xp.xpd.node_value[229],xp.oheader.node_value[35]) == "0")?"":makemask7("17.2",xp.xpd.node_value[229],xp.oheader.node_value[35]);
				f603   = (makemask7("17.2",xp.xpd.node_value[230],xp.oheader.node_value[35]) == "0")?"":makemask7("17.2",xp.xpd.node_value[230],xp.oheader.node_value[35]);
				f604   = (makemask7("17.2",xp.xpd.node_value[231],xp.oheader.node_value[35]) == "0")?"":makemask7("17.2",xp.xpd.node_value[231],xp.oheader.node_value[35]);
				f605   = (makemask7("17.2",xp.xpd.node_value[232],xp.oheader.node_value[35]) == "0")?"":makemask7("17.2",xp.xpd.node_value[232],xp.oheader.node_value[35]);
				f606   = (makemask7("17.2",xp.xpd.node_value[233],xp.oheader.node_value[35]) == "0")?"":makemask7("17.2",xp.xpd.node_value[233],xp.oheader.node_value[35]);				
				f607   = (makemask7("17.2",xp.xpd.node_value[234],xp.oheader.node_value[35]) == "0")?"":makemask7("17.2",xp.xpd.node_value[234],xp.oheader.node_value[35]);	

                f461 = xp.xpd.node_value[235].trim(); // 200331 EK Edit                 引落名義

				/* PRIVRATE */
				// 2013.3.16 実行代わり金振込処理対応 本多 START
				//int ngrid6 = 223;	//f434
				//int ngrid6 = 230;	//f434
				int ngrid6 = 238;	//f434
				// 2013.3.16 実行代わり金振込処理対応 本多 END
				
                //f428~f431 => 222~321 : 100Line

				/* LIMTREGINFO */
				int ngrid7 = ngrid6 + 104;   //f130
				String f130 = xp.xpd.node_value[ngrid7];
				nLoop7 = Integer.parseInt(f130);
				f131 = new String [nLoop7];
				f132 = new String [nLoop7];
				f133 = new String [nLoop7];
				f134 = new String [nLoop7];
				f135 = new String [nLoop7];
				f136 = new String [nLoop7];
				f137 = new String [nLoop7];
				f138 = new String [nLoop7];
				f139 = new String [nLoop7];
				f140 = new String [nLoop7];
				f141 = new String [nLoop7];
				f142 = new String [nLoop7];	//disabled

    			int nCunt7 = ngrid7 + 1;
				for (int i = 0; i < nLoop7; i++) {
			     	f131[i] = xp.xpd.node_value[nCunt7++].trim();
			     	f132[i] = xp.xpd.node_value[nCunt7++].trim();
			     	f133[i] = xp.xpd.node_value[nCunt7++].trim();
			     	f134[i] = xp.xpd.node_value[nCunt7++].trim();
			     	f135[i] = XmlUtil.makeDate(xp.xpd.node_value[nCunt7++]);
			     	f136[i] = XmlUtil.makeDate(xp.xpd.node_value[nCunt7++]);
			     	f137[i] = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[nCunt7++]);
			     	f138[i] = CutZeroMoney(xp.xpd.node_value[nCunt7++]);
			     	f139[i] = CutZeroMoney(xp.xpd.node_value[nCunt7++]);
			     	f140[i] = CutZero(xp.xpd.node_value[nCunt7++]);
			     	f141[i] = XmlUtil.makeDate(xp.xpd.node_value[nCunt7++]);
                    f142[i]	= xp.xpd.node_value[nCunt7++].trim();
				}

				/* REPAYAMTINFO */
                int ngrid8 = ngrid7 + (nLoop7 * 12) + 4;  //f158
                f151 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[ngrid8 + 1]);
                f152 = xp.xpd.node_value[ngrid8 + 2];
				nLoop8 = Integer.parseInt(f152);
				f155 = new String [nLoop8];
				f153 = new String [nLoop8];
				f154 = new String [nLoop8];

				int nCunt8 = ngrid8 + 3 ;
				for (int i=0; i<nLoop8; i++) {
					f155[i] = CutZero(xp.xpd.node_value[nCunt8++]);
					f153[i] = CutZero(xp.xpd.node_value[nCunt8++]);
			     	f154[i] = CutZeroMoney(xp.xpd.node_value[nCunt8++]);
    			}
	
				/* DEEMEDINTEREST */
				//f601 = XmlUtil.checkValue("02","3",xp.xpd.node_value[189]);

			}else {
				out.println("<p>"+xp.getErrorMsg()+"</p>");
			}
		}else {
			out.println("<p>Error Code : '"+strError+"'</p>");
		}
	}else {
		out.println("<p>MQ Message is NULL</p>");
	}
%>
<script>var trInXml = loadXML('/codeXml/4.LON/13300_02in.xml')</script>
<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
<script language="javascript" src="<%= request.getContextPath() %>/js/xhrSend.js"></script>
<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
<script>
var oldValue = "";
var repayMonth = "";
var repayYear = "";
var repayMth = "";
var repayDate = "";
var divissu = "";   //取引区分(貸出実行方法)

/* initPage Start ----------------------------------------------------------------------------*/
	function initPage() {
		setMsg("");
		//20100131 KimSunYong追加： ek内部障害対応
		if('<%=f507%>' == "7200") {
			firstFocusField = document.all.f58_1;
		}else{
			firstFocusField = document.all.f3;
		}
		lastFocusfield = document.all.f404;

		document.all.initFlag.value = 0;
		document.all.changeFlag.value = 0;
		document.all.cnslno.value = document.all.f1_1.value + document.all.f1_2.value + document.all.f1_3.value + document.all.f1_4.value + document.all.f1_5.value;
		document.all.f1_2.value = '<%=f4_2%>';
		document.all.f2.value = "1";

		tab1LastFocusField = document.all.f412;
		tab2LastFocusField = document.all.f57;
		tab3LastFocusField = document.all.f29;
		tab4LastFocusField = document.all.f406;

		disablePrintBtn();

		//process3.jsp Select
		localQuery3();

/* 1st tab */
		document.all.f213.value = ('<%= f15 %>' == 0)? "":padNumber('<%= f15 %>',4);
		document.all.f210.value = (document.all.f210.value ==0)? "":document.all.f210.value;
		
		set_basic("f210");
		
		document.all.f296.value = (document.all.f296.value ==0)? "":padNumber(document.all.f296.value,4);
		set_basic("f296");
		
        document.all.f297.value = (document.all.f297.value ==0)? "":document.all.f297.value;
		if (document.all.f297.value != "") {
			setRequiredParam("f426"); //保証料徴求区分
		} else {
			document.all.f426.disabled = true;
		}
		
		set_basic("f297");

		document.all.f225.value = (document.all.f225.value == 'y')? "1":"0";
		document.all.f225.disabled = true; //団体生命契約区分



/* 3rd tab */
		document.all.f4.value = (document.all.f4.value == 0)? "":document.all.f4.value;
		document.all.f5.value = (document.all.f5.value == 0)? "":document.all.f5.value;
		document.all.f6.value = (document.all.f6.value == 0)? "":document.all.f6.value;
		document.all.f59.value  = (document.all.f59.value  == 0)? "":parseInt(document.all.f59.value,10);

		//EBS 20090519
		if(document.all.f59.value=="" || document.all.f59.value=='0'){
			//分割実行ではない場合
		    document.all.f6.value = "01";
		}
		
		set_basic("f6");
		
		document.all.f414.value = (document.all.f414.value == 0)? "":document.all.f414.value;
		document.all.f416.value = (document.all.f416.value == 0)? "":document.all.f416.value;
		document.all.f418.value = (document.all.f418.value == 0)? "":document.all.f418.value;
		document.all.f420.value = (document.all.f420.value == 0)? "":document.all.f420.value;
		document.all.f421.value = (document.all.f421.value == 0)? "":document.all.f421.value;
		document.all.f422.value = (document.all.f422.value == 0)? "":document.all.f422.value;
		document.all.f423.value = (document.all.f423.value == 0)? "":document.all.f423.value;
		document.all.f424.value = (document.all.f424.value == 0)? "":document.all.f424.value;
		document.all.f425.value = (document.all.f425.value == 0)? "":document.all.f425.value;
		document.all.f435_1.value = '<%= XmlUtil.dataPattern("c",f435,0) %>';

		document.all.f58_1.value = '<%=f84%>'.substr(0,4); //実行予定日
		document.all.f58_2.value = '<%=f84%>'.substr(4,2);
		document.all.f58_3.value = '<%=f84%>'.substr(6,2);
		document.all.tmpglday.value= '<%=f84%>';
		document.all.execday.value = '<%=f84%>';
		document.all.glDay.value = getDate('<%=f84%>');
		document.all.dptCd.value = getIHeader("DPT_CD");
		
        //承認申請担当者
		if('<%=f409%>' != ""){
			document.all.f409.value = '<%=f409%>';
		} else {
			document.all.f409.value = getIHeader("TELR");
		}
		set_basic("f409");
		
		setRequiredParam("f412"); //連帯債務者区分
		if('<%=f413%>' == "") { document.all.ciff413.value = ""; } //JOINJOINCIF NAME
		else { document.all.ciff413.value = '<%=f413%>'; }

		if('<%=f415%>' == "") { document.all.ciff415.value = ""; }
		else { document.all.ciff415.value ='<%=f415%>'; }

		if('<%=f417%>' == "") { document.all.ciff417.value = ""; }
		else { document.all.ciff417.value = '<%=f417%>'; }

		if('<%=f419%>' == "") { document.all.ciff419.value = ""; }
		else { document.all.ciff419.value = '<%=f419%>'; }

		//20090212
		if('<%=f507%>' == "7200") { disableField(document.all.f3); }

		// 2013.3.16 実行代わり金振込処理対応 本多 START
		document.all.f445_1.value = "000000";
		document.all.f445_3.value = "0000";
		
		set_basic("f444_1");
		set_basic("f444_2");
		set_basic("f444_3");
		
		document.all.f444_3Lbl.value=searchF3(document.all.f444_3);
		
		set_basic("f508_1");
		set_basic("f508_2");
		
		document.all.f508_3Lbl.value=searchF3(document.all.f508_3);
		// 2013.3.16 実行代わり金振込処理対応 本多 END

/* 4th tab */
		document.all.f36.value = (document.all.f36.value == 0)? "":document.all.f36.value;
		document.all.f40.value = (document.all.f40.value == 0)? "":document.all.f40.value;
		document.all.f44.value = (document.all.f44.value == 0)? "":document.all.f44.value;
		document.all.f47.value = (document.all.f47.value == 0)? "": padNumber(document.all.f47.value,2);
		document.all.f48.value = (document.all.f48.value == 0)? "": padNumber(document.all.f48.value,2);
		
		observeField(document.all.f50);
		observeField(document.all.f51);
//EBS 20090519
		if('<%=f507%>' == "7200") {
			label3();
			cal11();
		}
		document.all.f51.value = ('<%= f76 %>' == 0)? "":padNumber('<%= f76 %>',2);
		document.all.f52.value = (document.all.f52.value == 0)? "":padNumber(document.all.f52.value,2);
		document.all.f150.value= (document.all.f150.value== 0)? "":document.all.f150.value;

	    //f34 期日区分
		document.all.f34.value = '<%=f56%>' == 0 ? "" : '<%=f56%>';
		if(document.all.f34.value == "1"){
			var scheDate= '<%=f84%>';  //document.all.f58.value ;
			var scheYY  = '<%=f84%>'.substr(0,4);
			var scheMM  = '<%=f84%>'.substr(4,2);
			var scheDD  = '<%=f84%>'.substr(6,2);
			var repayYY = '<%=f57_1%>';
			var repayMM = '<%=f57_2%>';
			var repayDD = '<%=f57_3%>';
			document.all.ichaMonth.value = (repayYY - scheYY) * 12 + (repayMM - scheMM);
			if(scheDD > repayDD){
				document.all.ichaMonth.value = 	document.all.ichaMonth.value - 1;
			}
		}else{
			document.all.ichaMonth.value = '<%=f58%>';
		}
		repayYear = '<%=f57_1%>';
		repayMth  = '<%=f57_2%>';
		repayDate = '<%=f57_3%>';
		repayMonth= '<%=f58%>';

		if('<%=f56%>' == 1) {
			setRequiredParam("f35_1");
			setRequiredParam("f35_2");
			setRequiredParam("f35_3");
			disableField(document.all.f36);
		} else if('<%=f56%>' == 2) {
			setRequiredParam("f36");
			disableField(document.all.f35_1);
			disableField(document.all.f35_2);
			disableField(document.all.f35_3);
		} else {
			disableField(document.all.f35_1);
			disableField(document.all.f35_2);
			disableField(document.all.f35_3);
			disableField(document.all.f36);
		}

		document.all.f38.value = '<%=f60%>' == 0 ? "" : '<%=f60%>'; //据置区分
		if('<%=f60%>'==1){
			document.all.f39_1.readonly = false;
			document.all.f39_2.readonly = false;
			document.all.f39_3.readonly = false;
			setRequiredParam("f39_1");
			setRequiredParam("f39_2");
			setRequiredParam("f39_3");
		} else if('<%=f60%>'==2){
			document.all.f40.readonly = false;
			setRequiredParam("f40");
		} else {
			disableField(document.all.f39_1);
			disableField(document.all.f39_2);
			disableField(document.all.f39_3);
			disableField(document.all.f40);
		}

		if(document.all.f457.value == '0'){
			document.all.f50.value = (document.all.f50.value == '0')?"":document.all.f50.value;
		}else{
			document.all.f50.value = document.all.f50.value;
		}

		
		if(document.all.f47.value != ""){
			document.all.f47Lbl.value = '<%=f449%>';
		}
		
		if(document.all.f48.value != ""){
			document.all.f48Lbl.value = '<%=f450%>';
		}
		document.all.f45.disabled = true;
		document.all.f46.disabled = true;
		document.all.f460.disabled= true;


/* 5th tab */
		document.all.f453.value = (document.all.f453.value == 0)? "":document.all.f453.value;
		document.all.f454.value = (document.all.f454.value == 0)? "":document.all.f454.value;
		document.all.f503.disabled = true;
		document.all.f504.disabled = true;
		if(document.all.f503.value > 0){
			document.all.f504.disabled = false;
		}
		if(document.all.f9.value != ""){
			document.all.f9Lbl.value = '<%=f442%>';
		}
		if(document.all.f10.value != ""){
			document.all.f10Lbl.value = '<%=f443%>';
		}
		if(document.all.f13.value != ""){
			document.all.f13Lbl.value = '<%=f451%>';
		}
		if(document.all.f14.value != ""){
			document.all.f14Lbl.value = '<%=f452%>';
		}
		if(document.all.f503.value != ""){
			document.all.f503Lbl.value= '<%=f458%>';
		}
		if('<%=f438%>'!=0){
			document.all.f438.value = '<%=f438%>';
		}
		if('<%=f441%>'!=0){
			document.all.f441.value = '<%=f441%>';
		}

		/* f9 変動類型コード*/
		if(document.all.f8.value == 3){
			if(document.all.f6.value =='03'){
				document.all.f9.qtype="3324"
			} else {
				document.all.f9.qtype="3314"
			}
		}
		if('<%= XmlUtil.nNullCheck(f30) %>' == 1){
			document.all.f9.qtype="3315"
		}
		if(document.all.f9.value.substr(0,1) == '6'){
			document.all.f11.pop = "yes";
		} else if(document.all.f9.value.substr(0,1) == '8'){
			document.all.f12.pop = "yes";
		}

/* 6th tab */
		oldValue = document.all.f408.value;
		document.all.f408.value = (document.all.f408.value == 0)? "":document.all.f408.value;
		if(document.all.f408.value != ""){
			setRequiredParam("f407");
		}
		document.all.f31.value = (document.all.f31.value == "")? "0.00000":document.all.f31.value;
		document.all.f439.value= (document.all.f439.value== "")? "0.00000":document.all.f439.value;

		document.all.f427.value = 25; // 02in.xml => 6th tab tableのrow count


/* Select Box Set */
        /* 1st tab */
		for (i = 0; i < document.all.f217.options.length; i++) {
			if (document.all.f217.options[i].value == '<%= XmlUtil.nNullCheck(f16) %>')
				document.all.f217.options[i].selected = true;
			else document.all.f217.options[i].selected = false;
		}
		for (i = 0; i < document.all.f218.options.length; i++) {
			if (document.all.f218.options[i].value == '<%= XmlUtil.nNullCheck(f17) %>')
				document.all.f218.options[i].selected = true;
			else document.all.f218.options[i].selected = false;
		}
		for (i = 0; i < document.all.f219.options.length; i++) {
			if (document.all.f219.options[i].value == '<%= XmlUtil.nNullCheck(f18) %>')
				document.all.f219.options[i].selected = true;
			else document.all.f219.options[i].selected = false;
		}
		for (i = 0; i < document.all.f221.options.length; i++) {
			if (document.all.f221.options[i].value == '<%= XmlUtil.nNullCheck(f20) %>')
				document.all.f221.options[i].selected = true;
			else document.all.f221.options[i].selected = false;
		}

        /* 2nd tab */
		for (i = 0; i < document.all.f300.options.length; i++) {
			if (document.all.f300.options[i].value == '<%= XmlUtil.nNullCheck(f98) %>')
				document.all.f300.options[i].selected = true;
			else document.all.f300.options[i].selected = false;
		}
		for (i = 0; i < document.all.f301.options.length; i++) {
			if (document.all.f301.options[i].value == '<%= XmlUtil.nNullCheck(f99) %>')
				document.all.f301.options[i].selected = true;
			else document.all.f301.options[i].selected = false;
		}
		for (i = 0; i < document.all.f303.options.length; i++) {
			if (document.all.f303.options[i].value == '<%= XmlUtil.nNullCheck(f101) %>')
				document.all.f303.options[i].selected = true;
			else document.all.f303.options[i].selected = false;
		}
		for (i = 0; i < document.all.f304.options.length; i++) {
			if (document.all.f304.options[i].value == '<%= XmlUtil.nNullCheck(f102) %>')
				document.all.f304.options[i].selected = true;
			else document.all.f304.options[i].selected = false;
		}

        /* 3rd tab */
		for (i = 0; i < document.all.f446.options.length; i++) {
			if (document.all.f446.options[i].value == '<%= XmlUtil.nNullCheck(f446) %>')
				document.all.f446.options[i].selected = true;
			else document.all.f446.options[i].selected = false;
		}
		for (i = 0; i < document.all.f447.options.length; i++) {
			if (document.all.f447.options[i].value == '<%= XmlUtil.nNullCheck(f447) %>')
				document.all.f447.options[i].selected = true;
			else document.all.f447.options[i].selected = false;
		}
		for (i = 0; i < document.all.f412.options.length; i++) {
			if (document.all.f412.options[i].value == '<%= XmlUtil.nNullCheck(f412) %>')
				document.all.f412.options[i].selected = true;
			else document.all.f412.options[i].selected = false;
		}

        /* 4th tab */
		for (i = 0; i < document.all.f34.options.length; i++) {
			if (document.all.f34.options[i].value == '<%= XmlUtil.nNullCheck(f56) %>')
				document.all.f34.options[i].selected = true;
			else document.all.f34.options[i].selected = false;
		}
		for (i = 0; i < document.all.f38.options.length; i++) {
			if (document.all.f38.options[i].value == '<%= XmlUtil.nNullCheck(f60) %>')
				document.all.f38.options[i].selected = true;
			else document.all.f38.options[i].selected = false;
		}
		for (i = 0; i < document.all.f45.options.length; i++) {
			if (document.all.f45.options[i].value == '<%= XmlUtil.nNullCheck(f68) %>')
				document.all.f45.options[i].selected = true;
			else document.all.f45.options[i].selected = false;
		}
		for (i = 0; i < document.all.f46.options.length; i++) {
			if (document.all.f46.options[i].value == '<%= XmlUtil.nNullCheck(f69) %>')
				document.all.f46.options[i].selected = true;
			else document.all.f46.options[i].selected = false;
		}
		for (i = 0; i < document.all.f460.options.length; i++) {
			if (document.all.f460.options[i].value == '<%= XmlUtil.nNullCheck(f460) %>')
				document.all.f460.options[i].selected = true;
			else document.all.f460.options[i].selected = false;
		}

        /* 5th tab */
		for (i = 0; i < document.all.f8.options.length; i++) {
			if (document.all.f8.options[i].value == '<%= XmlUtil.nNullCheck(f30) %>')
				document.all.f8.options[i].selected = true;
			else document.all.f8.options[i].selected = false;
		}

        /* 6th tab */
		for (i = 0; i < document.all.f403.options.length; i++) {
			if (document.all.f403.options[i].value == '<%= XmlUtil.nNullCheck(f403) %>')
				document.all.f403.options[i].selected = true;
			else document.all.f403.options[i].selected = false;
		}
		for (i = 0; i < document.all.f404.options.length; i++) {
			if (document.all.f404.options[i].value == '<%= XmlUtil.nNullCheck(f404) %>')
				document.all.f404.options[i].selected = true;
			else document.all.f404.options[i].selected = false;
		}
		
		//Call: lq5 2011/11/8 金ｓイベント発火順番変更:　特約保証コードアクティブ可否バグ修正
		lq5();

		/* 貸出実行方法 */
		if(document.all.f217.value == 3){
    		document.all.f6.readOnly = true;
			document.all.f6.tabindex = -1;
			//document.all.f6.qtype="3210"	//1,3,4
		} else {
			document.all.f6.readOnly = false;
			document.all.f6.tabindex = 0;
			document.all.f6.qtype="3205"	//1,3
		}
				
        //f6 貸出実行方法によって設定変更
        divissu = parseInt('<%=f28%>',10);
		u_divissu();

		//先取/後取によって設定変更
//		repayCk();

        //function Call : changeField3_1
		changeField3_1();

		document.all.changeFlag.value = 1;
		document.all.initFlag.value = 1;
		
		document.all.f58_1.onblur=changeGlday;
		document.all.f58_2.onblur=changeGlday;
		document.all.f58_3.onblur=changeGlday;
		document.all.oldglDay.value = '<%=f84%>';
		enableAllBtn();
		document.all.TRANSACTION2.disabled=false;
		enableExecBtn();

		//20160321 fx add start

		var currcode = 	getOHeader("NATIONAL_CODE");
		document.all.f100.value = currcode;
		chEvent(document.all.f3,currcode); 
		chEvent(document.all.f50,currcode); 
		chEvent(document.all.f601,currcode); 
		chEvent(document.all.f602,currcode); 
		chEvent(document.all.f603,currcode); 
		chEvent(document.all.f604,currcode); 
		chEvent(document.all.f605,currcode); 
		chEvent(document.all.f606,currcode); 
		chEvent(document.all.f607,currcode);
		chEvent(document.all.f50,currcode);
		
		//document.all.f608.value   = document.all.f3.value; 
		//20160321 fx add end

		setMsg("200007");
	}
/* initPage END ------------------------------------------------------------------------------*/


/* checkPage Start ---------------------------------------------------------------------------*/
	function checkPage(fieldArray){
		
		setMsg("253");
		dataForm.target = "hiddenFrame";
		dataForm.action = top.CONTEXT+"/WebFacade";
		//印刷時
		if(document.all.RTN_FLAG.value == 2){
			reloadOutXML('/codeXml/4.LON/13300_10out.xml');
			return true;
		}
		
		if(document.all.tmpflag.value == "1"){
			alertError("12845");
			return false;
		}
		if(document.all.f38.value == "1"){
			if(!dateCheck('f39_1','f39_2','f39_3')) return false;
		}
		if(document.all.f60_1.value != ""){
			if(!dateCheck('f60_1','f60_2','f60_3')) return false;
		}
		if(document.all.f61_1.value != ""){
			if(!dateCheck('f61_1','f61_2','f61_3')) return false;
		}
		if(document.all.f62_1.value != ""){
			if(!dateCheck('f62_1','f62_2','f62_3')) return false;
		}
		if(document.all.f63_1.value != ""){
			if(!dateCheck('f63_1','f63_2','f63_3')) return false;
		}
		if(document.all.f64_1.value != ""){
			if(!dateCheck('f64_1','f64_2','f64_3')) return false;
		}

/* 3rd tab */
        //f6, f59
		if(document.all.f6.value == '03'){
			if(isNaN(parseInt(document.all.f59.value,10))==true){
				tabItemSelect(2);
				alertError("6173");
				setFocus(document.all.f59);
				return false;
			}
			if(document.all.f59.value == 1){
				tabItemSelect(2);
				setFocus(document.all.f59);
				alertError("12640");
				document.all.f6.value = '01';
				return false;
			}
			if(document.all.f59.value > 5){
				tabItemSelect(2);
				alertError("12641");
				setFocus(document.all.f59);
				document.all.f59.value = "";
				return false;
			}
		}

		//f436
		if(unFormatComma(document.all.f436.value) > 0 ){
			if(parse(unFormatComma(document.all.f3.value)) > parse(unFormatComma(document.all.f436.value))){
				alertError("12545");
				setFocus(document.all.f3);
				return false;
			}
		}

		// 2013.3.16 実行代わり金振込処理対応 本多 START
		//f444, f445
		if( document.all.f444_4.value =="") {
			//fieldArray["f444_1"]  = padChar("",7);
			fieldArray["f444"]  = padChar("",3);
			fieldArray["f444_1"]  = padChar("",4);
			fieldArray["f444_2"]  = padChar("",4);
			fieldArray["f444_3"]  = padChar("",2);
			fieldArray["f444_4"]  = padChar("",7);
		}
		
		//f508
		if( document.all.f508_4.value =="") {
			fieldArray["f508"]  = padChar("",3);
			fieldArray["f508_1"]  = padChar("",4);
			fieldArray["f508_2"]  = padChar("",4);
			fieldArray["f508_3"]  = padChar("",2);
			fieldArray["f508_4"]  = padChar("",7);
		}
		// 2013.3.16 実行代わり金振込処理対応 本多 END
		
		if( document.all.f445_2.value =="") {
			fieldArray["f445_1"]  = padChar("",6);
			fieldArray["f445_3"]  = padChar("",4);
			fieldArray["f445_2"]  = padChar("",10);
		}

	    //f413_3, f415_3. f417_3, f419_3
		if(document.all.CIF_3.value == document.all.f413_3.value ||
		   document.all.CIF_3.value == document.all.f415_3.value ||
		   document.all.CIF_3.value == document.all.f417_3.value ||
		   document.all.CIF_3.value == document.all.f419_3.value ){
			tabItemSelect(2);
			alertError("12615");
			return false;
		}
		var chk2Cif=u_checkCIF(document.all["f413_3"],document.all["f415_3"],document.all["f417_3"],document.all["f419_3"]);
		if(chk2Cif!="") {
			tabItemSelect(2);
			alertError("1361");
			chk2Cif.select();
			chk2Cif.focus();
			return false;
		}
		if(document.all.f415_3.value == ""){
			if(document.all.f416.value != ""){
				tabItemSelect(2);
				alertError("12224");
				document.all.f416.value = "";
				setFocus(document.all.f415_3);
				return false;
			}
		}
		if(document.all.f417_3.value == ""){
			if(document.all.f418.value != ""){
				tabItemSelect(2);
				alertError("12224");
				document.all.f418.value = "";
				setFocus(document.all.f417_3);
				return false;
			}
		}
		if(document.all.f419_3.value == ""){
			if(document.all.f420.value != ""){
				tabItemSelect(2);
				alertError("12224");
				document.all.f420.value = "";
				setFocus(document.all.f419_3);
				return false;
			}
		}

        //f59 分割実行予定回数
		if(document.all.f59.value == 2){
			if(!u_datecompare("f60_1","f60_2","f60_3","f61_1","f61_2","f61_3")) return false;
		}else if(document.all.f59.value == 3){
			if(!u_datecompare("f60_1","f60_2","f60_3","f61_1","f61_2","f61_3")){
				return false;
			}else if(!u_datecompare("f61_1","f61_2","f61_3","f62_1","f62_2","f62_3")) return false;
		}else if(document.all.f59.value == 4){
			if(!u_datecompare("f60_1","f60_2","f60_3","f61_1","f61_2","f61_3")){
				return false;
			}else if(!u_datecompare("f62_1","f62_2","f62_3","f63_1","f63_2","f63_3")){
				return false;
			}else if(!u_datecompare("f61_1","f61_2","f61_3","f62_1","f62_2","f62_3")) return false;
		}else if(document.all.f59.value == 5){
			if(!u_datecompare("f60_1","f60_2","f60_3","f61_1","f61_2","f61_3")){
				return false;
			}else if(!u_datecompare("f62_1","f62_2","f62_3","f63_1","f63_2","f63_3")){
				return false;
			}else if(!u_datecompare("f63_1","f63_2","f63_3","f64_1","f64_2","f64_3")){
				return false;
			}else if(!u_datecompare("f61_1","f61_2","f61_3","f62_1","f62_2","f62_3")) return false;
		}

<!-- 20200331 Ek Edit Start -->
// 下のifは、入金(振込先)口座情報関連チェック
	if(document.all.f508_1.value != "" || document.all.f508_2.value != "" || document.all.f508_3.value != "" || document.all.f508_4.value != ""){
		if(document.all.f508_1.value == "" || document.all.f508_2.value == "" || document.all.f508_3.value == "" || document.all.f508_4.value == ""){
			alertError('70816');
			for(i=1;i<=4;i++){
				if( document.all["f508_"+i].value == "" ){
					document.all["f508_"+i].focus();
					return false;
				}
			}
			return false;
		}
	}
	if(document.all.f508_1.value != "" && document.all.f508_2.value != "" && document.all.f508_3.value != "" && document.all.f508_4.value != ""){
		if(document.all.f509.value == ""){
			alertError('200394');
		  setFocus(document.all.f509);
			return false;
		}
	}
	if(document.all.f508_1.value == "" && document.all.f508_2.value == "" && document.all.f508_3.value == "" && document.all.f508_4.value == ""){
		if(document.all.f509.value != ""){
			alertError('200395');
			setFocus(document.all.f509);
			return false;
		}
	}
	if(!onlyAcceptChar(document.all.f509)) return false;

// 下のifは、引落口座情報関連チェック
	if(document.all.f444_1.value != "" || document.all.f444_2.value != "" || document.all.f444_3.value != "" || document.all.f444_4.value != ""){
		if(document.all.f444_1.value == "" || document.all.f444_2.value == "" || document.all.f444_3.value == "" || document.all.f444_4.value == ""){
			alertError('70816');
			for(i=1;i<=4;i++){
				if( document.all["f444_"+i].value == "" ){
					document.all["f444_"+i].focus();
					return false;
				}
			}
			return false;
		}
	}
	if(document.all.f444_1.value != "" && document.all.f444_2.value != "" && document.all.f444_3.value != "" && document.all.f444_4.value != ""){
		if(document.all.f461.value == ""){
			alertError('200394');
		  setFocus(document.all.f461);
			return false;
		}
	}
	if(document.all.f444_1.value == "" && document.all.f444_2.value == "" && document.all.f444_3.value == "" && document.all.f444_4.value == ""){
		if(document.all.f461.value != ""){
			alertError('200395');
			setFocus(document.all.f461);
			return false;
		}
	}
	if(!onlyAcceptChar(document.all.f461)) return false;
<!-- 20200331 Ek Edit End -->

/* 4th tab */
        //f50, f51, f52
		var amount = (document.all.f50.value == "") ? 0: parse(document.all.f50.value);
		var bnsMonth1 = parse(document.all.f51.value);
		if(document.all.f51.value != "" && isNaN(bnsMonth1)==true){
			tabItemSelect(3);
			alertError("6173");
			document.all.f51.value = "";
			document.all.f51.focus();
			return false;
		}
		if( amount > 0 && document.all.f51.value == "") {
			tabItemSelect(3);
			alertError("012005");
			document.all.f52.value = "";
			setFocus(document.all.f51);
			return false;
		}else if( ( amount > 0 ) && (bnsMonth1 < 1 || bnsMonth1 > 6) ) {
			tabItemSelect(3);
			alertError("200294");
			document.all.f52.value = "";
			setFocus(document.all.f51);
			return false;
		}

		//f53, f54
		if(document.all.f460.value == 21 || document.all.f460.value == 22 || document.all.f460.value == 23){
			if(parse(document.all.f53.value) == 0){
				tabItemSelect(3);
				setFocus(document.all.f53)
				alertError("14061");
				return false;
			}
			if(unFormatComma(document.all.f50.value) > 0) {
    			if(parse(document.all.f54.value) == 0){
	    		    tabItemSelect(3);
    				setFocus(document.all.f54)
    				alertError("14062");
    				return false;
    			}
    		}
		}

        //f34, f38
		if(document.all.f34.value == "1"){
			var appldate = document.all.f35_1.value+document.all.f35_2.value+document.all.f35_3.value;
			if(appldate.length > 0){
				if(!dateCheck('f35_1','f35_2','f35_3')) return false;
				if((document.all.f58_1.value+document.all.f58_2.value+document.all.f58_3.value) >= appldate){
					alertError("12797");
					setFocus(document.all.f35_1);
					return false;
				}
			}
		}
		if(document.all.f34.value == 2){
			if(parse(document.all.f36.value) == 0){
				tabItemSelect(3);
				setFocus(document.all.f36);
				alertError("200095");
				return false;
			}
		}
		if(document.all.f38.value == 2){
			if(parse(document.all.f40.value) == 0){
				tabItemSelect(3);
				setFocus(document.all.f40)
				alertError("200095");
				return false;
			}
		}

	    //f42
		//約定日
		if(document.all.f42.readOnly == false) {
			if(document.all.f42.value > 32) {
				alertError("12638");
				document.all.f42.value = "";
				setFocus(document.all.f42);
				return false;
			}
			if(document.all.f42.value == '0') {
				alertError("12645");
				document.all.f42.value = "";
				setFocus(document.all.f42);
				return false;
			}
			if(document.all.f42.value == '') {
				alertError("200080");
				document.all.f42.value = "";
				setFocus(document.all.f42);
				return false;
			}
		}
		// 20200703 EK Edit Start
		/* 元金返済方式＝１、利息返済方式＝１の場合、承認期限の日付(f35_3)と約定日（f42）が一致するかをチェック
			承認期限の日付(f35_3)に２９～３１が入力すれば、約定日（f42）は32日であるべき */
		if(document.all.f45.value == 1 && document.all.f46.value == 1){
			if(document.all.f35_3.value != "0" && document.all.f35_3.value != ""){
				if(document.all.f42.value == 32 && document.all.f35_3.value < 29){
					alertError("12595");
					setFocus(document.all.f42);
					return false;
				} 
			}
		}
	// 20200703 EK Edit End
		fieldArray["f42"] = padNumber(document.all.f42.value, 2);

		if(document.all.f55.value != ""){
			if(!checkHalfChar(document.all.f55)) return false;
		}
		if(document.all.f56.value != ""){
			if(!checkHalfChar(document.all.f56)) return false;
		}
		if(document.all.f57.value != ""){
			if(!checkHalfChar(document.all.f57)) return false;
		}

/* 5th tab */
	    //f11
		if( document.all.f11.value != "" && (parse(document.all.f11.value) > parse(document.all.ichaMonth.value)) ){
			alertError("200051");
			setFocus(document.all.f11);
			return false;
		}
		if(document.all.f11.value != "" && document.all.f22.value == "0.00000"){
			alertError("200051");
			setFocus(document.all.f11);
			return false;
		}

	    //f12
		if(document.all.f12.value != "" &&( parse(document.all.f12.value) > parse(document.all.ichaMonth.value) )){
			alertError("200051");
			setFocus(document.all.f12);
			return false;
		}
		if(document.all.f12.value != "" && document.all.f438.value == "0.00000"){
			alertError("200051");
			setFocus(document.all.f12);
			return false;
		}

		//f32
		// 2011/11/1 zero rate 対応
		if(parse(document.all.f32.value) < 0){
			alertError("200349");
			tabItemSelect(4);
			setFocus(document.all.f29);
			return false;
		}
	
/* 6th tab */
 		fieldArray["f427"] = 25;
 		for(i=0;i<25;i++){
			fieldArray["f428"][i] = document.all.f428[i].value;
			fieldArray["f429"][i] = padNumber(document.all.f429[i].value,3);
			fieldArray["f430"][i] = padNumber(u_clearDot(document.all.f430[i].value),7);
			fieldArray["f431"][i] = padNumber(u_clearDot(document.all.f431[i].value),7);
		}
/* 8th tab */
		if(document.all.f460.value == 34){
            /**if(unFormatComma(document.all.f151.value) == "" || document.all.f151.value == "0.00000"){
                alertError("200080");
    			tabItemSelect(7);
				setFocus(document.all.f151);
				return false;
			}**/
			// 2011/11/1 zero rate 対応
			if(parse(document.all.f151.value) <0){
				alertError("200349");
				tabItemSelect(7);
				setFocus(document.all.f151);
				return false;
			}
			
    		if(!document.all.f153[0].value){
				alertError("200080");
    			tabItemSelect(7);
    			setFocus(document.all.f153[0]);
    			return false;
    		}
    		if(!document.all.f154[0].value){
    			alertError("200080");
    			tabItemSelect(7);
    			setFocus(document.all.f154[0]);
    			return false;
            }
            var count= 0;
            var d153 = new Array();
    		var f153 = new Array();
    		var f154 = new Array();
        	for(i=0;i<60;i++){
			    if(document.all.f153[i].value){
				    if(i != 0 && !document.all.f153[i-1].value){
						alertError("200080");
            			tabItemSelect(7);
						setFocus(document.all.f153[i-1]);
						return false;
				    }
				    if(i != 0 && !document.all.f154[i-1].value){
						alertError("200080");
            			tabItemSelect(7);
						setFocus(document.all.f154[i-1]);
						return false;
				    }

    				d153[i] = padNumber(document.all.d153[i].value,3);
    				f153[i] = padNumber(document.all.f153[i].value,3);
     				f154[i] = parseFloat(unFormatComma(document.all.f154[i].value));
                    if(f153[i]){
    					if(f154[i] != 0 && f154[i] == ''){
    						alertError("200080");
    						tabItemSelect(7);
    						setFocus(document.all.f154[i]);
    						return false;
    					}else {
						    fieldArray["f153"][i] = padNumber(f153[i],3);
                            fieldArray["f154"][i] = padNumber(f154[i]+"00",17);
					    }
				    }
                    if (document.all.f153[i].value != "" && document.all.f154[i].value != "") {
                        count++ ;
                    }
				}
        	}
            document.all.f152.value = count;
            fieldArray["f152"] = padNumber(document.all.f152.value, 3);
	    }else{
            fieldArray["f152"] = 000;
        }
/* RTN_FLAG */
		if(document.all.printFLAG.value == '1'){
			document.all.printFLAG.value = '7';
		}
		//実行時 Check
		if(document.all.RTN_FLAG.value == 9){
			if(document.all.f59.value > 0 && document.all.f60_1.value != "" && document.all.f60_2.value != "" && document.all.f60_3.value != ""){
				if(document.all.f60_1.value != document.all.f58_1.value){
					alertError("12574");
					tabItemSelect(2);
					setFocus(document.all.f60_1);
					return false;
				}
				if(document.all.f60_2.value != document.all.f58_2.value){
					alertError("12574");
					tabItemSelect(2);
					setFocus(document.all.f60_2);
					return false;
				}
				if(document.all.f60_3.value != document.all.f58_3.value){
					alertError("12574");
					tabItemSelect(2);
					setFocus(document.all.f60_3);
					return false;
				}
			}
			if (document.all.f503.value > 0){
				if(parse(unFormatComma(document.all.f3.value)) > parse(unFormatComma(document.all.f504.value))){
					alertError("12972");
					setFocus(document.all.f504);
					return false;
				}
				if(unFormatComma(document.all.f410.value) > 0 || unFormatComma(document.all.f411.value) > 0){
					alertError("12973");
					setFocus(document.all.f410);
					return false;
				}
			}else if ((document.all.f223.value != "") && (document.all.f225.checked == true)){
				if(unFormatComma(document.all.f410.value) <= 0 && unFormatComma(document.all.f411.value) <= 0){
					alertError("12646");
					setFocus(document.all.f410);
					return false;
				}
			}
			reloadOutXML('/codeXml/4.LON/13300_10out.xml');
		}
		//登録時 Check
		if(document.all.printFLAG.value == '1' || document.all.printFLAG.value == '7'){
			if (document.all.f297.value != "") {
				if (document.all.f426.value == "") {
					alertError("200080");
					setFocus(document.all.f426);
					return false;
				}
			}
			if ((document.all.f223.value != "") && (document.all.f225.checked == true)){
				if(unFormatComma(document.all.f410.value) == ""){
					alertError("200080");
					setFocus(document.all.f410);
					return false;
				}
				if(unFormatComma(document.all.f411.value) == ""){
					alertError("200080");
					setFocus(document.all.f411);
					return false;
				}
			}
			if(document.all.f6.value==3 || document.all.f6.value==03){
				if(!document.all.f59.value){
					alertError("200080");
					tabItemSelect(2);
					setFocus(document.all.f59);
					return false;
				}
				if(document.all.f59.value == 1){
					if(!document.all.f60_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_1);
						return false;
					}else if(!document.all.f60_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_2);
						return false;
					}else if(!document.all.f60_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_3);
						return false;
					}else if(!document.all.f421.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f421);
						return false;
					}
				}
				if(document.all.f59.value == 2){
					if(!document.all.f60_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_1);
						return false;
					}else if(!document.all.f60_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_2);
						return false;
					}else if(!document.all.f60_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_3);
						return false;
					}else if(!document.all.f421.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f421);
						return false;
					}else if(!document.all.f61_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_1);
						return false;
					}else if(!document.all.f61_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_2);
						return false;
					}else if(!document.all.f61_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_3);
						return false;
					}else if(!document.all.f422.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f422);
						return false;
					}else if(!u_datecompare("f60_1","f60_2","f60_3","f61_1","f61_2","f61_3")) return false;
				}
				if(document.all.f59.value == 3){
					if(!document.all.f60_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_1);
						return false;
					}else if(!document.all.f60_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_2);
						return false;
					}else if(!document.all.f60_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_3);
						return false;
					}else if(!document.all.f421.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f421);
						return false;
					}else if(!document.all.f61_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_1);
						return false;
					}else if(!document.all.f61_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_2);
						return false;
					}else if(!document.all.f61_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_3);
						return false;
					}else if(!document.all.f422.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f422);
						return false;
					}else if(!document.all.f62_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f62_1);
						return false;
					}else if(!document.all.f62_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f62_2);
						return false;
					}else if(!document.all.f62_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f62_3);
						return false;
					}else if(!document.all.f423.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f423);
						return false;
					}else if(!u_datecompare("f60_1","f60_2","f60_3","f61_1","f61_2","f61_3")){
						return false;
					}else if(!u_datecompare("f61_1","f61_2","f61_3","f62_1","f62_2","f62_3")) return false;
				}
				if(document.all.f59.value == 4){
					if(!document.all.f60_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_1);
						return false;
					}else if(!document.all.f60_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_2);
						return false;
					}else if(!document.all.f60_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_3);
						return false;
					}else if(!document.all.f421.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f421);
						return false;
					}else if(!document.all.f61_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_1);
						return false;
					}else if(!document.all.f61_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_2);
						return false;
					}else if(!document.all.f61_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_3);
						return false;
					}else if(!document.all.f422.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f422);
						return false;
					}else if(!document.all.f62_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f62_1);
						return false;
					}else if(!document.all.f62_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f62_2);
						return false;
					}else if(!document.all.f62_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f62_3);
						return false;
					}else if(!document.all.f423.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f423);
						return false;
					}else if(!document.all.f63_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f63_1);
						return false;
					}else if(!document.all.f63_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f63_2);
						return false;
					}else if(!document.all.f63_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f63_3);
						return false;
					}else if(!document.all.f424.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f424);
						return false;
					}else if(!u_datecompare("f60_1","f60_2","f60_3","f61_1","f61_2","f61_3")){
						return false;
					}else if(!u_datecompare("f62_1","f62_2","f62_3","f63_1","f63_2","f63_3")){
						return false;
					}else if(!u_datecompare("f61_1","f61_2","f61_3","f62_1","f62_2","f62_3")){
						return false;
					}
				}
				if(document.all.f59.value == 5){
					if(!document.all.f60_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_1);
						return false;
					}else if(!document.all.f60_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_2);
						return false;
					}else if(!document.all.f60_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f60_3);
						return false;
					}else if(!document.all.f421.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f421);
						return false;
					}else if(!document.all.f61_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_1);
						return false;
					}else if(!document.all.f61_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_2);
						return false;
					}else if(!document.all.f61_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f61_3);
						return false;
					}else if(!document.all.f422.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f422);
						return false;
					}else if(!document.all.f62_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f62_1);
						return false;
					}else if(!document.all.f62_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f62_2);
						return false;
					}else if(!document.all.f62_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f62_3);
						return false;
					}else if(!document.all.f423.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f423);
						return false;
					}else if(!document.all.f63_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f63_1);
						return false;
					}else if(!document.all.f63_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f63_2);
						return false;
					}else if(!document.all.f63_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f63_3);
						return false;
					}else if(!document.all.f424.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f424);
						return false;
					}else if(!document.all.f64_1.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f64_1);
						return false;
					}else if(!document.all.f64_2.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f64_2);
						return false;
					}else if(!document.all.f64_3.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f64_3);
						return false;
					}else if(!document.all.f425.value){
						alertError("200080");
						tabItemSelect(2);
						setFocus(document.all.f425);
						return false;
					}else if(!u_datecompare("f60_1","f60_2","f60_3","f61_1","f61_2","f61_3")){
						return false;
					}else if(!u_datecompare("f62_1","f62_2","f62_3","f63_1","f63_2","f63_3")){
						return false;
					}else if(!u_datecompare("f63_1","f63_2","f63_3","f64_1","f64_2","f64_3")){
						return false;
					}else if(!u_datecompare("f61_1","f61_2","f61_3","f62_1","f62_2","f62_3")){
						return false;
					}
				}
				if(document.all.f59.value > 0 && document.all.f60_1.value != "" && document.all.f60_2.value != "" && document.all.f60_3.value != ""){
					if(document.all.f60_1.value != document.all.f58_1.value){
						alertError("12574");
						tabItemSelect(2);
						setFocus(document.all.f60_1);
						return false;
					}
					if(document.all.f60_2.value != document.all.f58_2.value){
						alertError("12574");
						tabItemSelect(2);
						setFocus(document.all.f60_2);
						return false;
					}
					if(document.all.f60_3.value != document.all.f58_3.value){
						alertError("12574");
						tabItemSelect(2);
						setFocus(document.all.f60_3);
						return false;
					}
				}
			}
		}
		//debugInput();
		return true;
	}
/* checkPage END -----------------------------------------------------------------------------*/


/* flow Start --------------------------------------------------------------------------------*/
	function flow() {
		if(document.all.RTN_FLAG.value == '2' || (document.all.RTN_FLAG.value == '9' && document.all.printFLAG.value != '7')){
			if (top.oHeader["PROC_STA"] != "E" && top.oHeader["PROC_STA"] != "e") {
				document.all.cifsearch.disabled = true;
				var objInputAll = document.all.tags("INPUT");
				for(var i=0 ;i<objInputAll.length; i++){
					if(objInputAll[i].type != "hidden"){
						objInputAll[i].disabled = true;
					}
				}
				var objSelectAll = document.all.tags("SELECT");
				for(var i=0 ;i<objSelectAll.length; i++){
					objSelectAll[i].disabled = true;
				}
				//
				disableField(document.all.TRANSACTION2);
				printPDF("13300_20580","/codeXml/4.LON/13300_10out.xml","Y");
			} else {
				enableField(document.all.TRANSACTION2);
			}
		}

		if(document.all.printFLAG.value == '7'){
			if (top.oHeader["PROC_STA"] != "E" && top.oHeader["PROC_STA"] != "e"){
				document.all.cifsearch.disabled = true;
				var objInputAll = document.all.tags("INPUT");
				for(var i=0 ;i<objInputAll.length; i++){
					if(objInputAll[i].type != "hidden"){
						objInputAll[i].disabled = true;
					}
				}
				var objSelectAll = document.all.tags("SELECT");
				for(var i=0 ;i<objSelectAll.length; i++){
					objSelectAll[i].disabled = true;
				}
				//
				enablePrintBtn();
				disableField(document.all.TRANSACTION2);
			}
		}
		setMsg("000499");
	}
/* flow END ----------------------------------------------------------------------------------*/

	/*
	 * initPageで Call、LNPGRPを select
	 */
	function localQuery3(){
	    //alertFunName("localQuery3");
		document.all.dptCd.value = getIHeader("DPT_CD");
		document.all.prodCd.value = document.all.f211.value; //prodCd
		dataForm.action=top.CONTEXT+"/4.LON/13300/process3.jsp";
		dataForm.target="popup3";
		<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
		//dataForm.submit();
		xhrSend();
		<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
	}
	/*
	 * initPageで Call
	 */
	function lq5() {
	    //alertFunName("lq5");
		if ((document.all.f223.value != "") && (document.all.f225.checked == true)){
			document.all.f410.disabled = false;
			document.all.f411.disabled = false;
			document.all.f503.disabled = false;
		}else{
			makeReadOnly(document.all.f410);
			makeReadOnly(document.all.f411);
			makeReadOnly(document.all.f503);
		}
	}
    /*
	 * initPageで Call
	 * f58 実行予定日変更の時 Call
	 */
	function checkGlday() {
	    //alertFunName("checkGlday");
		var productID =  document.all.f211.value;
		var bisDate = getIHeader("BIS_DATE");
		var dptCd = getIHeader("DPT_CD");
		document.all.glDay.value = padNumber(document.all.f58_1.value,4) + padNumber(document.all.f58_2.value,2) + padNumber(document.all.f58_3.value,2);
		if (!dateCheck("f58_1", "f58_2", "f58_3")){
			document.all.f58_1.value = document.all.execday.value.substr(0,4);
			document.all.f58_2.value = document.all.execday.value.substr(4,2);
			document.all.f58_3.value = document.all.execday.value.substr(6,2);
			setFocus(document.all.f58_1);
			return false;
		}
		var glDay = document.all.glDay.value;
		document.all.glDay.value = getDate(document.all.glDay.value);
		if (document.all.oldPROD.value != "" && glDay == document.all.oldglDay.value){
			return false;
		}
		if(glDay == document.all.execday.value){ 
			return false;
		}
		document.all.tmp1.value = dptCd;
		document.all.tmp2.value = productID;
		var xql;
		var nodeList;
		var node;
		var index = 0;
		var maxAPPL_DATE;
		var flagGUAR_COMP;	/* External mortgage cord*/
		var codeGUAR_COMP;	/* The guarantee association work cord or the bonding company cord*/
		var flagGROUP_LIFE;	/* Group flag */
		var codeGROUP_LIFE;	/* Group code */

		/* max(APPL_DATE) */
		xql = "/table/record[@DPT_CD='"+dptCd+
					  "' and @GRP='" +productID+
					  "' and @APPL_DATE<='" +glDay+
					  "' and @STA<40]";
		/*  // origin			  
		nodeList = top.LNPGRP.selectNodes(xql);
		if (nodeList.length == 0) {
			alertError("384");
			document.all.f58_1.value = document.all.execday.value.substr(0,4);
			document.all.f58_2.value = document.all.execday.value.substr(4,2);
			document.all.f58_3.value = document.all.execday.value.substr(6,2);
			setFocus(document.all.f58_1);
			return false;
		}
		node =  nodeList.nextNode();
		maxAPPL_DATE = node.getAttribute("APPL_DATE");
		
		for(var i =0; i<nodeList.length-1 ; i++) {
			node =  nodeList.nextNode();
			maxAPPL_DATE = (node.getAttribute("APPL_DATE") > maxAPPL_DATE ) ? node.getAttribute("APPL_DATE") : maxAPPL_DATE;
		}
		*/
		nodeList = top.LNPGRP.evaluate(xql, top.LNPGRP, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
		
		if (nodeList.snapshotLength == 0) {
			alertError("384");
			document.all.f58_1.value = document.all.execday.value.substr(0,4);
			document.all.f58_2.value = document.all.execday.value.substr(4,2);
			document.all.f58_3.value = document.all.execday.value.substr(6,2);
			setFocus(document.all.f58_1);
			return false;
		}		
		node =  nodeList.snapshotItem(index);
		maxAPPL_DATE = node.getAttribute("APPL_DATE");
		

		for(var i = index; i<nodeList.snapshotLength-1 ; i++) {			
			node =  nodeList.snapshotItem(index);
			maxAPPL_DATE = (node.getAttribute("APPL_DATE") > maxAPPL_DATE ) ? node.getAttribute("APPL_DATE") : maxAPPL_DATE;
		}

		/* The GUAR_COMP_FLAG there is not a necessity which 2 times will execute the searching query the place
		   where it becomes the c/s flaw)*/
		xql = "/table/record[@DPT_CD='"+dptCd+
					  "' and @GRP='" +productID+
					  "' and @APPL_DATE='" +maxAPPL_DATE+
					  "' and @STA<40]";
		/*  // origin
		node = top.LNPGRP.selectSingleNode(xql);
		*/
		var node_xpath = document.evaluate(xql, top.LNPGRP, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
		node = node_xpath.singleNodeValue;

		if (!node){
			alertError("384");
			document.all.f58_1.value = document.all.execday.value.substr(0,4);
			document.all.f58_2.value = document.all.execday.value.substr(4,2);
			document.all.f58_3.value = document.all.execday.value.substr(6,2);
			setFocus(document.all.f58_1);
			return false;
		}
        //6th tab
		flagGUAR_COMP = node.getAttribute("GUAR_COMP_FLAG");  //外部保証区分
		codeGUAR_COMP = node.getAttribute("GUAR_COMP_CODE");  //保証会社コード
		flagGROUP_LIFE= node.getAttribute("GROUP_LIFE_FLAG"); //団体生命加入区分
		codeGROUP_LIFE= node.getAttribute("GROUP_LIFE_CODE"); //団体生命コード

		//3rd tab
		repayKind = node.getAttribute("REPAY_KIND");  //先/後取区分
		document.all.repayKind.value = repayKind;
		
		if(document.all.oldPROD.value == productID && document.all.oldglDay.value != glDay){
			if( document.all.flagCOMP.value != flagGUAR_COMP){
				alertError("12774");
				window.open("","contents","","");
				document.all.f58_1.value = document.all.execday.value.substr(0,4);
				document.all.f58_2.value = document.all.execday.value.substr(4,2);
				document.all.f58_3.value = document.all.execday.value.substr(6,2);
				setFocus(document.all.f58_1);
				return false;
			}
			if(document.all.flagCOMP.value == '1' && padNumber(document.all.f297.value+"",4) != padNumber(codeGUAR_COMP+"",4)){
				alertError("12775");
				window.open("","contents","","");
				document.all.f58_1.value = document.all.execday.value.substr(0,4);
				document.all.f58_2.value = document.all.execday.value.substr(4,2);
				document.all.f58_3.value = document.all.execday.value.substr(6,2);
				setFocus(document.all.f58_1);
				return false;
			}
			if(document.all.flagLIFE.value != flagGROUP_LIFE){
				alertError("12776");
				window.open("","contents","","");
				document.all.f58_1.value = document.all.execday.value.substr(0,4);
				document.all.f58_2.value = document.all.execday.value.substr(4,2);
				document.all.f58_3.value = document.all.execday.value.substr(6,2);
				setFocus(document.all.f58_1);
				return false;
			}
			if(document.all.flagLIFE.value == '3' && padNumber(document.all.f223.value+"",4) != padNumber(codeGROUP_LIFE+"",4)){
				alertError("12777");
				window.open("","contents","","");
				document.all.f58_1.value = document.all.execday.value.substr(0,4);
				document.all.f58_2.value = document.all.execday.value.substr(4,2);
				document.all.f58_3.value = document.all.execday.value.substr(6,2);
				setFocus(document.all.f58_1);
				return false;
			}
		}
		document.all.flagCOMP.value = flagGUAR_COMP;
		document.all.flagLIFE.value = flagGROUP_LIFE;
		document.all.oldPROD.value  = productID;
		document.all.oldglDay.value = glDay;
		document.all.tmpglday.value = glDay;
		return true;
	}

    /*
	 * initPageで Call
	 * f58 実行予定日変更の時 Call
	 */
	function repayCk(){
	    //alertFunName("repayCk");
        //f6 貸出実行方法
		if(document.all.repayKind.value == 1){  //先取
        	//document.all.f6.value = '01';
        	document.all.f6.readOnly = true;
    		document.all.f6.tabindex = -1;
    		disableField(document.all.f6Lbl);
    	} else {
        	if(document.all.f217.value == 3) return;   // 20240304 相談種類＝極度（３）
        	document.all.f6.readOnly = false;   //後取
        	document.all.f6.tabindex = 0;
        	document.all.f6.qtype = 3205;
    		enableField(document.all.f6Lbl);
    	}
		//f44 返済方式コード
		if(document.all.repayKind.value == 1){  //先取
    		document.all.f44.qtype="3311"
		    if(document.all.f45.value == 5){
    		    document.all.f44.value=""
            }
		} else {
    		document.all.f44.qtype="3301"
		}
    }
	/*
	 * initPageで Call
	 * そして、f59 分割実行の時にも呼び出し
	 */
	function u_divissu(){
	    //alertFunName("u_divissu");
		document.all.f60_1.disabled=true;
		document.all.f60_2.disabled=true;
		document.all.f60_3.disabled=true;
		document.all.f61_1.disabled=true;
		document.all.f61_2.disabled=true;
		document.all.f61_3.disabled=true;
		document.all.f62_1.disabled=true;
		document.all.f62_2.disabled=true;
		document.all.f62_3.disabled=true;
		document.all.f63_1.disabled=true;
		document.all.f63_2.disabled=true;
		document.all.f63_3.disabled=true;
		document.all.f64_1.disabled=true;
		document.all.f64_2.disabled=true;
		document.all.f64_3.disabled=true;
		document.all.f421 .disabled=true;
		document.all.f422 .disabled=true;
		document.all.f423 .disabled=true;
		document.all.f424 .disabled=true;
		document.all.f425 .disabled=true;
		setNotRequiredParam("f60_1");
		setNotRequiredParam("f60_2");
		setNotRequiredParam("f60_3");
		setNotRequiredParam("f61_1");
		setNotRequiredParam("f61_2");
		setNotRequiredParam("f61_3");
		setNotRequiredParam("f62_1");
		setNotRequiredParam("f62_2");
		setNotRequiredParam("f62_3");
		setNotRequiredParam("f63_1");
		setNotRequiredParam("f63_2");
		setNotRequiredParam("f63_3");
		setNotRequiredParam("f64_1");
		setNotRequiredParam("f64_2");
		setNotRequiredParam("f64_3");
		setNotRequiredParam("f421");
		setNotRequiredParam("f422");
		setNotRequiredParam("f423");
		setNotRequiredParam("f424");
		setNotRequiredParam("f425");

		var currcode = 	getOHeader("NATIONAL_CODE");

		if(document.all.f59.value=='1'){
			tab1LastFocusField = document.all.f421;
			setRequiredParam("f60_1");
			setRequiredParam("f60_2");
			setRequiredParam("f60_3");
			setRequiredParam("f421");
			document.all.f60_1.disabled=false;
			document.all.f60_2.disabled=false;
			document.all.f60_3.disabled=false;

			enableField(document.all.f421);
			document.all.f61_1.value = "";
			document.all.f61_2.value = "";
			document.all.f61_3.value = "";
			document.all.f62_1.value = "";
			document.all.f62_2.value = "";
			document.all.f62_3.value = "";
			document.all.f63_1.value = "";
			document.all.f63_2.value = "";
			document.all.f63_3.value = "";
			document.all.f64_1.value = "";
			document.all.f64_2.value = "";
			document.all.f64_3.value = "";
			document.all.f422.value = "";
			document.all.f423.value = "";
			document.all.f424.value = "";
			document.all.f425.value = "";

			if(document.all.initFlag.value == 1){
				setFocus(document.all.f60_1);
			}

		//20160429 fxadd 
			chEvent(document.all.f421,currcode); 

		} else if(document.all.f59.value=='2'){
			tab1LastFocusField = document.all.f422;
			document.all.f61_1.disabled=false;
			document.all.f61_2.disabled=false;
			document.all.f61_3.disabled=false;
			document.all.f60_1.disabled=false;
			document.all.f60_2.disabled=false;
			document.all.f60_3.disabled=false;
			document.all.f422.disabled =false;
			document.all.f421.disabled =false;

			document.all.f62_1.value = "";
			document.all.f62_2.value = "";
			document.all.f62_3.value = "";
			document.all.f63_1.value = "";
			document.all.f63_2.value = "";
			document.all.f63_3.value = "";
			document.all.f64_1.value = "";
			document.all.f64_2.value = "";
			document.all.f64_3.value = "";
			document.all.f423.value = "";
			document.all.f424.value = "";
			document.all.f425.value = "";

			setRequiredParam("f60_1");
			setRequiredParam("f60_2");
			setRequiredParam("f60_3");
			setRequiredParam("f61_1");
			setRequiredParam("f61_2");
			setRequiredParam("f61_3");
			setRequiredParam("f421");
			setRequiredParam("f422");

			if(document.all.initFlag.value == 1){
				setFocus(document.all.f60_1);
			}

			//20160429 fxadd 
			chEvent(document.all.f421,currcode); 
			chEvent(document.all.f422,currcode); 
			
		} else if(document.all.f59.value=='3'){
			tab1LastFocusField = document.all.f423;
			document.all.f61_1.disabled=false;
			document.all.f61_2.disabled=false;
			document.all.f61_3.disabled=false;
			document.all.f62_1.disabled=false;
			document.all.f62_2.disabled=false;
			document.all.f62_3.disabled=false;
			document.all.f60_1.disabled=false;
			document.all.f60_2.disabled=false;
			document.all.f60_3.disabled=false;
			document.all.f422.disabled=false;
			document.all.f423.disabled=false;
			document.all.f421.disabled=false;

			document.all.f63_1.value = "";
			document.all.f63_2.value = "";
			document.all.f63_3.value = "";
			document.all.f64_1.value = "";
			document.all.f64_2.value = "";
			document.all.f64_3.value = "";
			document.all.f424.value = "";
			document.all.f425.value = "";

			setRequiredParam("f62_1");
			setRequiredParam("f62_2");
			setRequiredParam("f62_3");
			setRequiredParam("f60_1");
			setRequiredParam("f60_2");
			setRequiredParam("f60_3");
			setRequiredParam("f61_1");
			setRequiredParam("f61_2");
			setRequiredParam("f61_3");
			setRequiredParam("f423");
			setRequiredParam("f421");
			setRequiredParam("f422");

			if(document.all.initFlag.value == 1){
				setFocus(document.all.f60_1);
			}
			//20160429 fxadd 
			chEvent(document.all.f421,currcode);
			chEvent(document.all.f422,currcode);
			chEvent(document.all.f423,currcode);

		} else if(document.all.f59.value=='4'){
			tab1LastFocusField = document.all.f424;
			document.all.f61_1.disabled=false;
			document.all.f61_2.disabled=false;
			document.all.f61_3.disabled=false;
			document.all.f62_1.disabled=false;
			document.all.f62_2.disabled=false;
			document.all.f62_3.disabled=false;
			document.all.f60_1.disabled=false;
			document.all.f60_2.disabled=false;
			document.all.f60_3.disabled=false;
			document.all.f63_1.disabled=false;
			document.all.f63_2.disabled=false;
			document.all.f63_3.disabled=false;
			document.all.f422.disabled=false;
			document.all.f423.disabled=false;
			document.all.f421.disabled=false;
			document.all.f424.disabled=false;

			document.all.f64_1.value = "";
			document.all.f64_2.value = "";
			document.all.f64_3.value = "";
			document.all.f425.value = "";

			setRequiredParam("f60_1");
			setRequiredParam("f60_2");
			setRequiredParam("f60_3");
			setRequiredParam("f61_1");
			setRequiredParam("f61_2");
			setRequiredParam("f61_3");
			setRequiredParam("f62_1");
			setRequiredParam("f62_2");
			setRequiredParam("f62_3");
			setRequiredParam("f63_1");
			setRequiredParam("f63_2");
			setRequiredParam("f63_3");
			setRequiredParam("f421");
			setRequiredParam("f422");
			setRequiredParam("f423");
			setRequiredParam("f424");

			if(document.all.initFlag.value == 1){
				setFocus(document.all.f60_1);
			}

		//20160429 fxadd 
			chEvent(document.all.f421,currcode); 
			chEvent(document.all.f422,currcode); 
			chEvent(document.all.f423,currcode); 
			chEvent(document.all.f424,currcode); 

		} else if(document.all.f59.value=='5'){
			tab1LastFocusField = document.all.f425;
			document.all.f61_1.disabled=false;
			document.all.f61_2.disabled=false;
			document.all.f61_3.disabled=false;
			document.all.f62_1.disabled=false;
			document.all.f62_2.disabled=false;
			document.all.f62_3.disabled=false;
			document.all.f60_1.disabled=false;
			document.all.f60_2.disabled=false;
			document.all.f60_3.disabled=false;
			document.all.f64_1.disabled=false;
			document.all.f64_2.disabled=false;
			document.all.f64_3.disabled=false;
			document.all.f63_1.disabled=false;
			document.all.f63_2.disabled=false;
			document.all.f63_3.disabled=false;
			document.all.f425.disabled=false;
			document.all.f422.disabled=false;
			document.all.f423.disabled=false;
			document.all.f421.disabled=false;
			document.all.f424.disabled=false;

			setRequiredParam("f60_1");
			setRequiredParam("f60_2");
			setRequiredParam("f60_3");
			setRequiredParam("f61_1");
			setRequiredParam("f61_2");
			setRequiredParam("f61_3");
			setRequiredParam("f62_1");
			setRequiredParam("f62_2");
			setRequiredParam("f62_3");
			setRequiredParam("f63_1");
			setRequiredParam("f63_2");
			setRequiredParam("f63_3");
			setRequiredParam("f64_1");
			setRequiredParam("f64_2");
			setRequiredParam("f64_3");
			setRequiredParam("f421");
			setRequiredParam("f422");
			setRequiredParam("f423");
			setRequiredParam("f424");
			setRequiredParam("f425");

			if(document.all.initFlag.value == 1){
				setFocus(document.all.f60_1);
			}

			//20160429 fxadd 
			chEvent(document.all.f421,currcode); 
			chEvent(document.all.f422,currcode); 
			chEvent(document.all.f423,currcode); 
			chEvent(document.all.f424,currcode); 
			chEvent(document.all.f425,currcode);

		} else if(document.all.f59.value=="" || document.all.f59.value=='0'){
		    //分割実行ではない場合
			setFocus(document.all.f6);
			if(document.all.f217.value == 3){
				document.all.f6.value = "04"; //極度
			}else{
				document.all.f6.value = "01";
			}
			document.all.f59.value="";
			document.all.f60_1.value = "";
			document.all.f60_2.value = "";
			document.all.f60_3.value = "";
			document.all.f421.value = "";
			document.all.f61_1.value = "";
			document.all.f61_2.value = "";
			document.all.f61_3.value = "";
			document.all.f62_1.value = "";
			document.all.f62_2.value = "";
			document.all.f62_3.value = "";
			document.all.f63_1.value = "";
			document.all.f63_2.value = "";
			document.all.f63_3.value = "";
			document.all.f64_1.value = "";
			document.all.f64_2.value = "";
			document.all.f64_3.value = "";
			document.all.f422.value = "";
			document.all.f423.value = "";
			document.all.f424.value = "";
			document.all.f425.value = "";
		}
	}
	/*
	 * initPageで Call
	 */
	function changeField3_1(){
	    //alertFunName("changeField3_1");
		document.all.f39_1.disabled = true;
		document.all.f39_2.disabled = true;
		document.all.f39_3.disabled = true;
		document.all.f40.disabled = true;

		setNotRequiredParam("f39_1");
		setNotRequiredParam("f39_2");
		setNotRequiredParam("f39_3");
		setNotRequiredParam("f40");

		if(document.all.f38.value == '1'){
			document.all.f39_1.disabled = false;
			document.all.f39_2.disabled = false;
			document.all.f39_3.disabled = false;
			document.all.f39_1.readOnly = false;
			document.all.f39_2.readOnly = false;
			document.all.f39_3.readOnly = false;
			document.all.f39_1.tabindex = 0;
			document.all.f39_2.tabindex = 0;
			document.all.f39_3.tabindex = 0;
			setRequiredParam("f39_1");
			setRequiredParam("f39_2");
			setRequiredParam("f39_3");
		}else if(document.all.f38.value == '2'){
			document.all.f40.disabled = false;
			document.all.f40.readOnly = false;
			document.all.f40.tabindex = 0;
			setRequiredParam("f40");
		}
	}


	/*
	 * checkPageで Call
	 */
	function u_clearDot(v) {
	    //alertFunName("u_clearDot");
		var pos=v.indexOf(".");
		var res=v;
		if(pos!=-1) {
			res="";
			var len=v.length;
			var v1=v.substring(0,pos);
			var v2=v.substring(pos+1,len);
			res=v1+v2;
		}
		return res;
	}
	function u_checkCIF() {
	    //alertFunName("u_checkCIF");
		var cif=new Array();
		var len=arguments.length;
		var chk="";

		for(var i=0;i<len;i++) {
			cif[i]=arguments[i].value;
		}
		for(var i=0;i<len-1;i++) {
				if(cif[i]=="") continue;
			for(var j=i+1;j<len;j++) {
				if(cif[j]=="") continue;
				if(cif[i]==cif[j]) {
					chk=arguments[j];
					break;
				}
			}
		}
		return chk;
	}

	/*
	 *印刷ボタン
	 */
    function changeRTNFlag2(){
	    //alertFunName("changeRTNFlag2");
		document.all.RTN_FLAG.value = '2';
		reloadInXML('/codeXml/4.LON/13300_01in.xml');

		document.all.f1_1.value = document.all.h1_1.value;
		document.all.f1_2.value = document.all.h1_2.value;
		document.all.f1_3.value = document.all.h1_3.value;
		document.all.f1_4.value = document.all.h1_4.value;
		document.all.f1_5.value = document.all.h1_5.value;

		document.all.TRANSACTION.disabled = false;
		document.all.TRANSACTION.click();
		document.all.TRANSACTION.disabled = true;
	}

	/*
	 *登録ボタン
	 */
	function changeRTNFlag7(){
	    //alertFunName("changeRTNFlag7");
		if(document.all.tmpflag.value == "1"){
			alertError("12898");
			return false;
		}
		document.all.RTN_FLAG.value = '7';
		document.all.printFLAG.value = '1';
		document.all.TRANSACTION.click();
		document.all.RTN_FLAG.value = '9';
	}

	/*
	 *実行ボタン
	 */
	function changeRTNFlag9(){
	    //alertFunName("changeRTNFlag9");
		if(document.all.RTN_FLAG.value == '9') document.all.printFLAG.value = '0';
		if(document.all.f412.value == 2){
			if(!document.all.f413_3.value){
				tabItemSelect(2);
				return false;
			}
			if(!document.all.f414.value){
				tabItemSelect(2);
				return false;
			}
			if(document.all.f415_3.value != "" && !document.all.f416.value){
				tabItemSelect(2);
				return false;
			}
			if(document.all.f417_3.value != "" && !document.all.f418.value){
				tabItemSelect(2);
				return false;
			}
			if(document.all.f419_3.value != "" && !document.all.f420.value){
				tabItemSelect(2);
				return false;
			}
		}
		if(document.all.f6.value==3 || document.all.f6.value==03){
		
			if(!document.all.f59.value){
				tabItemSelect(2);
				return false;
			}
			if(document.all.f59.value == 1){
				if(!document.all.f60_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f60_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f60_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f421.value){
					tabItemSelect(2);
					return false;
				}
			}
			if(document.all.f59.value == 2){
				if(!document.all.f60_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f60_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f60_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f421.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f422.value){
					tabItemSelect(2);
					return false;
				}
			}
			if(document.all.f59.value == 3){
				if(!document.all.f60_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f60_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f60_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f421.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f422.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f62_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f62_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f62_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f423.value){
					tabItemSelect(2);
					return false;
				}
			}
			if(document.all.f59.value == 4){
				if(!document.all.f60_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f60_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f60_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f421.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f422.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f62_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f62_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f62_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f423.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f63_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f63_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f63_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f424.value){
					tabItemSelect(2);
					return false;
				}
			}
			if(document.all.f59.value == 5){
				if(!document.all.f60_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f60_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f60_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f421.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f61_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f422.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f62_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f62_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f62_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f423.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f63_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f63_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f63_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f424.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f64_1.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f64_2.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f64_3.value){
					tabItemSelect(2);
					return false;
				}else if(!document.all.f425.value){
					tabItemSelect(2);
					return false;
				}
			}
		}
		document.all.TRANSACTION.click();
	}

	function getDate(date){
	    //alertFunName("getDate");
		if(date == "" || date == " ") return "00000000";
		var yy = parseInt(date.substr(0,4),10);
		var mm = parseInt(date.substr(4,2),10);
		var dd = parseInt(date.substr(6,2),10);
		if(document.all.raterefercode.value == '1'){
			if(mm >= 4 && mm < 10){
				return yy.toString() + '0401';
			}else if(mm < 4){
				return	(yy - 1).toString() + '1001';
			}else{
				return yy.toString() + '1001';
			}
		}else if(document.all.raterefercode.value == '2'){
			if(mm == 1){
				return (yy - 1).toString() + '12' + '01'
			}else if (mm >= 2 && mm <= 10){
				return yy.toString() + '0' + (mm - 1).toString() + '01';
			}else{
				return yy.toString() + (mm - 1).toString() + '01';
			}
		}else if(document.all.raterefercode.value == '3'){
			return date.substr(0,6) + '01';
		}else{
			return date;
		}
	}

	function parse(src){
	    ////alertFunName("parse");
		return (src == '')? '0':parseFloat(src);
	}

	function u_datecompare(y1, m1, d1, y2, m2, d2) {
	    //alertFunName("u_datecompare");
		var date1 = document.all[y1].value + document.all[m1].value + document.all[d1].value;
		var date2 = document.all[y2].value + document.all[m2].value + document.all[d2].value;
		if (date1 >= date2) {
			tabItemSelect(2);
			alertError("12575");
			setFocus(document.all[y2]);
			return false;
		}
		return true;
	}

	function u_autopadding(){
	    ////alertFunName("u_autopadding");
		var val = getFloatPart(event.srcElement.value);
		var val2 = getIntPart(event.srcElement.value);

		if(!val){
			if(!val2){
				event.srcElement.value = '0.00000';
			}else{
				event.srcElement.value = val2 + '.00000';
			}
		}
		if(val.length==1){
			event.srcElement.value = event.srcElement.value + '0000';
		}
		if(val.length==2){
			event.srcElement.value = event.srcElement.value + '000';
		}
		if(val.length==3){
			event.srcElement.value = event.srcElement.value + '00';
		}
		if(val.length==4){
			event.srcElement.value = event.srcElement.value + '0';
		}
		if(val2.length==0 && event.srcElement.value.length==6){
		    event.srcElement.value = '0' + event.srcElement.value;
		}
	}

	function findIndex(field) {
	    //alertFunName("findIndex");
		var fieldArray = document.all[field.name];
		for (var i=0; i<fieldArray.length; i++) {
			if (fieldArray[i] == field) return i;
		}
		return -1;
	}

	function localQuery4() {
	    //alertFunName("localQuery4");
		if(event.propertyName != "value") return;
		var kind = document.all.f9.value + "";
		var chpCD = kind.substr(0,1);
		if(document.all.f34.value == "1"){
			var scheDate = document.all.tmpglday.value;  //document.all.f58.value ;
			var scheYY = document.all.f58_1.value; 	//scheDate.substr(0,4);
			var scheMM = document.all.f58_2.value; 	//scheDate.substr(4,2);
			var scheDD = document.all.f58_3.value; 	//scheDate.substr(6,2);
			var repayYY= document.all.f35_1.value;  //repayDate.substring(0,4);
			var repayMM= document.all.f35_2.value;  //repayDate.substring(4,6);
			var repayDD= document.all.f35_3.value;  //repayDate.substring(6,8);
			document.all.ichaMonth.value = (repayYY - scheYY) * 12 + (repayMM - scheMM);
			if(scheDD > repayDD){
				document.all.ichaMonth.value = 	document.all.ichaMonth.value - 1;
			}
		}else {
			document.all.ichaMonth.value = document.all.f36.value ;
		}
		document.all.dptCd.value = getIHeader("DPT_CD");
		document.all.rateKind.value = document.all.f8.value; //rateKind
		document.all.glDay.value = getDate(document.all.tmpglday.value);
		document.all.prodCd.value = document.all.f211.value; //prodCd
		document.all.chpCode.value = document.all.f9.value;  //chpCode
		document.all.baseRate.value = document.all.f10.value; //baseRate
		dataForm.action=top.CONTEXT+"/4.LON/13300/process4.jsp";
		dataForm.target="popup4";
		<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
		//dataForm.submit();
		xhrSend();
		<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
	}

    /*
     * alert Function Name
     */
    function alertFunName(name) {
    	alert(name + top.getErrMsg(name));
    }
/*-- 1st tab --------------------------------------------------------------------------------------*/
    /*
     *f220 保証人の保証種類
     */
	function u_getGuarKind(code) {
	    //alertFunName("u_getGuarKind");
		var code_1 = code.substr(0,1);
		var code_5 = code.substr(1,3);
		/*  // origin
		node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='22' "+
							" and @CODE_1 = '"+code_1+"' "+
							" and @CODE_5 = '"+code_5+"' "+
							" and (@STA=1 or @STA=2) "+
							" and @CODE_2 = 0 "+
							" and @CODE_3 = 0 "+
							" and @CODE_4 = 0 "+
							" and @CODE_5 != 0]");
		*/
		var node_root = "/table/record[@CODE_KIND ='22' "+
							" and @CODE_1 = '"+code_1+"' "+
							" and @CODE_5 = '"+code_5+"' "+
							" and (@STA=1 or @STA=2) "+
							" and @CODE_2 = 0 "+
							" and @CODE_3 = 0 "+
							" and @CODE_4 = 0 "+
							" and @CODE_5 != 0]";
		var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
		node = node_xpath.singleNodeValue;
		
		document.all.f220Lbl.value = (node)? node.getAttribute("CODE_NAME"):"";
	}

    /*
     *f225 団体生命契約区分
     */
	function checkBox(obj){
	    //alertFunName("checkBox");
		if(obj.value == '1'){
			obj.checked = true;
		}else{
			obj.checked = false;
		}
	}


/*-- 3rd tab --------------------------------------------------------------------------------------*/
    /*
     *f58 実行予定日
     */
	function changeGlday(){
	    //alertFunName("changeGlday");
	    var frstIssuDate = trim(document.all.f58_1.value) + trim(document.all.f58_2.value) + trim(document.all.f58_3.value);
	    if(frstIssuDate.length == 8){
	    	if(document.all.oldglDay.value == frstIssuDate)return;	
		    var checkFlag = checkGlday();
			if(checkFlag){
				repayCk();  //先取/後取区分
				cal6();
				localQueryGrp();
				document.all.f34.value = "";
				document.all.f35_1.value = "";
				document.all.f35_2.value = "";
				document.all.f35_3.value = "";
				document.all.f36.value = "";
			}
	    }
	}
	
	function localQueryGrp(){
	    //alertFunName("localQueryGrp");
		dataForm.action=top.CONTEXT+"/4.LON/13300/process15.jsp";
		dataForm.target="popup15";
		<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
		//dataForm.submit(); //f408_1
		xhrSend();
		<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
	}

	/*
	 *f426 保証料徴求区分
	 */
	function localQuery2(){
	    //alertFunName("localQuery2");
		if(event.propertyName != "value")return;

		if(event.srcElement.value == ""){
			document.all.f401.value = "0.00000";
			document.all.f426Lbl.value = "";
		}
		if(document.all.f426.value != "") {
			document.all.dptCd.value = getIHeader("DPT_CD");
			document.all.scheDate.value = document.all.tmpglday.value; //document.all.glDay.value;
			document.all.guarCd.value = event.srcElement.value; //guarCd
			document.all.guarComp.value = document.all.f297.value // guarComp
			dataForm.action=top.CONTEXT+"/4.LON/13300/process2.jsp";
			dataForm.target="popup2";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
	}

    /*
	 *f6 貸出実行方法
	 */
	function show(){
	    //alertFunName("show");
		if(event.propertyName != "value")return;

		if(parse(event.srcElement.value) == 3){
			if(document.all.f412.value == 2) tab1LastFocusField = document.all.f425;
			else tab1LastFocusField = document.all.f420;
			document.all.d.style.display = "block";
			document.all.f38.disabled=true;
			document.all.f39_1.disabled = true;
			document.all.f39_2.disabled = true;
			document.all.f39_3.disabled = true;
			document.all.f40.disabled = true;
			document.all.f38.value = "";
			document.all.f39_1.value = "";
			document.all.f39_2.value = "";
			document.all.f39_3.value = "";
			document.all.f40.value = "";
			setNotRequiredParam("f39_1");
			setNotRequiredParam("f39_2");
			setNotRequiredParam("f39_3");
			setNotRequiredParam("f40");
			setRequiredParam("f59");
			document.all.f8.value = '3';
			document.all.f9.qtype='3324';
			document.all.f8.disabled=true;
		}else{	
			if(document.all.f412.value == 2) tab1LastFocusField = document.all.f420;
			else tab1LastFocusField = document.all.f412;
			document.all.d.style.display = "none";

			if(document.all.f45.value !="1"){
				document.all.f38.disabled=false;
				if(document.all.initFlag.value == 1 && document.all.f38.value != ""){
					document.all.f39_1.disabled = false;
					document.all.f39_2.disabled = false;
					document.all.f39_3.disabled = false;
					document.all.f40.disabled = false;
				}
			}
			if(parseInt(document.all.f6.value,10)!= divissu ){
				document.all.f8.value = "";
			}
			document.all.f8.disabled=false;
			if(document.all.f8.value == 1){
				document.all.f9.qtype='3315';
			}else{
				document.all.f9.qtype='3314';
			}
			setNotRequiredParam("f59");
			setNotRequiredParam("f60_1");
			setNotRequiredParam("f60_2");
			setNotRequiredParam("f60_3");
			setNotRequiredParam("f61_1");
			setNotRequiredParam("f61_2");
			setNotRequiredParam("f61_3");
			setNotRequiredParam("f62_1");
			setNotRequiredParam("f62_2");
			setNotRequiredParam("f62_3");
			setNotRequiredParam("f63_1");
			setNotRequiredParam("f63_2");
			setNotRequiredParam("f63_3");
			setNotRequiredParam("f64_1");
			setNotRequiredParam("f64_2");
			setNotRequiredParam("f64_3");
			setNotRequiredParam("f421");
			setNotRequiredParam("f422");
			setNotRequiredParam("f423");
			setNotRequiredParam("f424");
			setNotRequiredParam("f425");

			document.all.f59.value = "";
			document.all.f60_1.value = "";
			document.all.f60_2.value = "";
			document.all.f60_3.value = "";
			document.all.f61_1.value = "";
			document.all.f61_2.value = "";
			document.all.f61_3.value = "";
			document.all.f62_1.value = "";
			document.all.f62_2.value = "";
			document.all.f62_3.value = "";
			document.all.f63_1.value = "";
			document.all.f63_2.value = "";
			document.all.f63_3.value = "";
			document.all.f64_1.value = "";
			document.all.f64_2.value = "";
			document.all.f64_3.value = "";
			document.all.f421.value = "";
			document.all.f422.value = "";
			document.all.f423.value = "";
			document.all.f424.value = "";
			document.all.f425.value = "";
		}
	}
	function u_autotwo(one) {
	    //alertFunName("u_autotwo");
		if(event.srcElement.value != ""){
			document.all.f6.value = (one == '0')? "": padNumber(one,2);
		}
		if(parseInt(document.all.f6.value,10) != divissu){
			divissu = parseInt(document.all.f6.value,10);
			cal6();
		}
	}

	// 2013.3.16 実行代わり金振込処理対応 本多 START
	/* 
	* 銀行名称取得（引落口座用）
	*/
	function getBankName1(){
		if(document.all.f444_1.value.length > 0){
			document.all.bnkCd.value = document.all.f444_1.value;
			dataForm.action=top.CONTEXT+"/4.LON/13300/process17.jsp";
			dataForm.target="popup17";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
		if (document.all.f444_1.value.length == 0){
		  document.all.f444_1Lbl.value = "";
		  document.all.f444_2.value = "";
		  document.all.f444_2Lbl.value = "";
		}
	}

	/* 
	* 銀行名称取得（振込口座用）
	*/
	function getBankName2(){
		
		if(document.all.f508_1.value.length > 0){
			document.all.bnkCd.value = document.all.f508_1.value;
			dataForm.action=top.CONTEXT+"/4.LON/13300/process19.jsp";
			dataForm.target="popup19";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
		if (document.all.f508_1.value.length == 0){
		  document.all.f508_1Lbl.value = "";
		  document.all.f508_2.value = "";
		  document.all.f508_2Lbl.value = "";
		}		
	}
	
	/* 
	* 支店名称取得（引落口座用）
	*/
	function getShitenName1(){
		if(document.all.f444_2.value.length > 0){
			document.all.bnkCd2.value = document.all.f444_1.value;
			document.all.brnCd.value = document.all.f444_2.value;
			dataForm.action=top.CONTEXT+"/4.LON/13300/process18.jsp";
			dataForm.target="popup18";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
		if (document.all.f444_2.value.length == 0){
		  document.all.f444_2Lbl.value = "";
		}	
	}
	
	/* 
	* 支店名称取得（振込口座用）
	*/
	function getShitenName2(){
		if(document.all.f508_2.value.length > 0){
			document.all.bnkCd2.value = document.all.f508_1.value;
			document.all.brnCd.value = document.all.f508_2.value;
			dataForm.action=top.CONTEXT+"/4.LON/13300/process20.jsp";
			dataForm.target="popup20";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
		if (document.all.f508_2.value.length == 0){
		  document.all.f508_2Lbl.value = "";
		}		
	}
	// 2013.3.16 実行代わり金振込処理対応 本多 END

    /*
	 *f412 連帯債務者区分
	 */
	function show2(){
		var gubun = event.srcElement.value;
		if(gubun == 2){
				if(document.all.f6.value == 3) tab1LastFocusField = document.all.f425;
				else tab1LastFocusField = document.all.f420;
				document.all.d2.style.display = "block";
				document.all.p906.value = "";

				setRequiredParam("f413_3");
				setRequiredParam("f414");

				document.all.f413_3.value = '<%=f413_3%>';
				document.all.f415_3.value =  '<%=f415_3%>';
				document.all.f417_3.value =  '<%=f417_3%>';
				document.all.f419_3.value =  '<%=f419_3%>';

				if('<%=f413%>' == "") {
					document.all.ciff413.value = "";
				} else {
					document.all.ciff413.value = '<%=f413%>';
					document.all.f414.value = '<%=f414%>';
				}

				if('<%=f415%>' == "") {
					document.all.ciff415.value = "";
				} else {
					document.all.ciff415.value = '<%=f415%>';
					document.all.f416.value = '<%=f416%>';
				}

				if('<%=f417%>' == "") {
					document.all.ciff417.value = "";
				} else {
					document.all.ciff417.value = '<%=f417%>';
					document.all.f418.value = '<%=f418%>';
				}

				if('<%=f419%>' == "") {
					document.all.ciff419.value = "";
				} else {
					document.all.ciff419.value = '<%=f419%>';
					document.all.f420.value ='<%=f420%>';
				}

				u_joinChange('p906','f414','f416','f418','f420','f412');

		}else{
				if(document.all.f6.value == 3) tab1LastFocusField = document.all.f425;
				else tab1LastFocusField = document.all.f412;
				document.all.d2.style.display = "none";
				document.all.p906.value = "100";
				document.all.f413_3.value = "";
				document.all.f415_3.value = "";
				document.all.f417_3.value = "";
				document.all.f419_3.value = "";
				document.all.f414.value = "";
				document.all.f416.value = "";
				document.all.f418.value = "";
				document.all.f420.value = "";
				setNotRequiredParam("f413_3");
				setNotRequiredParam("f414");
		}
	}
	function u_joinChange() {
		if(document.all[arguments[5]].value==2) {
			var obj0=document.all[arguments[0]];

			var obj1=document.all[arguments[1]].value;
			if(obj1=="") obj1=0;
			var obj2=document.all[arguments[2]].value;
			if(obj2=="") obj2=0;
			var obj3=document.all[arguments[3]].value;
			if(obj3=="") obj3=0;
			var obj4=document.all[arguments[4]].value;
			if(obj4=="") obj4=0;

			var totVal=parseInt(obj1)+parseInt(obj2)+parseInt(obj3)+parseInt(obj4);
			if(totVal>=100) {
				alertError("12225");
				var curField=event.srcElement.name;
				document.all[curField].value="";
				document.all[curField].focus();
				return false;
			}
			var curVal=100-parseInt(totVal);
			obj0.value=curVal;
		}
	}
    function doCheckInputFields(obj) {
		var fieldName = obj.name;
		switch (fieldName) {
		   case "f413_3" :	/* 連帯債務者顧客番号1 */
		   		checkf413();
		      	break;
		   case "f415_3" :	/* 連帯債務者顧客番号2 */
		   		checkf415();
		      	break;
		   case "f417_3" :	/* 連帯債務者顧客番号3 */
		   		checkf417();
		      	break;
		   case "f419_3" :	/* 連帯債務者顧客番号4 */
		   		checkf419();
		      	break;
		   default :
		      	break;
		}
	}
	/* 連帯債務者顧客番号1 */
	function checkf413() {
		var objf413_1 = document.all.f413_1;
		var objf413_2 = document.all.f413_2;
		var objf413_3 = document.all.f413_3;

		/* Automatic input */
		if (objf413_3.value != "") {
			objf413_1.value = "000000";
			objf413_2.value = getIHeader("DPT_CD");
		} else {
			objf413_1.value = "";
			objf413_2.value = "";
			document.all.ciff413.value = "";
			document.all.f414.value = "";
		}
	}
	/* 連帯債務者顧客番号2 */
	function checkf415() {
		var objf415_1 = document.all.f415_1;
		var objf415_2 = document.all.f415_2;
		var objf415_3 = document.all.f415_3;

		/* Automatic input */
		if (objf415_3.value != "") {
			objf415_1.value = "000000";
			objf415_2.value = getIHeader("DPT_CD");
			setRequiredParam("f416");
		} else {
			objf415_1.value = "";
			objf415_2.value = "";
			document.all.ciff415.value = "";
			document.all.f416.value = "";
			setNotRequiredParam("f416");
		}
	}
	/* 連帯債務者顧客番号3 */
	function checkf417() {
		var objf417_1 = document.all.f417_1;
		var objf417_2 = document.all.f417_2;
		var objf417_3 = document.all.f417_3;

		/* Automatic input */
		if (objf417_3.value != "") {
			objf417_1.value = "000000";
			objf417_2.value = getIHeader("DPT_CD");
			setRequiredParam("f418");
		} else {
			objf417_1.value = "";
			objf417_2.value = "";
			document.all.ciff417.value = "";
			document.all.f418.value = "";
			setNotRequiredParam("f418");
		}
	}
	/* 連帯債務者顧客番号4 */
	function checkf419() {
		var objf419_1 = document.all.f419_1;
		var objf419_2 = document.all.f419_2;
		var objf419_3 = document.all.f419_3;

		/* Automatic input */
		if (objf419_3.value != "") {
			objf419_1.value = "000000";
			objf419_2.value = getIHeader("DPT_CD");
			setRequiredParam("f420");
		} else {
			objf419_1.value = "";
			objf419_2.value = "";
			document.all.ciff419.value = "";
			document.all.f420.value = "";
			setNotRequiredParam("f420");
		}
	}

	// 2013.3.16 実行代わり金振込処理対応 本多 START
	/* 引落口座 */
	function u_reqcheck(){
		/*if(document.all.f444_2.value != "" || document.all.f444_3.value != "" || document.all.f444_4.value != "" || document.all.f445_2.value != ""){
			setRequiredParam("f444_2");
			setRequiredParam("f444_3");
			setRequiredParam("f444_4");
			setRequiredParam("f445_2");
		}else{
			setNotRequiredParam("f444_2");
			setNotRequiredParam("f444_3");
			setNotRequiredParam("f444_4");
			setNotRequiredParam("f445_2");
		}*/
	}
	// 2013.3.16 実行代わり金振込処理対応 本多 END

	/* button */
	function u_searchCIF(){
		if(document.all[arguments[0]+"_3"].value=="" && document.all[arguments[1]+"_3"].value=="" && document.all[arguments[2]+"_3"].value=="" && document.all[arguments[3]+"_3"].value=="") {
			return;
		}
		document.all.dptCd.value=getIHeader("DPT_CD");

		document.all.cif1.value=document.all[arguments[0]+"_1"].value+document.all[arguments[0]+"_2"].value+document.all[arguments[0]+"_3"].value;
		document.all.cif2.value=document.all[arguments[1]+"_1"].value+document.all[arguments[1]+"_2"].value+document.all[arguments[1]+"_3"].value;
		document.all.cif3.value=document.all[arguments[2]+"_1"].value+document.all[arguments[2]+"_2"].value+document.all[arguments[2]+"_3"].value;
		document.all.cif4.value=document.all[arguments[3]+"_1"].value+document.all[arguments[3]+"_2"].value+document.all[arguments[3]+"_3"].value;
		document.all.nm1.value="cif"+arguments[0];
		document.all.nm2.value="cif"+arguments[1];
		document.all.nm3.value="cif"+arguments[2];
		document.all.nm4.value="cif"+arguments[3];
		dataForm.action=top.CONTEXT+"/4.LON/13300/process6.jsp";
		dataForm.target="popup6";
		<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
		//dataForm.submit();
		xhrSend();
		<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
	}

/*-- 4th tab --------------------------------------------------------------------------------------*/

    /*
     *f44 返済方式コード
     */
	function getCodes(code){
	    //alertFunName("getCodes");
		
		if(!event.target.hasAttribute("value"))return;
		var codeVal = parse(code);
		var product = document.all.f211.value;
		var node1;
		var xql;
		var node2;
        var nodeList;
		var node3;
		var nodeorg;
		var bonusflag;
		var dptCd = getIHeader("DPT_CD");
		var glDay = document.all.glDay.value;
        var paybkmthd;
		var index = 0;
		if(document.all.repayKind.value == 1){ //先取
	        paybkmthd = 5;
	    }else{
	        paybkmthd = 0;
        }

        //LNPGRLN
		/*  // origin
		node1 = top.LNPGRLN.selectSingleNode("/table/record[@DPT_CD='"+top.iHeader["DPT_CD"]+
								"' and @GRP='"+product+
								"' and @PAYBK_MTHD_CODE='"+codeVal+
								"' and @STA='1']");
		*/
		var node_root_1 = "/table/record[@DPT_CD='"+top.iHeader["DPT_CD"]+
								"' and @GRP='"+product+
								"' and @PAYBK_MTHD_CODE='"+codeVal+
								"' and @STA='1']";
		var node_xpath_1 = document.evaluate(node_root_1, top.LNPGRLN, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
		node1 = node_xpath_1.singleNodeValue;

		xql = (node1)? node1.getAttribute("PAYBK_MTHD_CODE") :"";

        //LNPREMH
		/*  // origin
		node2 = top.LNPREMH.selectSingleNode("/table/record[@DPT_CD='"+top.iHeader["DPT_CD"]+
								"' and @PAYBK_MTHD_CODE = '"+xql+
								"' and @CAPT_PAYBK_MTHD != '"+paybkmthd+
								"' and @STA='1']");
		*/
		var node_root_2 = "/table/record[@DPT_CD='"+top.iHeader["DPT_CD"]+
								"' and @PAYBK_MTHD_CODE = '"+xql+
								"' and @CAPT_PAYBK_MTHD != '"+paybkmthd+
								"' and @STA='1']";
		var node_xpath_2 = document.evaluate(node_root_2, top.LNPREMH, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
		node2 = node_xpath_2.singleNodeValue;

        //LNPGRP
		nodeorg = "/table/record[@DPT_CD='"+dptCd+
					"' and @GRP='" +product+
					"' and @APPL_DATE<='" +glDay+
					"' and @STA<40]";
		/*  // origin			
		nodeList = top.LNPGRP.selectNodes(nodeorg);
			
		if (nodeList.length == 0) return;
		*/
		nodeList = document.evaluate(nodeorg, top.LNPGRP, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
		
		if (nodeList.snapshotLength == 0) return;
		
		node3 =  nodeList.snapshotItem(index);
		bonusflag = node3.getAttribute("BONUS_SAME_FLAG");
		document.all.bonussameflag.value = bonusflag;
		
		if(document.all.initFlag.value == 1 && document.all.f44Lbl.value == ""){
			//alert(document.all.initFlag.value);

			document.all.f44Lbl.value = "";
			document.all.f47.value = "";
			document.all.f47Lbl.value = "";
			document.all.f48.value = "";
			document.all.f48Lbl.value = "";
			document.all.f53.value = "";
			document.all.f54.value = "";
			document.all.f150.value = "";
			document.all.f38.value = "";
			document.all.f38.disabled = true;
			document.all.f39_1.value = "";
			document.all.f39_2.value = "";
			document.all.f39_3.value = "";
			document.all.f40.value = "";
			document.all.f42.value = "";
			setNotRequiredParam("f39_1");
			setNotRequiredParam("f39_2");
			setNotRequiredParam("f39_3");
			setNotRequiredParam("f40");
		}
		document.all.f44Lbl.value = (node2)? node2.getAttribute("PAYBK_MTHD_NAME"):"";
		document.all.f45.value = (node2)? node2.getAttribute("CAPT_PAYBK_MTHD"):"0";
		document.all.f46.value = (node2)? node2.getAttribute("INT_PAYBK_MTHD"):"0";
		document.all.f460.value= (node2)? node2.getAttribute("CAPT_PAYBK_KIND"):"0";
		

//EBS 20090519
		if(document.all.f507.value == "7200" && document.all.f45.value  == "19") {
			document.all.f47.value = "98";
			
			label2();
			
			disableField(document.all.f47);
		    //document.all.f47.readOnly = true;			
		    document.all.f50.tabIndex = -1;			
//			disableField(document.all.f42);
//			setNotRequiredParam("f42");
//			document.all.f42.readOnly = true;	
			document.all.f42.value = "";
			document.all.f51.value = "";
			document.all.f52.value = "";
		}
		else {
			enableField(document.all.f47);
			//document.all.f47.readOnly = false;
			document.all.f50.tabIndex = 0;
//			enableField(document.all.f42);
//			setRequiredParam("f42");
//			document.all.f42.readOnly = false;
		}

        /* 毎回分割金 */
		if(document.all.f460.value == 21 || document.all.f460.value == 22 || document.all.f460.value == 23){
			enableField(document.all.f53);
			setRequiredParam("f53");
		}else {
			setNotRequiredParam("f53");
			disableField(document.all.f53);
		}
        /* 分割金適用期間 */
		if(document.all.f460.value == 23){
			enableField(document.all.f150);
			setRequiredParam("f150");
		}else {
			setNotRequiredParam("f150");
			disableField(document.all.f150);
		}
		//20240206一括返済対応
		if((document.all.f45.value == '1') && (document.all.f46.value == '1')){
			document.all.f34.value = 1;
			document.all.f36.value = "";
			document.all.f36.disabled = true;
			document.all.f35_1.disabled = false;
			document.all.f35_2.disabled = false;
			document.all.f35_3.disabled = false;
			setRequiredParam("f35_1");
			setRequiredParam("f35_2");
			setRequiredParam("f35_3");
			setNotRequiredParam("f36");
		}
        /* ボーナス返済金額 */
		if(bonusflag == "1"){
			if (document.all.f460.value != 34 && (document.all.f45.value =="5" || document.all.f45.value =="6")){
                setRequiredParam("f50");
    			document.all.f50.readOnly = false;
    			document.all.f51.readOnly = false;
    			document.all.f50.tabIndex = 0;
    			document.all.f51.tabIndex = 0;
			}else {
				setNotRequiredParam("f50");
			    document.all.f50.value = "";
			    if('<%=f507%>' != "7200") {
					document.all.f51.value = "";
					document.all.f52.value = "";
				}
			    document.all.f50.readOnly = true;
			    document.all.f51.readOnly = true;
			    document.all.f50.tabIndex = -1;
			    document.all.f51.tabIndex = -1;
			}
		}
        /* 不均等返済額情報 */
	    if(document.all.f44.value.length > 0){
            changeView152();
	    }

		if (document.all.f45.value !="1" && document.all.f6.value != 3){
		    document.all.f38.disabled = false;
		}

				
		if(document.all.f44.value == 19){
			document.all.f47.value = 98;			
			makeReadOnly(document.all.f47);
		} else makeEditable(document.all.f47);
	}

    /*
     *f47 元金返済周期
     */
	function label2(){
	    //alertFunName("label2");		

		document.all.f47Lbl.value = "";
		document.all.f48.value = "";
		document.all.f48Lbl.value = "";
		
		document.all.dptCd.value = getIHeader("DPT_CD");
		if(document.all.f47.value.length > 0){
			if(document.all.f47.disabled) document.all.f47.disabled = false;
			dataForm.action=top.CONTEXT+"/4.LON/13300/label2.jsp";
			dataForm.target="popup";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
	}

	/*
	 *f48 利息返済周期
	 */
	function label3(){
//	    alertFunName("label3");
		
		document.all.f48Lbl.value = "";
		document.all.f42.value = "";
		
		document.all.dptCd.value = getIHeader("DPT_CD");
		if(document.all.f48.value.length > 0){
			if(document.all.f47.disabled) document.all.f47.disabled = false;
			dataForm.action=top.CONTEXT+"/4.LON/13300/label3.jsp";
			dataForm.target="popup";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
		
		//EBS 20090526
		if(document.all.f507.value == "7200" && document.all.f45.value  == "19") {
			document.all.f47.value = "98";
			disableField(document.all.f47);
		    document.all.f50.tabIndex = -1;
//			disableField(document.all.f42);
//			setNotRequiredParam("f42");
//			document.all.f42.readOnly = true;
//			document.all.f42.value = "";
			document.all.f51.value = "";
			document.all.f52.value = "";
		}
		else {
			enableField(document.all.f47);
			document.all.f50.tabIndex = 0;
//			enableField(document.all.f42);
//			setRequiredParam("f42");
//			document.all.f42.readOnly = false;
//			document.all.f42.tabIndex = 0;
		}
	}
	function u_autoinit(){
		
		if(event.srcElement.name == "f47"){
			if(event.srcElement.value == "0" || event.srcElement.value.length < 1){
				document.all.f47Lbl.value = "";
				document.all.f48.value = "";
				document.all.f48Lbl.value = "";
			}
		}
		
		if(event.srcElement.name == "f48"){
			if(event.srcElement.value == "0" || event.srcElement.value == ""){
				document.all.f48Lbl.value = "";
			}
		}
		document.all.f42.value = "";
		if(document.all.f45.value == 19 && document.all.f48.value == 98){			
			setNotRequiredParam("f42");
			makeReadOnly(document.all.f42);
		} else {
			
			makeEditable(document.all.f42);
			setRequiredParam("f42");
		}
	}

    /*
     *f50 ボーナス返済金額
     */
	function cal11(){
	    //alertFunName("cal11");
		if(!event.target.hasAttribute("value")) return;
		
		console.log("cal11()");
        /*ボーナス月*/
		if (unFormatComma(document.all.f50.value) > 0) {
			setRequiredParam("f51");
			enableField(document.all.f51);
		}else {
			setNotRequiredParam("f51");
			document.all.f51.value = "";
			document.all.f52.value = "";
			disableField(document.all.f51);
			document.all.f457.value = document.all.f50.value == "" ? 0 : 1;
		}
 		/*ボーナス毎回分割金*/
		if ((document.all.f460.value == 21 || document.all.f460.value == 22 || document.all.f460.value == 23)
		    && (unFormatComma(document.all.f50.value) > 0)) {
			enableField(document.all.f54);
			setRequiredParam("f54");
		}else {
			document.all.f54.value = "";
			setNotRequiredParam("f54");
			disableField(document.all.f54);
		}
	}

    /*
     *f51 ボーナス月
     */
	function cal12(){
	    //alertFunName("cal12");
		var f3 =  unFormatComma(document.all.f3.value);
		f3 = parse(f3);
		var f50 = unFormatComma(document.all.f50.value);
		f50 = parse(f50);
		var f470 = unFormatComma(document.all.f470.value);
		f470 = parse(f470);
		var temp = f3 * f470 / 100;
		if (temp < f50) {
			alertError("200209");
			document.all.f50.value = "";
			setFocus(document.all.f50);
		}
	}
	function cal14(){
	    //alertFunName("cal14");
		if(event.target.value == ""){
			document.all.f52.value = "";
		}else{
			var res = parse(event.target.value);
			console.log("res" + res);
			if(res > 6){
				document.all.f52.value = "";
			}else{
				document.all.f52.value = padNumber(res+6,2);
			}
		}
	}

	/* f54 */
	function bnsAMT_check() {
	    //alertFunName("bnsAMT_check");
		var bnsSchgBal = parse(unFormatComma(document.all.f50.value));   // ボーナス変更後残高
		var bnsEachPart = parse(unFormatComma(document.all.f54.value));  // ボーナス毎回分割金

		if(bnsSchgBal < bnsEachPart) {
			alertError("200209");
			document.all.f54.value = "";
			window.open("","contents","","");
			setFocus(document.all.f50);
			return false;
		}
	}

    /*f35_1*/
	function repay_change() {
	    //alertFunName("repay_change");
		if(event.srcElement.name == "f36" && event.srcElement.value != ""){
			if(parse(document.all.f36.value) != parse( repayMonth )){
				if(document.all.f6.value != 3){
					document.all.f8.value = "";
				}else{
					document.all.f8.value = 3;
				}
				cal6();
				repayMonth = document.all.f36.value;
			}
		}
		if(event.srcElement.name == "f35_1" && event.srcElement.value != ""){
			var chRepayYear = document.all.f35_1.value;
			if(parse(repayYear) != parse(chRepayYear)){
				if(document.all.f6.value != 3){
					document.all.f8.value = "";
				}else{
					document.all.f8.value = 3;
				}
				cal6();
				repayYear = chRepayYear;
			}
		}
		if(event.srcElement.name == "f35_2" && event.srcElement.value != ""){
			var chRepayMth = document.all.f35_2.value;
			if(parse(repayMth) != parse(chRepayMth)){
				if(document.all.f6.value != 3){
					document.all.f8.value = "";
				}else{
					document.all.f8.value = 3;
				}
				cal6();
				repayMth = chRepayMth;
			}
		}
		if(event.srcElement.name == "f35_3" && event.srcElement.value != ""){
			var chRepayDate = document.all.f35_3.value;
			if(parse(repayDate) != parse(chRepayDate)){
				if(document.all.f6.value != 3){
					document.all.f8.value = "";
				}else{
					document.all.f8.value = 3;
				}
				cal6();
				repayDate = chRepayDate;
			}
			// 20240206 Add if statement
			// 「最終償還日数」の場合、日数を約定日に固定し、かつ期限一括方式の場合、修正を防止する。
			if (document.all.f45.value == 1 && document.all.f46.value == 1) {
				document.all.f42.value = chRepayDate;
				document.all.f42.readOnly = true;
			} else {
				document.all.f42.readOnly = false;
				document.all.f42.value = chRepayDate;
				cal13();
			}
		}
		if(document.all.f34.value == "1"){
			var scheYY = document.all.f58_1.value; 	//scheDate.substr(0,4);
			var scheMM = document.all.f58_2.value; 	//scheDate.substr(4,2);
			var scheDD = document.all.f58_3.value; 	//scheDate.substr(6,2);
			var repayYY = document.all.f35_1.value;	//repayDate.substring(0,4);
			var repayMM = document.all.f35_2.value; //repayDate.substring(4,6);
			var repayDD = document.all.f35_3.value; //repayDate.substring(6,8);

			document.all.ichaMonth.value = (repayYY - scheYY) * 12 + (repayMM - scheMM);
			if(scheDD > repayDD){
				document.all.ichaMonth.value = document.all.ichaMonth.value - 1;
			}
		}
		if(document.all.f34.value == "2"){
			document.all.ichaMonth.value = document.all.f36.value ;
		}
	}

    /*
     *f34 期日区分
     */
	function changeField(){
	    //alertFunName("changeField");
		document.all.f35_1.disabled = true;
		document.all.f35_2.disabled = true;
		document.all.f35_3.disabled = true;
		document.all.f36.disabled = true;

		if(document.all.initFlag.value == 1){
			document.all.f35_1.value = "";
			document.all.f35_2.value = "";
			document.all.f35_3.value = "";
			document.all.f36.value = "";
		}

		setNotRequiredParam("f35_1");
		setNotRequiredParam("f35_2");
		setNotRequiredParam("f35_3");
		setNotRequiredParam("f36");

		if(event.srcElement.value == '1'){
			document.all.f35_1.disabled = false;
			document.all.f35_2.disabled = false;
			document.all.f35_3.disabled = false;
			setRequiredParam("f35_1");
			setRequiredParam("f35_2");
			setRequiredParam("f35_3");
		}else if(event.srcElement.value == '2'){
			document.all.f36.disabled = false;
			setRequiredParam("f36");
		}
	}
	function changeField5(){
	    //alertFunName("changeField5");
		if(document.all.f34.value == document.all.f38.value){

		}else if(document.all.f38.value == ''){

		}else{
			document.all.f38.value = "";
			document.all.f40.value = "";
			document.all.f39_1.value = "";
			document.all.f39_2.value = "";
			document.all.f39_3.value = "";
			document.all.f40.disabled = true;
			document.all.f39_1.disabled = true;
			document.all.f39_2.disabled = true;
			document.all.f39_3.disabled = true;
			setNotRequiredParam("f39_1");
			setNotRequiredParam("f39_2");
			setNotRequiredParam("f39_3");
			setNotRequiredParam("f40");
		}
	}

    /*
     *f38 据置区分
     */
	function changeField3(){
	    //alertFunName("changeField3");
		document.all.f39_1.disabled = true;
		document.all.f39_2.disabled = true;
		document.all.f39_3.disabled = true;
		document.all.f40.disabled = true;

		if(document.all.initFlag.value == 1){
			document.all.f39_1.value = "";
			document.all.f39_2.value = "";
			document.all.f39_3.value = "";
			document.all.f40.value = "";
		}

		setNotRequiredParam("f39_1");
		setNotRequiredParam("f39_2");
		setNotRequiredParam("f39_3");
		setNotRequiredParam("f40");

		if(document.all.f38.value == '1'){
			document.all.f39_1.disabled = false;
			document.all.f39_2.disabled = false;
			document.all.f39_3.disabled = false;
			document.all.f39_1.readOnly = false;
			document.all.f39_2.readOnly = false;
			document.all.f39_3.readOnly = false;
			document.all.f39_1.tabindex = 0;
			document.all.f39_2.tabindex = 0;
			document.all.f39_3.tabindex = 0;
			setRequiredParam("f39_1");
			setRequiredParam("f39_2");
			setRequiredParam("f39_3");
		}else if(document.all.f38.value == '2'){
			document.all.f40.disabled = false;
			document.all.f40.readOnly = false;
			document.all.f40.tabindex = 0;
			setRequiredParam("f40");
		}
	}
	function changeField6(){
	    //alertFunName("changeField6");
		if(document.all.f34.value == document.all.f38.value){

		}else if(document.all.f38.value == ''){

		}else if(document.all.f34.value == 2 && document.all.f38.value == 1){

		}else{
			document.all.f38.value = "";
			document.all.f40.value = "";
			document.all.f39_1.value = "";
			document.all.f39_2.value = "";
			document.all.f39_3.value = "";
			document.all.f40.disabled = true;
			document.all.f39_1.disabled = true;
			document.all.f39_2.disabled = true;
			document.all.f39_3.disabled = true;
			setNotRequiredParam("f39_1");
			setNotRequiredParam("f39_2");
			setNotRequiredParam("f39_3");
			setNotRequiredParam("f40");
			setFocus(document.all.f42);
		}
	}

    /*
     *f42 約定日
     */
	function cal13(){
	    //alertFunName("cal13");
		if ((document.all.f42.value == "29") || (document.all.f42.value == "30") ||  (document.all.f42.value == "31")) {
			// 20240206 - Add if statement. f45 = 1：一括返済（一時返済）
			if(document.all.f45.value != "1" ) {
				(document.all.f42.value = "32");
			}
		}
	}


/*-- 5th tab --------------------------------------------------------------------------------------*/
	/*
	 *f8 利率区分
	 */
	function u_devide(){
	    //alertFunName("u_devide");
		if(document.all.f8.value == 1){
			if(document.all.f6.value == '03'){
				document.all.f8.value = "";
			}
		}
	}
	function cal6(){
	    //alertFunName("cal6");
		document.all.changeFlag.value = 0;
		document.all.rateFlag.value = 0;
		document.all.f9.value = "";
		document.all.f9Lbl.value = "";
		document.all.f10.value = "";
		document.all.f10Lbl.value = "";
		document.all.f11.value = "";
		document.all.f12.value = "";
		document.all.f13.value = "";
		document.all.f13Lbl.value = "";
		document.all.f14.value = "";
		document.all.f14Lbl.value = "";

		changeView();
		document.all.f16.value = "0.00000";
		document.all.f17.value = "0.00000";
		document.all.f18.value = "0.00000";
		document.all.f19.value = "0.00000";
		document.all.f20.value = "0.00000";
		document.all.f21.value = "0.00000";
		document.all.f22.value = "0.00000";
		document.all.f23.value = "0.00000";
		document.all.f24.value = "0.00000";
		document.all.f25.value = "0.00000";
		document.all.f26.value = "0.00000";
		document.all.f28.value = "0.00000";
		document.all.f29.value = "0.00000";
		document.all.f30.value = "0.00000";
		document.all.f31.value = "0.00000";
		document.all.f32.value = "0.00000";
		document.all.f438.value= "0.00000";
		document.all.f441.value= "0.00000";
		document.all.f506.value= "0.00000";

		document.all.f28.readOnly = false;
		document.all.f29.readOnly = false;
		document.all.f30.readOnly = true;
		document.all.f33.readOnly = true;
		document.all.f30.tabIndex = -1;
		document.all.f33.tabIndex = -1;
		document.all.f503.pop = "yes";

		document.all.changeFlag.value = 1;

		if(document.all.f8.value == 1){
			document.all.f9.qtype="3315";
    		setNotRequiredParam("f11");
		}else if(document.all.f8.value == 3){
			if(document.all.f6.value == '03'){
				document.all.f9.qtype='3324';
			}else{
				document.all.f9.qtype="3314";
			}
		}
	}
	function changeView(){
	    //alertFunName("changeView");
		document.all.f11.value = "";
		document.all.f12.value = "";
		document.all.f13.value = "";
		document.all.f13Lbl.value = "";
		document.all.f14.value = "";
		document.all.f14Lbl.value = "";
		document.all.f13.disabled = true;
		document.all.f14.disabled = true;
		setNotRequiredParam("f11");
		setNotRequiredParam("f12");
		setNotRequiredParam("f13");
		setNotRequiredParam("f14");

		var kind2 = document.all.f9.value + "";
		var kind3 = kind2.substring(0,1);

		if(kind3 == 8){
			document.all.f13.disabled = false;
			document.all.f14.disabled = false;
			setRequiredParam("f12");
			setRequiredParam("f13");
			setRequiredParam("f14");
		}else if(kind3 == 6){
			document.all.f13.disabled = false;
			document.all.f14.disabled = false;
			setRequiredParam("f11");
			setRequiredParam("f13");
			setRequiredParam("f14");
		}
	}

	/*
	 *f9 変動類型コード
	 */
	function changeValue0(){
	    //alertFunName("changeValue0");
		if(event.propertyName != "value")return;
		document.all.glDay.value = getDate(document.all.tmpglday.value);
		document.all.dptCd.value = getIHeader("DPT_CD");
		document.all.prodCd.value = document.all.f211.value; //prodCd

		if(document.all.f9.value.length > 0 && document.all.f6.value.length > 0 && document.all.f8.value.length > 0){
			document.all.f16.value = 0;
			document.all.f17.value = 0;
			document.all.f18.value = 0;
			document.all.f19.value = 0;
			document.all.f20.value = 0;
			document.all.f21.value = 0;
			document.all.f22.value = 0;
			document.all.f23.value = 0;
			document.all.f24.value = 0;
			document.all.f25.value = 0;
			document.all.f26.value = 0;
			document.all.f441.value = 0;
			document.all.f438.value = 0;
			document.all.f10.value = '';
			document.all.f10Lbl.value = '';
			document.all.f11.value = '';
			document.all.f12.value = '';
			document.all.f13.value = '';
			document.all.f13Lbl.value = '';
			document.all.f14.value = '';
			document.all.f14Lbl.value = '';

			dataForm.action=top.CONTEXT+"/4.LON/13300/process9.jsp";
			dataForm.target="popup9";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
	}
	function changeView4(){
	    //alertFunName("changeView4");
		document.all.f11.pop = "no";
		document.all.f12.pop = "no";
		setNotRequiredParam("f11");
		setNotRequiredParam("f12");
		setNotRequiredParam("f13");
		setNotRequiredParam("f14");

		var kind2 = document.all.f9.value + "";
		var kind3 = kind2.substring(0,1);
		if(kind3 == 8){
			document.all.f13.disabled = false;
			document.all.f14.disabled = false;
			document.all.f11.disabled = true;
			document.all.f12.disabled = false;
			document.all.f12.pop = "yes";
			setRequiredParam("f12");
			setRequiredParam("f13");
			setRequiredParam("f14");
		}else if(kind3 == 6){
			document.all.f13.disabled = false;
			document.all.f14.disabled = false;
			document.all.f11.disabled = false;
			document.all.f12.disabled = true;
			document.all.f11.pop = "yes";
			setRequiredParam("f11");
			setRequiredParam("f13");
			setRequiredParam("f14");
		}else{
			document.all.f13.disabled = true;
			document.all.f14.disabled = true;
			document.all.f11.disabled = true;
			document.all.f12.disabled = true;
		}
	}

    /*
     *f10 基準利率コード
     */
	function localQuery10(){

		if(document.all.f10.value == ""){
			document.all.f10Lbl.value = "";
			return;
		}
		if(event.propertyName != "value")return;
		document.all.glDay.value = document.all.tmpglday.value; //実行予定日
		document.all.dptCd.value = getIHeader("DPT_CD");
		document.all.prodCd.value = document.all.f211.value; //prodCd
		document.all.chpCode.value = document.all.f9.value;  //chpCode
		document.all.baseRate.value = document.all.f10.value; //baseRate
		document.all.appcAmt.value = document.all.f3.value.replace(/\D/g,''); //申請金額

		var chpcd = document.all.f9.value + "";
		var chpkind = chpcd.substr(0,1);
		if(chpkind == '6'){
			document.all.f11.value = '';
			document.all.f13.value = '';
			document.all.f13Lbl.value = '';
			document.all.f14.value = '';
			document.all.f14Lbl.value = '';
		} else if(chpkind = '8'){
			document.all.f12.value = '';
			document.all.f13.value = '';
			document.all.f13Lbl.value = '';
			document.all.f14.value = '';
			document.all.f14Lbl.value = '';
			document.all.f438.value = 0;
		}

		if(document.all.baseRate.value.length > 0 ){
			document.all.rateFlag2.value = "";
			dataForm.action=top.CONTEXT+"/4.LON/13300/process.jsp";
			dataForm.target="popup";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
	}

    /*
     *f11 CAP 特約期間
     */
	function searchrate1(){
	    //alertFunName("searchrate1");
		if(event.propertyName != "value")return;
		document.all.glDay.value = getDate(document.all.tmpglday.value);
		document.all.dptCd.value = getIHeader("DPT_CD");
		document.all.prodCd.value = document.all.f211.value; //prodCd
		document.all.chpCode.value = document.all.f9.value;  //chpCode
		document.all.baseRate.value = document.all.f10.value; //baseRate
		if(document.all.f11.value.length > 0 ){
			dataForm.action=top.CONTEXT+"/4.LON/13300/process10.jsp";
			dataForm.target="popup10";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
			if(document.all.f408_1.value.length == 3){
				dataForm.action=top.CONTEXT+"/4.LON/13300/process8.jsp";
				dataForm.target="popup8";
				<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
				//dataForm.submit();
				xhrSend();
				<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
			}
		}
		else if(document.all.f11.value == ""){
			document.all.f26.value = 0;
			document.all.f22.value = 0;
			document.all.f23.value = 0;
			document.all.f24.value = 0;
			document.all.f441.value = 0;
		}
	}

    /*
     *f12 固定金利特約期間
     */
	function searchrate2(){
	    //alertFunName("searchrate2");
		if(event.propertyName != "value")return;
		document.all.glDay.value = getDate(document.all.tmpglday.value);
		document.all.dptCd.value = getIHeader("DPT_CD");
		document.all.prodCd.value = document.all.f211.value; //prodCd
		document.all.chpCode.value = document.all.f9.value;  //chpCode
		document.all.baseRate.value = document.all.f10.value; //baseRate
		if(document.all.f12.value.length > 0){
			dataForm.action=top.CONTEXT+"/4.LON/13300/process11.jsp";
			dataForm.target="popup11";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
			if(document.all.f408_1.value.length == 3){
				dataForm.action=top.CONTEXT+"/4.LON/13300/process8.jsp";
				dataForm.target="popup8";
				<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
				//dataForm.submit();
				xhrSend();
				<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
			}
		}else{
			document.all.f438.value = "0.00000"; 
		}
	}

    /*
     *f13 次期変動類型コード
     */
     function searchrate3(){
	    //alertFunName("searchrate3");
		if(event.propertyName != "value")return;

		document.all.glDay.value = getDate(document.all.tmpglday.value);
		document.all.dptCd.value = getIHeader("DPT_CD");
		document.all.prodCd.value = document.all.f211.value; //prodCd
		document.all.chpCode.value = document.all.f9.value;  //chpCode
		document.all.baseRate.value = document.all.f10.value; //baseRate
		if(document.all.f13.value.length > 0){
			document.all.f14.value = "";
			document.all.f14Lbl.value = "";
			document.all.f13Lbl.value = "";
			dataForm.action=top.CONTEXT+"/4.LON/13300/process12.jsp";
			dataForm.target="popup12";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
	}

    /*
     *f14 次期基準利率コード
     */
	function searchrate4(){
	    //alertFunName("searchrate4");
		if(event.propertyName != "value")return;
		document.all.glDay.value = getDate(document.all.tmpglday.value);
		document.all.dptCd.value = getIHeader("DPT_CD");
		document.all.prodCd.value = document.all.f211.value; //prodCd
		document.all.chpCode.value = document.all.f9.value;  //chpCode
		document.all.baseRate.value = document.all.f10.value; //baseRate
		if(document.all.f14.value.length > 0){
			document.all.f14Lbl.value = "";
			dataForm.action=top.CONTEXT+"/4.LON/13300/process13.jsp";
			dataForm.target="popup13";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
	}

    /*
     *f503 特約保障コード
     */
	function searchrate5(){
	    //alertFunName("searchrate5");
		if(document.all.f503.value == ""){
			document.all.f503Lbl.value = "";
			document.all.f505.value = "0.00000";
			document.all.f504.value = "0";
			document.all.f504.disabled = true;
			return;
		}
		if(event.propertyName != "value")return;
		if(parseInt(document.all.f503.value,10) == '<%=f503%>'){
			document.all.f503Lbl.value = '<%=f458%>';
			document.all.f505.value = '<%=f505%>';
		}else{
			document.all.grp.value = document.all.f211.value;
			document.all.dptCd.value = getIHeader("DPT_CD");
			document.all.specCd.value = document.all.f503.value; //specCd
			dataForm.action=top.CONTEXT+"/4.LON/13300/process16.jsp";
			dataForm.target="popup16";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
		if(document.all.f503.value == 0){
			document.all.f504.value = "0";
			document.all.f504.disabled = true;
		}else{
			document.all.f504.disabled = false;
		}
	}
	function changeField7(){
	    //alertFunName("changeField7");
		if(document.all.f503.value != ""){
			document.all.f503.value = parseInt(event.srcElement.value,10);
		}
	}

    /*
     *f19 商品減算利率
     */
	function u_pattern2(){
	    //alertFunName("u_pattern2");
		if(document.all.f408_1.value.length > 0){
			if(dataForm.action != top.CONTEXT+"/4.LON/13300/process8.jsp"){
				dataForm.action=top.CONTEXT+"/4.LON/13300/process8.jsp";
				dataForm.target="popup8";
				<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
				//dataForm.submit();
				xhrSend();
				<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
			}
		}
	}

	function cal17(){
	    //alertFunName("cal17");
		if(event.propertyName != "value")return;

		var f16  = parse(document.all.f16.value);
		var f18  = parse(document.all.f18.value);
		var f19  = parse(document.all.f19.value);
		var f20  = parse(document.all.f20.value);
		var f21  = parse(document.all.f21.value);
		var f25  = parse(document.all.f25.value);
		var f26  = parse(document.all.f26.value);
		var f438 = parse(document.all.f438.value);
		var chpcd = document.all.f9.value.substr(0,1);

		if(!f16 ) f16 =0;
		if(!f18 ) f18 =0;
		if(!f19 ) f19 =0;
		if(!f20 ) f20 =0;
		if(!f21 ) f21 =0;
		if(!f25 ) f25 =0;
		if(!f438) f438=0;
		if(!f18 ) f18 =0;
		if(!f19 ) f19 =0;

		if( chpcd == '1' || chpcd == '8' ){ //chp_code = 1x or 8x
			var tmpf17 = f438 + f25 + f18 + f26 - f19;
			if(tmpf17 > 0) document.all.f17.value = getIntPart((tmpf17 + 0.000005) * 100000) / 100000;
			else document.all.f17.value = getIntPart((tmpf17 - 0.000005) * 100000) / 100000;
		}
		else if( chpcd == '2' ){
			var tmpf172 = f18 + f21 + f20 + f26 - f19;
			if(tmpf172 > 0)	document.all.f17.value = getIntPart((tmpf172 + 0.000005) * 100000) / 100000;
			else document.all.f17.value = getIntPart((tmpf172 - 0.000005) * 100000) / 100000;
		}
		else{
			var tmpf173 = f16 + f18 + f21 + f20 + f26 - f19;
			if(tmpf173 > 0)	document.all.f17.value = getIntPart((tmpf173 + 0.000005) * 100000) / 100000;
			else document.all.f17.value = getIntPart((tmpf173 - 0.000005) * 100000) / 100000;
		}
	}
	function cal32(){
	    //alertFunName("cal32");
		if(document.all.changeFlag.value != 1) return;
		var f28  = parse(document.all.f28.value);
		var f29  = parse(document.all.f29.value);
		var f17  = parse(document.all.f17.value);
		var fDEP = parse(document.all.DEPRATE.value);
		var f401 = parse(document.all.f401.value);
		var f402 = parse(document.all.f402.value);
		var f440 = parse(document.all.f440.value);
		var f441 = parse(document.all.f441.value);
		var f505 = parse(document.all.f505.value);
		var f506 = parse(document.all.f506.value);

		if(!f29)  f29=0;
		if(!f28)  f28=0;
		if(!f17)  f17=0;
		if(!fDEP) fDEP=0;
		if(!f401) f401=0;
		if(!f402) f402=0;
		if(!f440) f440=0;
		if(!f441) f441=0;
		if(!f505) f505=0;
		if(!f506) f506=0;

		var chpcode = document.all.f9.value.substr(0,1);
		if( chpcode == "6") {
			var temp = f28 - f29 + f17 + f401 + f402 - fDEP - f440 + f505 + f506;
			
			if(temp > 0) temp = getIntPart(( temp + 0.000005) * 100000) / 100000; 
			    else temp = getIntPart(( temp - 0.000005) * 100000) / 100000;
			if(temp < f441){
				if(parse(document.all.f32.value) == temp) return;
				document.all.f32.value = temp; //getIntPart(((f28 - f29) + (f17 + f401 + f402) - fDEP - f440 + f505 + 0.000005) * 100000) / 100000;
			}else{
				if(parse(document.all.f32.value) == parse(document.all.f441.value)) return;
				document.all.f32.value = document.all.f441.value;
			}
		}else{	
			var test = (f28 + f17 + f401 + f402 - fDEP - f440 - f29 + f505 + f506);
				
			if(parse(document.all.f32.value) == test) return;
			if(test > 0) document.all.f32.value = getIntPart((test + 0.000005) * 100000) / 100000;
			else document.all.f32.value = getIntPart((test - 0.000005) * 100000) / 100000;
		}
        /* 不均等返済額情報 */
		changeView152();
	}
	function cal40(){
	    //alertFunName("cal40");
		if(document.all.changeFlag.value != 1) return;
		if(event.propertyName != "value")return;
		var f22 = parse(document.all.f22.value);
		var f401 = parse(document.all.f401.value);
		var f402 = parse(document.all.f402.value);
		var f505 = parse(document.all.f505.value);

		if(document.all.f22.value > 0){
			document.all.f441.value = getIntPart((f22 + f401 + f402 + f505 + 0.000005) * 100000) / 100000;
		}
	}


 /*-- 6th tab --------------------------------------------------------------------------------------*/
     /*
     * f407, f408 提携先コード
     */
	function label4(){
	    //alertFunName("label4");
		if(event.propertyName != "value") return;
		if(document.all.initFlag.value == 1){
			if(oldValue != document.all.f408.value){
				if(document.all.f407.value !="") document.all.f407.value="";
				document.all.f407Lbl.value="";
				if(document.all.f408_1.value !="") {
					document.all.f408_1.value="";
					dataForm.action=top.CONTEXT+"/4.LON/13300/process8.jsp";
					dataForm.target="popup8";
					<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
					//dataForm.submit();
					xhrSend();
					<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
				}
				document.all.f408_1Lbl.value="";
				oldValue = document.all.f408.value;
			}
			if(document.all.f408.value != "") {
				setRequiredParam("f407");
				oldValue != document.all.f408.value;
			} else {
				setNotRequiredParam("f407");
				document.all.f408Lbl.value = "";
			}
		}
	}
	function u_coalpadding() {
	    //alertFunName("u_coalpadding");
		if(oldValue != document.all.f408.value){
			oldValue = document.all.f408.value;
		}
		if(document.all.f408.value != ""){
			oldValue = document.all.f408.value;
		}
	}
	function clslabel() {
	    //alertFunName("clslabel");
		if(document.all.f407tmp.value == document.all.f407.value) return;
		if(document.all.f407.value.length != 5){
			document.all.f407Lbl.value = "";
			if(document.all.f408_1.value != "") document.all.f408_1.value = "";
			document.all.f408_1Lbl.value = "";
		}else{
			document.all.dptCd.value = getIHeader("DPT_CD");
			dataForm.action=top.CONTEXT+"/4.LON/13300/process7.jsp";
			dataForm.target="popup7";
			<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
			//dataForm.submit();
			xhrSend();
			<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		}
	}
    function u_padding(){
	    //alertFunName("u_padding");
		if(document.all.f407tmp.value == document.all.f407.value) return;
		document.all.tmpflag.value=1;
		document.all.dptCd.value = getIHeader("DPT_CD");
		dataForm.action=top.CONTEXT+"/4.LON/13300/process7.jsp";
		dataForm.target="popup7";
		<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
		//dataForm.submit();
		xhrSend();
		<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
		if(document.all.f407.value.length == 5) return;
		var f407 = parse(document.all.f407.value);
		document.all.f407.value = (f407 == 0)? "" : padNumber(document.all.f407.value,5);

	}

    /*
     * f408_1 優遇幅パターン
     */
	function u_pattern1(){
	    //alertFunName("u_pattern1");
		if(document.all.f408_1.value == ""){
			document.all.f408_1Lbl.value = "";
		}else{
			var tmp = document.all.f408_1.value;
			/*  // origin
			var node=top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 738 and @CODE_5="+tmp+" and (@STA=1 or @STA=2)]");
			*/
			var node_root = "/table/record[@CODE_KIND = 738 and @CODE_5="+tmp+" and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			var node = node_xpath.singleNodeValue;
			
			document.all.f408_1Lbl.value =  (node)? node.getAttribute("CODE_NAME"):"";
		}
		document.all.tmpflag.value=1;
		document.all.f407tmp.value = document.all.f407.value;

		document.all.cnslno.value = document.all.f1_1.value + document.all.f1_2.value + document.all.f1_3.value + document.all.f1_4.value + document.all.f1_5.value;

		dataForm.action=top.CONTEXT+"/4.LON/13300/process8.jsp";
		dataForm.target="popup8";
		<!-- ▼▼▼　2024.02.27 ek XMLHttpRequest 同期化対応　▼▼▼ -->
		//dataForm.submit();
		xhrSend();
		<!-- ▲▲▲　2024.02.27 ek XMLHttpRequest 同期化対応　▲▲▲ -->
	}

	/*f403 ポイント別優遇適用可否*/
	function changeValue2(){
	    //alertFunName("changeValue2");
		if(event.propertyName != "value")return;
		if(event.srcElement.value == "1"){
			document.all.f31.value = "<%=f53%>";
		}else{
			document.all.f31.value = "0.00000";
		}
	}
    /*f404 変動類型別優遇適用可否*/
	function changeValue3(){
	    //alertFunName("changeValue3");
		if(event.propertyName != "value") return;
		var chpCode = document.all.f9.value;
		if(document.all.f404.value == "1"){
			insertValue(chpCode);
		}else{
			document.all.f439.value = "0.00000";
		}
	}
	function insertValue(chpCode){
	    //alertFunName("insertValue");
		var kind2 = chpCode + "";
		var kind3 = kind2.substring(0,1);
		if(document.all.f404.value == 1){
			document.all.f439.value = 0;
			if(kind3 == "6"){
				for(var i=0 ; i<25; i++){
					if(kind3 == document.all.f428[i].value && parse(document.all.f11.value) <= parse(document.all.f429[i].value)){
						document.all.f439.value = document.all.f430[i].value;
						break;
					}
				}
			} else if(kind3 == "8"){
				for(var i=0 ; i<25; i++){
					if(kind3 == document.all.f428[i].value && parse(document.all.f12.value) <= parse(document.all.f429[i].value)){
						document.all.f439.value = document.all.f430[i].value;
						break;
					}
				}
			} else {
				for(var i=0 ; i<25; i++){
					if(kind3 == document.all.f428[i].value){
						document.all.f439.value = document.all.f430[i].value;
						break;
					}
				}
			}
		}
	}

	function changeValue4(){
	    //alertFunName("changeValue4");
		if(document.all.initFlag.value == 1){
			var f440 = parse(document.all.f31.value) + parse(document.all.f439.value);
			var f406 = parse(document.all.f406.value);

			document.all.f440.value = (f440 > f406) ? f406 : f440;
		}
	}

    /* f428 */
	function u_getDesc(code){
	    //alertFunName("u_getDesc");
		if(code > 0){
			var node;
			var index = findIndex(event.srcElement);
			/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = '729' and @CODE_5='"+code+
												"' and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
			*/
			var node_root = "/table/record[@CODE_KIND = '729' and @CODE_5='"+code+
												"' and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			document.all["f428Lbl"][index].value =  (node)? node.getAttribute("CODE_NAME"):"";
		}else{
			var index = findIndex(event.srcElement);
			document.all["f428Lbl"][index].value =  "";
		}
	}


/*-- 8th tab 不均等返済額情報 ---------------------------------------------------------------------*/
	function changeView152(){
	    //alertFunName("changeView152");
		if(document.all.f460.value == 34){
            document.all.d153[0].value = 1;
			document.all.f151.disabled = false;
			changeView151();
		    for(i=0;i<60;i++){
  				document.all.d153[i].disabled = false;
    			document.all.f153[i].disabled = false;
    			document.all.f154[i].disabled = false;
			}
			document.all.d153[0].style.backgroundColor = COLOR_REQUIRED_BG;
			document.all.f153[0].style.backgroundColor = COLOR_REQUIRED_BG;
			document.all.f154[0].style.backgroundColor = COLOR_REQUIRED_BG;
			document.all.td152[0].style.backgroundColor = COLOR_REQUIRED_BG;
			document.all.td153[0].style.backgroundColor = COLOR_REQUIRED_BG;
			document.all.td154[0].style.backgroundColor = COLOR_REQUIRED_BG;
        }else {
            document.all.f151.value = "";
			document.all.f151.disabled = true;
		    for(i=0;i<60;i++){
                document.all.d153[i].value = "";
                document.all.f153[i].value = "";
                document.all.f154[i].value = "";
  				document.all.d153[i].disabled = true;
  				document.all.f153[i].disabled = true;
  				document.all.f154[i].disabled = true;
			}
			document.all.d153[0].style.backgroundColor = COLOR_ENABLED_BG;
			document.all.f153[0].style.backgroundColor = COLOR_ENABLED_BG;
			document.all.f154[0].style.backgroundColor = COLOR_ENABLED_BG;
			document.all.td152[0].style.backgroundColor = COLOR_ENABLED_BG;
			document.all.td153[0].style.backgroundColor = COLOR_ENABLED_BG;
			document.all.td154[0].style.backgroundColor = COLOR_ENABLED_BG;
		}
    }
	function changeView151(){
	    //alertFunName("changeView151");
        if(document.all.old151.value != "") {
		    document.all.f151.value = document.all.old151.value;
		    document.all.old151.value ="";
		}else{
		    document.all.f151.value = document.all.f32.value;
	    }
	}

	function u_compare1(){
	    //alertFunName("u_compare1");
		var index = findIndex(event.srcElement);
		var d153 = new Array();
		var f153 = new Array();
		d153[index] = parseFloat(document.all.d153[index].value);
		f153[index] = parseFloat(document.all.f153[index].value);

		if(index < 60){
 			if(document.all.f153[index].value != ""){
                //Form > To
				if(d153[index] > f153[index]){
					for(var i=index;i<60;i++){
    					document.all.d153[i].value = "";
						document.all.f153[i].value = "";
						document.all.f154[i].value = "";
					    document.all.old_f153[i].value = "";
    				}
					//f153[0] = 0
    				if(f153[index] == '0') {
                        document.all.d153[0].value = '1';
    			    }else{
    			        var tmp = document.all.f153[index-1].value;
    				    document.all.d153[index].value = parseInt(tmp) + 1;
                    }
					setFocus(document.all.f153[index]);
				}
                //f153[i] <> old_f153[i]
				if(document.all.f153[index].value != document.all.old_f153[index].value){
					for(i=index+1;i<60;i++){
						document.all.d153[i].value = "";
						document.all.f153[i].value = "";
						document.all.f154[i].value = "";
                        document.all.old_f153[i].value = "";
					}
				}
 			}else{
                //f153[i] = null
				if(document.all.f153[index+1].value != ""){
					for(i=index+1;i<60;i++){
						document.all.d153[i].value = "";
						document.all.f153[i].value = "";
						document.all.f154[i].value = "";
                        document.all.old_f153[i].value = "";
					}
					document.all.f154[index].value = "";
					setFocus(document.all.f153[index]);
				}
 			}
        }
        document.all.old_f153[index].value = document.all.f153[index].value;
	}
	function u_compare2() {
	    //alertFunName("u_compare2");
		var index = findIndex(event.srcElement);
	    if(index < 60 && document.all.f154[index].value != ""){
            if(document.all.f154[index].value == "0"){
                document.all.f154[index].value="";
                setFocus(document.all.f154[index]);
		    }
            if(index == 0){
                if(document.all.f154[index].value == document.all.f154[index+1].value){
                    document.all.f154[index].value="";
                    setFocus(document.all.f154[index]);
		        }
		    }else if(index == 59) {
                if(document.all.f154[index].value == document.all.f154[index-1].value){
                    document.all.f154[index].value="";
                    setFocus(document.all.f154[index]);
		        }
		    }else{
                if(document.all.f154[index].value == document.all.f154[index-1].value ||
                   document.all.f154[index].value == document.all.f154[index+1].value){
                    document.all.f154[index].value="";
                    setFocus(document.all.f154[index]);
                }
		    }
	    }
	}
	function u_focus() {
	    //alertFunName("u_focus");
		var index = findIndex(event.srcElement);
	    if(index > 0 && index < 60){
			if(document.all.f153[index-1].value == "" && document.all.f154[index-1].value == ""){
				setFocus(document.all.f153[index-1]);
            }
			if(document.all.f153[index-1].value == "" && document.all.f154[index-1].value != ""){
				setFocus(document.all.f153[index-1]);
			}
			if(document.all.f153[index-1].value != "" && document.all.f154[index-1].value == ""){
				setFocus(document.all.f154[index-1]);
			}
		}
	}
	function u_nextNum() {
	    //alertFunName("u_nextNum");
    	var index = findIndex(event.srcElement);
        /* Next d153 */
		if(index >=1 && index <= 58){
            if(document.all.f153[index-1].value != "" && document.all.f154[index-1].value != ""){
			    var tmp = document.all.f153[index-1].value;
			    document.all.d153[index].value = parseInt(tmp) + 1;
			}
	    }
		if(index ==59) {
            var tmp = document.all.f153[index-1].value;
			document.all.d153[index].value = parseInt(tmp) + 1;
	    }
	}
//20160321 fx add 
	function u_moveValue() {
		
		//if(event.propertyName != "value") return;

		var sum = Number(unFormatComma(document.all.f3.value))	- ( Number(unFormatComma(document.all.f601.value))  +
																	Number(unFormatComma(document.all.f602.value))  +
																	Number(unFormatComma(document.all.f603.value)) +
																	Number(unFormatComma(document.all.f604.value)) +
																	Number(unFormatComma(document.all.f605.value)) +
																	Number(unFormatComma(document.all.f606.value)) +
																	Number(unFormatComma(document.all.f607.value)) );

		var subnum=getOHeader("CHARGE_CODE");
		subnum= parseInt(subnum,10);	

		document.all.f608.value =mask7sum( sum.toFixed(subnum)); 
		
	}
//20160321 fx add 
	function u_autoPadding() {
	//	alert("aasd"+event.evnetname);
		var obj=event.srcElement;
		if(obj.fLen ==0) return;
		if (obj.value == ""){
		
			var str = "0.";
			for(var i = 0; i < obj.fLen; i++){
				str = str+"0";
			}
			obj.value =str;
		} else{
		var numStr=unFormatComma(obj.value);
			
			//alert(numStr);
			var dotIndex=numStr.indexOf(".");
			var floatnum = getFloatPart(numStr)
			var  tmp =  obj.fLen - floatnum.length;
			//alert(tmp);
			var zerop="";
			for(var i = 0; i < tmp; i++){
				zerop= zerop+"0";
			}
			//alert(zerop);
			
			if(dotIndex ==0){
				obj.value="0"+obj.value;	
			}
			if(dotIndex ==-1){
				obj.value=obj.value+".";	
			}
		    obj.value=obj.value+zerop;
		}

	}

    //20160429 sub_curr_padding
	function mask7sum(num){
	var returnvar;

	var dotIndex = num.indexOf(".");

		if (dotIndex > 0) {

			var intvar=	formatComma(getIntPart(num));
			var floatvar=getFloatPart(num);
			returnvar=intvar+"."+floatvar; 
			return returnvar;
		
		}else{
			returnvar=formatComma(num);	
			return returnvar;
		}
	}

</script>
<style>
<!--
.xTitle {border:1px outset;background-color:#c0c0c0;font-size:9pt }
.xInput {border:none;text-align:center; }
//-->
</style>
<!-- 20150915 code 01-->
<input type='hidden' name='code' value='01'>
<input type='hidden' name='RTN_FLAG' value='9'>
<button id=NEW onclick="top.execute(document.all.trCode.value, '01')" style='border:1px inset;' disabled=true><sup>F5</sup>&nbsp;<script>w1('APPLICATION')</script></button>
<button id=DELETE onclick="top.execute(document.all.trCode.value, '03')" disabled=true><sup>F7</sup>&nbsp;<script>w1('DELETE')</script></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<button id=TRANSACTION2 onclick="changeRTNFlag7()" disabled=true><sup>&nbsp;&nbsp;</sup><script>w1('ADDNEW')</script></button>
<button id=PRINT onclick="changeRTNFlag2()" disabled=true><sup>&nbsp;</sup><script>w1('PRINT')</script></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<button id=TRANSACTION type=submit disabled=true onclick="changeRTNFlag9()"><sup>F9</sup>&nbsp;<script>w1('TRANSACTION')</script></button>
<br>
<p>
<label class="tab_page_label"><script>w1('CNSLNO')</script></label>
<input type='hidden' name='f1_1' value='<%= f4_1 %>'><input name='f1_2' style='width:44px;' readonly tabindex='-1' value='<%= f4_2 %>'><input name='f1_3' style='width:44px;' readonly tabindex='-1' value='<%= f4_3 %>'><input name='f1_4' style='width:24px;' readonly tabindex='-1' value='<%= f4_4 %>'><input name='f1_5' style='width:64px;' readonly tabindex='-1' value='<%= f4_5 %>'>
<label class="tab_page_label"><script>w1('CURRENCYCD')</script></label> <input name='f100'  style='width:44px;' readonly ></input><br> <!--20160321fx add ---->
<input type='hidden' name='h1_1' value='<%= f4_1 %>'><input type='hidden' name='h1_2' value='<%= f4_2 %>'><input type='hidden' name='h1_3' style='width:44px;' value='<%= f4_3 %>'><input type='hidden' name='h1_4' style='width:24px;' value='<%= f4_4 %>'><input type='hidden' name='h1_5' style='width:64px;' value='<%= f4_5 %>'>
<label class="tab_page_label"><script>w1('CIF')</script></label>
<input type='hidden' name='CIF_1' readonly tabindex=-1 value='<%= f9_1 %>'><input type='hidden' name='CIF_2' style='width:44px;' readonly tabindex=-1 value='<%= f9_2 %>'><input name='CIF_3' style='width:84px;' readonly tabindex=-1 value='<%= f9_3 %>'><input name='CIFNAME' style='width:604px;' readonly tabindex=-1 value='<%= f10 %>'><br>
<input type='hidden' name='f2'><br>

</p>
<div class=TabUI>
<span id=tabItems class='TabItem'><script>w1('LOANCNAPINFO')</script></span>		<!--貸出相談情報-->
<span id=tabItems class='TabItem'><script>w1('BONDPROPERTYINFO')</script></span>	<!--債務者属性情報-->
<span id=tabItems class='TabItem'><script>w1('LOANENROLLINFO1')</script></span>		<!--貸出登録情報１-->
<span id=tabItems class='TabItem'><script>w1('LOANENROLLINFO2')</script></span>		<!--貸出登録情報２-->
<span id=tabItems class='TabItem'><script>w1('LOANENROLLINFO3')</script></span>		<!--貸出登録情報３-->
<span id=tabItems class='TabItem'><script>w1('PRIVRATE')</script></span>			<!--優遇金利-->
<span id=tabItems class='TabItem'><script>w1('LIMTREGINFO')</script></span>			<!--極度取引情報-->
<span id=tabItems class='TabItem'><script>w1('REPAYAMTINFO')</script></span>		<!--不均等返済額情報-->
<span id=tabItems class='TabItem'><script>w1('DEEMEDINTEREST')</script></span>		<!--みなし利息-->
</div>

<!-- 1st tab -------------------------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>

<label class="tab_page_label"><script>w1('LONSTATUS')</script></label>
<input name='f206' style='width:154px;' readonly tabindex=-1 value='<%= f7 %>'><br>

<input type='hidden' name='f209' style='width:364px;' readonly tabindex=-1 value='<%= f11 %>'>
<label class="tab_page_label"><script>w1('COMPTYPNAM')</script></label>
<input name='f210' style='width:44px;' qtype="61" readonly tabindex=-1 pop="no" value='<%= f12 %>'><input name='f210Lbl' style='width:364px;' readonly tabindex=-1><br>

<label class="tab_page_label"><script>w1('PRODCD')</script></label><input name='f211' type='hidden' value='<%= f13 %>'>
<input name='f211_1' style='width:114px' readonly tabindex=-1 value='<%= ProductCode(f13) %>'><input name='f212' style='width:424px;' readonly tabindex=-1 value='<%= f14 %>'><br>

<label class="tab_page_label"><script>w1('FUNDUSECD')</script></label>
<input name='f213' style='width:44px;' readonly tabindex=-1 value='<%= f15 %>'><input name='f501' style='width:354px;' readonly tabindex='-1' value='<%= f501 %>'><br>

<label class="tab_page_label"><script>w1('CNSLKIND')</script></label>
<select name='f217' table='LNPCODE' key='634' disabled></select>
<label class="tab_page_label" style='width:308px;'><script>w1('LIMITKIND')</script></label>
<select name='f218' table='LNPCODE' key='632' disabled></select><br>

<label class="tab_page_label"><script>w1('COLLKIND')</script></label>
<select name='f219' table='LNPCODE' key='23' disabled style='width:290px;'></select>
<label class="tab_page_label"><script>w1('GUARNTTYP')</script></label>
<input name='f220' style='width:44px;' onpropertychange="u_getGuarKind(this.value)" readonly tabindex=-1 value='<%= f19 %>'><input name='f220Lbl' style='width:244px;' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('BILLCNLTKIND')</script></label>
<select name='f221' table='LNPCODE' key='633' disabled></select>
<label class="tab_page_label" style='width:294px;'><script>w1('ACCTABOUTBILLLOAN')</script></label>
<input type='hidden' name='f222_1' readonly tabindex=-1 value='<%= f21_1 %>'><input type='hidden' name='f222_2' readonly tabindex=-1 value='<%= f21_2 %>'><input name='f222_3' style='width:44px;' readonly tabindex=-1 value='<%= f21_3 %>'><input name='f222_4' style='width:29px;' readonly tabindex=-1 value='<%= f21_4 %>'><input name='f222_5' style='width:64px;' readonly tabindex=-1 value='<%= f21_5 %>'><br>

<label class="tab_page_label"><script>w1('GUARCOKINDCODE')</script></label>
<input name='f296' style='width:44px;' qtype='3206' readonly tabindex=-1 pop='no' value='<%= f96 %>'><input name='f296Lbl' style='width:254px;' readonly tabindex='-1' value='<%= f296Lbl %>'>
<label class="tab_page_label" style="width:112px;"><script>w1('GUARCOMPCODE')</script></label>
<input name='f297' style='width:44px;' qtype='3207' readonly tabindex=-1 pop='no' value='<%= f97 %>'><input name='f297Lbl' style='width:244px;' readonly tabindex='-1' value='<%= f297Lbl %>'><br>

<label class="tab_page_label"><script>w1('GROUPLIFECODE')</script></label>
<input name='f223' style='width:44px;' readonly tabindex=-1  qtype='3154' pop='no' value='<%= f22 %>'><input name='f502' style='width:254px;' readonly tabindex='-1' value='<%= f502 %>'>
<label class="tab_page_label" style="width:112px;"><script>w1('LIFECNT')</script></label>
<input name='f224' style='width:44px;' readonly tabindex=-1 value='<%= f23 %>'><br>

<label class="tab_page_label"><script>w1('LOANENTERFLAG')</script></label>
<input type="checkbox" name='f225' style="height:fit-content; margin-left:-4px;" value='<%= f24 %>'  <%=f24.trim().equals("y") ? "checked" : "" %>>
<label class="tab_page_label" style='margin-left:-35px;'><script>w1('CKECKYN')</script></label>
<label class="tab_page_label" style='margin-left:187px;'><script>w1('LOANINSLNO')</script></label>
<input name='f226' style='width:154px;' readonly tabindex=-1 value='<%= f25 %>'><br>

<input type='hidden' name='cnslno'><!--相談番号-->
<input type='hidden' name='changeFlag'>
<input type='hidden' name='initFlag'><!--1からinitPage()処理後-->
</div>





<!-- 2nd tab -------------------------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>

<label class="tab_page_label"><script>w1('DEBTKIND')</script></label>
<select name='f300' table="LNPCODE" key="609" disabled ></select>
<label class="tab_page_label" style="width:142px;"><script>w1('CLASSTYP3')</script></label>
<select name='f301' table="LNPCODE" key="610" disabled ></select><br>
<label class="tab_page_label"><script>w1('CREDITKIND')</script></label>
<select name='f303' table="LNPCODE" key="611" disabled ></select>
<label class="tab_page_label"><script>w1('TREATPLAN')</script></label>
<select name='f304' table="LNPCODE" key="612" disabled ></select><br>
<label class="tab_page_label"><script>w1('SUMMARY')</script></label>
<input name='f308' style='width:464px;' readonly tabindex=-1 value='<%= f106 %>'><br>
<label class="tab_page_label">&nbsp;</label>
<input name='f309' style='width:464px;' readonly tabindex=-1 value='<%= f107 %>'><br>
<label class="tab_page_label">&nbsp;</label>
<input name='f310' style='width:464px;' readonly tabindex=-1 value='<%= f108 %>'><br>
<label class="tab_page_label">&nbsp;</label>
<input name='f311' style='width:464px;' readonly tabindex=-1 value='<%= f109 %>'><br>
</div>




<!-- 3rd tab -------------------------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('WANAPPLAMT')</script></label>
<input name='f3' style='width:154px;' onpropertychange='u_moveValue()'
onblur="u_autoPadding()" value='<%= f6 %>'> <!--  20160321---------->

<label class="tab_page_label" style="margin-left:90px;"><script>w1('LONREQDT')</script></label>
<input name='f58_1' style='width:44px;'><input name='f58_2' style='width:29px;'><input name='f58_3' style='width:29px;'>
<input name='f58' type='hidden'><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('SOLIEMPNO')</script></label>
<input name='f4' qtype='28' style="width:84px;" maxlength='10' value='<%= f26 %>'><input name='f4Lbl' style="width:204px;" readonly tabindex=-1>
<label class="tab_page_label" style='margin-left:-44px;'><script>w1('MGREMPNM')</script></label>
<input name='f5' qtype='28' style="width:84px;" maxlength='10' value='<%= f27 %>'><input name='f5Lbl' style="width:204px;" readonly tabindex=-1><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('SGTPROPNO')</script></label>
<input name='f409' qtype='28' style="width:84px;" maxlength='10' pop='no' readonly tabindex='-1' value='<%= f409 %>'><input name='f409Lbl' style="width:204px;" readonly tabindex=-1 value='<%= f409Lbl %>'><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('RELTCNSLNO')</script></label>
<input name='f435_1' style="width:144px;" readonly tabindex=-1><input name='f435' type='hidden' style="width:144px;" readonly tabindex=-1 value='<%= f435 %>'>
<label class="tab_page_label" style="margin-left:100px;"><script>w1('LONTOTAMT')</script></label>
<input name='f436' style='width:134px;' readonly tabindex='-1' value='<%= f436 %>'><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('LIFEINSUAMT3')</script></label>
<input name='f410' style='width:134px;' value='<%= f410 %>'>
<label class="tab_page_label" style="margin-left:110px;"><script>w1('LIFEINSUAMT4')</script></label>
<input name='f411' style='width:134px;' value='<%= f411 %>'><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('GUARTYPE')</script></label>
<input name='f426' style="width:29px;" qtype="3400" master="f297" master2="execday" onpropertychange='localQuery2()' value='<%= f426 %>'><input name='f426Lbl' style="width:224px;" readonly tabindex=-1 value='<%= f426Lbl %>'><br>

<!---- 2021/07/14 ORIX DEMO ebs START
<label class="tab_page_label"><script>w1('FEEPATN1')</script></label>
<select name='f446' table="COMCOMB" key="5090" value='<%= f446 %>'></select>
<label class="tab_page_label" style="margin-left:136px;"><script>w1('FEEPATN2')</script></label>
<select name='f447' table="COMCOMB" key="5090" value='<%= f447 %>'></select><br>   -->

<label class="tab_page_label" style="width:161px; padding:0; font-size:11px;"><script>w1('FEEPATN1')</script></label>
<select name='f446' table='LNPCODE' key='726' value='<%= f446 %>'></select>
<label class="tab_page_label" style="width:161px; padding:0; font-size:11px; margin-left:107px;"><script>w1('FEEPATN2')</script></label>
<select name='f447' table='LNPCODE' key='726' value='<%= f447 %>'></select><br>
<!---- 2021/07/14 ORIX DEMO ebs END ---->

<label class="tab_page_label" class="tab_page_label" style="margin-left:36px;"><script>w1('OUTACCT_CIF')</script></label>
<input name='f445_1' type='hidden' value='<%= f445_1 %>'><input name='f445_3' type='hidden' value='<%= f445_3 %>'><input name='f445_2' style="width:84px;" value='<%= f445_2 %>' onpropertychange='u_reqcheck()'>

<br><br>
<!-- 引落口座情報 -->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('DEPACCT_INFO')</script></label><br>
<!-- 銀行 -->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('BANK')</script></label>
<input name='f444_1' qtype='4084' style='width:40px;' maxlength='4' data-methods="getBankName1();" value='<%= f444_1 %>' ><input name='f444_1Lbl' style='width:244px;' maxlength='30' readonly tabindex='-1' value='<%= f444_1Lbl %>' >

<!-- 支店 -->
<label class="tab_page_label" style="margin-left:-40px;"><script>w1('NBR')</script></label>
<input name='f444_2' qtype='4085' style='width:40px;' maxlength='4' master="f444_1" data-methods="getShitenName1();" value='<%= f444_2 %>'><input name='f444_2Lbl' style='width:244px;' readonly tabindex='-1' value='<%= f444_2Lbl %>'><br>

<!-- 種別-->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('KIND')</script></label>
<input name='f444_3' style='width:24px;' maxlength='2' qtype='3999' value='<%= f444_3 %>'><input name='f444_3Lbl' style='width:94px;' readonly tabindex='-1' value='<%= f444_3Lbl %>'>

<!-- 口座番号 -->
<label class="tab_page_label" style="margin-left:131px;"><script>w1('DEP_ACCT_NO')</script></label><input name='f444_4' style='width:164px;' maxlength='7' value='<%= f444_4 %>'><br>

<!-- 20200331 Ek Edit Start -->
<!-- 引落名義(カナ) -->
<label class="tab_page_label" style="margin-left:40px;"><script>w1('DEP_ACCT_NAME_KANA')</script></label></label><input name='f461' style='width:454px;' maxlength='30' value='<%= f461 %>'>
<br><br>
<!-- 20200331 Ek Edit End -->

<!-- 入金（振込先）口座情報 -->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('TRFACCT_INFO')</script></label><br>
<!-- 銀行 -->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('BANK')</script></label>
<input name='f508_1' qtype='4084' style='width:40px;' maxlength='4' data-methods="getBankName2();"  value='<%= f508_1 %>'><input name='f508_1Lbl' style='width:244px;' maxlength='30' readonly tabindex='-1' value='<%= f508_1Lbl %>' >

<!-- 支店 -->
<label class="tab_page_label" style="margin-left:-40px;"><script>w1('NBR')</script></label>
<input name='f508_2' qtype='4085' style='width:40px;' maxlength='4' master="f508_1" data-methods="getShitenName2();" value='<%= f508_2 %>'><input name='f508_2Lbl' style='width:244px;' readonly tabindex='-1' value='<%= f508_2Lbl %>'><br>

<!-- 種別 -->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('KIND')</script></label>
<input name='f508_3' style='width:24px;' maxlength='2' qtype='3999' value='<%= f508_3 %>'><input name='f508_3Lbl' style='width:94px;' readonly tabindex='-1' value='<%= f508_3Lbl %>'>

<!-- 口座番号 -->
<label class="tab_page_label" style="margin-left:131px;"><script>w1('DEP_ACCT_NO')</script></label><input name='f508_4' style='width:164px;' maxlength='7' value='<%= f508_4 %>'><br>

<!-- 口座名義(カナ) -->
<label class="tab_page_label" style="margin-left:40px;"><script>w1('DEPACCTNAME')</script></label></label><input name='f509' style='width:454px;' maxlength='30' value='<%= f509 %>'>
<br><br>


<label class="tab_page_label" style="margin-left:36px;"><script>w1('LOANISSUMETHOD')</script></label>
<input name='f6' style="width:29px;" qtype='3210' data-methods="show()" onblur="u_autotwo(this.value)" value='<%= f28 %>'><input name='f6Lbl' style="width:164px;" readonly tabindex=-1 value='<%= f6Lbl %>'><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('RELDEBTKIND')</script></label>
<select name='f412' table='LNPCODE' key='720' onpropertychange="show2()" value='<%= f412 %>'><select>
<label class="tab_page_label" style='margin-left:155px;'><script>w1('JOINDEBTRATE')</script></label>
<input name='p906' style='width:34px;' readonly tabIndex='-1'>%
<input type='hidden' name='f7' value='<%= f29 %>'><!--限度区分--><br>

<span id='d2' style="display:none;"><!--show2()-->
	<label class="tab_page_label" style="margin-left:36px;"><script>w1('JOINJOINCIF1')</script></label>
	<input name='f413_3' style='width:84px;' onpropertychange="doCheckInputFields(this);" value='<%= f413_3 %>'><input name='ciff413' style='width:404px;' maxlength='30' readonly tabindex='-1'>
	<input name='f413_1' type='hidden' value='<%= f413_1 %>'><input name='f413_2' type='hidden' value='<%= f413_2 %>'>
	<label class="tab_page_label" style='margin-left:-45px;'><script>w1('JOINRATET1')</script></label>
	<input name='f414' style='width:34px;' onblur="u_joinChange('p906','f414','f416','f418','f420','f412')" value='<%= f414 %>'>%<br>

	<label class="tab_page_label" style="margin-left:36px;"><script>w1('JOINJOINCIF2')</script></label>
	<input name='f415_3' style='width:84px;' onpropertychange="doCheckInputFields(this);" value='<%= f415_3 %>'><input name='ciff415' style='width:404px;' maxlength='30' readonly tabindex='-1'>
	<input name='f415_1' type='hidden' value='<%= f415_1 %>'><input name='f415_2' type='hidden' value='<%= f415_2 %>'>
	<label class="tab_page_label" style='margin-left:-45px;'><script>w1('JOINRATE2')</script></label>
	<input name='f416' style='width:34px;' onblur="u_joinChange('p906','f414','f416','f418','f420','f412')" value='<%= f416 %>'>%<br>

	<label class="tab_page_label" style="margin-left:36px;"><script>w1('JOINJOINCIF3')</script></label>
	<input name='f417_3' style='width:84px;' onpropertychange="doCheckInputFields(this);" value='<%= f417_3 %>'><input name='ciff417' style='width:404px;' maxlength='30' readonly tabindex='-1'>
	<input name='f417_1' type='hidden' value='<%= f417_1 %>'><input name='f417_2' type='hidden' value='<%= f417_2 %>'>
	<label class="tab_page_label" style='margin-left:-45px;'><script>w1('JOINRATE3')</script></label>
	<input name='f418' style='width:34px;' onblur="u_joinChange('p906','f414','f416','f418','f420','f412')" value='<%= f418 %>'>%<br>

	<label class="tab_page_label" style="margin-left:36px;"><script>w1('JOINJOINCIF4')</script></label>
	<input name='f419_3' style='width:84px;' onpropertychange="doCheckInputFields(this);" value='<%= f419_3 %>'><input name='ciff419' style='width:404px;' maxlength='30' readonly tabindex='-1'>
	<input name='f419_1' type='hidden' value='<%= f419_1 %>'><input name='f419_2' type='hidden' value='<%= f419_2 %>'>
	<label class="tab_page_label" style='margin-left:-45px;'><script>w1('JOINRATE4')</script></label>
	<input name='f420' style='width:34px;' onblur="u_joinChange('p906','f414','f416','f418','f420','f412')" value='<%= f420 %>'>%<br>
	<button style='margin-left:165px;' onClick="u_searchCIF('f413','f415','f417','f419')" id=cifsearch><script>w1('QUERY')</script></button>
</span>
<span id='d' style="display:none;"><!--show()-->
	<br><b><label class="tab_page_label" style="margin-left:36px;"><script>w1('DIVISSUSCHEINFO')</script></label></b><br>

	<label class="tab_page_label" style="margin-left:36px;"><script>w1('DIVISSUSCHECNT')</script></label>
	<input name='f59' style='width:29px;' maxlength=1 onblur="u_divissu()" value='<%= f85 %>'>
	<label class="tab_page_label" style="margin-left:-17px;"><script>w1('SCHEDATE')</script></label><label style="margin-left:5px;"><script>w1('SCHEAMT')</script></label><br>

	<input style="margin-left:205px;" name='f60_1' style='width:44px;' disabled=true value='<%= f86_1 %>'><input name='f60_2' style='width:29px;' disabled=true value='<%= f86_2 %>'><input name='f60_3' style='width:29px;' disabled=true value='<%= f86_3 %>'><input  style="margin-left:50px;" name='f421' style='width:154px;' disabled=true value='<%= f421 %>' onblur="u_autoPadding()"><br>
	<input style="margin-left:205px;" name='f61_1' style='width:44px;' disabled=true value='<%= f87_1 %>'><input name='f61_2' style='width:29px;' disabled=true value='<%= f87_2 %>'><input name='f61_3' style='width:29px;' disabled=true value='<%= f87_3 %>'><input  style="margin-left:50px;" name='f422' style='width:154px;' disabled=true value='<%= f422 %>' onblur="u_autoPadding()" ><br>
	<input style="margin-left:205px;" name='f62_1' style='width:44px;' disabled=true value='<%= f88_1 %>'><input name='f62_2' style='width:29px;' disabled=true value='<%= f88_2 %>'><input name='f62_3' style='width:29px;' disabled=true value='<%= f88_3 %>'><input  style="margin-left:50px;" name='f423' style='width:154px;' disabled=true value='<%= f423 %>' onblur="u_autoPadding()"><br>
	<input style="margin-left:205px;" name='f63_1' style='width:44px;' disabled=true value='<%= f89_1 %>'><input name='f63_2' style='width:29px;' disabled=true value='<%= f89_2 %>'><input name='f63_3' style='width:29px;' disabled=true value='<%= f89_3 %>'><input  style="margin-left:50px;" name='f424' style='width:154px;' disabled=true value='<%= f424 %>' onblur="u_autoPadding()" ><br>
	<input style="margin-left:205px;" name='f64_1' style='width:44px;' disabled=true value='<%= f90_1 %>'><input name='f64_2' style='width:29px;' disabled=true value='<%= f90_2 %>'><input name='f64_3' style='width:29px;' disabled=true value='<%= f90_3 %>'><input  style="margin-left:50px;" name='f425' style='width:154px;' disabled=true value='<%= f425 %>' onblur="u_autoPadding()" ><br>
</span>

<input type='hidden' name='repayKind'><!--先取/後取区分-->
<input type='hidden' name='cif1'>
<input type='hidden' name='cif2'>
<input type='hidden' name='cif3'>
<input type='hidden' name='cif4'>
<input type='hidden' name='nm1'>
<input type='hidden' name='nm2'>
<input type='hidden' name='nm3'>
<input type='hidden' name='nm4'>
<input type='hidden' name='bnkCd'><!--銀行コード-->
<input type='hidden' name='bnkCd2'><!--銀行コード-->
<input type='hidden' name='brnCd'><!--支店コード-->
<input type='hidden' name='bnkFlg' ><!--引落・振込口座の処理フラグ-->
<input type='hidden' name='f444'>
<input type='hidden' name='f508'>
</div>

<!-- 4th tab -------------------------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>
<!-- 返済方式コード -->
<label class="tab_page_label"><script>w1('PAYBKMTHDCODE')</script></label>
<input name='f44' style="width:34px;" qtype="3301" master="f211"  data-methods="getCodes(this.value)" value='<%= f67 %>'><input name='f44Lbl' style="width:404px;" readonly tabindex=-1 value='<%= f448 %>'><br>
<!--元金返済方式-->
<label class="tab_page_label"><script>w1('CAPTPAYBKMTHD')</script></label>
<select name='f45' table="LNPCODE" key="507"></select>
<!--利息返済方式-->
<label class="tab_page_label" style="width:215px;"><script>w1('INTPAYBKMTHD')</script></label>
<select name='f46' table="LNPCODE" key="506"></select><br>
<!--元金返済周期-->
<label class="tab_page_label"><script>w1('CAPTPAYBKCYCL')</script></label>
<input name='f47' style="width:29px;" qtype="3302" master="f44" onkeyup="label2();u_autoinit()" maxlength='2' value='<%= f70 %>'><input name='f47Lbl' style="width:164px;" readonly tabindex=-1 value='<%= f449 %>'>
<!--利息返済周期-->
<label class="tab_page_label" style='margin-left:58px;'><script>w1('INTPAYBKCYCL')</script></label>
<input name='f48' style="width:29px;" qtype="3303" master="f47" master2="f44" onkeyup="label3();u_autoinit()" maxlength='2' value='<%= f71 %>'><input name='f48Lbl' style="width:164px;" readonly tabindex=-1 value='<%= f450 %>'><br>
<!--返済方式種類-->
<label class="tab_page_label"><script>w1('CAPTPAYBKKIND')</script></label>
<select name='f460'  table="LNPCODE" key="721"></select><br>
<input name='f49' type='hidden' table='LNPCODE' key='604'><!--STEP種類-->
<input name='stepFlag' type='hidden' style='margin-left:-4px;' disabled><!--STEP適用区分-->
<!--ボーナス返済金額-->
<label class="tab_page_label"><script>w1('BNSREPAYAMT')</script></label>

<input name='f50' style='width:134px;' data-methods="cal11()" onblur="u_autoPadding()" value='<%= f75 %>'>

<!--ボーナス月-->
<label class="tab_page_label" style='margin-left:110px;'><script>w1('BNSREPAYMON')</script></label>
<input name='f51' style='width:24px;'  onfocus="cal12()" data-methods="cal14()">,<input name='f52' style='width:24px;' value='<%= f77 %>' readonly tabindex='-1'><br>
<!--毎回分割金-->
<label class="tab_page_label"><script>w1('EACHPARTAMT')</script></label>
<input name='f53' style='width:134px;' value='<%= f79 %>'>
<!--ボーナス毎回分割金-->
<label class="tab_page_label" style='margin-left:110px;'><script>w1('BNSEACHPARTAMT')</script></label>
<input name='f54' style='width:134px;' onblur="bnsAMT_check()" value='<%= f80 %>'><br>
<!--分割金適用期間-->
<label class="tab_page_label"><script>w1('AMTAPPLTERM')</script></label>
<input name='f150' style="width:34px;" value='<%= f150 %>'><br><br>
<!--期日区分-->
<label class="tab_page_label"><script>w1('MATUDTTYP')</script></label>
<select name='f34' table='COMCOMB' key='2920' onchange="changeField()" data-methods='changeField5()'></select>
<!--承認期限-->
<label class="tab_page_label" style="margin-left:13px;"><script>w1('APRLIMT')</script></label>
<input name='f35_1' style='width:44px;' onblur="repay_change()" value='<%= f57_1 %>'><input name='f35_2' style='width:24px;' onblur="repay_change()" value='<%= f57_2 %>'><input name='f35_3' style='width:24px;' onblur="repay_change()" value='<%= f57_3 %>'>
<!--返済月数-->
<label class="tab_page_label"><script>w1('RIMBMNS')</script></label>
<input name='f36' style='width:34px;' onblur="repay_change()" value='<%= f58 %>'><input type='hidden' name='f37' style='width:84px;' value='<%= f59 %>'><br>
<!--据置区分-->
<label class="tab_page_label"><script>w1('EXPTYP')</script></label>
<select name='f38' table='COMCOMB' key='890' onchange="changeField3()" onblur='changeField6()'></select>
<!--最終据置日-->
<label class="tab_page_label" style='margin-left:26px;'><script>w1('EXPEXPR')</script></label>
<input name='f39_1' style='width:44px;' value='<%= f61_1 %>'><input name='f39_2' style='width:24px;' value='<%= f61_2 %>'><input name='f39_3' style='width:24px;' value='<%= f61_3 %>'>
<!--据置月数-->
<label class="tab_page_label"><script>w1('EXPMTHS')</script></label>
<input name='f40' style='width:34px;' value='<%= f62 %>'><input type='hidden' name='f41' style='width:84px;' value='<%= f63 %>'><br>
<!--約定日-->
<label class="tab_page_label"><script>w1('THEDATE')</script></label>
<input name='f42' style='width:29px;' onblur='cal13()' value='<%= f64 %>'><br>
<input name='f43' type='hidden' value='<%= f66 %>'><br><!--振込猶予区分-->
<!--返済資源-->
<label class="tab_page_label"><script>w1('REPAYFUND')</script></label>
<input name='f55' style='width:364px;' maxlength='20' value='<%= f81 %>'><br>
<!--返済方式-->
<label class="tab_page_label"><script>w1('RIMBMTHD')</script></label>
<input name='f56' style='width:364px;' maxlength='20' value='<%= f82 %>'><br>
<!--期待効果-->
<label class="tab_page_label"><script>w1('EXPECEFF')</script></label>
<input name='f57' style='width:364px;' maxlength='20' value='<%= f83 %>'><br>
</div>

<!-- 5th tab -------------------------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>

<label class="tab_page_label"><script>w1('RATEKIND')</script></label>
<select name='f8' table='COMCOMB' key='880' onchange="cal6();" onblur='u_devide()'></select><br>

<label class="tab_page_label"><script>w1('CHPCODE')</script></label>
<input name='f9'  qtype="3314" master="glDay" master2="f211" slave="f10"  style="width:34px;" onpropertychange="changeValue0();changeView4()" value='<%= f31 %>'><input name='f9Lbl' style="width:274px;" readonly tabindex=-1 value='<%= f9Lbl %>'>
<label class="tab_page_label" style="margin-left:-10px;"><script>w1('BASERATECODE')</script></label>
<input name='f10' qtype="3305" master="glDay" master2="f9" master3="f211" style="width:34px;" onpropertychange="localQuery10()" value='<%= f32 %>'><input name='f10Lbl' style="width:274px;" readonly tabindex=-1 value='<%= f10Lbl %>'><br>

<label class="tab_page_label"><script>w1('CAPSELECTTERM')</script></label>
<input name='f11' style="width:34px;" qtype="8001" pop='no' f3ESC='Y' master="f211" master2="f9" master3="f10" master4="ichaMonth" master5="glDay" onpropertychange="searchrate1();" value='<%= f33 %>' maxlength="3">
<label class="tab_page_label" style="margin-left:264px;"><script>w1('FIXRATESPCTYP')</script></label>
<input name='f12' style='width:34px;' qtype="7001" pop='no' f3ESC='Y' master="f211" master2="f9" master3="f10" master4="ichaMonth" master5="glDay" onpropertychange="searchrate2();" value='<%= f34 %>'><br>

<label class="tab_page_label"><script>w1('NEXTCHPCODE')</script></label>
<input name='f13' style='width:34px;' qtype="3324" master="glDay" master2="f211" slave="f14" onpropertychange='searchrate3()' value='<%= f35 %>'><input name='f13Lbl' style='width:274px;' readonly tabindex='-1' value='<%= f451 %>'>
<label class="tab_page_label" style="margin-left:-10px;"><script>w1('NEXTBASERATECODE')</script></label>
<input name='f14' style='width:34px;' qtype="3305" master="glDay" master2="f13" master3="f211" onpropertychange='searchrate4()' value='<%= f36 %>'><input name='f14Lbl' style='width:274px;' readonly tabindex='-1' value='<%= f452 %>'><br>

<label class="tab_page_label"><script>w1('SPECCODE')</script></label>
<input name='f503' style='width:34px;' qtype="3427" master="f211" onpropertychange='searchrate5()' onblur='changeField7()' maxlength='2' value='<%= f503 %>'><input name='f503Lbl' style='width:274px;' readonly tabindex='-1' value='<%= f458 %>'>
<label class="tab_page_label" style="margin-left:-10px;"><script>w1('LIFEINSUAMT5')</script></label>
<input name='f504' style='width:134px;' value='<%= f504 %>'><br>

<input name='f15'  type='hidden' value='<%= f37 %>'>
<!--変動類型PLAN-->
<input name='f453' type='hidden' qtype="3307" f3ESC="Y" master="glDay" master2="f211" slave="f1454" ><input name='f453Lbl' type='hidden' value='<%= f455 %>'>
<!--基準利率PLAN-->
<input name='f454' type='hidden' qtype="3305" f3ESC="Y" master="glDay" master2="f453" master3="f211"><input name='f454Lbl' type='hidden' value='<%= f456 %>'><br><br>

<!-- prod code -->
<label class="tab_page_label"><script>w1('GRPRATEINFO')</script></label><br>
<label class="tab_page_label"><script>w1('PRIMERATE')</script></label>
<input name='f16'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding()" value='<%= f38 %>'><!--PRIME RATE-->
<label class="tab_page_label"><script>w1('PLUSRATE')</script></label>
<input name='f18'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();cal17();" value='<%= f40 %>'><!--An article addition rate-->
<label class="tab_page_label"><script>w1('MINUSRATE')</script></label>
<input name='f19'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();u_pattern2();" value='<%= f41 %>'><!--An article subtraction rate--><br>
<label class="tab_page_label"><script>w1('FSTGRADRATE')</script></label>
<input name='f20'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();cal17();" value='<%= f42 %>'><!--A first time stage interest rate-->
<label class="tab_page_label"><script>w1('FSTSPREADRATE')</script></label>
<input name='f21'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();cal17();" value='<%= f43 %>'><!--A first time SPREAD interest rate-->
<label class="tab_page_label"><script>w1('GRPRATE')</script></label>
<input name='f17'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();cal32();" value='<%= f39 %>'><!--An article rate--><br>
<label class="tab_page_label"><script>w1('CAP')</script></label>
<input name='f22'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();cal40();" value='<%= f44 %>'><!--A CAP rate-->
<label class="tab_page_label"><script>w1('FLOOR')</script></label>
<input name='f23'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding()" value='<%= f45 %>'><!--An FLOOR rate-->
<label class="tab_page_label"><script>w1('NEXTSPREADRATE')</script></label>
<input name='f24'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding()" value='<%= f46 %>'><!--A next SPREAD rate--><br>
<label class="tab_page_label"><script>w1('TERMRATE')</script></label>
<input name='f25'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();cal17();" value='<%= f47 %>'><!--A period interest rate-->
<label class="tab_page_label"><script>w1('CAPTERMSPREADRATE')</script></label>
<input name='f26'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();cal17();" value='<%= f48 %>'><!--CAP period SPREAD-->
<label class="tab_page_label"><script>w1('PRODFIXRATE')</script></label>
<input name='f438' style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();cal17();"><!--An article fixation rate--><br>
<label class="tab_page_label"><script>w1('CIFCAP')</script></label>
<input name='f441' style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();cal32()"><!--Customer CAP--><br><br>

<!--fix fee-->
<label class="tab_page_label"><script>w1('FIXRATE')</script></label>
<input name='f27' style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding()"><!--A decision interest rate-->
<label class="tab_page_label"><script>w1('INCRS')</script></label>
<input name='f28' style='width:84px;' onkeydown="allowFloat()" onKeyup="checkFloat()" onblur="u_autopadding()" onpropertychange="cal32();" value='<%= f50 %>'><!--An addition interest rate-->
<label class="tab_page_label"><script>w1('PDCRS')</script></label>
<input name='f29' style='width:84px;' onkeydown="allowFloat()" onKeyup="checkFloat()" onblur="u_autopadding()" onpropertychange="cal32()" value='<%= f51 %>'><!--A subtraction interest rate--><br>
<label class="tab_page_label"><script>w1('SUPPRATE')</script></label>
<input name='DEPRATE' style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding()" value='<%= f111 %>'><!--The interest supplying rate-->
<label class="tab_page_label"><script>w1('GUARRATE')</script></label>
<input name='f401' style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();cal40();cal32();" value='<%= f401 %>'><!--Guarantee rate-->
<label class="tab_page_label"><script>w1('CORPLIFERATE')</script></label>
<input name='f402' style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding()" value='<%= f402 %>'><!--A group life rate--><br>
<label class="tab_page_label"><script>w1('SPECADDRATE')</script></label>
<input name='f505' style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();cal40();cal32();" value='<%= f505 %>'>
<label class="tab_page_label"><script>w1('DEPRATE')</script></label>
<input name='f30'  style='width:84px;' readonly tabindex=-1 onkeydown='allowFloat()' onkeyup='checkFloat()' onblur='u_autopadding()' value='<%= f52 %>'><!--Deposit rates-->
<label class="tab_page_label"><script>w1('TRFMAGRATE')</script></label>
<input name='f33'  style='width:84px;' readonly tabindex=-1 onkeydown='allowFloat()' onkeyup='checkFloat()' onblur='u_autopadding()' value='<%= f55 %>'><!--An interlocking movement addition interest rate--><br>
<label class="tab_page_label"><script>w1('LONRATE')</script></label>
<input name='f506'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();" value='<%= f506 %>'>
<label class="tab_page_label" style="margin-left:217px;"><script>w1('CURTRATE')</script></label>
<input name='f32'  style='width:84px;' readonly tabindex=-1 onpropertychange="u_autopadding();" value='<%= f54 %>'><!--An application rate-->

<input type='hidden' name='specCd'>
<input type='hidden' name='appcAmt'>
<input type='hidden' name='f507' value='<%= f507 %>'>
</div>

<!-- 6th tab -------------------------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>

<label class="tab_page_label" style="margin-left:17px;"><script>w1('COALCODE')</script></label>
<input name='f408' qtype='3141' style='width:49px;' onpropertychange="label4();getDesc()" onblur="u_coalpadding()" value='<%= f408 %>'><input name='f408Lbl' style='width:204px;' readonly tabindex='-1' value='<%= f408Lbl %>'>
<label class="tab_page_label"><script>w1('INSTNO')</script></label>
<input name='f407' qtype='3142' master='glDay' master2='f408' style='width:49px;' onblur="u_padding()" onkeyup="clslabel()" value='<%= f407 %>'><input name='f407Lbl' style='width:204px;' readonly tabindex='-1' value='<%= f407Lbl %>'><br>
<label class="tab_page_label" style='margin-left:17px;'><script>w1('PRIPATTERN')</script></label>
<input name='f408_1' style='width:49px;' qtype='80' onpropertychange='u_pattern1()' value='<%= f500 %>'><input name='f408_1Lbl' style='width:204px;' readonly tabindex='-1' value='<%= f500Lbl %>'><br>
<input name='f407tmp' type='hidden'>
<label class="tab_page_label" style="width:fit-content; margin-left:5px;"><script>w1('PNTPRIVFLAG')</script></label>
<select name='f403' table="COMCOMB" key="4930" onpropertychange='changeValue2();' value='<%= f403 %>'></select>
<label class="tab_page_label" style="margin-left:197px;"><script>w1('PNTPRIVRATE')</script></label>
<input name='f31' style='width:84px;' onpropertychange="u_autopadding();changeValue4();" readonly tabindex='-1' value='<%= f53 %>'><br>

<label class="tab_page_label" style="width:fit-content; margin-left:5px;"><script>w1('CHPPRVFLAG')</script></label>
<select name='f404' table="COMCOMB" key="4930" onpropertychange="changeValue3()" value='<%= f404 %>'></select>
<label class="tab_page_label" style="margin-left:197px;"><script>w1('CHPPRVRATE')</script></label>
<input name='f439' style='width:84px;' onpropertychange='u_autopadding();changeValue4()' readonly tabindex='-1'><br>

<label class="tab_page_label" style="margin-left:17px;"><script>w1('MAXPRIVRATE')</script></label>
<input name='f406' style='width:84px;' onkeydown='allowFloat()' onkeyup='checkFloat()' onblur='u_autopadding();changeValue4();' value='<%= f406 %>'>
<label class="tab_page_label" style="margin-left:162px;"><script>w1('APLPRIVRATE')</script></label>
<input name='f440' style='width:84px;' onpropertychange='u_autopadding();cal32()' readonly tabindex='-1'><br><br>

<span style="overflow:auto; width:99%; height:300px; border:none">
<table border='0' cellspacing='1' cellpadding='2' bgcolor="black" style='font-size:9pt' width=100%>
	<tr bgcolor='darkgary' align='center'>
		<td class=xTitle nowrap colspan='2' height='20px'><script>w1('CHPCODE')</script></td>
		<td class=xTitle nowrap><script>w1('ONLY_TERM')</script></td>
		<td class=xTitle nowrap><script>w1('FRSTPRIVRATE')</script></td>
		<td class=xTitle nowrap><script>w1('AFTPRIVRATE')</script></td>
	</tr>
<%	for(int i=0 ; i<25; i++) {  %>
	<tr bgcolor='white' align='center'>
		<td width='3%'><input name='f428' class=xInput qtype='3729' onpropertychange= 'u_getDesc(this.value)' mask='01' readonly tabindex='-1'></td>
		<td width='27%'>&nbsp;&nbsp;<input name='f428Lbl' style='border:none;' readonly tabindex='-1'></td>
		<td width='10%'><input name=f429 class=xInput mask='01'  readonly tabindex='-1'></td>
		<td width='30%'><input name=f430 class=xInput onkeydown='allowFloat()' onkeyup='checkFloat();insertValue(document.all.f9.value)' iLen='2' fLen='5' onblur='u_autopadding();insertValue(document.all.f9.value)'></td>
		<td width='30%'><input name=f431 class=xInput onkeydown='allowFloat()' onkeyup='checkFloat()' iLen='2' fLen='5' onblur='u_autopadding()'></td>
	</tr>
<%	} %>
</table>
</span>
<input type='hidden' name='f427'>

<input type='hidden' name='f405' value='<%= f405 %>'><!--期間別優遇適用可否-->
<input type='hidden' name='f470' value='<%= f74 %>' ><!--ボーナス比率-->
<input type='hidden' name='f510' value='<%= f510 %>'><!--返済額指定型適用区分-->

<input type='hidden' name='dptCd'>
<input type='hidden' name='rateKind'>
<input type='hidden' name='baseRate'>
<input type='hidden' name='chpCode'>
<input type='hidden' name='prodCd'>
<input type='hidden' name='ichaMonth'>
<input type='hidden' name='guarCd'>
<input type='hidden' name='scheDate'>
<input type='hidden' name='guarComp'>
<input type='hidden' name='insumalerate'>

<input type='hidden' name='coopcompcode'>

<input type='hidden' name="glDay">
<input type='hidden' name='oldPROD'>
<input type='hidden' name='oldglDay'>
<input type='hidden' name='tmpglday'>

<input type='hidden' name="execday">
<input type='hidden' name='tmp1'>
<input type='hidden' name='tmp2'>

<input type='hidden' name='flagCOMP'>
<input type='hidden' name='flagLIFE'>
<input type='hidden' name='tmpflag' value='0'>
<input type='hidden' name='grp'>
<input type='hidden' name="printFLAG" value='0'>
<input type='hidden' name='f457' value= '<%=f457%>'>

<!--process.jsp LNPRATE Select-->
<input type='hidden' name='raterefercode' onpropertychange='localQuery4()'><!--RATE_REFER_CODE	金利参照断面区分-->


<!--process3.jsp LNPGRP Select localQuery3()-->
<input type='hidden' name='bonussameflag'><!--BONUS_SAME_FLAG	ボーナス併用可否-->
<input type='hidden' name='bonusper'><!--BONUS_PER	ボーナス比率-->
<input type='hidden' name='guarcompcode'><!--GUAR_COMP_CODE	保証会社コード-->
<input type='hidden' name='guarcompflag'><!--GUAR_COMP_FLAG	外部保証区分-->
<input type='hidden' name='grouplifecode'><!--GROUP_LIFE_CODE	団体生命コード-->
<input type='hidden' name='lifechrgkind'><!--LIFE_CHRG_KIND	団体生命負担区分-->
<input type='hidden' name='termappflag'><!--TERM_APP_FLAG	期間指定可否-->
<input type='hidden' name='dateappflag'><!--DATE_APP_FLAG	日付指定可否-->
<input type='hidden' name='grouplifeflag'><!--GROUP_LIFE_FLAG	団体生命加入区分-->


<!--process4.jsp LNPRATE Select-->
<input type='hidden' name='rateFlag'><!--RATE_KIND	段階金利適用区分-->
<input type='hidden' name='rateFlag2'>

<!--不使用-->
<input type='hidden' name='inoutFlag'>
<input type='hidden' name="f408_11" value='<%= f500 %>'>
<input type='hidden' name="f4071" value='<%= f407 %>'>
<input type='hidden' name='f437'>
</div>

<!-- 7th tab : LIMTREGINFO ------------------------------------------------------------------------>
<div id=tabPages class='TabPage padding_ver_20'>

<table border='0' cellspacing='1' cellpadding='0' bgcolor="black">
	<tr bgcolor='darkgary' align='center'>
		<td class=xTitle width='20px'  nowrap height='20px'>&nbsp&nbsp</td>
		<td class=xTitle width='110px' nowrap><script>w1('LIMITKIND')</script></td>
		<td class=xTitle width='90px'  nowrap><script>w1('GRPNAME')</script></td>
		<td class=xTitle width='60px'  nowrap><script>w1('STATUS')</script></td>
		<td class=xTitle width='120px' nowrap><script>w1('HOMEBRN')</script></td>
		<td class=xTitle width='80px'  nowrap><script>w1('OPNDATE')</script></td>
		<td class=xTitle width='80px'  nowrap><script>w1('MATUDATE2')</script></td>
		<td class=xTitle width='60px'  nowrap><script>w1('LIMTRATE')</script></td>
		<td class=xTitle width='110px' nowrap><script>w1('LIMTAMT2')</script></td>
		<td class=xTitle width='110px' nowrap><script>w1('LIMTBAL')</script></td>
		<td class=xTitle width='70px'  nowrap><script>w1('PROCACCTCNT')</script></td>
		<td class=xTitle width='80px'  nowrap><script>w1('PROCDAY')</script></td>
	</tr>
<%	if (nLoop7 == 0) {	%>
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
	</tr>
<%	} else {
		for (int i = 0; i < nLoop7; i++) { %>
	<tr bgcolor=white>
		<td align='center' height='20px' class=xTitle><%= i + 1 %></td>
		<td>&nbsp; <%= f131[i] %></td>
		<td align='center'><%= f132[i] %></td>
		<td align='center'><%= f133[i] %></td>
		<td>&nbsp; <%= f134[i] %></td>
		<td align='center'><%= f135[i] %></td>
		<td align='center'><%= f136[i] %></td>
		<td align='right'><%= f137[i] %>&nbsp;</td>
		<td align='right'><%= f138[i] %>&nbsp;</td>
		<td align='right'><%= f139[i] %>&nbsp;</td>
		<td align='right'><%= f140[i] %>&nbsp;</td>
		<td align='center'><%= f141[i] %></td>
	</tr>
<% 		}
	}
%>
</table>
</div>

<!-- 8th tab -------------------------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>

<label class="tab_page_label" style="margin-left:-25px;"><script>w1('CALAPPLRATE')</script></label>
<input name='f151' style='width:84px;' onblur='u_autopadding()'>%<br><input name='old151' type='hidden' value='<%= f151 %>'>

<span style="overflow:auto; width:99%; height:400px; border:none;">
<table border='0' cellspacing='1' cellpadding='2' bgcolor="black" width='100%' style='font-size:9pt'>
	<tr bgcolor='darkgary' align='center'>
	    <td class=xTitle nowrap width='3%' height='20px'><script>w1('SEQNO')</script></td>
		<td class=xTitle nowrap width='25%'><script>w1('REPAYCNTFROM')</script></td>
		<td class=xTitle nowrap width='25%'><script>w1('REPAYCNTTO')</script></td>
		<td class=xTitle nowrap width='47%'><script>w1('REPAYAMT2')</script></td>
	</tr>
<% for (int i=0; i<60; i++) { %>
	<tr bgcolor=white align='center'>
		<td class=xTitle height='20'><%= i+1 %></td>
        <td id="td152"><input name='d153' class=xInput style='text-align:right;' value='<%= (i < nLoop8) ? f155[i]:"" %>' readonly tabindex='-1'></td>
        <td id="td153"><input name='f153' class=xInput style='text-align:right;' value='<%= (i < nLoop8) ? f153[i]:"" %>' onkeydown='allowCodeNumber()' onblur='u_compare1()' onFocus='u_focus();u_nextNum()' maxlength='3'>
                       <input name='old_f153' class=xInput type='hidden' value='<%= (i < nLoop8) ? f153[i]:"" %>'></td>
        <td id="td154"><input name='f154' class=xInput style='width:174px;text-align:right' value='<%= (i < nLoop8) ? f154[i]:"" %>' onkeydown='allowNumber()' onkeyup='fCurrency2()' onblur='u_compare2()' onFocus='u_focus()' iLen=15 fLen=0 mask='02'></td>
	</tr>
<%  } %>
</table>
</span><br>
<input type='hidden' name='f152' value='<%= f152 %>'>
</div>

<!---みなし利息-->
<!-- 9th tab ------------------------------------------------------------------------------------->
<div id=tabPages class='TabPage padding_ver_20'>

<!-- 事務取扱手数料 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('OFFICETXFEE')</script></label>
<input name='f601' style='width:154px;text-align:right' onpropertychange='u_moveValue()' onblur="u_autoPadding()" value='<%= f601 %>'><br>  <!--  20160331---------->
<!-- 印紙代 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('STAMPTAX')</script></label>
<input name='f602' style='width:154px;text-align:right' onpropertychange='u_moveValue()'  onblur="u_autoPadding()"  value='<%= f602 %>'><br>  <!--  20160331---------->
<!-- 公証費用 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('KJFEE')</script></label>
<input name='f603' style='width:154px;text-align:right' onpropertychange='u_moveValue()'  onblur="u_autoPadding()" value='<%= f603 %>'><br>  <!--  20160331---------->
<!-- 火災保険料 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('INSUFEE')</script></label>
<input name='f604' style='width:154px;text-align:right' onpropertychange='u_moveValue()'  onblur="u_autoPadding()" value='<%= f604 %>'><br>  <!--  20160331---------->
<!-- 担保調査費用 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('OUTCOLLRESFEE')</script></label>
<input name='f605' style='width:154px;text-align:right' onpropertychange='u_moveValue()'  onblur="u_autoPadding()" value='<%= f605 %>'><br>   <!--  20160331---------->
<!-- 確定日付料 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('FIXDATEFEE')</script></label>
<input name='f606' style='width:154px;text-align:right' onpropertychange='u_moveValue()'  onblur="u_autoPadding()" value='<%= f606 %>'><br>    <!--  20160331---------->
<!-- 登記費用 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('DKFEE')</script></label>
<input name='f607' style='width:154px;text-align:right' onpropertychange='u_moveValue()'   onblur="u_autoPadding()" value='<%= f607 %>'><br>    <!--  20160331---------->
<!-- 差引後顧客口座入金金額 -->
<label class="tab_page_label" style='width:fit-content; margin-left:8px;'><script>w1('NETDEPTOTAMT')</script></label>
<input name='f608' style='width:154px;text-align:right' readonly tabindex='-1' >   <!--  20160331---------->

</div>

<iframe name=popup width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup2 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup3 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup4 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup6 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup7 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup10 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup8 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup9 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup11 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup12 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup13 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup15 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup16 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup17 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup18 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup19 width=0 height=0 style="border:0;">
</iframe>
<iframe name=popup20 width=0 height=0 style="border:0;">
</iframe>