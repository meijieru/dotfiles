# Install

## Prequisite

- Make bootable usb `sudo dd if={path_to_iso} of={/dev/sda} bs=4M conv=fdatasync`
- Change mirror source
- Add following to `/etc/pacman.conf`, `pacman -Syy`, then `pacman -S archlinuxcn-keyring`

    ```
    [archlinuxcn]
    SigLevel = Optional TrustedOnly
    Server = http://repo.archlinuxcn.org/$arch
    ```

- Install `yay`, and set up git

## Postprocess

- Sudo
    - For manjaro, run `sudo rm /etc/sudoers.d -r`
    - sudo without passwd：run `visudo` and add `%wheel ALL=(ALL) NOPASSWD: ALL`

- Start up services
    - `sudo systemctl enable NetworkManager`
    - `sudo systemctl enable bluetooth`
    - `sudo systemctl enable sddm`
    - `sudo systemctl enable tlp`
    - `sudo systemctl enable tlp-sleep`
    - `sudo systemctl disable netctl`

- HiDPI
    - [Grub](https://unix.stackexchange.com/questions/31672/can-grub-font-size-be-customised)
    - [SDDM](https://wiki.archlinux.org/index.php/SDDM#Enable_HiDPI)

- Mount
    - edit `/etc/fstab` as [guide](https://wiki.archlinux.org/index.php/Fstab)

- Font
    - [emoji](https://wiki.archlinux.org/index.php/Font_configuration/Examples#System-wide_Noto_Emoji_fonts)
    - [win10](https://aur.archlinux.org/pkgbase/ttf-ms-win10/)
        - Download the PKGBUILD file into windows font dir `$WIN10/Windows/Fonts`
        - run `updpkgsums` to update checksums
        - remove unfounded fonts from PKGBUILD file
        - run `makepkg` to generate the package
        - run `sudo pacman -U {pkg_path}` to install them

- Swap File
    - no need

- Fcitx
    - add following to `/etc/environment`

        ```
        GTK_IM_MODULE=fcitx5
        XMODIFIERS=@im=fcitx
        QT_IM_MODULE=fcitx5
        ```

- Touchpad
    - run `sudo gpasswd -a $USER input`
    - run `libinput-gestures-setup autostart`

- Keyring
    - following [wiki](https://wiki.archlinux.org/index.php/GNOME/Keyring), add following to `/etc/pam.d/sddm`
        ```
        -auth      optional     pam_gnome_keyring.so
        -session   optional     pam_gnome_keyring.so auto_start
        ```

- KDE
    - CapsLock to Ctrl
        - go to `Input Devices->Keyboard->Advanced->Caps Lock behavior`

- Bluetooth
    - For headset, go to `multimedia->Audio and Video->Device Preference`, set headset to the prefered one

- Vim
    - open neovim, run `PlugInstall`
    - Inverse search in okular. Backward search must be set up from the viewer through `Settings > Editor > Custom Text Editor`. The following settings should work for Vim and neovim, respectively:
        ```
        vim --remote-silent %f -c %l
        nvr --remote-silent %f -c %l
        ```
