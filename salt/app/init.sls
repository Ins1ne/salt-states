include:
  - system

# if we want fetch source from github – uncomment block below,
# also need change everywhere "file: app" to "git: app" and remove .git absent
#
#app:
  #git.latest:
    #- name: {{ pillar['git_repo'] }}
    #- rev: {{ pillar['git_rev'] }}
    #- target: {{ pillar['project_root'] }}
    #- force: True
    #- require:
      #- pkg: git

# Copy project files
app:
  file.recurse:
    - name: {{ pillar['project_root'] }}
    - source: salt://app/{{ pillar['project_dir'] }}
    - require:
      - pkg: git

# remove git repository
{{ pillar['project_root'] }}/.git:
  file.absent:
    - require:
      - file: app

# configure database_settings
database_settings:
  file.managed:
    - name: {{ pillar['project_root'] }}/{{ pillar['project_name'] }}/database_settings.py
    - source: salt://app/database_settings.py
    - require:
      - file: app

# create and manage virtualenv
#env:
  #virtualenv.managed:
    #- name: {{ pillar['virtualenv'] }}
    #- runas: {{ pillar['user'] }}
    #- requirements: {{ pillar['project_root'] }}/conf/requirements/requirements.txt
    #- cwd: {{ pillar['project_root'] }}
    #- require:
      #- pkg: python-virtualenv
      #- cmd: distribute
      #- file: app

env:
  virtualenv.managed:
    - name: {{ pillar['virtualenv'] }}
    - runas: {{ pillar['user'] }}
    - cwd: {{ pillar['project_root'] }}
    - require:
      - pkg: python-virtualenv

update_distribute:
  cmd.run:
    - name: ". {{ pillar['virtualenv'] }}/bin/activate && pip install -U distribute"
    - require:
      - file: app
      - virtualenv: env

install_requirements:
  cmd.run:
    - name: ". {{ pillar['virtualenv'] }}/bin/activate && pip install -r {{ pillar['project_root'] }}/conf/requirements/requirements.txt"
    - require:
      - file: app
      - virtualenv: env
      - cmd: update_distribute

# collecting static files
collectstatic:
  cmd.run:
    - name: ". {{ pillar['virtualenv'] }}/bin/activate && python manage.py collectstatic --noinput"
    - cwd: {{ pillar['project_root'] }}
    - require:
      - virtualenv: env
      - file: database_settings
      - cmd: install_requirements
    - watch:
      - file: app
