import salt.client
import sys


def pollpush():
    '''
    Run the monitoring command and return to carbon
    '''
    client = salt.client.LocalClient(__opts__['conf_file'])
    cmds = ('virt.vm_diskstats', 'virt.vm_netstats', 'virt.vm_cputime')
    nodes = 'chani,harkonnen,fremen'

    for cmd in cmds:
        jid = client.cmd_async(nodes, cmd, expr_form='list', ret='carbon', timeout=__opts__['timeout'])
