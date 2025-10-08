// File: TryFunctionTests.Codeunit.al
// Purpose: automated tests demonstrating AL TryFunction attribute and related System methods.
// Notes:
//  - Tests use the standard "Library Assert" testing helper (codeuni_t 130002). // The word "codeunit" followed by a number in a comment above the test codeunit causes AL Test Runner to run that codeunit!
//  - There is an illustrative (commented) example showing that database writes inside try methods
//    are unsupported and will cause a runtime error. Use with caution.

codeunit 50110 "TryFunctionTests"
{
    Subtype = test; // capital S is required here because of AL Test Runner issues

    var
        AssertCodeunit: Codeunit "Library Assert";

    [test]
    procedure Test_TryMethod_ReturnsTrue_WhenNoError()
    var
        OK: Boolean;
    begin
        // ensure no leftover error state
        System.ClearLastError();

        OK := this.SuccessfulTryMethod();

        // verify the try method reports success and that there's no last error text
        this.AssertCodeunit.IsTrue(OK, 'Expected successful try method to return true.');
        this.AssertCodeunit.IsTrue(System.GetLastErrorText() = '', 'Expected no last error text after successful try method.');
    end;

    [test]
    procedure Test_TryMethod_ReturnsFalse_OnError_And_GetLastErrorText()
    var
        OK: Boolean;
        LastErrorText: Text;
    begin
        // clear previous error and exercise failing try method
        System.ClearLastError();

        OK := this.FailingTryMethod();

        // the try-call should swallow the runtime error and return false
        this.AssertCodeunit.IsFalse(OK, 'Try method should return false when an error occurs.');

        // and GetLastErrorText should contain the error message produced
        LastErrorText := System.GetLastErrorText();
        this.AssertCodeunit.AreEqual(LastErrorText, 'Simulated failure for tryfunction test.', 'GetLastErrorText returned unexpected text.');
    end;

    // -------------------------------------------------------------------------
    // NOTE: the following test is intentionally commented out. It's provided as
    // an example only because attempting database writes inside a [tryfunction]
    // is unsupported and will cause a runtime error (the platform prevents it).
    // If you uncomment and run this during automated test runs, it will fail the
    // test run by design. Keep it as documentation / manual test only.
    //
    // [test]
    // procedure Example_TryMethod_WithDatabaseWrite_ShouldCauseRuntimeError()
    // var
    //     OK: Boolean;
    // begin
    //     // DO NOT enable this test in CI or automated runs — it's here to show
    //     // the platform behaviour described in the docs.
    //     OK := TryMethodThatWritesToDatabase();
    //     // we don't assert here because the call is expected to raise a runtime error
    // end;
    // -------------------------------------------------------------------------

    // a simple try-method that succeeds
    [tryfunction]
    local procedure SuccessfulTryMethod()
    begin
        // no errors -> try-method returns true (implicitly)
    end;

    // a simple try-method that raises an error
    [tryfunction]
    local procedure FailingTryMethod()
    begin
        error('Simulated failure for tryfunction test.');
    end;

    // // illustrative example: DO NOT call this from automated runs
    // [tryfunction]
    // local procedure TryMethodThatWritesToDatabase()
    // var
    //     TestCustomerRecord: Record Customer;
    // begin
    //     // Example only: inserting into a persistent table inside a try-method is unsupported.
    //     // The runtime/platform will block this and fail with a runtime error.
    //     TestCustomerRecord.Init();
    //     TestCustomerRecord.Name := 'ShouldNotBeInserted';
    //     TestCustomerRecord.Insert();
    // end;
}
