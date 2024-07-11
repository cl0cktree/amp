<%@ page import="java.net.*" %>
<%@ page import="com.ek.util.*" %>
<%@ taglib uri="/WEB-INF/common_1.0.tld" prefix="ek" %>
<%@ page contentType="text/html; charset=Windows-31J" %>

<%	PropManager tp = PropManager.getInstance();
	BaseProperties tbp = tp.getProperties("environment");
	String DeliveryServer = tbp.getProperty("DeliveryServer");
	//20210629 SVN漏れ分再追加
	String TimeoutSecs = tbp.getProperty("session.timeout.secs");
        request.setCharacterEncoding("Windows-31J");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="Windows-31J">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title></title>
<LINK REL="stylesheet" HREF="<%= request.getContextPath() %>/css/templet.css" TYPE="text/css">
<LINK REL="stylesheet" HREF="<%= request.getContextPath() %>/css/tabUI.css" TYPE="text/css">
<LINK REL="stylesheet" HREF="<%= request.getContextPath() %>/css/common.css" TYPE="text/css">
<LINK REL="stylesheet" HREF="<%= request.getContextPath() %>/bootstrap/css/bootstrap.min.css" TYPE="text/css">

<script language="javascript" src="<%= request.getContextPath() %>/js/constant.js"></script>
<script language="javascript" src="<%= request.getContextPath() %>/js/util.js"></script>
<script language="javascript" src="<%= request.getContextPath() %>/js/tabUI.js"></script>
<script language="javascript" src="<%= request.getContextPath() %>/js/prevent2.js"></script>
<script language="javascript" src="<%= request.getContextPath() %>/bootstrap/js/bootstrap.min.js"></script>
<script language="javascript">

var strModifiedFieldsName = ""; /* field name which is changed */
var firstFocusField;            /* first focus field */
var lastFocusField; 	        /* last focus field */
var tab1LastFocusField;
var tab2LastFocusField;
var tab3LastFocusField;
var tab4LastFocusField;
var winF3;

var screenTimer; //20191028 timeoutmsg screen
var myTimer; //20190111 timeoutmsg
window.onload = function() {
	var start = new Date();
	window.focus();
	//setTimeout("disableExecBtn()", 10000);
	initFields();		/* initialization  */
	initSelect();		/* select object init */
	//focusSelect()
	initTab();			/* tab init */
	setDoCheckFlag("");	/* doCheckFlag clear */
	//setTimeout("initPageNFocus()", 1);
	//20210629 SVN漏れ分再追加 Start
	var timeout = "<%=TimeoutSecs%>";
        timeout = timeout*1000 + 30000;
		screenTimer=setTimeout( timeoutMsg2,timeout ); //20191028 sceentimeoutmsg
	//20210629 SVN漏れ分再追加 End
	initPageNFocus();
	initModifiedFields(); /* The fringe land item control init for an approval factor */
	var state = "RATE TEST (record the trcode!!) : " + (new Date() - start);
}

/**
 *	jsp page init and firstField focus()
 */
function initPageNFocus(){
	initPage();	/* jsp page init */
	if (firstFocusField) {
		setFocus(firstFocusField);
	}
	//top.document.all.STS_MESSAGE.innerHTML = "&nbsp;";
}

// 2024/06/25
function observeField(field) {
	const config = { attributes: true, attributeFilter: ['value'] };


    var methods = (field.getAttribute('data-methods') || '').split(',').map(function(methodStr) {
        var match = methodStr.match(/(\w+)\(([^)]*)\)/);
        if (match) {
            var methodName = match[1].trim();
            var param = match[2].trim();
            return { method: window[methodName], param: param };
        } else {
            var methodNameNoParam = methodStr.trim();
            return { method: window[methodNameNoParam], param: null };
        }
    }).filter(function(item) {
        return item && typeof item.method === 'function';
    });

	
     var callback = function() {
        var value = field.value;

        methods.forEach(function(item) {
            var param = item.param === "this.value" ? value : 
						item.param === "this" ? value : 
						item.param;
            if (item.param === null) {
                item.method();
            } else {
                item.method(param);

            }
        });
        getDesc(); // Always call getDesc after the specific methods
    };

 
    var observer = new MutationObserver(function(mutationsList) {
        for (var mutation of mutationsList) {
            if (mutation.type === 'attributes' && mutation.attributeName === 'value') {
                callback();
            }
        }
    });


    observer.observe(field, config);

    field.addEventListener('change', callback);

}


/**
 *	field initialization
 *	xml param initialization
 */
function initFields() {
	try {
		var xmlParams = trInXml.querySelectorAll("param");
	} catch (e) {
		return;
	}
	var param;
	var field;

	/* param initialization*/
	for (var i=0; i<xmlParams.length; i++) {
		param = xmlParams[i];
		var fieldName = param.getAttribute("name");
		fields = document.querySelectorAll("[name='" + fieldName + "']");

		if (!fields.length) continue;		/* The object which corresponds to a correspondence param Ubs u lyus the Eskip */
		
		fields.forEach(function(field) {
			try {
				/* Essential input item with specific color control */
				if (param.getAttribute("require") == "Y") {
					field.style.backgroundColor = COLOR_REQUIRED_BG;
				}

				/* Add event listener for F3 type */
				if (param.getAttribute("UI") == "F3") {

					observeField(field);
				}
				/* Add event listener for F3 type (processjsp) */
				if (param.getAttribute("UI") == "combo" && field.hasAttribute("qtype")){

					observeField(field);
				}

				/* Initialize input field attributes */
				if (field.tagName == "INPUT") {
					initLength(field, param);	/* Attribute control of length */
					initOnlyNum(field, param);	/* Only number price control */
					initMask(field, param);		/* Mask control */
					initType(field, param);
					if (field.readOnly || field.disabled) {
						//field.style.backgroundColor = "#DCDCDC";
					}
				}
			} catch (e) {
				console.error(e.message + " field name duplicate.");
			}
		});
	}
}

/**
 * Consequently in the length of the param the tLen (total length), the iLen (the essence portion length), the fLen (decimal portion length) attribute setting
 */
function initLength(field,param) {

	var len = param.getAttribute("length");
	var tLen = getIntPart(len);
	var fLen = "0";
	var iLen = "0";
	if(isFloat(len)) {
		fLen = getFloatPart(len);
		iLen = (parseInt(tLen,10) - parseInt(fLen,10)).toString();
	} else {
		fLen = "0";
		iLen = tLen;
	}
	field.tLen = tLen;	/* tLen attribute(total length) Addition*/
	field.fLen = fLen;	/* fLen attribute(float length) Addition*/
	field.iLen = iLen;	/* iLen attribute(integer length) Addition*/
}

/**
 * When becomes the onlynum= "Y" of the param, only number input possible control
 */
function initOnlyNum(field,param) {

	var onlyNum = param.getAttribute("onlyNum");
	var mask = param.getAttribute("mask");

	if (mask != "00" ) return;	/*When the mask "is not 00" and it hangs the func separately*/

	/*When the onlyNum "becomes Y"*/
	if (onlyNum == "Y") {
		field.onkeydown=allowNumber; /* The onKeydown when the allowNumber () the func it hangs in the event*/
		/* field.style.textAlign="right";	 */
	}
}

/**
 *mask attribute control of param
 */
function initMask(field,param) {

	var mask = param.getAttribute("mask");
	var type = param.getAttribute("type");
	field.mask = mask;	/* mask attribute addition */
	//field.type = type;

	/* code type */
	if (mask == "01") {
		field.onkeydown=allowCodeNumber; /* The onKeydown when the allowCodeNumber () the func it hangs in the event*/
		field.maxLength = field.iLen;	 /* The select the price is eliminated and the function which is input from hazard the maxlength*/
		setDefaultValue(field,param);	 /* defalut price control*/
	/* code type - zero padding  */
	}else if (mask == "04") {
		field.onkeydown=allowCodeNumber; /* The onKeydown when the allowCodeNumber () the func it hangs in the event*/
		field.maxLength = field.iLen;	 /* The select the price is eliminated and the function which is input from hazard the maxlength*/
		setDefaultValue(field,param);	 /* defalut price control*/
	/* money */
	}else if (mask == "02") {
		field.onkeydown=allowNumber; 	/* The onKeydown when the allowCodeNumber () the func it hangs in the event*/
		field.onkeyup=fCurrency;	 	/* The onKeyup when the fCurrency () the func it hangs in the event*/
		field.style.textAlign="right";	/* ｿ・?､ｷﾄ */
	/* interest rate */
	}else if (mask == "05") {
		field.onkeydown=allowNumber; 	/* The onKeydown when the allowCodeNumber () the func it hangs in the event*/
		field.onkeyup=fCurrency2; 		/* The onKeyup when the fCurrency () the func it hangs in the event*/
		field.style.textAlign="right";	/* ｿ・?､ｷﾄ */
	}else if (mask == "03") {
		field.onkeydown=allowFloat; 	/* The onKeydown when the allowCodeNumber () the func it hangs in the event*/
		field.onkeyup=checkFloat;		/* The onKeyup when the fCurrency () the func it hangs in the event*/
		field.style.textAlign="right";	/* ｿ・?､ｷﾄ */

	}else if (mask == "07") {                //20160331 fx mask7
		field.style.textAlign="right";

	}

}
function initType(field,param){
	var type = param.getAttribute("type");
	if(type=="W"){
		field.style.imeMode="active";
	}else{
		field.style.imeMode="inactive";
	}
}

/**
 * When it grows in defalut attribute of the param, default price input
 */
function setDefaultValue(field,param) {
	var defaultVal = param.getAttribute("default");
	switch (defaultVal) {
	   case "01" :
			field.value = getIHeader("BRN");	/* 店番 */
	      	break;
	   case "02" :
	   		field.value = getGLYEAR();			/*Accounting year*/
	      	break;
	   case "03" :
			field.value = DEFAULT_INPUT_08; 	/*Dividing cord (Subject cord)*/
	      	break;
	   case "04" :
	   		field.value = DEFAULT_INPUT_04; 	/*Dividing cord (consultation number)*/
	      	break;
	   case "05" :
	   		field.value = DEFAULT_INPUT_05;		/*Dividing cord (mortgage number) */
	      	break;
	   case "06" :
	   		field.value = DEFAULT_INPUT_06;		/*Dividing cord (approval number)*/
	      	break;
	   case "07" :
	   		field.value = DEFAULT_INPUT_07;		/*Dividing cord (application number)*/
	      	break;
	   case "08" :
	   		field.value = getIHeader("DPT_CD");	/*Bank cord (DPT_CD)*/
	      	break;
	   case "09" :
	   		field.value = getBranch();			/*Bank cord (DPT_CD)*/
	      	break;
	   case "10" :
			field.value = DEFAULT_INPUT_10; 	/*Dividing cord (カードローンの大科目)*/
	      	break;
	   case "99" :
	   		field.value = padNumber("0",param.getAttribute("length"));	/* '0' With the place it fills*/
	      	break;
	   default :
	      	break;
	} //end of select
}

function getBranch(){

	var dptCd = top.iHeader["DPT_CD"];
	var xpathExpression = "/table/record[@DPT_CD='"+dptCd+"' and @STA="+0+"]"; 
	var obj = document.evaluate(xpathExpression, top.LNPBANK, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null); 
	
	node =  obj.singleNodeValue;
	var branchDefault = (node)? node.getAttribute("FIXED_BRN"):"";
	return branchDefault;
}

/**
 *Fiscal year it brings
 */
function getGLYEAR() {

		var bisDate = getIHeader("BIS_DATE");
		var dptCd = top.iHeader["DPT_CD"];
		
		var xpathExpression = "/table/record[@DPT_CD='"+dptCd+"']"; 
		var obj = document.evaluate(xpathExpression, top.COMMSFC, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null); 
		
		node = obj.singleNodeValue;

		var comDate = (node)? node.getAttribute("INVEST_DATE"):"";
		var glyear="";

		if (bisDate.substring(4,8) <= comDate) {
			glyear = (parseInt(bisDate.substr(0,4))-1).toString();
		} else {
			glyear = bisDate.substr(0,4);
		}
		return glyear;
}

/**
 * All select object which are to the document the make
 */
function initSelect() {
	allSelect = document.querySelectorAll('select');
	allSelect.forEach(function(objSel) {
        makeSelect(objSel, objSel.getAttribute('table'), objSel.getAttribute('key'));
    });
}

/**
 *The select object at key price of the table the make
 */
function makeSelect(selObj, table, key) {

	if(!table || !key) return;
	var str=selObj.outerHTML;
	var xpathExpression;
	str = str.substring(0,str.indexOf(">")+1);

	/* table COMCOMB one case */
	if (table == "COMCOMB") {
		xpathExpression = ".//record[@CODE='" + key + "']";
		var children = top.COMCOMB.evaluate(xpathExpression, top.COMCOMB, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null); 
		str += "<OPTION value=''></OPTION>";
		for(var j=0;j<children.snapshotLength;j++) {
			var child = children.snapshotItem(j);
			str += "<OPTION value='" + child.getAttribute("SUB_CODE") + "'>" + child.getAttribute("CODE_NAME") + "</OPTION>";
		}
	/* table CIPOTCD one case */
	} else if (table == "CIPOTCD") {
		xpathExpression = ".//record[@GRP_CD='" + key + "' and @STA != '09']";
		var children = top.CIPOTCD.evaluate(xpathExpression, top.CIPOTCD, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null); 
		str += "<OPTION value=''></OPTION>";
		for(var j=0;j<children.snapshotLength;j++) {
			var child = children.snapshotItem(j);
			str += "<OPTION value='" + parseInt(child.getAttribute("ITEM_CD"),10) + "'>" + child.getAttribute("ITEM_DESC") + "</OPTION>";
		}
	/* table LNPCODE one case */
	} else if (table == "LNPCODE") {
		if(key == '95'){
			xpathExpression = ".//record[@CODE_KIND='" + key + "' and @STA <= '40' and @CODE_5 < 10]";
			var children = top.LNPCODE.evaluate(xpathExpression, top.LNPCODE, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null); 
			str += "<OPTION value=''></OPTION>";
			for(var j=0;j<snapshotLength.length;j++) {
				var child = children.snapshotItem(j);
				if (child.getAttribute("CODE_5") == "0") continue;
				str += "<OPTION value='" + child.getAttribute("CODE_5") + "'>" + child.getAttribute("CODE_NAME") + "</OPTION>";
			}
		}
		else {
			xpathExpression = ".//record[@CODE_KIND='" + key + "' and @STA <= '40']";
			var children = top.LNPCODE.evaluate(xpathExpression, top.LNPCODE, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null); 
			str += "<OPTION value=''></OPTION>";
			for(var j=0;j<children.snapshotLength;j++) {
				var child = children.snapshotItem(j);
				if (child.getAttribute("CODE_5") == "0") continue;
				str += "<OPTION value='" + child.getAttribute("CODE_5") + "'>" + child.getAttribute("CODE_NAME") + "</OPTION>";
			}
		}

// ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓
    /* table DPPOTCD one case */
	} else if (table == "DPPOTCD") {/* table DPPOTCD one case */
		xpathExpression = ".//record[@GRP_CODE='" + key + "' and @STA ='0']";
		var children = top.DPPOTCD.evaluate(xpathExpression, top.DPPOTCD, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null); 
		str += "<OPTION value=''></OPTION>";
		for(var j=0;j<children.snapshotLength;j++) {
			var child = children.snapshotItem(j);
			str += "<OPTION value='" + child.getAttribute("ITEM_CODE") + "'>" + child.getAttribute("SHRT_NAME") + "</OPTION>";
		}
// ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑

	}
	str += "</SELECT>";
	selObj.outerHTML = str;
}

/**
 * The Thread which controls the make completes control
 * It gives the focus to the select which has become the make last
 */
function focusSelect() {
	allSelect = document.querySelectorAll("SELECT");
	if(allSelect.length>0) {
		setFocus(document.querySelectorAll("SELECT")[allSelect.length-1]);
	}
}

/**
 * The onpropertychange it becomes calling in the event
 * Public finance depending use
 */
function getDesc() {}

/**
 * The window it becomes calling in onload event
 * Corresponding page jsp developer public finance depending use
 */
function initPage() {}

/**
 * ｺｯｰ豢・?ﾗｸ・init
 */
function initModifiedFields() {
	/* ﾀﾏｹﾝ ｺｯｰ豢・?ﾗｸ・ﾀ惕・*/
	storeFieldsOrgVal(document);

	/* grid ｺｯｰ豢・?ﾗｸ・ﾀ惕・*/
	var grid = document.all["grid"];
	var txtarea = document.all["txtarea"];

	if (grid) {
		if (grid.length) {
			for (var i=0; i<grid.length; i++) {
				storeFieldsOrgVal(grid[i].doc);
			}
		} else {
			storeFieldsOrgVal(grid.doc);
		}
	}
}

/**
 *	original value store
 */
function storeFieldsOrgVal(objDoc) {

	var fields = objDoc.querySelectorAll("INPUT");
	for (var i=0; i<fields.length; i++) {
		fields[i].orgVal = fields[i].value;	/* original value with orgVal attribute store*/
	}
	fields = objDoc.querySelectorAll("SELECT");
	for (var i=0; i<fields.length; i++) {
		fields[i].orgVal = fields[i].value;	/* original value with orgVal attribute store*/
	}
}

/**
 *
 */
function checkModifiedFields() {
	/* Fringe land fields merged name clear;*/
	strModifiedFieldsName = "";

	/*  */
	compareFieldsVal(document);

	/* grid  */
	var grid = document.all["grid"];
	var txtarea = document.all["txtarea"];

	if (grid) {
		if (grid.length) {
			for (var i=0; i<grid.length; i++) {
				compareGridFieldsVal(grid[i].doc);
			}
		} else {
			compareGridFieldsVal(grid.doc);
		}
	}
	document.pmpDataForm.pmpModifiedFields.value = strModifiedFieldsName;
}

/**
 *	original value comparison (generality)
 */
function compareFieldsVal(objDoc) {

	var fields = objDoc.querySelectorAll("INPUT");
	for (var i=0; i<fields.length; i++) {
		if (fields[i].orgVal != fields[i].value) {
			strModifiedFieldsName += fields[i].name + ",";
		}
	}

	fields = objDoc.querySelectorAll("SELECT");
	for (var i=0; i<fields.length; i++) {
		if (fields[i].orgVal != fields[i].value) {
			strModifiedFieldsName += fields[i].name + ",";
		}
	}
}

/**
 *	original value store (Grid)
 */
function compareGridFieldsVal(objDoc) {
	var fields = objDoc.querySelectorAll("INPUT");
	for (var i=0; i<fields.length; i++) {
		if (fields[i].orgVal != fields[i].value) {
			strModifiedFieldsName += fields[i].mdname + ",";	/* mdname */
		}
	}

	fields = objDoc.querySelectorAll("SELECT");
	for (var i=0; i<fields.length; i++) {
		if (fields[i].orgVal != fields[i].value) {
			strModifiedFieldsName += fields[i].mdname + ",";	/* mdname */
		}
	}
}

/**
 *	The function the inside it brings
 */
function getFunctionStr(funcPointer) {
	if (!funcPointer) return "";
	var funcStr = funcPointer.toString();
	return funcStr.substring(funcStr.indexOf("{")+1, funcStr.lastIndexOf("}")-1);
}

/**
 * The wool of the dataForm tes it accomplishes an effectiveness verification in E input item and all price
 * at the time of normal one it returns the true.
 */
function checkFields() {


	try {
		top.document.all.STS_MESSAGE.innerHTML = "&nbsp;";
		document.all.SCRIPTCHECK.value = "1"; /*The script guarantees was accomplished. (From FrontController checking)*/
		document.all.msgString.value = "";

		try {
			var xmlParams = trInXml.querySelectorAll("param");
		} catch (e) {
			return false;
										   
	   
		}

		top.iFieldsStr = new Array();	/*Initially anger of the iFieldsStr*/
		for (var i=0; i<xmlParams.length; i++) {

			var param = xmlParams[i];
			var fieldName = param.getAttribute("name");
			var fieldLen = param.getAttribute("length");
			//alert("test:"+fieldName+":"+i);
			/* fieldLen? 0? param(label,tabl)? skip */
																							   
			if(fieldLen == 0) continue;

			field = document.all[fieldName];

			/*When there is not a object which corresponds to a correspondence param the skip (does not to be like this day principle.)*/
			if (!field) {
								  
				top.iFieldsStr[fieldName] = padChar("",parseInt(fieldLen));	/* dummy padding */
				continue;
			}
			try {
				top.iFieldsStr[fieldName] = format(param, field);

				if(field){
					if(field.readonly == false || field.disabled == false){
	 					if (field.value != "" || field.value != 0) checkF3(field);
	 				}
	 			}
			} catch (e) {
				/* When the exception it occurs, after message outputting the focus */
				alert(e.description);
				if (field.select) field.select();
				setFocus(field);
				return false;
			}

			var xmlChildParams = param.querySelectorAll("param");	/* The child the param it brings*/


			/* The case where the param is having child param
			   The price makes and the grid.go () as the calling box it comes to fill in arrangement.*/
			//alert("test:"+fieldName+":");//+xmlChildParams.length);
			//alert(xmlChildParams);
			if (xmlChildParams.length > 0) {
				//alert("childparam length:"+xmlChildParams.length);
				for ( var j=0; j<xmlChildParams.length; j++) {
					var childParam = xmlChildParams[j];
					/* If the length will come out the 0th person thing and there is not a necessity which will be satisfactory. (because is a tab or a label)*/
					if(parseInt(childParam.getAttribute("length"))>0) {
						/*It makes an arrangement at price of the fieldName and*/
						top.iFieldsStr[childParam.getAttribute("name")] = new Array();
	   
					}
																													 
							   
				}
				/* The child if the param (there to be also times when the length is 0th person param and include as) the skip*/
				i+= xmlChildParams.length;
			}

		}
		/* grid The renewal one case which multiplex new input and the fringe land it sees*/
		if(top.doCheckFlag == "9") {
			/*If there is a grid to the jsp, the go of the grid () calling*/
			var grid = document.all["grid"];
			var txtarea = document.all["txtarea"];

			if (grid) {
				if (grid.length) {
					for (var i=0; i<grid.length; i++) {
						if(!grid[i].go()) return false;
					}
				} else {
					if(!grid.go()) return false;
				}
			}
			if (txtarea) {
				if (txtarea.length) {
					for (var i=0; i<txtarea.length; i++) {
						if(!txtarea.go()) return false;
					}
				} else {
					if(!txtarea.go()) return false;
				}
			}
		}

		/*	Transaction number (tr) the setting it does in the Header. (Exceptionally, 63420 is sweet at new process duplication checking hour header of 61100 and direct input in order to ascend there is also a case which is special. In after Ho Chool Doel checkPage () from inside the setting in order to do as a favor the header from the place which it assembles it sprouts separately with the front)
		*/

		top.iHeader["TX_CODE"] = "0" + document.all.trCode.value;

		/* The push, the restore it does and for backupArray the clear.*/
		top.backupArray = new Array();
		try {
			/* The JSP the developer each one the inside function checkPage which it controls () calling*/
			if (!checkPage(top.iFieldsStr)) return false;
		} catch (e) {
			alert(e.description);
			return false;
		}
		/* Message input */
		document.all.msgString.value = makeInMessage();


        /*20160328 特殊全角文字変換対応*/
        var letter = top.jisuniXml.querySelectorAll("Table > Letter");
        for (var ii=0; ii<letter.length; ii++) {
             var jis = letter[ii].getAttribute("JIS");
             var jisstr = letter[ii].getAttribute("STR");
        //   alert("特殊全角文字:" + jis + jisstr + uni);
             document.all.msgString.value = document.all.msgString.value.replace(eval(jis),jisstr);
        }
        //alert(document.all.msgString.value);

	 	/* modified fields connection creation (, with dividing)*/
	 	if(!(document.all.RTN_FLAG.value == 2 && document.all.trCode.value == '13300')) checkModifiedFields();

		/* The input responsible person approval after message assembling the header price reset which becomes hazard setting*/
		resetAprvHeader();

		/*Execution button diabled*/
		disableExecBtn();
		disableAllBtn();

		document.all.X_VERSION.value = top.document.all.X_VERSION.value;
		/* document.all.RTN_FLAG.value = top.document.all.RTN_FLAG.value; 20150901*/
					 
	} catch (e) {
		alert(e.description);
		return false;
	}
	return true;
}

/**
 * input header and body assembly of message
 */
function makeInMessage() {

	var MessageBody = makeInMessageBody();

	/******************
	 * Header setting
	 ******************/
	top.iHeader["RTN_FLAG"] = document.all.RTN_FLAG.value;
	top.iHeader["IN_LENGTH"]= padNumber(byteLength(MessageBody)+"", 5);

	/* HOST_SERV(SERVER_NAME) setting */
	var server_name='<%=DeliveryServer%>'; 	/* 070406 main server */
	server_name = server_name.replace("sp", "10");
	top.iHeader["HOST_SERV"] = server_name;

	var MessageHeader = "";
	for (key in top.iHeader) {
		MessageHeader += top.iHeader[key];
	}
	return MessageHeader + MessageBody;
}

/**
 * input message Assembly
 */
function makeInMessageBody() {

	try {
		var xmlParams = trInXml.querySelectorAll("param");
	} catch (e) {
		return false;
	}

	var MessageBody = "";
	
	

	for (var i=0; i<xmlParams.length; i++) {
		var param = xmlParams[i];
		var fieldName = param.getAttribute("name");
		
		var fieldLen = param.getAttribute("length");
		/*fieldLen 0th person param (label and tabl) skip*/
		if(fieldLen == 0) continue;

		MessageBody += top.iFieldsStr[fieldName];

		var xmlChildParams = param.querySelectorAll("param");	/* The child the param it brings*/
		/*The case where the param is having child param*/
		if (xmlChildParams.length > 0) {

			var parentParam = xmlChildParams[0].parentNode;
			var parentFieldName = parentParam.getAttribute("name")
			var loopCnt = 0;
			/*The parent the param item is repetition Hoes possibility price.*/
			loopCnt = parseInt(top.iFieldsStr[parentFieldName],10);
			for (var j=0; j<loopCnt; j++) {
				for ( var h=0; h < xmlChildParams.length; h++) {
					var childParam = xmlChildParams[h];
					var childFieldName = childParam.getAttribute("name");
					var childFieldLen = parseInt(childParam.getAttribute("length"));

					/* The length 0th person param is not a necessity*/
					if(childFieldLen>0) {
						MessageBody += top.iFieldsStr[childFieldName][j];
					}
				}
			}
			/* The child that the param (there are also times when the Elength is 0th person param, to include as) the skip*/
			i+= xmlChildParams.length;
		}
	}
	return MessageBody;
}

/**
 *The header price reset which reaches responsibility square man-hour setting
 */
function resetAprvHeader() {
	if(getIHeader("APRV_TELR1") != "0000000000") {
		setIHeader("APRV_TELR1","0000000000");
		setIHeader("APRV_CARD_NO1","00000000");
		setIHeader("APRV_TELR2","0000000000");
		setIHeader("APRV_CARD_NO2","00000000");
		setIHeader("TELR_SEQ","000000");
		setIHeader("APRV_GUBUN","0");
	}
}

/**
 *The formatting control must become the input
 */
function format(param, field) {

	var len = param.getAttribute("length");
	var type = param.getAttribute("type");
	var mask = param.getAttribute("mask");
	var onlyNum = param.getAttribute("onlyNum");
	var value = "";
	var returnVal="";

	if (field) {
		/* The mask is 02,03 but cotton comma removal*/

		if (mask == "02" || mask == "03"|| mask == "05"|| mask == "07") { //fx 20160321

			value = trim(unFormatComma(field.value));

			//fx 20160321
			if(mask == "07"){
			 	value = unFormatDots(value);

			}
		} else {
			value = trim(field.value);
		}
	}

	/*The place where it is an essential item, the exception occurrence which when is not input*/
	if (value.length == 0 && param.getAttribute("require") == "Y" && document.all.RTN_FLAG.value != "7") {
		throw new Error(0,"200080 : "+top.getErrMsg("200080"));	/*Essential input err msg  */
	}

	
	if (type=="C" || type=="W") {
		if(mask == "01" && value != ""){
			if (onlyNum=="Y"){
				returnVal = padNumber(value, len);
			}else{
				returnVal = padChar(value, len);
			}
		}else{
			returnVal = padChar(value, len);
		}

	} else if (type=="N") {

		/*Input inside u cotton*/
		if(value.length == 0) {

			 /*"At 0" padding*/
			returnVal = padNumber(value, parseInt(len));

		/*length real income*/
		}else if(isFloat(len)) {

			var floatLen = parseInt(getFloatPart(len),10);
			/*Currently the case which is a price where the price which is input includes a decimal point*/
			if(isFloat(value)) {
				var belowStr = getFloatPart(value);//小数点以下の値
				value = getIntPart(value) + getFloatPart(value);	/*小数点削除*/
				value = (parseInt(value,10) * Math.pow(10,floatLen - belowStr.length)).toString(); /* As the decimal place 0 the price which fills*/
			/*Only the essence price which is not decimal point the case which is input*/
			} else {
				value = (parseInt(value,10) * Math.pow(10,floatLen)).toString(); /*As the decimal place 0 the price which fills*/
			}
			if(parseInt(value,10) < 0 ){
				returnVal = padSignedNumber(value, parseInt(len));
			}else{
				returnVal = padNumber(value, parseInt(len));
			}
		/*The price where the length is the essence*/
		} else {
			if(parseInt(value,10) < 0 ){
				returnVal = padSignedNumber(value, len);
			}else{
				returnVal = padNumber(value, len);
			}
		}
	} else {
		alert("xml param type wrong!!");
	}
	return returnVal;
}

/**
 *With blank character padding
 */
function padChar(value, length) {
	if(value != "") {
		var ctValue = "";
		// クエリストリングは後方の半角スペースを除去しておく(自動削除を考慮)
		value = String(value);
		var qValue = value.replace(/\s+$/, '');
		if (qValue != null) {
			// ajax 同期通信
			var url = '/webaj/charConvert';
			var params = 'pchar=' + encodeURIComponent(value);
			var responseText = top.sendXMLHttpRequest(url, params);
			ctValue = responseText;
		}
		// 除去した後方の半角スペース分を追加する
		var endspace = value.match(/\s+$/);
		if (endspace != null) {
			ctValue = ctValue + endspace[0];
		}
		if(ctValue != value){
			var shiftval = "";
			for(var i=0;i<value.length;i++){
	  			var subval = value.slice(i,i+1);
	  			var subchangeval = ctValue.slice(i,i+1);
	  			if(subval != subchangeval){
	  				shiftval += subval + " ";
				
	  			}
	  		}
			throw new Error(0,"12807 : "+top.getErrMsg("12807") + "( " +shiftval + ")");
		}
	}

	var byteLen = byteLength(value);
									   
	if (byteLen > length) throw new Error(0,"padChar 200309 : "+top.getErrMsg("200309") + value);	/*size over err msg*/
				 

	var str = value;
	for (var i=length-byteLen; i>0; i--) {
		str += " ";
	}
	return str;

}

/**
 *At 0 padding
 */
function padNumber(value, length) {
	/* alert("padNumber value=" + value + " length=" + length); */
	length = parseInt(length);
/* 20150914
	if (byteLength(value) > length) throw new Error(0,"Pad Number 200309 : "+top.getErrMsg("200309") + value );
*/
 /*size early stage err msg*/
	if (byteLength(value) > length) {
            alert("Pad Number 200309 : "+top.getErrMsg("200309") + value );
            return value ;
        }
	if (value.length > 0 && isNaN(value)) {
		alert("padNumber value=" + value + " length=" + length);
		throw new Error(0,"000326 : "+top.getErrMsg("000326")); /*Input error err msg*/
	}
	var str = value;
	for (var i=length-byteLength(value); i>0; i--) {
		str = "0" + str;
	}
	return str;
}

/**
 *It includes a decimal the padding of number type
 */
function padFloat(value,length) {

	/*length middle decimal portion length*/
	var floatLen = parseInt(getFloatPart(length),10);

	if ( value.length == 0 || value == ".") value = 0;

	/*When the decimal portion length of the value grows decimal portion length of the length compared to, the Eexception*/
	if (getFloatPart(value).length > floatLen ) {
		throw new Error(0,"padFloat 200309 : "+top.getErrMsg("200309") + value);	/*size early stage err msg*/
	}
	if (value.length > 0 && isNaN(value)) {
		throw new Error(0,"000326 : "+top.getErrMsg("000326"));	/*Input error err msg*/
	}

	if(isFloat(value)) {
		var belowStr = getFloatPart(value);
		value = getIntPart(value) + getFloatPart(value);	/* ﾁ｡ｻｩｱ・*/
		value = (parseInt(value,10) * Math.pow(10,floatLen - belowStr.length)).toString(); /*As the decimal place 0 the price which fills*/
	/*Only the essence price which is not decimal point the case which is input*/
	} else {
		value = (parseInt(value,10) * Math.pow(10,floatLen)).toString(); /*As the decimal place 0 the price which fills*/
	}
	/*With length padding*/
	return padNumber(value, parseInt(length));
}

/**
 *At 0 padding SingnedNumber(-)
 */
function padSignedNumber(value, length) {
	length = parseInt(length);

	if (byteLength(value) > length) throw new Error(0,"padSignedNumber 200309 : "+top.getErrMsg("200309")+value);		 /*size early stage err msg*/
	if (value.length > 0 && isNaN(value)) {
		//alert("padSignedNumber  value=" + value + " length=" + length);
		throw new Error(0,"000326 : "+top.getErrMsg("000326"));/*Input error err msg*/
	}

	var str = parseInt(value,10) * -1;

	for (var i=length-byteLength(value); i>0; i--) {
		str = "0" + str;
	}
	str = "-"+str;
	return str;
}

/**
 *Date comparison
 */
function dateCompare(y1, m1, d1, y2, m2, d2) {
	var date1 = document.all[y1].value + document.all[m1].value + document.all[d1].value;
	var date2 = document.all[y2].value + document.all[m2].value + document.all[d2].value;
	if (date1 > date2) {
		alertError("000471");
		setFocus(document.all[y1]);
		return false;
	}
	return true;
}
function dateCompare2(y1, m1, d1, y2, m2, d2) {
	var date1 = document.all[y1].value + document.all[m1].value + document.all[d1].value;
	var date2 = document.all[y2].value + document.all[m2].value + document.all[d2].value;
	if (date1 >= date2) {
		alertError("7250");
		setFocus(document.all[y1]);
		return false;
	}
	return true;
}

/**
 *Date validity characteristic checking
 */
function dateCheck2(date){
	var year = date.substring(0,4);
	var month = date.substring(4,6);
	var date = date.substring(6,8);

	if (year.length < 4) {
		alertError("000120");
		setFocus(yearObj);
		return false;
	}
	if (month.length < 2) {
		alertError("000120");
		setFocus(monthObj);
		return false;
	}
	if (date.length < 2) {
		alertError("000120");
		setFocus(dateObj);
		return false;
	}

	if (year < 1900) {
		alertError("000120");
		setFocus(yearObj);
		return false;
	}
	if (month < 1 || month > 12) {
		alertError("000120");
		setFocus(monthObj);
		return false;
	}
	if (date < 1) {
		alertError("000120");
		setFocus(dateObj);
		return false;
	}

	switch (month) {
		case "02"	:
			if (year % 400 == 0) {
				if (date > 29) {
					alertError("000120");
					setFocus(dateObj);
					return false;
				} else {
					return true;
				}
			}
			if (year % 100 == 0) {
				if(date > 28) {
					alertError("000120");
					setFocus(dateObj);
					return false;
				} else {
					return true;
				}
			}
			if (year % 4 == 0) {
				if (date > 29) {
					alertError("000120");
					setFocus(dateObj);
					return false;
				} else {
					return true;
				}
			}
			if (date > 28) {
				alertError("000120");
				setFocus(dateObj);
				return false;
			} else {
				return true;
			}
		case "04"	:
		case "06"	:
		case "09"	:
		case "11"	:
			if (date > 30) {
				alertError("000120");
				setFocus(dateObj);
				return false;
			} else {
				return true;
			}
		default		:
			if (date > 31) {
				alertError("000120");
				setFocus(dateObj);
				return false;
			} else {
				return true;
			}
	}

}

function dateCheck(yyyyName, mmName, ddName) {

	var yearObj = document.all[yyyyName];
	var monthObj = document.all[mmName];
	var dateObj = document.all[ddName];

	var year = yearObj.value;
	var month = monthObj.value;
	var date = dateObj.value;

	if (year.length < 4) {
		alertError("000120");
		setFocus(yearObj);
		return false;
	}
	if (month.length < 2) {
		alertError("000120");
		setFocus(monthObj);
		return false;
	}
	if (date.length < 2) {
		alertError("000120");
		setFocus(dateObj);
		return false;
	}

	if (year == '0000' || year == 0) {
		alertError("000120");
		setFocus(yearObj);
		return false;
	}
	if (year < 1900) {
		alertError("000120");
		setFocus(yearObj);
		return false;
	}
	if (month < 1 || month > 12) {
		alertError("000120");
		setFocus(monthObj);
		return false;
	}
	if (date < 1) {
		alertError("000120");
		setFocus(dateObj);
		return false;
	}

	switch (month) {
		case "02"	:
			if (year % 400 == 0) {
				if (date > 29) {
					alertError("000120");
					setFocus(dateObj);
					return false;
				} else {
					return true;
				}
			}
			if (year % 100 == 0) {
				if(date > 28) {
					alertError("000120");
					setFocus(dateObj);
					return false;
				} else {
					return true;
				}
			}
			if (year % 4 == 0) {
				if (date > 29) {
					alertError("000120");
					setFocus(dateObj);
					return false;
				} else {
					return true;
				}
			}
			if (date > 28) {
				alertError("000120");
				setFocus(dateObj);
				return false;
			} else {
				return true;
			}
		case "04"	:
		case "06"	:
		case "09"	:
		case "11"	:
			if (date > 30) {
				alertError("000120");
				setFocus(dateObj);
				return false;
			} else {
				return true;
			}
		default		:
			if (date > 31) {
				alertError("000120");
				setFocus(dateObj);
				return false;
			} else {
				return true;
			}
	}
}

// ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓
function dateCheck3(yyyyName, mmName) {

	var yearObj = document.all[yyyyName];
	var monthObj = document.all[mmName];

	var year = yearObj.value;
	var month = monthObj.value;

	if (year.length < 4) {
		alertError("000120");
		setFocus(yearObj);
		return false;
	}
	if (month.length < 2) {
		alertError("000120");
		setFocus(monthObj);
		return false;
	}

	if (year == '0000' || year == 0) {
		alertError("000120");
		setFocus(yearObj);
		return false;
	}
	if (year < 1900) {
		alertError("000120");
		setFocus(yearObj);
		return false;
	}
	if (month < 1 || month > 12) {
		alertError("000120");
		setFocus(monthObj);
		return false;
	}

	return true;

}
// ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑

/**
 *Date validity cold region checking anti- each letter checking
 */

/* decimal unicode '12293'(々) no check */
function checkHalfChar(obj) {
	var str = obj.value;
	for (var i=0; i<str.length; i++) {
		var c = str.charCodeAt(i);
		if ((c >= 8554 && c <= 8559) || (c >= 9312 && c <= 9470) || (c >= 65377 && c <= 65439) || c == 94 || c == 12292){
			alertError("12311");
			setFocus(obj);
			return false;
		}
	}
	return true;
}

/**
 * 半角文字チェック
 */
function onlyHalfChar(obj) {
	var str = obj.value;
	for (var i=0; i<str.length; i++) {
		var c = str.charCodeAt(i);
		if (c >= 33 && c <= 126){
			alertError("12311");
			setFocus(obj);
			return false;
		}
	}
	return true;
}

/**
 * 全角～―チェック  20151209
 */
function chkZenSpec(obj) {
	var str = obj.value;
	for (var i=0; i<str.length; i++) {
		var c = str.charCodeAt(i);
		//var d = str.charAt(i);
		//alert("chkZenSpec:"+ d + c );
		if( c == 65374){ /* ～ */
			alertError("12311");
			setFocus(obj);
			return false;
		}
		if( c == 8213){ /* ― */
			alertError("12311");
			setFocus(obj);
			return false;
		}
        }
	return true;
}
/**
 * 全角カナチェック
 */
function onlyAcceptChar(obj) {
	var str = obj.value;
	for (var i=0; i<str.length; i++) {
		var c = str.charCodeAt(i);
		/*var d = str.charAt(i);
		alert("onlyAcceptChar:"+ d + c);*/
		if( c < 12288){
			if ( c != 8217 && c != 8221 && c != 45 && c != 38){
				alertError("12311");
				setFocus(obj);
				return false;
			}
		}
		else if(c > 12290 && c <= 12301){
			if (c != 12300 && c != 12301){
				alertError("12311");
				setFocus(obj);
				return false;
			}
		}
		else if(c > 12301 && c < 12449){
			alertError("12311");
			setFocus(obj);
			return false;
		}
		else if(c > 12525 && c < 12539){
			if (c != 12527 && c != 12530 && c != 12531 && c != 12532){
				alertError("12311");
				setFocus(obj);
				return false;
			}
		}
		else if(c > 12539 && c < 65288){
			if (c != 65281 && c != 65284 && c != 65286 && c != 12540){
				alertError("12311");
				setFocus(obj);
				return false;
			}
		}
		else if(c > 65311 && c < 65313){
			alertError("12311");
			setFocus(obj);
			return false;
		}else if( c > 65338){
			alertError("12311");
			setFocus(obj);
			return false;
		}
	}
	return true;
}

/**
 * 全角スペースチェック
 */
function checkSpaceChar(obj) {
	var str1 = obj.value;
	var str = trim(obj.value);
	for (var i=0; i<str1.length-1; i++) {
		if(str1.charCodeAt(0) == 12288){
			alertError('158');
			setFocus(obj);
			return false;
		}
	}
	for (var i=1; i<str.length-1; i++) {
		if(str.charCodeAt(i) == 12288){
			alertError('158');
			setFocus(obj);
			return false;
		}
	}
	return true;
}

/**
 * 半角スペースチェック
 */
function checkHalfSpaceChar(obj) {
	var str1 = obj.value;
	var str = trim(obj.value);
	for (var i=0; i<str1.length-1; i++) {
		if(str1.charCodeAt(0) == 32){
			alertError('12348');
			setFocus(obj);
			return false;
		}
	}
	for (var i=1; i<str.length-1; i++) {
		if(str.charCodeAt(i) == 32){
			alertError('12348');
			setFocus(obj);
			return false;
		}
	}
	return true;
}

/**
 *It brings the price which it sends to the bakupArray and the setting it does.
 */
function restore(iField, backupField) {
	var inputElement = document.all[iField];

	if(!top.backupArray[backupField]) return;

	if (inputElement.tagName == "INPUT") {
		if(inputElement.type == "checkbox") {
			if(top.backupArray[backupField]=="1" || top.backupArray[backupField].toUpperCase()=="Y") {
				inputElement.checked = true;
			}
		} else {
			inputElement.value = top.backupArray[backupField];
		}
	}else if (inputElement.tagName == "SELECT") {

// ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓
//		inputElement.value = parseInt(top.backupArray[backupField],10);
		if(inputElement.table == "DPPOTCD") {
			inputElement.value = top.backupArray[backupField];
		}else{
			inputElement.value = parseInt(top.backupArray[backupField],10);
		}
// ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑

	}
}

/**
 *The output price of the field it comes to sleep, it comes and the setting it does.
 */
function set(iField, oField) {
	var inputElement = document.all[iField];
	if (inputElement.tagName == "INPUT") {
		if(inputElement.type == "checkbox") {
			if(top.oFields[oField].toString() == "1" || top.oFields[oField].toString().toUpperCase()=="Y") {
				inputElement.checked = true;
			}
		}
		if (inputElement.hasAttribute("qtype")) {
				observeField(inputElement);
				inputElement.value = top.oFields[oField];
				inputElement.dispatchEvent(new Event('input'));
				inputElement.dispatchEvent(new Event('change'));
			}else{
				inputElement.value = top.oFields[oField];
			}
	}else if (inputElement.tagName == "SELECT") {
		inputElement.value = parseInt(top.oFields[oField],10);
	}
}

function set_basic(iField){
	var inputElement = document.all[iField];
	if (inputElement.tagName == "INPUT") {
		if (inputElement.getAttribute("qtype")) {
				observeField(inputElement);
				inputElement.dispatchEvent(new Event('change'));
			}
	}
}

/**
 *text area output control (memory function)
 */
function setTextArea(iFieldName,oFieldName) {

	var str="";
	var arrayText = top.oFields[oFieldName];
	for (var i=0; i<arrayText.length; i++) {
		str += unFormatTab(rTrim(arrayText[i])) + "\r";
	}
	document.all[iFieldName].value = str;
}

function unFormatTab(str) {
	return str.replace(/[\t]/g, "");
}

/**
 * text area input control (memory function)
 */
function doTextArea(fieldName) {

	/*When it was input to it is not, false return*/
	var str = document.all[fieldName].value;

	if(str.length==0) {
		throw new Error(0,"000326 : "+top.getErrMsg("000326"));
	}

	var param;
	try {
		/* //origin
		param = trInXml.selectSingleNode(".//param [@name='"+fieldName+"']");
		*/
		var param_root = ".//param [@name='"+fieldName+"']";
		var param_xpath = document.evaluate(node_root, trInXml, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
		param = node_xpath.singleNodeValue;
	} catch (e) {
		alert(e.description);
		return false;
	}

	var fieldLen = param.getAttribute("length");
	var token;
	var tokenLen;
	var idxChar=0;
	var idxArray=0;
	var arr = new Array();
	var byteLen=0;

	while(idxChar<str.length) {

		token = "";
		tokenLen = 0;

		/*While the tokenLen will be smaller the paramLen than only, it repeats.*/
		for (; tokenLen < fieldLen; idxChar++) {
			if(str.charAt(idxChar)=="\r") {
				idxChar+=2;	/*"\r\n" Exclusion*/
				break;
			}
			token += str.charAt(idxChar);
			//tokenLen += str.charCodeAt(idxChar) < 256 ? 1 : 2;
			tokenLen += byteLength(str.charAt(idxChar));
		}
		arr[idxArray] = padChar(token,fieldLen);
		idxArray++;
	}

	top.iFieldsStr[fieldName]=arr;

	var parentParam = param.parentNode;
	var parentFieldName = parentParam.getAttribute("name");
	var parentFieldLen = parseInt(parentParam.getAttribute("length"));
	top.iFieldsStr[parentFieldName] = padNumber(idxArray.toString(),parentFieldLen);
	return true;
}

/**
 *The output it disjoints message string and it stores in arrangement.
 */
function parseOutMessage() {
	try {
		var xmlParams = trOutXml.querySelectorAll("param");
	} catch (e) {
		alert(e.description);
		return;
	}

	/*oFields, oFieldsStr initial anger*/
	clearOutputFields();

	var strResult = top.hiddenFrame.resultString;
	var strBody = strResult.substr(300, strResult.length);	/*result body of String*/
	var idxChar = 0; /*Initially the idx of the charAt*/

	for (var i=0; i<xmlParams.length; i++) {
		var param = xmlParams[i];

		var fieldName = param.getAttribute("name");

		/* Length of length(ｼﾒｼ?｡ｺﾎｺﾐ ｰ昞ﾁﾇﾏﾁ・ｾﾊﾀｺ ﾇﾘｴ・fieldﾀﾇ byte length) */
		var fieldLen = parseInt(param.getAttribute("length"));

		/* fieldLen 0th person param (label and tabl) skip*/
		if( isNaN(fieldLen) || fieldLen == 0 ) continue;  //20200602

		var token = "";

		try {
			token = getStr(fieldLen);

		} catch (e) {
			alert(e.description + "[output parsing error] "+fieldName);
			return;
		}

		/*The length does not make the 0th person thing. (the label and the tab)*/
		if(fieldLen>0) {
			top.oFieldsStr[fieldName] = token;	/* ｿ?・ｪ */
			top.oFields[fieldName] = unformat(param,token);	/*Processing price*/
		}

		var xmlChildParams = param.querySelectorAll("param");	/*The child the param it brings*/

		/*The case where the param is having child param*/
		if (xmlChildParams.length > 0) {
			var parentParam = xmlChildParams[0].parentNode;

			/*The parent the param item is repetition Hoes possibility price.*/
			var loopCnt = parseInt(top.oFields[parentParam.getAttribute("name")],10);

			for ( var j=0; j<xmlChildParams.length; j++) {

				var childParam = xmlChildParams[j];

				/*If the length comes out and the 0th person thing there is not a necessity.*/
				if(parseInt(childParam.getAttribute("length"))>0) {

					/*It makes an arrangement at price of the fieldName and*/
					top.oFieldsStr[childParam.getAttribute("name")] = new Array();
					/*It makes an arrangement at price of the fieldName and*/
					top.oFields[childParam.getAttribute("name")] = new Array();
				}
			}

			/*As repetition boss repetition*/
			for ( var k = 0; k < loopCnt; k++) {
				for ( var h=0; h < xmlChildParams.length; h++) {
					var childParam = xmlChildParams[h];
					var childFieldName = childParam.getAttribute("name");
					var childFieldLen = parseInt(childParam.getAttribute("length"));

					token = "";

					try {
						token = getStr(childFieldLen);
					} catch (e) {
						alert(e.description + "[output parsing error] "+childFieldName);
						return;
					}
					/*The length does not make the 0th person thing. (the label and the tab)*/
					if(childFieldLen>0) {
						top.oFieldsStr[childFieldName][k] = token;
						top.oFields[childFieldName][k] = unformat(childParam,token); /*  */
					}
				}
			}

			/*The child as the param (if there are also times when length is 0th person param, to include) the skip*/
			i+= xmlChildParams.length;

		}//end of if
	}//end of for
}//end of parseOutMessage()


/**
 *
 */
function unformat(param, fieldVal) {
	var val;
	//fieldVal = fieldVal.replace(/-/gi, "－");
	var temp = fieldVal;
	var mask = param.getAttribute("mask");
	
	if(param.getAttribute("type")=="C" || param.getAttribute("type")=="W") {
		val = trim(temp);
	} else if(param.getAttribute("type")=="T") {
		val = temp;
	} else if(param.getAttribute("type")=="N") {
		var len = param.getAttribute("length");

		if(isFloat(len)) {	/* length real income */

			var floatLen = parseInt(getFloatPart(len),10);
			temp = (trim(temp));

			/* mask amount of money one case  */
			if (mask == "02") {
				temp = formatComma(parseInt(temp.substring(0,temp.length-floatLen),10).toString());

			} else if (mask == "05") {
				temp = formatComma(parseInt(temp.substring(0,temp.length-floatLen),10).toString());

			} else if (mask == "07") { //fx 20160321
			 	var subnum=getOHeader("CHARGE_CODE");
			    subnum= parseInt(subnum,10);

		        temp  = temp.substring(0,temp.length-floatLen);

			    if(temp != ""){
			    	if(subnum == 0){
			    		temp =formatComma(parseInt(temp,10).toString());

			    	}else{
			    		
			    		floatVal=temp.substring(temp.length-subnum,temp.length);
						// 2020/04/29 EK Edit Start (eScofi Enhance) - parse "-000000..." into "-0",  not into "0"
						if (temp.substring(0,1) == "-" && parseInt(temp.substring(0,temp.length-subnum),10) == 0 ){
							temp="-"+formatComma(parseInt(temp.substring(0,temp.length-subnum),10).toString())+"."+floatVal;
						} // 2020/04/29 EK Edit End
						else{
							temp=formatComma(parseInt(temp.substring(0,temp.length-subnum),10).toString())+"."+floatVal;
						}
				
			    	}
			    }
			}else {

				/*point insertion*/
				temp = formatComma(parseInt(temp.substring(0,temp.length-floatLen),10).toString()) + "." + temp.substring(temp.length-floatLen,temp.length);
			}
			val = temp;

		} else {			/*length the essence one case*/
			temp = (trim(temp));	/*Before it comes to fill at 0, from the hazard which it makes with 8 antilogarithms it gives radix 10.*/
			if (param.getAttribute("mask") == "02" || param.getAttribute("mask") == "03"|| param.getAttribute("mask") == "05") {
				temp = formatComma(parseInt(temp.substring(0,len),10).toString());
				val = temp;	/*(,) Control*/
			}else if (param.getAttribute("mask") == "06"){
				var tempsub1;
				var tempsub2;
				temp = temp.toString();
				tempsub1 = temp.substr(0,7);
				tempsub2 = temp.substr(7,17);
				tempsub1 = parseInt(tempsub1,10).toString();
				if(tempsub1 == 0){
					tempsub1 = "";
					tempsub2 = parseInt(tempsub2,10).toString();
					temp = formatComma(tempsub1 + tempsub2);
				}else{
					tempsub2 = tempsub2.toString();
					temp = formatComma(tempsub1 + tempsub2);
				}
				val = temp;
			}else{
				val = parseInt(trim(temp),10);
			}
		}

	} else {
		alert("XML Type Attribute wrong!");
	}
	return val;
}

/**
 *jsp page movement
 */
function go(code) {
	if (code) top.hiddenFrame.document.form1.code.value = code;
	top.hiddenFrame.document.form1.SCRIPTCHECK.value = 1;
	top.hiddenFrame.document.form1.trCode.value = document.all.trCode.value;
	top.hiddenFrame.document.form1.submit();
}

/**
 *The output after the parsing it flows and it controls the func for
 */
function flow() {
	//alert("please redefine flow() function.");
}

/**
 *It sends a price to the backupArray
 */
function push(fieldName, value) {
	var param = getXMLParam(fieldName);
	if(param){
		var len = param.getAttribute("length");
		var type = param.getAttribute("type");
		var mask = param.getAttribute("mask");
		var onlyNum = param.getAttribute("onlyNum");
		if (type=="C" && mask == "01" && onlyNum == "Y" && value != ""){
			top.backupArray[fieldName] = padNumber(value, len);
		} else {
			top.backupArray[fieldName] = value;
		}
	}else{
		top.backupArray[fieldName] = value;
	}
}

/**
 *It brings a price from the backupArray.
 */
function pop(fieldName) {
	return top.backupArray[fieldName];
}

/**
 *In order not to be visible from the screen, it controls the input. (with arrangement it receives name of input which it will control with arg.)
 */
function hideInput(objNames) {
	for (var i=0; i<objNames.length; i++) {
		document.all[objNames[i]].style.display = "none";
	}
}

/**
 *Error alert
 */
function alertError(code) {
	alert(code + ":" + top.getErrMsg(code));
	setMsg("");
        clearTimeout(myTimer); //20190111 timeoutmsg
        //  alert("clear timer");
}

/**
 *status in territory error indication
 */
function setMsg(errCode) {
	var paderrCode = padNumber(errCode,6);
	top.document.all.STS_MESSAGE.innerText = "[" + paderrCode + "]" + top.getErrMsg(errCode);
        clearTimeout(myTimer); //20190111 timeoutmsg
        //  alert("clear timer");
}

/**
 *The ancestral sliced raw fish of the grid it checks the renewal which it sees or the doCheckFlag set for
 */
function setDoCheckFlag(value) {
	top.doCheckFlag = value;
}

/**
 *The ancestral sliced raw fish of the grid it checks the renewal which it sees or the doCheckFlag get for
 */
function getDoCheckFlag() {
	return top.doCheckFlag;
}

/**
 *It brings the price which it sends to the oFields.
 */
function getOutput(oFieldName) {
	return top.oFields[oFieldName];
}

/**
 *It brings the price which it sends to the oFieldsStr.
 */
function getOutputStr(oFieldName) {
	return top.oFieldsStr[oFieldName];
}

/**
 *It brings the price of the iFieldsStr.
 */
function getInputStr(iFieldName) {
	return top.iFieldsStr[iFieldName];
}

/**
 *It brings the price of the backupArray.
 */
function getBackupValue(bFieldName) {
	return top.backupArray[bFieldName];
}

/**
 *The oFields, oFieldsStr Array the clear.
 */
function clearOutputFields() {
	top.oFields = new Array();	/*oFields initial anger*/
	top.oFieldsStr = new Array();	/*oFieldsStr initial anger*/
}

/**
 *In order for the row of the grid to become the onDblclick, - the jsp developer to do public finance, use
 */
function onDblclickGrid(row) { }

/**
 *The row of the grid to do the onClick event - jsp developer public finance, use
 */
function onClickGrid(row) {}

/**
 *The onBlur () - the jsp developer public finance to do in the Input of the grid, use
 */
function onBlurGridInput(row,obj) {}

/**
 *The onChange () - the jsp developer public finance to do in the Input of the grid, use
 */
function onChangeGridInput(row,obj) {}

/**
 *The onFocus () - the jsp developer public finance to do in the Input of the grid, use
 */
function onFocusGridInput(row,obj) {}

/**
 *input, select with essential item color control
 */
function requireField(fieldName) {
	var field = document.all[fieldName];
	field.style.backgroundColor = COLOR_REQUIRED_BG;
}

/**
 *input, select with general item color control
 */
function notRequireField(fieldName) {
	var field = document.all[fieldName];
	field.style.backgroundColor = COLOR_ENABLED_BG;
}

/**
 *The input setting price it brings in the header
 */
function getIHeader(key) {
	return top.iHeader[key];
}

/**
 *The input the setting it does in the header
 */
function setIHeader(key,value) {
	top.iHeader[key] = value;
}

/**
 *The output setting price it brings in the header
 */
function getOHeader(key) {
	return top.oHeader[key];
}

/**
 *The ouput the setting it does in the header
 *
 */
function setOHeader(key,value) {
	top.oHeader[key] = value;
}

/**
 *status in line msg input
 *
 */
function setMsgField(msg) {
	top.document.all.STS_MESSAGE.innerHTML = msg;
        clearTimeout(myTimer); //20190111 timeoutmsg
        //  alert("clear timer");
}

/**
 *Execution button diabled
 */
function disableExecBtn() {
        var msgval = '';
        //alert(" disableExecBtn :" + top.document.all.STS_MESSAGE.innerHTML );
        if( typeof top.document.all.STS_MESSAGE.innerHTML !== 'undefined' ){
           msgval = top.document.all.STS_MESSAGE.innerHTML; //20190111
        }
        //alert( "msgval[" + msgval + "]" + msgval.length );
	disableBtn(top.contents.document.all.TRANSACTION);
        if( msgval==null || msgval.length < 4 || msgval == '&nbsp;' ){ //20190111
        //  alert("set timer");
            myTimer=setTimeout( timeoutMsg,61000 ); //20190111 timeoutmsg
        }
}

/**
 *Execution button enabled
 */
function enableExecBtn() {
        clearTimeout(myTimer); //20190111 timeoutmsg
        //  alert("clear timer");
	enableBtn(top.contents.document.all.TRANSACTION);
}
function timeoutMsg2(){ //20191028 timeoutmsg
   alert("画面タイムアウトが発生しました、再度サインオンしてください!");
   top.document.all.STS_MESSAGE.innerText = "画面タイムアウトが発生しました。";
   top.close();
}
function timeoutMsg(){ //20190111 timeoutmsg
  alert("サーバタイムアウトエラーが発生しました!");
  top.document.all.STS_MESSAGE.innerText = "サーバタイムアウトエラーが発生しました。";
  enableExecBtn();
}

function disableAllBtn() {
	if(top.contents.document.all.NEW) disableBtn(top.contents.document.all.NEW);
	if(top.contents.document.all.DELETE) disableBtn(top.contents.document.all.DELETE);
	if(top.contents.document.all.UPDATE) disableBtn(top.contents.document.all.UPDATE);
	if(top.contents.document.all.QUERY) disableBtn(top.contents.document.all.QUERY);
	if(top.contents.document.all.ALLINQUERY) disableBtn(top.contents.document.all.ALLINQUERY);
	if(top.contents.document.all.CANCELCANCEL) disableBtn(top.contents.document.all.CANCELCANCEL);
	if(top.contents.document.all.CLOSECANCEL) disableBtn(top.contents.document.all.CLOSECANCEL);
	if(top.document.all.trCode) disableBtn(top.document.all.trCode);
}

function enableAllBtn() {
	if(top.contents.document.all.NEW) enableBtn(top.contents.document.all.NEW);
	if(top.contents.document.all.DELETE) enableBtn(top.contents.document.all.DELETE);
	if(top.contents.document.all.UPDATE) enableBtn(top.contents.document.all.UPDATE);
	if(top.contents.document.all.QUERY) enableBtn(top.contents.document.all.QUERY);
	if(top.contents.document.all.ALLINQUERY) enableBtn(top.contents.document.all.ALLINQUERY);
	if(top.contents.document.all.CANCELCANCEL) enableBtn(top.contents.document.all.CANCELCANCEL);
	if(top.contents.document.all.CLOSECANCEL) enableBtn(top.contents.document.all.CLOSECANCEL);
	if(top.document.all.trCode) enableBtn(top.document.all.trCode);
}

/**
 *EXCEL button diabled
 */
function disableExcelBtn() {
	disableBtn(top.contents.document.all.EXCEL);
}

/**
 *EXCEL button enabled
 */
function enableExcelBtn() {
	enableBtn(top.contents.document.all.EXCEL);
}

/**
 *PRINT button diabled
 */
function disablePrintBtn() {
	disableBtn(top.contents.document.all.PRINT);
}

/**
 * PRINT button enabled
 */
function enablePrintBtn() {
	enableBtn(top.contents.document.all.PRINT);
}

/**
 * button disable
 */
function disableBtn(button) {
	if (button) {
		button.disabled = true;
	}
}

/**
 * button enable
 */
function enableBtn(button) {
	if (button) {
		button.disabled = false;
	}
}

/**
 *The input it shows the item of msg
 *
 */
function debugInput() {
	showModalDialog(top.CONTEXT + "/html/debugMsg.jsp", top.iFieldsStr, "");
}

/**
 *The output it shows the item of msg
 *
 */
function debugOutput() {
	showModalDialog(top.CONTEXT + "/html/debugMsg.jsp", top.oFieldsStr, "");
}

/**
 *The formSubmit it becomes calling in the event and
 *the corresponding page developer does public finance, use
 */
function checkPage() {
	return true;
}

/**
 *The disable it makes the obj
 *
 */
function disableField(obj) {
	obj.disabled = true;
	//obj.style.backgroundColor = COLOR_DISABLED_BG;
}

/**
 *The enable it makes the obj
 *
 */
function enableField(obj) {
	obj.disabled = false;
	//var condition = typeof(obj.required) != "undefined";
	//obj.style.backgroundColor = condition ? COLOR_REQUIRED_BG : COLOR_ENABLED_BG;
	//obj.style.backgroundColor = COLOR_ENABLED_BG;
}

/**
 *It cancels the readOnly attribute of the obj
 *
 */
function makeEditable(obj) {
	obj.readOnly = false;
	//obj.style.color = COLOR_EDITABLE_FG;
	obj.tabIndex = 0;
}

/**
 *The readonly it makes the obj
 *
 */
function makeReadOnly(obj) {
	obj.readOnly = true;
	//obj.style.color = "#DCDCDC";
	obj.tabIndex = -1;
}

/**
 *focus in the obj setting
 *
 */
function setFocus(obj) {
	var index = searchTab(obj.parentElement);
	if (index != -1) tabItemSelect(index);
	obj.focus();
	if (obj.tagName == "INPUT") {
		obj.select();
	}
}

/**
 *It searches the label and it shows in the screen
 *
 */
function w1(name) {
	var message = top.getScrMsg(name);
	var scriptElement = document.currentScript; 
    var parentElement = scriptElement.parentNode; 
	return parentElement.innerHTML = message;
	
}

/**
 *The screen it brings the msg
 */
function getScreenMsg(keyname) {
	return top.getScrMsg(keyname);
}

/**
 *The output the case subject body number which will show a result price with POP Ub same case
 *
 */
function showMsg(msg) {
	alert(msg);
}

/**
 *The case which will show a confirmation with POP Ub
 *
 */
function showConfirm(errorCode) {
	var msg;
	msg = "Message No : "+errorCode + "\n";
	msg = msg + top.getErrMsg(errorCode);
	return confirm(msg);
}

/**
 *	in.xml reloading
 *
 */
function reloadInXML(xmlURL){
	reloadXML(xmlURL,1);
}

/**
 *	out.xml reloading
 *
 */
function reloadOutXML(xmlURL){
	reloadXML(xmlURL,2);
}

function reloadOutXMLAbs(xmlURL){
	trOutXml = loadXMLAbs(xmlURL);
}

/**
 *xml again loading.
 *
 */
function reloadXML(xmlURL,op) {
	if(op == 1) {	//in.xml
		trInXml = loadXML(xmlURL);
	}else if(op == 2) {		//out.xml
		trOutXml = loadXML(xmlURL);
	}
}

/**
 *The price which is to the iFieldsStr it changes with a specific price.
 *
 */
function replace(fieldName, value) {
	var obj = top.iFieldsStr[fieldName];
	if (isArray(obj)) {
		for (var i=0; i<obj.length; i++) {
			obj[i] = value;
		}
	} else {
		top.iFieldsStr[fieldName] = value;
	}
}

/**
 *The output the parsing if the hazard which it does there are times must control the JSP developer does and public finance it writes.
 *
 */
function doBeforeParseOut() {}

function doBeforeParseErrorOut() {}

/**
 *excel popup output
 *
 */
function showExcel() {

	var grid = document.all["grid"];
	window.tableHtmlForExcel = grid.getTableHtml();	/*With tableHtmlForExcel attribute of widow data store*/

	var excelURL = top.CONTEXT+"/excel/excelSubmit.jsp";
	var winStatus = "toolbar=0, menubar=1, location=0, WIDTH=1014, HEIGHT=570, TOP=0, LEFT=0, STATUS=1";
	var excelWindow = window.open(excelURL , "excelWindow", winStatus);
	excelWindow.focus();
}

/**
 *pdf popup output: The submit it does at the price pmpManager.jsp which leaves space the popup
 *
 */
function showPDF(pdfKind,xmlURL,rePrint) {

	try {

		/*Filter args checking*/
		if (!pdfKind || !xmlURL) {
			throw new Error(0,"[showPDF]argument Exception");
		}

		var objForm = document.pmpDataForm;
		objForm.pmpPDFKind.value = pdfKind;	/*Output water end*/
		objForm.pmpXMLURL.value = xmlURL;	/* xml url */

		/*The re-output item yes or no gives the default with the Y*/
		objForm.pmpRePrint.value = "Y";
		if (rePrint) objForm.pmpRePrint.value = rePrint;

		var pmpPRNKind = top.getPRNKind(pdfKind);	/*Market ticket classification*/

		/*(Approval factor)) to input string input*/
		if (pmpPRNKind == "3") {
			objForm.pmpMsgString.value = document.dataForm.msgString.value;
		/*(To market ticket and output output string input*/
		} else {
			objForm.pmpMsgString.value = top.hiddenFrame.resultString;
		}

		/* form action setting */
		var pmpActionURL = top.CONTEXT+"/pmp/pmpManager.jsp";
		objForm.action = pmpActionURL;

		/*popup after pmpManager.jsp submit percentage url*/
		var pmpURL = top.CONTEXT+"/pmp/pdfSubmit.jsp";

		var winStatus = "toolbar=0, menubar=1, location=0, WIDTH=1014, HEIGHT=570, TOP=0, LEFT=0, STATUS=1";
		var pdfWindow = window.open(pmpURL , "pdfWindow", winStatus);
		pdfWindow.focus();

	} catch (e) {
		alert(e.description);
		return;
	}
}

/**
 * pdd, pdp output: With the pmpHiddenFrame the submit it does with the pmpManager.jsp.
 * pmpPDFKind: The frm file every ching the key which it will make
 * the pmpXMLURL: The in/out the xml URL
 * pmpMsgString which param information is listening to: in/out message field
 * pmpModifiedFields: The item which is changed
 */
function printPDF(pdfKind,xmlURL,rePrint) {

	try {

		/*Field args checking*/
		if (!pdfKind || !xmlURL) {
			throw new Error(0,"[printPDF]argument Exception");
		}

		// NRT-10033
		top.pmpHiddenFrameSeq += 1;	/*Field args checking pmpHiddenFrame number addition*/
		if(top.pmpHiddenFrameSeq > 20) {
			top.pmpHiddenFrameSeq = 1;
		}

		var objForm = document.pmpDataForm;
		objForm.pmpPDFKind.value = pdfKind;	/*Output result end*/
		objForm.pmpXMLURL.value = xmlURL;	/* xml url */

		/*The re-output item yes or no gives the default with the Y*/
		objForm.pmpRePrint.value = "Y";
		if (rePrint) objForm.pmpRePrint.value = rePrint.toUpperCase();

		objForm.pmpBIS_DATE.value = getOHeader("BIS_DATE");	/* 営業日 */
		objForm.pmpOUT_TIME.value = getOHeader("OUT_TIME");	/* APサーバ取引時間 */
		objForm.pmpHOST_SEQ.value = getOHeader("HOST_SEQ");	/* ホスト番号 */
		objForm.pmpGATH.value = getOHeader("GATH");			/* 取引番号 */
		objForm.pmpTELR.value = getOHeader("TELR");			/* テラー番号 */
		objForm.pmpTERM_ID.value = getOHeader("TERM_ID");	/* ターミナルID */
		objForm.pmpTX_CODE.value = getOHeader("TX_CODE");	/* 取引コード */
		objForm.pmpTX_NAME.value = top.getTXName(getOHeader("TX_CODE"));	/* 取引名 */
		objForm.pmpPDFName.value = top.getPDFName(pdfKind);	/* 帳票名 */
		var pmpPRNKind = top.getPRNKind(pdfKind);
		objForm.pmpPRNKind.value = pmpPRNKind;              /* 帳票番号 */
		objForm.pmpSeq.value = top.pmpHiddenFrameSeq;		/* 帳票順番 */

		/*(Approval factor) to input string input*/
		if (pmpPRNKind == "3") {
			objForm.pmpMsgString.value = document.dataForm.msgString.value;
		/*(The market ticket, it will count) to output string input*/
		} else {
			objForm.pmpMsgString.value = top.hiddenFrame.resultString;
		}

		/* form action setting */
		var pmpActionURL = top.CONTEXT+"/pmp/pmpManager.jsp";
		objForm.action = pmpActionURL;

		/* target iframe name setting */
		var targetFrameName = "pmpHiddenFrame"+top.pmpHiddenFrameSeq;
		//alert(targetFrameName);
		objForm.target = targetFrameName;
		//20190410 ek comment out //20191112 ebs update
		objForm.submit();

		if(top.contents.document.all.PRINT) {
			disableBtn(top.contents.document.all.PRINT);
		}
	} catch (e) {
		alert(e.description);
		return;
	}
}


/**
 *ouput total byte of string
 */
function showOutputLength() {
	alert(byteLength(top.hiddenFrame.resultString));
}

/**
 *The xml it brings a correspondence param with the name of the param
 */
function getXMLParam(paramName) {
	var xmlParam = trInXml.querySelector("param[name='" + paramName + "']");
	return xmlParam;
}

/**
 *The xml attribute the param require with the Y the setting, background color of jsp object with filter color conversion
 */
 function setRequiredParam(fieldName) {
 	var param = getXMLParam(fieldName);
 	param.setAttribute("require", "Y");
 	requireField(fieldName);
 }

/**
 *The xml attribute the param require with the N the setting, background color of jsp object with no filter color conversion
 */
 function setNotRequiredParam(fieldName) {
 	var param = getXMLParam(fieldName);
 	param.setAttribute("require", "N");
 	notRequireField(fieldName);
 }

// ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓

/**
 * setRequiredParam + enableField
 */
 function setRequiredEnable(fieldName) {
 	setRequiredParam(fieldName);
    var objName = document.all[fieldName]
    enableField(objName);
 }

/**
 * setNotRequiredParam + disableField
 */
 function setNotRequiredDisable(fieldName) {
 	setNotRequiredParam(fieldName);
    var objName = document.all[fieldName]
    objName.value="";
    disableField(objName);
 }
// ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑

/**
 *Date su thu it receives a ring price and the field _1, the field _2, the field _3 it splits and.
 */
function seperateDate(fieldName,strDate){
	document.all[fieldName+"_1"].value = strDate.substring(0,4);
	document.all[fieldName+"_2"].value = strDate.substring(4,6);
	document.all[fieldName+"_3"].value = strDate.substring(6,8);
}

/**
 *	float exchange int
 */

/**
 *It changes the field price of the grid at format price.
 *
 */
function formatGridValue(grid,fieldName,formatType) {
	var fieldVals = grid.getValue(fieldName);
	var fieldFormatVals = new Array();

	if (formatType == "formatYYYYMMDD") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatYYYYMMDD();
		}
	} else if (formatType == "formatYYYYMM") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatYYYYMM();
		}
	} else if (formatType == "formatZip") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatZip();
		}
	} else if (formatType == "formatTime8") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatTime8();
		}
	} else if (formatType == "formatTime6") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatTime6();
		}
	} else if (formatType == "formatTime4") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatTime4();
		}
	// 20130312 口座情報追加対応 本多 start
	} else if (formatType == "formatAccount") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatAccount();
		}
	// 20130312 口座情報追加対応 本多 end
	} else if (formatType == "formatAccount2") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatAccount2();
		}
	} else if (formatType == "formatApply") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatApply();
		}
	}
	else if (formatType == "formatCounsel") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatCounsel();
		}
	} else if (formatType == "formatProduct") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatProduct();
		}

// ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓
	} else if (formatType == "formatCif") {
		for (var i=0; i<fieldVals.length; i++) {
			fieldFormatVals[i] = fieldVals[i].formatCif();
		}
// ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑

	} else {

	}
	grid.setValue(fieldName,fieldFormatVals);
}

/**
 *The f3 when pressing height, the function which becomes calling
 *
 */
function fKey3(){
	var qtype = event.target.getAttribute("qtype");
	console.log("qtype :" + qtype); 
	if(!qtype) return;
	if(event.srcElement.pop == "no") return;
	if(event.srcElement.readOnly == true || event.srcElement.disabled == true){
		if(event.srcElement.onclick == null) return;
	}

	var master = document.all[event.srcElement.master];
	if (master){
		var masterLength = master.maxLength;
		var masterValue = (masterLength)? makeCode(master.value, masterLength):master.value;
		query(qtype, masterValue);
	}else{
		query(qtype,"");
	}
}

/**
 *The master, when is not the input which with the input is caught clear
 * f3 which is connected with the slave the master changes and the function which the clear does as a favor a correspondence slave
 *
 */
function clearCode(fieldName){
	if(!fieldName) return;
	if(event.propertyName != "value")return;
	fieldName.value ="";
	document.all[fieldName.name+"Lbl"].value ="";
	if(!document.all[fieldName.name+"Lbl2"]) return;
	document.all[fieldName.name+"Lbl2"].value ="";
}

/**
 *F3 query: The popup the function which leaves space the window
 *
 */
function query(type,master){
	var DptCd = top.iHeader["DPT_CD"];
	var Brn = top.iHeader["BRN"];
	var BisDate = top.iHeader["BIS_DATE"];

	window.f3field = event.srcElement;

	var length = event.srcElement.maxLength;
	/*master2, in only master3 goods cord application*/
	var master2 = document.all[event.srcElement.master2];
	var master3 = document.all[event.srcElement.master3];
	var master4 = document.all[event.srcElement.master4];
	var master5 = document.all[event.srcElement.master5];
	var master6 = document.all[event.srcElement.master6];
	master2 = (master2)? master2.value:"";
	master3 = (master3)? master3.value:"";
	master4 = (master4)? master4.value:"";
	master5 = (master5)? master5.value:"";
	master6 = (master6)? master6.value:"";

	window.f3descfield = document.all[event.srcElement.name+"Lbl"];
	window.f3descfield2 = document.all[event.srcElement.name+"Lbl2"];
	var url = top.CONTEXT+"/F3/f3.jsp?type="+type+"&length="+length+
				"&master="+master+"&master2="+master2+"&master3="+master3+
				"&master4="+master4+"&master5="+master5+"&master6="+master6+
				"&DptCd="+DptCd+"&Brn="+Brn+"&BisDate="+BisDate;

	//status = "url => "+url;
	
	var width = 420;
	if(type==110) width = 700
	winF3 = window.open(
		url,
		'son',
		'width='+width+',height=400,scrollbars=yes,resizable=no,toolbar=no,menubar=no,location=no,top=100,left=300,status=no'
		);
	winF3.focus();
}




/**
 *	show code description when you change a value in F3 field
 *
 */
function getDesc(){
	/*The onpropertychange when () the value price is changed only, application*/

	var obj = event.target || event.srcElement;

    if (!obj) return;
	/*query The number which it decides;*/
	
	if (!obj || obj.nodeType !== 1) return;
	var qtype = obj.getAttribute("qtype");
	/*The type== 3133, 3151, 3162 xml query do not exist. Only popup control*/
	if(!qtype || qtype == 17 || qtype == 19 || qtype == 20 ||
		qtype == 110  || qtype == 3133 || qtype == 3151 ||
		qtype == 3152 || qtype == 3153 || qtype == 3154 ||
		qtype == 3142 || qtype == 3143 || qtype == 3144 ||
		qtype == 3145 || qtype == 3149 || qtype == 3162 ||
		qtype == 3163 || qtype == 3164 || qtype == 3301 ||
		qtype == 3302 || qtype == 3303 || qtype == 3304 ||
		qtype == 3305 || qtype == 3306 || qtype == 3311 ||
		qtype == 3314 || qtype == 3315 || qtype == 3324 ||
		qtype == 3400 || qtype == 3423 || qtype == 3424 ||
		qtype == 3425 || qtype == 3426 || qtype == 3427 ||
		qtype == 3428 || qtype == 7100 || qtype == 8002 ||

// ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓
		qtype == 3307 || qtype == 5027 || qtype == 5101|| qtype == 5031 ||
// ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑

		// 2012/3/19 honda DELETE(NB対応_実行代わり金対応）START
        //2020/04/29  qtype 4085　EK追加 
		qtype == 4084 || qtype == 4085) return;
		// 2012/3/19 honda DELETE(NB対応_実行代わり金対応）END

	/* ｼｳｸ暲ﾌ ｵ鮴銧･ ﾇﾊｵ・ */
	var description = document.all[obj.name+"Lbl"];

	if(obj.value == "") {
		if(description) description.value = "";
	}

	var slave = document.all[obj.getAttribute("slave")];
	

	var slaveDesc;
	if(slave){
		slaveDesc = document.all[obj.getAttribute("slave")+"Lbl"];
		slave.value = "";
		if(!slaveDesc) return;
		slaveDesc.value = "";
	}
	if(obj.getAttribute("qtype") == 64 || obj.getAttribute("qtype") == 66 || obj.getAttribute("qtype") == 67){
		searchF3(obj);
	}else{
		if(!description) return;
		description.value = searchF3(obj);
	}
}

/**
 *The SUBMIT when doing, the function which checks the price where the price which corresponds to the F3 exists
 *
 */

function checkF3(obj){
	if(obj.f3ESC && obj.f3ESC == "Y") return;
	var qtype = obj.qtype;

    //20200331 EK Edit START (if items refering qytpes(4084,4085) exist in those screens, do not error-check a code, codeLbl)
    if ((document.all.trCode.value == '61100' || document.all.trCode.value == '62100' || document.all.trCode.value == '63100' ||
         document.all.trCode.value == '12040' || document.all.trCode.value == '31520' || document.all.trCode.value == '12440' ||
         document.all.trCode.value == '13300' || document.all.trCode.value == '31270' || document.all.trCode.value == '31330' ||
         document.all.trCode.value == '10010' ) && (qtype == 4084 || qtype == 4085)){
    //20200331 EK Edit END
        return;
       	/*The type== 3133, 3151, 3162 xml query do not exist not to be, price check percentage there is not a necessity.*/
        }else if( qtype == 17   || qtype == 19   || qtype == 20   ||
                  qtype == 3133 || qtype == 3142 || qtype == 3143 ||
                  qtype == 3144 || qtype == 3145 || qtype == 3149 ||
                  qtype == 3151 || qtype == 3152 || qtype == 3153 ||
                  qtype == 3154 || qtype == 3162 || qtype == 3163 ||
                  qtype == 3164 || qtype == 3301 || qtype == 3302 ||
                  qtype == 3303 || qtype == 3304 || qtype == 3305 ||
                  qtype == 3306 || qtype == 3307 || qtype == 3311 ||
                  qtype == 3314 || qtype == 3315 || qtype == 3324 ||
                  qtype == 3400 || qtype == 3423 || qtype == 3424 ||
                  qtype == 3425 || qtype == 3426 || qtype == 3427 ||
                  qtype == 3428 || qtype == 7002 || qtype == 7100 ||
                  qtype == 8001 || qtype == 8002 || 
              
                  // ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓
                  qtype == 5022 || qtype == 5026 || qtype == 5027 ||
                  qtype == 5031 || qtype == 5060 || qtype == 5029 ||
                  qtype == 5032 || qtype == 5101 || qtype == 5061 ||
                  // ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑
              
                  // 2012/3/19 honda DELETE(NB対応_実行代わり金対応）START
                  /*20200323 EK Edit START -> 20200511 EBS (ek Edit Canel) */
                  qtype == 4084 || qtype == 4085 || 
                  /* 20200323 EK Edit END  -> 20200511 EBS (ek Edit Canel) */
                  qtype == 4091 ||
                  // 2012/3/19 honda DELETE(NB対応_実行代わり金対応）END
                  qtype == 4092 ) 
        {
            if(document.all[obj.name+"Lbl"]){
                if(document.all[obj.name+"Lbl"].value == ""){
                    throw new Error(0,"200051 : "+top.getErrMsg("200051"));
                }else return;
            }else return;
        /* post address f3 check logic */
        }else if(qtype == 110){
            if(obj.type == 'hidden'){
                if(document.all[obj.name+"Lbl"].value != ""){
                    if(document.all[obj.name].value != '99999999999'){
                        if(document.all[obj.name+"Lbl2"]){
                            if(document.all[obj.name+"Lbl2"].value == ""){
                                throw new Error(0,"200051 : "+top.getErrMsg("200051"));
                            }else return;
                        }else if(document.all[obj.name+"Lbl3"]){
                            if(document.all[obj.name+"Lbl3"].value == ""){
                                throw new Error(0,"200051 : "+top.getErrMsg("200051"));
                            }else return;
                        }else return;
                    }else return;
                }else return;
            }else if(obj.type == 'text'){
                var objname = obj.name.replace("Lbl","");
                if(document.all[objname]){
                    if(document.all[objname].value  != '99999999999'){
                        if(document.all[obj.name+"2"]){
                            if(document.all[obj.name+"2"].value == ""){
                                throw new Error(0,"200051 : "+top.getErrMsg("200051"));
                            }else return;
                        }else if(document.all[obj.name+"3"]){
                            if(document.all[obj.name+"3"].value == ""){
                                throw new Error(0,"200051 : "+top.getErrMsg("200051"));
                            }else return;
                        }else return;
                    }else return;
                }else return
            }else return;
            
        }else if(!qtype) {
        return; 
        
        }else if(obj.qtype == 64 || obj.qtype == 66 || obj.qtype == 67){
            if(document.all[obj.name+"Lbl"]){
                if(document.all[obj.name+"Lbl"].value == ""){
                    throw new Error(0,"200051 : "+top.getErrMsg("200051"));
                  }else return;
              }else return;
        
        }else if(searchF3(obj) == ""){
            throw new Error(0,"200051 : "+top.getErrMsg("200051"));}
}

/**
 *Place possibility from the UI and place possibility of the DATABASE it does not agree the UI two place one time,
 * the function the cord is 4 places basically padding to make 0
 *
 */
function makeCode(code, length, tLen){
	if(tLen > 4) return code;
	if(length == 1){
		code= "000"+code
	}else if(length == 2){
		code= "00"+code
	}else if(length == 3){
		code= "0"+code
	}else{
		code = code;
	}
	return code;
}

/**
 *The xml the helpDesc it brings with the query and price rightly three thing
 *
 */
function searchF3(obj){
	
	var qtype = obj.getAttribute("qtype");


	/* With right time DPT_CD it is long(ﾀｺﾇ狷ﾚｵ・, BRN(ﾁ｡ｹ・, BIS_DATE(ｵ﨧ﾏﾀﾏ); */
	var dptCd = top.iHeader["DPT_CD"];
	var brn = top.iHeader["BRN"];
	var bisDate = top.iHeader["BIS_DATE"];

	/*query Time the green onion which is necessary meter field master2, master3 in all goods cord use*/
	var master = document.all[obj.getAttribute("master")];
	var master2 = document.all[obj.getAttribute("master2")];
	var master3 = document.all[obj.getAttribute("master3")];
	var master4 = document.all[obj.getAttribute("master4")];
	var masterLength = (master)? master.tLen:"0";
	var masterLength2 = (master2)? master2.tLen:"0";
	var masterLength3 = (master3)? master3.tLen:"0";
	var masterLength4 = (master4)? master4.tLen:"0";
	var masterValue = (master)? makeCode(master.value, master.value.length, masterLength):"";
	var master2Value = (master2)? makeCode(master2.value, master2.value.length, masterLength2):"";
	var master3Value = (master3)? makeCode(master3.value, master3.value.length, masterLength3):"";
	var master4Value = (master4)? makeCode(master4.value, master4.value.length, masterLength4):"";

	/*Code number*/
	var code = obj.value;

// ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓
	var code1= obj.value;
// ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑

	if(code=="") return "";
	var length = obj.tLen;

// 20181108 EK START
	//code = (length)? makeCode(code, obj.value.length, length): code;
	if(qtype == 26 || qtype == 28 || qtype == 32 || qtype == 101 || qtype == 105){
		code = trim(obj.value);
	} else {
		code = (length)? makeCode(code, obj.value.length, length): code;
	}
// 20181108 EK END
	var node;
	
// 20240514 Ek
	var xpath;
	
	switch(parseInt(qtype, 10)){
		case 5:
		/* //origin
			node = top.DPPGRP.selectSingleNode("/table/record[@DPT_CD='"+dptCd+"' and @GRP='"+code+
															"' and @STA = '0' ]");
		*/													
			var node_root = "/table/record[@DPT_CD='"+dptCd+"' and @GRP='"+code+"' and @STA = '0' ]";
			var node_xpath = document.evaluate(node_root, top.DPPGRP, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
	
			return (node)? node.getAttribute("SHRT_DESC"):"";
			break;

		case 6:
		/* //origin	
			node = top.EFPBKCD.selectSingleNode("/table/record[@BANK_ID='"+code+"']");
		*/	
			var node_root = "/table/record[@BANK_ID='"+code+"']";
			var node_xpath = document.evaluate(node_root, top.EFPBKCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("BANK_NAME"):"";
			break;

		case 7:
			dptCd = (masterValue)?masterValue:dptCd;
		/*  //origin
			node = top.COMBRCH.selectSingleNode("/table/record[@DPT_CD='"+dptCd+"' and @BRN='"+code+
															"' and @STA = '0']");
		*/														
			var node_root = "/table/record[@DPT_CD='"+dptCd+"' and @BRN='"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.COMBRCH, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CH_NAME"):"";
			break;

		case 10:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0007' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/														
			var node_root = "/table/record[@GRP_CD='0007' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 14:
			if(code!='9999'){
			/*  // origin	
				node = top.COMBRCH.selectSingleNode("/table/record[@BRN='"+code+
																"' and @STA = '0']");
			*/
				var node_root = "/table/record[@BRN='"+code+"' and @STA = '0']";
				var node_xpath = document.evaluate(node_root, top.COMBRCH, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
				node = node_xpath.singleNodeValue;
			
				return (node)? node.getAttribute("CH_NAME"):"";
				break;
			}else{
				return "全支店合算";
				break;
			}

		case 15:
		/*
			node = top.DPPGRP.selectSingleNode("/table/record[@DPT_CD='"+dptCd+"' and @GRP='"+code+
															"' and @TX_DATE <= '"+bisDate+
															"' and @STA = '0' "+
															" and @ACCT_VLD_DATE >='"+bisDate+"' ]");
		*/
			var node_root = "/table/record[@DPT_CD='"+dptCd+"' and @GRP='"+code+"' and @TX_DATE <= '"+bisDate+"' and @STA = '0' "+" and @ACCT_VLD_DATE >='"+bisDate+"' ]";
			var node_xpath = document.evaluate(node_root, top.DPPGRP, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_DESC"):"";
			break;

		case 18:
		/*
			node = top.DPPCHQ.selectSingleNode("/table/record[@CHQ_CODE='"+code+
															"' and @STA = '0']");
		*/
			var node_root = "/table/record[@CHQ_CODE='"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPCHQ, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("DESCR"):"";
			break;

		case 24:
		/*  // origin
			node = top.DPPGIRO.selectSingleNode("/table/record[@GIRO_CODE='"+code+
															"' and @STA = '0']");
		*/	
			var node_root = "/table/record[@GIRO_CODE='"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPGIRO, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("INST_NAME"):"";
			break;

		case 25:
		/*  // origin
			node = top.GMPPBLC.selectSingleNode("/table/record[@ACCT_CODE = '4600' and @ACCT_SEQ='"+code+
															"' and @STA = '0']");
		*/	
			var node_root = "/table/record[@ACCT_CODE = '4600' and @ACCT_SEQ='"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.GMPPBLC, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ACCT_NAME"):"";
			break;

		/*brn: When a point cord price it brings. (corresponding screen 24300) being point price, long poem*/
		case 26:
			if(obj.readOnly ||  obj.pop == "no"){
				if(code!='9999999999'){
					brn = (masterValue)?masterValue:brn;
					/*  // origin
					node = top.TLMTELR.selectSingleNode("/table/record[@DPT_CD ='"+dptCd+
																	"' and @BRN='"+brn+
																	"' and @TELR='"+code+"']");
					*/
					var node_root = "/table/record[@DPT_CD ='"+dptCd+"' and @BRN='"+brn+"' and @TELR='"+code+"']";
					var node_xpath = document.evaluate(node_root, top.TLMTELR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
					node = node_xpath.singleNodeValue;
					
					return (node)? node.getAttribute("TELR_NAME"):"";
					break;
				}else{
					return "全テラー合算";
					break;
				}
			}else{
				if(code!='9999999999'){
					brn = (masterValue)?masterValue:brn;
					/*
					node = top.TLMTELR.selectSingleNode("/table/record[@DPT_CD ='"+dptCd+
																	"' and @BRN='"+brn+
																	"' and @TELR='"+code+
																	"' and @STA = '0']");
					*/
					var node_root = "/table/record[@DPT_CD ='"+dptCd+"' and @BRN='"+brn+"' and @TELR='"+code+"' and @STA = '0']";
					var node_xpath = document.evaluate(node_root, top.TLMTELR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
					node = node_xpath.singleNodeValue;
					
					return (node)? node.getAttribute("TELR_NAME"):"";
					break;
				}else{
					return "全テラー合算";
					break;
				}
			}

		case 27:
		/*  // origin
			node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE = '0027' and @ITEM_CODE='"+code+
															"' and @STA = '0']");
		*/													
			var node_root = "/table/record[@GRP_CODE = '0027' and @ITEM_CODE='"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("FULL_NAME"):"";
			break;

		case 28:
			if(obj.readOnly ||  obj.pop == "no"){
				if(code!='9999999999'){
					/*  // origin
					node = top.TLMTELR.selectSingleNode("/table/record[@DPT_CD ='"+dptCd+
																	"' and @TELR='"+code+"']");
					*/
					var node_root = "/table/record[@DPT_CD ='"+dptCd+"' and @TELR='"+code+"']";
					var node_xpath = document.evaluate(node_root, top.TLMTELR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
					node = node_xpath.singleNodeValue;
					
					return (node)? node.getAttribute("TELR_NAME"):"";
					break;
				}else{
					return "全テラー合算";
					break;
				}
			}else{
				if(code!='9999999999'){
					/*  //origin
					node = top.TLMTELR.selectSingleNode("/table/record[@DPT_CD ='"+dptCd+
																	"' and @TELR='"+code+
																	"' and @STA = '0']");
					*/												
					var node_root = "/table/record[@DPT_CD ='"+dptCd+"' and @TELR='"+code+"' and @STA = '0']";
					var node_xpath = document.evaluate(node_root, top.TLMTELR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
					node = node_xpath.singleNodeValue;
					
					return (node)? node.getAttribute("TELR_NAME"):"";
					break;
				}else{
					return "全テラー合算";
					break;
				}
			}

		case 32:
			if(obj.readOnly ||  obj.pop == "no"){
				if(code!='9999999999'){
					/*  // origin
					node = top.TLMTELR.selectSingleNode("/table/record[@DPT_CD ='"+dptCd+
																	"' and @BRN='"+brn+
																	"' and @TELR='"+code+"']");
					*/
					var node_root = "/table/record[@DPT_CD ='"+dptCd+"' and @BRN='"+brn+"' and @TELR='"+code+"']";
					var node_xpath = document.evaluate(node_root, top.TLMTELR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
					node = node_xpath.singleNodeValue;
					
					return (node)? node.getAttribute("TELR_NAME"):"";
					break;
				}else{
					return "全テラー合算";
					break;
				}
			}else{
				if(code!='9999999999'){
					/*
					node = top.TLMTELR.selectSingleNode("/table/record[@DPT_CD ='"+dptCd+
																	"' and @BRN='"+brn+
																	"' and @TELR='"+code+
																	"' and @STA = '0']");
					*/
					var node_root = "/table/record[@DPT_CD ='"+dptCd+"' and @BRN='"+brn+"' and @TELR='"+code+"' and @STA = '0']";
					var node_xpath = document.evaluate(node_root, top.TLMTELR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
					node = node_xpath.singleNodeValue;
					
					return (node)? node.getAttribute("TELR_NAME"):"";
					break;
				}else{
					return "全テラー合算";
					break;
				}
			}

		case 35:
		/*  // origin
			node = top.GLPNAME.selectSingleNode("/table/record[@GL='"+code+
															"' and @STAT= '0' "+
															" and @GL >= '40000000']");
		*/	
			var node_root = "/table/record[@GL='"+code+"' and @STAT= '0' "+" and @GL >= '40000000']";
			var node_xpath = document.evaluate(node_root, top.GLPNAME, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("L_NAME"):"";
			break;

		case 36:
		/*  // origin
			node = top.COMMSFC.selectSingleNode("/table/record[@DPT_CD='"+code+
															"' and @STA = '0']");
		*/	
			var node_root = "/table/record[@DPT_CD='"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.COMMSFC, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("JP_NAME"):"";
			break;

		case 38:
		/*  //  origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0001' and @ITEM_CD='"+code+
															"' and (@ITEM_CD != '0100'"+
															" and @ITEM_CD != '0110'"+
															" and @ITEM_CD != '0710')"+
															" and @STA != '09']");
		*/												
			var node_root = "/table/record[@GRP_CD = '0001' and @ITEM_CD='"+code+"' and (@ITEM_CD != '0100'"+" and @ITEM_CD != '0110'"+" and @ITEM_CD != '0710')"+" and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 39:
		/*  // origin
			node = top.GLPNAME.selectSingleNode("/table/record[@GL='"+code+
															"' and @STAT = '0']");
		*/	
			var node_root = "/table/record[@GL='"+code+"' and @STAT = '0']";
			var node_xpath = document.evaluate(node_root, top.GLPNAME, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("L_NAME"):"";
			break;

		case 40:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0001' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0001' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 42:
		/*  // origin
			node = top.GLPNAME.selectSingleNode("/table/record[@GL='"+code+
															"' and @STAT = '0']");
		*/	
			var node_root = "/table/record[@GL='"+code+"' and @STAT = '0']";
			var node_xpath = document.evaluate(node_root, top.GLPNAME, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("S_NAME"):"";
			break;

		case 43:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0021' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0021' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 44:
		/*  //  origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0028' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0028' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 45:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0045' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0045' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 46:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0046' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0046' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 47:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0047' and @ITEM_CD='"+code+
															"' and @STA = '00']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0047' and @ITEM_CD='"+code+"' and @STA = '00']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)?node.getAttribute("ITEM_DESC"):"";
			break;

		case 48:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0002' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0002' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 49:
		/*  // origin  
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0048' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0048' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 50:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0020' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/													
			var node_root = "/table/record[@GRP_CD = '0020' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 51:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0027' and @ITEM_CD='"+code+
																"' and @STA != '09']");
		*/														
			var node_root = "/table/record[@GRP_CD = '0027' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 52:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0003' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0003' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 53:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0061' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0061' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 54:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0014' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/													
			var node_root = "/table/record[@GRP_CD = '0014' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 55:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0030' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0030' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 56:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0056' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0056' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 60:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0009' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/													
			var node_root = "/table/record[@GRP_CD = '0009' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 61:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0011' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0011' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 62:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0001' and @ITEM_CD='"+code+
															"' and (@ITEM_CD = '0100'"+
															" or @ITEM_CD = '0110'"+
															" or @ITEM_CD = '0710')"+
															" and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0001' and @ITEM_CD='"+code+"' and (@ITEM_CD = '0100'"+" or @ITEM_CD = '0110'"+" or @ITEM_CD = '0710')"+" and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 63:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0050' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0050' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 64:
			var description = document.all[obj.name+"Lbl"];
			var description2 = document.all[obj.name+"Lbl2"];
			/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0053' and @ITEM_CD='"+code+
															"' and @STA != '09']");
			*/
			var node_root = "/table/record[@GRP_CD = '0053' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;

			if(description) description.value = (node)? node.getAttribute("LG_DESC"):"";;
			if(description2) description2.value = (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 65:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0051' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0051' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 66:
			var description = document.all[obj.name+"Lbl"];
			var description2 = document.all[obj.name+"Lbl2"];			
			/* origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0057' and @ITEM_CD='"+code+
															"' and @STA != '09']");
			*/
			var node_root = "/table/record[@GRP_CD = '0057' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			if(description) description.value = (node)? node.getAttribute("LG_DESC"):"";;
			if(description2) description2.value = (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 67:
			var description = document.all[obj.name+"Lbl"];
			var description2 = document.all[obj.name+"Lbl2"];
			/* origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0058' and @ITEM_CD='"+code+
															"' and @STA != '09']");
			*/
			var node_root = "/table/record[@GRP_CD = '0058' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			if(description) description.value = (node)? node.getAttribute("LG_DESC"):"";;
			if(description2) description2.value = (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 69:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0059' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0059' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 70:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0060' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0060' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 71:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0061' and @ITEM_CD='"+code+
															"' and @ITEM_CD != '0001' "+
															" and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0061' and @ITEM_CD='"+code+"' and @ITEM_CD != '0001' "+" and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 72:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0061' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0061' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 73:

			if(code!='999999'){
				/*  // origin
				node = top.COMTXCD.selectSingleNode("/table/record[@DPT_CD='"+dptCd+"' and @TX_CODE="+code+
															" and @STA = '0']");
				*/
				var node_root = "/table/record[@DPT_CD='"+dptCd+"' and @TX_CODE="+code+" and @STA = '0']";
				var node_xpath = document.evaluate(node_root, top.COMTXCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
				node = node_xpath.singleNodeValue;
				
				return (node)? node.getAttribute("FULL_DESC"):"";
				break;

			}else{
				return "全取引合算";
				break;
			}

		case 74:
		/*
			node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE = '0002' and @ITEM_CODE='"+code+
															"' and @STA = '0']");
		*/	
			var node_root = "/table/record[@GRP_CODE = '0002' and @ITEM_CODE='"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("FULL_NAME"):"";
			break;

		case 75:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0047' and @ITEM_CD='"+code+
															"' and @STA = '99']");
		*/	
			var node_root = "/table/record[@GRP_CD = '0047' and @ITEM_CD='"+code+"' and @STA = '99']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 78:

		case 3100:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 501 and @CODE_5="+code+
															" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/													
			var node_root = "/table/record[@CODE_KIND = 501 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 79:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 1 and @CODE_5="+code+
															" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/	
			var node_root = "/table/record[@CODE_KIND = 1 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 80:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 738 and @CODE_5="+code+
															" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/													
			var node_root = "/table/record[@CODE_KIND = 738 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 81:
		/*  // origin
			node = top.DPPGRP.selectSingleNode("/table/record[@DPT_CD='"+dptCd+"' and @GRP='"+code+
															"' and @STA='0' "+
															" and @GRP_TYPE = 's'"+
															" and @GRP_CD = 'l'"+
															" and (@GRP_DTL_CD = 'l' or @GRP_DTL_CD = 'b')]");
		*/	
			var node_root = "/table/record[@DPT_CD='"+dptCd+"' and @GRP='"+code+"' and @STA='0' "+" and @GRP_TYPE = 's'"+" and @GRP_CD = 'l'"+" and (@GRP_DTL_CD = 'l' or @GRP_DTL_CD = 'b')]";
			var node_xpath = document.evaluate(node_root, top.DPPGRP, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("SHRT_DESC"):"";
			break;

		case 82:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 744 and @CODE_5="+code+
															" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/	
			var node_root = "/table/record[@CODE_KIND = 744 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 84:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 84 and @CODE_5="+code+
															" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/	
			var node_root = "/table/record[@CODE_KIND = 84 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
		
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 85:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 85 and @CODE_5="+code+
															" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/													
			var node_root = "/table/record[@CODE_KIND = 85 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 88:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='"+code+
															"' and @STA !='09']");
		*/													
			var node_root = "/table/record[@GRP_CD='"+code+"' and @STA !='09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("GRP_DESC"):"";
			break;

		/*masterValue: It brings a price like that. (corresponding screen 36010, 36040);*/
		case 89:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='"+masterValue+
															"' and @ITEM_CD='"+code+
															"' and @STA !='09']");
		*/													
			var node_root = "/table/record[@GRP_CD='"+masterValue+"' and @ITEM_CD='"+code+"' and @STA !='09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)?node.getAttribute("ITEM_DESC"):"";
			break;

		case 92:
		/*  // origin
			node = top.GLPNAME.selectSingleNode("/table/record[@GL='"+code+
															"' and @STAT = '0'"+
															" and @GL > '39999999']");
		*/													
			var node_root = "/table/record[@GL='"+code+"' and @STAT = '0'"+" and @GL > '39999999']";
			var node_xpath = document.evaluate(node_root, top.GLPNAME, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("L_NAME"):"";
			break;

		case 93:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0061' and @ITEM_CD='"+code+
															"' and @ITEM_CD != '0001'"+
															" and @ITEM_CD != '0099'"+
															" and @STA != '09']");
		*/													
			var node_root = "/table/record[@GRP_CD = '0061' and @ITEM_CD='"+code+"' and @ITEM_CD != '0001'"+" and @ITEM_CD != '0099'"+" and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 94:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0075' and @LG_CD='"+code+
															"' and @STA != '09']");
		*/													
			var node_root = "/table/record[@GRP_CD = '0075' and @LG_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("LG_DESC"):"";
			break;

		case 96:
		/*  // origin
			node = top.DPPGRP.selectSingleNode("/table/record[@DPT_CD ='"+dptCd+"' and @GRP='"+code+
															"' and @TX_DATE <='"+bisDate+
															"' and @STA = '0'"+
															"  and @ACCT_VLD_DATE >='"+bisDate+
															"' and (@GRP='1100' or @GRP='1300' or @GRP='2400')]");
		*/													
			var node_root = "/table/record[@DPT_CD ='"+dptCd+"' and @GRP='"+code+"' and @TX_DATE <='"+bisDate+"' and @STA = '0'"+"  and @ACCT_VLD_DATE >='"+bisDate+"' and (@GRP='1100' or @GRP='1300' or @GRP='2400')]";
			var node_xpath = document.evaluate(node_root, top.DPPGRP, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_DESC"):"";
			break;

		case 97:
		/*  // origin
			node = top.GLPNAME.selectSingleNode("/table/record[@GL='"+code+
															"' and @STAT ='0'"+
															" and @GL >= '12000000'"+
															" and @GL <= '12199999']");
		*/													
			var node_root = "/table/record[@GL='"+code+"' and @STAT ='0'"+" and @GL >= '12000000'"+" and @GL <= '12199999']";
			var node_xpath = document.evaluate(node_root, top.GLPNAME, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("L_NAME"):"";
			break;

		case 98:
		/*  // origin
			node = top.GLPNAME.selectSingleNode("/table/record[@GL='"+code+
															"' and @STAT ='0'"+
															" and @GL >= '50200000'"+
															" and @GL <= '50299999']");
		*/													
			var node_root = "/table/record[@GL='"+code+"' and @STAT ='0'"+" and @GL >= '50200000'"+" and @GL <= '50299999']";
			var node_xpath = document.evaluate(node_root, top.GLPNAME, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("L_NAME"):"";
			break;

		case 1100:
		/*  // origin
			node = top.GLPNAME.selectSingleNode("/table/record[@GL='"+code+
															"' and @STAT ='0'"+
															" and @GL > '49999999'"+
															" and @GL < '60000000']");
		*/	
			var node_root = "/table/record[@GL='"+code+"' and @STAT ='0'"+" and @GL > '49999999'"+" and @GL < '60000000']";
			var node_xpath = document.evaluate(node_root, top.GLPNAME, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("L_NAME"):"";
			break;

		case 99:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 73 and @CODE_5="+code+
															" and @STA='1'"+
															" and @CODE_5 != 0]");
		*/													
			var node_root = "/table/record[@CODE_KIND = 73 and @CODE_5="+code+" and @STA='1'"+" and @CODE_5 != 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 100:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 73 and @CODE_5="+code+
															" and @STA = '1'"+
															" and @CODE_5 != 0"+
															" and @CODE_5 != 1"+
															" and @CODE_5 != 5]");
		*/													
			var node_root = "/table/record[@CODE_KIND = 73 and @CODE_5="+code+" and @STA = '1'"+" and @CODE_5 != 0"+" and @CODE_5 != 1"+" and @CODE_5 != 5]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 101:
		/*  // origin
				node = top.TLMTELR.selectSingleNode("/table/record[@DPT_CD ='"+dptCd+
																"' and @BRN='"+brn+
																"' and @TELR='"+code+"']");
		*/														
			var node_root = "/table/record[@DPT_CD ='"+dptCd+"' and @BRN='"+brn+"' and @TELR='"+code+"']";
			var node_xpath = document.evaluate(node_root, top.TLMTELR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("TELR_NAME"):"";
			break;

		case 102:
		/*  // origin
			node = top.COPCHNL.selectSingleNode("/table/record[@DPT_CD='"+dptCd+"' and @CHANNEL_CD="+code+"]");
		*/	
			var node_root = "/table/record[@DPT_CD='"+dptCd+"' and @CHANNEL_CD="+code+"]";
			var node_xpath = document.evaluate(node_root, top.COPCHNL, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_DESC"):"";
			break;

		/*masterValue: It brings a cord type price. (the corresponding screen = 36080);*/
		case 103:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0065' and @LG_CD='"+masterValue+
															"' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/													
			var node_root = "/table/record[@GRP_CD='0065' and @LG_CD='"+masterValue+"' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 104:
		/*  // origin
			node = top.COMTXCD.selectSingleNode("/table/record[@TX_CODE="+code+
															" and @STA = '0'"+
															" and (@TX_CODE='012020' or @TX_CODE='013400')]");
		*/													
			var node_root = "/table/record[@TX_CODE="+code+" and @STA = '0'"+" and (@TX_CODE='012020' or @TX_CODE='013400')]";
			var node_xpath = document.evaluate(node_root, top.COMTXCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("FULL_DESC"):"";
			break;

		case 105:
		/*  // origin
			node = top.TLMTELR.selectSingleNode("/table/record[@DPT_CD ='"+dptCd+"' and @TELR='"+code+
															"' and @STA = '0']");
		*/													
			var node_root = "/table/record[@DPT_CD ='"+dptCd+"' and @TELR='"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.TLMTELR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("TELR_NAME"):"";
			break;

		case 106:
		/*  // origin
			node = top.COPAPRV.selectSingleNode("/table/record[@APRV_CODE="+code+"]");
		*/	
			var node_root = "/table/record[@APRV_CODE="+code+"]";
			var node_xpath = document.evaluate(node_root, top.COPAPRV, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("APRV_DESC"):"";
			break;

		case 107:
		/*  // origin
			node = top.DPPSPCD.selectSingleNode("/table/record[@SPCL_CODE='"+code+"']");
		*/	
			var node_root = "/table/record[@SPCL_CODE='"+code+"']";
			var node_xpath = document.evaluate(node_root, top.DPPSPCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("FULL_NAME"):"";
			break;

		case 108:
		/*  // origin
			node = top.GLPNAME.selectSingleNode("/table/record[@GL='"+code+
															"' and @STAT = '0'"+
															" and @GL >= '40200000'"+
															" and @GL <= '49999999']");
		*/													
			var node_root = "/table/record[@GL='"+code+"' and @STAT = '0'"+" and @GL >= '40200000'"+" and @GL <= '49999999']";
			var node_xpath = document.evaluate(node_root, top.GLPNAME, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("L_NAME"):"";
			break;

		case 109:
		/*  // origin
			node = top.GLPRPNM.selectSingleNode("/table/record[@R_NO="+code+"]");
		*/	
			var node_root = "/table/record[@R_NO="+code+"]";
			var node_xpath = document.evaluate(node_root, top.GLPRPNM, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("DES"):"";
			break;

	   /* test */
	   	case 111:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0065' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/													
			var node_root = "/table/record[@GRP_CD = '0065' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

	  	case 115:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD = '0100' and @ITEM_CD='"+code+
															"' and @STA != '09']");
		*/													
			var node_root = "/table/record[@GRP_CD = '0100' and @ITEM_CD='"+code+"' and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 1124:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0024' and @LG_CD='"+code+
									"' and @STA != '09']");
		*/							
				var node_root = "/table/record[@GRP_CD='0024' and @LG_CD='"+code+"' and @STA != '09']";
				var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
				node = node_xpath.singleNodeValue;
				
				return (node)? node.getAttribute("LG_DESC"):"";
				break;

		case 1224:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0024' and @LG_CD='"+masterValue+
									"' and @STA != '09' "+
									" and @MD_CD='"+code+"']");
		*/							
				var node_root = "/table/record[@GRP_CD='0024' and @LG_CD='"+masterValue+"' and @STA != '09' "+" and @MD_CD='"+code+"']";
				var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
				node = node_xpath.singleNodeValue;
				
				return (node)? node.getAttribute("MD_DESC"):"";
				break;

		case 1324:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0024' and @MD_CD='"+masterValue+
									"' and @STA != '09' "+
									" and @MD_CD='"+code+"']");
		*/							
				var node_root = "/table/record[@GRP_CD='0024' and @MD_CD='"+masterValue+"' and @STA != '09' "+" and @MD_CD='"+code+"']";
				var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
				node = node_xpath.singleNodeValue;
				
				return (node)? node.getAttribute("ITEM_DESC"):"";
				break;

		case 1156:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0056' and @STA != '09' "+
									" and @ITEM_CD='"+code+"']");
		*/							
				var node_root = "/table/record[@GRP_CD='0056' and @STA != '09' "+" and @ITEM_CD='"+code+"']";
				var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
				node = node_xpath.singleNodeValue;
				
				return (node)? node.getAttribute("ITEM_DESC"):"";
				break;

		case 1456:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0056' and @LG_CD="+code+
									" and @STA != '09']");
		*/							
				var node_root = "/table/record[@GRP_CD='0056' and @LG_CD="+code+" and @STA != '09']";
				var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
				node = node_xpath.singleNodeValue;
				
				return (node)? node.getAttribute("LG_DESC"):"";
				break;

		case 1256:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0056' and @LG_CD='"+masterValue+
									"' and @STA != '09' "+
									" and @MD_CD="+code+"]");
		*/							
				var node_root = "/table/record[@GRP_CD='0056' and @LG_CD='"+masterValue+"' and @STA != '09' "+" and @MD_CD="+code+"]";
				var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
				node = node_xpath.singleNodeValue;
				
				return (node)? node.getAttribute("MD_DESC"):"";
				break;

		case 1356:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0056' and @MD_CD='"+masterValue+
									"' and @STA != '09' "+
									" and @ITEM_CD='"+code+"']");
		*/							
				var node_root = "/table/record[@GRP_CD='0056' and @MD_CD='"+masterValue+"' and @STA != '09' "+" and @ITEM_CD='"+code+"']";
				var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
				node = node_xpath.singleNodeValue;
				
				return (node)? node.getAttribute("ITEM_DESC"):"";
				break;

		case 1400:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = "+code+
												" and @CODE_1 = 0 "+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0 "+
												" and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = "+code+" and @CODE_1 = 0 "+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0 "+" and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3001 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='1' and @CODE_1="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 != 0 "+
												" and @CODE_2= 0 "+
												" and @CODE_3= 0 "+
												" and @CODE_4 =0 "+
												" and @CODE_5= 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='1' and @CODE_1="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 != 0 "+" and @CODE_2= 0 "+" and @CODE_3= 0 "+" and @CODE_4 =0 "+" and @CODE_5= 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3002 :
			if(masterValue == "") return "";
			/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='1' and @CODE_2="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = "+masterValue+
												" and @CODE_2 != 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 =0 "+
												" and @CODE_5 = 0]");
			*/									
			var node_root = "/table/record[@CODE_KIND ='1' and @CODE_2="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = "+masterValue+" and @CODE_2 != 0 "+" and @CODE_3 = 0 "+" and @CODE_4 =0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3003 :
			if(masterValue == "") return "";
			if(master2Value == "") return "";
			/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='1' and @CODE_3="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = "+master2Value+
												" and @CODE_2 = "+masterValue+
												" and @CODE_3 != 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0]");
			*/								
			var node_root = "/table/record[@CODE_KIND ='1' and @CODE_3="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = "+master2Value+" and @CODE_2 = "+masterValue+" and @CODE_3 != 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3004:
			if(masterValue == "") return "";
			if(master2Value == "") return "";
			if(master3Value == "") return "";
			/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='1' and @CODE_4="+code+
												"and @CODE_5 =0 and (@STA=1 or @STA=2) "+
												" and @CODE_1="+master3Value+
												" and @CODE_2="+master2Value+
												" and @CODE_3="+masterValue+
												"]");
			*/
			var node_root = "/table/record[@CODE_KIND ='1' and @CODE_4="+code+"and @CODE_5 =0 and (@STA=1 or @STA=2) "+" and @CODE_1="+master3Value+" and @CODE_2="+master2Value+" and @CODE_3="+masterValue+"]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3005 :
			if(masterValue == "") return "";
			if(master2Value == "") return "";
			if(master3Value == "") return "";
			if(master4Value == "") return "";
			/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='1' and @CODE_5="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = "+master4Value+
												" and @CODE_2 = "+master3Value+
												" and @CODE_3 = "+master2Value+
												" and @CODE_4 = "+masterValue+
												" and @CODE_5 > 0]");
			*/								
			var node_root = "/table/record[@CODE_KIND ='1' and @CODE_5="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = "+master4Value+" and @CODE_2 = "+master3Value+" and @CODE_3 = "+master2Value+" and @CODE_4 = "+masterValue+" and @CODE_5 > 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3011 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='22' and @CODE_1="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 > 0 "+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='22' and @CODE_1="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 > 0 "+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3012 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='22' and @CODE_5="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = "+masterValue+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 > 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='22' and @CODE_5="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = "+masterValue+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 > 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3021 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='6' and @CODE_1="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 > 0 "+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='6' and @CODE_1="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 > 0 "+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3022 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='6' and @CODE_2="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = '"+masterValue+
												"' and @CODE_2 > 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='6' and @CODE_2="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = '"+masterValue+"' and @CODE_2 > 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3023 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='6' and @CODE_5="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = '"+master2Value+
												"' and @CODE_2 = '"+masterValue+
												"' and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 > 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='6' and @CODE_5="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = '"+master2Value+"' and @CODE_2 = '"+masterValue+"' and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 > 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3031 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='24' and @CODE_1="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 > 0 "+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='24' and @CODE_1="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 > 0 "+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;
		case 3032 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='24' and @CODE_5="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = '"+masterValue+
												"' and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 > 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='24' and @CODE_5="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = '"+masterValue+"' and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 > 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3100:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 501 and @CODE_5="+code+
												"and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 501 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3101:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 502 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 502 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3102:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 504 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 504 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3103:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 506 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 506 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3104:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 508 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 508 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3105:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 510 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 510 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3106:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 512 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 512 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3107:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 514 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 514 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3108:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 515 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 515 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3109:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 503 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 503 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3110:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 505 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 505 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3111:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 507 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 507 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3112:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 509 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 509 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3113:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 511 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 511 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3114:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 513 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 513 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3115:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 516 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 516 and @CODE_5="+code+"and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3116:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 608 and @CODE_5="+code+
												" and @CODE_5 < 900" +
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 608 and @CODE_5="+code+" and @CODE_5 < 900" +" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3117:
		/*  // origin
			node = top.EFPEXCD.selectSingleNode("/table/record[@EXCD='"+code+"']");
		*/	
			var node_root = "/table/record[@EXCD='"+code+"']";
			var node_xpath = document.evaluate(node_root, top.EFPEXCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("EX_NAME"):"";
			break;

		case 3118:
		/*  // origin
			node = top.DPPGIRO.selectSingleNode("/table/record[@GIRO_CODE='"+code+
												"' and @GIRO_CODE > 0]");
		*/										
			var node_root = "/table/record[@GIRO_CODE='"+code+"' and @GIRO_CODE > 0]";
			var node_xpath = document.evaluate(node_root, top.DPPGIRO, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("INST_NAME"):"";
			break;

		case 3119:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 621 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 621 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3120:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 601 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 601 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3121:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 622 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 622 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3122:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 603 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 603 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3123:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 602 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 602 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3124:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 605 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 605 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3125:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 624 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 624 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3126:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 614 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 614 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3127:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 629 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 629 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3128:

		case 3129:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 630 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 630 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3130:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 615 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 615 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3131:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 620 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 620 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3132:

		case 3141:
		/*  // origin
			node = top.LNPCOAL.selectSingleNode("/table/record[@DPT_CD = '"+dptCd+
												"' and @COAL_CODE='"+code+
												"' and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@DPT_CD = '"+dptCd+"' and @COAL_CODE='"+code+"' and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCOAL, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("COAL_NM_CH"):"";
			break;

		case 3134:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 618 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 618 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3729:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 729 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 729 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3136:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 627 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 627 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3137:
		/*  //origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 640 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 640 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3138:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 641 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/	
			var node_root = "/table/record[@CODE_KIND = 641 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3139:
		/*  // origin
			node = top.LNPGRP.selectSingleNode("/table/record[@GRP ='"+code+
						"' and @APPL_DATE<='"+bisDate+"' and (@STA=1 or @STA=2) ]");
		*/				
			var node_root = "/table/record[@GRP ='"+code+"' and @APPL_DATE<='"+bisDate+"' and (@STA=1 or @STA=2) ]";
			var node_xpath = document.evaluate(node_root, top.LNPGRP, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ACCT_NAME"):"";
			break;

		case 3140:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 607 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 607 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3146:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 607 and @CODE_5="+code+
												" and @CODE_5 > 0 and @CODE_5 < 60 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 607 and @CODE_5="+code+" and @CODE_5 > 0 and @CODE_5 < 60 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3150:
		/*  // origin
			node = top.LNPREMH.selectSingleNode("/table/record[@PAYBK_MTHD_CODE ="+code+
						" and @DPT_CD ='"+dptCd+"' and (@STA=1 or @STA=2) ]");
		*/				
			var node_root = "/table/record[@PAYBK_MTHD_CODE ="+code+" and @DPT_CD ='"+dptCd+"' and (@STA=1 or @STA=2) ]";
			var node_xpath = document.evaluate(node_root, top.LNPREMH, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("PAYBK_MTHD_NAME"):"";
			break;

		case 3155:
		/*  // origin
			node = top.LNPGUAR.selectSingleNode("/table/record[@DPT_CD = '"+dptCd+
												"' and @GUAR_COMP_CODE='"+code+
												"' and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@DPT_CD = '"+dptCd+"' and @GUAR_COMP_CODE='"+code+"' and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPGUAR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("GUAR_COMP_NAME"):"";
			break;

		case 3159:
		/*  // origin
			node = top.LNPGUAR.selectSingleNode("/table/record[@DPT_CD = '"+dptCd+
												"' and @GUAR_COMP_CODE='"+code+
												"' and @STA < 40]");
		*/										
			var node_root = "/table/record[@DPT_CD = '"+dptCd+"' and @GUAR_COMP_CODE='"+code+"' and @STA < 40]";
			var node_xpath = document.evaluate(node_root, top.LNPGUAR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("GUAR_COMP_NAME"):"";
			break;

		case 3157:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 700 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 700 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3158:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 73 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 73 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3160 :

		case 3161 :

// ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓
		case 3500 :
		case 3501 :
		case 3502 :
// ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑

			/*  // origin
			node = top.GLPNAME.selectSingleNode("/table/record[@GL='"+code+"']");
			*/
			var node_root = "/table/record[@GL='"+code+"']";
			var node_xpath = document.evaluate(node_root, top.GLPNAME, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("S_NAME"):"";
			break;

		case 3170:
		/*  // origin
			node = top.COMBRCH.selectSingleNode("/table/record[@DPT_CD='"+dptCd+"' and @BRN='"+code+
												"' and @STA = '0']");
		*/										
			var node_root = "/table/record[@DPT_CD='"+dptCd+"' and @BRN='"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.COMBRCH, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CH_NAME"):"";
			break;

		case 3171:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 633 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 633 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3173:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 6 and @CODE_5="+code+
												" and @CODE_1 =5 "+
												" and @CODE_2 =2 "+
												" and @CODE_5 >= 5201 "+
												" and @CODE_5 <= 5299 "+
												" and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 6 and @CODE_5="+code+" and @CODE_1 =5 "+" and @CODE_2 =2 "+" and @CODE_5 >= 5201 "+" and @CODE_5 <= 5299 "+" and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3174 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 608 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 608 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3200:
		/*  //  origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 710 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 710 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3201:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 711 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 711 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3202:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 709 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 709 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3203:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 715 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 715 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3204:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = '022' and @CODE_5="+code+
												" and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = '022' and @CODE_5="+code+" and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3205:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 2 and @CODE_5="+code+
												" and ((@CODE_5 = 1) or (@CODE_5 = 3)) and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 2 and @CODE_5="+code+" and ((@CODE_5 = 1) or (@CODE_5 = 3)) and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3206:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 6 and @CODE_5="+code+
												" and @STA < 40]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 6 and @CODE_5="+code+" and @STA < 40]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3207:
		/*  // origin
			node = top.LNPGUAR.selectSingleNode("/table/record[@GUAR_COMP_CODE="+code+
												" and @DPT_CD ="+dptCd+" and @STA < 40]");
		*/										
			var node_root = "/table/record[@GUAR_COMP_CODE="+code+" and @DPT_CD ="+dptCd+" and @STA < 40]";
			var node_xpath = document.evaluate(node_root, top.LNPGUAR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("GUAR_COMP_NAME"):"";
			break;

		case 3208:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 717 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 717 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3209:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 719 and @CODE_5="+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 719 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3210:
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 2 and @CODE_5="+code+
												" and ((@CODE_5 = 1) or (@CODE_5 = 3) or (@CODE_5 = 4)) and (@STA=1 or @STA=2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND = 2 and @CODE_5="+code+" and ((@CODE_5 = 1) or (@CODE_5 = 3) or (@CODE_5 = 4)) and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3211:

			/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 754 and @CODE_5="+code+
											 " and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
			*/								 
			var node_root = "/table/record[@CODE_KIND = 754 and @CODE_5="+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3290:
		/*  // origin
			node = top.COMCOMB.selectSingleNode("/table/record[@CODE = 5410 and @SUB_CODE="+code+
												"]");
		*/	
			var node_root = "/table/record[@CODE = 5410 and @SUB_CODE="+code+"]";
			var node_xpath = document.evaluate(node_root, top.COMCOMB, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3300:
		/*  // origin
			node = top.COMCOMB.selectSingleNode("/table/record[@CODE = 710 and @SUB_CODE="+code+
												"]");
		*/										
			var node_root = "/table/record[@CODE = 710 and @SUB_CODE="+code+"]";
			var node_xpath = document.evaluate(node_root, top.COMCOMB, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3401 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='6' and @CODE_1="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = 9 "+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='6' and @CODE_1="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = 9 "+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3402 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='6' and @CODE_2="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = "+masterValue+
												" and @CODE_2 != 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='6' and @CODE_2="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = "+masterValue+" and @CODE_2 != 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3403 :
			if(masterValue == "") return "";
			if(master2Value == "") return "";
			/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='6' and @CODE_5="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = "+master2Value+
												" and @CODE_2 = "+masterValue+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 != 0]");
			*/									
			var node_root = "/table/record[@CODE_KIND ='6' and @CODE_5="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = "+master2Value+" and @CODE_2 = "+masterValue+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 != 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3404 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='6' and @CODE_1="+code+
												" and (@STA=1 or @STA=2) "+
												" and (@CODE_1=1 or @CODE_1=2) "+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='6' and @CODE_1="+code+" and (@STA=1 or @STA=2) "+" and (@CODE_1=1 or @CODE_1=2) "+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3405 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='6' and @CODE_1="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = 3 "+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='6' and @CODE_1="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = 3 "+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3411 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='24' and @CODE_1="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 != 0 "+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='24' and @CODE_1="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 != 0 "+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3412 :
			if(masterValue == "") return "";
			/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='24' and @CODE_5="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = "+masterValue+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 != 0]");
			*/									
			var node_root = "/table/record[@CODE_KIND ='24' and @CODE_5="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = "+masterValue+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 != 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3421 :
		/*  // origin
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='22' and @CODE_1="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 != 0 "+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 = 0]");
		*/										
			var node_root = "/table/record[@CODE_KIND ='22' and @CODE_1="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 != 0 "+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 = 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 3422 :
			if(masterValue == "") return "";
			/*
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='22' and @CODE_5="+code+
												" and (@STA=1 or @STA=2) "+
												" and @CODE_1 = "+masterValue+
												" and @CODE_2 = 0 "+
												" and @CODE_3 = 0 "+
												" and @CODE_4 = 0 "+
												" and @CODE_5 != 0]");
			*/									
			var node_root = "/table/record[@CODE_KIND ='22' and @CODE_5="+code+" and (@STA=1 or @STA=2) "+" and @CODE_1 = "+masterValue+" and @CODE_2 = 0 "+" and @CODE_3 = 0 "+" and @CODE_4 = 0 "+" and @CODE_5 != 0]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;
			
		//証券化対応の適用
		case 3430 :
		/*
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND='758' and @CODE_5="+code+ 
			                                    "and @CODE_5> 0 "+
			                                    "and (@STA= 1 or @STA= 2)]");
		*/										
			var node_root = "/table/record[@CODE_KIND='758' and @CODE_5="+code+ "and @CODE_5> 0 "+"and (@STA= 1 or @STA= 2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 4000:
		/*  // origin
			node = top.COMCOMB.selectSingleNode("/table/record[@CODE = '5320' and @SUB_CODE="+code+
												"]");
		*/										
			var node_root = "/table/record[@CODE = '5320' and @SUB_CODE="+code+"]";
			var node_xpath = document.evaluate(node_root, top.COMCOMB, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 4001:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0001' and @ITEM_CD='"+code+
												"' and @ITEM_CD != '4002'"+
												"  and @ITEM_CD != '4003'"+
												"  and @ITEM_CD != '4004'"+
												"  and @STA != '09']");
		*/										
			var node_root = "/table/record[@GRP_CD='0001' and @ITEM_CD='"+code+"' and @ITEM_CD != '4002'"+"  and @ITEM_CD != '4003'"+"  and @ITEM_CD != '4004'"+"  and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 4065:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0065' and @ITEM_CD='"+code+
												"' and @ITEM_CD != '4002'"+
												"  and @ITEM_CD != '4003'"+
												"  and @ITEM_CD != '4004'"+
												"  and @STA != '09']");
		*/										
			var node_root ="/table/record[@GRP_CD='0065' and @ITEM_CD='"+code+"' and @ITEM_CD != '4002'"+"  and @ITEM_CD != '4003'"+"  and @ITEM_CD != '4004'"+"  and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 4069:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0069' and @ITEM_CD='"+code+
												"' and @ITEM_CD != '4002'"+
												"  and @ITEM_CD != '4003'"+
												"  and @ITEM_CD != '4004'"+
												"  and @STA != '09']");
		*/										
			var node_root ="/table/record[@GRP_CD='0069' and @ITEM_CD='"+code+"' and @ITEM_CD != '4002'"+"  and @ITEM_CD != '4003'"+"  and @ITEM_CD != '4004'"+"  and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 4070:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0070' and @ITEM_CD='"+code+
												"' and @ITEM_CD != '4002'"+
												"  and @ITEM_CD != '4003'"+
												"  and @ITEM_CD != '4004'"+
												"  and @STA != '09']");
		*/										
			var node_root ="/table/record[@GRP_CD='0070' and @ITEM_CD='"+code+"' and @ITEM_CD != '4002'"+"  and @ITEM_CD != '4003'"+"  and @ITEM_CD != '4004'"+"  and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 4076:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0076' and @ITEM_CD='"+code+
												"' and @ITEM_CD != '4002'"+
												"  and @ITEM_CD != '4003'"+
												"  and @ITEM_CD != '4004'"+
												"  and @STA != '09']");
		*/										
			var node_root ="/table/record[@GRP_CD='0076' and @ITEM_CD='"+code+"' and @ITEM_CD != '4002'"+"  and @ITEM_CD != '4003'"+"  and @ITEM_CD != '4004'"+"  and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 4077:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0077' and @ITEM_CD='"+code+
												"' and @ITEM_CD != '4002'"+
												"  and @ITEM_CD != '4003'"+
												"  and @ITEM_CD != '4004'"+
												"  and @STA != '09']");
		*/										
			var node_root ="/table/record[@GRP_CD='0077' and @ITEM_CD='"+code+"' and @ITEM_CD != '4002'"+"  and @ITEM_CD != '4003'"+"  and @ITEM_CD != '4004'"+"  and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 4078:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0078' and @ITEM_CD='"+code+
												"' and @ITEM_CD != '4002'"+
												"  and @ITEM_CD != '4003'"+
												"  and @ITEM_CD != '4004'"+
												"  and @STA != '09']");
		*/										
			var node_root ="/table/record[@GRP_CD='0078' and @ITEM_CD='"+code+"' and @ITEM_CD != '4002'"+"  and @ITEM_CD != '4003'"+"  and @ITEM_CD != '4004'"+"  and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 4082:
		/*  // origin
			node = top.CIPOTCD.selectSingleNode("/table/record[@GRP_CD='0082' and @ITEM_CD='"+code+
												"' and @ITEM_CD != '4002'"+
												"  and @ITEM_CD != '4003'"+
												"  and @ITEM_CD != '4004'"+
												"  and @STA != '09']");
		*/										
			var node_root ="/table/record[@GRP_CD='0082' and @ITEM_CD='"+code+"' and @ITEM_CD != '4002'"+"  and @ITEM_CD != '4003'"+"  and @ITEM_CD != '4004'"+"  and @STA != '09']";
			var node_xpath = document.evaluate(node_root, top.CIPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("ITEM_DESC"):"";
			break;

		case 4083:
		/*  // origin
			node = top.CCMKIND.selectSingleNode("/table/record[@STA2 = '00' and @CC_CODE='"+code+"']");
		*/	
			var node_root ="/table/record[@STA2 = '00' and @CC_CODE='"+code+"']";
			var node_xpath = document.evaluate(node_root, top.CCMKIND, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CC_NAME"):"";
			break;

		case 3999:
		/*  // origin  
			node = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND = 752 and @CODE_5= "+code+
												" and @CODE_5 > 0 and (@STA=1 or @STA=2)]");
		*/										
			var node_root ="/table/record[@CODE_KIND = 752 and @CODE_5= "+code+" and @CODE_5 > 0 and (@STA=1 or @STA=2)]";
			var node_xpath = document.evaluate(node_root, top.LNPCODE, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("CODE_NAME"):"";
			break;

		case 4084:
		/*  // origin
			node = top.EFPBKCD.selectSingleNode("/table/record[@STA = '0' and @BANK_ID='"+code+"']");
		*/	
			var node_root ="/table/record[@STA = '0' and @BANK_ID='"+code+"']";
			var node_xpath = document.evaluate(node_root, top.EFPBKCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("BANK_NAME"):"";
			break;

		case 4085:
		/*  // origin
			node = top.EFPBRCD.selectSingleNode("/table/record[@STA = '0' and @BRN_ID='"+code+
												"' and @BANK_ID = '"+masterValue+"']");
		*/										
			var node_root ="/table/record[@STA = '0' and @BRN_ID='"+code+"' and @BANK_ID = '"+masterValue+"']";
			var node_xpath = document.evaluate(node_root, top.EFPBRCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("BRN_NAME"):"";
			break;

    case 4090 :
	/*  // origin
      node = top.LNPAGNT.selectSingleNode("/table/record[@STA = '1' and @AGENT_CD='"+code+"']");
	*/  
		var node_root ="/table/record[@STA = '1' and @AGENT_CD='"+code+"']";
		var node_xpath = document.evaluate(node_root, top.LNPAGNT, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
		node = node_xpath.singleNodeValue;
	  
	  return (node)? node.getAttribute("AGENT_NAME"):"";
		  break;

    case 4091 :
		  if(code == getIHeader("DPT_CD")){
			/*  // origin  
			node = top.COMMSFC.selectSingleNode("/table/record[@STA = '0' and @DPT_CD='"+code+"']");
			*/
			var node_root ="/table/record[@STA = '0' and @DPT_CD='"+code+"']";
			var node_xpath = document.evaluate(node_root, top.COMMSFC, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
		  
			return (node)? node.getAttribute("JP_NAME"):"";
		    break;
		  }else if(code != getIHeader("DPT_CD")){
			  /*  // origin
			  node = top.EFPBKCD.selectSingleNode("/table/record[@STA = '0' and @BANK_ID='"+code+"']");
			  */
				var node_root ="/table/record[@STA = '0' and @DPT_CD='"+code+"']";
				var node_xpath = document.evaluate(node_root, top.EFPBKCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
				node = node_xpath.singleNodeValue;
				
				return (node)? node.getAttribute("BANK_NAME"):"";
				break;
		  }

	// 20160321 for fx
	case 4092 :
	/*  // origin
      node = top.LNPCURR.selectSingleNode("/table/record[@STA = '1' and @AGENT_CD='"+code+"']");
	*/  
		var node_root ="/table/record[@STA = '1' and @AGENT_CD='"+code+"']";
		var node_xpath = document.evaluate(node_root, top.LNPCURR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
		node = node_xpath.singleNodeValue;
	  return (node)? node.getAttribute("CURR_NAME"):"";
	
		  break;

// ↓↓↓ 2016/08/04 EBS 李 預金V3移行試し用修正 START ↓↓↓
        /* 2009 預金テモシステム F3 code 追加 */
		case 5001:
		/*  // origin
			node = top.DPPTGRP.selectSingleNode("/table/record[@DPT_CD = '"+dptCd+
                                                        "' and @TGRP='"+code+
                                                        "' and @STA = '0']");
		*/												
			var node_root ="/table/record[@DPT_CD = '"+dptCd+ "' and @TGRP='"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPTGRP, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("DESCR"):"";
			break;

		case 5010:
		/*  // origin
			node = top.DPPGRP.selectSingleNode("/table/record[@DPT_CD = '"+dptCd+
                                                        "' and @GRP='"+code+
                                                        "' and @STA = '0']");
		*/												
			var node_root ="/table/record[@DPT_CD = '"+dptCd+"' and @GRP='"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPGRP, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_DESC"):"";
			break;

        case 5011:
		/*  // origin
            node = top.DPPGRP.selectSingleNode("/table/record[@DPT_CD = '"+dptCd+
                                                       "' and @GRP='"+code+
                                                       "' and @STA = '0' and @TX_DATE >'"+bisDate+"']");
		*/											   
			var node_root ="/table/record[@DPT_CD = '"+dptCd+"' and @GRP='"+code+"' and @STA = '0' and @TX_DATE >'"+bisDate+"']";
			var node_xpath = document.evaluate(node_root, top.DPPGRP, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_DESC"):"";
			break;

		case 5021:
		/*  // origin
			node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE  = '0031' and @ITEM_CODE = '"+code+
                                                        "' and @ITEM_CODE < '0004' and @STA = '0']");
		*/												
			var node_root ="/table/record[@GRP_CODE  = '0031' and @ITEM_CODE = '"+code+"' and @ITEM_CODE < '0004' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_NAME"):"";
			break;

		case 5023:
		/*  // origin
			node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE = '0070' and @ITEM_CODE = '"+code+
                                                        "' and @STA = '0']");
		*/												
			var node_root ="/table/record[@GRP_CODE = '0070' and @ITEM_CODE = '"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_NAME"):"";
			break;

		case 5024:
		/*  // origin
			node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE = '0035' and @ITEM_CODE = '"+code+
                                                        "' and @STA = '0']");
		*/												
			var node_root ="/table/record[@GRP_CODE = '0035' and @ITEM_CODE = '"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_NAME"):"";
			break;

		case 5025:
		/*  // origin
			node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE = '0002' and @ITEM_CODE = '"+code+
                                                        "' and @STA = '0']");
		*/												
			var node_root ="/table/record[@GRP_CODE = '0002' and @ITEM_CODE = '"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("FULL_NAME"):"";
			break;

		case 5028:
		/*  // origin
			node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE = '0067' and @ITEM_CODE = '"+code+
                                                        "' and @STA = '0']");
		*/												
			var node_root ="/table/record[@GRP_CODE = '0067' and @ITEM_CODE = '"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_NAME"):"";
			break;

		case 5030:
			/*  // origin
			node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE  = 0015 and @ITEM_CODE = "+code+
                                                        "  and @ITEM_CODE >= 0020 "+
                                                        "  and @ITEM_CODE <= 0039 "+
                                                        "  and @STA = '0']");
			*/											
			var node_root ="/table/record[@GRP_CODE  = 0015 and @ITEM_CODE = "+code+"  and @ITEM_CODE >= 0020 "+"  and @ITEM_CODE <= 0039 "+"  and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_NAME"):"";
			break;

		case 5050:
			 var code2 = code.substring(0,2);
			 var code3 = code.substring(2,3);
			 var code4 = code.substring(3,4);
			//node = top.DPPCHRG.selectSingleNode("/table/record[@DPT_CD = '"+dptCd+
            //                                            "' and @FEE_CODE||FEE_SUB_CD1||FEE_SUB_CD2 = "+code+
            //                                            "' and @STA = '0']");
			/*  // origin
			node = top.DPPCHRG.selectSingleNode("/table/record[@DPT_CD = '"+dptCd+
                                                        "' and @FEE_CODE = '"+code2+
														"' and @FEE_SUB_CD1 = '"+code3+
														"' and @FEE_SUB_CD2 = '"+code4+
                                                        "' and @STA = '0']");
			*/
			var node_root ="/table/record[@DPT_CD = '"+dptCd+"' and @FEE_CODE = '"+code2+"' and @FEE_SUB_CD1 = '"+code3+"' and @FEE_SUB_CD2 = '"+code4+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPCHRG, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			//alert("searchF3node:"+node.getAttribute("DESCR"));
			return (node)? node.getAttribute("DESCR"):"";
			break;

		case 5100:
		/*  // origin
			node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE = '"+code+
                                                        "' and @STA = '0']");
		*/												
			var node_root ="/table/record[@GRP_CODE = '"+code+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("GRP_DESC"):"";
			break;

		case 5102:
		/*  // origin
			node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE='0049' "+
			                                            "  and (@ITEM_CODE = '"+code+"' or @ITEM_CODE = '0"+code+"')"+
			                                            "  and @ITEM_CODE >= '0101' "+
			                                            "  and @ITEM_CODE <= '0113' "+
			                                            "  and @STA = '0']");
		*/												
		    var node_root ="/table/record[@GRP_CODE='0049' "+"  and (@ITEM_CODE = '"+code+"' or @ITEM_CODE = '0"+code+"')"+"  and @ITEM_CODE >= '0101' "+"  and @ITEM_CODE <= '0113' "+"  and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_NAME"):"";
		    break;

		case 5103:
		/*  // origin
			node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE='0049' and @ITEM_CODE ='"+code+
			                                            "' and @ITEM_CODE >= '0121' "+
			                                            "  and @ITEM_CODE <= '0135' "+
			                                            "  and @STA = '0']");
		*/												
		    var node_root ="/table/record[@GRP_CODE='0049' and @ITEM_CODE ='"+code+"' and @ITEM_CODE >= '0121' "+"  and @ITEM_CODE <= '0135' "+"  and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_NAME"):"";
		    break;

		case 5105:
		/*  // origin
		    node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE='0053' and @STA=0"+
		                                                  "  and @ITEM_CODE='"+code+"']");
		*/												  
		    var node_root ="/table/record[@GRP_CODE='0053' and @STA=0"+"  and @ITEM_CODE='"+code+"']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_NAME"):"";
		    break;

		case 5106:
		/*  // origin
		    node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE='0052' and @STA=0"+
		                                                  "  and @ITEM_CODE='"+code+"']");
		*/												  
		    var node_root ="/table/record[@GRP_CODE='0052' and @STA=0"+"  and @ITEM_CODE='"+code+"']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("SHRT_NAME"):"";
		    break;

		case 5031:
		/*  // origin
			node = top.DPPTAXR.selectSingleNode("/table/record[@DPT_CD = '"+dptCd+
			                                            "' and @TAX_CODE = '"+code1+
                                                        "' and @STA = '0']");
		*/												
			var node_root ="/table/record[@DPT_CD = '"+dptCd+"' and @TAX_CODE = '"+code1+"' and @STA = '0']";
			var node_xpath = document.evaluate(node_root, top.DPPTAXR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			
			return (node)? node.getAttribute("DESCR"):"";
			break;

		case 5104:
		/*  // origin
		     node = top.DPPOTCD.selectSingleNode("/table/record[@GRP_CODE='0027' and @ITEM_CODE='"+code+
		                                                 "' and @STA ='0']");
		*/												 
		    var node_root ="/table/record[@GRP_CODE='0027' and @ITEM_CODE='"+code+"' and @STA ='0']";
			var node_xpath = document.evaluate(node_root, top.DPPOTCD, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
			node = node_xpath.singleNodeValue;
			 
			return (node)? node.getAttribute("SHRT_NAME"):"";
		    break;
// ↑↑↑ 2016/08/04 EBS 李 預金V3移行試し用修正 END   ↑↑↑

		default :
			return "";
			break;
	}
}

//20160321
function chEvent(obj,val) {
	
	var code=val;
	if(code.length == 0) return; //20160429 fx add
	/* //origin
	node = top.LNPCURR.selectSingleNode("/table/record[@STA = '1' and @CURR_CODE='"+code+"']");
	*/
	var node_root = "/table/record[@STA = '1' and @CURR_CODE='"+code+"']";
	var node_xpath = document.evaluate(node_root, top.LNPCURR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
	node = node_xpath.singleNodeValue;
		
	// 20200518 EK Edit Start
	if (!node) {
	    alertError("284");
	    return;
	};
	// 20200518 EK Edit Start
	var subnum =node.getAttribute("SUB_CURR_NUM");

  	if (obj.olen > 0 ){
  		obj.iLen = obj.olen - subnum;
	}else{
        obj.olen =obj.iLen;
  		obj.tLen =obj.olen;

  	}

	obj.fLen =subnum;

    obj.onkeydown=allowFloat; 	/* The onKeydown when the allowCodeNumber () the func it hangs in the event*/
	obj.onkeyup=checkFloat2;		/* The onKeyup when the fCurrency () the func it hangs in the event*/
	obj.style.textAlign="right";

}

//20160321 sub_curr_padding
function mask7(code,temp){
	/* //origin
	var node = top.LNPCURR.selectSingleNode("/table/record[@STA = '1' and @CURR_CODE='"+code+"']");
	*/
	var node_root = "/table/record[@STA = '1' and @CURR_CODE='"+code+"']";
	var node_xpath = document.evaluate(node_root, top.LNPCURR, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);	
	var node = node_xpath.singleNodeValue;
	
	var orgnum =unFormatComma(temp);
	var returnval;
	var subnum =node.getAttribute("SUB_CURR_NUM");
		subnum= parseInt(subnum,10);


		if(orgnum==0){
		return 0;
		}
		else if(subnum == 0){
			returnval =formatComma(orgnum);
	   }else{
			floatVal=orgnum.substring(orgnum.length-subnum,orgnum.length);
			//alert("floatVal"+floatVal);
			returnval=formatComma(parseInt(orgnum.substring(0,orgnum.length-subnum),10).toString())+"."+floatVal;
		}
		return returnval;
	}

function getStr(fieldLen){
	var str = sessionStorage.getItem("setStr");
	var index = Number(sessionStorage.getItem("index"));
	if(index > 0){
		str = str.slice(index);
	}
	var text_array = str.split('');
	var count = 0;
	var resultStr = '';
	var i = 0;
	for (i = 0; i < text_array.length; i++) {
		var n = escape(text_array[i]);
		if (n.length < 4){
			count++;
		} else if (text_array[i].match(/[ｱ-ﾝﾞﾟ]+/)){
			count++;
		} else {
			count += 2;
		}
		if (count > fieldLen) {
			break;
		}
	}
	resultStr = str.substr(0,i);
	index += i;
	sessionStorage.setItem("index",index);

	return resultStr;

}

// when "enter" press on input tag, it will not work. 
document.addEventListener('DOMContentLoaded', (event) => {
            var inputs = document.querySelectorAll('input');
            inputs.forEach(input => {
                input.addEventListener('keypress', function(event) {
                    if (event.key === 'Enter') {
                        event.preventDefault();
                    }
                });
            });
        });

</script>
</head>
<body nowrap style="font-size:9pt" leftmargin=0 topmargin=0>

<form
	class="dataform_content"
	name="dataForm"
	method="post"
	onsubmit="return checkFields()"
	target="hiddenFrame">
<input type='hidden' name='SCRIPTCHECK' value='0'>
<input type='hidden' name="msgString">
<input type='hidden' name='trCode' value='<%= request.getParameter("trCode") %>'>
<input type='hidden' name='templet' value='flow'>
<input type='hidden' name='X_VERSION'>
<ek:insert region="main"/>
</form>

<!-- PMPﾀ・ﾞ parameter form -->
<form
	name='pmpDataForm'
	method='post'>
<input type='hidden' name='pmpMsgString'><!--MSG STR-->
<input type='hidden' name='pmpPDFKind'><!--帳票種類-->
<input type='hidden' name='pmpXMLURL'><!-- XMLURL -->
<input type='hidden' name='pmpModifiedFields'><!--Approval factor fringe land item-->
<input type='hidden' name='pmpRePrint'><!--再出力可否-->
<input type='hidden' name='pmpBIS_DATE'><!--年月日-->
<input type='hidden' name='pmpOUT_TIME'><!--時分初-->
<input type='hidden' name='pmpHOST_SEQ'><!--ホスト番号-->
<input type='hidden' name='pmpGATH'><!--取引番号-->
<input type='hidden' name='pmpTELR'><!--テラー番号-->
<input type='hidden' name='pmpTERM_ID'><!--ターミナルID-->
<input type='hidden' name='pmpTX_CODE'><!--取引コード-->
<input type='hidden' name='pmpTX_NAME'><!--取引名-->
<input type='hidden' name='pmpPDFName'><!--帳票名-->
<input type='hidden' name='pmpPRNKind'><!--帳票番号-->
<input type='hidden' name='pmpSeq'><!--帳票順番-->
</form>
</body>
</html>
