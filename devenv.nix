{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  # Environment variables (static)
  env = {
    GREET = "devenv";
    QNX_BASE = "/home/qnx800";
    QNX_HOST = "/home/qnx800/host/linux/x86_64";
    QNX_TARGET = "/home/qnx800/target/qnx";
  };

  # Packages available in the shell
  packages = [
    pkgs.git
    pkgs.gnumake
    pkgs.file
  ];

  # Enable C tooling
  languages.c.enable = true;

  # Scripts you can run
  scripts = {
    hello.exec = ''
      echo "hello from $GREET"
    '';

    qnx-env.exec = ''
      echo "QNX_BASE=$QNX_BASE"
      echo "QNX_HOST=$QNX_HOST"
      echo "QNX_TARGET=$QNX_TARGET"
      command -v qcc || echo "qcc NOT FOUND"
    '';

    build-qnx-hello.exec = ''
      set -e
      echo "Building QNX hello world…"
      qcc -Vgcc_ntoaarch64le -o hello hello.c
      file hello
    '';
  };

  # Runs automatically when you enter `devenv shell`
  enterShell = ''
    # Export QNX environment
    export PATH="$QNX_HOST/usr/bin:$PATH"
    export LD_LIBRARY_PATH="$QNX_HOST/usr/lib:$LD_LIBRARY_PATH"
    export MAKEFLAGS="-j$(nproc)"

    echo "Entering QNX devenv shell"
    hello
    qnx-env
  '';

  # Simple test to validate environment
  enterTest = ''
    echo "Running tests"
    git --version
    command -v qcc
  '';
}
