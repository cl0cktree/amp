/*
 * File name :  main.js
 * Author : 
 * version : 1.0
 * Date : 2006/11/01
 */

/**
 *	TabUI initialization
 */
function initTab() {
	if (!document.querySelectorAll('tabItems')) return;
	var element;
	for (var i=0; i<tabItems.length; i++) {
		element = tabItems[i];
		element.onclick = new Function("tabItemSelect(" + i +")");
		element.onmouseover = new Function("tabItemMouseOver(" + i +")");
		element.onmouseout = new Function("tabItemMouseOut(" + i +")");
	}
	tabItemSelect(0);
}

/**
 *	The Tab which corresponds to the index of the TabUI activation index 0,1,2...
 */
function tabItemSelect(index) {
	for (var i=0; i<tabItems.length; i++) {
		
		/* The tabItems not to be and the display false report 
		   (the disappearTab () with this one case of security when the appearTab () controlling, not to peel in order not to be visible)
		*/
		if (tabItems[i].style.display != "none" ) {
			tabItems[i].style.display = "inline";	
			tabItems[i].style.backgroundColor = COLOR_TAB_UNSELECTED_BG;
			tabPages[i].style.display = "none";
		}
	}
	tabItems[index].style.backgroundColor = COLOR_TAB_SELECTED_BG;
	tabPages[index].style.display = "block";
}

/**
 * tab portion of TabUI this description below of security
 */
function disappearTab(tabidx) {

	if(isArray(tabidx)) {
		for (var i=0; i<tabidx.length; i++) {
			tabItems[tabidx[i]].style.display = "none";
			tabPages[tabidx[i]].style.display = "none";
		}
	} else {
		tabItems[tabidx].style.display = "none";
		tabPages[tabidx].style.display = "none";
	}	
}

/** 
 * It does to show the tab portion of the TabUI
 */
function appearTab(tabidx) {

	if(isArray(tabidx)) {
		for (var i=0; i<tabidx.length; i++) {
			tabItems[tabidx[i]].style.display = "inline";
			tabPages[tabidx[i]].style.display = "block";
		}
	} else {
		tabItems[tabidx].style.display = "inline";
		tabPages[tabidx].style.display = "block";
	}	
}


/**
 *	When the mouse cursor is located above the Tab of the TabUI, the letter color change
 */
function tabItemMouseOver(index) {
	if (tabItems[index].style.backgroundColor != COLOR_TAB_SELECTED_BG) {
		tabItems[index].style.color = COLOR_TAB_MOUSEOVER;
	}
}

/**
 *	When the mouse escapes from the Tab of the TabUI, the letter color change
 */
function tabItemMouseOut(index) {
	tabItems[index].style.color = COLOR_TAB_MOUSEOUT;
}

/**
 *	Currently the Index of the Tab which is activated returning
 */
function getSelectedTab() {
	var obj = document.querySelectorAll('tabItems');
	if (obj) {
		for (var i=0; i<obj.length; i++) {
			if (obj[i].style.backgroundColor == COLOR_TAB_SELECTED_BG) return i;
		}
	}
	return -1;
}

/**
 *	Previously Tab TabUI activation
 */
function moveFocusLeft() {
	var index = getSelectedTab();
	if (index == -1) return;
	if (--index >= 0) tabItemSelect(index);
}

/**
 *	Next Tab of TabUI activation
 */
function moveFocusRight() {
	var index = getSelectedTab();
	if (index == -1) return;
	if (++index < tabItems.length) tabItemSelect(index);
}

/**
 *	It searches the index of the tab, return
 */
function searchTab(tab) {
	var tabPages = document.querySelectorAll('tabPages');
	if (!tabPages) return -1;
	for (var i=0; i<tabPages.length; i++) {
		if (tabPages[i] == tab) return i;
	}
	return -1;
}