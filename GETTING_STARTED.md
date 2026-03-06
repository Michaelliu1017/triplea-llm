# TripleA-LLM：基于 gpt-4o-mini 的 TripleA Wargame 游戏


## 项目部署（本地跑 GPT 对战 Bot）


### 1.1 环境准备

| 需要 | 说明 |
|------|------|
| **Java JDK 17+** | 用于跑 TripleA Host 和 Bridge。 |
| **Python 3.10+** | 用于跑 GPT 驱动脚本。 |
| **OpenAI API Key** | 在 [OpenAI](https://platform.openai.com) 获取，用于调用 gpt-4o-mini。 |

### 1.2 下载项目

```bash
git clone https://github.com/Michaelliu1017/triplea-llm
cd triplea-llm
```

### 1.3 启动顺序（开三个终端页面）

#### 终端 1：启动 Host（TripleA GUI）

```bash
cd triplea-llm
./gradlew :game-app:game-headed:run
```

- 等待 GUI 打开后：
  - **Play** → **Host a game**（或等效入口）。
  - 选地图，例如 **Pacific 40**（或任意支持多方的图）。
  - **玩家设置**：**日本** 设为 **Human** 并取消选择前边的checkbox，**其他所有玩家**设为 **AI**（Bot）或 **Human**。
  - 记下 **端口** 选择 3301，**不要设密码**。
  - 进入 **等待玩家** 界面，**先不要点「开始游戏」**。

#### 终端 2：启动 Bridge

```bash
cd triplea-llm
./gradlew :game-app:game-bridge:run --args="--host 127.0.0.1 --port 3301 --name Bot_Yamamoto_Isoroku --take Japanese"
```

- `--port 3301` 要和 Host 里显示的端口一致。
- `--take Japanese` 要和**地图里日本方的名字**一致（有的图是 `Japanese`，有的是 `Japan`，在 Host 选人界面能看到）。
- 看到 Bot加入游戏后即可开始，点击 **「开始游戏」**。

#### 终端 3：启动 GPT 驱动

```bash
cd triplea-llm/clients/python
export OPENAI_API_KEY=sk-你的OpenAI密钥
./run_auto.sh --rules-file rules_zh.txt
```

- 第一次运行会自动建 `.venv` 并装 `openai`。
- 之后 GPT 会持续替日本做决策（购买、部署、移动、进攻等），直到你按 **Ctrl+C** 或对局结束。
- 复制你的密钥：https://platform.openai.com/settings/organization/api-keys

这样就是：**GPT 控制日本 vs 其他 Bot**，在本地完成对战。

### 1.4 一键命令汇总

假设仓库已克隆到 `triplea-llm`，在**项目根**执行：

| 终端 | 命令 |
|------|------|
| **1 - Host** | `./gradlew :game-app:game-headed:run` → 在 GUI 建房间、其他玩家选 AI、日本留给人/网络、记端口、等连接 |
| **2 - Bridge** | `./gradlew :game-app:game-bridge:run --args="--host 127.0.0.1 --port 3301 --name Bot_Bridge --take Japanese"` |
| **3 - GPT** | `cd clients/python && export OPENAI_API_KEY=sk-你的key && ./run_auto.sh --rules-file rules_zh.txt` |

### 1.5 常见问题

- **Bridge 连不上 / 没有「开始游戏」**：确认 Host 已到等待玩家界面，端口、无密码，再启动 Bridge。
- **一直提示「当前不是日本回合」**：注意你的启动顺序，先启动host，再连接bridge。
- **GET /state 报错或超时**：确认 Host 已点「开始游戏」，且 Bridge 终端里已打印 "Bridge connected"。
- 更多见：`clients/python/排查「不是日本回合」.md`、`clients/python/项目实现与部署说明.md`。

---

## 小结

- **你要发布**：按 **一** 在 GitHub 建仓库 `triplea-llm`，在项目根 `git init` → `add` → `commit` → `remote` → `push`。
- **别人要本地跑 GPT 对 Bot**：按 **二** 克隆 → 装好 Java / Python / API Key → 依次开 Host（其他玩家选 AI）→ Bridge（接管日本）→ GPT Driver（`run_auto.sh`）。

更细的部署与原理见：**clients/python/README.md**、**clients/python/项目实现与部署说明.md**。
