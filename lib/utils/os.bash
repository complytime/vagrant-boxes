#!/usr/bin/env bash

function os__name() {
  case "$(uname -s)" in
    Darwin)
      echo 'Darwin'
      ;;
    Linux)
      echo 'Linux'
      ;;
    *)
      fail "if not darwin or linux, then we don't support it..."
      ;;
  esac
}

export OS_NAME="$(os__name)"

function arch__name(){
  case "$(uname -m)" in
    arm64)
      echo 'arm64'
      ;;
    x86_64)
      echo 'amd64'
      ;;
    *)
      fail "if not arm64 or amd64, then we don't support it..."
      ;;
  esac
}

export ARCH="$(arch__name)"