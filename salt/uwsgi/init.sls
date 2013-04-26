include:
  - system
  - app

# install uwsgi
uwsgi:
  pip.installed:
    - require:
      - pkg: python-dev
      - pkg: python-pip

# create uwsgi log directory
uwsgi_log_directory:
  file.directory:
    - name: /var/log/uwsgi/
    - makedirs: True
    - group: {{ pillar['system']['web_group'] }}
    - user: {{ pillar['system']['web_user'] }}
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - group
      - user
      - mode

# create uwsgi emperor log file
/var/log/uwsgi/emperor.log:
  file.managed:
    - user: {{ pillar['system']['web_user'] }}
    - group: {{ pillar['system']['web_group'] }}
    - require:
      - file: uwsgi_log_directory

# create directories for vassals
vassals_directory:
  file.directory:
    - name: /etc/uwsgi/vassals/
    - makedirs: True

# manage app config for uwsgi
vassal_config:
  file.managed:
    - name: "/etc/uwsgi/vassals/{{ pillar['project']['name'] }}.ini"
    - source: salt://uwsgi/uwsgi.ini
    - template: jinja
    - require:
      - pip: uwsgi
      - file: vassals_directory

# manage uwsgi startup config
/etc/init/uwsgi.conf:
  file.managed:
    - source: salt://uwsgi/uwsgi.conf
    - template: jinja
    - require:
      - pip: uwsgi

# soft reload uwsgi service
reload-uwsgi-service:
  file.touch:
    - name: "/etc/uwsgi/vassals/{{ pillar['project']['name'] }}.ini"
    - require:
      - file: vassals_directory
      - file: vassal_config
      - file: app
      - pip: uwsgi
      - virtualenv: env
