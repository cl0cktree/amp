<%@ page contentType="text/html;charset=Windows-31J" %>
<script>var trInXml = loadXML('/codeXml/4.LON/12010_03in.xml')</script>
<script>var trOutXml = loadXML('/codeXml/4.LON/12010_03out.xml')</script>
<script>
	function initPage() {
		setMsg("");
		document.all.f1.value="2";	/* Transaction number */
		firstFocusField = document.all.f2_5;
		lastFocusField = document.all.f2_5;
	}
	function checkPage(fieldArray){
		//debugInput();
		return true;
	}
	function flow() {
		//debugOutput();
		setMsg("253");
		
		if( parseInt(getOutput("f500"),10) == 7 || parseInt(getOutput("f500"),10) == 8 ){
			go("05");
		} else if( parseInt(getOutput("f500"),10) == 2 || getOutput("f500") == 11 || getOutput("f500") == 21){
			go("06");
		}else{
			go();
		}
	}
</script>
<input type='hidden' name='code' value='04'>
<input type='hidden' name='RTN_FLAG' value='1'>
<button id=NEW onclick="top.execute(document.all.trCode.value, '01')" ><sup>F5</sup>&nbsp;<script>w1('NEW')</script></button>
<button id=UPDATE onclick="top.execute(document.all.trCode.value, '03')" style='border:1px inset;'><sup>F6</sup>&nbsp;<script>w1('UPDATE')</script></button>
<button id=TRANSACTION type=submit style=margin-left:20><sup>F9</sup>&nbsp;<script>w1('TRANSACTION')</script></button><br>
<p>
<!--<label class="tab_page_label"><script>w1('TXKIND1')</script></label>-->
<input type=hidden name='f1' style='width:80px'><br>
<label class="tab_page_label"><script>w1('CNSLNO')</script></label>
<input type=hidden name='f2_1' style='width:80px'><input name='f2_2' style='width:40px'><input name='f2_3' style='width:40px'><input name='f2_4' style='width:20px'><input name='f2_5' style='width:60px'>
<!--
<label class="tab_page_label"><script>w1('LONSTATUS')</script></label>
<input name='p1' style='width:80px' readonly tabindex='-1'><br>

<label class="tab_page_label"><script>w1('CIF')</script></label>
<input name='f6_1' style='width:80px' type=hidden><input name='f6_2' style='width:80px' type=hidden><input name='f6_3' style='width:80px' readonly tabindex='-1'>
<label class="tab_page_label"><script>w1('CIFNAME0')</script></label>
<input name='p2' style='width:150px' readonly tabindex='-1'><br>
-->
</p>