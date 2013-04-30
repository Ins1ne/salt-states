include:
  - system

# copy origin db dump
#/tmp/origin.sql:
  #file.managed:
    #- source: salt://mysql/origin.sql
    #- template: jinja
    #- requere:
      #- pkg: mysql-server
      #- service: mysql

# copy origin db schema dump
#/tmp/origin_schema.sql:
  #file.managed:
    #- source: salt://mysql/origin_schema.sql
    #- template: jinja
    #- requere:
      #- pkg: mysql-server
      #- service: mysql

# manage mysql config
my_cfg:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://mysql/my.cnf
    - template: jinja
    - requere:
      - pkg: mysql-server
      - service: mysql

# restart mysql service if file changed
mysql:
  service:
    - running
    - watch:
      - file: my_cfg

# check if database exists
database_exists:
  mysql_database.present:
    - name: {{ pillar['db']['slave']['name'] }}
    - require:
      - pkg: python-mysqldb
      - service: mysql

# check if user exists
{{ pillar['db']['slave']['user'] }}:
  mysql_user.present:
    - host: {{ pillar['db']['slave']['host'] }}
    - password: {{ pillar['db']['slave']['password'] }}
    - require:
      - pkg: python-mysqldb
      - service: mysql

# grant all priveleges for user to our database
#all_privileges:
  #mysql_grants.present:
    #- grant: all privileges
    #- database: {{ pillar['db']['slave']['name'] }}.*
    #- user: {{ pillar['db']['slave']['user'] }}
    #- require:
      #- mysql_database: database_exists
      #- mysql_user: {{ pillar['db']['slave']['user'] }}

## grant all priveleges for user to our database
#all_privileges_wildcard:
  #mysql_grants.present:
    #- grant: "ALL PRIVILEGES"
    #- database: {{ pillar['db']['slave']['name'] }}.*
    #- user: {{ pillar['db']['slave']['user'] }}
    #- host: "%"
    #- require:
      #- mysql_database: database_exists
      #- mysql_user: {{ pillar['db']['slave']['user'] }}
      #- mysql_grants: all_privileges

## grant super priveleges for user to our database
#super_privileges:
  #mysql_grants.present:
    #- grant: "SUPER"
    #- database: "*.*"
    #- user: {{ pillar['db']['slave']['user'] }}
    #- require:
      #- mysql_database: database_exists
      #- mysql_user: {{ pillar['db']['slave']['user'] }}

grant_all_privileges:
  cmd.run:
    - name: "mysql -uroot {% if pillar['db']['slave']['root_password'] %}-p{{ pillar['db']['slave']['root_password'] }}{% endif %} -e \"GRANT ALL ON {{ pillar['db']['slave']['name'] }}.* TO {{ pillar['db']['slave']['user'] }}@'localhost' IDENTIFIED BY '{{ pillar['db']['slave']['password'] }}';\""
    - require:
      - mysql_database: database_exists
      - mysql_user: {{ pillar['db']['slave']['user'] }}

grant_all_privileges_wildcard:
  cmd.run:
    - name: "mysql -uroot {% if pillar['db']['slave']['root_password'] %}-p{{ pillar['db']['slave']['root_password'] }}{% endif %} -e \"GRANT ALL ON {{ pillar['db']['slave']['name'] }}.* TO {{ pillar['db']['slave']['user'] }}@'%' IDENTIFIED BY '{{ pillar['db']['slave']['password'] }}';\""
    - require:
      - mysql_database: database_exists
      - mysql_user: {{ pillar['db']['slave']['user'] }}
      - cmd: grant_all_privileges

grant_super_privileges:
  cmd.run:
    - name: "mysql -uroot {% if pillar['db']['slave']['root_password'] %}-p{{ pillar['db']['slave']['root_password'] }}{% endif %} -e \"GRANT SUPER ON *.* TO {{ pillar['db']['slave']['user'] }}@'localhost' IDENTIFIED BY '{{ pillar['db']['slave']['password'] }}';\""
    - require:
      - mysql_database: database_exists
      - mysql_user: {{ pillar['db']['slave']['user'] }}

flush_privileges:
  cmd.run:
    - name: "mysql -uroot {% if pillar['db']['slave']['root_password'] %}-p{{ pillar['db']['slave']['root_password'] }}{% endif %} -e \"FLUSH PRIVILEGES;\""
    - require:
      - cmd: grant_super_privileges
      - cmd: grant_all_privileges_wildcard
