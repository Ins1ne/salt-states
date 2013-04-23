# coding: utf-8

import requests

__outputter__ = {
    "start": "highstate",
}


def start(test=None, **kwargs):
    return __salt__['state.highstate'](test, **kwargs)


def migrate_sat():
    cmd = ". {0}/bin/activate && python manage.py migrate sat".format(__pillar__['virtualenv'])
    cwd = __pillar__['project_root']

    return __salt__['cmd.run'](cmd, cwd=cwd)


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
