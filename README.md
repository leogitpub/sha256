# sha256
`sha256.dwl`, an implementation written purely in dataweave (DWL).

SHA 256 message digest is a very popular and a widely used Cryptographic Hash Algorithm. There are a variety of ways one can achieve this implementation, but my main goal here is to do SHA256 in one single script file by extensively using tail recursives.

This script has a function `SHA256()` which accepts a single value as a parameter. Calling this function with the value will result in a SHA 256 hash of that value.

## Note: 
The Initial Version of this code can only work on those values which are less than or equal to 55 bytes ~= 440 bits. Any futher than that will give incorrect results. Do not touch sha256.dwl.

### Message to Contributors
To those who are interested in contributing to this repo, you are deeply appreciated to do so.
You can contribute by making adjustments to the code in sha256.contrib.dwl and create a pull request. But remember, all those adjustment should not extensively change the dynamic of the code with respect to the Intial Version (`dwl file checksum <1e78872ae56988ae55afba48ffd89d2e9fcacf8c49946ed273f7c12af0732d9e>`).
