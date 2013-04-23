# coding: utf-8

import requests

__outputter__ = {
    "start": "highstate",
}


def start(test=None, **kwargs):
    return __salt__['state.highstate'](test, **kwargs)


def migrate_sat():
    cmd = ". {0}/bin/activate && python manage.py migrate sat".format(__pillar__['virtualenv'])
    cwd = __pillar__['project']['root']

    return __salt__['cmd.run'](cmd, cwd=cwd)


def connect_db_to_master():
    cmd = 'mysql -u{0} -p{1} –e "STOP SLAVE; CHANGE MASTER TO MASTER_HOST=\'{2}\', MASTER_USER=\'{3}\', MASTER_PASSWORD=\'{4}\', MASTER_PORT=\'{5}\'; START SLAVE;"'.format(
        __pillar__['db']['slave']['user'],
        __pillar__['db']['slave']['password'],
        __pillar__['db']['master']['host'],
        __pillar__['db']['master']['user'],
        __pillar__['db']['master']['password'],
        __pillar__['db']['master']['port'],
    )

    return __salt__['cmd.run'](cmd)


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


def db():
    pass


def test():
    return 'sss'
