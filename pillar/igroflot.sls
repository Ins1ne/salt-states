virtualenv: /home/deploy/env

media_proxy: http://s.gamestand.org

db:
  master:
    name: origin_db
    user: repl
    password: repl
    host: 172.30.1.18
    port: ""
  slave:
    name: satellite_default
    user: deploy
    password: deploy
    host: localhost
    port: ""
    root_password: ""

project:
  root: /home/deploy/satellite-simplified
  dir: satellite-simplified
  name: satellites_simplified

system:
  user: deploy
  web_user: deploy
  web_group: deploy
