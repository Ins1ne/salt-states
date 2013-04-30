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

# chech if user exists
{{ pillar['db']['slave']['user'] }}:
  mysql_user.present:
    - host: {{ pillar['db']['slave']['host'] }}
    - port: {{ pillar['db']['slave']['port'] }}
    - password: {{ pillar['db']['slave']['password'] }}
    - require:
      - pkg: python-mysqldb
      - service: mysql

# grant all priveleges for user to our database
all_privileges:
  mysql_grants.present:
    - grant: all privileges
    - database: {{ pillar['db']['slave']['name'] }}.*
    - user: {{ pillar['db']['slave']['user'] }}
    - host: "'localhost'"
    - require:
      - mysql_database: database_exists
      - mysql_user: {{ pillar['db']['slave']['user'] }}

# grant all priveleges for user to our database
all_privileges_wildcard:
  mysql_grants.present:
    - grant: all privileges
    - database: {{ pillar['db']['slave']['name'] }}.*
    - user: {{ pillar['db']['slave']['user'] }}
    - host: "'%'"
    - require:
      - mysql_database: database_exists
      - mysql_user: {{ pillar['db']['slave']['user'] }}
      - mysql_grants: all_privileges

# grant super priveleges for user to our database
super_privileges:
  mysql_grants.present:
    - grant: super
    - database: "*.*"
    - user: {{ pillar['db']['slave']['user'] }}
    - host: "'localhost'"
    - require:
      - mysql_database: database_exists
      - mysql_user: {{ pillar['db']['slave']['user'] }}
