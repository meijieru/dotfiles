# Install

## Prequisite

- Change mirror source
- Add following to `/etc/pacman.conf`, `pacman -Syy`, then `pacman -S archlinuxcn-keyring`

    ```
    [archlinuxcn]
    SigLevel = Optional TrustedOnly
    Server = http://repo.archlinuxcn.org/$arch
    ```

- Install `pacaur`, and set up git

## Postprocess

- start up services
    - `sudo systemctl enable dhcpcd.service`
    - `sudo systemctl enable NetworkManager.service`
    - `sudo systemctl enable bluetooth.service`
