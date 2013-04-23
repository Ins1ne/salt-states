project_root: /home/vagrant/satellite-simplified
project_dir: satellite-simplified
project_name: satellites_simplified
virtualenv: /home/vagrant/env
user: vagrant
web_user: vagrant
web_group: vagrant
db_master: origin_db
db_slave: satellite_default
media_proxy: https://s.gamestand.org/media/

db:
  master:
    name: origin_db
    user: repl
    password: repl
    host: localhost
    port: ""
  slave:
    name: satellite_default
    user: vagrant
    password: vagrant
    host: localhost
    port: ""

project:
  root: /home/vagrant/satellite-simplified
  dir: satellite-simplified
  name: satellites_simplified

system:
  user: vagrant
  web_user: vagrant
  web_group: vagrant
