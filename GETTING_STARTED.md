# TripleA-LLM：从发布到本地 GPT 对 Bot 对战

本文分两部分：**一、你如何把项目放到 GitHub**；**二、别人下载后如何在本地跑 GPT 与 Bot 对战**。

---

## 一、把项目放到 GitHub 仓库

### 1.1 在 GitHub 上建仓库

1. 打开 [GitHub](https://github.com) 并登录。
2. 右上角 **New repository**。
3. **Repository name** 填：`triplea-llm`。
4. 选 **Public**，**不要**勾选 "Add a README"（用本地的）。
5. 点 **Create repository**，记下地址，例如：  
   `https://github.com/你的用户名/triplea-llm.git`

### 1.2 在本地项目根目录执行（有 Git 时）

在**项目根目录**（能看到 `build.gradle`、`clients`、`game-app` 的目录）打开终端：

```bash
git init
git add .
git status
git commit -m "Add TripleA-LLM: GPT-driven TripleA wargame"
git remote add origin https://github.com/你的用户名/triplea-llm.git
git branch -M main
git push -u origin main
```

把 `你的用户名` 换成你的 GitHub 用户名。若提示要登录，按 GitHub 的 HTTPS 或 SSH 方式认证即可。

### 1.3 注意

- 不要提交 `OPENAI_API_KEY` 或任何密钥。
- `.gitignore` 已忽略 `build/`、`.gradle/`、`clients/python/.venv/` 等，一般无需改。

---

## 二、别人下载后如何部署（本地跑 GPT 对 Bot）

别人克隆你的仓库后，按下面步骤可在**本机**跑起来：**GPT 控制日本 vs 其他 Bot（AI）**。

### 2.1 环境准备

| 需要 | 说明 |
|------|------|
| **Java JDK 17+** | 用于跑 TripleA Host 和 Bridge。 |
| **Python 3.10+** | 用于跑 GPT 驱动脚本。 |
| **OpenAI API Key** | 在 [OpenAI](https://platform.openai.com) 获取，用于调用 gpt-4o-mini。 |

### 2.2 下载项目

```bash
git clone https://github.com/你的用户名/triplea-llm.git
cd triplea-llm
```

### 2.3 启动顺序（开三个终端）

#### 终端 1：启动 Host（TripleA GUI）

```bash
cd triplea-llm
./gradlew :game-app:game-headed:run
```

- 等待 GUI 打开后：
  - **Play** → **Host a game**（或等效入口）。
  - 选地图，例如 **Pacific 40**（或任意支持多方的图）。
  - **玩家设置**：**日本（Japan/Japanese）** 设为 **Human** 或 **Network**（由“玩家”连接），**其他所有玩家**设为 **AI**（Bot）。
  - 记下 **端口**（如 3300），**不要设密码**。
  - 进入 **等待玩家** 界面，**先不要点「开始游戏」**。

#### 终端 2：启动 Bridge（接管日本）

```bash
cd triplea-llm
./gradlew :game-app:game-bridge:run --args="--host 127.0.0.1 --port 3300 --name Bot_Bridge --take Japanese"
```

- `--port 3300` 要和 Host 里显示的端口一致。
- `--take Japanese` 要和**地图里日本方的名字**一致（有的图是 `Japanese`，有的是 `Japan`，在 Host 选人界面能看到）。
- 看到 **"Bridge connected and took player"** 和 **"Bridge HTTP server listening on port 8081"** 后，回到 **Host 窗口**，点击 **「开始游戏」**。

#### 终端 3：启动 GPT 驱动（让 GPT 下日本）

```bash
cd triplea-llm/clients/python
export OPENAI_API_KEY=sk-你的OpenAI密钥
./run_auto.sh --rules-file rules_zh.txt
```

- 第一次运行会自动建 `.venv` 并装 `openai`。
- 之后 GPT 会持续替日本做决策（购买、部署、移动、进攻等），直到你按 **Ctrl+C** 或对局结束。

这样就是：**GPT 控制日本 vs 其他 Bot**，在本地完成对战。

### 2.4 一键命令汇总（别人复制用）

假设仓库已克隆到 `triplea-llm`，在**项目根**执行：

| 终端 | 命令 |
|------|------|
| **1 - Host** | `./gradlew :game-app:game-headed:run` → 在 GUI 建房间、其他玩家选 AI、日本留给人/网络、记端口、等连接 |
| **2 - Bridge** | `./gradlew :game-app:game-bridge:run --args="--host 127.0.0.1 --port 3300 --name Bot_Bridge --take Japanese"` |
| **3 - GPT** | `cd clients/python && export OPENAI_API_KEY=sk-你的key && ./run_auto.sh --rules-file rules_zh.txt` |

### 2.5 常见问题（别人可能遇到）

- **Bridge 连不上 / 没有「开始游戏」**：确认 Host 已到等待玩家界面，端口、无密码，再启动 Bridge。
- **一直提示「当前不是日本回合」**：把 Bridge 的 `--take` 改成地图里日本方的**准确名字**（如 `Japanese` 或 `Japan`）。
- **GET /state 报错或超时**：确认 Host 已点「开始游戏」，且 Bridge 终端里已打印 "Bridge connected"。
- 更多见：`clients/python/排查「不是日本回合」.md`、`clients/python/项目实现与部署说明.md`。

---

## 小结

- **你要发布**：按 **一** 在 GitHub 建仓库 `triplea-llm`，在项目根 `git init` → `add` → `commit` → `remote` → `push`。
- **别人要本地跑 GPT 对 Bot**：按 **二** 克隆 → 装好 Java / Python / API Key → 依次开 Host（其他玩家选 AI）→ Bridge（接管日本）→ GPT Driver（`run_auto.sh`）。

更细的部署与原理见：**clients/python/README.md**、**clients/python/项目实现与部署说明.md**。
