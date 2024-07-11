/*
 * File name : util.js
 * Author : 
 * version : 1.0
 * Date : 2006/11/01
 */

/* Screen number classification help */
function fKey1() {		
}

/* In screen number direct input location movement */
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

function fKey5() {
	var radioButton = top.contents.document.all.NEW;
	if (radioButton) {
		radioButton.click();
	}
}

function fKey6() {
	var radioButton = top.contents.document.all.UPDATE;
	if (radioButton) {
		radioButton.click();
	}
}

function fKey7() {
	var radioButton = top.contents.document.all.DELETE;
	if (radioButton) {
		radioButton.click();
	}
}

function fKey8() {
	var radioButton = top.contents.document.all.QUERY;
	if (radioButton) {
		radioButton.click();
	}
}

/* operation */
function fKey9() {		
	var button = top.contents.document.all.TRANSACTION;
	if (button) {
		button.click();
	}
}

function fKey10() {
}

function fKey11() {
}

function fKey12() {
}

document.oncontextmenu = function() {
        // 2007.4.20 sck comment out
	//return false;
}

document.onhelp = function() {
	return false;
}

document.onmousemove = function() {
	return false;
}

document.onkeydown = function() {
	var keyCode = event.keyCode;
	var element = event.srcElement;

	/* keyCode = backspace */
	if (keyCode == 8) {
		if (element.tagName != "INPUT" || element.readOnly) {
			event.keyCode = 0;
			event.returnValue = false;
		}
	}

	//function key F1 ~ F12

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

	/* alt key + left arrow (history.back()) use prohibition */
	if (event.altKey) {
		if (keyCode == 37) {
			alert("Illegal access to history.");
			event.keyCode = 0;
			event.returnValue = false;
		}
	}

	/* ctrl key union form hot key use prohibition */
	if (event.ctrlKey) {
		if (keyCode >= 65 && keyCode <=90) {
			event.keyCode = 0;
			event.returnValue = false;
		}
	}
}