# 老旧小区电梯故障报修与维保跟踪平台 — 小程序端

面向业主、物业、维修员三类角色的 uni-app 小程序，管理员使用 `admin-web` 管理端。

## 技术栈

- uni-app 3 + Vue 3 + Pinia
- 目标平台：微信小程序、H5

## 目录结构

```
uniapp-app/
├── package.json
├── vite.config.js
└── src/
    ├── main.js              入口
    ├── App.vue              全局样式
    ├── pages.json           页面路由与 tabBar 配置
    ├── manifest.json        应用配置
    ├── api/                 接口封装，按业务模块分文件
    │   ├── auth.js          登录注册与级联查询
    │   ├── repair.js        报修与进度
    │   ├── order.js         派单、接单、维修过程、异常
    │   ├── maintain.js      维保计划、巡检、档案
    │   └── analysis.js      统计、预警、健康档案、站内通知
    ├── store/
    │   └── user.js          登录态管理
    └── utils/
        ├── request.js       请求封装，token 注入与登录失效跳转
        └── dict.js          状态文案与字典映射
```

## 角色与页面

| 角色 | 页面 |
| --- | --- |
| 公共 | 登录、注册、个人中心、消息中心 |
| 业主 | 首页、我要报修、报修进度列表、报修详情 |
| 物业 | 首页、待派单池、派单、报修工单、维保计划、工单异常、统计分析 |
| 维修员 | 首页、待接单、在办工单、维修过程、巡检任务、巡检执行 |

登录后由首页按 `userStore.roleKey` 展示对应角色的功能入口。

## 运行

```bash
# 安装依赖
npm install

# H5 调试，默认端口 8090，接口经 /dev-api 代理到后端 8080
npm run dev:h5

# 微信小程序，产物在 dist/dev/mp-weixin，用微信开发者工具导入
npm run dev:mp-weixin

# 构建
npm run build:h5
npm run build:mp-weixin
```

## 与后端的接口约定

- 请求头 `Authorization` 携带 JWT 令牌，值不带 `Bearer` 前缀
- 返回值统一为 `{ code, msg, data }`，分页为 `{ code, msg, rows, total }`
- 401 时自动清空登录态并跳转登录页
- 文件上传走 `/common/file/upload`，业务类型见各模块 api 文件中的 `*_BIZ_TYPE` 常量
