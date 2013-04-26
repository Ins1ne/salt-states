include:
  - system

# remove app directory on minion
remove_app:
  file.absent:
    - name: {{ pillar['project']['root'] }}

# Copy project files
app:
  file.recurse:
    - name: {{ pillar['project']['root'] }}
    - source: salt://app/{{ pillar['project']['dir'] }}
    - exclude_pat: '*.pyc'
    - exclude: '*.pyc'
    - require:
      - file: remove_app
    - group: {{ pillar['system']['web_group'] }}
    - user: {{ pillar['system']['web_user'] }}
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - group
      - user
      - mode

# remove git repository
#{{ pillar['project']['root'] }}/.git:
  #  file.absent:
    # - require:
      # - file: app

# configure database_settings
database_settings:
  file.managed:
    - name: {{ pillar['project']['root'] }}/{{ pillar['project']['name'] }}/database_settings.py
    - template: jinja
    - source: salt://app/database_settings.py
    - group: {{ pillar['system']['web_group'] }}
    - user: {{ pillar['system']['web_user'] }}
    - mode: 644
    - require:
      - file: app

# create and manage virtualenv
#env:
  #virtualenv.managed:
    #- name: {{ pillar['virtualenv'] }}
    #- runas: {{ pillar['system']['user'] }}
    #- requirements: {{ pillar['project']['root'] }}/conf/requirements/requirements.txt
    #- cwd: {{ pillar['project']['root'] }}
    #- require:
      #- pkg: python-virtualenv
      #- cmd: distribute
      #- file: app

env:
  virtualenv.managed:
    - name: {{ pillar['virtualenv'] }}
    - runas: {{ pillar['system']['user'] }}
    - cwd: {{ pillar['project']['root'] }}
    - require:
      - pkg: python-virtualenv

update_distribute:
  cmd.run:
    - name: ". {{ pillar['virtualenv'] }}/bin/activate && pip install -U distribute"
    - user: {{ pillar['system']['user'] }}
    - require:
      - file: app
      - virtualenv: env

install_requirements:
  cmd.run:
    - name: ". {{ pillar['virtualenv'] }}/bin/activate && pip install -r {{ pillar['project']['root'] }}/conf/requirements/requirements.txt"
    - user: {{ pillar['system']['user'] }}
    - require:
      - file: app
      - virtualenv: env
      - cmd: update_distribute

# collecting static files
collectstatic:
  cmd.run:
    - name: ". {{ pillar['virtualenv'] }}/bin/activate && python manage.py collectstatic --noinput"
    - cwd: {{ pillar['project']['root'] }}
    - user: {{ pillar['system']['user'] }}
    - require:
      - virtualenv: env
      - file: database_settings
      - cmd: install_requirements
    - watch:
      - file: app
