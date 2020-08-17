#NoEnv

 ; Mouse to Keyboard Map tool. Map Mouse Movements and Buttons to Keyboard keys
 ; Author: Hide Techno Tips
 ; Youtube Channel "HiDe Techno Tips HDTT" Link: https://www.youtube.com/channel/UCy3fBVKd0RMY05CgiiuGqSA?sub_confirmation=1
 ; Please Subscribe to my Youtube Channel.
 ; My GitHub Profile: https://github.com/HiDe-Techno-Tips

 ; Default Hotkeys:
 ; Press F6 to Show or Hide the Mouse Cursor.
 ; Press F7 to toggle Pause and Suspend.
 ; Press F8 to Start The Mouse Movement to Keyboard map.

F6::SystemCursor(-1)  ; Pressing the key before "::" shows or hides the Mouse Cursor.
return

F7::                  ; Pressing the key before "::" toggles Pause script and Suspend Hotkeys.
Suspend
Pause, , 1
return

 ; Mouse Buttons/Wheel to Keyboard Map.
 ; Pressing Mouse Buttons or rotating Wheel before "::" presses the key after "::" below.
LButton::u           ; For Left Mouse Button.
RButton::o           ; For Right Mouse Button.
MButton::8           ; For Middle Mouse Button.
WheelUp::Up           ; For Mouse Wheel up.
WheelDown::Down         ; For Mouse Wheel down.
WheelLeft::Left         ; For Mouse Wheel Left of compatible Mouse.
WheelRight::Right        ; For Mouse Wheel Right of compatible Mouse.
XButton1::9          ; For Mouse Thumb Button 1 of compatible Mouse.
XButton2::3          ; For Mouse Thumb Button 2 of compatible Mouse.

 ; Keys to Simulate Left and Right Mouse Button while Hotkeys are active.
[::LButton            ; The Key before "::" will work as Left Mouse Button while Hotkeys are active.
]::RButton            ; The Key before "::" will work as Right Mouse Button while Hotkeys are active.

F8::                ; Pressing key before "::" Starts the Main Script.
Main:                ; Main Script starts from this label.

 ; Center Co-Ordinates for Mouse Cursor.
x:=683
y:=384

 ; Mouse Movement to Keyboard Map.
 ; Moving mouse towards the direction before "=" presses the key after "=" below.
ToRight=j
ToLeft=l
ToUp=i
ToDown=k

MouseMove, x, y         ; Move Mouse Cursor to the center Co-Ordinates.
Sleep, 5
MouseGetPos, x1, y1     ; Get New Mouse cursor Co-Ordinate after sleep time.

ax:=(2*((x1-x)+25))     ; Horizontal Displacement of Mouse Cursor modified such that center is 50.
ay:=(2*((y1-y)+25))     ; Vertical Displacement of Mouse Cursor modified such that center is 50.

if (ax<50){                  ; Press and Hold the Right key if Mouse Cursor is moving towards right.
Send {Blind}{%ToRight% down}
}
if (ax>50){                  ; Press and Hold the Left key if Mouse Cursor is moving towards left.
Send {Blind}{%ToLeft% down}
}
if (ay<50){                  ; Press and Hold the Up key if Mouse Cursor is moving up.
Send {Blind}{%ToUp% down}
}
if (ay>50){                  ; Press and Hold the Down key if Mouse Cursor is moving down.
Send {Blind}{%ToDown% down}
}

if (ax=50){                  ; Release Left and Right Keys if Mouse Cursor is not moving Horizontally.
Send {Blind}{%ToRight% up}
Send {Blind}{%ToLeft% up}
}
if (ay=50){                  ; Release Up and Down Keys if Mouse Cursor is not moving vertically.
Send {Blind}{%ToUp% up}
Send {Blind}{%ToDown% up}
}

Goto, Main                   ; To run the Main script again and again without pressing hotkey.

 ; Function to Show or Hide the Mouse Cursor.
SystemCursor(OnOff=1)   ; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
{
    static AndMask, XorMask, $, h_cursor
        ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13 ; system cursors
        , b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13   ; blank cursors
        , h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13   ; handles of default cursors
    if (OnOff = "Init" or OnOff = "I" or $ = "")       ; init when requested or at first call
    {
        $ = h                                          ; active default cursors
        VarSetCapacity( h_cursor,4444, 1 )
        VarSetCapacity( AndMask, 32*4, 0xFF )
        VarSetCapacity( XorMask, 32*4, 0 )
        system_cursors = 32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650
        StringSplit c, system_cursors, `,
        Loop %c0%
        {
            h_cursor   := DllCall( "LoadCursor", "Ptr",0, "Ptr",c%A_Index% )
            h%A_Index% := DllCall( "CopyImage", "Ptr",h_cursor, "UInt",2, "Int",0, "Int",0, "UInt",0 )
            b%A_Index% := DllCall( "CreateCursor", "Ptr",0, "Int",0, "Int",0
                , "Int",32, "Int",32, "Ptr",&AndMask, "Ptr",&XorMask )
        }
    }
    if (OnOff = 0 or OnOff = "Off" or $ = "h" and (OnOff < 0 or OnOff = "Toggle" or OnOff = "T"))
        $ = b  ; use blank cursors
    else
        $ = h  ; use the saved cursors

    Loop %c0%
    {
        h_cursor := DllCall( "CopyImage", "Ptr",%$%%A_Index%, "UInt",2, "Int",0, "Int",0, "UInt",0 )
        DllCall( "SetSystemCursor", "Ptr",h_cursor, "UInt",c%A_Index% )
    }
}