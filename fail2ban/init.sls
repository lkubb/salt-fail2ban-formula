# vim: ft=sls

{#-
    *Meta-state*.

    This installs the fail2ban package,
    manages the fail2ban configuration file
    and then starts the associated fail2ban service.
#}

include:
  - .package
  - .config
  - .service
