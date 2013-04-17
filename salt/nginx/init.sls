nginxconf:
  file.managed:
    - name: /etc/nginx/sites-enabled/default
    - source: salt://nginx/nginx.conf
    - template: jinja
    - makedirs: True
    - mode: 755

nginx:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: nginxconf
