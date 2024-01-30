# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as fail2ban with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

{%- if grains.os_family == "RedHat" and grains.os != "Fedora" %}

CRB and EPEL repos are enabled:
  pkg.installed:
    - name: epel-release
    - require_in:
      - Fail2Ban is installed

{%-   if grains.os == "Rocky" %}
  cmd.run:
    - name: crb enable
    - unless:
      - crb status | grep 'is enabled'

{%-   else %}
  cmd.run:
    - name: dnf config-manager --set-enabled crb
    - unless:
      - dnf repolist --enabled | grep -e '^crb'
{%-   endif %}
    - require_in:
      - Fail2Ban is installed
{%- endif %}

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
