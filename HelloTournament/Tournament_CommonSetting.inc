// 游戏状态
enum GameState
{
    GameState_None,       // 还没有任何状态
    GameState_Warmup,     // 热身状态
    GameState_GetReady,   //所准备状态
    GameState_KnifeRound, //刀战
    GameState_MatchOn     //正常比赛
};

//开始热身
stock void StartWarmUp(bool indefiniteWarmup = true, int warmupTime = 60) {
	//服务器无限热身
	ServerCommand("mp_do_warmup_period 1");
    ServerCommand("mp_warmuptime %d", warmupTime);
    ServerCommand("mp_warmup_start");

    if (indefiniteWarmup) {
        ServerCommand("mp_warmup_pausetimer 1");
    }
}
