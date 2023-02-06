# vim: ft=sls

{#-
    Starts the fail2ban service and enables it at boot time.
    Has a dependency on `fail2ban.config`_.
#}

include:
  - .running
