#!/usr/bin/python3

from fabric.api import local, run, env, put, sudo
from datetime import datetime
from os.path import exists
env.hosts = ["34.74.73.47", "35.237.84.2"]


def do_pack():
    """Pack file """
    local("sudo mkdir -p versions")
    date = datetime.now().strftime("%Y%m%d%H%M%S")
    file = ("versions/web_static_{}.tgz").format(date)
    local("sudo tar -cvzf {} web_static".format(file))
    return file


def do_deploy(archive_path):
    """Deploy file"""
    if exists(archive_path) is False:
        return False
    try:
        put(archive_path, "/tmp/")
        my_tgz = archive_path.split("/")[1].split(".")[0]
        path = "/data/web_static/releases/{}".format(my_tgz)
        print(path)
        run("mkdir {}".format(path))
        run("tar -zxvf /tmp/{}.tgz -C {}/".format(my_tgz, path))
        run("sudo rm /tmp/{}".format(archive_path.split("/")[1]))
        run("sudo rm /data/web_static/current")
        run("sudo ln -sf /data/web_static/releases/{}\
        /data/web_static/current".format(my_tgz))
        run("sudo mv /data/web_static/releases/{}/web_static/*\
        /data/web_static/releases/{}".format(my_tgz, my_tgz))
        run("rm -rf /data/web_static/releases/{}/web_static/".format(my_tgz))
        return True
    except:
        return False
