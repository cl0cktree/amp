/*
 * It is included it is a prevent.js which is added in the templet.jsp and the grid.html.
 *
 */
var firstFocusField;
var lastFocusField;
var tab1LastFocusField;
var tab2LastFocusField;
var tab3LastFocusField;
var tab4LastFocusField;
var winF3;

/**
 * Screen number classification help
 */
window.onfocus = function(){
	if(winF3){
		if(!winF3.closed) winF3.close();
	}
};

function fKey1() {
	var tx_code = top.contents.document.all.trCode.value;
	var url = top.CONTEXT + "/F1/f1.jsp?tx_code=0" + tx_code;
	window.open(url, "F1Window", "width=740, height=500, status=no, scrollbars=yes" ).focus();
}

/**
 * In screen number direct input location movement
 */
function fKey2() {
	var home = top.document.all.trCode;
	if (home && !home.disabled) {
		home.select();
		home.focus();
	}
}

function fKey3(){
}

function fKey4() {
}

/**
 * New registration
 */
function fKey5() {
	var radioButton = top.contents.document.all.NEW;
	if (radioButton) {
		radioButton.click();
	}
}

/**
 * modify
 */
function fKey6() {
	var radioButton = top.contents.document.all.UPDATE;
	if (radioButton) {
		radioButton.click();
	}
}

/**
 * cancle
 */
function fKey7() {
	var radioButton = top.contents.document.all.DELETE;
	if (radioButton) {
		radioButton.click();
	}
}

/**
 *  inquire
 */
function fKey8() {
	var radioButton = top.contents.document.all.QUERY;
	if (radioButton) {
		radioButton.click();
	}
}

/**
 * operation
 */
function fKey9() {
	var button = top.contents.document.all.TRANSACTION;
	if (button) {
		if(event.srcElement.onblur != null){
			try{
				alertError("12845");
			}catch(exceptioin){
				top.contents.alertError("12845");
			}finally{
				button.focus();
			}
		}else{
			button.click();
		}
	}
}

function fKey10() {
}

function fKey11() {
}

function fKey12() {
}

/**
 * mouse right button
 */
document.oncontextmenu = function() {
        // 2007.4.17 EBS sck
	//return false;
};
document.onmousemove = function() {
	return false;
};

document.onhelp = function() {
	return false;
};


document.onkeyup = function() {
	var element = event.srcElement;
	var keyCode = event.keyCode;
	if (element.tagName == "INPUT") {
		if (keyCode != 13 && keyCode != 9) {
			if(element.onpropertychange != null && element.qtype != null){
				if ((keyCode == 8 && element.value != "") || (element.value.length < 2 && !element.readOnly)) {
					element.value = element.value;
				}
			}
		}
	}
};
/**
 * keydown event
 */
document.onkeydown = function() {
	var keyCode = event.keyCode;
	var element = event.srcElement;

	/* keyCode�� backspace */
	if (keyCode == 8) {
		if (element.tagName != "INPUT" || element.readOnly) {
			event.keyCode = 0;
			event.returnValue = false;
		}
	}
	/*keyCode is ESC*/
	if(keyCode == 27){
		if(!element.value){
			event.keyCode = 0;
			event.returnValue = false;
		}
	}

	/* keyCode�� enter */
	if (keyCode == 13 || keyCode == 9) {
		if (element.tagName != "BUTTON" && element.name != "trCode") {
			if (element.tagName == "INPUT" && !element.readOnly) {
				/* If code data padding at 0 */
				if (element.mask == "01") {
					if(element.value == 0 || !element.value){
						element.value = element.value;
					}
					else element.value = padNumber(element.value,element.maxLength);
				}
				if(element.mask == "04"){
					element.value = padNumber(element.value,element.maxLength);
				}
				/*if(element.qtype == "110" && element.value != ""){
					fKey3();
				}*/
			}
			/* Last, in order not to lose the focus which when is a field, it sends the focus with the first field */
			if (lastFocusField && element == lastFocusField) {
				event.returnValue = false;
				if (firstFocusField) setFocus(firstFocusField);
				return;
			}
			if (tab1LastFocusField && element == tab1LastFocusField) {
				event.returnValue = false;
				setFocus(tab1LastFocusField);
				return;
			}
			if (tab2LastFocusField && element == tab2LastFocusField) {
				event.returnValue = false;
				setFocus(tab2LastFocusField);
				return;
			}
			if (tab3LastFocusField && element == tab3LastFocusField) {
				event.returnValue = false;
				setFocus(tab3LastFocusField);
				return;
			}
			if (tab4LastFocusField && element == tab4LastFocusField) {
				event.returnValue = false;
				setFocus(tab4LastFocusField);
				return;
			}
			event.keyCode = 9;
		}else if (element.tagName == "BUTTON") {
			if (lastFocusField && element == lastFocusField) {
				event.returnValue = false;
				if (firstFocusField) setFocus(firstFocusField);
				return;
			}
		}
	}

	/* function key F1 ~ F12 */

	if (keyCode == 112) fKey1();
	if (keyCode == 113) fKey2();
	if (keyCode == 114) fKey3();
	if (keyCode == 115) fKey4();
	if (keyCode == 116) fKey5();
	if (keyCode == 117) fKey6();
	if (keyCode == 118) fKey7();
	if (keyCode == 119) fKey8();
	if (keyCode == 120) fKey9();
	if (keyCode == 121) fKey10();
	if (keyCode == 122) fKey11();
	if (keyCode == 123) fKey12();

	/* function key use prohibition */
	if (keyCode >= 112 && keyCode <= 123) {
		event.keyCode = 0;
		event.returnValue = false;
	}

	/* alt key + left arrow (history.back() or alt key + F4(endding) use prohibition */
	if (event.altKey) {
		//alert(keyCode);
		if (keyCode == 37) {
			alert("Illegal access to history.");
			event.keyCode = 0;
			event.returnValue = false;
		}
		if (keyCode == 115) {
			alert("Illegal access to history.");
			event.keyCode = 0;
			event.returnValue = false;
		}
	}

	/* ctrl key union form hot key use prohibition but ctrl + V or ctrl + C use*/
	if (event.ctrlKey) {
		/*	if (keyCode == 80) return;
		if (keyCode >= 65 && keyCode <= 88) {
			event.keyCode = 0;
			event.returnValue = false;
		}*/



		if (keyCode == 67 || keyCode == 86) return;
		if (keyCode == 80) return;
		if (keyCode >= 65 && keyCode <67) {
			event.keyCode = 0;
			event.returnValue = false;
		}
		if (keyCode >= 68 && keyCode <=85) {
			event.keyCode = 0;
			event.returnValue = false;
		}
	}
};

/**
 * Decimal point input permission
 */
function allowFloat() {

	if (event.srcElement.keyHitFlag) {
		event.returnValue = false;
		return false;
	}
	var value = event.srcElement.value;

	event.srcElement.beforeKeydownValue = value;

	/* backspace(8),tab(9),enter(13),shift(16),end(35),home(36),�����O(�a(37),?E38),?E49),�n(40)),delete(46) */
	var controlKeys = new Array(8, 9, 13, 16, 35, 36, 37, 38, 39, 40, 46);

	/* If operation key : end */
	for (var i=0; i<controlKeys.length; i++) {
		if (controlKeys[i] == event.keyCode) return;
	}

 	/*	if not 48 ~ 57 (Top number key cord), 96 ~ 105 (right number key cord),  event false 	*/
	if ((event.keyCode < 48) || (event.keyCode > 57 && event.keyCode < 96) || (event.keyCode > 105)) event.returnValue = false;

	var length = event.srcElement.value.length;

	//if( value == '0' && length > 1){
	//	if (event.keyCode != 190 && event.keyCode != 110) event.returnValue = false;
	//}
	if( value == '0' ){
	
		if (event.keyCode != 190 && event.keyCode != 110) event.returnValue = false;
	}

	event.srcElement.hasDot = value.indexOf(".") < 0 ? false : true;

	if (event.keyCode == 110 || event.keyCode == 190) {
		event.returnValue = !event.srcElement.hasDot;

	}
	event.srcElement.keyHitFlag = true;
}

/**
 * Decimal point input checking of interest rate
 */
function checkFloat() {

	event.srcElement.keyHitFlag = false;

	var value = unFormatComma(event.srcElement.value);
	var intVal = getIntPart(value);
	var floatVal = getFloatPart(value);

	if (intVal.length > event.srcElement.iLen || floatVal.length > event.srcElement.fLen) {
		event.srcElement.value = event.srcElement.beforeKeydownValue;
	}
}

/**
 * deprecated
 */
function maskComma() {
	if (event.keyCode == 8) return;
	if (event.keyCode == 9) return;
	if (event.keyCode == 46) return;
	var value = unFormatComma(event.srcElement.value) + (event.keyCode - 48);
	var intValue = getIntPart(value);
	var floatValue = getFloatPart(value);
	event.srcElement.value = formatComma(intValue);
	if (floatValue.length > 0) event.srcElement.value += "." + floatValue;
	event.returnValue = false;
}

/**
 *	Only number input possible (onkeydown event control)
 */
function allowNumber() {

	if (event.shiftKey) {
		//event.keyCode = 0;2011/12/28 kim sunyong comment access denied to shift key
		event.returnValue = false;
	}

	/* backspace(8),tab(9),enter(13),shift(16),end(35),home(36),direction key(left (37), up(38), right(49), down(40)),delete(46) */
	var controlKeys = new Array(8, 9, 13, 16, 35, 36, 37, 38, 39, 40, 46);

	/* If operation key : end */
	for (var i=0; i<controlKeys.length; i++) {
		if (controlKeys[i] == event.keyCode) return;
	}

 	/*	if not 48 ~ 57 (Top number key cord), 96 ~ 105 (right number key cord),  event false 	*/
	if ((event.keyCode < 48) || (event.keyCode > 57 && event.keyCode < 96) || (event.keyCode > 105)) event.returnValue = false;

	/* excepts the comma length >= iLen -> event false */
	if (unFormatComma(event.srcElement.value).length >= event.srcElement.iLen) event.returnValue = false;
}

/**
 *	Only number input possible (onkeydown event control)
 */
function allowCodeNumber() {

	if (event.shiftKey) {
		//event.keyCode = 0; 2011/12/28 kim sunyong comment access denied to shift key
		event.returnValue = false;
	}

	/* backspace(8),tab(9),enter(13),shift(16),end(35),home(36),direction key(left (37), up(38), right(49), down(40)),delete(46) */
	var controlKeys = new Array(8, 9, 13,16, 35, 36, 37, 38, 39, 40, 46);

	/* If operation key : end */
	for (var i=0; i<controlKeys.length; i++) {
		if (controlKeys[i] == event.keyCode) {

//			if(event.ctrlKey == event.keyCode) break; else return;
			return;
		}
	}

 	/*	if not 48 ~ 57 (Top number key cord), 96 ~ 105 (right number key cord),  event false */
	if ((event.keyCode < 48) || (event.keyCode > 57 && event.keyCode < 96) || (event.keyCode > 105)) event.returnValue = false;


// SUJUNG
//	if ((event.keyCode < 48) || (event.keyCode > 57 && event.keyCode < 67) || (event.keyCode > 67 && event.keyCode < 86)) event.returnValue = false;
//	if ((event.keyCode > 86 && event.keyCode < 105) || (event.keyCode > 105)) event.returnValue = false;
}

/**
 * Amount of money comma process(onkeyup event control)
 */
function fCurrency() {
	if(event.keyCode != 13 && event.keyCode != 9){
		/* When 8 (backspace), 9 (tab), 46 (delete) is not and is not also the number key, end */
		if (event.keyCode != 8 && event.keyCode != 46 && ((event.keyCode < 48) || (event.keyCode > 57 && event.keyCode < 96) || (event.keyCode > 105))) return;


		/* comma process */
		event.srcElement.value = formatComma(unFormatComma(event.srcElement.value));

		/* first 0 input error check*/
		var zeroCheck = unFormatComma(event.srcElement.value) + "";
		if(event.srcElement.readOnly){
			return;
		}else{
			if(zeroCheck.substr(0,1) == '0')  {
				event.srcElement.value = formatComma(parseInt(zeroCheck,10));
				event.returnValue = true;
			}
		}
	}
}

function fCurrency2() {
	if(event.keyCode != 13 && event.keyCode != 9){
		/* When 8 (backspace), 9 (tab), 46 (delete) is not and is not also the number height, end */
		if (event.keyCode != 8 && event.keyCode != 46 && ((event.keyCode < 48) || (event.keyCode > 57 && event.keyCode < 96) || (event.keyCode > 105))) return;


		/* comma process */
		event.srcElement.value = formatComma(unFormatComma(event.srcElement.value));

		/* first 0 input error check*/
		var zeroCheck = unFormatComma(event.srcElement.value) + "";
		if(event.srcElement.readOnly){
			return;
		}else{
			if(zeroCheck.substr(0,1) == '0' && zeroCheck.length != 1)  {
				event.srcElement.value = formatComma(parseInt(zeroCheck,10));
				event.returnValue = true;
			}
		}
	}
}

function fCurrency3() {
	if(event.keyCode != 13 && event.keyCode != 9){
		/* When 8 (backspace), 9 (tab), 46 (delete) is not and is not also the number height, end */
		if (event.keyCode != 8 && event.keyCode != 46 && ((event.keyCode < 48) || (event.keyCode > 57 && event.keyCode < 96) || (event.keyCode > 105))) return;

		var floatLen = parseInt(getFloatPart(event.srcElement.value),10);

		/* comma process */
		event.srcElement.value = formatComma(unFormatComma(event.srcElement.value));

		/* first 0 input error check*/
		var zeroCheck = unFormatComma(event.srcElement.value) + "";
		if(event.srcElement.readOnly){
			return;
		}else{
			if(zeroCheck.substr(0,1) == '0' && zeroCheck.length != 1)  {
				//event.srcElement.value = formatComma(parseInt(zeroCheck,10));

				var temp = formatComma(parseInt(temp.substring(0,temp.length-floatLen),10).toString()) + "." + temp.substring(temp.length-floatLen,temp.length);
				event.srcElement.value = tmp;
				event.returnValue = true;
			}
		}
	}
}

/**
 *fx add 20160331
 */
function checkFloat2() {
	event.srcElement.keyHitFlag = false;
	if(event.srcElement.fLen == 0){
		if(event.keyCode == 190 || event.keyCode == 110){
			event.srcElement.value = event.srcElement.beforeKeydownValue;
			return;

		}
	}

	var value = unFormatComma(event.srcElement.value);
	var intVal = getIntPart(value);
	var floatVal = getFloatPart(value);

	if (intVal.length > event.srcElement.iLen || floatVal.length > event.srcElement.fLen) {
		event.srcElement.value = event.srcElement.beforeKeydownValue;
	}
	if (floatVal.length > 0 || event.keyCode == 190 || event.keyCode == 110) {
	 	event.srcElement.value =formatComma(intVal)+"."+floatVal;
	}else{
		event.srcElement.value =formatComma(intVal);
	}

	if (intVal.length > event.srcElement.iLen || floatVal.length > event.srcElement.fLen) {
		event.srcElement.value = event.srcElement.beforeKeydownValue;
	}
}


