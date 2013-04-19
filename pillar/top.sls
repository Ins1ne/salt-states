base:
  "*":
    {% if grains['group'] == 'django' %}
    - django
    {% elif grains['group'] == 'origin1' %}
    - origin1
    {% else %}
    - default
    {% endif %}
