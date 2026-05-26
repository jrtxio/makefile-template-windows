# makefile-template-windows

[English](README.md) | [中文](README.zh-CN.md)

一个面向 **Windows** C/C++ 项目的层级式多模块 Makefile 模板，基于 MinGW-w64 和 Git-Bash 构建。

示例项目模拟了一个 socket 双向链表的创建和释放操作，演示了如何搭建多模块构建体系。

## 特性

- **层级式构建** — 每个源码模块拥有独立的子 Makefile，根 Makefile 负责编排调度
- **集中化配置** — 所有工具链路径、编译选项和目录设置集中在 `make_settings.mk` 中管理
- **分离输出目录** — 目标文件输出到 `Build/Obj/`，最终可执行文件输出到 `Build/Gen/`
- **VS Code 集成** — 预配置了 `launch.json`（GDB 调试）和 `tasks.json`（构建/清理）
- **可移植路径** — 全部使用正斜杠，确保 Makefile 在 Git-Bash 下正常运行

## 环境要求

| 工具 | 版本 | 用途 |
|------|------|------|
| [MinGW-w64](https://www.mingw-w64.org/) | gcc 8.1.0+ | C/C++ 编译器（`gcc.exe`、`gdb.exe`） |
| [Git for Windows](https://git-scm.com/) | 任意 | 提供 Git-Bash 运行 `make` |
| [Make](http://gnuwin32.sourceforge.net/packages/make.htm) | 3.82+ | 构建自动化（`make.exe`） |

## 快速开始

### 1. 克隆模板

```bash
git clone https://github.com/jrtxio/makefile-template-windows.git my-project
cd my-project
```

### 2. 配置工具链

编辑 `make_settings.mk`，将 `INSTALL_DIR` 设为你的 MinGW 安装路径（默认：`C:/Program Files/mingw64`）：

```makefile
INSTALL_DIR ?= C:/Program Files/mingw64
```

### 3. 构建

```bash
make all
```

### 4. 运行

```bash
./Build/Gen/main.exe
```

### 5. 清理

```bash
make clean
```

## Make 目标

| 目标 | 说明 |
|------|------|
| `all` | 创建输出目录，编译所有模块，链接并将可执行文件移至 `Build/Gen/` |
| `clean` | 清除构建输出目录中的所有 `.o` 和 `.exe` 文件 |

## 如何定制

### 添加新的源码模块

1. 在 `Source/` 下创建新目录，例如 `Source/mymodule/`
2. 在其中添加 `Makefile`，沿用 `Source/main/Makefile` 的模板：

```makefile
CFILES = $(wildcard *.c)
OBJS   = $(CFILES:%.c=%.o)

all: $(OBJS)
%.o : %.c
	@echo $(<F)
	@$(subst \,/, $(CC) $(CFLAGS) -o $(OBJ_DIR)/$(@F) -c $<)
```

3. 在 `make_settings.mk` 中注册新模块：

```makefile
APPL_SRC_DIRS = $(SRC_DIR)/main \
                $(SRC_DIR)/socket \
                $(SRC_DIR)/mymodule

APPL_INC_DIRS = $(SRC_DIR)/main \
                $(SRC_DIR)/socket \
                $(SRC_DIR)/mymodule
```

### 修改输出二进制文件名

在 `make_settings.mk` 中修改 `IMAGE_SRC`：

```makefile
IMAGE_SRC = myapp
```

### 开启/关闭调试符号

在根目录 `Makefile` 中设置 `DEBUG` 变量：

```makefile
DEBUG = 1   # 启用 -g 编译选项
DEBUG = 0   # 关闭
```

## 项目结构

```
.
├── Makefile                  # 根 Makefile — 编排构建流程
├── make_settings.mk          # 集中化构建配置
├── .vscode/
│   ├── launch.json           # GDB 调试配置
│   ├── settings.json         # 文件关联与 IntelliSense
│   └── tasks.json            # 构建与清理任务
├── Source/
│   ├── main/
│   │   ├── main.c            # 应用程序入口
│   │   └── Makefile           # 模块 Makefile
│   └── socket/
│       ├── fnet_socket.c/h   # socket 链表实现
│       ├── fnet_prot.c/h     # 协议层
│       ├── fnet_tcp.c/h      # TCP 协议处理
│       ├── fnet_socket_prv.h # socket 内部定义
│       ├── fnet_stack_config.h
│       ├── fnet_stdlib.h     # 标准库抽象层
│       └── Makefile           # 模块 Makefile
└── Build/                    # （自动生成）构建输出
    ├── Obj/                  # 编译产生的目标文件
    └── Gen/                  # 最终可执行文件
```

## VS Code 集成

- **构建**：`Ctrl+Shift+B` 执行 `make all`
- **清理**：从任务运行器中选择 "clean" 任务
- **调试**：按 `F5` 构建并使用 GDB 调试（默认在入口处断点）
