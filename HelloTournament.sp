#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>

//引入外部插件
#include "HelloTournament/Tournament_CommonSetting.inc"

//关联变量
ConVar g_WarmUpCfgCvar;

//全局变量
GameState g_GameState = GameState_None;


//插件基本信息
public Plugin:myinfo = 
{
	name = "CNCS锦标赛插件",
	author = "东方怂天",
	description = "CNCS锦标赛插件",
	version = "1.0",
	url = "www.easternday.cn"
}

//插件开始工作
public OnPluginStart()
{
	//加载翻译
	LoadTranslations("common.phrases");
	LoadTranslations("core.phrases");
	
	//Cmd指令监听
	RegServerCmd("WarmUp", Command_WarmUp, "【比赛前热身】");
  	g_WarmUpCfgCvar = CreateConVar("HT_cfg_warmup", "sourcemod/HelloTournament/WarmUp.cfg", "游戏开始前的热身时间设置; 文件应该放在 csgo/cfg directory 下。");
}


//开始准备比赛
stock Action Command_WarmUp(int args) {
	ChangeState(GameState_Warmup);
	ExecCfg(g_WarmUpCfgCvar);
	StartWarmUp(true);
    return Plugin_Handled;
	/*
    //重置两边票数为0
    FriendFireVote[0] = 0;
    FriendFireVote[1] = 0;
    //开启菜单
	for (int i = 1; i <= MaxClients; i++) {
		if (IsPlayer(i)) {
            Menu menu = new Menu(FriendlyFireVote);
            SetMenuExitButton(menu, false);
            SetMenuTitle(menu, "【是否开启友军伤害】");
            AddMenuItem(menu, "开启", "开启");
            AddMenuItem(menu, "关闭", "关闭");
            DisplayMenu(menu, i, MENU_TIME_FOREVER);
		}
	}
	*/
}

//改变游戏状态
public void ChangeState(GameState state) {
	PrintToChatAll("游戏状态改变： %d -> %d", g_GameState, state);
  	//TODO 这块代码有空研究一下，pugsetup.sp
  	//Call_StartForward(g_hOnStateChange);
  	//Call_PushCell(g_GameState);
  	//Call_PushCell(state);
  	//Call_Finish();
  	g_GameState = state;
}

//释放cfg文件
public void ExecCfg(ConVar cvar) {
  	char cfg[PLATFORM_MAX_PATH];
  	cvar.GetString(cfg, sizeof(cfg));

  	// for files that start with configs/pugsetup/* we just
  	// read the file and execute each command individually,
  	// otherwise we assume the file is in the cfg/ directory and
  	// just use the game's exec command.
	ServerCommand("exec \"%s\"", cfg);
}

//当有物品丢弃时
public Action CS_OnCSWeaponDrop(int client, int weapon)
{
	//如果是在热身
	if(g_GameState == GameState_Warmup)
    {
		AcceptEntityInput(weapon, "Kill");
		RemoveEntity(weapon);
	}

    return Plugin_Continue;
}