# vim: ft=sls

{#-
    Removes the fail2ban package and service hardening overrides, if configured.
    Has a depency on `fail2ban.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as fail2ban with context %}

include:
  - {{ sls_config_clean }}

{%- if fail2ban.service_hardened and "systemd" | which %}

Fail2ban service overrides are removed:
  file.absent:
    - name: /etc/systemd/system/{{ fail2ban.lookup.service.name }}.service.d
{%- endif %}

Fail2Ban is removed:
  pkg.removed:
    - name: {{ fail2ban.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
