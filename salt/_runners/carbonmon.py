import salt.client


def pollpush():
    '''
    Run the monitoring command and return to carbon
    '''
    client = salt.client.LocalClient(__opts__['conf_file'])
    cmds = ('ps.physical_memory_usage', 'ps.cpu_percent')
    nodes = '*'

    for cmd in cmds:
        jid = client.cmd_async(nodes, cmd, ret='carbon', timeout=__opts__['timeout'])
