import sys
import logging
from functools import wraps

LOG_FORMAT = '%(asctime)s [%(levelname)-5.5s] [%(process)d] (%(name)s) %(message)s'

is_init = False
root = logging.getLogger('auxlib')
root.propagate = False


def get_logger(name):
    """Get a logger that is a child of the 'root' logger."""
    return root.getChild(name)


def setup(vim, level, output_file=None, overwrite=0):
    """Setup logging for Auxlib."""
    global is_init
    if is_init:
        vim.command('echo "auxlib logger already set!!"')
        get_logger('logging').info('Try to initialize again.')
        return
    is_init = True

    if output_file:
        formatter = logging.Formatter(LOG_FORMAT)
        handler = logging.FileHandler(
            filename=output_file, mode=('w' if overwrite else 'a'))
        handler.setFormatter(formatter)
        root.addHandler(handler)

        level = str(level).upper()
        if level not in ('DEBUG', 'INFO', 'WARN', 'WARNING', 'ERROR',
                         'CRITICAL', 'FATAL'):
            level = 'DEBUG'
        root.setLevel(getattr(logging, level))

        try:
            import pkg_resources

            neovim_version = pkg_resources.get_distribution('pynvim').version
        except ImportError:
            neovim_version = 'unknown'

        log = get_logger('logging')
        log.info('--- Auxlib Log Start ---')
        log.info('%s, Python %s, neovim client %s',
                 vim.call('auxlib#utils#neovim_version'), '.'.join(
                     map(str, sys.version_info[:3])), neovim_version)

        if not vim.vars.get('auxlib#_logging_notified'):
            vim.vars['auxlib#_logging_notified'] = 1


def logmethod(func):
    """Decorator for setting up the logger in WithLoggingBase subclasses.

    This does not guarantee that log messages will be generated.  If
    `WithLoggingBase._is_logging_enabled` is True, it will be propagated up to
    the root 'auxlib' logger.
    """

    @wraps(func)
    def wrapper(self, *args, **kwargs):
        if not is_init or not self._is_logging_enabled:
            return
        if self._logger is None:
            self._logger = get_logger(self._name)
        return func(self, *args, **kwargs)

    return wrapper


class WithLoggingBase(object):
    """Class that adds logging functions to a subclass."""

    def __init__(self, enable_logging=True, name=None):
        self._name = name if name else 'unknown'
        self._is_logging_enabled = True
        self._logger = None  # type: logging.Logger

    @logmethod
    def debug(self, msg, *args, **kwargs):
        self._logger.debug(msg, *args, **kwargs)

    @logmethod
    def info(self, msg, *args, **kwargs):
        self._logger.info(msg, *args, **kwargs)

    @logmethod
    def warning(self, msg, *args, **kwargs):
        self._logger.warning(msg, *args, **kwargs)

    warn = warning

    @logmethod
    def error(self, msg, *args, **kwargs):
        self._logger.error(msg, *args, **kwargs)

    @logmethod
    def exception(self, msg, *args, **kwargs):
        # This will not produce a log message if there is no exception to log.
        self._logger.exception(msg, *args, **kwargs)

    @logmethod
    def critical(self, msg, *args, **kwargs):
        self._logger.critical(msg, *args, **kwargs)

    fatal = critical
