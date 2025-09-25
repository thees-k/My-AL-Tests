// https://learn.microsoft.com/en-us/training/modules/al-built-in-functions/5-numeric-functions
codeunit 50103 "NumericFunctionTests"
{
    SubType = Test;

    [Test]
    procedure Round_DefaultAndDirection()
    var
        Num: Decimal;
        ResultValue: Decimal;
        AssertInstance: Codeunit Assert;
    begin
        // Default rounding (no precision) -> round to integer, 5 and above rounds up
        Num := 1.5;
        ResultValue := Round(Num);
        AssertInstance.AreEqual(2, ResultValue, 'Round(1.5) should produce 2.');

        // Direction: '>' always up, '<' always down
        Num := 1.2345;
        ResultValue := Round(Num, 0.001, '>');
        AssertInstance.AreEqual(1.235, ResultValue, 'Round with direction ">" did not round up as expected.');

        ResultValue := Round(Num, 0.001, '<');
        AssertInstance.AreEqual(1.234, ResultValue, 'Round with direction "<" did not round down as expected.');

        // Negative precision: round to tens (-1) -> 15 -> 20
        ResultValue := Round(15, -1);
        AssertInstance.AreEqual(20, ResultValue, 'Round with negative precision (-1) did not round to tens as expected.');

        // Another negative precision example: 14 -> 10
        ResultValue := Round(14, -1);
        AssertInstance.AreEqual(10, ResultValue, 'Round with negative precision (-1) did not round 14 down to 10 as expected.');
    end;

    [Test]
    procedure Abs_Basic()
    var
        Value: Decimal;
        AssertInstance: Codeunit Assert;
    begin
        Value := -10.235;
        Value := Abs(Value);
        AssertInstance.AreEqual(10.235, Value, 'Abs did not return the absolute value.');

        // zero stays zero
        AssertInstance.AreEqual(0, Abs(0), 'Abs(0) should be 0.');
    end;

    [Test]
    procedure Power_SquareRoot_And_ZeroPowZero()
    var
        PowerResult: Decimal;
        AssertInstance: Codeunit Assert;
    begin
        // fractional exponent (square root)
        PowerResult := POWER(64, 0.5);
        AssertInstance.AreEqual(8, PowerResult, 'POWER(64, 0.5) should return 8.');

        // 0^0 behaviour - many implementations return 1
        PowerResult := POWER(0, 0);
        AssertInstance.AreEqual(1, PowerResult, 'POWER(0, 0) should return 1.');
    end;

    [Test]
    procedure Power_NegativeBaseFractional_Throws()
    var
        DummyResult: Decimal;
    begin
        // Typical edge-case: negative base with fractional exponent is not a real decimal.
        // Expect a runtime error
        ASSERTERROR DummyResult := Power(-1, 0.5);
    end;

    [Test]
    procedure Randomize_Deterministic_WithSeed()
    var
        FirstRandom: Integer;
        SecondRandom: Integer;
        AssertInstance: Codeunit Assert;
    begin
        // When seeded with the same value, Randomize should produce the same random sequence.
        Randomize(12345);
        FirstRandom := Random(100);

        Randomize(12345);
        SecondRandom := Random(100);

        AssertInstance.AreEqual(FirstRandom, SecondRandom, 'Randomize with same seed did not produce deterministic first value.');
    end;

    [Test]
    procedure Random_EdgeCases_ZeroAndNegative()
    var
        RandomZero: Integer;
        RandomNegativeMax: Integer;
        AssertInstance: Codeunit Assert;
    begin
        // Random(0) should always return 1 per docs
        RandomZero := Random(0);
        AssertInstance.AreEqual(1, RandomZero, 'Random(0) should return 1.');

        // Negative MaxNumber must be treated as positive (Random(-10) => 1..10)
        RandomNegativeMax := Random(-10);
        AssertInstance.IsTrue((RandomNegativeMax >= 1) and (RandomNegativeMax <= 10), 'Random(-10) should return a value between 1 and 10 inclusive.');
    end;
}
