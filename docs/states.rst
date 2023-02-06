Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``fail2ban``
^^^^^^^^^^^^
*Meta-state*.

This installs the fail2ban package,
manages the fail2ban configuration file
and then starts the associated fail2ban service.


``fail2ban.package``
^^^^^^^^^^^^^^^^^^^^
Installs the fail2ban package and service hardening overrides, if configured.


``fail2ban.config``
^^^^^^^^^^^^^^^^^^^
Manages the fail2ban service configuration.
Has a dependency on `fail2ban.package`_.


``fail2ban.service``
^^^^^^^^^^^^^^^^^^^^
Starts the fail2ban service and enables it at boot time.
Has a dependency on `fail2ban.config`_.


``fail2ban.clean``
^^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``fail2ban`` meta-state
in reverse order, i.e.
stops the service,
removes the configuration file and then
uninstalls the package.


``fail2ban.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the fail2ban package and service hardening overrides, if configured.
Has a depency on `fail2ban.config.clean`_.


``fail2ban.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the fail2ban service and has a
dependency on `fail2ban.service.clean`_.


``fail2ban.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the fail2ban service and disables it at boot time.


