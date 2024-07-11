<%@ page contentType="text/html;charset=Windows-31J" %>
<!-- SSO 対応 20181002 -->
<%  String acct_no = "";
    String acct_km = "";
    String acct_br = "";
    String sso = "0";
    String signon = (String)session.getAttribute("SIGNON");
    String accountId = (String)session.getAttribute("ACCTNO");
    String guarantyKbn = (String)session.getAttribute("GUAKBN");
    if( signon!=null && signon=="S" && accountId!="" ){ //20190116
        sso = "1";
    }
    if( accountId!=null&&guarantyKbn!=null ){
        if( accountId.length()==20 ){
            acct_no = accountId.substring(accountId.length()-7);
            acct_km = accountId.substring(accountId.length()-9,accountId.length()-7);
            acct_br = accountId.substring(accountId.length()-13,accountId.length()-9);
        }
    }
%>

<script>var trInXml = loadXML('/codeXml/4.LON/17010_01in.xml')</script>
<script>var trOutXml = loadXML('/codeXml/4.LON/17010_01out.xml')</script>
<script>
	setMsg("");
	var dpt_cd=getIHeader("DPT_CD");
	var brn=getIHeader("BRN");
	var glyear=getGLYEAR();
	var cnsl=DEFAULT_INPUT_04;

// 2020/04/23 品質強化対応(証書貸付に戻す) ebs START
//	var acct=DEFAULT_INPUT_10;
	var acct=DEFAULT_INPUT_08;
// 2020/04/23 品質強化対応(証書貸付に戻す) ebs END

	function initPage() {
		disablePrintBtn();
		requireField("f3");
		document.all.f3.selectedIndex=2;
		u_setChange("f1","f2");
		document.all.f1_1.value="000";
		document.all.f1_2.value=dpt_cd;
		document.all.f1_3.value=getBranch();
		document.all.f1_4.value=acct;

               //SSO対応 20181002
                var acctkm = "<%= acct_km %>";
                var acctbr = "<%= acct_br %>";
                var ssoflag= "<%= sso %>";
                if( ssoflag=="1" ){
                document.all.f1_5.value="<%= acct_no %>";
                if( acctkm.length==2) document.all.f1_4.value=acctkm;
                if( acctbr.length==4) document.all.f1_3.value=acctbr;
                }

		firstFocusField=document.all.f1_4;    // 20240329 f1_5 -> f1_4 Modified.
		lastFocusField=document.all.f1_5;
	}
	function checkPage(fieldArray){
		var acctno=document.all.f1_1.value+document.all.f1_2.value+document.all.f1_3.value+document.all.f1_4.value+document.all.f1_5.value;
		var cnslno=document.all.f2_1.value+document.all.f2_2.value+document.all.f2_3.value+document.all.f2_4.value+document.all.f2_5.value;
		push("p1", acctno);
		push("p2", cnslno);
//		debugInput();
		return true;
	}
	function flow() {
//		showOutputLength();
//		debugOutput();
		setMsg("253");
		go();
	}
	function u_changeField(){
		if(document.all.f3.value == '1') {
			u_setChange("f2","f1");
			document.all.f2_1.value=dpt_cd;
			document.all.f2_2.value=brn;
			document.all.f2_3.value=glyear;
			document.all.f2_4.value=cnsl;
		} else if(document.all.f3.value=='2') {
			u_setChange("f1","f2");
			document.all.f1_1.value="000";
			document.all.f1_2.value=dpt_cd;
			document.all.f1_3.value=getBranch();
			document.all.f1_4.value=acct;
		} else {
			document.all.f3.selectedIndex=1;
			u_setChange("f2","f1");
			document.all.f2_1.value=dpt_cd;
			document.all.f2_2.value=brn;
			document.all.f2_3.value=glyear;
			document.all.f2_4.value=cnsl;
		}
	}
	function u_setChange(a,b) {
		for(var i=1;i<=5;i++) {
			var en_unit=eval("document.all['"+a+"_"+i+"']");
			var dis_unit=eval("document.all['"+b+"_"+i+"']");
			var en_field=a+"_"+i;
			var dis_field=b+"_"+i;

			en_unit.disabled=false;
			setRequiredParam(en_field);

			dis_unit.value="";
			dis_unit.disabled=true;
			setNotRequiredParam(dis_field);
			dis_unit.style.background="#dddddd";
		}
		var setUnit=eval("document.all['"+a+"_"+"5']");
		setUnit.focus();
		firstFocusField=setUnit;
		lastFocusField=setUnit;
	}
</script>

<input type='hidden' name='code' value='02'>
<input type='hidden' name='RTN_FLAG' value='1'>
<button id=QUERY onclick="top.execute(document.all.trCode.value, '01')" style='border:1px inset;'><sup>F8</sup>&nbsp;<script>w1('QUERY')</script></button>
<button id=TRANSACTION type=submit style=margin-left:20><sup>F9</sup>&nbsp;<script>w1('TRANSACTION')</script></button>
<label style='width:40'></label>
<button id=PRINT onclick="printPDF('17010_40200','/codeXml/4.LON/17010_01out.xml')"><sup>&nbsp;</sup>&nbsp;<script>w1('PRINT')</script></button>
<p>
<label><script>w1('ENQKIND')</script></label>
<select name='f3' table='COMCOMB' key='4760' onChange="u_changeField()"></select><br>

<label><script>w1('CNSLNO')</script></label>
<input type='hidden' name='f2_1' style='width:40px'><input name='f2_2' style='width:40px'><input name='f2_3' style='width:40px'><input name='f2_4' style='width:25px'><input name='f2_5' style='width:60px'>
<label><script>w1('LONACCTNO')</script></label>
<input type='hidden' name='f1_1' style='width:40px'><input type='hidden' name='f1_2' style='width:40px'><input name='f1_3' style='width:40px'><input name='f1_4' style='width:25px'><input name='f1_5' style='width:60px'><br>
</p>
