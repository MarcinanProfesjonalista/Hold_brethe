#cs ----------------------------------------------------------------------------

	 AutoIt Version: 3.3.18.0
	 Author:         myName

	 Script Function:
		Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <Misc.au3>

Global $f8Held = False
Global $bothWasDown = False
Global $pressTimer = 0
Global $releaseTimer = 0
Global $waitingRelease = False

While 1

    If WinActive("STALZONE") Then

        Local $leftDown = _IsPressed("01")  ; LPM
        Local $rightDown = _IsPressed("02") ; PPM
        Local $bothDown = $leftDown And $rightDown

        ; NOWE NACISNIECIE OBU PRZYCISKOW
        If $bothDown And Not $bothWasDown Then
            $pressTimer = TimerInit()
            $waitingRelease = False
        EndIf

        ; OBA PRZYCISKI TRZYMANE
        If $bothDown Then

            $waitingRelease = False

            If Not $f8Held Then
                If TimerDiff($pressTimer) >= 0 Then
                    Send("{F9 down}")
                    $f8Held = True
                EndIf
            EndIf

        Else

            ; PUSZCZENIE JEDNEGO Z PRZYCISKOW
            If $f8Held And Not $waitingRelease Then
                $releaseTimer = TimerInit()
                $waitingRelease = True
            EndIf

            ; PUSC F8 PO 200 MS
            If $waitingRelease Then
                If TimerDiff($releaseTimer) >= 200 Then
                    Send("{F9 up}")
                    $f8Held = False
                    $waitingRelease = False
                EndIf
            EndIf

        EndIf

        $bothWasDown = $bothDown

    Else

        ; STALZONE NIEAKTYWNE
        If $f8Held Then
            Send("{F8 up}")
        EndIf

        $f8Held = False
        $bothWasDown = False
        $waitingRelease = False
        $pressTimer = 0
        $releaseTimer = 0

    EndIf

    Sleep(1)

WEnd
