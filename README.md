# Server Bootstrap

一键配置 Ubuntu 服务器开发环境的自动化脚本。

## 功能特性

- 🚀 自动安装常用开发工具（git, vim, tmux, jq, ripgrep 等）
- 📝 部署个人配置文件（bashrc, tmux.conf, vimrc）
- 🔧 使用国内镜像源加速安装
- ⚡ 一键完成所有配置，快速启动开发环境

## 快速开始

### 0. 网络不通时的解决方案 ⚠️

如果服务器无法访问 GitHub，使用以下任一方法：

**方法一：使用 GitHub 加速服务**
```bash
# 使用 ghproxy 加速
git clone https://ghproxy.com/https://github.com/cmy-hhxx/server_bootstrap.git

# 或使用 fastgit
git clone https://hub.fastgit.xyz/cmy-hhxx/server_bootstrap.git
```

**方法二：手动下载并上传（推荐）**
```bash
# 在本地电脑下载 zip 包
# https://github.com/cmy-hhxx/server_bootstrap/archive/refs/heads/main.zip

# 上传到服务器
scp server_bootstrap-main.zip user@server:/tmp/

# 在服务器上解压
cd /tmp
unzip server_bootstrap-main.zip
mv server_bootstrap-main server-bootstrap
cd server-bootstrap
```

**方法三：使用 Gitee 镜像（如果已同步）**
```bash
git clone https://gitee.com/your-username/server_bootstrap.git
```

### 1. 克隆仓库

如果服务器网络正常：

```bash
git clone https://github.com/cmy-hhxx/server_bootstrap.git
cd server-bootstrap
```

### 2. 配置

复制配置模板并编辑：

```bash
cp config.example.sh config.sh
vim config.sh
```

可选项：
- `GIT_USER_NAME` / `GIT_USER_EMAIL`: Git 用户信息
- `APT_MIRROR`: APT 镜像源（aliyun 或 tsinghua）

### 3. 运行安装脚本

```bash
chmod +x setup.sh
./setup.sh
```

### 4. 重启终端

```bash
# 或者重新加载配置
source ~/.bashrc
```

## 安装内容

### 基础工具
- **git**: 版本控制
- **curl / wget**: 下载工具
- **vim**: 文本编辑器
- **tmux**: 终端复用器
- **build-essential**: 编译工具链
- **jq**: JSON 处理工具
- **ripgrep**: 高性能文本搜索

### 配置文件
- `.bashrc`: Bash 配置
- `.tmux.conf`: Tmux 配置
- `.vimrc`: Vim 配置

## 目录结构

```
server-bootstrap/
├── README.md              # 本文件
├── setup.sh               # 主安装脚本
├── config.example.sh      # 配置模板
├── dotfiles/              # 配置文件
│   ├── bashrc
│   ├── tmux.conf
│   └── vimrc
└── scripts/               # 模块化安装脚本
    └── install-basics.sh  # 基础工具安装
```

## 常见问题

### Q: 服务器无法访问 GitHub 怎么办？

A: 这是最常见的问题，有三种解决方案：

**最简单：手动下载上传**
1. 在本地浏览器访问：https://github.com/cmy-hhxx/server_bootstrap/archive/refs/heads/main.zip
2. 下载 zip 文件
3. 使用 scp 上传到服务器：`scp server_bootstrap-main.zip user@server:/tmp/`
4. 在服务器解压：`unzip server_bootstrap-main.zip && cd server_bootstrap-main`

**使用加速服务：**
```bash
git clone https://ghproxy.com/https://github.com/cmy-hhxx/server_bootstrap.git
```

**同步到 Gitee：**
在 Gitee 创建仓库并同步，然后使用 Gitee 地址克隆

### Q: 如何更换 APT 镜像源？

A: 在 `config.sh` 中设置：

```bash
APT_MIRROR="aliyun"    # 阿里云镜像
# 或
APT_MIRROR="tsinghua"  # 清华镜像
```

### Q: 安装失败怎么办？

A: 脚本设计为允许部分失败，可以：

1. 查看错误信息
2. 手动运行失败的模块脚本：
   ```bash
   bash scripts/install-basics.sh
   ```
3. 检查日志输出定位问题

## 后续步骤

安装完成后，你可以根据需要安装其他工具：

- **Claude Code**: [官方文档](https://docs.anthropic.com/en/docs/claude-code)
- **Codex**: [GitHub 仓库](https://github.com/anthropics/codex)
- **代理工具**: 根据需要自行配置网络代理
- **其他开发工具**: 根据需要自行安装

## 网络配置建议

如果服务器需要访问国外网络，建议：

1. **使用其他代理方案**：根据你的实际情况选择合适的代理工具
2. **配置环境变量**：在 `~/.bashrc` 中设置代理环境变量
3. **测试连接**：使用 `curl -I https://google.com` 测试网络连通性

## 系统要求

- **操作系统**: Ubuntu 18.04+（推荐 20.04 或 22.04）
- **架构**: x86_64 (amd64)
- **权限**: sudo 权限
- **磁盘空间**: 至少 500MB 可用空间

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！
