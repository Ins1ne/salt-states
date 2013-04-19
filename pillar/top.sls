base:
  "*":
    {% if grains['group'] == 'django' %}
    - django
    {% els if grains['group'] == 'origin1' %}
    - origin1
    {% else %}
    - default
    {% endif %}
