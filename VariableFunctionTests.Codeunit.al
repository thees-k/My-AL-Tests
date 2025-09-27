// https://learn.microsoft.com/en-us/training/modules/al-built-in-functions/9-variable-functions
codeunit 50109 VariableFunctionTests
{
    SubType = Test;

    var
        MyCustomer: Record Customer;
        AssertInstance: Codeunit Assert;
        // variables used across tests to demonstrate Clear / ClearAll behavior
        MyText: Text[80];
        MyInteger: Integer;
        Ok: Boolean;

    //-----------------------------------------
    // Test 1: Clear(variable) — resets a single variable to its default
    //-----------------------------------------
    [Test]
    procedure Test_Clear_Simple()
    begin
        this.MyText := 'Hello Business Central';
        // demonstrate Clear - should set to default (empty string)
        Clear(this.MyText);

        this.AssertInstance.AreEqual('', this.MyText, 'Clear should set text to empty string.');
    end;

    //-----------------------------------------
    // Test 2: ClearAll() — resets variables and clears filters/keys (except the "Rec" system var)
    //-----------------------------------------
    [Test]
    procedure Test_ClearAll_ClearsAllVariablesAndFilters()
    begin
        // Setup: set a couple of variables and set a filter on a record variable
        this.MyText := 'will be cleared';
        this.MyInteger := 42;

        // Set a filter on the record variable so we can assert ClearAll removed it.
        // Use an existing customer No. (in CRONUS/sandbox you may need to adapt the value).
        this.MyCustomer.SetFilter("No.", '%1', '10000'); // attempt to set a filter

        // Verify preconditions (optional but clarifies intent)
        this.AssertInstance.IsTrue(StrLen(this.MyCustomer.GetFilters()) > 0, 'Precondition: filter must be set.');

        // Perform ClearAll
        ClearAll();

        // After ClearAll:
        // - myText and myInteger should be reset to default values
        // - filters on Cust should be cleared (GetFilters returns empty string)
        this.AssertInstance.AreEqual('', this.MyText, 'After ClearAll, text var must be default (empty).');
        this.AssertInstance.AreEqual(0, this.MyInteger, 'After ClearAll, integer var must be 0.');
        this.AssertInstance.AreEqual('', this.MyCustomer.GetFilters(), 'After ClearAll, record filters should be cleared.');
    end;

    //-----------------------------------------
    // Test 3: Evaluate(variable, text) — success case
    //-----------------------------------------
    [Test]
    procedure Test_Evaluate_Success_Integer()
    begin
        this.MyText := '5';
        this.MyInteger := 0;

        this.Ok := Evaluate(this.MyInteger, this.MyText); // returns true on success, assigns value to myInteger

        this.AssertInstance.IsTrue(this.Ok, 'Evaluate should return true for convertible text.');
        this.AssertInstance.AreEqual(5, this.MyInteger, 'Evaluate must assign numeric value when conversion succeeds.');
    end;

    //-----------------------------------------
    // Test 4: Evaluate(...) — failure case (string not convertible) — variable should remain unchanged
    //-----------------------------------------
    [Test]
    procedure Test_Evaluate_Failure_LeavesVariableUnchanged()
    begin
        this.MyText := 'not-a-number';
        this.MyInteger := 123; // deliberately non-default initial value

        this.Ok := Evaluate(this.MyInteger, this.MyText); // should return false

        this.AssertInstance.IsFalse(this.Ok, 'Evaluate should return false when conversion fails.');
        // Important: Evaluate must NOT modify the target variable on failure
        this.AssertInstance.AreEqual(123, this.MyInteger, 'On Evaluate failure the original variable value must remain unchanged.');
    end;

    //-----------------------------------------
    // Test 5: Format(variable) — converts to text
    //-----------------------------------------
    [Test]
    procedure Test_Format_Basic()
    begin
        this.MyInteger := 314;
        this.MyText := Format(this.MyInteger);

        // Format uses runtime culture settings — for simple integers this yields the numeric digits only.
        this.AssertInstance.AreEqual('314', this.MyText, 'Format(integer) should produce the textual digits of the integer.');
    end;

    //-----------------------------------------
    // (Optional) Additional demonstration / comment about culture-sensitive conversions
    // You should not rely on Evaluate/Format to parse/format decimals or dates without ensuring the
    // input string matches the tenant/regional settings. See notes below.
    //-----------------------------------------
}