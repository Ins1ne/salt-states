# coding: utf-8


def update_hosts(name):
    pass


def start(test=None, **kwargs):
    return __salt__['state.highstate'](test, **kwargs)
