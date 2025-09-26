codeunit 50100 "Tryout"
{
    SubType = Test;

    [Test]
    procedure TryoutSomething()
    var
        AssertInstance: Codeunit Assert;
        s: Text;
    begin
        s := 'Hello world';
        AssertInstance.AreEqual('', UpperCase(s), '<<<<<<<<<<<<<<<<<<<<<<<<');
    end;

    [Test]
    procedure TryoutSomething2()
    var
        AssertInstance: Codeunit Assert;
        str: Text;
    begin
        str := UserId();
        str := InsStr(str, CompanyName(), StrLen(str) + 1); // append
        AssertInstance.AreEqual('', str, '<<<<<<<<<<<<<<<<<<<<<<<<');
    end;

}
