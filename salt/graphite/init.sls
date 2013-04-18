graphite:
  pkg.installed:
    - pkgs:
      - python-django
      - python-pip
      - python-django-tagging
      - python-dev
      - python-twisted
      - python-memcache
      - memcached
      - python-cairo

graphite-web:
  pip.installed:
    - require:
      - pkg: graphite

whisper:
  pip.installed:
    - require:
      - pkg: graphite

carbon:
  pip.installed:
    - require:
      - pkg: graphite
