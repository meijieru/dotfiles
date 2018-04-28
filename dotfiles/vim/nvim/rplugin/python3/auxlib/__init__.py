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

    @auxlib_function(sync=True)
    def parse_ycm_flags(self, args):
        return ' '.join(utils.parse_ycm_flags(args[0]))

    @neovim.autocmd('filetype', pattern='cpp', allow_nested=False, sync=True)
    def set_ale_cpp_options(self):
        self.vim.command('echo "cpp autocmd"')
