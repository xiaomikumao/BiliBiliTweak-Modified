# 无 Mac 编译 BiliBiliTweak 指南

由于你没有 macOS 电脑，这里提供几个可行的方案来编译这个 iOS 越狱插件。

## 方案对比

| 方案 | 难度 | 成本 | 推荐度 |
|------|------|------|--------|
| 使用 Codespaces | ⭐⭐ | 免费额度 | ⭐⭐⭐⭐⭐ |
| 使用在线 Mac 云服务 | ⭐⭐⭐ | 付费 | ⭐⭐⭐ |
| 寻求社区帮助 | ⭐ | 免费 | ⭐⭐⭐⭐ |
| 使用 Docker 编译 | ⭐⭐⭐⭐ | 免费 | ⭐⭐ |

---

## 方案 1：使用 GitHub Codespaces（推荐）

GitHub Codespaces 提供免费的云端开发环境，虽然是基于 Linux 的，但我们可以安装 Theos 来编译。

### 步骤：

1. **Fork 这个项目到你的 GitHub**
   - 访问 https://github.com/TouchFriend/BiliBiliTweak
   - 点击右上角的 "Fork" 按钮

2. **创建 Codespace**
   - 在你的 fork 仓库页面
   - 点击 "Code" 按钮 → "Codespaces" → "Create codespace on main"

3. **在 Codespace 中编译**
   ```bash
   # 安装 Theos
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"
   
   # 设置环境变量
   echo 'export THEOS=~/theos' >> ~/.bashrc
   echo 'export PATH=$THEOS/bin:$PATH' >> ~/.bashrc
   source ~/.bashrc
   
   # 安装依赖
   sudo apt-get update
   sudo apt-get install -y build-essential git curl
   
   # 编译项目
   cd /workspaces/BiliBiliTweak
   make clean
   make package
   ```

4. **下载编译产物**
   - 编译成功后，在 `packages/` 目录下会生成 `.deb` 文件
   - 从 VS Code 左侧文件浏览器下载

**优点：** 免费、简单、不需要本地配置  
**缺点：** 需要 GitHub 账号、编译可能较慢

---

## 方案 2：使用在线 Mac 云服务

如果你愿意花费少量费用，可以租用云 Mac 服务。

### 推荐服务商：

1. **MacStadium**
   - 网址：https://www.macstadium.com/
   - 提供远程 Mac 访问

2. **XcodeClub**
   - 网址：https://xcodeclub.com/
   - 专门用于编译 iOS 应用

3. **AWS Mac 实例**
   - Amazon 提供的 Mac 云实例
   - 按小时计费

**步骤：**
1. 注册并租用 Mac 实例
2. 远程连接到 Mac
3. 安装 Xcode 和 MonkeyDev
4. 编译项目
5. 下载编译产物

**优点：** 编译速度快、环境完整  
**缺点：** 需要付费

---

## 方案 3：寻求社区帮助（最简单）

你可以在 iOS 越狱社区寻求帮助，让人帮你编译。

### 推荐社区：

1. **Reddit**
   - r/jailbreak
   - r/iOSProgramming

2. **Discord 社区**
   - r/jailbreak 的 Discord 服务器
   - Theos 开发群

3. **中文社区**
   - 威锋技术组
   - iOS 逆向论坛

**步骤：**
1. 注册社区账号
2. 发帖说明需求
3. 提供修改后的源代码
4. 请人帮忙编译
5. 分享编译产物（对其他人也有帮助）

**优点：** 最简单、免费  
**缺点：** 需要等待他人帮助

---

## 方案 4：使用 Docker 编译（高级）

你可以使用 Docker 容器来搭建 Theos 编译环境。

### 步骤：

1. **安装 Docker**
   - Windows: https://www.docker.com/products/docker-desktop
   - 安装后启动 Docker

2. **拉取 Theos Docker 镜像**
   ```bash
   docker pull nygard/theos
   ```

3. **运行容器并编译**
   ```bash
   # 进入项目目录
   cd BiliBiliTweak-main
   
   # 运行 Docker 容器
   docker run -it --rm -v ${PWD}:/project nygard/theos /bin/bash
   
   # 在容器内编译
   cd /project
   make clean
   make package
   
   # 退出容器
   exit
   ```

4. **获取编译产物**
   - 编译成功后，文件会在项目目录下生成

**优点：** 免费、可重复利用  
**缺点：** 需要学习 Docker、配置复杂

---

## 我的推荐

### 如果你是新手：
**方案 3（寻求社区帮助）** → 最简单，发个帖子等别人帮忙

### 如果你有一定技术基础：
**方案 1（GitHub Codespaces）** → 免费且相对简单

### 如果你经常需要编译 iOS 插件：
**方案 2（在线 Mac 云服务）** → 一次配置，长期使用

---

## 快速开始：使用 GitHub Codespaces

我为你准备了一个详细的步骤：

### 1. Fork 仓库
访问 https://github.com/TouchFriend/BiliBiliTweak，点击 Fork

### 2. 开启 Codespace
在你的 fork 页面，点击 Code → Codespaces → Create codespace

### 3. 运行编译脚本
我在项目中添加了一个自动编译脚本，直接运行：

```bash
cd /workspaces/BiliBiliTweak
bash build_in_codespace.sh
```

### 4. 下载产物
编译完成后，在文件浏览器中找到 `.deb` 文件，右键下载

---

## 常见问题

### Q: GitHub Codespaces 免费吗？
A: 是的，提供 60 小时的免费使用时间/月。

### Q: 编译需要多长时间？
A: 通常在 10-30 分钟左右。

### Q: 编译失败怎么办？
A: 检查错误信息，可能需要安装额外的依赖。也可以在社区寻求帮助。

### Q: 我可以直接使用原版插件吗？
A: 可以，但原版会隐藏人数和礼物特效。如果你需要这些功能，必须编译修改版。

---

## 联系我

如果你在编译过程中遇到问题，可以：
1. 查看项目的 Issues 页面
2. 在社区发帖求助
3. 或联系我获取更多帮助

祝你编译成功！🎉
