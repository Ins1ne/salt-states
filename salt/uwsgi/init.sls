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

uwsgi-service:
    service.running:
        - enable: True
        - name: uwsgi
        - require:
            - file: /etc/init/uwsgi.conf

wsgi_server:
    supervisord:
        - running
        - restart: False
        - require:
            - pkg: supervisor

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
