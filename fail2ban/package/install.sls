# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as fail2ban with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

Fail2Ban is installed:
  pkg.installed:
    - name: {{ fail2ban.lookup.pkg.name }}

{%- if "systemd" | which and fail2ban.service_hardened %}

Fail2Ban hardened service unit is installed:
  file.managed:
    - name: /etc/systemd/system/{{ fail2ban.lookup.service.name }}.service.d/harden.conf
    - source: {{ files_switch(
                    ["fail2ban.service", "fail2ban.service.j2"],
                    config=fail2ban,
                    lookup="Fail2Ban hardened service unit is installed",
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ fail2ban.lookup.rootgroup }}
    - makedirs: true

Fail2Ban log directory exists:
  file.directory:
    - name: {{ salt["file.dirname"](fail2ban.config.logtarget) }}
{%- endif %}
