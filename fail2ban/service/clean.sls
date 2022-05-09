# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as fail2ban with context %}

fail2ban-service-clean-service-dead:
  service.dead:
    - name: {{ fail2ban.lookup.service.name }}
    - enable: False
