; 左 Ctrl の動作を Mac 風にする AutoHotkey スクリプト
;
; AutoHotkey: v1.1.22.07
; Author:     karakaram   http://www.karakaram.com/hhkb-pro2-windows-customize

#InstallKeybdHook
#UseHook

; 左 Ctrl の動作を Mac 風に
<^a::switchKeyByWindow("{Home}", "^a")
+<^a::switchKeyByWindow("+{Home}", "+^a")
<^e::switchKeyByWindow("{End}", "^e")
+<^e::switchKeyByWindow("+{End}", "+^e")
<^f::switchKeyByWindow("{Right}", "^f")
+<^f::switchKeyByWindow("+{Right}", "+^f")
<^b::switchKeyByWindow("{Left}", "^b")
+<^b::switchKeyByWindow("+{Left}", "+^b")
<^p::switchKeyByWindow("{Up}", "^p")
+<^p::switchKeyByWindow("+{Up}", "^+p")
<^n::switchKeyByWindow("{Down}", "^n")
+<^n::switchKeyByWindow("+{Down}", "+^n")
<^o::switchKeyByWindow("{End}{Enter}", "^o")
<^h::switchKeyByWindow("{Backspace}", "^h")
<^d::switchKeyByWindow("{Delete}", "^d")

; 日本語入力中の変換（若干挙動があやしい）
; 左 Ctrl + k で全角カタカナ(F7)
<^k::switchKeyByIMEStatus("+{End}{Delete}", "^k", "{F7}")
; 左 Ctrl + l で全角英数(F9)
<^l::switchKeyByIMEStatus("^l", "^l", "{F9}")
; 左 Ctrl + ; で半角ｶﾀｶﾅ(F8)
<^;::switchKeyByIMEStatus("^;", "^;", "{F8}")
; 左 Ctrl + ' で半角英数(F10)
<^'::switchKeyByIMEStatus("^'", "^'", "{F10}")


;----------------------------------------------------------------
; Ctrl キーを送信する Window かどうかを判断する
;
; return   1:差し替えを無効にするウィンドウ
;          0:差し替えを有効にするウィンドウ
;----------------------------------------------------------------
isCtrlKeyWindow()
{
    ; GVim
    IfWinActive,ahk_class Vim
    {
        return 1
    }
    ; Poderosa
    IfWinActive,ahk_class WindowsForms10.Window.8.app.0.20f9772
    {
        return 1
    }
    ; Mingw
    IfWinActive,ahk_class ConsoleWindowClass
    {
        return 1
    }
    ; Tera Term
    IfWinActive,ahk_class VTWin32
    {
        return 1
    }
    ; Sygwin
    IfWinActive,ahk_class mintty
    {
        return 1
    }

    Return 0
}

;----------------------------------------------------------------
; Window によって送信するキーを振り分ける
;
; defaultKey    デフォルトで送信するキー
; ctrlKey       Ctrlを送信するウィンドウのとき送信するキー
;----------------------------------------------------------------
switchKeyByWindow(defaultKey, ctrlKey)
{
    if (isCtrlKeyWindow())
    {
        Send,%ctrlKey%
    }
    else
    {
        Send,%defaultKey%
    }
    Return
}

;----------------------------------------------------------------
; IME 変換中の場合に送信するキーを振り分ける
;
; defaultKey    デフォルトで送信するキー
; ctrlKey       Ctrl を送信するウィンドウのときに送信するキー
; functionKey   IME 変換中のときに送信するキー
;----------------------------------------------------------------
switchKeyByIMEStatus(defaultKey, ctrlKey, functionKey)
{
    if (IME_GetConverting() > 0)
    {
        Send,%functionKey%
    }
    else if (isCtrlKeyWindow())
    {
        Send,%ctrlKey%
    }
    else
    {
        Send,%defaultKey%
    }
    Return
}
