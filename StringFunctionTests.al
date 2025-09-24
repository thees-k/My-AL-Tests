codeunit 50101 "StringFunctionTests"
{
    SubType = Test;

    [Test]
    procedure StrPos_FindSubstring()
    var
        s: Text;
        pos: Integer;
        Assert: Codeunit Assert;
    begin
        s := 'Hello world';
        pos := StrPos(s, 'world'); // 1-based -> should return 7
        Assert.AreEqual(7, pos, 'StrPos did not return expected index.');
    end;

    [Test]
    procedure StrPos_NotFound_ReturnsZero()
    var
        s: Text;
        pos: Integer;
        Assert: Codeunit Assert;
    begin
        s := 'abc';
        pos := StrPos(s, 'z');
        Assert.AreEqual(0, pos, 'StrPos should return 0 when substring not found.');
    end;

    [Test]
    procedure IndexOf_WorksLikeStrPos()
    var
        s: Text;
        pos1: Integer;
        pos2: Integer;
        Assert: Codeunit Assert;
    begin
        s := 'HelloWorldOfMany';
        pos1 := StrPos(s, 'l');       // expecting 3
        pos2 := s.IndexOf('l');       // expecting same
        Assert.AreEqual(pos1, pos2, 'IndexOf and StrPos should return the same first index.');
    end;

    [Test]
    procedure CopyStr_And_Substring_Basic()
    var
        s: Text[50];
        cut1: Text;
        cut2: Text;
        Assert: Codeunit Assert;
    begin
        s := 'HelloWorldOfManyManyCharacters';
        cut1 := CopyStr(s, 5, 10);           // 'oWorldOfMa'
        cut2 := s.Substring(5, 10);         // .NET-like method exposed in AL
        Assert.AreEqual(cut1, cut2, 'CopyStr and Substring did not return same result for valid indices.');
    end;

    [Test]
    procedure CopyStr_WithoutLength_ReturnsToEnd()
    var
        s: Text[10];
        result: Text;
        Assert: Codeunit Assert;
    begin
        s := 'abcdef';
        result := CopyStr(s, 3); // should return 'cdef'
        Assert.AreEqual('cdef', result, 'CopyStr without length did not return expected substring to end.');
    end;

    [Test]
    procedure SelectStr_And_Split_Equivalence()
    var
        s: Text[80];
        sel: Text;
        splitVal: Text;
        Assert: Codeunit Assert;
    begin
        s := 'This,is a comma,separated,string';
        sel := SelectStr(2, s);                  // 'is a comma'
        splitVal := s.Split(',').Get(2);         // using Split + Get(2)
        Assert.AreEqual(sel, splitVal, 'SelectStr and Split.Get did not return same element.');
    end;

    [Test]
    procedure InsStr_InsertsCorrectly()
    var
        s: Text[80];
        result: Text;
        Assert: Codeunit Assert;
    begin
        s := 'Press ENTER to continue.';
        result := InsStr(s, 'or ESC ', 13);
        Assert.AreEqual('Press ENTER or ESC to continue.', result, 'InsStr did not insert text correctly.');
    end;

    [Test]
    procedure StrLen_And_MaxStrLen()
    var
        s: Text[50];
        lenActual: Integer;
        lenMax: Integer;
        Assert: Codeunit Assert;
    begin
        s := '12345';
        lenActual := StrLen(s);      // 5
        lenMax := MaxStrLen(s);      // 50 because Text[50]
        Assert.AreEqual(5, lenActual, 'StrLen returned unexpected length.');
        Assert.AreEqual(50, lenMax, 'MaxStrLen returned unexpected value for Text[50].');
    end;

    [Test]
    procedure CaseConversion_ToUpper_ToLower()
    var
        s: Text;
        up1: Text;
        up2: Text;
        low1: Text;
        low2: Text;
        Assert: Codeunit Assert;
    begin
        s := 'HelloWorld';
        up1 := UpperCase(s);
        up2 := s.ToUpper();
        low1 := LowerCase(s);
        low2 := s.ToLower();

        Assert.AreEqual(up1, up2, 'UpperCase and ToUpper produced different results.');
        Assert.AreEqual(low1, low2, 'LowerCase and ToLower produced different results.');
        Assert.AreEqual('HELLOWORLD', up1, 'UpperCase did not produce expected uppercase string.');
        Assert.AreEqual('helloworld', low1, 'LowerCase did not produce expected lowercase string.');
    end;

    [Test]
    procedure IncStr_IncrementsNumberInString()
    var
        s: Text;
        result: Text;
        Assert: Codeunit Assert;
    begin
        s := 'Account no. 99 does not balance.';
        result := IncStr(s);
        Assert.IsTrue(StrPos(result, '100') > 0, 'IncStr did not increment the trailing number as expected.');
    end;

    [Test]
    procedure Contains_StartsWith_EndsWith()
    var
        s: Text;
        Assert: Codeunit Assert;
    begin
        s := 'Hello world';
        Assert.IsTrue(s.Contains('world'), 'Contains failed to detect substring.');
        Assert.IsTrue(s.StartsWith('Hello'), 'StartsWith failed.');
        Assert.IsTrue(s.EndsWith('world'), 'EndsWith failed.');
        Assert.IsFalse(s.StartsWith('world'), 'StartsWith returned true incorrectly.');
    end;

    [Test]
    procedure Replace_Remove_Trim()
    var
        s: Text[80];
        replaced: Text;
        removed: Text;
        trimmed: Text;
        Assert: Codeunit Assert;
    begin
        s := '  Hello world  ';
        replaced := s.Replace('world', 'planet');    // '  Hello planet  '
        removed := replaced.Remove(3, 6);             // remove 'Hello ' (start idx 3 length 6) -> leading two spaces remain + 'planet  '
        trimmed := removed.Trim();                    // trim leading/trailing spaces

        Assert.AreEqual('  Hello planet  ', replaced, 'Replace did not produce expected string.');
        // After Remove and Trim final should be 'planet'
        Assert.AreEqual('planet', trimmed, 'Remove/Trim combination did not yield expected result.');
    end;

    [Test]
    procedure PadLeft_PadRight_Lengths()
    var
        s: Text;
        leftPadded: Text;
        rightPadded: Text;
        Assert: Codeunit Assert;
    begin
        s := '12';
        leftPadded := s.PadLeft(5, '0');   // expected length 5, '00012'
        rightPadded := s.PadRight(5, '*'); // expected length 5, '12***'

        Assert.AreEqual(5, StrLen(leftPadded), 'PadLeft did not produce expected total length.');
        Assert.AreEqual(5, StrLen(rightPadded), 'PadRight did not produce expected total length.');
        Assert.AreEqual('00012', leftPadded, 'PadLeft did not pad as expected.');
        Assert.AreEqual('12***', rightPadded, 'PadRight did not pad as expected.');
    end;

    [Test]
    procedure LastIndexOf_FindsLastOccurrence()
    var
        s: Text;
        idx: Integer;
        Assert: Codeunit Assert;
    begin
        s := 'banana';
        idx := s.LastIndexOf('a'); // expecting 6 (1-based)
        Assert.AreEqual(6, idx, 'LastIndexOf did not find last occurrence correctly.');
    end;

    [Test]
    procedure TrimStart_TrimEnd()
    var
        s: Text;
        tStart: Text;
        tEnd: Text;
        Assert: Codeunit Assert;
    begin
        s := '  abc  ';
        tStart := s.TrimStart();
        tEnd := s.TrimEnd();
        Assert.AreEqual('abc  ', tStart, 'TrimStart did not remove leading spaces only.');
        Assert.AreEqual('  abc', tEnd, 'TrimEnd did not remove trailing spaces only.');
    end;
}
