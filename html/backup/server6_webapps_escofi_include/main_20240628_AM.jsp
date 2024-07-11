<!--
 * Date : 2006/11/01
 * Author :
 * version : 1.0
-->
<%@ page contentType="text/html; charset=Windows-31J"%>
<%@ page import="com.ek.web.util.*" %>
<!DOCTYPE html>
<html>
<HEAD>
<meta charset="Windows-31J">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<TITLE> New Document </TITLE>
<style>
body {
height : 100vh;
min-width : 1280px;
min-height : 569px;
}
table {width:100%;height:100%;font-size:9pt;}
.TopMenu a {color:white; text-decoration:none}
.RecentMenu a {color:black; text-decoration:none}
.RecentMenu a:hover {color:red}
.LicMsg{
position:relative;
top:-18px;
left:0px;
right:100px;
padding-top:0px;
padding-left:0px;
padding-right:80px;
height:20px;
line-height:20px;
text-align:right;
float:right;
z-index:999;

font-weight:bold;
color:red;
}
.subTitleStyle{
position:relative;
top:0px;
left:0px;
right:0px;
z-index:1;
}



/*20240617 label? class ?? ? display ?? ? ?? ? width ? ?? */    
.label_align{display:inline-block;width:72px;}

iframe {
  margin: 0;
  padding: 0; 
  border: 0;
  display: block;
  width: 100%;
  height: 100%; 
  box-sizing: border-box;
}
</style>

<script language="javascript" src="<%= request.getContextPath() %>/js/constant.js"></script>
<script language="javascript" src="<%= request.getContextPath() %>/js/prevent.js"></script>
<script language="javascript" src="<%= request.getContextPath() %>/js/util.js"></script>
<script language="javascript" src="<%= request.getContextPath() %>/js/sha256.js"></script>
<script language="javascript">

//Local Table 40
var CCMKIND = null;
var CIPKING = null;
var CIPOTCD = null;
var COMBRCH = null;
var COMCOMB = null;
var COMLABL = null;
var COMMENU = null;
var COMMESG = null;
var COMMSFC = null;
var COMPRIC = null;
var COMTXCD = null;
var COPAPRV = null;
var COPCHNL = null;
//var EFPBKCD = null; 2012/3/19 honda DELETE(NB対応_実行代わり金対応）
//var EFPBRCD = null; 2012/3/19 honda DELETE(NB対応_実行代わり金対応）
var GLPCODE = null;
var GLPNAME = null;
var GLPPOST = null;
var GLPRPNM = null;
var LNPBANK = null;
var LNPCOAL = null;
var LNPCODE = null;
//var LNPCOLN = null; 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
//var LNPCYCL = null; 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
//var LNPGPLS = null; 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
//var LNPGRAD = null; 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
var LNPGRAT = null;
var LNPGRLN = null;
var LNPGRP  = null;
//var LNPGTRM = null; 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
var LNPGUAR = null;
//var LNPINTS = null; 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
var LNPLIFE = null;
//var LNPRATE = null; 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
var LNPREMH = null;
var LNPSPEC = null;
//var LNPSPLN = null; 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
var LNPSRVC = null;
var PRNLIST = null;
var TLMTELR = null;
//var CIPZIPC = null;

//**2012/4/30 NoneBank 追加
var LNPAGNT = null;
var LNPNBNK = null;

//20160321 fx loan 追加
var LNPCURR = null;

// ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓
var DPPGRP  = null;
var DPPTGRP = null;
var DPPOTCD = null;
var DPPTAXR = null;
var DPPCHQ  = null;
var DPPCHRG = null;
// ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑

// ↓↓↓ 20210204 Nonbank START ↓↓↓
var LNPPATN = null;
// ↑↑↑ 20210204 Nonbank END   ↑↑↑

var OUT_HEADER = null;
var menuXml = null;
var SyncCheckXml = null;
var CheckFlag = "";

//20160328 特殊全角文字変換対応
var jisuniXml = null;

var IPAddress = "<%= request.getRemoteAddr() %>";	                                //ip address
var CONTEXT = "<%= request.getContextPath() %>";	                                //context path
var TELR = "<%= WebUtil.handleNull(request.getParameter("TELR")) %>";	            //teller id
var TERM_ID = "<%= WebUtil.padding(request.getParameter("TERM_ID"), 8, true) %>";	//terminal id

var oHeader = new Array(); 		/* output message header */
var iHeader = new Array(); 		/* input message header */
var iFieldsStr = new Array();	/* input message body array */
var oFields = new Array(); 		/* output message body parsing array (The value which is processed) */
var oFieldsStr = new Array(); 	/* output message body parsing array (The value which is not processed) */
var backupArray = new Array();	/* contents from frame price of of specific field immediately before submit with being temporary store (push and restore) percentage arrangement */

var doCheckFlag = "";			/* Input process checking flag of grid */
var pmpHiddenFrameSeq = 0;		/* pdd, pdp output order of hazard submit percentage target iframe */
var bookMarkIndex = 0;			/* bookmark index */
var APRV_PATH= CONTEXT + "/APRV/aprv.jsp";	/* Responsible person approval control module url */


/**
 *
 */
window.onload =  function() {
	initIHeader();		/* init input header  */
	initOHeaderXML();
	initMenuXML();
	initLocalTable();	/* init local table xml  */
    //20160328 特殊全角文字変換対応
    initJisUniXML();        // load jisuni.xml */
	
	if(CheckFlag == "FALSE"){
		//sign-on transactions execution
		execute(24000);
	}else{
		//if making Localxml
		console.log("CheckFlag 2: " + CheckFlag);
		topMenuArea.appendChild(makeExitButton("log-out", 0));
		alert("12792:しばらくたってから再度サインオンして下さい。");
	}
};

//20160328 特殊全角文字変換対応
function initJisUniXML() {
	jisuniXml = loadXML("/xml/jisuni.xml");	//jisuni.xml
}

/**
 *
 */
function initOHeaderXML() {
	OUT_HEADER = loadXML("/xml/OUT_HEADER.xml");	//output header xml
}

/**
 *
 */
function initMenuXML() {
	menuXml = loadXML("/xml/menu.xml");         	//menu.xml
}

/**
 *	init input header
 *
 */
function initIHeader() {

	iHeader["DPT_CD"] = "0000";
	iHeader["BRN"] = "0000";
	iHeader["OTHER_BRN"] = "0000";
	iHeader["TELR"] = "0000000000";
	iHeader["TERM_ID"] = TERM_ID;
	iHeader["BIS_DATE"] = "00000000";
	iHeader["SYS_DATE"] = "00000000";
	iHeader["IN_TIME"] = "16000000";
	iHeader["OUT_TIME"] = "16000000";
	iHeader["PROC_TIME"] = "000";
	iHeader["TX_CODE"] = "000000";
	iHeader["SYS_CODE"] = "000";
	iHeader["OTHER_SYS_TERM"] = "000";
	iHeader["HOST_SERV"] = "00000000";
	iHeader["HOST_PROG"] = "00000000";
	//iHeader["LOG_NAME"] = "00000000";
	iHeader["APRV_GUBUN"] = "0";
	iHeader["APRV_TELR1"] = "0000000000";
	iHeader["APRV_CARD_NO1"] = "00000000";
	iHeader["APRV_TELR2"] = "0000000000";
	iHeader["APRV_CARD_NO2"] = "00000000";
	//iHeader["MAIN_TELR"] = "000000";
	iHeader["POST_FLAG"] = "0";
	iHeader["RTN_FLAG"] = "0";
	iHeader["EOD_FLAG"] = "0";
	iHeader["TP_FLAG"] = "0";
	iHeader["IN_LENGTH"] = "00000";
	iHeader["TELR_SEQ"] = "000000";
	iHeader["ORG_SEQ"] = "000000000";
	iHeader["HOST_SEQ"] = "000000000";
	iHeader["GATH"] = "000000000";
	iHeader["PREV_GATH"] = "000000000";
	iHeader["TIMER"] = "030";
	iHeader["HOST_NO"] = "00";
	iHeader["ACCT_KIND"] = "0";
	iHeader["CIF_NO"] = "00000000000000000000";
	iHeader["LOG_NO"] = "0";
	iHeader["NATIONAL_CODE"] = "000";
	iHeader["CIF_FLAG"] = "0";
	iHeader["MSG_FLAG"] = "0";
	iHeader["DEF_FLAG"] = "0";
	iHeader["MIS_FLAG"] = "0";
	iHeader["TPFQ"] = "000";
	iHeader["IPADDR"] = "000000000000000";
	iHeader["DUMMY_1"] ="0000030";//DUMMY_1追加
	iHeader["LIC_FLAG"] ="0"; //license機能追加
	iHeader["DUMMY_2"] ="00000000000000000000000000000000000000000000000000000000000";
}

/**
 *	init local table xml
 *
 */
function initLocalTable() {
	//local table xml load
	CCMKIND =  loadZIP("/xml/CCMKIND.xml");
	CIPKING =  loadZIP("/xml/CIPKING.xml");
	CIPOTCD =  loadZIP("/xml/CIPOTCD.xml");
	COMBRCH =  loadZIP("/xml/COMBRCH.xml");
	COMCOMB =  loadZIP("/xml/COMCOMB.xml");
	COMLABL =  loadZIP("/xml/COMLABL.xml");
	COMMENU =  loadZIP("/xml/COMMENU.xml");
	COMMESG =  loadZIP("/xml/COMMESG.xml");
	COMMSFC =  loadZIP("/xml/COMMSFC.xml");
	COMPRIC =  loadZIP("/xml/COMPRIC.xml");
	COMTXCD =  loadZIP("/xml/COMTXCD.xml");
	COPAPRV =  loadZIP("/xml/COPAPRV.xml");
	COPCHNL =  loadZIP("/xml/COPCHNL.xml");
	//EFPBKCD = loadZIP("/xml/EFPBKCD.zip"); 2012/3/19 honda DELETE(NB対応_実行代わり金対応）
	//EFPBRCD = loadZIP("/xml/EFPBRCD.zip"); 2012/3/19 honda DELETE(NB対応_実行代わり金対応）
	GLPCODE =  loadZIP("/xml/GLPCODE.xml");
	GLPNAME =  loadZIP("/xml/GLPNAME.xml");
	GLPPOST =  loadZIP("/xml/GLPPOST.xml");
	GLPRPNM =  loadZIP("/xml/GLPRPNM.xml");
	LNPBANK =  loadZIP("/xml/LNPBANK.xml");
	LNPCOAL =  loadZIP("/xml/LNPCOAL.xml");
	LNPCODE =  loadZIP("/xml/LNPCODE.xml");
	/** 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
	*LNPCOLN = loadZIP("/xml/LNPCOLN.zip");
	*LNPCYCL = loadZIP("/xml/LNPCYCL.zip");
	*LNPGPLS = loadZIP("/xml/LNPGPLS.zip");
	*LNPGRAD = loadZIP("/xml/LNPGRAD.zip");**/
    LNPGRAT =  loadZIP("/xml/LNPGRAT.xml");
	LNPGRLN =  loadZIP("/xml/LNPGRLN.xml");
	LNPGRP  =  loadZIP("/xml/LNPGRP.xml");
	//LNPGTRM = loadZIP("/xml/LNPGTRM.zip"); 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
	LNPGUAR =  loadZIP("/xml/LNPGUAR.xml");
	//LNPINTS = loadZIP("/xml/LNPINTS.zip"); 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
	LNPLIFE =  loadZIP("/xml/LNPLIFE.xml");
	//LNPRATE = loadZIP("/xml/LNPRATE.zip"); 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
	LNPREMH =  loadZIP("/xml/LNPREMH.xml");
	LNPSPEC =  loadZIP("/xml/LNPSPEC.xml");
	//LNPSPLN = loadZIP("/xml/LNPSPLN.zip"); 2012/1/11 KIM SUNYONG DELETE(未使用ローカルデータベースファイル)
	LNPSRVC =  loadZIP("/xml/LNPSRVC.xml");
	PRNLIST =  loadZIP("/xml/PRNLIST.xml");
	TLMTELR =  loadZIP("/xml/TLMTELR.xml");
	//** 2012/4/30 NoneBank 追加
	LNPAGNT =  loadZIP("/xml/LNPAGNT.xml");
	LNPNBNK =  loadZIP("/xml/LNPNBNK.xml");

   //201512/12/21 fx loan 追加
    LNPCURR =  loadZIP("/xml/LNPCURR.xml");

	//local table xml delete
	//CIPZIPC = loadZIP("/xml/CIPZIPC.zip");    why? big Size

// ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓
	DPPGRP  =  loadZIP("/xml/DPPGRP.xml");
	DPPTGRP =  loadZIP("/xml/DPPTGRP.xml");
	DPPOTCD =  loadZIP("/xml/DPPOTCD.xml");
	DPPTAXR =  loadZIP("/xml/DPPTAXR.xml");
	DPPCHQ  =  loadZIP("/xml/DPPCHQ.xml");
	DPPCHRG =  loadZIP("/xml/DPPCHRG.xml");
// ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑

// ↓↓↓ 20210204 Nonbank START ↓↓↓
    LNPPATN =  loadZIP("/xml/LNPPATN.xml");
// ↑↑↑ 20210204 Nonbank END   ↑↑↑

}

/**
 *	xml(.zip) load
 *
 */
function loadZIP(zipURL) {
    CheckFlag = SyncCheck();
	//CheckFlag = "FALSE";
    if(CheckFlag == "FALSE"){
		// JBK基盤更改 - アプレット除去のために追加 (20220531)
		var tempXML = loadXML(zipURL);
		//tempXML.loadXML(document.all.ServerApplet.loadXML(top.CONTEXT + zipURL));
		return tempXML;
	}
}


function parseXML(responseText) {
    var parser = new DOMParser();
    var doc = parser.parseFromString(responseText, "application/xml");
    return doc;
}

/**
 *	makeLocalFlag check
 *
 */
function SyncCheck() {
	SyncCheckXml = loadXML("/xml/SyncCheck.xml");         	//menu.xml
	if (!SyncCheckXml) {
        console.error("Failed to load or parse the XML.");
        return;
		}
	
	
	var SyncCheckFlag = SyncCheckXml.querySelectorAll("Sync");
	var SyncFlag;
	for (var i=0; i<SyncCheckFlag.length; i++) {
		SyncFlag = SyncCheckFlag[i].getAttribute("SyncFlag");
	}
	
	return SyncFlag;
}




/**
 *	After sign-on (24000) menu initial anger
 *
 */
function init() {
	console.log("after sign-on");
	var result = top.menuXml.querySelectorAll("topNode > menu");
	const menuArea = document.getElementById('leftMenuArea');
	for (var i=0; i<result.length; i++) {
		var caption = result[i].getAttribute("caption");
		var iconSrcUrl = result[i].getAttribute("icon");
		if (caption != 'hidden') {
			topMenuArea.appendChild(makeButton(caption, i, iconSrcUrl));
			var dotImg = document.createElement("img");
			dotImg.src = top.CONTEXT + "/images/dot01.gif";
			dotImg.style.marginLeft = 10+'px';
			dotImg.style.marginRight = 10+'px';
			// 20240618 i's value must be change...
			if(i != 5){
				topMenuArea.appendChild(dotImg);
			}
			menuArea.contentWindow.public_genMenu(result[i]);
		}
	}
	topMenuArea.appendChild(makeExitButton("log-out", i));
	document.getElementById('screenNumber').removeAttribute('readonly');
	document.getElementById('screenNumber').value = "";
	document.getElementById('subTitle').innerHTML = "初期　画面";
	menuArea.contentWindow.public_show(2);
	
	//document.all.STS_MESSAGE.innerText = "初期 画面";
}


/*
 *	label creation of signOnTimeArea
 *
 */
function makeLabel(strDateTime){
	signOnTimeAreaCenter.appendChild(displaySignOnDateTime(strDateTime));
}

function displaySignOnDateTime(strDateTime){
	if(strDateTime == null || strDateTime.length == 0) return;

	var obj = document.createElement("a");
	obj.style.fontWeight = "bold";
	obj.style.fontSize = 9+'px';
	obj.style.color = "black";
	obj.innerHTML = "最終サインオン日時 " + strDateTime;

	signOnTimeAreaTop.height = 3;
	leftScreen.height = 28;
	return obj;
}

/**
 *	button creation of TopMenu
 *
 */
function makeButton(caption, index, iconSrcUrl) {
	console.log("makeButton");
	var iframe = document.getElementById("leftMenuArea");
	var obj = document.createElement("a");
	obj.style.marginRight = 10+'px';
	obj.innerHTML = "<img src='" + top.CONTEXT + iconSrcUrl + "' border=0 align=textbottom> " + caption;
	obj.tabIndex = -1;
	obj.href = "#";
	
	obj.addEventListener("click", function(event) {
		event.preventDefault();
		iframe.contentWindow.public_show(index);
	});
	
	return obj;
}

/**
 *	logout button creation
 *
 */
function makeExitButton(caption, index) {
	var obj = document.createElement("a");
	obj.style.position = 'absolute';
	obj.style.top = '20px';
	obj.style.right ='10px';
	obj.style.marginRight = '10px';
	obj.style.fontWeight = "bold";
	obj.style.color = "yellow";
	obj.innerHTML = "<img src='" + top.CONTEXT + "/images/logout.gif' border=0 align=textbottom> " + caption;
	obj.tabIndex = -1;
	obj.href = "javascript:top.close()";
	return obj;
}

/**
 *	The trCode direct input a screen number from the field, when pressing the enter, calling
 *
 */
function checkTrCode() {
	var tx_code = document.getElementsByName('trCode')[0].value;
	console.log("topMenuArea : " + document.all.topMenuArea.childNodes.length);

	if (document.getElementsByName('trCode')[0].disabled) return false;
	if (trim(tx_code) == "24000" && document.all.topMenuArea.childNodes.length != 3) {
		alert("already login.");
		return false;
	}
	if (tx_code == "") {
		alert("Invalid Screen Number.");
		document.all.trCode.select();
		document.all.trCode.focus();
		return false;
	}

	var title = getTitle(tx_code);

	if (title == "") {
		alert("Invalid Screen Number.");
		document.all.trCode.select();
		document.all.trCode.focus();
		return false;
	} else {
		document.all.SCRIPTCHECK.value = 1;
		document.all.moveCheck.value = 1;
		subTitle.innerHTML = title;

		appendBookMark(document.all.trCode.value, title);

		/* Global variable initial anger must do */
		backupArray = new Array();
		iFieldsStr = new Array();
		oFields = new Array();
		oFieldsStr = new Array();
		doCheckFlag = "";

		return true;
	}
}

/**
 *	[ Screen number ] it returns the Title which corresponds to the action in screen name form.
 *
 */
function getTitle(action) {
	var title = "[" + action + "] ";
	if (action == "24000") return title + "Sign-On";
	try {
		var result = menuXml.querySelector('menu[action="' + action + '"]');
		return title + result.getAttribute("caption");
		document.all.STS_MESSAGE.innerHTML = "[]";
	} catch (exception) {
		return "";
	}
}

/**
 * Transactions name it brings
 *
 */
function getTXName(txCode) {
	var txName = "";
	try {
		var node = COMTXCD.querySelector("/table/record[@TX_CODE='"+ txCode + "' and @STA = '0']");
		txName = (node)? node.getAttribute("FULL_DESC"):"";
		return txName;
	} catch (e) {
		alert(e.description);
		return "";
	}
}

/**
 *	Market ticket name it brings
 *
 */
function getPDFName(pdfKind) {
	try {
		var obj = PRNLIST.querySelector("/table/record[@PDFKIND='" + pdfKind + "']");
		return obj ? obj.getAttribute("PDFNAME") : "";
		//return "PDFNAME";
	} catch (e) {
		alert(e.description);
		return "";
	}
}

/**
 *	Market ticket classification it brings
 *
 */
function getPRNKind(pdfKind) {
	try {
		var obj = PRNLIST.querySelector("/table/record[@PDFKIND='" + pdfKind + "']");
		return obj ? obj.getAttribute("PRNKIND") : "";
		//return "1";
	} catch (e) {
		alert(e.description);
		return "";
	}
}

/**
 *	The CIFMSG it brings
 *
 */
function getCIFMSG(code) {
	try {
		var xpathExpression = "/table/record[@GRP_CD='0065' and @ITEM_CD='" + code + "']"; 
		var obj = document.evaluate(xpathExpression, CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null); 
		return obj ? obj.getAttribute("ITEM_DESC") : "";
	} catch (e) {
		alert(e.description);
		return "";
	}
}

/**
 *	The keypress control which is a transaction number input
 *
 */
function trCode_keypress() {
	if (event.keyCode == 13) {
		document.all.STS_MESSAGE.innerHTML = "[]";
		document.all.code.value = "01";
	}
}

/**
 *	Screen number (action) it shows the screen which corresponds in contents Frame.
 *
 */
function execute(action, code) {
	if(!document.all.trCode.disabled){
		document.all.code.value = code ? code : "01";
		document.all.trCode.value = action;
		document.all.execBtn.click();
	}
}

/**
 *	BookMark process
 *
 */
function appendBookMark(action, title) {
	if (title == "" || action == "24000" || action == "00000") return;
	var url = "javascript:top.execute('" + action + "')";
	for (var i=0; i<myMenu.length; i++) {
		if (myMenu[i].href == url) return;
	}
	if (bookMarkIndex >= myMenu.length) bookMarkIndex = 0;
	var aTag = myMenu[bookMarkIndex];
	bookMarkIndex++;

	aTag.href = url;
	aTag.innerText = "[" + action + "]";
	aTag.title = title;
	aTag.tabIndex = -1;
}

/**
 *	get error message string
 *
 */
function getErrMsg(code) {
	code = intValue(code);
	var xpathExpression = "/table/record[@MESS_NO='" + code + "']"; 
    var obj = document.evaluate(xpathExpression, top.COMMESG, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null); 
	var node = obj.singleNodeValue;
	return node ? node.getAttribute("MESS_DESC") : "";
}

/**
 *	get comtxcd obj
 *
 */
function getCOMTXCD(dptcd,trCode) {
	var obj = COMTXCD.querySelector("table record[DPT_CD='" + dptcd + "'][TX_CODE='" + trCode + "']");
	return obj;
}

/**
 *	get screen message string
 *
 */
function getScrMsg(label) {
	var xpathExpression = "/table/record[@LABEL='" + label + "']"; 
    var obj = document.evaluate(xpathExpression, COMLABL, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null); 
    var node = obj.singleNodeValue;
    return node ? node.getAttribute("NAME") : "none"; 
}

/**
 *	Responsible person approval screen calling
 *
 */
function func1(str) {
	var args = new Array();
	args[0] = this.contents;
	args[1] = str;
	return window.showModalDialog(APRV_PATH, args,"dialogWidth:800px; dialogHeight:600px");
}

function liseMsgBlock(msgType){
	var msgBar = document.getElementById("LicMsgBar");
	var msg = "";
	msgBar.style.display="block";
	if(msgType == "1"){
		msg="ライセンス制限口座数を超えています。追加ライセンスが必要になります。";
	}else{
		msg="ライセンス制限口座数を超えています。取引遅延可能性があります。";
	}
	msgBar.innerHTML=msg;
}

function liseMsgNonBlock(){
	var msgBar = document.getElementById("LicMsgBar");

	msgBar.style.display="none";
	msgBar.innerHTML="";
}

/**
 * XMLHttpRequestによる同期通信処理
 */
function sendXMLHttpRequest(url, params, flag) {
    if (flag === true) {
        const date = new Date();
        const year = date.getFullYear();
        const mon = date.getMonth() + 1;
        const day = date.getDate();
        const hour = date.getHours();
        const min = date.getMinutes();
        const sec = date.getSeconds();
        const now = '&' + year + ('0'+mon).slice(-2) + ('0'+day).slice(-2) + ('0'+hour).slice(-2) + ('0'+min).slice(-2) + ('0'+sec).slice(-2);

        params += now;
    }

    const xhr = new XMLHttpRequest();
    xhr.open("GET", top.CONTEXT + url + '?' + params, false); 
    xhr.send(); 

    if (xhr.status === 200) {
        return xhr.responseText; 
    } else {
        throw new Error('Request failed with status: ' + xhr.status); 
    }
}

/**
 * チャレンジ生成
 *
 */
function createChallenge() {
	// ajax 同期通信
	var responseText = sendXMLHttpRequest('/webaj/createCh', '', true);
	return responseText;
}

/**
 * パスワードのハッシュ化 20200207追加
 *
 * @author ebs金龍山
 */
function getStretchedPassword(pswd, telr) {
    var SHA_OBJ = new jsSHA("SHA-256","TEXT");
    var hash = '';
    SHA_OBJ.update(telr);
    var salt = SHA_OBJ.getHash("HEX");
    for (var i = 0; i < 1000;  i++) {
    	SHA_OBJ = new jsSHA("SHA-256","TEXT");
        SHA_OBJ.update(hash + salt + pswd);
        hash = SHA_OBJ.getHash("HEX");
    }
    return hash;
}

/**
 * ランダムパスワード生成
 */
function getTmpPassword() {
	var tmp = "";
	var baseStr = "012345678901234567890123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var length = 8;
	for (var i = 0; i < length; i++) {
		tmp += baseStr.charAt(Math.random() * baseStr.length);
	}
	return tmp;
}

</script>
</HEAD>
<BODY leftmargin=0 topmargin=0 scroll=no>
<table cellspacing=0 cellpadding=0 style="height:100%">
	<tr><td height=10>
		<table cellspacing=0>
			<tr>
				<td id=topMenuArea style="background-color:#001146;color:white" class=TopMenu>
					<img src="<%= request.getContextPath() %>/images/logo.gif" style="margin-left:80px;margin-right:100px" border=0>
				</td>
			</tr>
			<tr height=5 bgcolor="#006fb7">
				<td></td>
			</tr>
		</table>
	</td></tr>
	<tr><td>
		<table cellspacing=0 cellpadding=0><tr>
			<td width="200px">
			<!-- 20240617 ??? style?  height: 100%?? -->		
				<form name=dataForm onsubmit="return checkTrCode()" target=contents method=post style="height: 100%">
			<!-- 20240617 ??? style?  height: 100%?? // -->
				<table cellspacing=0>
					<tr><td id=signOnTimeAreaTop    height=1 bgcolor=#00aeef></td></tr>
					<tr><td id=signOnTimeAreaCenter height=1 bgcolor=#00aeef align="center"></td></tr>
					<tr>
						<td id=leftScreen height=5 bgcolor=#00aeef>
							<B style="color:#000b29">&nbsp;&nbsp;画面番号</B> :
							<!-- 20240617  style ? ?? px ?? ?? -->						
							<input name="trCode" id="screenNumber" tabindex="-1" readonly="true" maxlength="5" type="number" style="width: 50px;border: solid 1px black;" onkeypress="trCode_keypress()" placeholder="trcode">
							<!-- 20240617 ??? style ? ?? px ?? ?? //-->	
							<input name=code        type=hidden value=01>
							<input name=templet     type=hidden value=templet>
							<input name=SCRIPTCHECK type=hidden value=0>
							<input name=moveCheck   type=hidden value=0>
							<input
								type=hidden name=X_VERSION
								value='<%= application.getAttribute("VERSION") %>'>
							<!-- 20240617 ??? style? display: none ?? -->						
							<input name="execBtn" type="submit" style="width: 0;display: none;" tabindex="-1">
							<!-- 20240617 ??? style? display: none px ?? ?? //-->
						</td>
					</tr>
					<tr>
						<td bgcolor="#ededed" style="box-sizing:border-box; min-width:200px;">
							<iframe
								id=leftMenuArea
								src="<%= request.getContextPath() %>/html/leftmenu.jsp" width=100% height=100%>
							</iframe>
						</td>
					</tr>
					<tr>
						<td bgcolor="#00aeef" height=20>
							<b>Recent used Menu</b>
						</td>
					</tr>
					<tr height=75>
						<td bgcolor="#ededed" class=RecentMenu>
							<span style="width:100%; height:100%; overflow:hidden">
								<a id=myMenu style="height:15" target="contents" tabindex=-1></a><br>
								<a id=myMenu style="height:15" target="contents" tabindex=-1></a><br>
								<a id=myMenu style="height:15" target="contents" tabindex=-1></a><br>
								<a id=myMenu style="height:15" target="contents" tabindex=-1></a><br>
								<a id=myMenu style="height:15" target="contents" tabindex=-1></a>
							</span>
						</td>
					</tr>
				</table>
				</form>
			</td>
			<td>
				<table cellspacing=0>
					<tr height=22>
						<td valign=bottom>
							<img src="<%= request.getContextPath() %>/images/icon_toptitle.gif" style="margin-left:10px;margin-top:10px;">
							<b><span id=subTitle class=subTitleStyle>[24000] Sign-On</span></b>
						    <span id=LicMsgBar class=LicMsg></span>
						</td>
					</tr>
					<tr height=1>
						<td ></td>
					</tr>
					<tr>
						<td>
							<!-- 20240617 height ?? calc(100vh - 138px) ?? ?? -->						
							<iframe name="contents" style="border: none; width:100%; min-width:936px; height: calc(100vh - 138px);" src="<%= request.getContextPath() %>/include/prevent.jsp">
    
							</iframe>
							<!-- 20240617 height ?? calc(100vh - 138px) ?? ?? //-->
							<iframe
								tabindex=-1
								name=hiddenFrame style="border: none; height:0; width:100%; display:block;"
								src="<%= request.getContextPath() %>/include/prevent.jsp">
							</iframe>

							<!-- Output hiddenFrame -->
							<iframe
								tabindex=-1
								name="pmpHiddenFrame1" style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame2" style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame3" style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame4" style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame5" style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame6" style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame7" style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame8" style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame9" style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame10" style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame11" style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame12"  style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame13"  style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame14"  style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame15"  style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame16"  style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame17"  style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame18"  style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame19"  style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<iframe
								tabindex=-1
								name="pmpHiddenFrame20"  style="border: none; height:0; width:100%; display:block;">
							</iframe>
							<!-- /Output hiddenFrame -->

							<!-- Output test hiddenFrame -->
							<iframe
								tabindex=-1
								name=pdfFrame style="border: none; height:0; width:100%"
								src="<%= request.getContextPath() %>/include/prevent.jsp">
							</iframe>
							<!-- /Output test hiddenFrame -->
						</td>
					</tr>
				</table>
			</td>
		</tr></table>
	</td></tr>
	<tr><td height=10>
		<table border=1 cellspacing=0>
			<tr><b><td id=STS_MESSAGE colspan=8  style="background-color:#d4d4d4; font:11pt">&nbsp;</td></b></tr>
			<tr style="background-color:#d4d4d4" align=center>
				<td id="STS_BRN1" width=50>&nbsp;</td>
				<td id="STS_BRN2" width=50>&nbsp;</td>
				<td id="STS_TELR" width=100>&nbsp;</td>
				<td id="STS_BIS_DATE">&nbsp;</td>
				<td id="STS_TCKT_COUNT" width=50>&nbsp;</td>
				<td id="STS_TELR_CASH_AMT" width=200 align=right>&nbsp;</td>
				<td id="STS_TELR_CHQ_AMT" width=200 align=right>&nbsp;</td>
				<td id="STS_TELR_ALT_AMT" width=200 align=right>&nbsp;</td>
			</tr>
		</table>
	</td></tr>
</table>
</BODY>
</html>
