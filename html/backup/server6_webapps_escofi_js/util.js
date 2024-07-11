/*
 * File name :  util.js
 * Author :
 * version : 1.0
 * Date : 2006/11/01
 */

/**
 *	The obj probably is the array, it discriminates.
 *
 */
function isArray(obj) {
	return obj.join ? true : false;
}

/**
 *	The front and after of the str it returns the string which removes the blank character which is continued.
 *
 */
function trim(str) {
	return(lTrim(rTrim(str)));
}

/**
 *	The front of the str it returns the string which removes the null string which is continued.
 *
 */
function lTrim(str) {
	var i=0;
	while (str.charAt(i) == " " || str.charAt(i) == "\t" || str.charCodeAt(i) == 12288) i++;
	return str.substring(i);
}

/**
 *	Rear of the str it returns the string which removes the null string which is continued.
 *
 */
function rTrim(str) {
	var i=str.length -1;
	while (str.charAt(i) == " " || str.charAt(i) == "\t" || str.charCodeAt(i) == 12288) i--;
	return str.substring(0, i+1);
}


/**
 *	It returns the ascii length of the str
 *
 */

function byteLength(str) {
	/*
	var length = 0;
	for (var i=0; i<str.length; i++) {
		length += str.charCodeAt(i) < 256 ? 1 : 2;
	}
	return length;
	*/

	if (str=="") {
		return 0;
	} else {
		var byteLen = 0;
		// クエリストリングは後方の半角スペースを除去しておく(自動削除を考慮)
		str = String(str);
		var qValue = str.replace(/\s+$/, '');
		if (qValue != null) {
			// ajax 同期通信
			var url = '/webaj/blength';
			var params = "para=" + qValue;
			var responseText = top.sendXMLHttpRequest(url, params);
			byteLen = Number(responseText);
		}
		// 除去した後方の半角スペース分を追加する
		var endspace = str.match(/\s+$/);
		if (endspace != null) {
			byteLen = byteLen + endspace[0].length;
		}
		return Number(byteLen);
	}
}


/**
 *	It removes the front "0" of the str
 *
 */
function intValue(str) {
	var i=0;
	while (str.charAt(i) == "0") i++;
	return str.substring(i);
}

/**
 *	The value which corresponds to the key from the cookie extraction
 *
 */
function getCookie(key) {
	var ck = document.cookie + ";";
	var index = ck.indexOf(key);
	if (index == -1) return null;
	var delimIdx = ck.indexOf(";", index);
	if (delimIdx == -1) return null;
	return ck.substring(index+key.length+1, delimIdx);
}

/**
 *	The xml which corresponds to the url with the sync mode loading
 *
 */
function loadXML(url) {
	var xhr = new XMLHttpRequest(); 
	url = top.CONTEXT + url;
    try {
        xhr.open("GET", url, false); 
        xhr.send(); 

        if (xhr.status === 200) {
            var xml = xhr.responseXML; 
            return xml;
        } else {
            console.error("HTTP Error: " + xhr.status + " " + xhr.statusText);
        }
    } catch (e) {
        console.error("XMLHttpRequest Error: " + e.message);
    }
    return null;
} 

/**
 *	The xml which corresponds to the url with the sync mode loading
 *
 */
function loadXMLAbs(url) {
	var xml = new ActiveXObject("Microsoft.XMLDOM");
	xml.async = false;
	xml.load(url);
	/* The xml without being anger day is disregard */
	//if (xml.parseError.errorCode == -2146697210) return xml;
	if (xml.parseError.errorCode != 0) {
		alert(
			"XML Parse Error!\n" +
			xml.parseError.reason +
			xml.parseError.url + "\n" +
			"line:" + xml.parseError.line + " col:" + xml.parseError.linepos + "\n" +
			xml.parseError.errorCode
		);
	}
	return xml;
}

/**
 *	The xml which corresponds to the url with the sync mode loading
 *	(ModalDialog)
 */
function loadXMLModal(url,objModal) {
	var xml = new ActiveXObject("Microsoft.XMLDOM");
	xml.async = false;
	xml.load(objModal.top.CONTEXT + url);
	/* The xml without being anger day is disregard */
	//if (xml.parseError.errorCode == -2146697210) return xml;
	if (xml.parseError.errorCode != 0) {
		alert(
			"XML Parse Error!\n" +
			xml.parseError.reason +
			xml.parseError.url + "\n" +
			"line:" + xml.parseError.line + " col:" + xml.parseError.linepos + "\n" +
			xml.parseError.errorCode
		);
	}
	return xml;
}




/**
 * value == below decimal : true, value != below decimal  point:false => Return
 *
 */
function isFloat(value) {
	try {
		var intVal = parseInt(value);
	} catch (e) {
		return false;
	}
	return value != intVal;
}

/**
 *	value==a positive number : true, value != below decimal  point:false => Return
 *
 */
function isInt(value) {
	try {
		var intVal = parseInt(value);
	} catch (e) {
		return false;
	}
	return value == intVal;
}

/**
 *	from numStr getIntPart(123.456) -> 123
 *
 */
function getIntPart(num) {
	var numStr = num + "";
	var dotIndex = numStr.indexOf(".");
	if (dotIndex == -1) return numStr;

	return numStr.substr(0, dotIndex);
}

/**
 *	getFloatPart(123.456) -> 456
 *
 */
function getFloatPart(num) {
	var numStr = num + "";
	var dotIndex = numStr.indexOf(".");
	if (dotIndex == -1) return "";

	return numStr.substring(dotIndex + 1);
}

/**
 *	comma remove
 *
 */
function unFormatComma(str) {
	return str.replace(/[,]/g, "");
}

function unFormatDots(str) {
	return str.replace(/[.]/g, "");
}

/**
 *	comma insert
 *
 */
function formatComma(num) {
	idx = num.length-3;
	while(idx > 0) {
		if(num.substr(0, idx) == "-") break;
		else {
			num = num.substr(0, idx) + "," + num.substr(idx);
			idx -= 3;
		}
	}
	return num;
}

/****************************
 String.prototype funtion
*****************************/
/**
 * Hour: Minute: Second: Milli Second  (12121212 -> 12:12:12:12)
 */
function formatTime8() {
	var retVal = this.substr(0, 2) + ":";
	if(retVal=="-") return "";
	retVal += this.substr(2, 2) + ":";
	retVal += this.substr(4, 2) + ":";
	retVal += this.substr(6, 2);
	return retVal;
}

/**
 * Hour: Minute: Second (121212 -> 12:12:12)
 */
function formatTime6() {
	var retVal = this.substr(0, 2) + ":";
	if(retVal=="-") return "";
	retVal += this.substr(2, 2) + ":";
	retVal += this.substr(4, 2);
	return retVal;
}

/**
 * Hour: Minute (1212 -> 12:12)
 */
function formatTime4() {
	var retVal = this.substr(0, 2) + ":";
	if(retVal=="-") return "";
	retVal += this.substr(2, 2);
	return retVal;
}

/**
 * Account number (00000180001121234567 -> 0001-12-1234567)
 */
function formatAccount() {
	var retVal = this.substr(7, 4) + "-";
	if(retVal=="-") return "";
	retVal += this.substr(11, 2) + "-";
	retVal += this.substr(13, 7);
	return retVal;
}

/* 20130312 口座情報追加対応 本多 start */
/**
 * Account number (00000180001121234567 -> 0018-0001-12-1234567)
 */
function formatAccount2() {
	var retVal = this.substr(3, 4) + "-";
	if(retVal=="-") return "";
	retVal += this.substr(7, 4) + "-";
	retVal += this.substr(11, 2) + "-";
	retVal += this.substr(13, 7);
	return retVal;
}
/* 20130312 口座情報追加対応 本多 end */

/**
 * Consultation number (00180001200201123456 -> 0001-2002-01-123456)
 */
function formatCounsel() {
	var retVal = this.substr(4, 4) + "-";
	if(retVal=="-") return "";
	retVal += this.substr(8, 4) + "-";
	retVal += this.substr(12, 2) + "-";
	retVal += this.substr(14, 6);
	return retVal;
}

/**
 * APPLYNUMBER (00180001200212123456 -> 0001-2002-12-123456)
 */
function formatApply() {
	var retVal = this.substr(4, 4) + "-";
	if(retVal=="-") return "";
	retVal += this.substr(8, 4) + "-";
	retVal += this.substr(12, 2) + "-";
	retVal += this.substr(14, 6);
	return retVal;
}

function formatDambo() {
	var retVal = this.substr(4, 4) + "-";
	if(retVal=="-") return "";
	retVal += this.substr(8, 4) + "-";
	retVal += this.substr(12, 2) + "-";
	retVal += this.substr(14, 6);
	return retVal;
}

/**
 * Goods cord (01030030001 -> 01-03-003-0001)
 */
function formatProduct() {
	var retVal = this.substr(0, 2) + "-";
	if(retVal=="-") return "";
	retVal += this.substr(2, 2) + "-";
	retVal += this.substr(4, 3) + "-";
	retVal += this.substr(7, 4);
	return retVal;
}

/**
 * The year month and day (20061010 -> 2006-10-10)
 */
function formatYYYYMMDD() {
	var retVal = this.substr(0, 4) + "-";
	if(retVal=="-") return "";
	retVal += this.substr(4, 2) + "-";
	retVal += this.substr(6, 2);
	return retVal;
}

/**
 * year and month(200210 -> 2002-10)
 */
function formatYYYYMM() {
	var retVal = this.substr(0, 4) + "-";
	if(retVal=="-") return "";
	retVal += this.substr(4, 2);
	return retVal;
}

/**
 * Address number (1234567 -> 123-4567)
 */
function formatZip() {
	var retVal = this.substr(0, 3) + "-";
	if(retVal=="-") return "";
	retVal += this.substr(3, 4);
	return retVal;
}

/**
 * Account number (00000002941000000113 -> 1000000113)
 */
function formatCif() {
	var retVal = this.substr(10, 20);
	if(retVal=="") return "";
	return retVal;
}

String.prototype.formatTime8 = formatTime8;
String.prototype.formatTime6 = formatTime6;
String.prototype.formatTime4 = formatTime4;
String.prototype.formatAccount = formatAccount;

/* 20130312 口座情報追加対応 本多 start */
String.prototype.formatAccount2 = formatAccount2;
/* 20130312 口座情報追加対応 本多 end */

String.prototype.formatCounsel = formatCounsel;
String.prototype.formatApply = formatApply;
String.prototype.formatDambo = formatDambo;
String.prototype.formatProduct = formatProduct;
String.prototype.formatYYYYMMDD = formatYYYYMMDD;
String.prototype.formatYYYYMM = formatYYYYMM;
String.prototype.formatZip = formatZip;
String.prototype.formatCif = formatCif;

