<%@ page contentType="text/html; charset=Windows-31J" %>
<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
%>
<!DOCTYPE html>
<html lang="en">
<HEAD>
<TITLE> New Document </TITLE>
<script src="<%= request.getContextPath() %>/js/prevent.js"></script>
<script src="<%= request.getContextPath() %>/js/constant.js"></script>
<script>
	/**
	 *	menu making
	 *
	 */
	function public_genMenu(xmlNode) {
		makeTree(document.getElementById('area'), xmlNode, 0);
	}

	/**
	 *	The Tree structure of LeftMenu is made
	 *
	 */
	function makeTree(htmlParent, xmlNode, depth) {
		var nodes = xmlNode.childNodes;
		console.log("nodes" + nodes);
		var subMenu = document.createElement("span");
		subMenu.style.display = "none";
		if (depth == 0) {
			subMenu.id = "leftMenus";
		} else {
			subMenu.style.backgroundColor = "#d3d3d3";
			subMenu.style.minWidth = 224+'px';
			subMenu.style.paddingRight = 4+'px';
		}
		htmlParent.appendChild(subMenu);
		if (nodes.length == 0) return;
		for (var i=0; i<nodes.length; i++) {
			xmlNode = nodes[i];
			subMenu.appendChild(makeSpan(xmlNode, depth));
			makeTree(subMenu, xmlNode, depth + 1);
		}
	}

	/**
	 *	The Item of LeftMenu is made
	 *
	 */
	function makeSpan(xmlNode, depth) {
		var obj = document.createElement("span");
		if(xmlNode.nodeType === 1){
			var action = xmlNode.getAttribute("action");
			console.log("action :" + action);
			obj.style.display = "block";
			obj.style.width = "fit-content";
			obj.style.marginLeft = (depth * 10) + 'px';
			obj.style.marginTop = '3px';
			obj.style.fontSize = ((depth * -1)+12)+'px';
			obj.style.cursor = "pointer";
			obj.onmouseover = function() {
				this.style.color = COLOR_MENU_SELECTED_FG;
			};
			obj.onmouseout = function() {
				this.style.color = this.parentElement.style.color;
			};
			obj.onclick = action ? function() { top.execute(action); } : expand;
			action = action ? action : "+";
			var imgSrc = depth === 0 ? "menu_icon_on.gif" : "submenu_icon.gif";
			obj.innerHTML = obj.innerHTML = "<img src='<%= request.getContextPath() %>/images/" + imgSrc + "' style='margin-left:10px; margin-right:5px'>[" 
			+ action + "] " + xmlNode.getAttribute("caption") + "<br>";
			obj.title = "[" + action + "] " + xmlNode.getAttribute("caption");
		}
		
		
		return obj;
	}

	/**
	 *	LeftMenu which corresponds to num is shown
	 *
	 */
	function public_show(num) {
		 var leftMenus = document.querySelectorAll("#leftMenus");
            leftMenus.forEach(function(leftMenus) {
                leftMenus.style.display = "none";
            });
			console.log("leftMenus[num]" + leftMenus[num]);
            leftMenus[num].style.display = "block";
			leftMenus[num].style.width = "max-content";
			leftMenus[num].style.paddingLeft = 9 + "px";
            var trCode = top.document.getElementById('screenNumber');
            trCode.disabled = false;
            trCode.select();
            trCode.focus();
	}

	/**
	 *	When LeftMenu Item which has SubMenu is clicked, display non of SubMenu it displays
	 *
	 */
	function expand() {
		var target = event.target;
		console.log("expand");
        var subMenu = target.nextElementSibling;
        subMenu.style.display = subMenu.style.display === "none" ? "block" : "none";
    }
</script>	
</HEAD>
<body style="margin:0; background-color: #ededed;">
<span id="area" style="width: 100%; height: 100%; overflow: auto; font-size: 9px;"></span>
</body>
</HTML>