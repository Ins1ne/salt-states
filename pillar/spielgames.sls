virtualenv: /home/deploy/env

media_proxy: https://s.gamestand.org/media/

db:
  master:
    name: origin_db
    user: repl
    password: repl
    host: 172.30.1.19
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
