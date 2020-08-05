## Common

```sh
# First setting up onedrive
export ROAMING_DIR='{Onedrive-JHU}/settings/win10'
```


### Uninstall unneccesary apps

- Cortana
- 电影与电视
- 3D查看器
- OneNote for win10


### Apps from win store

- Windows Terminal
    - Config file `${ROAMING_DIR}/windows_terminal/settings.json`
    - Use soft link
    - **TODO**
- X410
    - Will deprecate once wsl2 GUI is supported
- Ditto
    - **TODO**
- Snipaste
- Skype

Optional
- GestureSign
- 弹弹play
- Pulse Secure
    - **Currently not able to connect to school vpn**


### Apps from website

- [VSCode](TODO)
- [Chrome](TODO)
- [SharpKeys](https://download.cnet.com/SharpKeys/3000-2094_4-75803009.html)
    - Exchange `CapsLock` with `Left control`.
    - Load settings from `${ROAMING_DIR}/sharpkeys/win10_keyboard.skl`
- [AutoHotKey](TODO)
    - TODO
- [Everything](TODO)
- [Adobe PDF Reader](TODO)
- [Faststone Image Viewer](http://www.faststone.org/)
- [Bandzip](https://www.bandisoft.com/bandizip/old/6/)
- [DisplayCal](https://displaycal.net/#download)
- [Dropbox](https://www.dropbox.com/)
- [Free Download Manager](https://www.freedownloadmanager.org/zh/download.htm)
- [Huorong](https://www.huorong.cn/person5.html)
- [Ivacy](TODO)
- [PotPlayer](TODO)
- [Pulse Secure](TODO)
- [TeamViewer](TODO)
- [TIM](TODO)
- [Wechat](TODO)
- [WizNote](TODO)
- [Zoom](TODO)
- [Office](TODO)

Optional
- [Lightroom](https://www.weidown.com/xiazai/5606.html)
- [EasyCanvas](http://www.easynlight.com/)
- [MacType](TODO)
- [Mathpix Snipping Tool](TODO)
- [QQ Music](TODO)
- [SFTP Net Drive](TODO)
- [Slack](TODO)
- [Feishu](TODO)
- [BaiduNetDisk](TODO)

### StartUp

TODO

### WSL

```sh
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

TODO
