// https://learn.microsoft.com/en-us/training/modules/al-built-in-functions/3-string-functions
codeunit 50101 "StringFunctionTests"
{
    SubType = Test;

    [Test]
    procedure StrPos_FindSubstring()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text;
        Position: Integer;
    begin
        InputText := 'Hello world';
        Position := StrPos(InputText, 'world'); // 1-based -> should return 7
        AssertInstance.AreEqual(7, Position, 'StrPos did not return expected index.');
    end;

    [Test]
    procedure StrPos_NotFound_ReturnsZero()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text;
        Position: Integer;
    begin
        InputText := 'abc';
        Position := StrPos(InputText, 'z');
        AssertInstance.AreEqual(0, Position, 'StrPos should return 0 when substring not found.');
    end;

    [Test]
    procedure IndexOf_WorksLikeStrPos()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text;
        FirstPos: Integer;
        SecondPos: Integer;
    begin
        InputText := 'HelloWorldOfMany';
        FirstPos := StrPos(InputText, 'l');       // expecting 3
        SecondPos := InputText.IndexOf('l');       // expecting same
        AssertInstance.AreEqual(FirstPos, SecondPos, 'IndexOf and StrPos should return the same first index.');
    end;

    [Test]
    procedure CopyStr_And_Substring_Basic()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text[50];
        Cut1: Text;
        Cut2: Text;
    begin
        InputText := 'HelloWorldOfManyManyCharacters';
        Cut1 := CopyStr(InputText, 5, 10);           // 'oWorldOfMa'
        Cut2 := InputText.Substring(5, 10);         // .NET-like method exposed in AL
        AssertInstance.AreEqual(Cut1, Cut2, 'CopyStr and Substring did not return same result for valid indices.');
    end;

    [Test]
    procedure CopyStr_WithoutLength_ReturnsToEnd()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text[10];
        ResultText: Text;
    begin
        InputText := 'abcdef';
        ResultText := CopyStr(InputText, 3); // should return 'cdef'
        AssertInstance.AreEqual('cdef', ResultText, 'CopyStr without length did not return expected substring to end.');
    end;

    [Test]
    procedure SelectStr_And_Split_Equivalence()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text[80];
        SelectedPart: Text;
        SplitValue: Text;
    begin
        InputText := 'This,is a comma,separated,string';
        SelectedPart := SelectStr(2, InputText);                  // 'is a comma'
        SplitValue := InputText.Split(',').Get(2);         // using Split + Get(2)
        AssertInstance.AreEqual(SelectedPart, SplitValue, 'SelectStr and Split.Get did not return same element.');
    end;

    [Test]
    procedure InsStr_InsertsCorrectly()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text[80];
        ResultText: Text;
    begin
        InputText := 'Press ENTER to continue.';
        ResultText := InsStr(InputText, 'or ESC ', 13);
        AssertInstance.AreEqual('Press ENTER or ESC to continue.', ResultText, 'InsStr did not insert text correctly.');
    end;

    [Test]
    procedure StrLen_And_MaxStrLen()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text[50];
        LenActual: Integer;
        LenMax: Integer;
    begin
        InputText := '12345';
        LenActual := StrLen(InputText);      // 5
        LenMax := MaxStrLen(InputText);      // 50 because Text[50]
        AssertInstance.AreEqual(5, LenActual, 'StrLen returned unexpected length.');
        AssertInstance.AreEqual(50, LenMax, 'MaxStrLen returned unexpected value for Text[50].');
    end;

    [Test]
    procedure CaseConversion_ToUpper_ToLower()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text;
        Upper1: Text;
        Upper2: Text;
        Lower1: Text;
        Lower2: Text;
    begin
        InputText := 'HelloWorld';
        Upper1 := UpperCase(InputText);
        Upper2 := InputText.ToUpper();
        Lower1 := LowerCase(InputText);
        Lower2 := InputText.ToLower();

        AssertInstance.AreEqual(Upper1, Upper2, 'UpperCase and ToUpper produced different results.');
        AssertInstance.AreEqual(Lower1, Lower2, 'LowerCase and ToLower produced different results.');
        AssertInstance.AreEqual('HELLOWORLD', Upper1, 'UpperCase did not produce expected uppercase string.');
        AssertInstance.AreEqual('helloworld', Lower1, 'LowerCase did not produce expected lowercase string.');
    end;

    [Test]
    procedure IncStr_IncrementsNumberInString()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text;
        ResultText: Text;
    begin
        InputText := 'Account no. 99 does not balance.';
        ResultText := IncStr(InputText);
        AssertInstance.IsTrue(StrPos(ResultText, '100') > 0, 'IncStr did not increment the trailing number as expected.');
    end;

    [Test]
    procedure Contains_StartsWith_EndsWith()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text;
    begin
        InputText := 'Hello world';
        AssertInstance.IsTrue(InputText.Contains('world'), 'Contains failed to detect substring.');
        AssertInstance.IsTrue(InputText.StartsWith('Hello'), 'StartsWith failed.');
        AssertInstance.IsTrue(InputText.EndsWith('world'), 'EndsWith failed.');
        AssertInstance.IsFalse(InputText.StartsWith('world'), 'StartsWith returned true incorrectly.');
    end;

    [Test]
    procedure Replace_Remove_Trim()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text[80];
        ReplacedText: Text;
        RemovedText: Text;
        TrimmedText: Text;
    begin
        InputText := '  Hello world  ';
        ReplacedText := InputText.Replace('world', 'planet');    // '  Hello planet  '
        RemovedText := ReplacedText.Remove(3, 6);             // remove 'Hello ' (start idx 3 length 6) -> leading two spaces remain + 'planet  '
        TrimmedText := RemovedText.Trim();                    // trim leading/trailing spaces

        AssertInstance.AreEqual('  Hello planet  ', ReplacedText, 'Replace did not produce expected string.');
        // After Remove and Trim final should be 'planet'
        AssertInstance.AreEqual('planet', TrimmedText, 'Remove/Trim combination did not yield expected result.');
    end;

    [Test]
    procedure PadLeft_PadRight_Lengths()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text;
        LeftPaddedText: Text;
        RightPaddedText: Text;
    begin
        InputText := '12';
        LeftPaddedText := InputText.PadLeft(5, '0');   // expected length 5, '00012'
        RightPaddedText := InputText.PadRight(5, '*'); // expected length 5, '12***'

        AssertInstance.AreEqual(5, StrLen(LeftPaddedText), 'PadLeft did not produce expected total length.');
        AssertInstance.AreEqual(5, StrLen(RightPaddedText), 'PadRight did not produce expected total length.');
        AssertInstance.AreEqual('00012', LeftPaddedText, 'PadLeft did not pad as expected.');
        AssertInstance.AreEqual('12***', RightPaddedText, 'PadRight did not pad as expected.');
    end;

    [Test]
    procedure LastIndexOf_FindsLastOccurrence()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text;
        IndexOfLast: Integer;
    begin
        InputText := 'banana';
        IndexOfLast := InputText.LastIndexOf('a'); // expecting 6 (1-based)
        AssertInstance.AreEqual(6, IndexOfLast, 'LastIndexOf did not find last occurrence correctly.');
    end;

    [Test]
    procedure TrimStart_TrimEnd()
    var
        AssertInstance: Codeunit Assert;
        InputText: Text;
        TrimmedStart: Text;
        TrimmedEnd: Text;
    begin
        InputText := '  abc  ';
        TrimmedStart := InputText.TrimStart();
        TrimmedEnd := InputText.TrimEnd();
        AssertInstance.AreEqual('abc  ', TrimmedStart, 'TrimStart did not remove leading spaces only.');
        AssertInstance.AreEqual('  abc', TrimmedEnd, 'TrimEnd did not remove trailing spaces only.');
    end;
}
