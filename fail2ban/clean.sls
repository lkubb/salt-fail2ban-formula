# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``fail2ban`` meta-state
    in reverse order, i.e.
    stops the service,
    removes the configuration file and then
    uninstalls the package.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
