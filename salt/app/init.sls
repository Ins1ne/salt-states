include:
  - system

# if we want fetch source from github – uncomment block below,
# also need change everywhere "file: webapp" to "git: webapp"
#
#webapp:
  #git.latest:
    #- name: {{ pillar['git_repo'] }}
    #- rev: {{ pillar['git_rev'] }}
    #- target: {{ pillar['project_root'] }}
    #- force: True
    #- require:
      #- pkg: git

webapp:
  file.recurse:
    - name: {{ pillar['project_root'] }}
    - source: salt://test
    - clean: True
    - exclude_pat: *\.git*|*.pyc
    - require:
      - pkg: git

venv:
  virtualenv.managed:
    - name: {{ pillar['virtualenv'] }}
    - no_site_packages: True
    - runas: {{ pillar['user'] }}
    - requirements: {{ pillar['project_root'] }}/requirements.txt
    - cwd: {{ pillar['project_root'] }}
    - require:
      - pkg: python-virtualenv
      - file: webapp

update_requirements:
  cmd.run:
    - name: ". {{ pillar['virtualenv'] }}/bin/activate && python manage.py collectstatic --noinput"
    - cwd: {{ pillar['project_root'] }}
    - require:
      - virtualenv: venv
    - watch:
      - file: webapp
