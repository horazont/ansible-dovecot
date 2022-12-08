#!/bin/bash
set -euo pipefail
kind="$1"
{% if dovecot_antispam_daemon == "spamassassin" %}
/usr/bin/spamc -L "$kind" || true
{% else  %}
/usr/bin/rspamc "learn_$kind" || true
{% endif %}
