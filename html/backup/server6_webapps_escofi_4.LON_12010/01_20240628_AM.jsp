<%@ page contentType="text/html;charset=Windows-31J" %>
<script>var trInXml = loadXML('/codeXml/4.LON/12010_01in.xml')</script>
<script>var trOutXml = loadXML('/codeXml/4.LON/12010_01out.xml')</script>
<script>
	function initPage() {
		setMsg("");
		document.all.f1.value="1"; /* Transaction number */
		firstFocusField = document.all.f6_3;
		lastFocusField = document.all.f6_3;
	}
	function checkPage(fieldArray){
		//debugInput();
		return true;
	}
	function flow() {
		//debugOutput();
		setMsg("253");
		go();
	}
</script>
<style>
	label {
		width:150px;
	}
</style>
<input type='hidden' name='code' value='02'>
<input type='hidden' name='RTN_FLAG' value='1'>
<button id=NEW onclick="top.execute(document.all.trCode.value, '01')" style='border:1px inset;'><sup>F5</sup>&nbsp;<script>w1('NEW')</script></button>
<button id=UPDATE onclick="top.execute(document.all.trCode.value, '03')"><sup>F6</sup>&nbsp;<script>w1('UPDATE')</script></button>
<button id=TRANSACTION type=submit style="margin-left:20px;"><sup>F9</sup>&nbsp;<script>w1('TRANSACTION')</script></button><br>
<p>
<!--<label class="tab_page_label"><script>w1('TXKIND1')</script></label>-->
<input type=hidden name='f1' style='width:80px;'><br>
<!--
<label class="tab_page_label"><script>w1('CNSLNO')</script></label>
<input name='f2_1' style='width:80px;' type=hidden><input name='f2_2' style='width:40px;' readonly tabindex='-1'><input name='f2_3' style='width:40px;' readonly tabindex='-1'><input name='f2_4' style='width:20px;' readonly tabindex='-1'><input name='f2_5' style='width:50px;' readonly tabindex='-1'>
<label class="tab_page_label"><script>w1('LONSTATUS')</script></label>
<input name='p1' style='width:80px' readonly tabindex='-1'><br> -->

<!--<label class="tab_page_label"><script>w1('TYPE')</script></label>-->
<input type=hidden name='f3' style='width:80px;'><input type=hidden name='f4' style='width:150px;'>
<!--<label class="tab_page_label"><script>w1('BISID')</script></label>-->
<input type=hidden name='f5' style='width:150px;'>
<label class="tab_page_label"><script>w1('CIF')</script></label>
<input type=hidden name='f6_1' style='width:80px;'><input type=hidden name='f6_2' style='width:80px;'><input name='f6_3' style='width:80px;'><input type=hidden name='p2' style='width:150px;' readonly tabindex='-1'><br>
</p>