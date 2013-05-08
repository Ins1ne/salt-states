#!/usr/bin/env python
# coding: utf-8

import os
import sys
from fabric.api import local
from fabric.contrib import django

SALT_MASTER_PATH = '/home/deploy/master/test/salt/'
PROJECT_ROOT = os.path.join(SALT_MASTER_PATH, 'app', 'satellite-simplified')

sys.path[0:0] = [
    PROJECT_ROOT,
]

django.project('satellites_simplified')
from apps.master.models import OriginConf


def origin_list():
    """
    List available origins databases
    """
    origins = OriginConf.objects.all()

    for origin in origins:
        print origin.human_title


def satellite(origin_name, minion_name):
    """
    Deploy new satellite
    """
    origin = OriginConf.objects.filter(human_title=origin_name)

    if not origin or len(origin) > 1:
        print u"Неправильное имя origin'а"
        sys.exit()

    origin = origin[0]

    local("sudo salt '{0}' saltutil.sync_all".format(minion_name))
    local("sudo salt '{0}' saltutil.refresh_pillar".format(minion_name))
    local("sudo salt '{0}' deploy.setup_initial_mysql_password".format(
        minion_name
    ))
    local("cd {0} && git pull origin master".format())
    local("sudo salt '{0}' state.highstate".format(minion_name))
    local("sudo salt '{0}' deploy.install_mysql_extension".format(minion_name))

    if origin.port:
        port = " -P{0}".format(origin.port)
    else:
        port = ""

    local("mysqldump -u{0} -p{1} -h{2}{3} --skip-triggers --no-data --ignore-table={4}.south_migrationhistory {4} > {5}".format(
        origin.user,
        origin.password,
        origin.host,
        port,
        origin.name,
        os.path.join(
            SALT_MASTER_PATH, 'mysql', 'sql', origin.name+'_structuredump.sql'
        )
    ))
    local("mysqldump -u{0} -p{1} -h{2}{3} --master-data --no-create-db --no-create-info --complete-insert --ignore-table={4}.south_migrationhistory {4} > {5}".format(
        origin.user,
        origin.password,
        origin.host,
        port,
        origin.name,
        os.path.join(
            SALT_MASTER_PATH, 'mysql', 'sql', origin.name+'_datadump.sql'
        )
    ))
    local("sudo salt '{0}' deploy.mysql_copy_dump {1}_structuredump.sql".format(
        minion_name, origin.name
    ))
    local("sudo salt '{0}' deploy.mysql_copy_dump {1}_datadump.sql".format(
        minion_name, origin.name
    ))
    local("sudo salt '{0}' deploy.mysql_import_dump {1}_structuredump.sql".format(
        minion_name, origin.name
    ))
    local("sudo salt '{0}' deploy.reset_south".format(minion_name))
    local("sudo salt '{0}' deploy.migrate_sat".format(minion_name))
    local("sudo salt '{0}' deploy.stop_slave".format(minion_name))
    local("sudo salt '{0}' deploy.change_master_connection_data".format(
        minion_name
    ))
    local("sudo salt '{0}' deploy.mysql_import_dump {1}_datadump.sql".format(
        minion_name, origin.name
    ))
    local("sudo salt '{0}' deploy.start_slave".format(minion_name))
    local("sudo salt '{0}' deploy.initialize_games".format(minion_name))
    local("sudo salt '{0}' deploy.restart_app".format(minion_name))


def deploy(match="'*'"):
    """
    Update code base and restart app
    """
    local('cd {0} && git pull origin master'.format(PROJECT_ROOT))
    local("sudo salt {0} state.highstate".format(match))
    local("sudo salt {0} deploy.restart_app".format(match))
