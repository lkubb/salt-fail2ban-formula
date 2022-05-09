# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as fail2ban with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set fail2ban_conf_base = salt["file.dirname"](fail2ban.lookup.config) %}

include:
  - {{ sls_package_install }}

fail2ban-config-file-file-managed:
  file.managed:
    - name: {{ fail2ban.lookup.config }}
    - source: {{ files_switch(['fail2ban.conf.j2'],
                              lookup='fail2ban-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ fail2ban.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        config:
          Definition: {{ fail2ban.config | json }}

# This manages `jail.local` file.
Fail2ban local jail configuration is managed:
  file.managed:
    - name: {{ fail2ban_conf_base | path_join("jail.local") }}
    - source: {{ files_switch(['fail2ban.conf.j2'],
                              lookup='Fail2ban jails are managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ fail2ban.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        config:
          DEFAULT: {{ fail2ban.jails_defaults }}
{%- for name in fail2ban.jails_enabled %}
          {{ name }}: {enabled: true}
{%- endfor %}

{%- if fail2ban.actions %}

Fail2ban actions are managed:
  file.managed:
    - names:
{%-   for name, config in fail2ban.actions.items() %}
      - {{ fail2ban_conf_base | path_join("action.d", name ~ ".conf") }}:
        - context:
            config: {{ config | json }}
{%-   endfor %}
    - source: {{ files_switch(['fail2ban.conf.j2'],
                              lookup='Fail2ban actions are managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ fail2ban.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
{%- endif %}

{%- if fail2ban.filters %}

Fail2ban filters are managed:
  file.managed:
    - names:
{%-   for name, config in fail2ban.filters.items() %}
      - {{ fail2ban_conf_base | path_join("filter.d", name ~ ".conf") }}:
        - context:
            config: {{ config | json }}
{%-   endfor %}
    - source: {{ files_switch(['fail2ban.conf.j2'],
                              lookup='Fail2ban filters are managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ fail2ban.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
{%- endif %}

{%- if fail2ban.jails %}

Fail2ban jails are managed:
  file.managed:
    - names:
{%-   for name, config in fail2ban.jails.items() %}
      - {{ fail2ban_conf_base | path_join("jail.d", name ~ ".conf") }}:
        - context:
            config:
              {{ name }}: {{ config | json }}
{%-   endfor %}
    - source: {{ files_switch(['fail2ban.conf.j2'],
                              lookup='Fail2ban jails are managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ fail2ban.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
{%- endif %}
