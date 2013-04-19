include:
  - system

supervisor:
  pkg:
    - installed
  service:
    - running

/etc/supervisor/conf.d/django.conf:
  file.managed:
    - source: salt://supervisor/django.conf
    - template: jinja

reload_supervisor_config:
  cmd.run:
    - name: "supervisorctl update"
    - watch:
      - file: /etc/supervisor/conf.d/django.conf
    - require:
      - pkg: supervisor
