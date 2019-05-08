{% set master = salt['master.minion']() %}

{% if salt['saltutil.runner']('validate.discovery', cluster='ceph') == False %}

validate failed:
  salt.state:
    - name: just.exit
    - tgt: {{ master }}
    - failhard: True

{% endif %}

push proposals:
  salt.runner:
    - name: push.proposal

refresh_pillar1:
  salt.state:
    - tgt: '{{ salt['pillar.get']('deepsea_minions') }}'
    - tgt_type: compound
    - sls: ceph.refresh

show networks:
  salt.runner:
    - name: advise.networks

# We need ceph-volume to use dg.py and disks.py
install ceph packages:
  salt.state:
    - tgt: '{{ salt['pillar.get']('deepsea_minions') }}'
    - tgt_type: compound
    - sls: ceph.packages
    - failhard: True

{% for role in [ 'admin', 'osd', 'mon', 'mgr', 'igw', 'mds', 'rgw', 'ganesha'] %}
{{ role }} key:
  salt.state:
    - tgt: {{ master }}
    - tgt_type: compound
    - sls: ceph.{{ role }}.key
    - failhard: True

{% endfor %}

install and setup node exporters:
  salt.state:
    - tgt: '{{ salt['pillar.get']('deepsea_minions') }}'
    - tgt_type: compound
    - sls: ceph.monitoring.prometheus.exporters.node_exporter
