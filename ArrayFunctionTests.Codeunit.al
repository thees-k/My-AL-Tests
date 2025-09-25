// https://learn.microsoft.com/en-us/training/modules/al-built-in-functions/6-array-functions
codeunit 50104 ArrayFunctionTests
{
    SubType = Test;

    [Test]
    procedure ArrayLen_BasicAndDimensions()
    var
        AssertInstance: Codeunit Assert;
        IntArray: array[10] of Integer;
        MultiDimArray: array[2, 3] of Integer;
        LengthResult: Integer;
        Index: Integer;
    begin
        // Empty array -> length 0
        LengthResult := ArrayLen(IntArray);
        AssertInstance.AreEqual(10, LengthResult, 'ArrayLen() should return the declared length of an array, in this case it is 10');

        // Array items have their default values
        for Index := 1 to 10 do
            AssertInstance.AreEqual(0, IntArray[Index], 'Element of array should have its default value 0.');

        // Assign three elements -> ArrayLen() should still return declared length!
        IntArray[1] := 10;
        IntArray[2] := 20;
        IntArray[3] := 30;
        LengthResult := ArrayLen(IntArray);
        AssertInstance.AreEqual(10, LengthResult, 'ArrayLen() should return the declared length of an array, in this case it is 10');

        // Multi-dimensional array: dimension sizes and total elements
        LengthResult := ArrayLen(MultiDimArray, 1);
        AssertInstance.AreEqual(2, LengthResult, 'ArrayLen on dimension 1 of a 2x3 array should be 2.');

        LengthResult := ArrayLen(MultiDimArray, 2);
        AssertInstance.AreEqual(3, LengthResult, 'ArrayLen on dimension 2 of a 2x3 array should be 3.');

        LengthResult := ArrayLen(MultiDimArray);
        AssertInstance.AreEqual(6, LengthResult, 'ArrayLen without Dimension for a 2x3 array should return total elements (6).');

        // Invalid dimension index must raise a runtime error
        asserterror LengthResult := ArrayLen(MultiDimArray, 3);
    end;

    [Test]
    procedure CompressArray_StringsAndCode_And_Blanks()
    var
        AssertInstance: Codeunit Assert;
        Cities: array[6] of Text[20];
        Codes: array[5] of Code[10];
        CountResult: Integer;
    begin
        // Setup with empty and blanks-only entries
        Cities[1] := 'Paris';
        Cities[2] := '';
        Cities[3] := 'Rome';
        Cities[4] := '   '; // blanks-only, is regarded as non-empty
        Cities[5] := '';
        Cities[6] := 'New York';

        // CompressArray returns count of non-empty entries and moves them to the beginning,
        // empty entries should appear at the end.
        CountResult := CompressArray(Cities);
        AssertInstance.AreEqual(4, CountResult, 'CompressArray should return number of non-empty entries.');

        AssertInstance.AreEqual('Paris', Cities[1], 'CompressArray should preserve relative order of non-empty entries (1).');
        AssertInstance.AreEqual('Rome', Cities[2], 'CompressArray should preserve relative order of non-empty entries (2).');
        AssertInstance.AreEqual('   ', Cities[3], 'CompressArray should preserve relative order of non-empty entries (3).');
        AssertInstance.AreEqual('New York', Cities[4], 'CompressArray should preserve relative order of non-empty entries (4).');
        AssertInstance.AreEqual('', Cities[5], 'Empty entries must be moved to the end (5).');
        AssertInstance.AreEqual('', Cities[6], 'Empty entries must be moved to the end (6).');

        // CompressArray also supports Code[n] arrays
        Codes[1] := 'A';
        Codes[2] := '';
        Codes[3] := 'B';
        Codes[4] := '';
        Codes[5] := 'C';
        CountResult := CompressArray(Codes);
        AssertInstance.AreEqual(3, CountResult, 'CompressArray should also work for Code[n] arrays and return count of non-empty elements.');
        AssertInstance.AreEqual('A', Codes[1], 'Should be A');
        AssertInstance.AreEqual('B', Codes[2], 'Should be B');
        AssertInstance.AreEqual('C', Codes[3], 'Should be C');
    end;

    [Test]
    procedure CopyArray_Basic_CopyPositionOnly_And_Errors()
    var
        AssertInstance: Codeunit Assert;
        SrcInt: array[10] of Integer;
        DestInt: array[5] of Integer;
        PartialDestInt: array[4] of Integer;
        CountIndex: Integer;
    begin
        // Populate source
        for CountIndex := 1 to 10 do
            SrcInt[CountIndex] := CountIndex;

        // Copy a consecutive block (position + length)
        CopyArray(DestInt, SrcInt, 6, 5); // copies the elements of positions 6 to 10
        AssertInstance.AreEqual(6, DestInt[1], 'CopyArray did not copy the expected first element (6).');
        AssertInstance.AreEqual(10, DestInt[5], 'CopyArray did not copy the expected last element (10).');

        asserterror CopyArray(PartialDestInt, SrcInt, 8); // Runtime error: CopyArray: The length parameter 3 does not match the length of the destination array 4.

    end;
}