include:
    - reqs
    - nginx

uwsgi:
    pip.installed:
        - pkgs:
            uwsgi
        - require:
            - pkg: python-dev
            - pkg: python-pip

/var/log/uwsgi:
    file.directory:
        - makedirs: True

/etc/uwsgi/vassals:
    file.directory:
        - makedirs: True

vassal_config:
    file.managed:
        - name: "/etc/uwsgi/vassals/{{ pillar['project_name'] }}.ini"
        - source: salt://uwsgi/uwsgi.ini
        - template: jinja
        - require:
            - pip: uwsgi

/etc/init/uwsgi.conf:
    file.managed:
        - source: salt://uwsgi/uwsgi.conf
        - template: jinja
        - require:
            - pip: uwsgi

reload-uwsgi-service:
    cmd.run:
        #- name: "supervisorctl restart {{ pillar['project_name'] }}"
        - name: "touch /etc/uwsgi/vassals/{{ pillar['project_name'] }}.ini"
        - require:
            - pip: uwsgi
            - git: webapp
            - virtualenv: venv
            - file: vassal_config

nginxconf:
    file.managed:
        - name: /etc/nginx/sites-enabled/default
        - source: salt://uwsgi/nginx.conf
        - template: jinja
        - makedirs: True
        - mode: 755

nginx:
    service:
        - running
        - watch:
            - file: nginxconf
