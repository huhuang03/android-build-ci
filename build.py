# build template to real files
from pathlib import Path


def build():
    root_dir = Path(__file__).parent
    packages_path = root_dir / 'packages.txt'
    packages = [line for line in packages_path.read_text(encoding='utf-8').splitlines() if not not line]
    install_command_list = [_install_command(p) for p in packages]
    install_command = '\n'.join(install_command_list)
    src_content = (root_dir / 'Dockerfile.template').read()
    dst_content = src_content.replace('__INSTALL_PACKAGES__', install_command)
    (root_dir / 'Dockerfile').write_text(dst_content)


def _install_command(pkg: str) -> str:
    return f'sdk manager "{pkg}"'


if __name__ == '__main__':
    build()
