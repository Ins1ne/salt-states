base:
    "*":
        {% if grains['id'].startswith('origin1') %}
        - origin1
        {% else %}
        - django
        {% endif %}
