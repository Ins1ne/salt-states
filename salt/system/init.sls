# install mysql packages
mysql-pkgs:
  pkg.installed:
    - names:
      - mysql-server
      - libmysqlclient-dev

# install lxml dependencies
lxml-pkgs:
  pkg.installed:
    - names:
      - libxml2
      - libxml2-dev
      - libxslt1-dev

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
      - python-lxml
      - rubygems
    - require:
      - pkg: mysql-pkgs
      - pkg: lxml-pkgs
