# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as fail2ban with context %}
{%- set fail2ban_conf_base = salt["file.dirname"](fail2ban.lookup.config) %}

include:
  - {{ sls_service_clean }}

fail2ban-config-clean-file-absent:
  file.absent:
    - names:
      - {{ fail2ban.lookup.config }}
      - {{ fail2ban_conf_base | path_join("jail.local") }}
{%- for name in fail2ban.actions %}
      - {{ fail2ban_conf_base | path_join("action.d", name ~ ".conf") }}
{%- endfor %}
{%- for name in fail2ban.filters %}
      - {{ fail2ban_conf_base | path_join("filter.d", name ~ ".conf") }}
{%- endfor %}
{%- for name in fail2ban.jails %}
      - {{ fail2ban_conf_base | path_join("jail.d", name ~ ".conf") }}
{%- endfor %}
    - require:
      - sls: {{ sls_service_clean }}
