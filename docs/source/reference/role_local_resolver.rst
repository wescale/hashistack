local-resolver
==============

Installation and configuration of Unbound DNS resolver. It builds local zone with every node's private NIC address
of the hashistack platform.

------

::

  local_resolver_forwards: []


List of dict defining zones to forward and the forward targets.

.. code:: bash

    - zone: "."
      forwards:
        - 9.9.9.9


------

::

  local_resolver_platform_masters_inventory_group: >-
    {{ lookup('env', 'HS_WORKSPACE') }}_masters


Name of the inventory group that contains master nodes.

------

::

  local_resolver_platform_minions_inventory_group: >-
    {{ lookup('env', 'HS_WORKSPACE') }}_minions


Name of the inventory group that contains minion nodes.

------

::

  local_resolver_domain: "{{ public_domain }}"


This domain will be appended to the *inventory_hostname* of every node when building local zone data.

