codeunit 50102 "DateFunctionTests"
{
    SubType = Test;

    [Test]
    procedure Date2DMY_BasicParts()
    var
        d: Date;
        dayPart: Integer;
        monthPart: Integer;
        yearPart: Integer;
        Assert: Codeunit Assert;
    begin
        // Use a deterministic date (17-Apr-2020 used on MS docs)
        d := DMY2Date(17, 4, 2020);
        dayPart := Date2DMY(d, 1);
        monthPart := Date2DMY(d, 2);
        yearPart := Date2DMY(d, 3);

        Assert.AreEqual(17, dayPart, 'Date2DMY did not return expected day.');
        Assert.AreEqual(4, monthPart, 'Date2DMY did not return expected month.');
        Assert.AreEqual(2020, yearPart, 'Date2DMY did not return expected year.');
    end;

    [Test]
    procedure Date2DWY_WeekSpanningYear_YearDecision()
    var
        d: Date;
        dow: Integer;
        wyYear: Integer;
        Assert: Codeunit Assert;
    begin
        // Date2DWY has special behavior when a week spans two years:
        // it returns the year that contains the most days of that week.
        // Example: 01-Jan-2014 is in a week that has more days in 2014 -> year = 2014.
        d := DMY2Date(1, 1, 2014);
        dow := Date2DWY(d, 1);   // day of week: Monday=1 -> Wed = 3
        wyYear := Date2DWY(d, 3); // week-year per spec

        Assert.AreEqual(3, dow, 'Date2DWY returned unexpected day-of-week for 2014-01-01.');
        Assert.AreEqual(2014, wyYear, 'Date2DWY did not choose the expected week-year when the week spans two calendar years.');
    end;

    [Test]
    procedure CalcDate_SimpleAdditions()
    var
        baseDate: Date;
        res: Date;
        Assert: Codeunit Assert;
    begin
        baseDate := DMY2Date(17, 4, 2020); // example from docs
        // 1 week after 2020-04-17 is 2020-04-24
        res := CalcDate('1W', baseDate);
        Assert.AreEqual(DMY2Date(24, 4, 2020), res, 'CalcDate("1W") did not return expected date.');

        // 30 days after baseDate
        res := CalcDate('30D', baseDate);
        Assert.AreEqual(DMY2Date(17, 5, 2020), res, 'CalcDate("30D") did not return expected date.');
    end;

    [Test]
    procedure CalcDate_EndOfMonth_And_FirstDay()
    var
        baseDate: Date;
        endOfMonth: Date;
        firstOfMonth: Date;
        Assert: Codeunit Assert;
    begin
        baseDate := DMY2Date(17, 4, 2020);
        // Angle-bracket notation <CM> / <-CM> is commonly used to get last/first of the month
        endOfMonth := CalcDate('<CM>', baseDate);   // last day of April 2020 -> 30-Apr-2020
        firstOfMonth := CalcDate('<-CM>', baseDate); // first day of April 2020 -> 01-Apr-2020

        Assert.AreEqual(DMY2Date(30, 4, 2020), endOfMonth, 'CalcDate("<CM>") did not return expected last day of month.');
        Assert.AreEqual(DMY2Date(1, 4, 2020), firstOfMonth, 'CalcDate("<-CM>") did not return expected first day of month.');
    end;

    [Test]
    procedure CalcDate_AddMonth_DayOverflowAdjustsToLastValidDay()
    var
        baseDate: Date;
        res: Date;
        Assert: Codeunit Assert;
    begin
        // Add one month to 31-Jan-2021 (non-leap year) -> expect 28-Feb-2021
        baseDate := DMY2Date(31, 1, 2021);
        res := CalcDate('1M', baseDate);
        Assert.AreEqual(DMY2Date(28, 2, 2021), res, 'CalcDate("1M") did not handle day overflow correctly (expected last valid day of next month).');

        // Another check: adding 1M to 31-Mar-2021 -> 30-Apr-2021
        baseDate := DMY2Date(31, 3, 2021);
        res := CalcDate('1M', baseDate);
        Assert.AreEqual(DMY2Date(30, 4, 2021), res, 'CalcDate("1M") did not adjust March 31 correctly when adding one month.');
    end;

    [Test]
    procedure DMY2Date_InvalidDate_RaisesError()
    var
        Assert: Codeunit Assert;
        dummyDate: Date;
    begin
        // DMY2Date(29, 2, 2019) is invalid (2019 not a leap year) -> should raise a runtime error.
        // Use ASSERTERROR to declare that an error is expected.
        ASSERTERROR dummyDate := DMY2Date(29, 2, 2019);
        // If the call above does not raise, the test framework will fail this test.
    end;

    [Test]
    procedure WorkDate_SetAndRestore()
    var
        prevWorkDate: Date;
        newWorkDate: Date;
        returned: Date;
        Assert: Codeunit Assert;
    begin
        // Save current work date and restore at the end of the test to keep tests isolated.
        prevWorkDate := WorkDate(); // get current work date

        // Set a deterministic work date for this session and verify WorkDate() returns it.
        newWorkDate := DMY2Date(1, 12, 2022);
        returned := WorkDate(newWorkDate); // sets and returns the new work date
        Assert.AreEqual(newWorkDate, returned, 'WorkDate(NewDate) did not return the set value.');

        // Restore previous work date to avoid side-effects for other tests
        WorkDate(prevWorkDate);
    end;

    [Test]
    procedure Today_And_Time_Availability()
    var
        tDate: Date;
        tTime: Time;
        Assert: Codeunit Assert;
    begin
        // Basic smoke tests: Today() and Time() must return a value (non-zero for date)
        tDate := Today();
        tTime := Time();

        // Today() should not be 0D and Time() should be non-zero (time of day)
        Assert.AreNotEqual(0D, tDate, 'Today() returned an invalid date (0D).');
        Assert.IsTrue(tTime <> 0T, 'Time() returned zero; expected a valid time value.');
    end;
}
