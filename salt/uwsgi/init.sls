include:
  - reqs

uwsgi:
  pip.installed:
    - require:
      - pkg: python-dev
      - pkg: python-pip

/var/log/uwsgi:
  file.directory:
    - makedirs: True
    - group: {{ pillar['web_group'] }}
    - user: {{ pillar['web_user'] }}
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - group
      - user
      - mode

/etc/uwsgi/vassals:
  file.directory:
    - makedirs: True

vassal_config:
  file.managed:
    - name: "/etc/uwsgi/vassals/{{ pillar['project_name'] }}.ini"
    - source: salt://uwsgi/uwsgi.ini
    - template: jinja
    - require:
      - pip: uwsgi

/etc/init/uwsgi.conf:
  file.managed:
    - source: salt://uwsgi/uwsgi.conf
    - template: jinja
    - require:
      - pip: uwsgi

reload-uwsgi-service:
  cmd.run:
    - name: "touch /etc/uwsgi/vassals/{{ pillar['project_name'] }}.ini"
    - require:
      - pip: uwsgi
      - git: webapp
      - virtualenv: venv
      - file: vassal_config
