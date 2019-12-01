require ["vnd.dovecot.pipe", "copy", "imapsieve", "imap4flags"];

if not hasflag :is ["antispam-Spam"] {
    pipe :copy "sa-learn-spam";
}

# Synchronise flags with all clients and mark message as learnt-as-spam to
# avoid unnecessary latency.
addflag ["Junk", "$JUNK", "antispam-Spam"];
removeflag ["$NOTJUNK", "antispam-Ham"];
