' 防休眠脚本
On Error Resume Next

Set WshShell = CreateObject("WScript.Shell")
If Err.Number <> 0 Then
    WshShell.Popup "Error: Cannot create WScript.Shell object. Script cannot continue.", 5, "Fatal Error", 16
    WScript.Quit
End If

' 设置工作结束时间（24小时制）
endHour = 18
endMinute = 5

' 记录启动信息
WshShell.LogEvent 0, "Keep awake script started. Will exit at " & endHour & ":" & endMinute

Do
    ' 获取当前时间
    currentTime = Now()
    currentHour = Hour(currentTime)
    currentMinute = Minute(currentTime)

    ' 判断是否到达设定的结束时间（18:05）
    If currentHour >= endHour And currentMinute >= endMinute Then
        ' 到达18:05，弹出提示框并退出脚本
        WshShell.Popup "Work time over! Keep awake script stopped.", 10, "Info", 64
        WshShell.LogEvent 0, "Keep awake script exited as scheduled."
        WScript.Quit
    Else
        ' 在18:05之前，每分钟模拟一次按键
        WshShell.SendKeys "{SCROLLLOCK}"
        WScript.Sleep 100 ' 短暂延迟
        WshShell.SendKeys "{SCROLLLOCK}" ' 再按一次取消

        WScript.Sleep 60000 ' 等待60秒
    End If

    ' 错误检查
    If Err.Number <> 0 Then
        Err.Clear ' 清除错误
    End If
Loop