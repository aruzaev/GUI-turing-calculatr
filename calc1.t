import GUI %Importing the ability to use GUI code from Turing files

%Calculator Basics --------

var widgetName : int
var number : int := 0
var total : real := 0
var operator : string := ""
const maxNumbers : int := 12

%Input Buttons -------------------------------

var subtractButton : int
var exponentButton : int
var sqrtButton : int
var equalButton : int
var clearButton : int
var quitButton : int
var zeroButton : int
var calculationBox : int
var messageBox : int

%Logical Decralarations --------------------------

var numberedButton : array 1 .. maxNumbers of int
var buffer : int := 0
var equalPressed : boolean := false

%Procedure Declarations --------------------------

forward procedure intitializeEnvironment
forward procedure processClick
forward procedure addNumber (numberToAdd : int)
forward procedure operatorPressed (op : string)
forward procedure debug

%Button and Visual Creation -------------------------------------------

body procedure intitializeEnvironment %Begins the first procedure of creating the environment
    setscreen ("graphics:600;500") %Sets the screen size
    /*Creates the function buttons and puts them in their specified coordinates, followed by a second procedure 
    that allows the buttons to be pressed */
    quitButton := GUI.CreateButton (100, 100, 50, "Quit", processClick)
    zeroButton := GUI.CreateButton (200, 100, 50, "0", processClick)
    sqrtButton := GUI.CreateButton (300, 100, 50, "sqrt", processClick)
    equalButton := GUI.CreateButton (100, 50, 350, "=", processClick)
    subtractButton := GUI.CreateButton (400, 300, 50, "-", processClick)
    clearButton := GUI.CreateButton (400, 350, 50, "AC", processClick)
    exponentButton := GUI.CreateButton (400, 100, 50, "**", processClick)
    calculationBox := GUI.CreateTextBox (100, 300, 250, 75)
    messageBox := GUI.CreateTextBox (100, 400, 250, 75)

%Creates the numbered buttons -------------------------------

    %Buttons 1 - 3
    for drawNumberedButtons : 1 .. 4
	numberedButton (drawNumberedButtons) :=
	    GUI.CreateButton (100 * drawNumberedButtons, 150, 50,
	    intstr (drawNumberedButtons), processClick)

    end for
    GUI.SetLabel (numberedButton (4), "X")

    %Buttons 4 - 6
    for drawNumberedButtons : 1 .. 4
	numberedButton (drawNumberedButtons + 4) :=
	    GUI.CreateButton (100 * drawNumberedButtons, 200, 50,
	    intstr (drawNumberedButtons + 3), processClick)
    end for
    GUI.SetLabel (numberedButton (8), "/")

    %Buttons 7 - 9
    for drawNumberedButtons : 1 .. 4
	numberedButton (drawNumberedButtons + 8) :=
	    GUI.CreateButton (100 * drawNumberedButtons, 250, 50,
	    intstr (drawNumberedButtons + 6), processClick)
    end for
    GUI.SetLabel (numberedButton (12), "+")

end intitializeEnvironment %Ends intitializing the environment

%Creation of the clicking procedure ----------------------------

body procedure processClick
    const myFont := Font.New ("Arial:60:Bold")
    const myFont1 := Font.New ("Arial:30:Bold")
    widgetName := GUI.GetEventWidgetID

    %Sets the function of the quit button
    if widgetName = quitButton then
	GUI.Dispose (quitButton) 
	for disposeItAll : 1 .. maxNumbers
	    GUI.Dispose (numberedButton (disposeItAll))
	end for                                         %If the quit button is clicked, then remove everything
	GUI.Dispose (equalButton)
	GUI.Dispose (subtractButton)
	GUI.Dispose (sqrtButton)
	GUI.Dispose (exponentButton)
	GUI.Dispose (zeroButton)
	GUI.Dispose (clearButton)
	GUI.Dispose (calculationBox)
	GUI.Dispose (messageBox)



	Font.Draw ("The End", maxx div 4, maxx div 2, myFont, 50) %Put "The End" when it quits
	for changeColour : 4 .. 12
	    delay (100)
	end for
	GUI.Quit

	%If a number or operator is pressed, then output that symbol into the program's box and buffer
    elsif widgetName = zeroButton then
	addNumber (0)
    elsif widgetName = numberedButton (1) then
	addNumber (1)
    elsif widgetName = numberedButton (2) then
	addNumber (2)
    elsif widgetName = numberedButton (3) then
	addNumber (3)
    elsif widgetName = numberedButton (5) then
	addNumber (4)
    elsif widgetName = numberedButton (6) then
	addNumber (5)
    elsif widgetName = numberedButton (7) then
	addNumber (6)
    elsif widgetName = numberedButton (9) then
	addNumber (7)
    elsif widgetName = numberedButton (10) then
	addNumber (8)
    elsif widgetName = numberedButton (11) then
	addNumber (9)
    elsif widgetName = subtractButton then
	operatorPressed ("-")
    elsif widgetName = equalButton then
	operatorPressed ("=")

	%If the clear button is pressed, then clear all of the program's storage
    elsif widgetName = clearButton then
	GUI.ClearText (calculationBox)
	number := 0
	total := 0
	buffer := 0
	operator := ""
    elsif widgetName = numberedButton (4) then
	operatorPressed ("*")
    elsif widgetName = numberedButton (8) then
	operatorPressed ("/")
    elsif widgetName = numberedButton (12) then
	operatorPressed ("+")
    elsif widgetName = exponentButton then
	operatorPressed ("**")
    elsif widgetName = sqrtButton then
	operatorPressed ("sqrt")
    end if
end processClick %Ends the procedure of process click

body procedure addNumber %Saves the previous second number of a previous equation
    debug
    if equalPressed = true then
	number := numberToAdd
	total := 0
	GUI.AddLine (calculationBox, "")
	equalPressed := false
    else
	number := number * 10 + numberToAdd
    end if
    GUI.AddText (calculationBox, intstr (numberToAdd))
    debug
end addNumber

body procedure operatorPressed %Saves the previous operator and utilizes it
    debug
    if total = 0 and number = 0 then
	GUI.ClearText (calculationBox)
	GUI.AddText (calculationBox, "Syntax Error")
    elsif op = "sqrt" then     
	if total = 0 then
	    total := number
	end if
	total := sqrt (total)
	GUI.AddLine (calculationBox, "=")
	GUI.AddText (calculationBox, realstr (total, 0))
	equalPressed := true
    else
       if op = "=" then
	    GUI.AddLine (calculationBox, "=")
	    if number = 0 then
		number := buffer
	    end if
	    buffer := number
	    equalPressed := true
	else
	    GUI.AddText (calculationBox, op)
	end if
    %Creates the function of reusing the previous number and the previous operator in a new equation
	if operator = "+" then
	    total := total + number
	elsif operator = "-" then
	    total := total - number
	elsif operator = "*" then
	    total := total * number
	elsif operator = "/" then
	    total := total div number
	elsif operator = "**" then
	    total := total ** number
	elsif operator = "" then
	    total := number
	end if
	if op not= "=" then
	    operator := op
	else
	    GUI.AddText (calculationBox, realstr (total, 0))
	end if
    end if

    number := 0
    if op not= "=" then
	buffer := 0
	equalPressed := false
    end if
    debug
end operatorPressed

body procedure debug
    GUI.AddLine (messageBox, "")
    GUI.AddText (messageBox, "n: " + intstr (number) + " b: " + intstr (buffer) + " o: " + operator + " t: " + realstr (total, 0))
end debug

%End of the framework of the program and beginning of actual program

intitializeEnvironment

loop
    exit when GUI.ProcessEvent
end loop
