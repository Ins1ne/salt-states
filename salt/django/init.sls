include:
  - reqs

venv:
  virtualenv.managed:
    - name: {{ pillar['virtualenv'] }}
    - no_site_packages: True
    - runas: ubuntu
    - require:
      - pkg: python-virtualenv

webapp:
  git.latest:
    - name: {{ pillar['git'] }}
    - rev: master
    - target: {{ pillar['project_root'] }}
    - force: True
    - require:
      - pkg: git

update_requirements:
  cmd.run:
    - name: ". {{ pillar['virtualenv'] }}/bin/activate && pip install -r requirements.txt"
    - cwd: {{ pillar['project_root'] }}
    - require:
      - pkg: python-virtualenv
      - pkg: git
      - virtualenv: venv
    - watch:
      - git: webapp
    - file:
      - exists: {{ pillar['project_root'] }}/requirements.txt
