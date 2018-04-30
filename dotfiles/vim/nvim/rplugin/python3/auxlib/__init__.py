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
    def wrapper(self, args):
        getattr(self._logger, func_name)(args[0])

    return wrapper


@neovim.plugin
class AuxlibHandlers(object):

    def __init__(self, vim):
        self.vim = vim

    @auxlib_function()
    def test_python(self):
        self.vim.command('echo "Hello from auxlib python"')

    @auxlib_function()
    def enable_logging(self, args):
        logging = self.vim.vars['auxlib#_logging']
        logger.setup(self.vim, logging['level'], logging['logfile'],
                     logging['overwrite'])
        self._logger = logger.WithLoggingBase(enable_logging=True, name='vim')
        self._logger.info('Setup logger for vim.')

    for func_name in [
            'debug', 'info', 'warn', 'warning', 'error', 'critical', 'fatal'
    ]:
        vars()[func_name] = log_method(func_name)

    @neovim.autocmd(
        'filetype', pattern='cpp', sync=False, eval='g:ale_cpp_clang_options')
    def set_ale_cpp_options(self, ale_cpp_global_flags):
        ycm_marker = '.ycm_extra_conf.py'
        ancestor = utils.nearest_ancestor([ycm_marker], os.getcwd())
        if ancestor:
            flags = ' '.join(
                utils.parse_ycm_flags(os.path.join(ancestor, ycm_marker)))
        else:
            if ale_cpp_global_flags:
                flags = ale_cpp_global_flags
            else:
                flags = '-std=c++11 -Wall'
        self.vim.command('let b:ale_cpp_clang_options = "{}"'.format(flags))
