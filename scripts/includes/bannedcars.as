// This is a list of stream names that will not be broadcasted 
const array<string>  streamFilterList =  
{ 
    "Tatra-T813-Dakar.truck", "Saf-T-LinerHDX1.truck", "Saf-T-LinerHDX2.truck", "accord.truck", "accordb.truck", "accordc.truck", "accordd.truck", "1fffUID-AT-TE.truck", "Sawbuss.truck", "Sawbussescolar.truck", "spidertrax1.truck", "spidertrax2.truck", "spidertrax3.truck", "spidertrax4.truck", "spidertrax5.truck", "amcpacer.truck", "dmc12.truck", "dodgecaravan.truck", "ABC_69SuperBee.truck", "ABC_69SuperBeeTuned.truck" "1stgen.truck", "1stgen1.truck", "1stgen2.truck", "Unimog406.truck", "u5000dakar.truck", "Wrangler1.truck", "Wrangler2.truck", "daytona.truck", "ae86_compom.truck", "lexusis300.truck", "2004HummerH2.truck", "su05.truck", "su05-2.truck", "f430_scu.truck", "camry.truck", "m3e92.truck", "m3e93_gold.truck", "mazda3.truck", "2010_Chevy_Camaro_SS.truck", "x5.truck", "Audi_a4.truck", "Audi_a4_quattro_rally.truck", "Audi_DTM.truck", "Audi_rs4.truck", "Audi_s4_limitededition.truck", "AudiRS.truck", "Audi80_16fwd.truck", "Audi80_16rwd.truck", "Audi80_18fwd.truck", "Audi80_18rwd.truck", "Audi80_Quattro.truck", "chevysilveradonascar.truck", "chevysilveradonascarsuper.truck", "SeatIbiza.truck", "SeatIbizaGTI.truck", "nissan240sx3.truck", "nissan240sx3_dragster.truck", "nissan240sx3_drifter.truck", "nissan240sx3_drifter_fps.truck", "nissan240sx3_fps.truck", "svtraptor.truck", "S10drag.truck", "S10offroad.truck", "S10shortbed.truck", "S10slammed.truck", "3dc2eUID-MM-Monster-200-LS.truck", "abc_69superbeetuned", "abc_69superbee"
}; 

int botUID = -2;
int bannedCars_streamAdded(int uid, stream_register_t@ reg) 
{ 
    // debug 
    /*server.log("New stream detected:"); 
    server.log("      UID " + uid); 
    server.log("     NAME " + reg.getName()); 
    server.log("     TYPE " + reg.type); 
    server.log("   STATUS " + reg.status); 
    server.log("      UID " + reg.origin_sourceid); 
    server.log("      SID " + reg.origin_streamid);*/ 
     
    // Ignore chat and character streams 
    string name = reg.getName(); 
    if(name=="chat" || name=="default") 
        return BROADCAST_NORMAL; 

    // Loop over the list and compare the vehicle name 
    for(uint i=0; i<streamFilterList.length; ++i) 
    { 
        if(name == streamFilterList[i]) 
        { 
            server.say("#110000", uid, FROM_SERVER); 
            server.say("#110000============WARNING============", uid, FROM_SERVER); 
            server.say("#110000 This vehicle is not allowed on this server!", uid, FROM_SERVER); 
            server.say("#110000 All moderators and/or admins on the server have
been messaged and you are now subject to being kicked!", uid, FROM_SERVER); 
            server.say("#110000===============================", uid, FROM_SERVER); 
            server.say("#110000", uid, FROM_SERVER); 

		if(botUID>0)
			server.say("User '"+server.getUserName(uid)+"' has spawned a '"+name+"', which is a banned vehicle.", botUID, FROM_SERVER);
            return BROADCAST_BLOCK; 
        } 
    } 
     
    return BROADCAST_NORMAL; 
}  

void bannedCars_playerAdded(int uid)
{
	if((server.getUserAuthRaw(uid) & AUTH_BOT)>0)
		botUID = uid;
}

void bannedCars_playerDeleted(int uid, int)
{
	if(uid==botUID)
		botUID = -2;
}

void enableBannedCarsPlugin()
{
	server.setCallback("streamAdded", "bannedCars_streamAdded", null);
	server.setCallback("playerAdded", "bannedCars_playerAdded", null);
	server.setCallback("playerDeleted", "bannedCars_playerDeleted", null);
}