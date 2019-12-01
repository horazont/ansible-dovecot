require ["imap4flags", "imapsieve", "vnd.dovecot.pipe", "copy"];

# Flags used by clients:
# - Junk: presence of the junk flag in thunderbird
# - $JUNK: presence of the spam flag in KMail
# - $NOTJUNK: presence of the ham flag in KMail

# We need to detect transitions, so we use an "internal" antispam-Spam /
# antispam-Ham pair of flags to detect if we already know of a state.
# This is a bit ugly, but should do the trick.

if allof(anyof(hasflag :is ["Junk"],
               hasflag :is ["$JUNK"]),
         not hasflag :is ["antispam-Spam"])
{
    # The message was marked as Junk by a TB or KMail user just now.
    # We need to note that we saw the Junk state and synchronise it across
    # the clients.
    addflag ["Junk", "$JUNK", "antispam-Spam"];
    removeflag ["$NOTJUNK", "antispam-Ham"];
    # We also hand the message to a spam classifier for learning.
    pipe :copy "sa-learn-spam";
}
elsif allof(anyof(not hasflag :is ["Junk"],
                  not hasflag :is ["$JUNK"]),
            hasflag :is ["antispam-Spam"])
{
    # At least one of the client Junk flags is missing, but our marker is
    # still there.
    # This means that a client has removed its junk flag. We synchronise
    # this change across the clients and also learn the message as ham.

    # Since this is an explicit statement by the user that the mail is *not*
    # supposed to be Junk, we go ahead and set the NOTJUNK marker, too.
    # But we avoid setting $NOTJUNK if this was done by Kmail to avoid
    # confusion.
    if not hasflag :is ["$JUNK"] {
        addflag ["$NOTJUNK"];
    }
    addflag ["antispam-Ham"];
    removeflag ["Junk", "$JUNK", "antispam-Spam"];
    pipe :copy "sa-learn-ham";
}
elsif allof(hasflag :is ["$NOTJUNK"],
            not hasflag :is ["antispam-Ham"])
{
    # A Kmail explicitly marked a mail as non-junk. Synchronise flags and
    # learn as ham.
    removeflag ["Junk", "$JUNK", "antispam-Spam"];
    addflag ["antispam-Ham", "$NOTJUNK"];
    pipe :copy "sa-learn-ham";
}
