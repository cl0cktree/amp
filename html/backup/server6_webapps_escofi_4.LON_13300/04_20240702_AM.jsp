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
	return sData.substring (0, 2) + "-" + sData.substring (2, 4) + "-" + sData.substring (4, 7) + "-" + sData.substring (7, 11);
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
String f49 = "";
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
String f439 = "";
String f440 = "";
String f444_1 = "";
String f444_2 = "";
String f444_3 = "";
String f444_4 = "";
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

// 2013.3.16 実行代わり金振込処理対応 本多 START
String f444 = "";
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

/* 9th tab */
String f601 = "";
String f602 = "";
String f603 = "";
String f604 = "";
String f605 = "";
String f606 = "";
String f607 = "";
String f608 = "";

int outCnt6 = 0;    //6th tab grid output count
int nLoop6  = 0;    //6th tab grid count
int nLoop7  = 0;	//7th tab grid count
int nLoop8  = 0;    //8th tab grid count

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

/* 20200331 EK Edit Start 3rd tab */
String f461 = "";
/* 20200331 EK Edit End 3rd tab */

	byte [] rcvMsg = null;
	String strOutMessage = null;
/* 20160706
	if ((String) application.getAttribute(request.getRemoteAddr()) != null)
	{
		strOutMessage = (String) application.getAttribute(request.getRemoteAddr());
		application.removeAttribute(request.getRemoteAddr());
	}
*/
        String resultid = request.getParameter("RESULTID");
 System.out.println("[13300_04]resultid:" + resultid );
        if ( resultid != null ){
          strOutMessage = (String) application.getAttribute(resultid);
          if( strOutMessage!=null ) application.removeAttribute(resultid);
        }

	if ( strOutMessage != null ) {
		rcvMsg = strOutMessage.getBytes ("MS932");
	}
	//==============================================================================//
	// 2013.3.16 実行代わり金振込処理対応（ディレクトリパス修正）START
	//String xmlFile = request.getSession().getServletContext().getRealPath("/codeXml/4.LON/13300_03out.xml");
	String xmlFile = request.getSession().getServletContext().getRealPath("/codeXml/4.LON/13300_03out.xml");
	// 2013.3.16 実行代わり金振込処理対応（ディレクトリパス修正）END
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
/*
int ilen = xp.xpd.node_value.length;
for(int i=0; i<ilen; i++){
	out.println("["+i+"]-->["+xp.xpd.node_value[i]+"]<BR>");
}
*/
				/* LOANCNAPINFO */
				
				f4_1 = xp.xpd.node_value[8].trim();				// 相談番号
				f4_2 = xp.xpd.node_value[9].trim();
				f4_3 = xp.xpd.node_value[10].trim();
				f4_4 = xp.xpd.node_value[11].trim();
				f4_5 = xp.xpd.node_value[12].trim();

				f6   = makemask7("17.2",xp.xpd.node_value[14],xp.oheader.node_value[35]); //20160331 fx add 承認申請金額 

				f7 = xp.xpd.node_value[16].trim();				// 貸出状態
				f9_1 = xp.xpd.node_value[18].trim();			// 顧客番号
				f9_2 = xp.xpd.node_value[19].trim();
				f9_3 = xp.xpd.node_value[20].trim();
				f10 = xp.xpd.node_value[21].trim();				// 顧客名
				f11 = xp.xpd.node_value[22].trim();				// 産業分類
				f12 = xp.xpd.node_value[23].trim();				// 企業体規模名
				f13 = xp.xpd.node_value[24].trim();				// 商品コード
				f14 = xp.xpd.node_value[25].trim();				// 商品名
				f15 = xp.xpd.node_value[26];					// 資金使途コ－ド
				f501 = xp.xpd.node_value[27].trim();			// 資金使途コ－ド
				f16 = xp.xpd.node_value[28];					// 相談種類
				f17 = xp.xpd.node_value[29];					// 極度種類
				f18 = xp.xpd.node_value[30];					// 担保種類
				f19 = ZeroCheck(xp.xpd.node_value[31]);			// 保証種類
				f20 = xp.xpd.node_value[32];					// 手形手続種類
				f21_1 = xp.xpd.node_value[33].trim();			// 手形貸付関連口座
				f21_2 = xp.xpd.node_value[34].trim();
				f21_3 = xp.xpd.node_value[35].trim();
				f21_4 = xp.xpd.node_value[36].trim();
				f21_5 = xp.xpd.node_value[37].trim();
				f22 = ZeroCheck(xp.xpd.node_value[38]);			// 団体生命コード
				f502 = xp.xpd.node_value[39].trim();			// 団体生命コード
				f23 = ZeroCheck(xp.xpd.node_value[40]);			// 被保険者人数
				f24 = xp.xpd.node_value[41];					// 団体生命契約区分
				f25 = xp.xpd.node_value[42];					// 団体生命保険番号

				/* LOANCNAPINFO */
				f26 = xp.xpd.node_value[44].trim();				// 勧誘者行員番号
				f27 = xp.xpd.node_value[45].trim();				// 管理者
				f28 = xp.xpd.node_value[46];					// 取引区分
				f29 = xp.xpd.node_value[47];					// 限度区分

				f30 = xp.xpd.node_value[49];					// 利率区分
				f31 = ZeroCheck(xp.xpd.node_value[50]);			// 変動類型コード
				f32 = ZeroCheck(xp.xpd.node_value[51]);			// 基準利率コード
				f33 = ZeroTrim(xp.xpd.node_value[52]);			// CAP 特約期間
				f34 = ZeroTrim(xp.xpd.node_value[53]);			// 固定金利期間
				f35 = ZeroCheck(xp.xpd.node_value[54]);			// 次期変動類型コード
				f36 = ZeroCheck(xp.xpd.node_value[55]);			// 次期基準利率コード
				f37 = ZeroCheck(xp.xpd.node_value[56]);			// 次期特約期間
				f39 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[57]);		// 商品利率
				f38 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[58]);		// プライムレート
				f40 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[59]);		// 商品加算利率
				f41 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[60]);		// 商品減算利率
				f42 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[61]);		// 初回段階金利
				f43 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[62]);		// 初回SPREAD金利
				f44 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[63]);		// CAP利率
				f45 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[64]);		// FLOOR利率
				f46 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[65]);		// 次期SPREAD利率
				f47 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[66]);		// 期間金利
				f48 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[67]);		// CAP期間SPREAD
				f49 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[68]);		// 確定金利
				f52 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[69]);		// 預金金利
				f55 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[70]);		// 連動加算金利
				f50 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[71]);		// 加算金利
				f51 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[72]);		// 減免金利
				f53 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[73]);		// 顧客優遇金利
				f54 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[74]);		// 適用利率

				f56 = xp.xpd.node_value[76];					// 期日区分
				f57_1 = xp.xpd.node_value[77].trim();			// 返済日付
				f57_2 = xp.xpd.node_value[78].trim();			// 返済日付
				f57_3 = xp.xpd.node_value[79].trim();			// 返済日付
				f58 = ZeroTrim(xp.xpd.node_value[80]);			// 返済月数
				f59 = xp.xpd.node_value[81];					// dummy
				f60 = xp.xpd.node_value[82];					// 据置区分
				f61_1 = xp.xpd.node_value[83].trim();			// 据置期日
				f61_2 = xp.xpd.node_value[84].trim();			// 据置期日
				f61_3 = xp.xpd.node_value[85].trim();			// 据置期日
				f62 = ZeroTrim(xp.xpd.node_value[86]);			// 据置月数
				f63 = xp.xpd.node_value[87];					// Dummy
				f64 = xp.xpd.node_value[88].trim();				// 返済開始日

				f66 = xp.xpd.node_value[90];					// 振込猶予区分
				f67 = ZeroTrim(xp.xpd.node_value[91]);			// 返済方式コ－ド
				f68 = xp.xpd.node_value[92];					// 元金返済方式
				f69 = xp.xpd.node_value[93];					// 利息返済方式
				f70 = xp.xpd.node_value[94];					// 元金返済周期
				f71 = xp.xpd.node_value[95];					// 利息返済周期
				f460= xp.xpd.node_value[96];					// 返済方式種類
				
				//20240220 期限一括対応//
				if (Integer.parseInt(f30) != 0 ) {
					if ( (Integer.parseInt(f64) > 28) && (Integer.parseInt(f64) <= 31) && (Integer.parseInt(f68) != 1) &&Integer.parseInt(f69) != 1) {
						f64 = "32";
					}
				} else f64 = "";
				
            //  f72
			//  f73
				f74 = xp.xpd.node_value[99];					// ボーナス比率

				f75   = makemask7("17.2",xp.xpd.node_value[100],xp.oheader.node_value[35]);	// ボーナス返済金額 	//20160331 fx add

				f76 = xp.xpd.node_value[101];					// ボーナス月
				f77 = xp.xpd.node_value[102];					// ボーナス月
			//  f78
				f79 = CutZeroMoney(xp.xpd.node_value[104]);		// 毎回分割金
				f80 = CutZeroMoney(xp.xpd.node_value[105]);		// ボーナス毎回分割金
				f150= xp.xpd.node_value[106];					// 分割金適用期間
				f81 = xp.xpd.node_value[107].trim();			// 返済資源
				f82 = xp.xpd.node_value[108].trim();			// 返済方式
				f83 = xp.xpd.node_value[109].trim();			// 期待効果
				f84 = xp.xpd.node_value[110].trim();			// 実行予定日
				f85 = xp.xpd.node_value[111].trim();			// 分割実行予定回数
				f86_1 = xp.xpd.node_value[112].trim();			// 分割実行予定日付
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

//201604291 fx add 承認申請金額 
				f421 = makemask7("17.2",xp.xpd.node_value[127],xp.oheader.node_value[35]); // 分割実行金額
				f422 = makemask7("17.2",xp.xpd.node_value[128],xp.oheader.node_value[35]); 
				f423 = makemask7("17.2",xp.xpd.node_value[129],xp.oheader.node_value[35]); 
				f424 = makemask7("17.2",xp.xpd.node_value[130],xp.oheader.node_value[35]); 
				f425 = makemask7("17.2",xp.xpd.node_value[131],xp.oheader.node_value[35]); 

				f96 = xp.xpd.node_value[132];										// 保証協会種類コ－ド
				f97 = xp.xpd.node_value[133].trim();								// 保証会社コード

				/* BONDPROPERTYINFO */
				f98 = xp.xpd.node_value[135];										// 債務者区分
				f99 = xp.xpd.node_value[136];										// 分類区分
				f101 = xp.xpd.node_value[137];										// 信用格付
				f102 = xp.xpd.node_value[138];										// 取組方針
				f106 = xp.xpd.node_value[143].trim();								// 摘要
				f107 = xp.xpd.node_value[144].trim();
				f108 = xp.xpd.node_value[145].trim();
				f109 = xp.xpd.node_value[146].trim();
			//  f110
				f111 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[148]);		// 利息補給率
				f510 = xp.xpd.node_value[149];										// 返済額指定型適用区分
				f435 = xp.xpd.node_value[150].trim();								// 関連相談番号
				f436 = CutZeroMoney(xp.xpd.node_value[151]);						// 総貸出額
				f426 = ZeroCheck(xp.xpd.node_value[152]);							// 保証料徴求区分
				f426Lbl =xp.xpd.node_value[153];									// 保証料徴求区分名
				f401 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[154]);		// 保証料率
				f402 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[155]);		// 団体生命利率
				f403 = xp.xpd.node_value[156];										// ポイント別優遇適用可否
				f404 = xp.xpd.node_value[157];										// 変動類型別優遇適用可否
				f405 = xp.xpd.node_value[158];										// 期間別優遇適用可否
				f406 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[159]);		// 最大優遇幅
				f407 = ZeroCheck(xp.xpd.node_value[160]);							// 制度番号
				f407Lbl = xp.xpd.node_value[161].trim();							// 制度番号名
				f408 = ZeroCheck(xp.xpd.node_value[162]);							// 提携先コード
				f408Lbl = xp.xpd.node_value[163].trim();							// 提携先コード名
				f500 = ZeroCheck(xp.xpd.node_value[164]);							// 優遇幅パターン
				f409 = xp.xpd.node_value[166].trim();								// 承認申請担当者
				f410 = CutZeroMoney(xp.xpd.node_value[167]);						// 第1団信当初適用額
				f411 = CutZeroMoney(xp.xpd.node_value[168]);						// 第2団信当初適用額
				f412 = xp.xpd.node_value[169];										// 債務者区分
				f413_1 = xp.xpd.node_value[170].trim();								// 連帯債務者顧客番号１
				f413_2 = xp.xpd.node_value[171].trim();
				f413_3 = xp.xpd.node_value[172].trim();
				f413 = xp.xpd.node_value[173].trim();								// 連帯債務者名１
				f414 = XmlUtil.checkValue("02","3",xp.xpd.node_value[174]);			// 債務比率１
				f415_1 = xp.xpd.node_value[175].trim();								// 連帯債務者顧客番号２
				f415_2 = xp.xpd.node_value[176].trim();
				f415_3 = xp.xpd.node_value[177].trim();
				f415 = xp.xpd.node_value[178].trim();								// 連帯債務者名２
				f416 = XmlUtil.checkValue("02","3",xp.xpd.node_value[179]);			// 債務比率２
				f417_1 = xp.xpd.node_value[180].trim();								// 連帯債務者顧客番号３
				f417_2 = xp.xpd.node_value[181].trim();
				f417_3 = xp.xpd.node_value[182].trim();
				f417 = xp.xpd.node_value[183].trim();								// 連帯債務者名３
				f418 = XmlUtil.checkValue("02","3",xp.xpd.node_value[184]);			// 債務比率３
				f419_1 = xp.xpd.node_value[185].trim();								// 連帯債務者顧客番号４
				f419_2 = xp.xpd.node_value[186].trim();
				f419_3 = xp.xpd.node_value[187].trim();
				f419 = xp.xpd.node_value[188].trim();								// 連帯債務者名４
				f420 = XmlUtil.checkValue("02","3",xp.xpd.node_value[189]);			// 債務比率４
				f438 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[190]);		// 商品固定利率
				f439 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[191]);		// 変動類型優遇金利
				f440 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[192]);		// 適用優遇金利
				f441 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[193]);		// 顧客CAP
				f442 = xp.xpd.node_value[194].trim();								// コード名
				f443 = xp.xpd.node_value[195].trim();								// コード名1
				f448 = xp.xpd.node_value[196].trim();								// 返済方式コード
				f449 = xp.xpd.node_value[197].trim();								// 元金返済周期名
				f450 = xp.xpd.node_value[198].trim();								// 利息返済周期名
				f451 = xp.xpd.node_value[199].trim();								// 次期変動類型コード
				f452 = xp.xpd.node_value[200].trim();								// 次期基準利率コード
				f455 = xp.xpd.node_value[201].trim();								// 変動類型PLAN
				f456 = xp.xpd.node_value[202].trim();								// 基準利率PLAN
				
				// 2013.3.16 実行代わり金振込処理対応（電文変更） START
				//f444_1 = xp.xpd.node_value[203].trim();
				//f444_2 = xp.xpd.node_value[204].trim();
				//f444_3 = xp.xpd.node_value[205].trim();
				//f444_4 = xp.xpd.node_value[206].trim();
				f444 = xp.xpd.node_value[203].trim();								// ダミー
				f444_1 = xp.xpd.node_value[204].trim();								// 銀行
				f444_2 = xp.xpd.node_value[205].trim();								// 支店
				f444_3 = xp.xpd.node_value[206].trim();								// 種別
				f444_4 = xp.xpd.node_value[207].trim();								// 口座番号
				f508 = xp.xpd.node_value[208].trim();								// ダミー
				f508_1 = xp.xpd.node_value[209].trim();								// 銀行
				f508_2 = xp.xpd.node_value[210].trim();								// 支店
				f508_3 = xp.xpd.node_value[211].trim();								// 種別
				f508_4 = xp.xpd.node_value[212].trim();								// 口座番号
				f509 = xp.xpd.node_value[213].trim();								// 口座名義
				
				f445_1 = xp.xpd.node_value[214].trim();								// 引落口座 CIF
				f445_2 = xp.xpd.node_value[215].trim();								// 引落口座 CIF
				f446 = xp.xpd.node_value[216];										// 手数料パターン(繰上げ完済)
				f447 = xp.xpd.node_value[217];										// 手数料パターン(臨時返済)
				f453 = xp.xpd.node_value[218];										// 変動類型PLAN
				f454 = xp.xpd.node_value[219];										// 実行予定日
			//  f457
				f503 = CutZero(xp.xpd.node_value[221]);								// 特約保障コード
				f504 = CutZeroMoney(xp.xpd.node_value[222]);						// 第3団信当初適用額
				f505 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[223]);		// 特約加算利率
				f458 = xp.xpd.node_value[224];										// 特約保障コード名
				f506 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[225]);		// 貸越利率
				f507 = xp.xpd.node_value[226];										// 大科目コード

				//20160321 fx add 
				f601   = makemask7("17.2",xp.xpd.node_value[227],xp.oheader.node_value[35]);
				f602   = makemask7("17.2",xp.xpd.node_value[228],xp.oheader.node_value[35]);
				f603   = makemask7("17.2",xp.xpd.node_value[229],xp.oheader.node_value[35]);
				f604   = makemask7("17.2",xp.xpd.node_value[230],xp.oheader.node_value[35]);
				f605   = makemask7("17.2",xp.xpd.node_value[231],xp.oheader.node_value[35]);
				f606   = makemask7("17.2",xp.xpd.node_value[232],xp.oheader.node_value[35]);				
				f607 =   makemask7("17.2",xp.xpd.node_value[233],xp.oheader.node_value[35]);	

                f461 = xp.xpd.node_value[234].trim(); // 200331 EK Edit                 引落名義

				//int ngrid6 = 230;	//f434
				//int ngrid6 = 229;	//f434
				int ngrid6 = 229+8;	//f434
				// 2013.3.16 実行代わり金振込処理対応（電文変更） END
				
    			String f427 =  xp.xpd.node_value[ngrid6];
				nLoop6 = Integer.parseInt(f427);
				f428 = new String [nLoop6];											// 変動類型コード
				f429 = new String [nLoop6];											// 期間
				f430 = new String [nLoop6];											// 当初優遇幅
				f431 = new String [nLoop6];											// 期間経過後優遇幅

				int nCunt6 = ngrid6 + 1;
				for (int i = 0; i < nLoop6; i++) {
					f428[i] = xp.xpd.node_value[nCunt6++];
					f429[i] = ZeroTrim(xp.xpd.node_value[nCunt6++]);
					f430[i] = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[nCunt6++]);
					f431[i] = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[nCunt6++]);
					if(Integer.parseInt(f428[i]) > 0) outCnt6++;
				}
                //f428~f431 => 221~320

				/* LIMTREGINFO */
				int ngrid7 = ngrid6 + 104;   //f130
				String f130 = xp.xpd.node_value[ngrid7];
				nLoop7 = Integer.parseInt(f130);
				f131 = new String [nLoop7];											// 極度種類
				f132 = new String [nLoop7];											// 科目名
				f133 = new String [nLoop7];											// 状態
				f134 = new String [nLoop7];											// 取扱店
				f135 = new String [nLoop7];											// 新規取扱日
				f136 = new String [nLoop7];											// 満期日
				f137 = new String [nLoop7];											// 極度利率
				f138 = new String [nLoop7];											// 極度限度金額
				f139 = new String [nLoop7];											// 極度残高
				f140 = new String [nLoop7];											// 処理口座数
				f141 = new String [nLoop7];											// 処理日付
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
                f151 = XmlUtil.checkValue("03","7.5",xp.xpd.node_value[ngrid8 + 1]);	// 計算用適用利率
                f152 = xp.xpd.node_value[ngrid8 + 2];									// 返済額情報テーブル数
				nLoop8 = Integer.parseInt(f152);
				f155 = new String [nLoop8];												// 不均等回次(FROM)
				f153 = new String [nLoop8];												// 不均等回次(TO)
				f154 = new String [nLoop8];												// 不均等返済額

				int nCunt8 = ngrid8 + 3 ;
				for (int i=0; i<nLoop8; i++) {
					f155[i] = CutZero(xp.xpd.node_value[nCunt8++]);
					f153[i] = CutZero(xp.xpd.node_value[nCunt8++]);
			     	f154[i] = CutZeroMoney(xp.xpd.node_value[nCunt8++]);
    			}

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
<script>var trInXml = loadXML('/codeXml/4.LON/13300_04in.xml')</script>
<script>var trOutXml = loadXML('/codeXml/4.LON/13300_04out.xml')</script>
<script>
	function initPage() {
		setMsg("");
		tabItemSelect(2); //tab page setting

		//CNSLNO
		restore("f1_1","f1_1");
		restore("f1_2","f1_2");
		restore("f1_3","f1_3");
		restore("f1_4","f1_4");
		restore("f1_5","f1_5");
		restore("f2","f2");

		document.all.f6.value = '<%=f28%>';
		document.all.f6.value = (parseInt(document.all.f6.value,10) == 0)? "":padNumber(document.all.f6.value,2);
		document.all.f213.value = (parseInt(document.all.f213.value,10) == 0)? "":padNumber(document.all.f213.value,4);

		if(document.all.f35_3.value != "")
			document.all.d35.value = document.all.f35_1.value + "-" + document.all.f35_2.value + "-" + document.all.f35_3.value;
		if(document.all.f39_3.value != "")
			document.all.d39.value = document.all.f39_1.value + "-" + document.all.f39_2.value + "-" + document.all.f39_3.value;

		document.all.f58_1.value = '<%=f84%>'.substr(0,4);
		document.all.f58_2.value = '<%=f84%>'.substr(4,2);
		document.all.f58_3.value = '<%=f84%>'.substr(6,2);
		document.all.f58_4.value = document.all.f58_1.value + "-" + document.all.f58_2.value + "-" + document.all.f58_3.value;

		if('<%=f412%>' == 2){
			var f414 = 0;
			var f416 = 0;
			var f418 = 0;
			var f420 = 0;

			if(document.all.f414.value != "")
				f414 = parseInt(document.all.f414.value,10);
			if(document.all.f416.value != "")
				f416 = parseInt(document.all.f416.value,10);
			if(document.all.f418.value != "")
				f418 = parseInt(document.all.f418.value,10);
			if(document.all.f420.value != "")
				f420 = parseInt(document.all.f420.value,10);

			document.all.p906.value = 100 - (f414 + f416 + f418 + f420);
		}

		if('<%=f413%>' == "") { document.all.f413.value = ""; }
		else { document.all.f413.value = '<%=f413%>'; }

		if('<%=f415%>' == "") { document.all.f415.value = ""; }
		else { document.all.f415.value = '<%=f415%>'; }

		if('<%=f417%>' == "") { document.all.f417.value = ""; }
		else { document.all.f417.value = '<%=f417%>'; }

		if('<%=f419%>' == "") { document.all.f419.value = ""; }
		else { document.all.f419.value = '<%=f419%>'; }

		document.all.f220.value = (document.all.f220.value == 0)? "":document.all.f220.value;
		document.all.f223.value =(document.all.f223.value == 0)? "":padNumber(document.all.f223.value,4);
		document.all.f224.value = (document.all.f224.value == 0)? "":document.all.f224.value;
		document.all.f296.value = (document.all.f296.value == 0)? "":padNumber(document.all.f296.value,4);
		document.all.f297.value = (document.all.f297.value == 0)? "":document.all.f297.value;
		document.all.f36.value = (document.all.f36.value == 0)? "":document.all.f36.value;
		document.all.f40.value = (document.all.f40.value == 0)? "":document.all.f40.value;
		document.all.f44.value = (document.all.f44.value == 0)? "":document.all.f44.value;
		document.all.f47.value = (document.all.f47.value == 0)? "":document.all.f47.value;
		document.all.f48.value = (document.all.f48.value == 0)? "":document.all.f48.value;
		document.all.f426.value = (document.all.f426.value == 0)? "":document.all.f426.value;

		document.all.f11.value = (document.all.f11.value == 0)? "":document.all.f11.value;
		document.all.f12.value = (document.all.f12.value == 0)? "":document.all.f12.value;
		document.all.f13.value = (document.all.f13.value == 0)? "":document.all.f13.value;
		document.all.f14.value = (document.all.f14.value == 0)? "":document.all.f14.value;

		document.all.f51.value = (document.all.f51.value == 0)? "":document.all.f51.value;
		document.all.f52.value = (document.all.f52.value == 0)? "":document.all.f52.value;
		document.all.f150.value = (document.all.f150.value == 0)? "":document.all.f150.value;

		document.all.f407.value = (document.all.f407.value == 0)? "":padNumber(document.all.f407.value,5);
		document.all.f408_1.value = (document.all.f408_1.value == 0)? "":padNumber(document.all.f408_1.value,3);

		document.all.f414.value = (document.all.f414.value == 0)? "":document.all.f414.value;
		document.all.f416.value = (document.all.f416.value == 0)? "":document.all.f416.value;
		document.all.f418.value = (document.all.f418.value == 0)? "":document.all.f418.value;
		document.all.f420.value = (document.all.f420.value == 0)? "":document.all.f420.value;

		document.all.f421.value = (document.all.f421.value == '0')? "":document.all.f421.value;
		document.all.f422.value = (document.all.f422.value == '0')? "":document.all.f422.value;
		document.all.f423.value = (document.all.f423.value == '0')? "":document.all.f423.value;
		document.all.f424.value = (document.all.f424.value == '0')? "":document.all.f424.value;
		document.all.f425.value = (document.all.f425.value == '0')? "":document.all.f425.value;

		document.all.f435.value = document.all.f435.value.formatCounsel();

		document.all.f210.value = (document.all.f210.value == '0')? "":document.all.f210.value;
		document.all.f4.value = (document.all.f4.value == '0')? "":document.all.f4.value;
		document.all.f5.value = (document.all.f5.value == '0')? "":document.all.f5.value;
		document.all.f409.value = (document.all.f409.value == '0')? "":document.all.f409.value;

		document.all.f50.value = (document.all.f50.value.length > 0)? document.all.f50.value  : "";
		document.all.f408.value = (document.all.f408.value == '0')? "":document.all.f408.value;
		document.all.f225.value = (document.all.f225.value == 'y')? "1":"0";

		for (i = 0; i < document.all.f404.options.length; i++) {
			if (document.all.f404.options[i].value == '<%= XmlUtil.nNullCheck(f404) %>')
				document.all.f404.options[i].selected = true;
			else document.all.f404.options[i].selected = false;
		}
		for (i = 0; i < document.all.f403.options.length; i++) {
			if (document.all.f403.options[i].value == '<%= XmlUtil.nNullCheck(f403) %>')
				document.all.f403.options[i].selected = true;
			else document.all.f403.options[i].selected = false;
		}
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
		for (i = 0; i < document.all.f47.options.length; i++) {
			if (document.all.f47.options[i].value == '<%= XmlUtil.nNullCheck(f70) %>')
				document.all.f47.options[i].selected = true;
			else document.all.f47.options[i].selected = false;
		}
		for (i = 0; i < document.all.f48.options.length; i++) {
			if (document.all.f48.options[i].value == '<%= XmlUtil.nNullCheck(f71) %>')
				document.all.f48.options[i].selected = true;
			else document.all.f48.options[i].selected = false;
		}
		for (i = 0; i < document.all.f8.options.length; i++) {
			if (document.all.f8.options[i].value == '<%= XmlUtil.nNullCheck(f30) %>')
				document.all.f8.options[i].selected = true;
			else document.all.f8.options[i].selected = false;
		}
		for (i = 0; i < document.all.f9.options.length; i++) {
			if (document.all.f9.options[i].value == '<%= XmlUtil.nNullCheck(f31) %>')
				document.all.f9.options[i].selected = true;
			else document.all.f9.options[i].selected = false;
		}
		for (i = 0; i < document.all.f10.options.length; i++) {
			if (document.all.f10.options[i].value == '<%= XmlUtil.nNullCheck(f32) %>')
				document.all.f10.options[i].selected = true;
			else document.all.f10.options[i].selected = false;
		}
		for (i = 0; i < document.all.f13.options.length; i++) {
			if (document.all.f13.options[i].value == '<%= XmlUtil.nNullCheck(f35) %>')
				document.all.f13.options[i].selected = true;
			else document.all.f13.options[i].selected = false;
		}
		for (i = 0; i < document.all.f14.options.length; i++) {
			if (document.all.f14.options[i].value == '<%= XmlUtil.nNullCheck(f36) %>')
				document.all.f14.options[i].selected = true;
			else document.all.f14.options[i].selected = false;
		}
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
		document.all.f225.disabled = true;
		document.all.f427.value = <%= outCnt6 %>;
		
		
		// 2013.3.16 実行代わり金振込処理対応（口座種別） START
		document.all.f444_3Lbl.value=searchF3(document.all.f444_3);
		document.all.f508_3Lbl.value=searchF3(document.all.f508_3);
		// 2013.3.16 実行代わり金振込処理対応（口座種別） END

		//20160321 fx add start
		var currcode = 	getOHeader("NATIONAL_CODE");
		document.all.f100.value = currcode;

		show2('<%=f412%>');
		setMsg("200007");
		enableAllBtn();
		enableExecBtn();
	}
	function checkPage(fieldArray){
		dataForm.target = "hiddenFrame";
		dataForm.action = top.CONTEXT+"/WebFacade";

		return showConfirm("200001");
		setMsg("000253");
	}
	function flow() {
		setMsg("200006");
	}

	function u_getGuarType(code) {
		var code_1 = code.substr(0,1);
		var code_5 = code.substr(1,3);

		node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='22' "+
							" and @CODE_1 = '"+code_1+"' "+
							" and @CODE_5 = '"+code_5+"' "+
							" and (@STA=1 or @STA=2) "+
							" and @CODE_2 = 0 "+
							" and @CODE_3 = 0 "+
							" and @CODE_4 = 0 "+
							" and @CODE_5 != 0]");

		document.all.f220Lbl.value = (node)? node.getAttribute("CODE_NAME"):"";
	}
	function parse(src){
		return (src == '')? '0':parseFloat(src);
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
	function show(){
		if(event.propertyName != "value")return;
		if(event.srcElement.value == 3){
			document.all.d.style.display = "block";

		}else{
			document.all.d.style.display = "none";
		}
	}
	function show2(gubun){
		if(gubun == 2){
				document.all.d2.style.display = "block";
				document.all.p906.value = "";
				u_joinChange('p906','f414','f416','f418','f420','f412')
		}else{
				document.all.d2.style.display = "none";
				document.all.p906.value = "100";
		}
	}
	function doBeforeParseOut(){
		parseOutMessage();
		var ttt = top.hiddenFrame.resultString.substring(300,306);
		alertError(ttt);
	}
	function u_autopadding(){
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
	}
	
	// 2013.3.16 実行代わり金振込処理対応 START
	/* 
	* 銀行名称取得（引落口座）
	*/
	function getBankName1(){
		document.all.bnkCd.value = document.all.f444_1.value;
		dataForm.action=top.CONTEXT+"/4.LON/13300/process17.jsp";
		dataForm.target="popup17";
		dataForm.submit();
	}

	/* 
	* 銀行名称取得（引落口座）
	*/
	function getBankName2(){
		document.all.bnkCd.value = document.all.f508_1.value;
		dataForm.action=top.CONTEXT+"/4.LON/13300/process19.jsp";
		dataForm.target="popup19";
		dataForm.submit();
	}
	
	/* 
	* 支店名称取得（振込口座）
	*/
	function getShitenName1(){
		// 引落口座情報の支店名
		document.all.bnkCd2.value = document.all.f444_1.value;
		document.all.brnCd.value = document.all.f444_2.value;
		dataForm.action=top.CONTEXT+"/4.LON/13300/process18.jsp";
		dataForm.target="popup18";
		dataForm.submit();
	
	}
	
	/* 
	* 支店名称取得（振込口座）
	*/
	function getShitenName2(){
		document.all.bnkCd2.value = document.all.f508_1.value;
		document.all.brnCd.value = document.all.f508_2.value;
		dataForm.action=top.CONTEXT+"/4.LON/13300/process20.jsp";
		dataForm.target="popup20";
		dataForm.submit();
	
	}
	// 2013.3.16 実行代わり金振込処理対応 END

	//20160321 fx add 
	function u_moveValue() {

		var sum = Number(unFormatComma(document.all.f3.value)) - ( Number(unFormatComma(document.all.f601.value))  +
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
	label.tab_page_label{display:inline-block;}
	.padding_ver_20{padding:20px 0;}
	.padding_hor_20{padding:0 20px;}
	input{box-sizing:border-box;}
</style>
<input type='hidden' name='code' value='00'>
<input type='hidden' name='RTN_FLAG' value='9'>
<button id='NEW' onclick="top.execute(document.all.trCode.value, '01')" disabled='true'><sup>F5</sup>&nbsp;<script>w1('APPLICATION')</script></button>
<button id='DELETE' onclick="top.execute(document.all.trCode.value, '03')" style='border:1px inset;' disabled='true'><sup>F7</sup>&nbsp;<script>w1('DELETE')</script></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<button id='TRANSACTION2' disabled='true'><sup>&nbsp;&nbsp;</sup>&nbsp;<script>w1('ADDNEW')</script></button>
<button id='PRINT' disabled='true'><sup>&nbsp;</sup>&nbsp;<script>w1('PRINT')</script></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<button id='TRANSACTION' type='submit' disabled='true'><sup>F9</sup>&nbsp;<script>w1('TRANSACTION')</script></button>
<br>
<p>
<label class="tab_page_label"><script>w1('CNSLNO')</script></label>
<input type='hidden' name='f1_1'><input name='f1_2' style='width:40px;' readonly tabindex='-1'><input name='f1_3' style='width:40px;' readonly tabindex=-1><input name='f1_4' style='width:20px;' readonly tabindex='-1'><input name='f1_5' style='width:60px;' readonly tabindex='-1'><label class="tab_page_label">
<script>w1('CURRENCYCD')</script></label> <input name='f100'  style='width:40px;' readonly ></input><br>  <!--20160321fx add ---->
<label class="tab_page_label"><script>w1('CIF')</script></label>
<input type='hidden' name='CIF_1' value='<%= f9_1 %>'><input type='hidden' name='CIF_2' value='<%= f9_2 %>'><input name='CIF_3' style='width:80px;'  value='<%= f9_3 %>'><input name='CIFNAME' style='width:600px;' value='<%= f10 %>'><br>
<!--<label class="tab_page_label"><script>w1('APPRTYPE')</script></label>--><input type='hidden' name='f2'><br>
</p>
<div class='TabUI'>
<span id='tabItems' class='TabItem'><script>w1('LOANCNAPINFO')</script></span>
<span id='tabItems' class='TabItem'><script>w1('BONDPROPERTYINFO')</script></span>
<span id='tabItems' class='TabItem'><script>w1('LOANENROLLINFO1')</script></span>
<span id='tabItems' class='TabItem'><script>w1('LOANENROLLINFO2')</script></span>
<span id='tabItems' class='TabItem'><script>w1('LOANENROLLINFO3')</script></span>
<span id='tabItems' class='TabItem'><script>w1('PRIVRATE')</script></span>
<span id='tabItems' class='TabItem'><script>w1('LIMTREGINFO')</script></span>
<span id='tabItems' class='TabItem'><script>w1('REPAYAMTINFO')</script></span>
<span id='tabItems' class='TabItem'><script>w1('DEEMEDINTEREST')</script></span>		<!--みなし利息-->
</div>

<!-- 1st tab -------------------------------------------------------------------------------------->
<div id='tabPages' class='TabPage padding_ver_20'>

<label class="tab_page_label"><script>w1('LONSTATUS')</script></label>
<input name='f206' style='width:150px;' readonly tabindex='-1' value='<%= f7 %>'><br>
<input type='hidden' name='f209' style='width:360px;' readonly tabindex='-1' value='<%= f11 %>'>
<label class="tab_page_label"><script>w1('COMPTYPNAM')</script></label>
<input name='f210' style='width:40px;' qtype="61" onpropertychange="getDesc()" readonly tabindex=-1 pop="no" value='<%= f12 %>'><input name='f210Lbl' style='width:360px;' readonly tabindex='-1'><br>
<label class="tab_page_label"><script>w1('PRODCD')</script></label><input name='f211' type='hidden' value='<%= f13 %>'>
<input name='f211_1' style='width:110px;' readonly tabindex='-1' value='<%= ProductCode(f13) %>'><input name='f212' style='width:420px;' readonly tabindex='-1' value='<%= f14 %>'><br>
<label class="tab_page_label"><script>w1('FUNDUSECD')</script></label>
<input name='f213' style='width:40px;' readonly tabindex='-1' value='<%= f15 %>'><input name='f501' style='width:350px;' readonly tabindex='-1' value='<%= f501 %>'><br>
<label class="tab_page_label"><script>w1('CNSLKIND')</script></label>
<select name='f217' table='LNPCODE' key='634' disabled></select>
<label class="tab_page_label" style='width:305px;'><script>w1('LIMITKIND')</script></label>
<select name='f218' table='LNPCODE' key='632' disabled></select><br>
<label class="tab_page_label"><script>w1('COLLKIND')</script></label>
<select name='f219' table='LNPCODE' key='23' disabled style='width:290px;'></select>
<label class="tab_page_label"><script>w1('GUARNTTYP')</script></label>
<input name='f220' style='width:40px;' onpropertychange="u_getGuarType(this.value)" readonly tabindex=-1 pop="no" value='<%= f19 %>'><input name='f220Lbl' style='width:240px;' readonly tabindex='-1'><br>
<label class="tab_page_label"><script>w1('BILLCNLTKIND')</script></label>
<select name='f221' table='LNPCODE' key='633' disabled></select>
<label class="tab_page_label" style='width:292px;'><script>w1('ACCTABOUTBILLLOAN')</script></label>
<input type='hidden' name='f222_1' value='<%= f21_1 %>'><input type='hidden' name='f222_2'  value='<%= f21_2 %>'><input name='f222_3' style='width:40px;' readonly tabindex=-1 value='<%= f21_3 %>'><input name='f222_4' style='width:25px;' readonly tabindex=-1 value='<%= f21_4 %>'><input name='f222_5' style='width:60px;' readonly tabindex=-1 value='<%= f21_5 %>'><br>
<label class="tab_page_label"><script>w1('GUARCOKINDCODE')</script></label>
<input name='f296' style='width:40px;' qtype='3206' onpropertychange="getDesc()" pop="no" readonly tabindex=-1 value='<%= f96 %>'><input name='f296Lbl' style='width:250px;' readonly tabindex='-1' value='<%= f296Lbl %>'>
<label class="tab_page_label"><script>w1('GUARCOMPCODE')</script></label>
<input name='f297' style='width:40px;' qtype='3207' onpropertychange="getDesc()" pop="no" readonly tabindex=-1 value='<%= f97 %>'><input name='f297Lbl' style='width:240px;' readonly tabindex='-1' value='<%= f297Lbl %>'><br>
<label class="tab_page_label"><script>w1('GROUPLIFECODE')</script></label>
<input name='f223' style='width:40px;' readonly tabindex='-1' qtype='3154' pop='no' value='<%= f22 %>'><input name='f502' style='width:250px;' readonly tabindex='-1' value='<%= f502 %>'>
<label class="tab_page_label"><script>w1('LIFECNT')</script></label>
<input name='f224' style='width:40px;' readonly tabindex='-1' value='<%= f23 %>'><br>
<label class="tab_page_label"><script>w1('LOANENTERFLAG')</script></label>
<input type="checkbox" name='f225' style="margin-left:-4px;" value='<%= f24 %>'  <%=f24.trim().equals("y") ? "checked" : "" %>>
<label class="tab_page_label" style='margin-left:-35px;'><script>w1('CKECKYN')</script></label>
<label class="tab_page_label" style='margin-Left:185px;'><script>w1('LOANINSLNO')</script></label>
<input name='f226' style='width:150px;' readonly tabindex='-1' value='<%= f25 %>'><br>
</div>


<!-- 2nd tab -------------------------------------------------------------------------------------->
<div id='tabPages' class='TabPage padding_ver_20'>

<label class="tab_page_label"><script>w1('DEBTKIND')</script></label>
<select name='f300' table="LNPCODE" key="609" disabled></select>
<label class="tab_page_label" style="width:136px;"><script>w1('CLASSTYP3')</script></label>
<select name='f301' table="LNPCODE" key="610" disabled></select><br>
<label class="tab_page_label"><script>w1('CREDITKIND')</script></label>
<select name='f303' table="LNPCODE" key="611" disabled></select>
<label class="tab_page_label"><script>w1('TREATPLAN')</script></label>
<select name='f304' table="LNPCODE" key="612" disabled></select><br>
<label class="tab_page_label"><script>w1('SUMMARY')</script></label>
<input name='f308' style='width:460px;' readonly tabindex='-1' value='<%= f106 %>'><br>
<label class="tab_page_label">&nbsp;</label>
<input name='f309' style='width:460px;' readonly tabindex='-1' value='<%= f107 %>'><br>
<label class="tab_page_label">&nbsp;</label>
<input name='f310' style='width:460px;' readonly tabindex='-1' value='<%= f108 %>'><br>
<label class="tab_page_label">&nbsp;</label>
<input name='f311' style='width:460px;' readonly tabindex='-1' value='<%= f109 %>'><br>
<!--<label class="tab_page_label"><script>w1('LIMITTYPE')</script></label>-->
<input type='hidden' name='f231' readonly tabindex='-1'><br>
</div>

<!-- 3rd tab -------------------------------------------------------------------------------------->
<div id='tabPages' class='TabPage padding_ver_20'>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('WANAPPLAMT')</script></label>
<input name='f3' style='width:150px;' value='<%= f6 %>' readonly tabindex='-1'>
<label class="tab_page_label" style="margin-left:90px;"><script>w1('LONREQDT')</script></label><input name='f58' type='hidden' value='<%=f84%>' readonly tabindex='-1'>
<input name='f58_4' style='width:80px;' readonly tabindex='-1'><input name='f58' type='hidden' value='<%=f84%>' readonly tabindex='-1'>
<input name='f58_1' type='hidden'><input name='f58_2' type='hidden'><input name='f58_3' type='hidden'><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('SOLIEMPNO')</script></label>
<input name='f4' qtype='28' style="width:80px;" pop="no" value='<%= f26 %>' readonly tabindex='-1'><input name='f4Lbl' style="width:200px;" readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:-40px;'><script>w1('MGREMPNM')</script></label>
<input name='f5' qtype='28' style="width:80px;" pop="no" value='<%= f27 %>' readonly tabindex='-1'><input name='f5Lbl' style="width:200px;" readonly tabindex='-1'><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('SGTPROPNO')</script></label>
<input name='f409' qtype='28' style="width:80px;" pop="no" value='<%= f409 %>' readonly tabindex='-1'><input name='f409Lbl' style="width:200px;" readonly tabindex='-1' value='<%= f409Lbl %>'><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('RELTCNSLNO')</script></label>
<input name='f435' style="width:140px;" value='<%= f435 %>' readonly tabindex='-1'>
<label class="tab_page_label" style="margin-left:100px;"><script>w1('LONTOTAMT')</script></label>
<input name='f436' value='<%= f436 %>' readonly tabindex='-1' style='width:130px;'><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('LIFEINSUAMT3')</script></label>
<input name='f410' value='<%= f410 %>' readonly tabindex='-1' style='width:130px;'>
<label class="tab_page_label" style="margin-left:110px;"><script>w1('LIFEINSUAMT4')</script></label>
<input name='f411' value='<%= f411 %>' readonly tabindex='-1' style='width:130px;'><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('GUARTYPE')</script></label>
<input name='f426' style="width:25px;" qtype="3306" master="f58" pop="no" readonly tabindex='-1' value='<%= f426 %>'><input name='f426Lbl' style="width:220px;" readonly tabindex='-1' value='<%= f426Lbl %>'><br>

<label class="tab_page_label"><script>w1('FEEPATN1')</script></label>
<select name='f446' table="COMCOMB" key="5090" value='<%= f446 %>' disabled></select>
<label class="tab_page_label" style="margin-left:128px;"><script>w1('FEEPATN2')</script></label>
<select name='f447' table="COMCOMB" key="5090" value='<%= f447 %>' disabled></select><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('OUTACCT_CIF')</script></label>
<input type='hidden' name='f445_1' style="width:80px;" value='<%= f445_1 %>' readonly tabindex='-1'><input name='f445_2' style="width:80px;" value='<%= f445_2 %>' readonly tabindex='-1'>

<br><br>
<!-- 引落口座情報 -->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('DEPACCT_INFO')</script></label><br>
<!-- 銀行 -->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('BANK')</script></label>
<input name='f444_1' qtype='4084' style='width:36px;' maxlength='4' readonly onpropertychange="getBankName1();" value='<%= f444_1 %>' ><input name='f444_1Lbl' style='width:240px;' maxlength='30' readonly tabindex='-1' value='<%= f444_1Lbl %>' >

<!-- 支店 -->
<label class="tab_page_label" style="margin-left:-40px;"><script>w1('NBR')</script></label>
<input name='f444_2' qtype='4085' style='width:36px;' maxlength='4' master="f444_1" readonly onpropertychange="getShitenName1();" value='<%= f444_2 %>'><input name='f444_2Lbl' style='width:240px;' readonly tabindex='-1' value='<%= f444_2Lbl %>'><br>

<!-- 種別 -->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('KIND')</script></label>
<input name='f444_3' style='width:20px;' maxlength='2' qtype='3999' readonly onpropertyChange="getDesc()" value='<%= f444_3 %>'><input name='f444_3Lbl' style='width:90px;' readonly tabindex='-1' value='<%= f444_3Lbl %>'>

<!-- 口座番号 -->
<label class="tab_page_label" style="margin-left:130px;"><script>w1('DEP_ACCT_NO')</script></label><input name='f444_4' style='width:160px;' readonly maxlength='20' value='<%= f444_4 %>'><br>

<!-- 20200331 Ek Edit Start -->
<!-- 引落名義(カナ) -->
<label class="tab_page_label" style="margin-left:40px;"><script>w1('DEP_ACCT_NAME_KANA')</script></label></label><input name='f461' style='width:400px;' readonly maxlength='80' value='<%= f461 %>'>
<br><br>
<!-- 20200331 Ek Edit End -->

<!-- 入金（振込先）口座情報 -->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('TRFACCT_INFO')</script></label><br>
<!-- 銀行 -->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('BANK')</script></label>
<input name='f508_1' qtype='4084' style='width:36px;' maxlength='4' readonly onpropertychange="getBankName2();"  value='<%= f508_1 %>'><input name='f508_1Lbl' style='width:240px;' maxlength='30' readonly tabindex='-1' value='<%= f508_1Lbl %>' >

<!-- 支店 -->
<label class="tab_page_label" style="margin-left:-40px;"><script>w1('NBR')</script></label>
<input name='f508_2' qtype='4085' style='width:36px;' maxlength='4' readonly master="f508_1" onpropertychange="getShitenName2();" value='<%= f508_2 %>'><input name='f508_2Lbl' style='width:240px;' readonly tabindex='-1' value='<%= f508_2Lbl %>'><br>

<!-- 種別 -->
<label class="tab_page_label" style="margin-left:36px;"><script>w1('KIND')</script></label>
<input name='f508_3' style='width:20px;' maxlength='2' qtype='3999' readonly onpropertyChange="getDesc()" value='<%= f508_3 %>'><input name='f508_3Lbl' style='width:90px;' readonly tabindex='-1' value='<%= f508_3Lbl %>'>

<!-- 口座番号 -->
<label class="tab_page_label" style="margin-left:130px;"><script>w1('DEP_ACCT_NO')</script></label><input name='f508_4' style='width:160px;' readonly maxlength='20' value='<%= f508_4 %>'><br>

<!-- 口座名義(カナ) -->
<label class="tab_page_label" style="margin-left:40px;"><script>w1('DEPACCTNAME')</script></label></label><input name='f509' style='width:400px;' readonly maxlength='60' value='<%= f509 %>'>
<br><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('LOANISSUMETHOD')</script></label>
<input name='f6' qtype='3210' style="width:25px;" onpropertychange="show();getDesc();" pop="no" value='<%= f28 %>' readonly tabindex='-1'><input name='f6Lbl' style="width:160px;" readonly tabindex='-1' value='<%= f6Lbl %>'><br>

<label class="tab_page_label" style="margin-left:36px;"><script>w1('RELDEBTKIND')</script></label>
<select name='f412' table='LNPCODE' key='720' onpropertychange="show2();" disabled='true'><select>
<label class="tab_page_label" style='margin-left:149px;'><script>w1('JOINDEBTRATE')</script></label>
<input name='p906' style='width:30px;' readonly tabIndex='-1'>%
<!--<label class="tab_page_label"><script>w1('LIMITTYPE')</script></label>-->
<input type='hidden' name='f7' value='<%= f29 %>'><br>

<span id='d2' style="display:none;">
	<label class="tab_page_label" style="margin-left:36px;"><script>w1('JOINJOINCIF1')</script></label>
	<input name='f413_3' style='width:80px;' maxlength='10'  readonly tabIndex='-1' value='<%= f413_3 %>'><input name='f413' style='width:400px;' maxlength='30' readonly tabindex='-1'>
	<input name='f413_1' type='hidden' value='<%= f413_1 %>'><input name='f413_2' type='hidden' value='<%= f413_2 %>'>
	<label class="tab_page_label" style='margin-left:-45px;'><script>w1('JOINRATET1')</script></label>
	<input name='f414' style='width:30px;'  readonly tabIndex='-1' value='<%= f414 %>'>%<br>

	<label class="tab_page_label" style="margin-left:36px;"><script>w1('JOINJOINCIF2')</script></label>
	<input name='f415_3' style='width:80px;' maxlength='10'  readonly tabIndex='-1' value='<%= f415_3 %>'><input name='f415' style='width:400px;' maxlength='30' readonly tabindex='-1'>
	<input name='f415_1' type='hidden' value='<%= f415_1 %>'><input name='f415_2' type='hidden' value='<%= f415_2 %>'>
	<label class="tab_page_label" style='margin-left:-45px;'><script>w1('JOINRATE2')</script></label>
	<input name='f416' style='width:30px;'  readonly tabIndex='-1' value='<%= f416 %>'>%<br>

	<label class="tab_page_label" style="margin-left:36px;"><script>w1('JOINJOINCIF3')</script></label>
	<input name='f417_3' style='width:80px;' maxlength='10'  readonly tabIndex='-1' value='<%= f417_3 %>'><input name='f417' style='width:400px;' maxlength='30' readonly tabindex='-1'>
	<input name='f417_1' type='hidden'><input name='f417_2' type='hidden' value='<%= f417_2 %>'>
	<label class="tab_page_label" style='margin-left:-45px;'><script>w1('JOINRATE3')</script></label>
	<input name='f418' style='width:30px;'  readonly tabIndex='-1' value='<%= f418 %>'>%<br>

	<label class="tab_page_label" style="margin-left:36px;"><script>w1('JOINJOINCIF4')</script></label>
	<input name='f419_3' style='width:80px;' maxlength='10'  readonly tabIndex='-1' value='<%= f419_3 %>'><input name='f419' style='width:400px;' maxlength='30' readonly tabindex='-1'>
	<input name='f419_1' type='hidden'><input name='f419_2' type='hidden' value='<%= f419_2 %>'>
	<label class="tab_page_label" style='margin-left:-45px;'><script>w1('JOINRATE4')</script></label>
	<input name='f420' style='width:30px;'  readonly tabIndex='-1' value='<%= f420 %>'>%<br>
</span>
<span id='d' style="display:none;">
	<br><b><label class="tab_page_label" style="margin-left:36px;"><script>w1('DIVISSUSCHEINFO')</script></label></b><br>

	<label class="tab_page_label" style="margin-left:36px;"><script>w1('DIVISSUSCHECNT')</script></label>
	<input name='f59' style='width:25px;'  maxlength='1' value='<%= f85 %>'   readonly tabIndex='-1'>
	<!--label><script>w1('SCHEDATE')</script></label-->
	<input name='f60' type='hidden'><input name='f61' type='hidden'><input name='f62' type='hidden'><input name='f63' type='hidden'><input name='f64' type='hidden'>
	<label class="tab_page_label" style="margin-left:-17px;"><script>w1('SCHEDATE')</script></label><label class="tab_page_label" style="margin-left:5px;"><script>w1('SCHEAMT')</script></label><br>

	<input style="margin-left:205px;" name='f60_1' style='width:40px;' value='<%= f86_1 %>' readonly tabindex=-1><input name='f60_2' style='width:25px;' value='<%= f86_2 %>' readonly tabindex=-1><input name='f60_3' style='width:25px;' value='<%= f86_3 %>' readonly tabindex=-1><input  style="margin-left:50px;" name='f421' style='width:150px;' value='<%= f421 %>' readonly tabindex='-1'><br>
	<input style="margin-left:205px;" name='f61_1' style='width:40px;' value='<%= f87_1 %>' readonly tabindex=-1><input name='f61_2' style='width:25px;' value='<%= f87_2 %>' readonly tabindex=-1><input name='f61_3' style='width:25px;' value='<%= f87_3 %>' readonly tabindex=-1><input  style="margin-left:50px;" name='f422' style='width:150px;' value='<%= f422 %>' readonly tabindex='-1'><br>
	<input style="margin-left:205px;" name='f62_1' style='width:40px;' value='<%= f88_1 %>' readonly tabindex=-1><input name='f62_2' style='width:25px;' value='<%= f88_2 %>' readonly tabindex=-1><input name='f62_3' style='width:25px;' value='<%= f88_3 %>' readonly tabindex=-1><input  style="margin-left:50px;" name='f423' style='width:150px;' value='<%= f423 %>' readonly tabindex='-1'><br>
	<input style="margin-left:205px;" name='f63_1' style='width:40px;' value='<%= f89_1 %>' readonly tabindex=-1><input name='f63_2' style='width:25px;' value='<%= f89_2 %>' readonly tabindex=-1><input name='f63_3' style='width:25px;' value='<%= f89_3 %>' readonly tabindex=-1><input  style="margin-left:50px;" name='f424' style='width:150px;' value='<%= f424 %>' readonly tabindex='-1'><br>
	<input style="margin-left:205px;" name='f64_1' style='width:40px;' value='<%= f90_1 %>' readonly tabindex=-1><input name='f64_2' style='width:25px;' value='<%= f90_2 %>' readonly tabindex=-1><input name='f64_3' style='width:25px;' value='<%= f90_3 %>' readonly tabindex=-1><input  style="margin-left:50px;" name='f425' style='width:150px;' value='<%= f425 %>' readonly tabindex='-1'><br>
</span>
<input type='hidden' name='bnkCd'><!--銀行コード-->
<input type='hidden' name='bnkCd2'><!--銀行コード-->
<input type='hidden' name='brnCd'><!--支店コード-->
<input type='hidden' name='bnkFlg' ><!--引落・振込口座の処理フラグ-->
</div>





<!-- 4th tab -------------------------------------------------------------------------------------->
<div id='tabPages' class='TabPage padding_ver_20'>

<label class="tab_page_label"><script>w1('PAYBKMTHDCODE')</script></label>
<input name='f44' style="width:30px;" readonly tabindex='-1'  value='<%= f67 %>' readonly tabindex='-1'><input name='f44Lbl' style="width:400px;" readonly tabindex='-1' value='<%= f448 %>'><br>
<label class="tab_page_label"><script>w1('CAPTPAYBKMTHD')</script></label>
<select name='f45' table="LNPCODE" key="507" disabled></select>
<label class="tab_page_label" style="width:216px;"><script>w1('INTPAYBKMTHD')</script></label>
<select name='f46' table="LNPCODE" key="506" disabled></select><br>

<label class="tab_page_label"><script>w1('CAPTPAYBKCYCL')</script></label>
<select name='f47' table="LNPCODE" key="505" disabled></select>
<label class="tab_page_label" style='margin-left:114px;'><script>w1('INTPAYBKCYCL')</script></label>
<select name='f48' table="LNPCODE" key="504" disabled></select><br>

<label class="tab_page_label"><script>w1('CAPTPAYBKKIND')</script></label>
<select name='f460'  table="LNPCODE" key="721" disabled></select>
<input name='f49' type='hidden' table='LNPCODE' key='604'><!--STEP種類-->
<input name='stepFlag' type='hidden' style='margin-left:-4px;' disabled><!--STEP適用区分--><br>

<label class="tab_page_label"><script>w1('BNSREPAYAMT')</script></label>
<input name='f50' style='width:150px;' value='<%= f75 %>' readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:90px;' ><script>w1('BNSREPAYMON')</script></label>
<input name='f51' style='width:20px;' value='<%= f76 %>' readonly tabindex='-1'>,<input name='f52' style='width:20px;' value='<%= f77 %>' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('EACHPARTAMT')</script></label>
<input name='f53' style='width:150px;' value='<%= f79 %>' readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:90px;' ><script>w1('BNSEACHPARTAMT')</script></label>
<input name='f54' style='width:150px;' value='<%= f80 %>' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('AMTAPPLTERM')</script></label>
<input name='f150' style="width:30px;" value='<%= f150 %>' readonly tabindex='-1'><br><br>

<label class="tab_page_label"><script>w1('MATUDTTYP')</script></label>
<select name='f34' table='COMCOMB' key='2920' disabled></select>
<label class="tab_page_label" style="margin-left:13px;"><script>w1('APRLIMT')</script></label>
<input name='d35' style='width:80px;' readonly tabindex='-1'>
<input name='f35_1' type='hidden' style='width:40px;' value='<%= f57_1 %>'><input name='f35_2' type='hidden' style='width:20px;' value='<%= f57_2 %>'><input name='f35_3' type='hidden' style='width:20px;' value='<%= f57_3 %>'>
<label class="tab_page_label"><script>w1('RIMBMNS')</script></label>
<input name='f36' style='width:30px;' value='<%= f58 %>' readonly tabindex='-1'><input type='hidden' name='f37' style='width:80px;' value='<%= f59 %>' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('EXPTYP')</script></label>
<select name='f38' table='COMCOMB' key='890' disabled></select>
<label class="tab_page_label" style='margin-left:26px;'><script>w1('EXPEXPR')</script></label>
<input name='d39' style='width:80px;' readonly tabindex='-1'>
<input name='f39_1' type='hidden' style='width:40px;' value='<%= f61_1 %>'><input name='f39_2' type='hidden' style='width:20px;' value='<%= f61_2 %>'><input name='f39_3' type='hidden' style='width:20px;' value='<%= f61_3 %>'>
<label class="tab_page_label"><script>w1('EXPMTHS')</script></label>
<input name='f40' style='width:30px;' value='<%= f62 %>' readonly tabindex='-1'><input type='hidden' name='f41' style='width:80px;' value='<%= f63 %>' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('THEDATE')</script></label>
<input name='f42' style='width:25px;' value='<%= f64 %>' readonly tabindex='-1'><br>
<input name='f43' type='hidden' value='<%= f66 %>' readonly tabindex='-1'><br><!--振込猶予区分-->

<label class="tab_page_label"><script>w1('REPAYFUND')</script></label>
<input name='f55' style='width:360px;' value='<%= f81 %>' readonly tabindex='-1'><br>
<label class="tab_page_label"><script>w1('RIMBMTHD')</script></label>
<input name='f56' style='width:360px;' value='<%= f82 %>' readonly tabindex='-1'><br>
<label class="tab_page_label"><script>w1('EXPECEFF')</script></label>
<input name='f57' style='width:360px;' value='<%= f83 %>' readonly tabindex='-1'><br>
</div>




<!-- 5th tab -------------------------------------------------------------------------------------->
<div id='tabPages' class='TabPage padding_ver_20'>

<input type='hidden' name="f510" value='<%= f510 %>' readonly tabindex='-1'>
<input type='hidden' name="glDay">
<label class="tab_page_label"><script>w1('RATEKIND')</script></label>
<select name='f8' table='COMCOMB' key='880' disabled='true'></select><br>
<label class="tab_page_label"><script>w1('CHPCODE')</script></label>
<select name='f9'  table="LNPCODE" key="607" disabled='true' style='width:250px;'></select>
<label class="tab_page_label"><script>w1('BASERATECODE')</script></label>
<select name='f10' table="LNPCODE" key="608" disabled='true' style='width:250px;'></select><br>
<label class="tab_page_label"><script>w1('CAPSELECTTERM')</script></label>
<input name='f11' qtype="8001" f3ESC='Y' master="211" master2="f9" master3="f10" master4="ichaMonth" master5="glDay" pop="no" style="width:30px;" value='<%= f33 %>' readonly tabindex='-1'><!--cal8()-->
<label class="tab_page_label" style="margin-left:220px;"><script>w1('FIXRATESPCTYP')</script></label>
<input name='f12' style='width:30px;' qtype="7001" f3ESC='Y' master="211" master2="f9" master3="f10" master4="ichaMonth" master5="glDay" pop="no" value='<%= f34 %>' readonly tabindex='-1'><!--cal7()--><br>
<label class="tab_page_label"><script>w1('NEXTCHPCODE')</script></label>
<select name='f13'  table="LNPCODE" key="607" disabled='true' style='width:250px;'></select>
<label class="tab_page_label"><script>w1('NEXTBASERATECODE')</script></label>
<select name='f14' table="LNPCODE" key="608" disabled='true' style='width:250px;'></select><br>
<label class="tab_page_label"><script>w1('SPECCODE')</script></label>
<input name='f503' f3ESC='Y' disabled='true' style='width:30px;' value='<%= f503 %>'><input name='f503Lbl' disabled='true' style='width:220px;' readonly tabindex='-1' value='<%= f458 %>'>
<label class="tab_page_label"><script>w1('LIFEINSUAMT5')</script></label>
<input name='f504' disabled='true' style='width:130px;' value='<%= f504 %>'><br>
<!--label><script>w1('NEXTSPECTERM')</script></label-->
<input name='f15' style='width:30px;' type="hidden" value='<%= f37 %>'>
<!--変動類型PLAN-->
<input name='f453' type='hidden' style='width:30px;' qtype="3307" f3ESC='Y' pop="no" value='<%= f453 %>'><input name='f453Lbl' type='hidden' style='width:160px;' readonly tabindex='-1' value='<%= f455 %>'>
<!--基準利率PLAN-->
<input name='f454' type='hidden' style='width:30px;' qtype="3305" f3ESC='Y' pop="no" value='<%= f454 %>'><input name='f454Lbl' style='width:160px;' type='hidden' readonly tabindex='-1' value='<%= f456 %>'><br><br>

<label class="tab_page_label"><script>w1('GRPRATEINFO')</script></label><br>
<label class="tab_page_label"><script>w1('PRIMERATE')</script></label>
<input name='f16' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding();" value='<%= f38 %>'>
<label class="tab_page_label"><script>w1('PLUSRATE')</script></label>
<input name='f18' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f40 %>'>
<label class="tab_page_label"><script>w1('MINUSRATE')</script></label>
<input name='f19' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f41 %>'><br>
<label class="tab_page_label"><script>w1('FSTGRADRATE')</script></label>
<input name='f20' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f42 %>'>
<label class="tab_page_label"><script>w1('FSTSPREADRATE')</script></label>
<input name='f21' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f43 %>'>
<label class="tab_page_label"><script>w1('GRPRATE')</script></label>
<input name='f17' style='width:80px;' onpropertychange="u_autopadding()" readonly tabindex='-1' value='<%= f39 %>'><br>
<label class="tab_page_label"><script>w1('CAP')</script></label>
<input name='f22' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f44 %>'>
<label class="tab_page_label"><script>w1('FLOOR')</script></label>
<input name='f23' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f45 %>'>
<label class="tab_page_label"><script>w1('NEXTSPREADRATE')</script></label>
<input name='f24' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f46 %>'><br>
<label class="tab_page_label"><script>w1('TERMRATE')</script></label>
<input name='f25' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f47 %>'>
<label class="tab_page_label"><script>w1('CAPTERMSPREADRATE')</script></label>
<input name='f26' style='width:80px;' onpropertychange="u_autopadding()" readonly tabindex='-1' value='<%= f48 %>'>
<label class="tab_page_label"><script>w1('PRODFIXRATE')</script></label>
<input name='f438' style='width:80px;; textAlign:right' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f438 %>'><br>
<label class="tab_page_label"><script>w1('CIFCAP')</script></label>
<input name='f441' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f441 %>'><br><br>

<label class="tab_page_label"><script>w1('FIXRATE')</script></label>
<input name='f27' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f49 %>'>
<label class="tab_page_label"><script>w1('INCRS')</script></label>
<input name='f28' style='width:80px;' onpropertychange="u_autopadding()" value='<%= f50 %>' readonly tabindex='-1'>
<label class="tab_page_label"><script>w1('PDCRS')</script></label>
<input name='f29' style='width:80px;' onpropertychange="u_autopadding()" value='<%= f51 %>' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('SUPPRATE')</script></label>
<input name='DEPRATE' style='width:80px;' readonly tabindex=-1 onpropertychange="u_autopadding()" value='<%= f111 %>'>
<label class="tab_page_label"><script>w1('GUARRATE')</script></label>
<input name='f401' style='width:80px;' onpropertychange="u_autopadding()"  value='<%= f401 %>' readonly tabindex='-1'>
<label class="tab_page_label"><script>w1('CORPLIFERATE')</script></label>
<input name='f402' style='width:80px;'  onpropertychange="u_autopadding()" value='<%= f402 %>' readonly tabindex='-1'><br>
<label class="tab_page_label"><script>w1('SPECADDRATE')</script></label>
<input name='f505' style='width:80px;' onpropertychange="u_autopadding()" value='<%= f505 %>'readonly tabindex='-1'>
<label class="tab_page_label"><script>w1('DEPRATE')</script></label>
<input name='f30' style='width:80px;' onpropertychange="u_autopadding()" value='<%= f52 %>' readonly tabindex='-1'>
<label class="tab_page_label"><script>w1('TRFMAGRATE')</script></label>
<input name='f33' style='width:80px;' onpropertychange="u_autopadding()" value='<%= f55 %>' readonly tabindex='-1'><br>
<label class="tab_page_label"><script>w1('LONRATE')</script></label>
<input name='f506'  style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding();" value='<%= f506 %>'>
<label class="tab_page_label" style="margin-left:208px;"><script>w1('CURTRATE')</script></label>
<input name='f32' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f54 %>'>
</div>




<!-- 6th tab -->
<div id='tabPages' class='TabPage padding_ver_20'>

<label class="tab_page_label" style="margin-left:17px;"><script>w1('COALCODE')</script></label>
<input name='f408'style='width:45px;' readonly tabindex='-1' value='<%= f408 %>'><input name='f408Lbl' style='width:200px;' readonly tabindex='-1' value='<%= f408Lbl %>'>
<label class="tab_page_label"><script>w1('INSTNO')</script></label>
<input name='f407'style='width:45px;' readonly tabindex='-1' value='<%= f407 %>'><input name='f407Lbl' style='width:200px;' readonly tabindex='-1' value='<%= f407Lbl %>'><br>
<label class="tab_page_label" style="margin-left:17px;"><script>w1('PRIPATTERN')</script></label>
<input name='f408_1' style='width:45px;' qtype='80' pop='no' f3ESC='Y' readonly tabindex='-1' value='<%= f500 %>'><input name='f408_1Lbl' style='width:200px;' readonly tabindex='-1' value='<%= f500Lbl %>'><br>

<label class="tab_page_label" style="margin-left:9px;"><script>w1('PNTPRIVFLAG')</script></label>
<select name='f403' table="COMCOMB" key="4930" disabled></select>
<label class="tab_page_label" style="margin-left:197px;"><script>w1('PNTPRIVRATE')</script></label>
<input name='f31' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f53 %>'><br>
<label class="tab_page_label"><script>w1('CHPPRVFLAG')</script></label>
<select name='f404' table="COMCOMB" key="4930" disabled></select>
<label class="tab_page_label" style="margin-left:197px;"><script>w1('CHPPRVRATE')</script></label>
<input name='f439' style='width:80px;' onpropertychange="u_autopadding()" readonly tabindex=-1 value='<%= f439 %>'><br>
<label class="tab_page_label" style="margin-left:17px;"><script>w1('MAXPRIVRATE')</script></label>
<input name='f406'  style='width:80px;' readonly tabindex='-1' value='<%= f406 %>'>
<label class="tab_page_label" style="margin-left:167px;"><script>w1('APLPRIVRATE')</script></label>
<input name='f440' style='width:80px;' readonly tabindex='-1' onpropertychange="u_autopadding()" value='<%= f440 %>'><br><br>

<span style="overflow:auto; width:100%; height:300px; border:none">
<table border='0' cellspacing='1' cellpadding='2' bgcolor="black" style='font-size:9pt' width='100%'>
	<tr bgcolor='darkgary' align='center'>
		<td class='xTitle' nowrap colspan='2' height='20'><script>w1('CHPCODE')</script></td>
		<td class='xTitle' nowrap><script>w1('ONLY_TERM')</script></td>
		<td class='xTitle' nowrap><script>w1('FRSTPRIVRATE')</script></td>
		<td class='xTitle' nowrap><script>w1('AFTPRIVRATE')</script></td>
	</tr>
<%	for (int i = 0; i < outCnt6; i++) { %>
	<tr bgcolor='white'>
		<td align='center' width='5%'><input name='f428' class='xInput' mask='01' value='<%= f428[i] %>' readonly tabindex='-1'></td>
		<td align='left' width='25%'>&nbsp;&nbsp;
			<script>
				node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = '729' and @CODE_5='"+'<%= f428[i] %>'+
													"' and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
				document.write((node)? node.getAttribute("CODE_NAME"):"");
			</script>
		</td>
		<td align='center' width='10%'><input name='f429' class='xInput' mask='01' value='<%= f429[i] %>' readonly tabindex='-1'></td>
		<td align='center' width='30%'><input name='f430' class='xInput' iLen='2' fLen='5' value='<%= f430[i] %>' readonly tabindex='-1'></td>
		<td align='center' width='30%'><input name='f431' class='xInput' iLen='2' fLen='5' value='<%= f431[i] %>' readonly tabindex='-1'></td>
	</tr>
<%	} %>
</table>
</span>
<input type='hidden' name='f70'>
<input type='hidden' name='f405'>
<input type='hidden' name='f427'>
<input type='hidden' name='f437'>
<input type='hidden' name='dptCd'>
<input type='hidden' name='rateKind'>
<input type='hidden' name='baseRate'>
<input type='hidden' name='chpCode'>
<input type='hidden' name='prodCd'>
<input type='hidden' name='ichaMonth'>
<input type='hidden' name='rateFlag'>
<input type='hidden' name='guarCd'>
<input type='hidden' name='scheDate'>
</div>




<!-- 7th tab -------------------------------------------------------------------------------------->
<div id='tabPages' class='TabPage padding_ver_20'>

<table border='0' cellspacing='1' cellpadding='0' bgcolor="black">
	<tr bgcolor='darkgary' align='center'>
		<td class='xTitle' width='20'  nowrap height='20'>&nbsp&nbsp</td>
		<td class='xTitle' width='110' nowrap><script>w1('LIMITKIND')</script></td>
		<td class='xTitle' width='90'  nowrap><script>w1('GRPNAME')</script></td>
		<td class='xTitle' width='60'  nowrap><script>w1('STATUS')</script></td>
		<td class='xTitle' width='120' nowrap><script>w1('HOMEBRN')</script></td>
		<td class='xTitle' width='80'  nowrap><script>w1('OPNDATE')</script></td>
		<td class='xTitle' width='80'  nowrap><script>w1('MATUDATE2')</script></td>
		<td class='xTitle' width='60'  nowrap><script>w1('LIMTRATE')</script></td>
		<td class='xTitle' width='110' nowrap><script>w1('LIMTAMT2')</script></td>
		<td class='xTitle' width='110' nowrap><script>w1('LIMTBAL')</script></td>
		<td class='xTitle' width='70'  nowrap><script>w1('PROCACCTCNT')</script></td>
		<td class='xTitle' width='80'  nowrap><script>w1('PROCDAY')</script></td>
	</tr>
<%	if (nLoop7 == 0) {	%>
	<tr bgcolor='white'>
		<td align='center' height='20' class='xTitle'>&nbsp;</td>
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
	<tr bgcolor='white'>
		<td align='center' height='20' class='xTitle'><%= i + 1 %></td>
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
<div id='tabPages' class='TabPage padding_ver_20'>

<label class="tab_page_label" style="margin-left:-25px;"><script>w1('CALAPPLRATE')</script></label>
<input name='f151' style='width:80px;' onblur='u_autopadding()' value='<%= f151 %>' readonly tabindex='-1'>%<br>

<span style="overflow:auto; width:99%; height:400px; border:none">
<table border='0' cellspacing='1' cellpadding='2' bgcolor="black" width='100%' style='font-size:9pt;'>
	<tr bgcolor='darkgary' align='center'>
	    <td class='xTitle' nowrap width='3%' height='20'><script>w1('SEQNO')</script></td>
		<td class='xTitle' nowrap width='25%'><script>w1('REPAYCNTFROM')</script></td>
		<td class='xTitle' nowrap width='25%'><script>w1('REPAYCNTTO')</script></td>
		<td class='xTitle' nowrap width='47%'><script>w1('REPAYAMT2')</script></td>
	</tr>
<%	if (nLoop8 == 0) {	%>
	<tr bgcolor='white'>
		<td align='center' height='20' class='xTitle'>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<%	} else {
		for (int i = 0; i < nLoop8; i++) { %>
	<tr bgcolor='white' align='center'>
		<td height='20' class='xTitle'><%= i + 1 %></td>
		<td id="td152"><input name='d153' class='xInput' style='text-align:right;' readonly tabindex='-1' mask='01' value='<%= f155[i] %>' readonly tabindex='-1'></td>
		<td id="td153"><input name='f153' class='xInput' style='text-align:right;' maxlength='3' value='<%= f153[i] %>' readonly tabindex='-1' ></td>
    	<td id="td154"><input name='f154' class='xInput' style='width:170px; text-align:right;' value='<%= f154[i] %>' mask='02' iLen=15 fLen=0 readonly tabindex='-1'></td>
	</tr>
<% 		}
	}
%>
</table>
</span><br>
<input type='hidden' name='f152' value='<%= f152 %>'>
</div>

<!---みなし利息-->
<!-- 9th tab ------------------------------------------------------------------------------------->
<div id='tabPages' class='TabPage padding_ver_20'>

<!-- 事務取扱手数料 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('OFFICETXFEE')</script></label>
<input name='f601' style='width:150px;text-align:right' onpropertychange='u_moveValue()' value='<%= f601 %>' readonly tabindex='-1'><br>
<!-- 印紙代 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('STAMPTAX')</script></label>
<input name='f602' style='width:150px;text-align:right' onpropertychange='u_moveValue()' value='<%= f602 %>' readonly tabindex='-1'><br>
<!-- 公証費用 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('KJFEE')</script></label>
<input name='f603' style='width:150px;text-align:right' onpropertychange='u_moveValue()' value='<%= f603 %>' readonly tabindex='-1'><br>
<!-- 火災保険料 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('INSUFEE')</script></label>
<input name='f604' style='width:150px;text-align:right' onpropertychange='u_moveValue()' value='<%= f604 %>' readonly tabindex='-1'><br>
<!-- 担保調査費用 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('OUTCOLLRESFEE')</script></label>
<input name='f605' style='width:150px;text-align:right' onpropertychange='u_moveValue()' value='<%= f605 %>' readonly tabindex='-1'><br>
<!-- 確定日付料 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('FIXDATEFEE')</script></label>
<input name='f606' style='width:150px;text-align:right' onpropertychange='u_moveValue()' value='<%= f606 %>' readonly tabindex='-1'><br>
<!-- 登記費用 -->
<label class="tab_page_label" style='margin-left:20px;'><script>w1('DKFEE')</script></label>
<input name='f607' style='width:150px;text-align:right' onpropertychange="u_moveValue()" value='<%= f607 %>' readonly tabindex='-1'><br>
<!-- 差引後顧客口座入金金額 -->
<label class="tab_page_label" style='margin-left:3px;'><script>w1('NETDEPTOTAMT')</script></label>
<input name='f608' style='width:150px;text-align:right' readonly tabindex='-1'>

</div>

<iframe name='popup' width=0 height=0 style="border:0;">
</iframe>
</iframe>
<iframe name='popup17' width=0 height=0 style="border:0;">
</iframe>
<iframe name='popup18' width=0 height=0 style="border:0;">
</iframe>
<iframe name='popup19' width=0 height=0 style="border:0;">
</iframe>
<iframe name='popup20' width=0 height=0 style="border:0;">
</iframe>
