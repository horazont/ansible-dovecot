# Automatically file all spam in the Junk folder

require ["fileinto", "imap4flags"];

if header :contains "X-Spam-Status" "autolearn=spam"
{
    # So that *both* Thunderbird and KMail understand what’s going on here
    # We also add the antispam-TB-Junk flag to ensure that the FLAG
    # imapsieve script will un-learn the junk status if it is changed
    addflag ["$JUNK", "Junk", "antispam-Spam"];
}

if header :contains "X-Spam-Status" "autolearn=ham"
{
    # This one is for KMail
    addflag ["$NOTJUNK", "antispam-Ham"];
}
