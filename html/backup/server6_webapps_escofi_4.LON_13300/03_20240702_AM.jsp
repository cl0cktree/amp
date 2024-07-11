<%@ page contentType="text/html;charset=Windows-31J" %>
<script>var trInXml = loadXML('/codeXml/4.LON/13300_03in.xml')</script>
<script>var trOutXml = loadXML('/codeXml/4.LON/13300_03out.xml')</script>
<script>
	function initPage() {
		setMsg("");
		firstFocusField = document.all.f1_5
		lastFocusField = document.all.f1_5
		//APPRTYPE
		document.all.f2.value="3";
	}
	function checkPage(fieldArray){
		push("f1_1", document.all.f1_1.value);
		push("f1_2", document.all.f1_2.value);
		push("f1_3", document.all.f1_3.value);
		push("f1_4", document.all.f1_4.value);
		push("f1_5", document.all.f1_5.value);

		push("f2", document.all.f2.value);
		return true;
	}
	function flow() {
		//debugOutput();
		go();
		setMsg("253");
	}
</script>
<input type='hidden' name='code' value='04'>
<input type='hidden' name='RTN_FLAG' value='1'>
<button id=NEW onclick="top.execute(document.all.trCode.value, '01')"><sup>F5</sup>&nbsp;<script>w1('APPLICATION')</script></button>
<button id=DELETE onclick="top.execute(document.all.trCode.value, '03')" style='border:1px inset;'><sup>F7</sup>&nbsp;<script>w1('DELETE')</script></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<button id=TRANSACTION2 onclick="changeRTNFlag()" disabled=true><sup>&nbsp;&nbsp;</sup>&nbsp;<script>w1('ADDNEW')</script></button>
<button id=PRINT onclick="changeRTNFlag2()" disabled=true><sup>&nbsp;</sup>&nbsp;<script>w1('PRINT')</script></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<button id=TRANSACTION type=submit><sup>F9</sup>&nbsp;<script>w1('TRANSACTION')</script></button>
<br>
<p>
<label class="tab_page_label"><script>w1('CNSLNO')</script></label>
<input type='hidden' name='f1_1'><input name='f1_2' style='width:40px;'><input name='f1_3' style='width:40px;'><input name='f1_4' style='width:20px;'><input name='f1_5' style='width:60px;'><br>
<!--<label class="tab_page_label"><script>w1('APPRTYPE')</script></label>-->
<input type='hidden' name='f2'><br>
</p>