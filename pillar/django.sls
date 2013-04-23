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
    user: replica_user
    password: replica_password
    host: localhost
    port: ""
  slave:
    name: satellite_default
    user: local_user
    password: local_password
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
