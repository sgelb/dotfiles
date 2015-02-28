#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

dotfile_folder = os.path.expanduser('~/code/dotfiles')
dotfiles = {
    # source : destination
    'gitconfig': '~/.gitconfig',
    'githelpers': '~/.githelpers',
    'gitignore': '~/.gitignore',
    'screenrc': '~/.screenrc',
    'skel': '~/.vim/skel',
    'vimrc': '~/.vimrc',
    'Xresources': '~/.Xresources',
    'xinitrc': '~/.xinitrc',
    'zshrc': '~/.zshrc',
}

ok = '\33[32m::\33[1;0m'
error = '\33[31m::\33[1;0m'


def main():
    for key, value in dotfiles.items():
        src = os.path.join(dotfile_folder, key)
        dst = os.path.expanduser(value)
        if os.path.exists(src):
            try:
                if os.path.islink(dst):
                    raise FileExistsError
                os.symlink(src, dst)
                print('{} Linked {} to {}'.format(ok, src, dst))
            except FileExistsError:
                print('{} {} already exists'.format(error, dst))
        else:
            print('{} {} does not exist'.format(error, src))


if __name__ == '__main__':
    main()

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
