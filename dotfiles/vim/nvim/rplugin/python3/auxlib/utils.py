import os
import importlib
from pprint import pprint
from auxlib.logger import get_logger

logger = get_logger('utils')


def parse_ycm_flags(ycm_config_path):
    #  TODO(meijieru): no __pycache__
    ycm_config_path = os.path.abspath(os.path.expanduser(ycm_config_path))
    spec = importlib.util.spec_from_file_location('ycm_config', ycm_config_path)
    ycm_config = importlib.util.module_from_spec(spec)
    ycm_config_dir = os.path.dirname(ycm_config_path)
    try:
        spec.loader.exec_module(ycm_config)
        flags = ycm_config.flags
    except ModuleNotFoundError:  # try to load ycm_core
        return []

    to_abs = [flag in ['-isystem', '-I'] for flag in flags]
    res = []
    for i, flag in enumerate(flags):
        if i == 0 or (not to_abs[i - 1]):
            res.append(flag)
        else:
            res.append(os.path.abspath(os.path.join(ycm_config_dir, flag)))
    logger.debug('Parsed ycm flags: {}'.format(' '.join(res)))
    return res


if __name__ == "__main__":
    pprint(parse_ycm_flags('~/.ycm_extra_conf.py'))
