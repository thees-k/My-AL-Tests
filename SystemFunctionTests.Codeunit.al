// https://learn.microsoft.com/en-us/training/modules/al-built-in-functions/8-system-functions
codeunit 50107 SystemFunctionTests
{
    Subtype = Test;

    var
        AssertInstance: Codeunit Assert;
        DateTimeAssertHelper: Codeunit DateTimeAssertHelper;
        OriginalWorkDate: Date;
        Dt1: DateTime;
        Dt2: DateTime;

    [Test]
    procedure UserIdAndCompanyName_NotEmpty()
    var
        Uid: Text;
        Company: Text;
    begin
        // user id / company name should be available in the session
        Uid := UserId();
        Company := CompanyName();
        this.AssertInstance.IsTrue(Uid <> '', 'UserId must not be empty in the test environment');
        this.AssertInstance.IsTrue(Company <> '', 'CompanyName must not be empty in the test environment');
    end;

    [Test]
    procedure Today_IsConsistentWithinExecution()
    var
        D1: Date;
        D2: Date;
    begin
        // Today() should return the same date when called repeatedly within the same run
        D1 := Today();
        D2 := Today();
        this.AssertInstance.AreEqual(D1, D2, 'Today() should return the same date when called consecutively');
    end;

    [Test]
    procedure Time_CreateDateTime_AreNearlyEqual()
    begin
        // Combine Date + Time into DateTime twice and assert near equality with small delta
        // (allow small delta because time can tick between calls)
        this.Dt1 := System.CreateDateTime(Today(), Time());
        this.Dt2 := System.CreateDateTime(Today(), Time());
        // Delta is in milliseconds: 2000 ms = 2 seconds to tolerate clock ticks
        this.DateTimeAssertHelper.AssertDateTimeNear(this.Dt1, this.Dt2, 2000, 'message', this.AssertInstance);
    end;

    [Test]
    procedure WorkDate_GetSet_And_Restore()
    var
        NewWorkDate: Date;
    begin
        // Save original work date so the test can restore it
        this.OriginalWorkDate := WorkDate();

        // Set to a known different work date and assert it took effect
        NewWorkDate := Today() + 10;
        WorkDate(NewWorkDate);
        this.AssertInstance.AreEqual(NewWorkDate, WorkDate(), 'WorkDate should reflect the date passed to WorkDate(<Date>)');

        // Edge-case: set WorkDate to 0D (follow calendar day) - documented behavior
        WorkDate(0D);
        this.AssertInstance.AreEqual(Today(), WorkDate(), 'WorkDate(0D) should make WorkDate follow Today()');

        // Restore original value
        WorkDate(this.OriginalWorkDate);
        this.AssertInstance.AreEqual(this.OriginalWorkDate, WorkDate(), 'Original WorkDate must be restored at the end of the test');
    end;
}