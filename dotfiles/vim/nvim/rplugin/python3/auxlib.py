import neovim


@neovim.plugin
class Main(object):

    def __init__(self, vim):
        self.vim = vim

    @neovim.function('TestPython')
    def test_python(self, args):
        self.vim.command('echo "hello from TestPython"')
