// https://learn.microsoft.com/en-us/training/modules/al-built-in-functions/5-numeric-functions
codeunit 50102 "NumericFunctionTests"
{
    SubType = Test;

    [Test]
    procedure Round_DefaultAndDirection()
    var
        AssertInstance: Codeunit Assert;
        Num: Decimal;
        ResultValue: Decimal;
    begin
        // Default behavior is ROUND-HALF-AWAY-FROM-ZERO
        // Default rounding (precision = 0.01) rounds to two decimals
        Num := 1.5;
        ResultValue := Round(Num);
        AssertInstance.AreEqual(1.5, ResultValue, 'Round(1.5) with default precision should produce 1.5.');

        Num := 1.234;
        ResultValue := Round(Num);
        AssertInstance.AreEqual(1.23, ResultValue, 'Round(1.234) with default precision should produce 1.23.');

        Num := 1.235; // -> "half-up", away from zero
        ResultValue := Round(Num);
        AssertInstance.AreEqual(1.24, ResultValue, 'Round(1.235) with default precision should produce 1.24.');

        Num := -1.234;
        ResultValue := Round(Num);
        AssertInstance.AreEqual(-1.23, ResultValue, 'Round(-1.234) with default precision should produce -1.23.');

        Num := -1.235;
        ResultValue := Round(Num);
        AssertInstance.AreEqual(-1.24, ResultValue, 'Round(-1.235) with default precision should produce -1.24.');

        // To round to nearest integer, specify precision = 1
        Num := 1.5;
        ResultValue := Round(Num, 1);
        AssertInstance.AreEqual(2, ResultValue, 'Round(1.5, 1) should produce 2.');

        // Direction: '>' always up, '<' always down with precision 0.001
        Num := 1.2345;
        ResultValue := Round(Num, 0.001, '>');
        AssertInstance.AreEqual(1.235, ResultValue, 'Round with direction ">" did not round up as expected.');

        ResultValue := Round(Num, 0.001, '<');
        AssertInstance.AreEqual(1.234, ResultValue, 'Round with direction "<" did not round down as expected.');

        // Negative precisions (like -1) aren't allowed
        // Expect a runtime error
        asserterror ResultValue := Round(15, -1);
    end;

    [Test]
    procedure Abs_Basic()
    var
        AssertInstance: Codeunit Assert;
        Value: Decimal;
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
        AssertInstance: Codeunit Assert;
        PowerResult: Decimal;
    begin
        // fractional exponent (square root)
        PowerResult := Power(64, 0.5);
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
#pragma warning disable AA0206
        asserterror DummyResult := Power(-1, 0.5);
#pragma warning restore AA0206
    end;

    [Test]
    procedure Randomize_Deterministic_WithSeed()
    var
        AssertInstance: Codeunit Assert;
        FirstRandom: Integer;
        SecondRandom: Integer;
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
        AssertInstance: Codeunit Assert;
        RandomZero: Integer;
        RandomNegativeMax: Integer;
    begin
        // Random(0) should always return 1 per docs
        RandomZero := Random(0);
        AssertInstance.AreEqual(1, RandomZero, 'Random(0) should return 1.');

        // Negative MaxNumber must be treated as positive (Random(-10) => 1..10)
        RandomNegativeMax := Random(-10);
        AssertInstance.IsTrue((RandomNegativeMax >= 1) and (RandomNegativeMax <= 10), 'Random(-10) should return a value between 1 and 10 inclusive.');

        // Randomize()
    end;
}
