base:
  "*":
    {% if grains['group'] %}
    - {{ grains['group'] }}
    {% else %}
    - default
    {% endif %}
