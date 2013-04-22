include:
  - system
  - app

# install uwsgi
uwsgi:
  pip.installed:
    - require:
      - pkg: python-dev
      - pkg: python-pip

# create log directory
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

# create log file
/var/log/uwsgi/emperor.log:
  file:
    - managed
    - user: {{ pillar['web_user'] }}
    - group: {{ pillar['web_group'] }}

# create directories for vassals
/etc/uwsgi/vassals:
  file.directory:
    - makedirs: True

# manage app config for uwsgi
vassal_config:
  file.managed:
    - name: "/etc/uwsgi/vassals/{{ pillar['project_name'] }}.ini"
    - source: salt://uwsgi/uwsgi.ini
    - template: jinja
    - require:
      - pip: uwsgi

# manage uwsgi startup config
/etc/init/uwsgi.conf:
  file.managed:
    - source: salt://uwsgi/uwsgi.conf
    - template: jinja
    - require:
      - pip: uwsgi

# soft reload uwsgi service
reload-uwsgi-service:
  cmd.run:
    - name: "touch /etc/uwsgi/vassals/{{ pillar['project_name'] }}.ini"
    - require:
      - pip: uwsgi
      - file: app
      - virtualenv: env
      - file: vassal_config
