require ["vnd.dovecot.pipe", "copy", "imapsieve", "imap4flags"];

if not hasflag :is ["antispam-Ham"] {
    pipe :copy "sa-learn-ham.sh";
}

# Synchronise flags with all clients and mark message as learnt-as-ham to
# avoid unnecessary latency.
removeflag ["Junk", "$JUNK", "antispam-Spam"];
addflag ["$NOTJUNK", "antispam-Ham"];
