include:
  - reqs

webapp:
  git.latest:
    - name: {{ pillar['git_repo'] }}
    - rev: {{ pillar['git_rev'] }}
    - target: {{ pillar['project_root'] }}
    - force: True
    - require:
      - pkg: git

venv:
  virtualenv.managed:
    - name: {{ pillar['virtualenv'] }}
    - no_site_packages: True
    - runas: ubuntu
    - requirements: {{ pillar['project_root'] }}/requirements.txt
    - cwd: {{ pillar['project_root'] }}
    - require:
      - pkg: python-virtualenv
      - git: webapp
      #- file: {{ pillar['project_root'] }}/requirements.txt

update_requirements:
  cmd.run:
    - name: ". {{ pillar['virtualenv'] }}/bin/activate && python manage.py collectstatic --noinput"
    #- name: ". {{ pillar['virtualenv'] }}/bin/activate && pip install -r
      #requirements.txt && python manage.py collectstatic --noinput"
    - cwd: {{ pillar['project_root'] }}
    - require:
      #- pkg: python-virtualenv
      #- pkg: git
      - virtualenv: venv
    - watch:
      - git: webapp
    #- file:
      #- exists: {{ pillar['project_root'] }}/requirements.txt