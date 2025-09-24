codeunit 50100 "Tryout"
{
    SubType = Test;

    [Test]
    procedure TryoutSomething()
    var
        s: Text;
        Assert: Codeunit Assert;
    begin
        s := 'Hello world';
        Assert.AreEqual('', UpperCase(s), '<<<<<<<<<<<<<<<<<<<<<<<<');
    end;
}
