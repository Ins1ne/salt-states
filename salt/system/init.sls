# setup mysql install password
setup_mysql_password:
  cmd.run:
    - name: "echo mysql-server mysql-server/root_password password {{ pillar['db']['slave']['root_password'] }} | debconf-set-selections && echo mysql-server mysql-server/root_password_again password {{ pillar['db']['slave']['root_password'] }} | debconf-set-selections"
    - template: jinja

# install mysql packages
mysql-pkgs:
  pkg.installed:
    - names:
      - mysql-server
      - libmysqlclient-dev
    - require:
      - cmd: setup_mysql_password

# install required system packages
require-pkgs:
  pkg.installed:
    - names:
      - gcc
      - make
      - python-dev
      - python-virtualenv
      - python-pip
      - redis-server
      - python-mysqldb
    - require:
      - pkg: mysql-pkgs
