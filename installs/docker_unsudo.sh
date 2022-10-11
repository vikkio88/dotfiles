#!/bin/sh

sudo systemctl status docker
sudo usermod -aG docker ${USER}
