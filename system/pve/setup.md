## Proxmox

### Install 

- Go to web manager
    - `https:${IP}:8006`, use `root` account
- Remove activation notification
    ```sh
    sed -i.bak "s/data.status !== 'Active'/false/g" /usr/share/pve-manager/js/pvemanagerlib.js
    ```
- Enable https for apt
    ```sh
    apt install apt-transport-https
    apt-get update
    ```
- Find the fastest mirror
    ```sh
    apt-get install netselect-apt
    netselect-apt -c china -t 15 -a amd64
    cp /etc/apt/sources.list /etc/apt/sources.list_backup
    mv sources.list /etc/apt/sources.list

    # NOTE: check which mirror to use
    echo "# deb http://download.proxmox.com/debian/pve buster pve-no-subscription
    deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian buster pve-no-subscription
    deb https://mirrors.ustc.edu.cn/proxmox/debian/pve buster pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
    wget http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg -O /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
    chmod +r /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
    apt update && apt full-upgrade
    ```
- Disable LidSwitch suspend
    ```sh
    sed -i 's/#HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=ignore/g' /etc/systemd/logind.conf
    service systemd-logind restart
    ```
- Enable UPS using [nut](https://wiki.archlinux.org/title/Network_UPS_Tools)
    - Problem: NUT data stale with CyberPower UPS
        - Sol: modify the [interval](https://raspberrypi.stackexchange.com/questions/66611/nut-cyberpower-data-stale)

- Add backup job for VMs in GUI
    - Under `Datacenter/Backup`
    - TODO: failure on email

### Best practices


- [Use type `host` for cpu]()
- Use type `q35` for machine
- `Snapshot` for small modification, `Backup` for portable vm
- [Enable Auto-Ballooning](https://pve.proxmox.com/wiki/Dynamic_Memory_Management#Ballooning)

Introduction and best practices for kvm
- https://zhuanlan.zhihu.com/p/31894107
- https://zhuanlan.zhihu.com/p/31895393
- https://zhuanlan.zhihu.com/p/31548819

### LXC

- [Archlinux 静态ip没法联网](https://forum.proxmox.com/threads/privileged-lxc-with-arch-fails-to-start-network-and-systemd-nspawn.52646/)
    - enable nesting

#### Jellyfin

Ref
- https://www.z5n0w.cn/wordpress/?p=848
- https://post.smzdm.com/p/apzdlwdw/
- https://www.reddit.com/r/jellyfin/comments/g8lb1j/migrating_jellyfin_libraryconfig_lxc_vaapi/

- 注意hook文件需要有执行权限`chmod +x ${HOOK_FILE}`
- [注意proxmox 7.0开始使用cgroup2](https://forum.proxmox.com/threads/pve-7-0-lxc-intel-quick-sync-passtrough-not-working-anymore.92025/)

### Virutal machines

#### Openwrt

Create a vm in pve web, `Do not use any media` in `OS` tab.

```sh
export RELEASE='19.07.3'
export ISO_NAME=
export VM_ID=101

wget -O /var/lib/vz/template/iso/openwrt.img.gz https://downloads.openwrt.org/releases/${RELEASE}/targets/x86/64/openwrt-${RELEASE}-x86-64-combined-squashfs.img.gz
cd /var/lib/vz/template/iso
tar xzf openwrt.img.gz
qemu-img resize openwrt.img +1G  # increase disk image, otherwise `/overlay` is too small
wget -P /usr/local/bin http://dl.everun.top/softwares/utilities/img2kvm/img2kvm
chmod +x /usr/local/bin/img2kvm
img2kvm openwrt.img ${VM_ID}
```

Modify disk
- Delete origin disk
- Attach the generated disk
- Set the disk to boot in `Options->Boot Order`

Should be bootable now
```sh
# passwd
echo 'NOTE: set the passwd for openwrt!!!'
exit

# ip addr
echo 'NOTE: set static ip, point dns/gateway to main router!!!'
exit
vim /etc/config/network
/etc/init.d/network reload

# mirror [optional]
sed -i 's_downloads.openwrt.org_mirrors.tuna.tsinghua.edu.cn/openwrt_' /etc/opkg/distfeeds.conf

# luci
opkg update
opkg install luci luci-i18n-base-zh-cn

# theme
echo 'NOTE: download from https://github.com/jerrykuku/luci-theme-argon/releases'
exit

# https://www.right.com.cn/forum/forum.php?mod=viewthread&tid=3695056
echo 'NOTE: set dhcp, firewall'
exit

# v2ray [optional]
wget -O kuoruan-public.key http://openwrt.kuoruan.net/packages/public.key
opkg-key add kuoruan-public.key
echo "src/gz kuoruan_universal http://openwrt.kuoruan.net/packages/releases/all" >> /etc/opkg/customfeeds.conf
echo "src/gz kuoruan_packages http://openwrt.kuoruan.net/packages/releases/$(. /etc/openwrt_release ; echo $DISTRIB_ARCH)" >> /etc/opkg/customfeeds.conf
opkg update
opkg install luci luci-base luci-compat
opkg install luci-i18n-base-zh-cn uhttpd libuhttpd-openssl luci-app-uhttpd luci-i18n-uhttpd-zh-cn ip-full ipset iptables-mod-tproxy iptables-mod-nat-extra libpthread coreutils-base64 ca-bundle curl vim-full vim-runtime v2ray-core luci-app-v2ray luci-i18n-v2ray-zh-cn
```

opkg remove luci-mod-system luci-mod-status luci-mod-admin-full luci-mod-network luci-i18n-base-zh-cn


#### Windows

[Guidance](https://pve.proxmox.com/wiki/Windows_2019_guest_best_practices)

- TODO: change the net adaptor to `virtio`
- TODO: fix `guest agent not running`
- reference
    - https://www.reddit.com/r/Proxmox/comments/p9dt8d/is_anyone_able_to_run_windows_2022_currently/
    - https://forum.proxmox.com/threads/windows-server-2022-installation-with-virtio-network-and-scsi-drive-working.98050/

#### OMV

##### Login

Get the ip by `ip addr` and copy into the browser with http.
The default account/password is `admin/openmediavault`

##### Basic

Install `omv-extras`
```sh
wget -O - https://github.com/OpenMediaVault-Plugin-Developers/packages/raw/master/install | bash
```

In GUI
```md
Install and cockpit in omv-extras.
Install `cockpit-pcp` for usage visualization.
```

Install the utilities.
In debian, fd is renamed to fdfind.

##### User

Add user to `ssh,sudo,users` group

##### Network

`TODO`
- Static ip in router

##### Disk

[Passthrough](https://pve.proxmox.com/wiki/Passthrough_Physical_Disk_to_Virtual_Machine_(VM)) HDD/SSD/Physical disks to VM on Proxmox VE(PVE), [example](https://www.iguazio.com/docs/latest-release/cluster-mgmt/deployment/on-prem/vm/proxmox/howto/data-disks-attach/)
```sh
find /dev/disk/by-id/ -type l|xargs -I{} ls -l {}|grep -v -E '[0-9]$' |sort -k11|cut -d' ' -f9,10,11,12
dev=${DISK_BY_ID} ; qm set ${VM_ID} --scsi${SCSI_ID} ${dev},snapshot=0,backup=0,serial=$(lsblk -nd -o serial ${dev})
```

In OMV, it mounts the disks to `/src` with disk id, which is not readable.
Make symlink
```sh
ln -s ${DIR_SRC} ${DIR_DST}
```

Add `noatime` following the [wiki](https://wiki.archlinux.org/title/Fstab#atime_options).
Modify `mntent` section in `/etc/openmediavault/config.xml` to change the mount options, then run `omv-salt deploy run fstab`.

OMV disk options:
- For lifespan, disable `write-cache`.
- APM: 127 with spindown for non-freq, otherwise 128.
- AAM: minimum.


##### Shared Directory

- `sharerootfs`: TODO

##### Backup

###### Rsync

Enable `delete` option.

###### USB backup

TODO

###### Rclone

Config rclone for encrypted backup to cloud service


##### UPS

Do it on proxmox host.


##### Docker

- gui里安装portainer
    - 将portainer加到`behind_proxy`网络中，从而实现外网访问

##### Git

###### Gitea

- 创建gitea的database
    ```sql
    mysql -u root -p
    CREATE DATABASE gitea;
    GRANT ALL PRIVILEGES ON gitea.* TO 'gitea'@'localhost' IDENTIFIED BY 'XXXXXXXX';
    SHOW GRANTS FOR 'gitea';
    FLUSH PRIVILEGES;
    ```
- 如果需要[ssh passthrough](https://docs.gitea.io/en-us/install-with-docker/#ssh-container-passthrough)
    - 创建用户组`git`
    - 创建用户`git`
        - 可以在omv web gui操作，用户组`ssh, users, git, docker`
- [awesome gitea](https://gitea.com/gitea/awesome-gitea#user-content-applications)
    - [transfer from github](https://gitea.com/yige/github2gitea)
- TODO
    - Dependabot 
    - Issue template

##### Cloud service

###### Nextcloud

不错的教程[guidance](https://wusiyu.me/docker-nextcloud-self-sign-https-redis-with-samba-depoly-guide/)

- [启动服务，安装包等](https://www.linuxserver.io/blog/2019-09-14-customizing-our-containers)
- [Guidance](https://docs.linuxserver.io/general/swag#nextcloud-subdomain-reverse-proxy-example)
    - **直接在域名下设置nextcloud，不要本地设置**
- [设置](http://help.websoft9.com/cloudbox-practice/nextcloud/account.html)
- [local file name clash](https://github.com/owncloud/client/issues/6981)
- [上传速度慢](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/big_file_upload_configuration.html#adjust-chunk-size-on-nextcloud-side)
    - `/usr/bin` must in path
    <!-- - 关闭分片下载`sudo -u abc php occ config:app:set files max_chunk_size --value 0`, linuxserver的docker用户名是`abc` -->
    - 调整分片`occ config:app:set files max_chunk_size --value 1073741824`, linuxserver的docker用户名是`abc`
- [外部储存无法分享](外部储存选项中enable分享)
- [nextcloud配置]
    - `php/www2.conf` to overload `/etc/<php_version>/php-fpm.d/www2.conf`
    - `php/php-local.ini` to overload `/etc/<php_version>/php.ini`
- 启用缓存
    - enable [memory cache](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#memory-caching-backend-configuration)
- Debug
    - `echo '<?php phpinfo(); ?>' > ${nextcloud_config_root}/www/nextcloud/phpinfo.php`, then check `<addr>/phpinfo.php`
- 去除warning
    - add trusted proxy domain
    - enable HLSL by editing the proxy config for nextcloud `add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;`
    - disable caching for proxy `proxy_max_temp_file_size 0;`
- [上传超过512M](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/big_file_upload_configuration.html)
    - Understand nginx buffering behavior
        - [The Benefits of Microcaching with NGINX](https://www.nginx.com/blog/benefits-of-microcaching-nginx/)
        - [**Cache Placement Strategies for NGINX and NGINX Plus**](https://www.nginx.com/blog/cache-placement-strategies-nginx-plus/)
            - The memory used by a tmpfs cache could just as effectively be used by the page cache for a larger on‑disk cache.
        https://n3xtchen.github.io/n3xtchen/nginx/2016/02/19/nginx-port-forwording
    - php [ignore](https://stackoverflow.com/questions/12531408/setting-php-tmp-dir-php-upload-not-working) `upload_tmp_dir` setting
    - related 
        - https://help.nextcloud.com/t/504-gateway-timeout-for-large-file-uploads/87839/12
        - https://serverfault.com/questions/1007786/nginx-php-fpm-extremely-high-amounts-of-data-written-to-disk/1008029#1008029?newreg=b176ae4f799247d687477cf6041ee7c4
        - https://www.jianshu.com/p/55fd5ddafb1a
            - TODO: check innodb_flush_log_at_trx_commit 
        - https://haydenjames.io/linux-server-performance-disk-io-slowing-application/
        - https://github.com/Chocobozzz/PeerTube/issues/1423#issue-383221461
        - [profiling disk](https://haydenjames.io/linux-server-performance-disk-io-slowing-application/)

- 如果redis遇到权限问题
    - 官方镜像使用`UID=999, GID=1000`
    <!-- - 如果database目录没有预先创建，group会被设置为root -->
    <!-- - `chown -R 999:1000 ${REDIS_DATA_DIR}` -->
    <!-- - 观察到`dump.rdb`的用户会由999变为1000，导致权限错误，`chmod 664 ${REDIS_DATA_DIR}/dump.rdb` -->
    - docker-compose指定使用当前用户运行
- TODO
    - Move appdata to SSD
        - https://help.nextcloud.com/t/can-i-move-preview-app-data-to-ssd/104998
        - https://help.nextcloud.com/t/what-is-the-appdata-ocpom4nckwru-directory/19900
    - Integrate nextcloud
    - Android SSL initialized failed
- 缩略图相关
    - [参数设置](https://www.sgtfz.cn/2021/04/2944.html)


##### Multimedia

[参考](https://sleele.com/2020/03/16/%e9%ab%98%e9%98%b6%e6%95%99%e7%a8%8b-%e8%bf%bd%e5%89%a7%e5%85%a8%e6%b5%81%e7%a8%8b%e8%87%aa%e5%8a%a8%e5%8c%96/)

###### Jellyfin

Use VA-API for hardware acceleration
- Mount the corresponding device `/dev/dri:/dev/dri`
- set env var `DOCKER_MODS=linuxserver/mods:jellyfin-amd`

`FIXME`: how to do it in PVE?
Related sources:
- https://cetteup.com/216/how-to-use-an-intel-vgpu-for-plexs-hardware-accelerated-streaming-in-a-proxmox-vm/

How to [ignore files](https://features.jellyfin.org/posts/254/ignore-should-follow-same-rules-as-plex#)
- Currently add .ignore to the folder to exclude it from scanning.
- Currently not wildcard allowed.

Client
- [Windows](https://jellyfin.org/docs/general/clients/kodi.html#jellycon)
    - 如何[使用电视进行upscale](https://forum.kodi.tv/showthread.php?tid=351669)

为了隐私，关闭DLNA

###### Sonnar

- [Failed to import](https://trash-guides.info/Radarr/Radarr-remote-path-mapping/), requires remote path mapping.

##### Troubleshooting

- Problem: In PVE, could not shutdown or reboot the vm `VM quit/powerdown failed - got timeout`.
    - Sol: modify the `power button` option in omv GUI to `shutdown`.

##### Proxy

Use `subdomain` instead of `subfolder`.

- FIXME: use docker.internal instead of hardcoded

##### Increase the vm disk

[Officially](https://pve.proxmox.com/wiki/Resize_disks)
1. Resize the disk in pve
1. [Reboot](https://unix.stackexchange.com/questions/441789/resize2fs-fail-to-resize-partition-to-full-capacity) the VM
1. `sudo resize2fs ${DEV}`

However, I meet some problem. Seems due to the swap partition. So I
1. Disable swap
1. Remove the partition
1. `sudo apt install cloud-guest-utils`
1. `sudo growpart /dev/sda 1`
1. `sudo resize2fs /dev/sda1`
1. Use [swap file](https://wiki.archlinux.org/title/Swap#Swap_file) instead

## Others

- useful command
- `du --max-depth=2 -h ./ --exclude=./srv --exclude=./media --exclude=./proc | sort -h | tail -n 20`
