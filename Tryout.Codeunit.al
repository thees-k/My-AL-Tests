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
}
