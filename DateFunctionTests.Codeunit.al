// https://learn.microsoft.com/en-us/training/modules/al-built-in-functions/4-date-functions
codeunit 50103 "DateFunctionTests"
{
    SubType = Test;

    [Test]
    procedure Date2DMY_BasicParts()
    var
        AssertInstance: Codeunit Assert;
        DateValue: Date;
        DayPart: Integer;
        MonthPart: Integer;
        YearPart: Integer;
    begin
        // Use a deterministic date (17-Apr-2020 used on MS docs)
        DateValue := DMY2Date(17, 4, 2020);
        DayPart := Date2DMY(DateValue, 1);
        MonthPart := Date2DMY(DateValue, 2);
        YearPart := Date2DMY(DateValue, 3);

        AssertInstance.AreEqual(17, DayPart, 'Date2DMY did not return expected day.');
        AssertInstance.AreEqual(4, MonthPart, 'Date2DMY did not return expected month.');
        AssertInstance.AreEqual(2020, YearPart, 'Date2DMY did not return expected year.');
    end;

    [Test]
    procedure Date2DWY_WeekSpanningYear_YearDecision()
    var
        AssertInstance: Codeunit Assert;
        DateValue: Date;
        DayOfWeek: Integer;
        WeekYear: Integer;
    begin
        // Date2DWY has special behavior when a week spans two years:
        // it returns the year that contains the most days of that week.
        // Example: 01-Jan-2014 is in a week that has more days in 2014 -> year = 2014.
        DateValue := DMY2Date(1, 1, 2014);
        DayOfWeek := Date2DWY(DateValue, 1);    // day-of-week
        WeekYear := Date2DWY(DateValue, 3);     // week-year per spec

        AssertInstance.AreEqual(3, DayOfWeek, 'Date2DWY returned unexpected day-of-week for 2014-01-01.');
        AssertInstance.AreEqual(2014, WeekYear, 'Date2DWY did not choose the expected week-year when the week spans two calendar years.');
    end;

    [Test]
    procedure CalcDate_SimpleAdditions()
    var
        AssertInstance: Codeunit Assert;
        BaseDate: Date;
        ResultDate: Date;
    begin
        BaseDate := DMY2Date(17, 4, 2020); // example from docs
        // 1 week after 2020-04-17 is 2020-04-24
        ResultDate := CalcDate('<1W>', BaseDate);
        AssertInstance.AreEqual(DMY2Date(24, 4, 2020), ResultDate, 'CalcDate("1W") did not return expected date.');

        // 30 days after BaseDate
        ResultDate := CalcDate('<30D>', BaseDate);
        AssertInstance.AreEqual(DMY2Date(17, 5, 2020), ResultDate, 'CalcDate("30D") did not return expected date.');
    end;

    [Test]
    procedure CalcDate_EndOfMonth_And_FirstDay()
    var
        AssertInstance: Codeunit Assert;
        BaseDate: Date;
        EndOfMonthDate: Date;
        FirstOfMonthDate: Date;
    begin
        BaseDate := DMY2Date(17, 4, 2020);
        // Angle-bracket notation <CM> / <-CM> is commonly used to get last/first of the month
        EndOfMonthDate := CalcDate('<CM>', BaseDate);    // last day of April 2020 -> 30-Apr-2020
        FirstOfMonthDate := CalcDate('<-CM>', BaseDate); // first day of April 2020 -> 01-Apr-2020

        AssertInstance.AreEqual(DMY2Date(30, 4, 2020), EndOfMonthDate, 'CalcDate("<CM>") did not return expected last day of month.');
        AssertInstance.AreEqual(DMY2Date(1, 4, 2020), FirstOfMonthDate, 'CalcDate("<-CM>") did not return expected first day of month.');
    end;

    [Test]
    procedure CalcDate_AddMonth_DayOverflowAdjustsToLastValidDay()
    var
        AssertInstance: Codeunit Assert;
        BaseDate: Date;
        ResultDate: Date;
    begin
        // Add one month to 31-Jan-2021 (non-leap year) -> expect 28-Feb-2021
        BaseDate := DMY2Date(31, 1, 2021);
        ResultDate := CalcDate('<1M>', BaseDate);
        AssertInstance.AreEqual(DMY2Date(28, 2, 2021), ResultDate, 'CalcDate("1M") did not handle day overflow correctly (expected last valid day of next month).');

        // Another check: adding 1M to 31-Mar-2021 -> 30-Apr-2021
        BaseDate := DMY2Date(31, 3, 2021);
        ResultDate := CalcDate('<1M>', BaseDate);
        AssertInstance.AreEqual(DMY2Date(30, 4, 2021), ResultDate, 'CalcDate("1M") did not adjust March 31 correctly when adding one month.');
    end;

    [Test]
    procedure DMY2Date_InvalidDate_RaisesError()
    var
        DummyDate: Date;
    begin
        // DMY2Date(29, 2, 2019) is invalid (2019 not a leap year) -> should raise a runtime error.
        // Use ASSERTERROR to declare that an error is expected.
#pragma warning disable AA0206
        asserterror DummyDate := DMY2Date(29, 2, 2019);
#pragma warning restore AA0206
        // If the call above does not raise, the test framework will fail this test.
    end;

    [Test]
    procedure WorkDate_SetAndRestore()
    var
        AssertInstance: Codeunit Assert;
        PrevWorkDate: Date;
        NewWorkDate: Date;
        ReturnedWorkDate: Date;
    begin
        // Save current work date and restore at the end of the test to keep tests isolated.
        PrevWorkDate := WorkDate(); // get current work date

        // Set a deterministic work date for this session and verify WorkDate() returns it.
        NewWorkDate := DMY2Date(1, 12, 2022);
        ReturnedWorkDate := WorkDate(NewWorkDate); // sets and returns the new work date
        AssertInstance.AreEqual(NewWorkDate, ReturnedWorkDate, 'WorkDate(NewDate) did not return the set value.');

        // Restore previous work date to avoid side-effects for other tests
        WorkDate(PrevWorkDate);
    end;

    [Test]
    procedure Today_And_Time_Availability()
    var
        AssertInstance: Codeunit Assert;
        TodayDate: Date;
        CurrentTime: Time;
    begin
        // Basic smoke tests: Today() and Time() must return a value (non-zero for date)
        TodayDate := Today();
        CurrentTime := Time();

        // Today() should not be 0D and Time() should be non-zero (time of day)
        AssertInstance.AreNotEqual(0D, TodayDate, 'Today() returned an invalid date (0D).');
        AssertInstance.IsTrue(CurrentTime <> 0T, 'Time() returned zero; expected a valid time value.');
    end;
}
