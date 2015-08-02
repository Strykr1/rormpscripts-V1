#include "chatManager.as"
#include "terrainEditor.as"
#include "gameScriptWrapper.as"
#include "welcome.as"
#include "streamValidation.as"
#include "botAPI.as"
#include "kickNotificationWrapper.as"

// Create a chatManager object instance
chatManager chatSystem();



// Create a gameScriptManager object instance.
gameScriptManager gsm();



// Add the autoModerator plugin.
// This plugin allows the following commands:
//     - !suspendchat   Suspend all chat traffic for a certain time
//     - !schat         Short for !suspendchat
//     - !chatban       Blocks all chat messages from a certain user for a
//                      certain time
//     - !cban          Short for !chatban
//     - !temporaryban  Not yet implemented
//     - !tempban       Short for !temporaryban
//     - !tban       Short for !temporaryban
// Furthermore, it adds the profanity filter and flood filter to the chat.
chatPlugin_autoModerator autoModerator(@chatSystem);

// This small plugin transform messages like:
//      Anonymous: OMG LOOK ATZ ME
// to:
//      Anonymous: Omg look atz me
chatPlugin_disallowAllUpperCase disallowAllUpperCase(@chatSystem);

// This plugin adds the following commands:
//     - !afk           Prints "<username> is now away from keyboard."
//     - !back          Prints "<username> is now back."
//     - !gtg           Prints "<username> has got to go."
//     - !brb           Prints "<username> will be right back."
chatPlugin_miscellaneousCommands miscellaneousCommands(@chatSystem);

// This command adds the !move command, which will move your avatar in the
// specified direction.
chatPlugin_moveCommand moveCommand(@chatSystem);

// This commands adds the !goto, !setgoto (!sgoto) and !delelegoto (!dgoto)
// command. It allows you to store the position of your avatar (!setgoto <name>)
// and later teleport to that position (!goto <name>).
// Note: The !setgoto command works only with RoR 0.39! (not with 0.38)
chatPlugin_gotoCommand gotoCommand(@chatSystem, @gsm);

// This keeps track of what terrains are being used on the server and gives a
// list when the !terrainlist (!tlist) command is used.
// Note: All clients with RoR 0.38 will be shown as 'unknown terrain'.
//chatPlugin_terrainList terrainList(@chatSystem, @gsm);

// This checks the latency of all RoR 0.39 players every 20 seconds and responds
// to !ping commands.
//chatPlugin_ping ping(@chatSystem, @gsm);

// Another example, to show how to add commands.
// This adds a command !boost that gives a temporary boost to the truck of
// the user.
customCommand boostCommand(@chatSystem, "boost", customCommand_boost);
void customCommand_boost(chatMessage@ cmsg)
{
	cmsg.privateGameCommand.boostCurrentTruck(5);
}


// Add the terrain editor (RoR 0.39 only!)
// Commented out, doesn't work correctly yet.
//terrainEditor ternnditor(@chatSystem, @gsm);



// Load the terrain edits
terrainFileLoader terrain(@gsm, server.getServerTerrain());



// Add some commands that allow you to reload the terrain file, without having to restart the server.
customCommand reloadTerrainCommand(@chatSystem, "reloadterrain", customCommand_reloadTerrain, null, true, AUTH_ADMIN);
void customCommand_reloadTerrain(chatMessage@) { terrain.reload(); }

customCommand unloadTerrainCommand(@chatSystem, "unloadterrain", customCommand_unloadTerrain, null, true, AUTH_ADMIN);
void customCommand_unloadTerrain(chatMessage@) { terrain.unload(); }

customCommand loadTerrainCommand(@chatSystem, "loadterrain", customCommand_loadTerrain, null, true, AUTH_ADMIN);
void customCommand_loadTerrain(chatMessage@)   { terrain.load();   }


// This is a list of stream names that will not be broadcasted 
array<string>  streamFilterList =  
{ 
    "Tatra-T813-Dakar.truck", "Saf-T-LinerHDX1.truck", "Saf-T-LinerHDX2.truck", "Saf-T-LinerHDX3.truck", "1fffUID-AT-TE.truck", "Sawbuss.truck", "Sawbussescolar.truck", "spidertrax1.truck", "spidertrax2.truck", "spidertrax3.truck", "spidertrax4.truck", "spidertrax5.truck", "amcpacer.truck", "dmc12.truck", "dodgecaravan.truck", "1stgen.truck", "1stgen1.truck", "1stgen2.truck", "Unimog406.truck", "u5000dakar.truck", "Wrangler1.truck", "Wrangler2.truck", "daytona.truck", "ae86_compom.truck", "lexusis300.truck", "2004HummerH2.truck", "su05.truck", "su05-2.truck", "f430_scu.truck", "camry.truck", "m3e92.truck", "m3e93_gold.truck", "mazda3.truck", "2010_Chevy_Camaro_SS.truck", "x5.truck", "chevysilveradonascar.truck", "chevysilveradonascarsuper.truck", "SeatIbiza.truck", "SeatIbizaGTI.truck", "nissan240sx3.truck", "nissan240sx3_dragster.truck", "nissan240sx3_drifter.truck", "nissan240sx3_drifter_fps.truck", "nissan240sx3_fps.truck", "svtraptor.truck", "RenoClio.truck", "silvias13.truck", "rx7.truck", "Ferarri_458_Spider.truck", "Ferarri_458_Spider.truck", "bmw750i1.truck", "bmw750i2.truck", "bmw750i3.truck", "chevysilverado2.truck", "chevysilverado2mud.truck", "chevysilverado2500.truck", "chevysilverado2500lifted.truck", "chevysilverado3500.truck", "gavrilmv4police.truck", "gavrilmv4PoliceInterceptor.truck", "gavrilmv4rpolice.truck", "gavrilmv4RUSSIANPOLICE.truck", "gavrilmv4sunmarkedpolice.truck", "supra.truck", "BoxDodgeRamEXT222.truck", "svtraptoroffroadv1.truck", "svtraptoroffroadv2.truck", "gavril_monster_energy.truck", "gavril_monster_energy1.truck", "spacewagon_lhd.truck", "forester.truck", "foc07.truck", "2009 Dodge Challenger SRT8 (fps).truck", "2009 Dodge Challenger SRT8.truck", "su05.truck", "nissanr34.truck", "camry97.truck", "cvev.truck", "12Mazda_RX8.truck", "vwtour.truck", "2115.truck", "vaz2.truck", "vol.truck", "hondansxgt.truck", "ferrari_458_spider.truck", "chevelle.truck", "MMCP-C.truck", "honda97.truck", "EL_BRUTE.truck", "reven.truck", "MMCP-DP.truck", "MMCP-DA.truck", "moskvich.truck", "merc.truck", "lincoln.truck", "koenigsegg.truck", "m3e92_gold.truck", "m3e92.truck", "squishybigfoot.truck", "squishyblacksmith.truck", "squishybrutus.truck", "funnytex.truck", "funnytex2.truck", "hummerh.truck", "u5000racingne2wsusnedbed3.truck", "6ef84UID-1stgen.truck", "squishycj.truck", "GraveDiggerFT.truck", "a1523UIDcountach.truck", "Audi80Quattro.truck", "2010Shelbygt500.truck", "Sisu-SA-150B.truck", "af25UID-aaadodgeviper.truck", "Supra.truck", "3dc2eUID-MM-Race-400-LS.truck", "impala.truck", "focus.truck", "Enigma.truck", "dcds.truck", "1990_BMW_M5_E34.truck", "Supra 92.truck", "Beasty G2.truck", "Mafioso.truck", "DatSwaqqer Sticker Bomber.truck", "Trigger Finger.truck", "2001su.truck", "Toyota Soarer.truck", "Ford fiesta.truck", "Nissan_GTR-R35.truck", "nissanR34.truck", "bcgtpm.truck", "gavrilmv4Di1.truck", "gavrilmv4Di12.truck", "gavrilmv4_ret.truck", "gavrilluxury.truck", "gavrilmv4_n24.truck", "gavrilmv4_nur.truck", "gavrilmv4_xd1.truck", "gavrilmv4r_POLICe.truck", "pri.truck", "2107.truck", "Peugeot 406.truck", "1997 Honda Civic Type-R.truck", "21099.truck", "1983 Audi Sport quattro.truck", "daytonahazzard.truck", "ATV.truck", "suzuki.truck", "gazel.truck", "2114u.truck", "tt.truck", "gavrilgv3_DRAG.truck", "Ferrari 1989 F40 Competizione.truck", "Race_Touareg.truck", "20.truck", "Unimog4064door.truck", "MM-Baja-250-LS.truck", "MM-Monster-200-LS.truck", "MM-Race-400-LS.truck", "daytonahazzard.truck", "ATV.truck", "1983 Audi Sport quattro.truck", "1990_BMW_M5_E34.truck", "supra.truck", "tt.truck", "suzuki.truck", "2008su.truck", "2012 Mercedes-Benz S 65 AMG [W221].truck", "Niva.truck", "2114u.truck", "buffalo.truck", "buffaloP.truck", "Chevrolet ss.truck", "20.truck", "tax.truck", "sultan.truck", "03windstar_off.truck", "03windstar.truck", "03windstar_tenzo.truck", "MMCP-DM-C.truck", "gavrilmv4_jdm.truck", "vh-monsterbus.truck", "chevy10blazer.truck"
}; 
streamValidation bannedCars(@streamFilterList, BLACKLIST);



// Our main function (never remove this, even when it does nothing useful!)
void main()
{
	server.log("The script file is working :D");
	autoModerator.disableFloodFilter();
	server.setCallback("playerAdded", "authWarning_playerAdded", null);
}

// Add this somewhere else, for example at the very bottom of ExampleScript.as
void authWarning_playerAdded(int uid)
{
	if((server.getUserAuthRaw(uid)&(AUTH_ADMIN|AUTH_MOD))>0)
		server.say(server.getUserName(uid)+" is a server "+server.getUserAuth(uid), TO_ALL, FROM_HOST);
}