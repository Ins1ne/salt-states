base:
  #"*":
    #{% if grains['group'] %}
    #- {{ grains['group'] }}
    #{% else %}
    #- default
    #{% endif %}
  igroflot:
    - match: nodegroup
    - igroflot
  spielgames:
    - match: nodegroup
    - spielgames
