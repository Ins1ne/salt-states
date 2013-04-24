# coding: utf-8

import requests

__outputter__ = {
    "start": "highstate",
}


def start(test=None, **kwargs):
    return __salt__['state.highstate'](test, **kwargs)


def initialize_games():
    cmd = ". {0}/bin/activate && python apps/sat/setup.py".format(
        __pillar__['virtualenv']
    )
    cwd = __pillar__['project']['root']

    return __salt__['cmd.run'](cmd, cwd=cwd)


def migrate_sat():
    cmd = ". {0}/bin/activate && python manage.py migrate sat".format(
        __pillar__['virtualenv']
    )
    cwd = __pillar__['project']['root']

    return __salt__['cmd.run'](cmd, cwd=cwd)


def connect_slave_to_master():
    if __pillar__['db']['master']['port']:
        port =  ', MASTER_PORT=\'{5}\''.format(
            __pillar__['db']['master']['port']
        )
    else:
        port = "";

    cmd = 'mysql -u{0} -p{1} -e "STOP SLAVE; CHANGE MASTER TO MASTER_HOST=\'{2}\', MASTER_USER=\'{3}\', MASTER_PASSWORD=\'{4}\'{5}; START SLAVE;"'.format(
        __pillar__['db']['slave']['user'],
        __pillar__['db']['slave']['password'],
        __pillar__['db']['master']['host'],
        __pillar__['db']['master']['user'],
        __pillar__['db']['master']['password'],
        port,
    )

    return __salt__['cmd.run'](cmd)


def install_mysql_extension():
    cmd = "cd {0}/conf/sql/udf/ && sh install.sh".format(
        __pillar__['project']['root']
    )
    make_cmd = "cd {0}/conf/sql/udf/ && make".format(
        __pillar__['project']['root']
    )
    __salt__['cmd.run'](make_cmd)

    if __pillar__['db']['slave']['port']:
        port = " -P{0}".format(__pillar__['db']['slave']['port'])
    else:
        port = ""

    mysql_cmd = "mysql -u{0} -p{1} -h{2}{3} {4} < {5}/conf/sql/udf/{6}".format(
        __pillar__['db']['slave']['user'],
        __pillar__['db']['slave']['password'],
        __pillar__['db']['slave']['host'],
        port,
        'mysql',
        __pillar__['project']['root'],
        'lib_mysqludf_sys.sql',
    )

    #return __salt__['cmd.run'](cmd)
    return __salt__['cmd.run'](mysql_cmd)


def create_south_tables():
    cmd = "cd {0} && . {1}/bin/activate && python manage.py reset south --noinput".format(
        __pillar__['project']['root'],
        __pillar__['virtualenv'],
    )

    return __salt__['cmd.run'](cmd)


def mysql_import_file(path):
    if __pillar__['db']['slave']['port']:
        port = " -P{0}".format(__pillar__['db']['slave']['port'])
    else:
        port = ""

    cmd = "mysql -u{0} -p{1} -h{2}{3} {4} < {5}".format(
        __pillar__['db']['slave']['user'],
        __pillar__['db']['slave']['password'],
        __pillar__['db']['slave']['host'],
        port,
        __pillar__['db']['slave']['name'],
        path,
    )

    return __salt__['cmd.run'](cmd)


def mysql_restart():
    cmd = 'service mysql restart'

    return __salt__['cmd.run'](cmd)


def mysql_copy_file(filename):
    return __salt__['cp.get_file']('salt://mysql/sql/{0}'.format(filename),
                                   '/tmp/{0}'.format(filename))


def mysql_copy_structure():
    return __salt__['cp.get_file']('salt://mysql/sql/structuredump.sql',
                                   '/tmp/stucturedump.sql')


def mysql_copy_data():
    return __salt__['cp.get_file']('salt://mysql/sql/datadump.sql',
                                   '/tmp/datadump.sql')

def ping():
    """
    Check main page status code
    """
    status = False

    try:
        r = requests.get("http://{0}".format(__grains__['fqdn']))

        if r.status_code == 200:
            status = True
    except requests.exceptions.ConnectionError:
        pass

    return status
