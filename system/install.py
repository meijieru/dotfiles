import sys
import yaml
import subprocess


class bcolors(object):
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

    def disable(self):
        self.HEADER = ''
        self.OKBLUE = ''
        self.OKGREEN = ''
        self.WARNING = ''
        self.FAIL = ''
        self.ENDC = ''

    @staticmethod
    def print_ok(msg):
        print(bcolors.OKGREEN + '[INFO] {}'.format(msg) + bcolors.ENDC)


if __name__ == "__main__":
    with open(sys.argv[1], 'r') as f:
        data = yaml.load(f)

    if 'pacman' in data:
        pkg_list = data['pacman']
        pattern = 'yay -S --noconfirm {}'
    elif 'pacaur' in data:
        pkg_list = data['pacaur']
        pattern = 'sudo pacman -S --noconfirm {}'
    else:
        raise ValueError()

    for pkg in pkg_list:
        command = pattern.format(pkg)
        bcolors.print_ok('[INFO] {}'.format(command))
        subprocess.call(command, shell=True)
