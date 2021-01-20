const SLC = artifacts.require("./SLC.sol");

contract("SLC", accounts => {
  it("return the name of token", async () => {
    const SLCInstance = await SLC.deployed();

    // Set value of 89
    //await simpleStorageInstance.set(89, { from: accounts[0] });

    // Get stored value
    console.log(SLCInstance);
    const storedData = await SLCInstance.name.call();
    console.log(storedData)
    assert.equal(storedData, "SLC", "The value SLC was not stored.");
  });
});
