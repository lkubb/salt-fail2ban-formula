# vim: ft=sls

{#-
    Stops the fail2ban service and disables it at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as fail2ban with context %}

Fail2Ban is dead:
  service.dead:
    - name: {{ fail2ban.lookup.service.name }}
    - enable: false
