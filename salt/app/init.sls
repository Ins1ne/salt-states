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

# create media directory
media_dir:
  file.directory:
    - name: {{ pillar['project_root'] }}/{{ pillar['project_name'] }}/media
    - makedirs: True

# copy media files
media:
  file.recurse:
    - name: {{ pillar['project_root'] }}/{{ pillar['project_name'] }}/media
    - source: salt://app/origins/{{ pillar['group'] }}/{{ pillar['media'] }}
    #- source: salt://app/origins/django/{{ pillar['media'] }}
    - require:
      - file: app
      - file: media_dir

# create and manage virtualenv
venv:
  virtualenv.managed:
    - name: {{ pillar['virtualenv'] }}
    - no_site_packages: True
    - runas: {{ pillar['user'] }}
    - requirements: {{ pillar['project_root'] }}/requirements.txt
    - cwd: {{ pillar['project_root'] }}
    - require:
      - pkg: python-virtualenv
      - file: app

# collecting static files
collectstatic:
  cmd.run:
    - name: ". {{ pillar['virtualenv'] }}/bin/activate && python manage.py collectstatic --noinput"
    - cwd: {{ pillar['project_root'] }}
    - require:
      - virtualenv: venv
      - file: database_settings
    - watch:
      - file: app
