# coding: utf-8

__outputter__ = {
    "start": "highstate",
}


def start(test=None, **kwargs):
    return __salt__['state.highstate'](test, **kwargs)


def ping():
    pass


def update_hosts(name):
    pass
