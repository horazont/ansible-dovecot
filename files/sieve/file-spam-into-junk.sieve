# Automatically file all spam in the Junk folder

require ["fileinto", "mime"];

if header :contains "X-Spam-Flag" ["YES"] {
    fileinto "Junk";
    stop;
}
