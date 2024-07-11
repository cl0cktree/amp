<%--
-- 24000_サインオン 初期画面
--
-- 変更履歴
--
--%>
<%@ page contentType="text/html; charset=Shift_JIS" %>
<script>
    var trInXml  = loadXML("/codeXml/1.COM/24000_01in.xml");
    var trOutXml = loadXML("/codeXml/1.COM/24000_01out.xml");
	
	
    function initPage() {
        document.all.f1.value = '0397';
        document.all.f2.value = top.TELR;
        firstFocusField = document.all.f2;
        lastFocusField  = document.all.f4;
    }

    function checkPage(fieldArray) {
        var DPT_CD = padNumber(fieldArray["f1"],4);   //銀行コード
        var TELR   = fieldArray["f2"];                //テラー番号番号
        var PSWD   = fieldArray["f3"].substring(0,8); //暗証番号：先頭８桁のみ
        var NWPSWD = fieldArray["f4"].substring(0,8); //新暗証番号：先頭８桁のみ
		console.log("checkPage test");
        var rcdGLPPOST = document.evaluate(".//record", top.GLPPOST, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null); 
        var cnt = rcdGLPPOST.snapshotLength;
		console.log("cnt :" + cnt);
        var dptcdArray   = new Array();
        var brnArray     = new Array();
        var postBrnArray = new Array();
	

        // 20150603, パスワードの最小桁数：銀行情報パラメータ(COMMSFC)から取得
        var iPwdMinLen = u_GetPwdMinLen(DPT_CD);
		console.log("iPwdMinLen :" + iPwdMinLen);
        // 20160512, 重複文字チェック
        var isSame = /([A-Za-z0-9])\1\1/;
        if ( isSame.test(document.all.f4.value) ) {
                alertError("091153");
                setFocus(document.all.f4);
                return false;
        }
        // 20160516,スペース文字チェック
            if ( String(document.all.f4.value).replace(/\s+$/g, "").match(' ') ) {
                alertError("091152");
                setFocus(document.all.f4);
                return false;
            }
        try {
            for (var i=0; i<cnt; i++) {
				var node = rcdGLPPOST.snapshotItem(i); 
                dptcdArray[i]   = node.getAttribute("DPT_CD");   //BANKコード
                brnArray[i]     = node.getAttribute("BRN");      //支店コード
                postBrnArray[i] = node.getAttribute("POST_BRN"); //会計処理店番
            }

            /* 20150508,【B-07】ﾊﾟｰｽﾜｰﾄﾞﾊｯｼｭー化対応*/
            //「暗証番号(f3)」にてsalt + ストレッチングしたパスワードを取得
            var stretchedPswd = top.getStretchedPassword(PSWD, TELR);
			console.log("stretchedPswd :" + stretchedPswd);
            var ch = top.createChallenge();
			console.log("ch :" + ch);
            fieldArray["f3"] = top.getStretchedPassword(stretchedPswd, ch);

            //「新暗証番号(f4)」：
            if( trim(NWPSWD) != "" ){
                // 20150603, 入力値チェック：「新暗証番号(f4)」にてパスワードの最小桁数
                if ( document.all.f4.value.length < iPwdMinLen ){
                    alertError("91151"); //91151:パスワードが最小桁数を下回ってます。
                    setFocus(document.all.f4);
                    return false;
                }
                fieldArray["f4"] = top.getStretchedPassword(NWPSWD, TELR);
            }
            fieldArray["f5"] = padChar(top.IPAddress, 15);   //IP Address

            fieldArray["f6"] = padNumber(cnt.toString(), 3); //入力データ数
            fieldArray["f7"] = dptcdArray;  //BANKコード
            fieldArray["f8"] = brnArray;    //支店コード
            fieldArray["f9"] = postBrnArray;//会計処理店番

            // INPUTヘッダー値のセット
            top.iHeader["DPT_CD"] = DPT_CD;
            top.iHeader["TELR"]   = TELR;
            top.iHeader["IPADDR"] = padChar(top.IPAddress, 15);

            var comtxcd = top.getCOMTXCD(top.iHeader["DPT_CD"], "0"+document.all.trCode.value);
			
            top.iHeader["OTHER_SYS_TERM"] = comtxcd.getAttribute("OTHER_SYS_TERM");
			console.log("top.iHeader[OTHER_SYS_TERM] :" + top.iHeader["OTHER_SYS_TERM"]);
        }catch (e) {
            throw new Error(0,"4006 : "+top.getErrMsg("4006"));
        }
        //debugInput();
        return true;
    }
    function flow() {
		console.log("flow go");
        go();
    }
    function u_exit(){
		alert("close");
        top.close();
    }
    // 20150603, パスワードの入力最小桁数取得
    function u_GetPwdMinLen(dptcd){
        var nodeResult = document.evaluate(".//record[@DPT_CD='" + dptcd + "']", top.COMMSFC, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null); 
		var node = nodeResult.singleNodeValue;
        var ipwdmaxlen = (node) ? node.getAttribute("TELR_PSWD_LENGTH") : alertError("91007");

        return ipwdmaxlen;
    }
</script>
<style>.label_align{display:inline-block;width:72px;}</style>
<input type='hidden' name='code' value='02'>
<input type='hidden' name='RTN_FLAG' value='9'>
<input type='hidden' name='pswd_auth_indexs' value='304,314'>
<TABLE width=100% style ='height:100vh;'>
	<tr>
		<td align=center>
<!-- 20240617 ?? td ??? label? .label_align ?? -->
<!--BANKコード(f1)-->
		<label class="label_align"><script>w1("DPTCD")</script></label>
		<input NAME="f1" style="width:115px;/* margin-bottom; 2px; */" maxlength="4"><br>
<!--テラー番号(f2)-->
		<label class="label_align"><script>w1("TELRNUMBER")</script></label>
		<input NAME="f2" maxlength='10' style="width:115px" autocomplete="username"><br>
<!--暗証番号(f3):20150603,最大桁数指定-->
		<label class="label_align"><script>w1("PSWD")</script></label>
		<input NAME="f3" type="password" style="height:20px; width:115px" maxlength='8' autocomplete="new-password"><BR>
<!--新暗証番号(f4):20150603,最大桁数指定-->
		<label class="label_align"><script>w1("NEWPSWD")</script></label>
		<input NAME="f4" type="password" style="height:20px; width:115px" maxlength='8' autocomplete="new-password"><BR>
		<BUTTON id="TRANSACTION" type="submit" style='margin-left:76px; width:50px'  ><script>w1("TRANSACTION")</script></BUTTON>
		<BUTTON style='margin-left:10px; width:50px' id="EXIT" onClick="u_exit()"><script>w1("EXIT")</script></BUTTON>
		</td>
	</tr>
</TABLE>

