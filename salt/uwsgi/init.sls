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

uwsgi-service:
    service.running:
        - enable: True
        - name: uwsgi
        - require:
            - file: /etc/init/uwsgi.conf
            - file: /etc/init/uwsgi.ini

reload-uwsgi-service:
    cmd.run:
        - name: "touch /tmp/{{ pillar['project_name'] }}-reload.txt"
        - require:
            - pip: uwsgi
            - git: webapp
            - virtualenv: venv

/etc/init/uwsgi.conf:
    file.managed:
        - source: salt://uwsgi/uwsgi.conf
        - template: jinja
        - require:
            - pip: uwsgi

/etc/init/uwsgi.ini:
    file.managed:
        - source: salt://uwsgi/uwsgi.ini
        - template: jinja
        - require:
            - pip: uwsgi
