import os
import neovim
from auxlib import utils
from auxlib import logger

func_name_template = 'Auxlib_{}'


def auxlib_function(*args, **kwargs):

    def wrapper(func):
        return neovim.function(
            func_name_template.format(func.__name__), *args, **kwargs)(func)

    return wrapper


def log_method(func_name):

    @neovim.function(func_name_template.format(func_name))
    def wrapper(self, *args, **kwargs):
        fun = getattr(self._logger, func_name, None)
        if fun:
            fun(*args, **kwargs)

    return wrapper


@neovim.plugin
class AuxlibHandlers(object):

    def __init__(self, vim):
        self.vim = vim  # type: neovim.Nvim
        self._logger = None

    @auxlib_function()
    def test_python(self, *args):
        self.vim.command('echo "Hello from auxlib python"')

    @auxlib_function()
    def enable_logging(self, *args):
        logging = self.vim.vars['auxlib#_logging']
        logger.setup(self.vim, logging['level'], logging['logfile'],
                     logging['overwrite'])
        self._logger = logger.WithLoggingBase(enable_logging=True, name='vim')
        self._logger.info('Setup logger for vim.')

    for func_name in [
            'debug', 'info', 'warn', 'warning', 'error', 'critical', 'fatal'
    ]:
        vars()[func_name] = log_method(func_name)

    @neovim.autocmd('filetype', pattern='cpp', sync=False, eval='@%')
    def set_ale_cpp_options(self, buf_name):
        if 'ycm' not in self.vim.vars['bundle_groups']:
            return
        ycm_marker = '.ycm_extra_conf.py'
        file_path = os.path.join(os.getcwd(), buf_name)
        file_dir = os.path.dirname(os.path.abspath(file_path))
        ancestor = utils.nearest_ancestor([ycm_marker], file_dir)
        if ancestor:
            ycm_config_path = os.path.join(ancestor, ycm_marker)
            self.info('Ycm config path: {}'.format(ycm_config_path))
            flags = ' '.join(
                utils.parse_ycm_flags(ycm_config_path))
            if len(flags) > 0:
                self.vim.current.buffer.vars['ale_cpp_clang_options'] = flags
                self.info('Set ale flag: {}'.format(flags))
