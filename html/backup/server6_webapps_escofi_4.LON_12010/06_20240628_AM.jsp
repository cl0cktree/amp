<%@ page contentType="text/html;charset=Windows-31J" %>
<script>var trInXml = loadXML('/codeXml/4.LON/12010_04in.xml')</script>
<script>var trOutXml = loadXML('/codeXml/4.LON/12010_04out.xml')</script>
<script>
<!-- START OF 06.JSP -->
	var oldValue = "";

	function initPage() {
//test
		var objAll = document.all;

		set("f500","f500");
		set("f408","f408");
		set("f408Lbl","f408Lbl");
		oldValue = document.all.f408.value;
		
		set("f407","f407");
		set("f407Lbl","f407Lbl");
		document.all.f407.value=(document.all.f407.value==0)?"":padNumber(document.all.f407.value,5);
		
		set("f408_1","f408_1");
		set("f408_1Lbl","f408_1Lbl");
		document.all.f408_1.value=(document.all.f408_1.value==0)?"":padNumber(document.all.f408_1.value,3);
		
	/* 1st Tab */
		//TXKIND1
		set("f1","f4");
		//Consultation number
		set("f2_1","f5_1");
		set("f2_2","f5_2");
		set("f2_3","f5_3");
		set("f2_4","f5_4");
		set("f2_5","f5_5");
		//Condition
		set("p11","f57");
		//CIF
		set("f6_1","f9_1");
		set("f6_2","f9_2");
		set("f6_3","f9_3");
		//LOANAMT
		set("f7","f12");
		set("f8","f13");

		/*Personality cord		
		/*qtype=62 of personal schedule personality cord */
		if (getOutput("f15") == "0100" || getOutput("f15") == "0110" || getOutput("f15") == "0710") {
			document.all.p2.qtype = "62";
		/*qtype=38 of personal schedule personality cord */
		} else {
			document.all.p2.qtype = "38";
		}
		set("p2","f15");
		//COMSCALE
		set("f10","f16");
		set("f12","f18");
		set("f14","f20");
		set("f16","f22");
		set("f17","f23");
		set("p18","f24"); //CIF Name
		//Address
		set("f19","f25");
		set("p20","f26");
		set("p21","f27");
		set("f22","f28");
		set("p23","f29");
		set("p24","f30");
	
	/* 2nd Tab */
		set("p3","f64");
		set("p4","f65");
		set("p5","f67");
		set("p6","f68");
		set("p7","f72");
		set("p8","f73");
		set("p9","f74");
		set("p10","f75");
	
	/* 3rd Tab */
		set("f25","f31");
		set("f26","f32");
		set("f27","f33");
		set("f28","f34");
		set("f29_old","f35");
   		selectChange2(getOutput("f34"), getOutput("f35"));	//make select f29
		checkf29();

		set("f44","f51");
		set("f45_1","f52_1");
		set("f45_2","f52_2");
		set("f45_3","f52_3");
		set("f45_4","f52_4");
		set("f45_5","f52_5");
		set("f30","f37");
		set("f31","f38");
		set("f32","f39");
		set("f33","f40");
		set("f34","f41");
		set("f35_1","f42_1");
		set("f35_2","f42_2");
		set("f35_3","f42_3");

		set("p12","f36"); /* External conservative dividing */
		if(getOutput("f36") == 1 || getOutput("f36") == 2){
			document.all.f56.pop = "no";
			document.all.f55.pop = "no";
		}
	
		set("f36","f43");
		//set("f42","f49");
		document.all.f42.value = getOutput("f49") == 0 ? "" : getOutput("f49");
		
		//set("f43","f50");
		if(getOutput("f50")){
			document.all.f43_1.value = getOutput("f50").substr(0,1);
			document.all.f43.value = getOutput("f50").substr(1,3);
		}
		set("f41","f48");
		set("f37","f44");
		set("f38","f45");
		set("f39","f46");
		set("f40","f47");
		set("f46","f53");
		set("f47","f54");
		set("f48","f55");
		set("f49","f56");

		set("f904_1","f903_1");		/*External conservative dividing*/
		set("f904_2","f903_2");
		set("f904_3","f903_3");
		set("f904_4","f903_4");
		set("f904_5","f903_5");
		if (getOutput("f904")==0) {
			document.all.f905.value = "";
		} else {
			set("f905","f904");		/*貸出総金額*/
		}
		set("f901","f915");			/*Information point*/
		//set("p901","f901");
		set("f902","f916"); 		/*Information point*/
		//set("p902","f902");
		set("f903","f917");

	/*4th tab*/
		set("f55","f62");
		set("f56","f63");
		document.all.f56.value = getOutput("f63") == 0 ? "" : getOutput("f63");

		set("f52","f59");
		document.all.f52.value=(document.all.f52.value==0)?"":document.all.f52.value;

		//set("f53","f60");
		if(getOutput("f60") == 'y' || getOutput("f60") == 'y '){
			document.all.f53.value = "y";
			setRequiredParam("f51");
			document.all.f54.disabled=false;
			document.all.f54.value = getOutput("f61");
			document.all.f54tmp.value = document.all.f54.value;
		}
		set("f54","f61");

		set("f906","f905");
		set("p906","f906");
		set("f907_1","f907_1");
		set("f907_2","f907_2");
		set("f907_3","f907_3");
		set("f908","f908");
		set("f909_1","f909_1");
		set("f909_2","f909_2");
		set("f909_3","f909_3");
		set("f910","f910");
		set("f911_1","f911_1");
		set("f911_2","f911_2");
		set("f911_3","f911_3");
		set("f912","f912");
		set("f913_1","f913_1");
		set("f913_2","f913_2");
		set("f913_3","f913_3");
		set("f914","f914");

		set("ciff907","f907_4");
		set("ciff909","f909_4");
		set("ciff911","f911_4");
		set("ciff913","f913_4");

	/* Screen initial anger control */
		/* 1 */
		var zip2=document.all.f22.value;
		document.all.zip2.value=zip2.formatZip();
		var zip1=document.all.f19.value;
		document.all.zip1.value=zip1.formatZip();

		/* 3 */
		objAll.f27.disabled = true;
		objAll.p12.disabled = true;
		objAll.f42.disabled = true;
		objAll.f43_1.disabled = true;
		objAll.f43.disabled = true;
		objAll.f41.disabled = true;

		if(getOutput("f35") == 2 || getOutput("f35") == 4){
			objAll.f43_1.disabled = false;
			objAll.f43.disabled = false;
			objAll.f41.disabled = false;
			setRequiredParam("f41");
			set("f43_1Lbl","f50Lbl");
			set("f43Lbl","f50Lbl2");
		}
		if(getOutput("f35") == 3 || getOutput("f35") == 4){
			objAll.f42.disabled = false;
		}

		document.all.f25.value=1;

		/* 4 */
		objAll.x1.style.display = "none";
		//objAll.f53.disabled = true;
		objAll.f54.disabled = true;

		document.all.f55.readOnly=true;
		document.all.f55.tabIndex='-1';
		document.all.f56.readOnly=true;
		document.all.f56.tabIndex='-1';

		document.all.sample.style.width=340;

		var val = document.all.f906.value;
		if(val == "1") {
			document.all.sample.style.width=120;
		} 

		if(document.all.f906.value==2) {
			document.all.x1.style.display='';
			if(document.all.f909_3.value == "") {
				document.all.f910.value = "";
			}
			if(document.all.f911_3.value == "") {
				document.all.f912.value = "";
			}
			if(document.all.f913_3.value == "") {
				document.all.f914.value = "";
			}
		} else {
			document.all.x1.style.display='none';
		}


		firstFocusField = objAll.f29;
		lastFocusField = objAll.f902;
		tabItemSelect(2);

		u_addrTrim("p20");
		u_addrTrim("p21");
		u_addrTrim("p23");
		u_addrTrim("p24");
		u_zeroCheck("f43_1","f43","f55");

		document.all.dptCd.value=getIHeader("DPT_CD");
		document.all.glDay.value=document.all.f35_1.value+document.all.f35_2.value+document.all.f35_3.value;
		
		if(document.all.f43_1.value != ""){
			setRequiredParam("f43");
		}

		setMsg("200007");

		checkf33();

		if(document.all.p12.value=="") {
			document.all.p12.value=getOutput("f36");
			if(getOutput("f36")==1) {
				document.all.f56.value=getOutput("f63");
				document.all.f56.readOnly=false;
				document.all.f56.tabIndex='0';
				setRequiredParam("f56");
			} else if(getOutput("f36")==2) {
				document.all.f55.value=getOutput("f62");
				document.all.f55.readOnly=false;
				document.all.f55.tabIndex='0';
				setRequiredParam("f55");
			}
		} else {
			if(getOutput("f36")==1) {
				document.all.f56.readOnly=true;
				document.all.f56.tabIndex='-1';
			} else if(getOutput("f36")==2) {
				document.all.f55.value=getOutput("f62");
				document.all.f55.readOnly=true;
				document.all.f55.tabIndex='-1';
			}
		}
	
		var productID = padNumber(document.all.f30.value, 2) + padNumber(document.all.f31.value, 2) + padNumber(document.all.f32.value, 3) + padNumber(document.all.f33.value, 4);
		var bisDate = getIHeader("BIS_DATE");
		var dptCd = getIHeader("DPT_CD");
		document.all.glDay.value = document.all.f35_1.value + document.all.f35_2.value + document.all.f35_3.value;
		var glDay = document.all.glDay.value;
		document.all.tmp1.value = dptCd;
		document.all.tmp2.value = productID;
		var xql;
		var nodeList;
		var node;	
		var maxAPPL_DATE;
		var flagGUAR_COMP;	/* External mortgage cord*/
		var codeGUAR_COMP;	/* The guarantee association end cord or the bonding company cord*/
		var flagGROUP_LIFE;	/* Group flag */
		var codeGROUP_LIFE;	/* Group code */
		//alert("===>"+document.all.glDay.value);
		
		/* max(APPL_DATE) */
		xql = "/table/record[@DPT_CD='"+dptCd+
					"' and @GRP='" +productID+ 
					"' and @APPL_DATE<='" +glDay+ 
					"' and @STA<40]";
		nodeList = top.LNPGRP.selectNodes(xql);
		//alert(xql);
		//alert("1.length:"+nodeList.length);
		if (nodeList.length == 0) return;
		
		node =  nodeList.nextNode();
		maxAPPL_DATE = node.getAttribute("APPL_DATE");
		codeGROUP_LIFE = node.getAttribute("GROUP_LIFE_CODE");
		//alert("resultaFTER==>"+codeGROUP_LIFE);
		
		for(var i =0; i<nodeList.length-1 ; i++) {
			node =  nodeList.nextNode();
			//alert(node.getAttribute("APPL_DATE"));	
			maxAPPL_DATE = (node.getAttribute("APPL_DATE") > maxAPPL_DATE ) ? node.getAttribute("APPL_DATE") : maxAPPL_DATE;
		}
		/* The GUAR_COMP_FLAG there is not a necessity which 2 times will execute the searching query it becomes the c/s and at the place flaw) */

		xql = "/table/record[@DPT_CD='"+dptCd+
					"' and @GRP='" +productID+ 
					"' and @APPL_DATE='" +maxAPPL_DATE+
					"' and @STA<40]";
		node = top.LNPGRP.selectSingleNode(xql);	
		//alert(maxAPPL_DATE);
		//alert(xql);
		
		if (!node) return;

		flagGUAR_COMP = node.getAttribute("GUAR_COMP_FLAG");
		codeGUAR_COMP = node.getAttribute("GUAR_COMP_CODE");
		flagGROUP_LIFE = node.getAttribute("GROUP_LIFE_FLAG");
		codeGROUP_LIFE = node.getAttribute("GROUP_LIFE_CODE");
               
	    if(flagGROUP_LIFE == "1" || flagGROUP_LIFE == "0" || flagGROUP_LIFE == ""){
	    	makeReadOnly(document.all.f51);
	    	setNotRequiredParam("f51");
	    	document.all.f53.value = "n";
			document.all.f51.pop = "no";
	    }
	    if (flagGROUP_LIFE == "2" ) {
	    	makeEditable(document.all.f51);
	    	setNotRequiredParam("f51");	
	    	document.all.f53.value = "n";
	    }
	    if( flagGROUP_LIFE == "3"){
	    	makeReadOnly(document.all.f51);
			document.all.f51.pop = "no";
	    }
		//set("f51","f58");		
		document.all.f51.value=(parseInt(getOutput("f58"),10)==0)?"":padNumber(getOutput("f58"),4);

		if(document.all.f408.value != ""){
			setRequiredParam("f407");
		}
			
		if(getOutput("f32") == 3) {		//f26
			document.all.f27.disabled=false;
			setRequiredParam("f27");
		}
		if(getOutput("f32") == 1 && getOutput("f34") == 3) {
			document.all.f27.disabled=false;
			setRequiredParam("f27");
		}	
		if(getOutput("f35") == 5) {
			document.all.f29.disabled=true;
			document.all.p12.disabled=true;
			firstFocusField = objAll.f902;
		}

		//20160321 fx add 
		mSelect();
		
	    var	GrpPro =	node.getAttribute("GRP_PROCESS");
        var chkYN     = GrpPro.substring(1,2);
  		
        //alert(chkYN);
	    if(chkYN == "Y"){
	    	setNotRequiredParam("f36");
	    	setRequiredParam("f100");
	    	setRequiredParam("f101");
	    	setRequiredParam("f103");
	    	
	    }else{
	    	setRequiredParam("f36");
			setNotRequiredParam("f100");
	    	setNotRequiredParam("f101");
	    	setNotRequiredParam("f103");

	    } 

  		document.all.f100.value= getOutput("f100");
 		set("f101","f101");
		set("f102","f102");
		set("f103","f103");
		set("f104","f104");
		set("f105","f105");
		set("f106","f106");
		set("f107","f107");


		enableAllBtn();
		enableExecBtn();
		
	/* Financing consultation result */
		document.all.f25.disabled = true;
		document.all.f26.disabled = true;
		document.all.f27.disabled = true;
		document.all.f28.disabled = true;
		document.all.f44.disabled = true;
		document.all.p12.disabled = true;

		document.all.f30.disabled = true;
		document.all.f30Lbl.disabled = true;
		document.all.f31.disabled = true;
		document.all.f31Lbl.disabled = true;
		document.all.f32.disabled = true;
		document.all.f32Lbl.disabled = true;
		document.all.f33.disabled = true;
		document.all.f33Lbl.disabled = true;
		document.all.f34.disabled = true;
		document.all.f34Lbl.disabled = true;
		document.all.f35_1.disabled = true;
		document.all.f35_2.disabled = true;
		document.all.f35_3.disabled = true;
		document.all.f36.disabled = true;
		document.all.f37.disabled = true;
		document.all.f37Lbl.disabled = true;
		document.all.f901.disabled = true;
		document.all.f901Lbl.disabled = true;
		document.all.f903.disabled = true;
		document.all.f903Lbl.disabled = true;		

		document.all.f55.disabled = true;
		document.all.f55Lbl.disabled = true;
		document.all.f56.disabled = true;
		document.all.f56Lbl.disabled = true;
		document.all.f54.disabled = true;

		document.all.f408.disabled = true;
		document.all.f408Lbl.disabled = true;
		document.all.f407.disabled = true;
		document.all.f407Lbl.disabled = true;
		document.all.f408_1.disabled = true;
		document.all.f408_1Lbl.disabled = true;
		document.all.f906.disabled = true;
		document.all.searchCif.disabled = true;
		Tab5alldisable(); //20160321 fxtab disable
	}  /* END OF INITPAGE. *************************************************************************/

	function checkPage(fieldArray){
		if(document.all.f407.value != "" && document.all.f407Lbl.value =="") {
			alertError("200051");
			setFocus(document.all.f407);
			return false;
		}
		if(document.all.f408.value != "" && document.all.f408Lbl.value =="") {
			alertError("200051");
			setFocus(document.all.f408);
			return false;
		}

		if(document.all.f43_1.value != "" && document.all.f43.value != ""){
			fieldArray["f43"] = document.all.f43_1.value + document.all.f43.value;
		}

		if(document.all.f46.value != ""){
			if(!checkHalfChar(document.all.f46)) return false;
		}
		if(document.all.f47.value != ""){
			if(!checkHalfChar(document.all.f47)) return false;
		}
		if(document.all.f48.value != ""){
			if(!checkHalfChar(document.all.f48)) return false;
		}
		if(document.all.f49.value != ""){
			if(!checkHalfChar(document.all.f49)) return false;
		}

		if(document.all.f904_4.value != ""){
			fieldArray["f904_1"] = getIHeader("DPT_CD");
		} else {
			fieldArray["f904_1"] = padChar("",4);
		}

		dataForm.target = "hiddenFrame";
		dataForm.action = top.CONTEXT+"/WebFacade";

		var chk2Cif=u_checkCIF(document.all["f907_3"],document.all["f909_3"],document.all["f911_3"],document.all["f913_3"]);
		if(chk2Cif!="") {
			alertError("1361");
			chk2Cif.select();
			chk2Cif.focus();
			return false;
		}

		if(document.all.f29.value == 2 || document.all.f29.value == 4){
			var f41 = parseInt(document.all.f41.value,10);
			if( f41 == 0 ){
				alertError("5702");
				setFocus(document.all.f41);
				return false;
			}
		}
		
		/* The external mortgage comes to combine in mortgage dividing, it ascends */
		fieldArray["f29"] = padNumber(document.all.p12.value + parseInt(fieldArray["f29"],10), 4);
		
		/* Thread Prearranged date checking*/
		if (!dateCheck("f35_1", "f35_2", "f35_3")) return false;

		if(document.all.f906.value==2) {
			if(u_joinCheck('p906','f908','f910','f912','f914','f906')>101) {
				alertError("12225");
				return false;
			}
		}
		return showConfirm("200002");
	}
	function flow() {
		//debugOutput(); 
		setMsg("200005");
	}
	
/***************************************************************************************************/
	
	/**
	 * makeing f29 select 
	 *
	 */	
	function selectChange2(val, ser) {	
		//alert("selectChange2 val= "+ val);	//f28
		//alert("selectChange2 ser= "+ ser);	//f29
	    var children29 = null;	//f29: 担保区分

		if(val == 3){	//f28=3
	        children29 = top.LNPCODE.selectNodes(".//record[@CODE_KIND='95' and @STA <= '40' and @CODE_5 < 6]");  	
	
		} else {
	        children29 = top.LNPCODE.selectNodes(".//record[@CODE_KIND='95' and @STA <= '40' and @CODE_5 < 5]");
		}
	    
		var str29  = "	<SELECT name='f29' onChange='doCheckInputFields(this);'>";
		    str29 += "			<OPTION value=''></OPTION>";
						for(var j=0;j<children29.length;j++) {
							if (children29[j].getAttribute("CODE_5") == "0") continue;
							
							if (children29[j].getAttribute("CODE_5") == ser) {
		    str29 += "			<OPTION value='" + children29[j].getAttribute("CODE_5") + "' selected >" + children29[j].getAttribute("CODE_NAME") + "</OPTION>";
							} else {
			str29 += "			<OPTION value='" + children29[j].getAttribute("CODE_5") + "'>" + children29[j].getAttribute("CODE_NAME") + "</OPTION>";
							}
						}
		    str29 += "	</SELECT>";

		document.all.ddf29.innerHTML = str29;
		requireField("f29");
	}
	/**
	 * Joining dividing selection control
	 *
	 */
	function doCheckBoxYN_2() {
		var obj = document.all.f53;
		if((obj.value == "y" || obj.value == "Y") && document.all.f51.value != "") {
			//obj.value = "y";	
			if(document.all.f54tmp.value) document.all.f54.value = document.all.f54tmp.value;
			//document.all.f54.disabled = false;	/* Insurance number input possibility */
			setRequiredParam("f51");
		} else {
			//obj.value = "n";
			setNotRequiredParam("f51");			/* Insurance number input being not right */
			document.all.f54.value = "";
			document.all.f54.disabled = true;
		}	
	}		
	/**
	 *  Goods cord input hour control
	 *
	 */	
	function checkf33() {
		document.all.p12.value = "";	/* External mortgage dividing reset*/
		document.all.f51.value = "";	/* Group cord reset*/
		
		initf55f56();	/* Bonding company guarantee association cord reset*/

		if (document.all.f33.value == "") return;

		/***********************************
		  External mortgage dividing searching unyielding spirit
		***********************************/		
		var productID = padNumber(document.all.f30.value, 2) + padNumber(document.all.f31.value, 2) + padNumber(document.all.f32.value, 3) + padNumber(document.all.f33.value, 4);
		var bisDate = getIHeader("BIS_DATE");
		var dptCd = getIHeader("DPT_CD");
		document.all.glDay.value = document.all.f35_1.value + document.all.f35_2.value + document.all.f35_3.value;
		var glDay = document.all.glDay.value;
		document.all.tmp1.value = dptCd;
		document.all.tmp2.value = productID;
		var xql;
		var nodeList;
		var node;	
		var maxAPPL_DATE;
		var flagGUAR_COMP;	/* External mortgage cord*/
		var codeGUAR_COMP;	/* The guarantee association end cord or the bonding company cord*/
		var flagGROUP_LIFE;	/* Group flag */
		var codeGROUP_LIFE;	/* Group code */
		//alert("===>"+document.all.glDay.value);
		
		/* max(APPL_DATE) */
		xql = "/table/record[@DPT_CD='"+dptCd+
					"' and @GRP='" +productID+ 
					"' and @APPL_DATE<='" +glDay+ 
					"' and @STA<40]";
		nodeList = top.LNPGRP.selectNodes(xql);
		//alert(xql);
		//alert("1.length:"+nodeList.length);
		if (nodeList.length == 0) return;
		
		node =  nodeList.nextNode();
		maxAPPL_DATE = node.getAttribute("APPL_DATE");
		codeGROUP_LIFE = node.getAttribute("GROUP_LIFE_CODE");
		//alert("resultaFTER==>"+codeGROUP_LIFE);
		
		for(var i =0; i<nodeList.length-1 ; i++) {
			node =  nodeList.nextNode();
			//alert(node.getAttribute("APPL_DATE"));	
			maxAPPL_DATE = (node.getAttribute("APPL_DATE") > maxAPPL_DATE ) ? node.getAttribute("APPL_DATE") : maxAPPL_DATE;
		}

		/*  The GUAR_COMP_FLAG there is not a necessity which 2 times will execute the searching query it becomes the c/s and at the place flaw)*/
		xql = "/table/record[@DPT_CD='"+dptCd+
					"' and @GRP='" +productID+ 
					"' and @APPL_DATE='" +maxAPPL_DATE+
					"' and @STA<40]";
		node = top.LNPGRP.selectSingleNode(xql);	
		//alert(maxAPPL_DATE);
		//alert(xql);
		
		if (!node) return;

		flagGUAR_COMP = node.getAttribute("GUAR_COMP_FLAG");
		codeGUAR_COMP = node.getAttribute("GUAR_COMP_CODE");
		flagGROUP_LIFE = node.getAttribute("GROUP_LIFE_FLAG");
		codeGROUP_LIFE = node.getAttribute("GROUP_LIFE_CODE");
               
		//alert("result==>"+codeGROUP_LIFE);

		document.all.p12.value = flagGUAR_COMP == 0 ? "" : flagGUAR_COMP;
		/********************************************************************
		 ﾂ??: c/sﾀﾇ query (guar_comp_flag:External mortgage it brings
		 *********************************************************************
			select guar_comp_flag
		 	from lnpgrp
			where dpt_cd    		= LIB_T.GS_DPTCD
		     		and grp       	= ?
		     		and appl_date  	= ( select max(appl_date) from lnpgrp
		                              		where dpt_cd  	= LIB_T.GS_DPTCD
		                                    and grp     	=  str_String
		                                    and appl_date 	<= LIB_T.GD_BisDate
		                                    and sta       	< 40)
		     and sta<40
		 *********************************************************************/

	    if (flagGUAR_COMP == "1") {	/* ｺｸﾁｸｻ?ﾄﾚｵ?*/
			if(document.all.p12.disabled==false){
				document.all.f56.readOnly=false;
				document.all.f56.tabIndex='0';
			}
	    	document.all.f56.value = (codeGUAR_COMP == 0)? "": padNumber(codeGUAR_COMP,4);
	    	//setRequiredParam("f56");
	    } 
	    if (flagGUAR_COMP == "2") {	/*  Guarantee association end cord*/
			if(document.all.p12.disabled==false){
				document.all.f55.readOnly=false;
				document.all.f55.tabIndex='0';
			}
	    	if(codeGUAR_COMP >= 5201 && codeGUAR_COMP <= 5299){
	    		document.all.f55.value = codeGUAR_COMP;
	    	}
	    } 	
	    if (!flagGUAR_COMP || flagGUAR_COMP == '0') {
	     	//document.all.p12.disabled = false;	
	    } 	
	    //alert("result2==>"+codeGUAR_COMP);

		/*  Group flag 1,2,3*/
	    if(flagGROUP_LIFE == "1" || flagGROUP_LIFE == "0" || flagGROUP_LIFE == ""){
	    	makeReadOnly(document.all.f51);
	    	setNotRequiredParam("f51");
	    	document.all.f53.checked = false;
	    	document.all.f53.disabled = true;
			makeReadOnly(document.all.f54);
			document.all.f51.pop = "no";
			//alert(" flagGROUP_LIFE  1");
	    }
	    if (flagGROUP_LIFE == "2" ) {
	    	makeEditable(document.all.f51);
	    	setNotRequiredParam("f51");	
	    	document.all.f53.checked = false;
			//document.all.f53.disabled = false;
			document.all.f54.readOnly = false;
			document.all.f51.pop = "";
			doCheckBoxYN_2();
			//alert(" flagGROUP_LIFE  2");
	    }
	    if( flagGROUP_LIFE == "3"){
	    	makeReadOnly(document.all.f51);
			document.all.f53.checked = true;
			document.all.f53.disabled = true;
			document.all.f54.readOnly = false;
			document.all.f51.pop = "no";
			//alert(" flagGROUP_LIFE  3");
	    }
	    
	    /* 担保区分 = 極度 */
	    if(document.all.f29.value == 5){
	    	document.all.p12.disabled = true;
		}	    
    	checkf51(codeGROUP_LIFE);    
	    doCheckBoxYN_2();
	}

	/**
	 *	Bonding company 
	 *
	 */
	function initf55f56() {
		u_zeroCheck("f51");
		//setNotRequiredParam("f56");
		document.all.f56.value = "";
		document.all.f56Lbl.value="";
		document.all.f56.readOnly=true;
		document.all.f56.tabIndex='-1';
		document.all.f56.pop="no";
        	
		document.all.f55.value = "";
		document.all.f55Lbl.value="";
		document.all.f55.readOnly=true;
		document.all.f55.tabIndex='-1';
		document.all.f55.pop="no";

		document.all.p12.disabled = true;
		setNotRequiredParam("f56");
		setNotRequiredParam("f55");
	}
	/**
	 * combo value change Line-249
	 *
	 */
	function u_combochange(){
		initf55f56();
		if(document.all.p12.value == 1){
			document.all.f56.readOnly=false;
			document.all.f56.tabIndex='0';
			document.all.f56.pop= "yes";

			setNotRequiredParam("f55");
			setRequiredParam("f56");		
		}
		if(document.all.p12.value == 2){
			document.all.f55.readOnly=false;
			document.all.f55.tabIndex='0';
			document.all.f55.pop= "yes";

			setRequiredParam("f55");
			setNotRequiredParam("f56");
		}
	}	
	/**
	 *	Debtor dividing control
	 *
	 */
	function joinType() {
		document.all.sample.style.width=340;
		lastFocusField=document.all.f902;

		document.all.ciff907.value="";
		document.all.ciff909.value="";
		document.all.ciff911.value="";
		document.all.ciff913.value="";

		document.all.f907_3.value = "";
		document.all.f908.value = "";
		document.all.f909_3.value = "";
		document.all.f910.value = "";
		document.all.f911_3.value = "";
		document.all.f912.value = "";
		document.all.f913_3.value = "";
		document.all.f914.value = "";
		var val = document.all.f906.value;
		var objp906 = document.all.p906;
		var objx1 = document.all.x1;
		if(val == "1") {
			document.all.sample.style.width=120;
			objp906.value = "100";
		} else {
			objp906.value = "";
		}		
		if(val == "2") {
			objx1.style.display = "";
		} else {
			objx1.style.display = "none";
		}
	}
	/**
	 * Input item star control master
	 *
	 */
	function doCheckInputFields(obj) {
		var fieldName = obj.name;
		//alert(fieldName);
		switch (fieldName) {
		   case "f26" :			/* Consultation type */
				checkf26();
		      	break;
		   case "f28" :			/* Consultation dividing */
				checkf28();
				checkf29();
		      	break;
		   case "f29" :			/* Mortgage dividing*/
				checkf29();
		      	break;
		   case "f907_3" :		/* Debtor number1 */
		   		checkf907();
		      	break;
		   case "f909_3" :		/* Debtor number2 */
		   		checkf909();
		      	break;
		   case "f911_3" :		/* Debtor number3 */
		   		checkf911();
		      	break;
		   case "f913_3" :		/* Debtor number4 */
		   		checkf913();
		      	break;
		   default :
		  		break;
		} //end of select
	}
	/**
	 *	Consultation type	
	 *	相談種類
	 */
	function checkf26() {
	   	if (document.all.f26.value == "3") {	/* 極度 */
			document.all.f27.value = "";
			document.all.f27.disabled = false;
			setRequiredParam("f27");
			
			document.all.f29.value = "";
			document.all.f29.disabled = false;		
		}else { //f26=1
			document.all.f27.value = "";
			document.all.f27.disabled = true;
			setNotRequiredParam("f27");
		}
	}
	/**
	 *	Consultation dividing
	 *	稟議区分
	 */
	function checkf28() {
		var f26Val = document.all.f26.value;
		var f28Val = document.all.f28.value;

		if (f26Val == "1") {
			if(f28Val == "3") { 
				document.all.f27.value = "";
				document.all.f27.disabled = false; 
				setRequiredParam("f27");
				
				document.all.f29.value = 5;
				document.all.f29.disabled = true;
			}else{
				document.all.f27.value = "";
				document.all.f27.disabled = true;
				setNotRequiredParam("f27");
				
				document.all.f29.value = "";
				document.all.f29.disabled = false;				
			}	
		}
		if (f26Val == "3" && f28Val == "3") { 
			//alertError("14108");
			document.all.f26.value = "1";
		}		
	}
	/**
	 *	Mortgage dividing
	 *	担保区分
	 */
	function checkf29() {
		var f29Val = document.all.f29.value;
		
		/* Mortgage dividing 2,4 
		   guarantee type guarantor possibility other insurance self-acknowledgement possibility input possibility */
		if (f29Val == "2" || f29Val == "4") {
			document.all.f43_1.disabled = false;
			document.all.f41.disabled = false;
			setRequiredParam("f41");
		}else {
			document.all.f43_1.value = "";
			document.all.f43_1.disabled = true;
			document.all.f43.value = "";
			document.all.f43.disabled = true;
			document.all.f41.value = "";
			document.all.f41.disabled = true;
			setNotRequiredParam("f41");
		}
		/* Mortgage dividing 3,4 */
		if (f29Val == "3" || f29Val == "4") {
			document.all.f42.disabled = false;
		}else {
			document.all.f42.value = "";
			document.all.f42.disabled = true;
		}
		/* Mortgage dividing 5 */
		if (f29Val == "5") {
			document.all.p12.value = "";
			//document.all.p12.disabled = true;
			initf55f56();   			
		}else {
			checkf33();
		}			
	}
	/**
	 *	Debtor number 1
	 *
	 */
	function checkf907() {
		var objf907_1 = document.all.f907_1;
		var objf907_2 = document.all.f907_2;
		var objf907_3 = document.all.f907_3;
		
		/* Automatic input*/
		if (objf907_3.value.length > 0) {
			objf907_1.value = "000000";			
			objf907_2.value = getIHeader("DPT_CD");	
		} else {
			objf907_1.value = "";			
			objf907_2.value = "";				
		}
	}
	/**
	 *	Debtor number 2
	 *
	 */
	function checkf909() {
		var objf909_1 = document.all.f909_1;
		var objf909_2 = document.all.f909_2;
		var objf909_3 = document.all.f909_3;
		
		/* Automatic input */
		if (objf909_3.value.length > 0) {
			objf909_1.value = "000000";			
			objf909_2.value = getIHeader("DPT_CD");	
		} else {
			objf909_1.value = "";			
			objf909_2.value = "";				
		}
	}
	/**
	 *	Debtor number 3
	 *
	 */
	function checkf911() {
		var objf911_1 = document.all.f911_1;
		var objf911_2 = document.all.f911_2;
		var objf911_3 = document.all.f911_3;
		
		/* Automatic input */
		if (objf911_3.value.length > 0) {
			objf911_1.value = "000000";			
			objf911_2.value = getIHeader("DPT_CD");	
		} else {
			objf911_1.value = "";			
			objf911_2.value = "";				
		}
	}
	/**
	 *	Debtor number 4
	 *
	 */
	function checkf913() {
		var objf913_1 = document.all.f913_1;
		var objf913_2 = document.all.f913_2;
		var objf913_3 = document.all.f913_3;
		
		/* Automatic input */
		if (objf913_3.value.length > 0) {
			objf913_1.value = "000000";			
			objf913_2.value = getIHeader("DPT_CD");	
		} else {
			objf913_1.value = "";			
			objf913_2.value = "";				
		}
	}	 
	/**
	 *	Group cord checking
	 *
	 */
	function checkf51(groupLifeCode) {
		
		//alert("groupLifeCode:"+groupLifeCode);
		if (groupLifeCode == "") return;
		
		//document.all.f51.value = groupLifeCode;
		document.all.f51.value = (parseInt(groupLifeCode,10) == 0)? "": padNumber(groupLifeCode,4);
		//alert(document.all.f51.value);
		
		var groupLifeLbl = "";
		var bisDate = getIHeader("BIS_DATE");
		var dptCd = getIHeader("DPT_CD");
		var xql;
		var nodeList;
		var node;	
		var maxAPPL_DATE;
		document.all.glDay.value = document.all.f35_1.value + document.all.f35_2.value + document.all.f35_3.value;
		var glDay = document.all.glDay.value;
		
		/* max(APPL_DATE) ﾃ｣ｱ?*/
		xql = "/table/record[@DPT_CD='"+dptCd+
					"' and @LIFE_CODE='" +groupLifeCode+ 
					"' and @APPL_DATE<='" +glDay+ 
					"' and @STA<40]";
		nodeList = top.LNPLIFE.selectNodes(xql);
		//alert(xql);
		//alert("1.length:"+nodeList.length);
		if (nodeList.length == 0) return;
		
		node =  nodeList.nextNode();
		maxAPPL_DATE = node.getAttribute("APPL_DATE");
		for(var i =0; i<nodeList.length-1 ; i++) {
			node =  nodeList.nextNode();
			//alert(node.getAttribute("APPL_DATE"));	
			maxAPPL_DATE = (node.getAttribute("APPL_DATE") > maxAPPL_DATE ) ? node.getAttribute("APPL_DATE") : maxAPPL_DATE;
		}
		/* The life_isue_name there is not a necessity which 2 times will execute the searching query the place where it becomes the c/s flaw)*/
		xql = "/table/record[@DPT_CD='"+dptCd+
					"' and @LIFE_CODE='" +groupLifeCode+ 
					"' and @APPL_DATE='" +maxAPPL_DATE+
					"' and @STA<40]";
		node = top.LNPLIFE.selectSingleNode(xql);	
		//alert(maxAPPL_DATE);
		//alert(xql);
		
		if (!node) return;

		groupLifeLbl = node.getAttribute("LIFE_INSU_NAME");
		
		//document.all.f51Lbl.value = groupLifeLbl;
		//alert("groupLifeLbl==>"+groupLifeLbl);

		/**********************************************
		
		str_Select :=  ' select life_insu_name  from lnplife ' +
                 '  where dpt_cd          = ' + '''' + LIB_T.GS_DPTCD   + '''' +
                 '    and life_code       = ' + '''' + group_life_code  + '''' +
                 '    and appl_date       = ( select max(appl_date) from lnplife ' +
                                            ' where dpt_cd  = ' + '''' + LIB_T.GS_DPTCD + '''' +
                                            '   and life_code       = ' + '''' + group_life_code  + '''' +
                                            '   and appl_date <= ' + '''' +  FormatDateTime('yyyymmdd', LIB_T.GD_BisDate ) + '''' +
                                            '   and sta       < 40 ) ' +
                 '    and sta              < 40 ';

		*************************************************/
	} 
	function u_paddind(val){
		if(val != ""){
			if(event.srcElement.name == "f30"){
				event.srcElement.value = (parseInt(val,10) == 0)? "": padNumber(val,2);
			}
			if(event.srcElement.name == "f31"){
				event.srcElement.value = (parseInt(val,10) == 0)? "": padNumber(val,2);
			}
			if(event.srcElement.name == "f32"){
				event.srcElement.value = (parseInt(val,10) == 0)? "": padNumber(val,3);
			}
			if(event.srcElement.name == "f33"){
				event.srcElement.value = (parseInt(val,10) == 0)? "": padNumber(val,4);
			}
			if(event.srcElement.name == "f34"){
				event.srcElement.value = (parseInt(val,10) == 0)? "": padNumber(val,4);
			}
		}
	}
	function u_addrTrim(field) {
		var obj=document.all[field];
		if(obj.value!="") {
			var addr=obj.value;
			var tmp=addr.split(" ");
			var rStr=trim(tmp[0]);
			for(var i=1;i<tmp.length;i++) {
				var temp=trim(tmp[i]);
				if(temp!="") {
					rStr+=" "+temp;
				}
			}
			obj.value=rStr;
		}
	}
	function u_joinCheck() {
		//alert(document.all[arguments[5]].value);
		var totVal=0;
		if(document.all[arguments[5]].value==2) {
			var obj0=document.all[arguments[0]].value;
			if(obj0=="") obj0=0;
			var obj1=document.all[arguments[1]].value;
			if(obj1=="") obj1=0;
			var obj2=document.all[arguments[2]].value;
			if(obj2=="") obj2=0;
			var obj3=document.all[arguments[3]].value;
			if(obj3=="") obj3=0;
			var obj4=document.all[arguments[4]].value;
			if(obj4=="") obj4=0;
	
			totVal=parseInt(obj0)+parseInt(obj1)+parseInt(obj2)+parseInt(obj3)+parseInt(obj4);
			//alert(totVal);
		}
		return totVal;
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
			
			document.all.p906.style.textAlign = 'right';
		}
	}
	function u_checkCIF() {
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
	function u_zeroCheck() {
		var len=arguments.length;
		for(var i=0;i<len;i++) {
			var field=arguments[i];
			var obj=document.all[field];
			if(parseInt(obj.value)=="0") {obj.value="";}
		}
	}
	function u_clearContent(field1,field2) {
	var field0=event.srcElement.name;
		if(document.all[field0].value=="") {
			document.all[field1].value="";
			document.all[field2].value="";
			setNotRequiredParam(field2);
			u_joinChange('p906','f908','f910','f912','f914','f906');
		} else {
			setRequiredParam(field2);
		}
	}
	function u_searchCIF(){
		if(document.all[arguments[0]+"_3"].value=="" && document.all[arguments[1]+"_3"].value=="" && document.all[arguments[2]+"_3"].value=="" && document.all[arguments[3]+"_3"].value=="") {return;
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
	
		dataForm.action=top.CONTEXT+"/4.LON/12010/process.jsp";
		dataForm.target="popup";
		dataForm.submit();
	}
	function localQuery7(){
		if(event.propertyName!="value") return;
		
		document.all.glDay.value=document.all.f35_1.value+document.all.f35_2.value+document.all.f35_3.value;
		
		if(document.all.f407.value!="" && document.all.f408.value!="" && document.all.glDay.value.length==8) {
			document.all.dptCd.value = getIHeader("DPT_CD");
			dataForm.action=top.CONTEXT+"/4.LON/12010/process3.jsp";
			dataForm.target="popup";
			dataForm.submit();
		}
	}
	function u_pattern() {
		if(event.propertyName!="value") return;
		document.all.f408_1Lbl.value = "";
	}
	function u_clsinst(){
		if(document.all.f408.value!="") {
			setRequiredParam("f407");
		} else {
			setNotRequiredParam("f407");
		}
		if(oldValue != document.all.f408.value){
			document.all.f408Lbl.value="";
			document.all.f407.value="";
			document.all.f407Lbl.value="";
			document.all.f408_1.value="";
			document.all.f408_1Lbl.value="";
			oldValue = document.all.f408.value;
		}
	}
	function u_instpadding() {
		if(document.all.f407.value != ""){
			document.all.f407.value = (parseInt(document.all.f407.value,10) == 0) ? "" : padNumber(document.all.f407.value,5);
		}
		dataForm.action=top.CONTEXT+"/4.LON/12010/process7.jsp";
		dataForm.target="popup";
		dataForm.submit();
		if(oldValue != document.all.f408.value){
			document.all.f408_1.value="";
			document.all.f408_1Lbl.value="";
			oldValue = document.all.f408.value;
		}
	}
	function u_clscoal() {
		if(event.propertyName!="value") return;
		if(document.all.f407.value == ""){
			document.all.f407Lbl.value="";
			document.all.f408_1Lbl.value="";
			document.all.f408_1.value="";
		}
		
	}
	function u_clsInsto() {
		if(document.all.f35_1.value.length==4 && document.all.f35_2.value.length==2 && document.all.f35_3.value.length==2) {
			document.all.glDay.value=document.all.f35_1.value+document.all.f35_2.value+document.all.f35_3.value;
		}
			document.all.f407.value="";
			document.all.f407Lbl.value="";
			document.all.f408.value="";
			document.all.f408Lbl.value="";
			document.all.f408_1.value="";
			document.all.f408_1Lbl.value="";
			setNotRequiredParam("f408");
	}
	function Localquery2(){
		if(event.propertyName!="value") return;
		if(document.all.f51.value.length > 0){
			dataForm.action=top.CONTEXT+"/4.LON/12010/process2.jsp";
			dataForm.target="popup2";
			dataForm.submit();
			document.all.f53.value = "y";
			doCheckBoxYN_2();
		} else {
			document.all.f51Lbl.value = "";
			document.all.f53.value = "n";
			doCheckBoxYN_2();
		}
	}
	function autopadding(){
		if(document.all.f51.value != ""){
			document.all.f51.value = (document.all.f51.value=='0')? "": padNumber(document.all.f51.value,4);
		} else {
			document.all.f51Lbl.value = "";
		}
	}
	function getclear(){
		if(document.all.f51Lbl.value == "") return;
		if(document.all.f51.value == ""){
			if(document.all.f51Lbl.value != "") document.all.f51Lbl.value = "";
		}
	}

	function gettmp(){
		document.all.f54tmp.value = document.all.f54.value;
	}
			
	function dambokind() {
		if(document.all.f43_1.value != ""){
			setRequiredParam("f43");
		} else {
			setNotRequiredParam("f43");
			document.all.f43.value = "";
		}
	}
	function autoinit() {
		var codeVal = document.all.f43_1.value;
		var nodeVal;
		
		if(document.all.f43_1.value ==""){
			document.all.f43_1Lbl.value = "";
			document.all.f43.value = "";
			document.all.f43Lbl.value = "";
			document.all.f43.disabled=true;
			setNotRequiredParam("f43");
		} else {
			document.all.f43.disabled=false;
			nodeVal = top.LNPCODE.selectSingleNode("/table/record[@CODE_KIND ='22' and @CODE_1="+codeVal+
										" and (@STA=1 or @STA=2) "+
										" and @CODE_1 > 0 "+
										" and @CODE_2 = 0 "+
										" and @CODE_3 = 0 "+
										" and @CODE_4 = 0 "+
										" and @CODE_5 = 0]");
			document.all.f43_1Lbl.value = (nodeVal)? nodeVal.getAttribute("CODE_NAME"):"";
			setRequiredParam("f43");
		}
	}
	
	//20160321  fxinfo tab disable
	function Tab5alldisable(){
		document.all.f100.disabled=true;
		document.all.f101.disabled=true;
		document.all.f102.disabled=true;
		document.all.f103.disabled=true;
		document.all.f104.disabled=true;
		document.all.f105.disabled=true;
		document.all.f106.disabled=true;
		document.all.f107.disabled=true;
		
	}
	
 //20160321 fx make CUR selectbox  
	function mSelect(){
		var str= document.all.f100.outerHTML;
//		alert(str);
		str = str.substring(0,str.indexOf(">")+1);
		var children = top.LNPCURR.selectNodes(".//record[@STA=1 ]");
		str += "<OPTION value=''></OPTION>";
		
		for(var j=0;j<children.length;j++) {
			str += "<OPTION value='" + children[j].getAttribute("CURR_CODE") + "'>" + children[j].getAttribute("CURR_CODE") + "</OPTION>";

		}
		
		str += "</SELECT>";
		document.all.f100.outerHTML = str;		
		

	
	}
	
	
</script>
<!-- 20150910 code 00->02 -->
<input type='hidden' name='code' value='02'>
<input type='hidden' name='RTN_FLAG' value='9'>
<button id=NEW onclick="top.execute(document.all.trCode.value, '01')" disabled=true><sup>F5</sup>&nbsp;<script>w1('NEW')</script></button>
<button id=UPDATE onclick="top.execute(document.all.trCode.value, '03')" style='border:1px inset;' disabled=true><sup>F6</sup>&nbsp;<script>w1('UPDATE')</script></button>
<button id=TRANSACTION type=submit style="margin-left:20px;" disabled=true><sup>F9</sup>&nbsp;<script>w1('TRANSACTION')</script></button><br>
<p>
<!--<label class="tab_page_label"><script>w1('TXKIND1')</script></label>--><input type='hidden' name='f1'>
<label class="tab_page_label"><script>w1('CNSLNO')</script></label>
<input type='hidden' name='f2_1'><input name='f2_2' style='width:40px;' readonly tabindex='-1'><input name='f2_3' style='width:40px;' readonly tabindex='-1'><input name='f2_4' style='width:20px;' readonly tabindex='-1'><input name='f2_5' style='width:50px;' readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:115px;'><script>w1('LONSTATUS')</script></label>
<input name='p11' style='width:80px;' readonly tabindex='-1'><br>
<!--<label class="tab_page_label"><script>w1('TYPE')</script></label>--> <input type='hidden' name='f3'><input type='hidden' name='f4'>
<!--<label class="tab_page_label"><script>w1('BISID')</script></label>--><input type='hidden' name='f5'>
<label class="tab_page_label"><script>w1('CIF')</script></label>
<input type='hidden' name='f6_1'><input type='hidden' name='f6_2'><input name='f6_3' style='width:80px;' readonly tabindex='-1'><input name='p18' style='width:580px;' readonly tabindex='-1'><br>
</p>
<div class=TabUI>
<span id=tabItems class='TabItem'><script>w1('CIFINFO')</script></span>
<span id=tabItems class='TabItem'><script>w1('BONDPROPERTYINFO')</script></span>
<span id=tabItems class='TabItem'><script>w1('RSDTCHGINFO')</script>1</span>
<span id=tabItems class='TabItem' onclick="u_keyFocus()"><script>w1('RSDTCHGINFO2')</script></span>
<span id=tabItems class='TabItem'><script>w1('FXINFO')</script></span>   <!--20160321  fx add -->
</div>



<!-- 1st Tab -->
<p id=tabPages class='TabPage'>

<label class="tab_page_label" style='margin-left:-25px;'><script>w1('LONAMT')</script></label>
<input name='f7' style='width:150px;' readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:44px;'><script>w1('TELNO')</script></label>
<input name='f8' style='width:110px;' readonly tabindex='-1'><br>

<label class="tab_page_label" style='margin-left:-25px;'><script>w1('PERSTY')</script></label>
<input name='p2' style='width:40px;' qtype='62' pop='no' onpropertychange="getDesc()" readonly tabindex='-1'><input name='p2Lbl' style='width:200px;' readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:-46px;'><script>w1('COMSCALE')</script></label>
<input name='f10' style='width:40px;' qtype='61' pop='no' readonly tabindex='-1'><input name='f10Lbl' style='width:300px;' readonly tabindex='-1'>
<!--<label class="tab_page_label"><script>w1('COMPTYP')</script></label>-->
<input name='f11' type='hidden'><br>

<label class="tab_page_label" style='margin-left:-25px;'><script>w1('BISTYPCD')</script></label>
<input name='f14' style='width:40px;' qtype='56' pop='no' readonly tabindex='-1'><input name='f14Lbl' style='width:200px;' readonly tabindex='-1'>
<!--<label class="tab_page_label"><script>w1('BISTYPCDNAM')</script></label>-->
<input name='f15' type='hidden'>
<label class="tab_page_label" style='margin-left:-50px;'><script>w1('JOBCD')</script></label>
<input name='f12' style='width:40px;' qtype='48' pop='no' readonly tabindex='-1'><input name='f12Lbl' style='width:300px;' readonly tabindex='-1'>
<!--<label class="tab_page_label"><script>w1('JOBCDNAME')</script></label>-->
<input name='f13' type='hidden'><br>

<label class="tab_page_label" style='margin-left:-25px;'><script>w1('OFFICETELNO')</script></label>
<input name='f16' style='width:110px;' readonly tabindex='-1'><br>
<label class="tab_page_label" style='margin-left:-25px;'><script>w1('OFFICENAM')</script></label>
<input name='f17' style='width:550px;' readonly tabindex='-1' maxlength='80'><br>

<label class="tab_page_label" style='margin-left:-25px;'><script>w1('ADDR')</script></label><input name='f19' type='hidden'>
<input name='zip1' style='width:70px;' readonly tabindex='-1'><input name='p20' style='width:647px;' readonly tabindex='-1'><br>
<label class="tab_page_label" style='margin-left:-25px;'>&nbsp;</label>
<input name='p21' style='width:717px;' readonly tabindex='-1'><br>

<label class="tab_page_label" style='margin-left:-25px;'><script>w1('OFFICEPOSTNO')</script></label><input name='f22' type='hidden'>
<input name='zip2' style='width:70px;' readonly tabindex='-1'><input name='p23' style='width:647px;' readonly tabindex='-1'><br>

<label class="tab_page_label" style='margin-left:-25px;'><script>w1('OFFICEADDR4')</script></label>
<input name='p24' style='width:717px;' readonly tabindex='-1'><br>
</p>




<!-- 2nd Tab -->
<p id=tabPages class='TabPage'>

<label class="tab_page_label"><script>w1('DEBTKIND')</script></label>
<select name='p3' table='LNPCODE' key='609' disabled></select>
<label class="tab_page_label" style='margin-left:15px;'><script>w1('CLASSTYP3')</script></label>
<select name='p4' table='LNPCODE' key='610' disabled></select><br>
<label class="tab_page_label"><script>w1('CREDITKIND')</script></label>
<select name='p5' table='LNPCODE' key='611' disabled></select>
<label class="tab_page_label"><script>w1('TREATPLAN')</script></label>
<select name='p6' table='LNPCODE' key='612' disabled></select><br>
<label class="tab_page_label"><script>w1('SUMMARY')</script></label>
<input name='p7' style='width:460px;' readonly tabindex='-1'><br>
<label class="tab_page_label">&nbsp;</label>
<input name='p8' style='width:460px;' readonly tabindex='-1'><br>
<label class="tab_page_label">&nbsp;</label>
<input name='p9' style='width:460px;' readonly tabindex='-1'><br>
<label class="tab_page_label">&nbsp;</label>
<input name='p10' style='width:460px;' readonly tabindex='-1'><br>
</p>




<!-- 3rd Tab -->
<p id=tabPages class='TabPage'>

<label class="tab_page_label"><script>w1('NEWACTTYP')</script></label>
<select name='f25' table='COMCOMB' key='5433' onChange="doCheckInputFields(this);"></select>
<label class="tab_page_label" style='margin-left:213px;'><script>w1('CNSLKIND')</script></label><!--Consultation type-->
<select name='f26' table='COMCOMB' key='1800' onChange="doCheckInputFields(this);"></select><br>

<label class="tab_page_label"><script>w1('CNLTFLAG')</script></label><!--Consultation dividing-->
<select name='f28' table='LNPCODE' key='80' onChange="doCheckInputFields(this);"></select>
<label class="tab_page_label" style='margin-left:144px;'><script>w1('BILLCNLTKIND')</script></label>
<select name='f44' table='LNPCODE' key='633' disabled='true'></select><br>

<label class="tab_page_label"><script>w1('LIMITKIND')</script></label>
<select name='f27' table='LNPCODE' key='632' style='width:266px;'></select>
<label class="tab_page_label"><script>w1('ACCTABOUTBILLLOAN')</script></label>
<input name='f45_1' type='hidden'><input name='f45_2' type='hidden'><input name='f45_3' style='width:40px;' disabled='true'><input name='f45_4' style='width:20px;' disabled='true'><input name='f45_5' style='width:70px;' disabled='true'><br>

<label class="tab_page_label"><script>w1('GLCD')</script></label>
<input name='f30' style='width:25px;' qtype="3001" readonly tabIndex='-1' pop='no'><input name='f30Lbl' size ='45' readonly tabIndex='-1'>
<label class="tab_page_label"><script>w1('FUNDTYPCD')</script></label>
<input name='f31' style='width:25px;' qtype="3002" master="f30" readonly tabIndex='-1' pop='no'><input name='f31Lbl' size ='47' readonly tabIndex='-1'><br>

<label class="tab_page_label"><script>w1('GLGRPCD')</script></label>
<input name='f32' style='width:30px;' qtype="3003" master="f31" master2="f30" readonly tabIndex='-1' pop='no'><input name='f32Lbl' size='44' readonly tabIndex='-1'>
<label class="tab_page_label"><script>w1('SUBGRPCD')</script></label>
<input name='f33' style='width:40px;' qtype="3004" master="f32" master2="f31" master3="f30" readonly tabIndex='-1' pop='no'><input name='f33Lbl' size ='44' readonly tabIndex='-1'><br>

<label class="tab_page_label"><script>w1('FUNDUSECD')</script></label>
<input name='f34' style='width:40px;' qtype="3005" master="f33" master2="f32" master3="f31" master4="f30" readonly tabIndex='-1' pop='no'><input name='f34Lbl' size ='42' readonly tabIndex='-1'>
<label class="tab_page_label"><script>w1('LONREQDT')</script></label>
<input name='f35_1' style='width:40px;' readonly tabIndex='-1'><input name='f35_2' style='width:25px;' readonly tabIndex='-1'><input name='f35_3' style='width:25px;' readonly tabIndex='-1'><br>
<input type='hidden' name='glDay'>

<label class="tab_page_label"><script>w1('COLLTYP1')</script></label><!--Mortgage dividing-->
<span id=ddf29 style="display:inline;"></span><input type='hidden' name='f29_old'>
<label class="tab_page_label" style='margin-left:65px;'><script>w1('OUTCOLLTYP')</script></label>
<select name='p12' table='COMCOMB' key='3720' onchange='u_combochange()' disabled></select><br>

<label class="tab_page_label"><script>w1('APPCAMT')</script></label><!--Application amount of money-->
<input name='f36' style='width:150px;' readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:116px;'><script>w1('COLLKIND')</script></label><!-- Mortgage type-->
<select name='f42' table='LNPCODE' key='23'></select><br>

<label class="tab_page_label"><script>w1('GUARNTTYP')</script></label>
<input name='f43_1' style='width:15px;' qtype='3011' slave='f43' onpropertychange="getDesc();dambokind();autoinit()" onkeyup="autoinit()" onkeydown="allowNumber()" maxlength='1'><input name='f43_1Lbl' style='width:200px;' readonly tabindex='-1'><input name='f43' style='width:30px;' qtype='3012' master='f43_1' onpropertychange="getDesc()" onkeyup="autoinit()" onkeydown="allowNumber()" maxlength='3'><input name='f43Lbl' style='width:200px;' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('GUARNTCNT')</script></label>
<input name='f41' style='width:20px;' onkeyup='u_zeroCheck(this.name)'><br>

<label class="tab_page_label"><script>w1('PERUNDERCHAR')</script></label>
<input name='f37' style='width:80px;' qtype='28' readonly tabindex='-1' pop='no'><input name='f37Lbl' style='width:320px;' readonly tabindex='-1'>
<input name='f38' type='hidden'><input name='f39' type='hidden'><input name='f40' type='hidden'><br>

<label class="tab_page_label"><script>w1('SUMMARY1')</script></label>
<input name='f46' style='width:400px;' readonly tabindex='-1'><br>
<label class="tab_page_label"><script>w1('SUMMARY2')</script></label>
<input name='f47' style='width:400px;' readonly tabindex='-1'><br>
<label class="tab_page_label"><script>w1('SUMMARY3')</script></label>
<input name='f48' style='width:400px;' readonly tabindex='-1'><br>
<label class="tab_page_label"><script>w1('ETCMAIL')</script></label>
<input name='f49' style='width:400px;' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('RELTCNSLNO')</script></label>
<input name='f904_1' type='hidden' style='width:40px;'><input name='f904_2' style='width:40px;' readonly tabindex='-1'><input name='f904_3' style='width:40px;' readonly tabindex='-1'><input name='f904_4' style='width:20px;' readonly tabindex='-1'><input name='f904_5' style='width:50px;' readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:116px;'><script>w1('LOANTOTAMT')</script></label>
<input name='f905' style='width:150px;' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('INFOBRN')</script></label>
<input name='f901' style='width:40px;' qtype='14' readonly tabindex='-1' pop='no'><input name='f901Lbl' style='width:200px;' readonly tabindex='-1'>
<label class="tab_page_label" style='margin-left:26px;'><script>w1('TRBRANCH')</script></label>
<input name='f902' style='width:40px;' qtype='14'><input name='f902Lbl' style='width:200px;' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('EMPBRN')</script></label>
<input name='f903' style='width:40px;' qtype='14' readonly tabindex='-1' pop='no'><input name='f903Lbl' style='width:200px;' readonly tabindex='-1'><br>
</p>





<!-- 4th tab -->
<p id=tabPages class='TabPage'>

<input type='hidden' name='f50'>
<label class="tab_page_label"><script>w1('GUARCOKINDCODE')</script></label>
<input name='f55' style='width:40px;' qtype='3173' readonly tabindex='-1' pop='no'><input name='f55Lbl' style='width:230px;' readonly tabindex='-1'>
<label class="tab_page_label"><script>w1('GUARCOMPCODE')</script></label>
<input name='f56' style='width:40px;' qtype='3155' readonly tabindex='-1' pop='no'><input name='f56Lbl' style='width:230px;' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('GROUPLIFECODE')</script></label>
<input name='f51' style='width:40px;' qtype='3133' master='glDay' onpropertychange="Localquery2()" onblur='autopadding()'><input name='f51Lbl' style='width:230px;' readonly tabindex='-1'onpropertychange='getclear()'>
<label class="tab_page_label"><script>w1('LIFECNT')</script></label>
<input name='f52' style='width:30px; text-align:right;' disabled='true'><br>

<!--label><script>w1('LOANENTERFLAG')</script></label-->
<input name='f53' type='hidden' disabled='true' ><!--script>w1('CKECKYN')</script-->
<label class="tab_page_label" style='margin-left:0'><script>w1('LOANINSLNO')</script></label>
<input name='f54' style='width:170px;' onblur='gettmp()' maxlength='20' readonly tabindex='-1'><br>
<br>

<label class="tab_page_label"><script>w1('COALCODE')</script></label>
<input name='f408' qtype='3141' pop='no' master='glDay' style='width:45px;' onpropertychange="u_clsinst()" readonly tabindex='-1'><input name='f408Lbl' style='width:230px;' readonly tabindex='-1'>
<label class="tab_page_label" style="margin-left:-5px;"><script>w1('INSTNO')</script></label>
<input name='f407' qtype='3142' pop='no' master='glDay' master2='f408' style='width:45px;' onpropertychange="localQuery7()" readonly tabindex='-1'><input name='f407Lbl' style='width:230px;' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('PRIVWIDTPATTEN')</script></label>
<input name='f408_1' qtype='80' pop='no' style='width:45px;' onpropertychange="u_pattern()" readonly tabindex='-1'><input name='f408_1Lbl' style='width:230px;' readonly tabindex='-1'><br>
<br>

<label class="tab_page_label"><script>w1('RELDEBTKIND')</script></label>
<select name='f906' table='LNPCODE' key='720' onChange="joinType();"></select>
<label class="tab_page_label" style='margin-left:180px;' id='sample'><script>w1('JOINDEBTRATE')</script></label>
<input name='p906' style='width:30px;text-align:right;' readonly tabIndex='-1'>%<br>

<span id=x1>
	<label class="tab_page_label"><script>w1('JOINJOINCIF1')</script></label>
	<input name='f907_1' type='hidden'><input name='f907_2' type='hidden'><input name='f907_3' style='width:80px;' readonly tabindex='-1'><input name='ciff907' style='width:450px;' readonly tabindex='-1'>
	<label class="tab_page_label" style='width:80px;'><script>w1('JOINRATET1')</script></label>
	<input name='f908' style='width:30px;' readonly tabindex='-1'>%<br>
	
	<label class="tab_page_label"><script>w1('JOINJOINCIF2')</script></label>
	<input name='f909_1' type='hidden'><input name='f909_2' type='hidden'><input name='f909_3' style='width:80px;' readonly tabindex='-1'><input name='ciff909' style='width:450px;' readonly tabindex='-1'>
	<label class="tab_page_label" style='width:80px;'><script>w1('JOINRATE2')</script></label>
	<input name='f910' style='width:30px;' readonly tabindex='-1'>%<br>
	
	<label class="tab_page_label"><script>w1('JOINJOINCIF3')</script></label>
	<input name='f911_1' type='hidden'><input name='f911_2' type='hidden'><input name='f911_3' style='width:80px;' readonly tabindex='-1'><input name='ciff911' style='width:450px;' readonly tabindex='-1'>
	<label class="tab_page_label" style='width:80px;'><script>w1('JOINRATE3')</script></label>
	<input name='f912' style='width:30px;' readonly tabindex='-1'>%<br>
	
	<label class="tab_page_label"><script>w1('JOINJOINCIF4')</script></label>
	<input name='f913_1' type='hidden'><input name='f913_2' type='hidden'><input name='f913_3' style='width:80px;' readonly tabindex='-1'><input name='ciff913' style='width:450px;' readonly tabindex='-1'>
	<label class="tab_page_label" style='width:80px;'><script>w1('JOINRATE4')</script></label>
	<input name='f914' style='width:30px;' readonly tabindex='-1'>%<br>
	
	<button name="searchCif" style='margin-left:150px;'><script>w1('QUERY')</script></button>
</span>
</p>
<!-- 5th tab 20160321  fx 'FXINFO' add start-->  
<p id=tabPages class='TabPage'>

<label class="tab_page_label"><script>w1('CURRENCYCD')</script></label>
<select name='f100' onchange='u_curchange()'></select>
<label class="tab_page_label" style='margin-left:84px;'><script>w1('APPCAMT')</script></label><input name='f101' onfocus='u_checkAmt()' onblur="u_autoPadding()" style='width:150px;'  >
<br>
<br>

<label class="tab_page_label" style="margin-left:48px;"><script>w1('REFMARKETCD')</script></label>
<label class="tab_page_label" style="margin-left:160px;"><script>w1('IMPTSWAP')</script></label><input name='f102' type="checkbox"   onchange="u_setChange(this);" style="margin-left:-2px;" value="0">&nbsp;YES
<br>
<br>
<label class="tab_page_label"><script>w1('MARKETCD1')</script></label>
<select name='f103' table='LNPCODE' key='753' onChange="chMarket();"></select><br>
<label class="tab_page_label"><script>w1('MARKETCD2')</script></label>
<select name='f104' table='LNPCODE' key='753' onChange="chMarket();"></select><br>
<label class="tab_page_label"><script>w1('MARKETCD3')</script></label>
<select name='f105' table='LNPCODE' key='753' onChange="chMarket();"></select><br>
<label class="tab_page_label"><script>w1('MARKETCD4')</script></label>
<select name='f106' table='LNPCODE' key='753' onChange="chMarket();"></select><br>
<label class="tab_page_label"><script>w1('MARKETCD5')</script></label>
<select name='f107' table='LNPCODE' key='753' onChange="chMarket();"></select><br>

</p>
<!--20160321  fx 'FXINFO' add end -->

<input type='hidden' name='tmp1'>
<input type='hidden' name='tmp2'>
<input type='hidden' name='f54tmp'>
<input type='hidden' name='cif1'>
<input type='hidden' name='cif2'>
<input type='hidden' name='cif3'>
<input type='hidden' name='cif4'>
<input type='hidden' name='nm1'>
<input type='hidden' name='nm2'>
<input type='hidden' name='nm3'>
<input type='hidden' name='nm4'>
<input type='hidden' name='dptCd'>
<input type='hidden' name='f500'>
<iframe name='popup' width='0' height='0' style="border:0;"></iframe>
<iframe name='popup2' width='0' height='0' style="border:0;"></iframe>