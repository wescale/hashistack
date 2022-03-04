local-resolver
==============

::

  local_resolver_forwards: []


List of dict defining zones to forward and the forward targets.

.. code:: bash

    - zone: "."
      forwards:
        - 1.1.1.1


------

::

  local_resolver_platform_masters_inventory_group: >-
    {{ lookup('env', 'HS_WORKSPACE') }}_masters


Name of the inventory group that contains master nodes.

------

::

  local_resolver_platform_minions_inventory_group: "{{ lookup('env', 'HS_WORKSPACE') }}_minions"


Name of the inventory group that contains master nodes.

------

::

  local_resolver_domain: "{{ public_domain }}"
