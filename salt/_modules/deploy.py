# coding: utf-8

import requests

__outputter__ = {
    "start": "highstate",
}


def start(test=None, **kwargs):
    return __salt__['state.highstate'](test, **kwargs)


def ping():
    r = requests.get("http://{0}".format(__grains__['id']))

    if r.status_code == 200:
        return True
    else:
        return False


def update_hosts(name):
    pass

def test_pillar():
    return __pillar__
