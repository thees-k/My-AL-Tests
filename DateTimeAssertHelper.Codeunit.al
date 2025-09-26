codeunit 50108 DateTimeAssertHelper
{
    procedure AssertDateTimeNear(expected: DateTime; actual: DateTime; deltaMs: Integer; errorMessage: Text; AssertInstance: Codeunit Assert)
    var
        diffMs: Integer;
    begin
        diffMs := this.DateTimeDiffMs(actual, expected);
        if diffMs > deltaMs then
            AssertInstance.Fail(errorMessage + ' (difference: ' + Format(diffMs) + ' ms)');
    end;

    local procedure DateTimeDiffMs(DateTime1: DateTime; DateTime2: DateTime): Integer
    var
        diff: Duration;
    begin
        diff := DateTime1 - DateTime2;
        exit(Abs(this.DurationToMilliseconds(diff)));
    end;

    local procedure DurationToMilliseconds(duration: Duration): Integer
    var
        totalMs: Decimal;
    begin
        totalMs := duration / 10000;
        exit(Round(totalMs));
    end;
}