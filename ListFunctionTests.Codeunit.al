codeunit 50106 ListFunctionTests
{
    Subtype = Test;

    [Test]
    procedure Add_Contains_Count_Get_Set()
    var
        AssertInstance: Codeunit Assert;
        MyList: List of [Text];
        Got: Text;
    begin
        // Arrange
        MyList.Add('Alpha');
        MyList.Add('Beta');

        // Act / Assert
        AssertInstance.AreEqual(2, MyList.Count(), 'Count() should return number of elements in the list.');
        AssertInstance.IsTrue(MyList.Contains('Alpha'), 'Contains() should return true for existing element.');
        AssertInstance.IsFalse(MyList.Contains('Gamma'), 'Contains() should return false for non-existing element.');

        Got := MyList.Get(2);
        AssertInstance.AreEqual('Beta', Got, 'Get should return element at 1-based index.');

        // Set replaces an existing element
        MyList.Set(2, 'Beta2');
        AssertInstance.AreEqual('Beta2', MyList.Get(2), 'Set should replace value at the specified index.');

        // Out-of-range Get/Set should raise runtime error
        asserterror Got := MyList.Get(0);
        asserterror Got := MyList.Get(3);
    end;

    [Test]
    procedure Insert_ShiftsElements_And_EdgeCases()
    var
        AssertInstance: Codeunit Assert;
        MyList: List of [Text];
    begin
        // Arrange
        MyList.AddRange('A', 'C'); // AddRange adds multiple items to a list

        // Insert in the middle
        MyList.Insert(2, 'B');
        AssertInstance.AreEqual(3, MyList.Count(), 'Insert should increase Count.');
        AssertInstance.AreEqual('A', MyList.Get(1), 'Should be A');
        AssertInstance.AreEqual('B', MyList.Get(2), 'Should be B');
        AssertInstance.AreEqual('C', MyList.Get(3), 'Should be C');

        // Insert at beginning
        MyList.Insert(1, 'Z');
        AssertInstance.AreEqual('Z', MyList.Get(1), 'Should be Z');
        AssertInstance.AreEqual('A', MyList.Get(2), 'Should be A');

        // Insert at Count+1 => append (valid)
        MyList.Insert(MyList.Count() + 1, 'Tail');
        AssertInstance.AreEqual('Tail', MyList.Get(MyList.Count()), 'Insert at Count+1 should append.');

        // Invalid insert indices should raise
        asserterror MyList.Insert(0, 'X'); // index 0 is invalid (one-based)
        asserterror MyList.Insert(-1, 'X');
    end;

    [Test]
    procedure Remove_RemoveAt_RemoveRange_Behaviour()
    var
        AssertInstance: Codeunit Assert;
        MyList: List of [Text];
        Ok: Boolean;
    begin
        // Arrange - duplicates to test Remove (first occurrence)
        MyList.AddRange('one', 'two', 'one', 'three');

        // Remove returns true when an element was removed
        Ok := MyList.Remove('one');
        AssertInstance.IsTrue(Ok, 'Remove should return true when it removes the first occurrence.');
        AssertInstance.AreEqual(3, MyList.Count(), 'Count should decrease after Remove.');

        // IndexOf / LastIndexOf verify which occurrence remains
        AssertInstance.AreEqual(1, MyList.IndexOf('two'), 'IndexOf returns 1-based index of first occurrence.');
        AssertInstance.AreEqual(2, MyList.LastIndexOf('one'), 'LastIndexOf should point to last occurrence.');

        // Remove a non-existing item returns false
        Ok := MyList.Remove('not-present');
        AssertInstance.IsFalse(Ok, 'Remove should return false if value not found.');

        // RemoveAt: when called as a function returns Boolean; use result to avoid runtime error
        Ok := MyList.RemoveAt(99); // out of range -> returns false (no runtime error when capturing return)
        AssertInstance.IsFalse(Ok, 'RemoveAt should return false when index out of range.');

        // But omitting the return value and using an invalid index will raise runtime error
        asserterror MyList.RemoveAt(99); // because return value omitted

        // RemoveRange when used with Ok := returns false if invalid; otherwise would raise
        Ok := MyList.RemoveRange(10, 1);
        AssertInstance.IsFalse(Ok, 'RemoveRange should return false when index/count invalid.');

        asserterror MyList.RemoveRange(10, 1); // omit return value -> runtime error
    end;

    [Test]
    procedure AddRange_GetRange_And_GetRange_Overload()
    var
        AssertInstance: Codeunit Assert;
        MyList: List of [Text];
        SubList: List of [Text];
    begin
        // AddRange adds multiple items at once
        MyList.AddRange('T1', 'T2', 'T3', 'T4');
        AssertInstance.AreEqual(4, MyList.Count(), 'AddRange should add multiple elements.');

        // GetRange returns a new List with the requested slice (one-based index)
        SubList := MyList.GetRange(2, 2);
        AssertInstance.AreEqual(2, SubList.Count(), 'GetRange should return requested number of elements.');
        AssertInstance.AreEqual('T2', SubList.Get(1), 'Should be T2');
        AssertInstance.AreEqual('T3', SubList.Get(2), 'Should be T3');

        // Overload that takes a var List parameter
        MyList.GetRange(1, 3, SubList);
        AssertInstance.AreEqual(3, SubList.Count(), 'GetRange overload with var parameter should populate the provided list.');
        AssertInstance.AreEqual('T1', SubList.Get(1), 'Should be T1');
        AssertInstance.AreEqual('T3', SubList.Get(3), 'Should be T3');

        // Invalid GetRange (out-of-bounds) raises runtime error
        asserterror SubList := MyList.GetRange(0, 1);
        asserterror SubList := MyList.GetRange(2, 10);
        asserterror SubList := MyList.GetRange(5, 1);
    end;

    [Test]
    procedure EdgeCases_InsertAndRemoveRange_Boundaries()
    var
        AssertInstance: Codeunit Assert;
        MyList: List of [Integer];
        Ok: Boolean;
    begin
        // Setup
        MyList.AddRange(1, 2, 3);

        // Insert with index > Count+1 should raise
        asserterror MyList.Insert(MyList.Count() + 2, 9);

        // Insert with index = Count+1 is valid (append)
        MyList.Insert(MyList.Count() + 1, 4);
        AssertInstance.AreEqual(4, MyList.Count(), 'Should be 4');

        // RemoveRange valid removal
        Ok := MyList.RemoveRange(2, 2); // removes 2 and 3
        AssertInstance.IsTrue(Ok, 'RemoveRange should return true when valid range removed.');
        AssertInstance.AreEqual(2, MyList.Count(), 'Should be 2');

        // RemoveRange with negative count or index should raise when used as statement
        asserterror MyList.RemoveRange(0, 1);
        asserterror MyList.RemoveRange(1, -1);

        // When capturing return value, invalid RemoveRange returns false instead of throwing
        Ok := MyList.RemoveRange(10, 1);
        AssertInstance.IsFalse(Ok, 'RemoveRange should return false when range invalid and return value is captured.');
    end;

    [Test]
    procedure IndexOf_LastIndexOf_Reverse_EdgeCases()
    var
        AssertInstance: Codeunit Assert;
        MyList: List of [Integer];
    begin
        // Empty list behaviors
        AssertInstance.AreEqual(0, MyList.Count(), 'New list should start with Count 0.');
        AssertInstance.AreEqual(0, MyList.IndexOf(1), 'IndexOf should return 0 when value not found.');
        AssertInstance.AreEqual(0, MyList.LastIndexOf(1), 'LastIndexOf should return 0 when value not found.');
        AssertInstance.IsFalse(MyList.Contains(1), 'Contains should be false on empty list.');

        // Add duplicates and verify IndexOf / LastIndexOf
        MyList.AddRange(5, 6, 5, 7, 5);
        AssertInstance.AreEqual(1, MyList.IndexOf(5), 'IndexOf returns first occurrence (1-based).');
        AssertInstance.AreEqual(5, MyList.LastIndexOf(5), 'LastIndexOf returns last occurrence (1-based).');

        // Reverse functionality
        MyList.Reverse();
        AssertInstance.AreEqual(5, MyList.Get(1), 'After Reverse, first element should be former last.');
        AssertInstance.AreEqual(5, MyList.Get(MyList.Count()), 'After Reverse, last element should be former first.');

        // Reverse empty list is a no-op (should not raise)
        MyList.RemoveRange(1, 5); // removes all 5 items from the list
        AssertInstance.AreEqual(0, MyList.Count(), 'After removing all items Count should be 0.');
        MyList.Reverse();
        AssertInstance.AreEqual(0, MyList.Count(), 'Reverse on empty list should keep Count 0.');
    end;
}