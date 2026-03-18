# Server Bootstrap

一键配置 Ubuntu 服务器开发环境的自动化脚本。

## 功能

- 自动安装常用开发工具（git, vim, tmux, jq, ripgrep 等）
- 配置 APT 阿里云镜像源加速下载
- 部署个人配置文件（.bashrc, .tmux.conf, .vimrc）

## 使用方法

### 1. 下载到服务器

**方法一：直接克隆**
```bash
git clone https://github.com/cmy-hhxx/server_bootstrap.git
cd server-bootstrap
```

**方法二：手动上传（推荐）**
```bash
# 本地下载
# https://github.com/cmy-hhxx/server_bootstrap/archive/refs/heads/main.zip

# 上传到服务器
scp server_bootstrap-main.zip user@server:/tmp/
ssh user@server
cd /tmp && unzip server_bootstrap-main.zip && cd server_bootstrap-main
```

### 2. 执行安装

```bash
chmod +x setup.sh
./setup.sh
```

### 3. 重启终端

```bash
source ~/.bashrc
```

## 安装内容

**开发工具**
- git, curl, wget, vim, tmux, build-essential, jq, ripgrep

**配置文件**
- .bashrc, .tmux.conf, .vimrc

## 系统要求

- Ubuntu 18.04+ (推荐 20.04/22.04)
- x86_64 架构
- sudo 权限

## 许可证

MIT License
