# coding: utf-8

import urllib2

__outputter__ = {
    "start": "highstate",
}


def initialize_games():
    """
    Initialize basic game publications
    """
    cmd = ". {0}/bin/activate && python apps/sat/setup.py".format(
        __pillar__['virtualenv']
    )
    cwd = __pillar__['project']['root']

    return __salt__['cmd.run'](cmd, cwd=cwd)


def migrate_sat():
    """
    Migrations for satellite
    """
    cmd = ". {0}/bin/activate && python manage.py migrate sat".format(
        __pillar__['virtualenv']
    )
    cwd = __pillar__['project']['root']

    return __salt__['cmd.run'](cmd, cwd=cwd)


def change_master_connection_data():
    """
    Run CHANGE MASTER TO MATER on slave
    """
    if __pillar__['db']['master']['port']:
        port =  ', MASTER_PORT=\'{0}\''.format(
            __pillar__['db']['master']['port']
        )
    else:
        port = "";

    if __pillar__['db']['slave']['port']:
        slave_port =  ' -P=\'{0}\''.format(
            __pillar__['db']['slave']['port']
        )
    else:
        slave_port = "";

    cmd = 'mysql -u{0} -p{1} -h{2}{3} -e "CHANGE MASTER TO MASTER_HOST=\'{4}\', MASTER_USER=\'{5}\', MASTER_PASSWORD=\'{6}\'{7};"'.format(
        __pillar__['db']['slave']['user'],
        __pillar__['db']['slave']['password'],
        __pillar__['db']['slave']['host'],
        slave_port,
        __pillar__['db']['master']['host'],
        __pillar__['db']['master']['user'],
        __pillar__['db']['master']['password'],
        port,
    )

    return __salt__['cmd.run'](cmd)


def start_slave():
    """
    Run START SLAVE in mysql
    """
    if __pillar__['db']['slave']['port']:
        port =  ' -P=\'{0}\''.format(
            __pillar__['db']['slave']['port']
        )
    else:
        port = "";

    cmd = 'mysql -u{0} -p{1} -h{2}{3} -e "START SLAVE;"'.format(
        __pillar__['db']['slave']['user'],
        __pillar__['db']['slave']['password'],
        __pillar__['db']['slave']['host'],
        port,
    )

    return __salt__['cmd.run'](cmd)


def stop_slave():
    """
    Run STOP SLAVE in mysql
    """
    if __pillar__['db']['slave']['port']:
        port =  ' -P=\'{0}\''.format(
            __pillar__['db']['slave']['port']
        )
    else:
        port = "";

    cmd = 'mysql -u{0} -p{1} -h{2}{3} -e "STOP SLAVE;"'.format(
        __pillar__['db']['slave']['user'],
        __pillar__['db']['slave']['password'],
        __pillar__['db']['slave']['host'],
        port,
    )

    return __salt__['cmd.run'](cmd)


def install_mysql_extension():
    """
    Install mysql extension from project
    """
    make_cmd = "cd {0}/conf/sql/udf/ && make".format(
        __pillar__['project']['root']
    )
    __salt__['cmd.run'](make_cmd)

    if __pillar__['db']['slave']['port']:
        port = " -P{0}".format(__pillar__['db']['slave']['port'])
    else:
        port = ""

    if __pillar__['db']['slave']['root_password']:
        root_password = " -p{0}".format(
            __pillar__['db']['slave']['root_password']
        )
    else:
        root_password = ""

    mysql_cmd = "mysql -u{0}{1} -h{2}{3} {4} < {5}/conf/sql/udf/{6}".format(
        'root',
        root_password,
        __pillar__['db']['slave']['host'],
        port,
        'mysql',
        __pillar__['project']['root'],
        'lib_mysqludf_sys.sql',
    )

    return __salt__['cmd.run'](mysql_cmd)


def reset_south():
    """
    Run reset south to create south tables
    """
    cmd = "cd {0} && . {1}/bin/activate && python manage.py reset south --noinput".format(
        __pillar__['project']['root'],
        __pillar__['virtualenv'],
    )

    return __salt__['cmd.run'](cmd)


def mysql_import_dump(filename):
    """
    Import dump by name from /tmp folder on minion
    """
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
        "/tmp/{0}".format(filename),
    )

    return __salt__['cmd.run'](cmd)


def mysql_restart():
    """
    Restart mysql
    """
    cmd = 'service mysql restart'

    return __salt__['cmd.run'](cmd)


def mysql_copy_dump(filename):
    """
    Copy dump from salt/mysql/sql on master to /tmp folder on minion
    """
    return __salt__['cp.get_file']('salt://mysql/sql/{0}'.format(filename),
                                   '/tmp/{0}'.format(filename))


def setup_initial_mysql_password():
    """
    Setup mysql password for silently install
    """
    cmd = "echo mysql-server mysql-server/root_password password {0} | debconf-set-selections && echo mysql-server mysql-server/root_password_again password {0} | debconf-set-selections".format(
    __pillar__['db']['slave']['root_password']
    )

    return __salt__['cmd.run'](cmd)


def ping():
    """
    Check main page status code
    """
    status = False

    try:
        r = urllib2.urlopen("http://{0}".format(__grains__['fqdn']))

        if r.code == 200:
            status = True
    except urllib2.URLError:
        pass

    return status


def reload_app():
    """
    Soft reload application
    """
    path = "/etc/uwsgi/vassals/{0}.ini".format(__pillar__['project']['name'])

    return __salt__['file.touch'](path)


def restart_app():
    """
    Restart application via supervisorctl
    """
    cmd = 'supervisorctl restart {0}'.format(__pillar__['project']['name'])

    return __salt__['cmd.run'](cmd)


def design(layout):
    """
    Renders new layout for project
    """
    cmd = ". {0}/bin/activate && python manage.py layout {1}".format(
        __pillar__['virtualenv'],
        layout,
    )
    cwd = __pillar__['project']['root']
    user = __pillar__['system']['user']

    return __salt__['cmd.run'](cmd, cwd=cwd, user=user)
