# coding: utf-8

__outputter__ = {
    "start": "highstate",
}


def start(test=None, **kwargs):
    return __salt__['state.highstate'](test, **kwargs)


def ping():
    return True


def update_hosts(name):
    pass

def test_pillar():
    return __pillar__
