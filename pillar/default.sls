virtualenv: /home/vagrant/env

media_proxy: http://s.gamestand.org

db:
  master:
    name: origin_db
    user: repl
    password: repl
    host: 172.16.42.10
    port: ""
  slave:
    name: satellite_default
    user: vagrant
    password: vagrant
    host: localhost
    port: ""
    root_password: ""

project:
  root: /home/vagrant/satellite-simplified
  dir: satellite-simplified
  name: satellites_simplified

system:
  user: vagrant
  web_user: vagrant
  web_group: vagrant
