include:
  - requirements

venv:
  virtualenv.managed:
    - name: /home/ubuntu/venv
    - no_site_packages: True
    - runas: ubuntu
    - require:
      - pkg: python-virtualenv

webapp:
  git.latest:
    - name: https://github.com/Ins1ne/test.git
    - rev: master
    - target: /home/ubuntu/test
    - force: True

#/home/ubuntu/test/requirements.txt:
update_requirements:
  cmd.run:
    - name: ". venv/bin/activate && pip install -r test/requirements.txt"
    - cwd: /home/ubuntu
    - require:
      - pkg: python-virtualenv
      - virtualenv: venv
    - watch:
      - git: webapp
    - file:
      - exists: /home/ubuntu/test/requirements.txt
