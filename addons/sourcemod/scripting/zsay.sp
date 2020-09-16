#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "ZSay",
	author = "quantum",
	description = "Msay komutunun daha güzel gözüken halidir",
	version = "1.1",
	url = "https://steamcommunity.com/id/quascave"
};

ConVar g_SunucuAdi, g_SunucuIP;

public void OnPluginStart()
{
	RegAdminCmd("sm_zsay", Zsay, ADMFLAG_ROOT, "sm_zsay <mesaj> - Menu paneli şeklinde mesaj atar");
	g_SunucuAdi = CreateConVar("sm_zsay_sunucu_adi", "SM", "İlk satırda yazan yazıdır sadece sunucu ismini yazınız boşuk vs. bırakmanıza gerek yok");
	g_SunucuIP = CreateConVar("sm_zsay_sunucu_ip", "oyundedektoru.com", "Son satırda yazan yazıdır sadece sunucu ipsini yazınız boşuk vs. bırakmanıza gerek yok");
}

public void OnMapStart()
{
	AutoExecConfig(true, "ZSay", "quantum");
}

public Action Zsay(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Kullanım: \x02sm_zsay \x01<mesaj>");
		return Plugin_Handled;	
	}
	
	char text[192];
	GetCmdArgString(text, sizeof(text));

	SendPanelToAll(client, text);

	LogAction(client, -1, "\"%L\" tarafından sm_zsay (text %s)", client, text);
	
	return Plugin_Handled;		
}


void SendPanelToAll(int from, char[] message)
{	
	ReplaceString(message, 192, "\\n", "\n");

	char zsay[256];
	Format(zsay, sizeof(zsay), "%N: %s", from, message);
    
	char SunucuAdi[64];
	GetConVarString(g_SunucuAdi, SunucuAdi, sizeof(SunucuAdi));
	char SunucuIP[64];
	GetConVarString(g_SunucuIP, SunucuIP, sizeof(SunucuIP));
    
	char ilksatir[64];
	char sonsatir[64];
    
	Format(ilksatir, sizeof(ilksatir), "                  !- %s -!              ", SunucuAdi);
	Format(sonsatir, sizeof(sonsatir), "                  !- %s -!              ", SunucuIP);
	
	Panel zSayPanel = new Panel();
	zSayPanel.SetTitle(ilksatir);
	zSayPanel.DrawItem("", ITEMDRAW_SPACER);
	zSayPanel.DrawText(zsay);
	zSayPanel.DrawItem("", ITEMDRAW_SPACER);
	zSayPanel.DrawText(sonsatir);
	zSayPanel.DrawItem("Kapat", ITEMDRAW_CONTROL);

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			zSayPanel.Send(i, Handler_DoNothing, 5);
		}
	}

	delete zSayPanel;
}

public int Handler_DoNothing(Menu menu, MenuAction action, int param1, int param2)
{
	/* Boş kalıcak */
}
