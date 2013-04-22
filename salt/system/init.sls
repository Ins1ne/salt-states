# install required system packages
require-pkgs:
  pkg.installed:
    - names:
      - git
      - python-dev
      - python-virtualenv
      - python-pip
      - mysql-server
      - libmysqlclient-dev

# upgrade distribute
distribute:
  cmd.run:
    - name: "easy_install -U distribute"
    - require:
      - pkg: require-pkgs
