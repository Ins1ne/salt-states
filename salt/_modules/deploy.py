# coding: utf-8

import requests

__outputter__ = {
    "start": "highstate",
}


def start(test=None, **kwargs):
    return __salt__['state.highstate'](test, **kwargs)


def ping():
    """
    Check main page status code
    """
    status = False

    try:
        r = requests.get("http://{0}".format(__grains__['id']))

        if r.status_code == 200:
            status = True
    except requests.exceptions.ConnectionError:
        pass

    return status


def test_pillar():
    return __pillar__
