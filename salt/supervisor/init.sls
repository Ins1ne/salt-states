include:
  - system

# install and run supervisor
supervisor:
  pkg:
    - installed
  service:
    - running

# manage supervisor config
/etc/supervisor/conf.d/django.conf:
  file.managed:
    - source: salt://supervisor/django.conf
    - template: jinja

# update supervisor config
reload_supervisor_config:
  cmd.run:
    - name: "supervisorctl update"
    - watch:
      - file: /etc/supervisor/conf.d/django.conf
    - require:
      - pkg: supervisor
