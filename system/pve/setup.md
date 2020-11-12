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

### Best practices


- [Use type `host` for cpu]()
- Use type `q35` for machine
- `Snapshot` for small modification, `Backup` for portable vm

Introduction and best practices for kvm
- https://zhuanlan.zhihu.com/p/31894107
- https://zhuanlan.zhihu.com/p/31895393
- https://zhuanlan.zhihu.com/p/31548819

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
