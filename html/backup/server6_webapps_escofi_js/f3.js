/*
 * File name :  f3.js
 * Author : 
 * version : 1.0
 * Date : 2006/11/01
 */

function insert(){
	opener.f3field.value = trim(f3form.itemcd.value);
	window.close();
}

function set() {
	var code = event.srcElement.parentElement.children[0].innerText;
	var codeDesc = event.srcElement.parentElement.children[1].innerText;
	document.all.itemcd.value = code;
	document.all.itemdesc.value = codeDesc;
}

function w1(name) {
	document.write(opener.top.getScrMsg(name));
}

function over(obj){
	var cells = obj.cells;
	for (var i=0; i<cells.length; i++) {
		cells[i].style.backgroundColor ="#3862EF";
	}
}
function out(obj){
	var cells = obj.cells;
	for (var i=0; i<cells.length; i++) {
		cells[i].style.backgroundColor ="#ffffff";
	}
}