
// list type
enum streamValidation_listType
{
	WHITELIST,
	BLACKLIST
}

class streamValidation
{
	array<int> informants;     // List of UIDs of admins, mods and bots
	array<string>@ filterList; // List of stream names
	int type;                  // Type of list
	bool registered;           // Internal flag

	streamValidation(array<string>@ list, streamValidation_listType type_ = BLACKLIST)
	{
		informants.resize(0); // TODO: scan playerlist
		@filterList = @list;
		registered = true;
		type       = type_;
		if(type!=BLACKLIST and type!=WHITELIST)
			server.throwException("Type should be eiter BLACKLIST or WHITELIST.");
	
		server.setCallback("streamAdded",   "streamAdded",   @this);
		server.setCallback("playerAdded",   "playerAdded",   @this);
		server.setCallback("playerDeleted", "playerDeleted", @this);
	}
	
	~streamValidation()
	{
		destroy();
	}
	
	void destroy()
	{
		if(registered)
		{
			server.deleteCallback("streamAdded",   "streamAdded",   @this);
			server.deleteCallback("playerAdded",   "playerAdded",   @this);
			server.deleteCallback("playerDeleted", "playerDeleted", @this);
			registered = false;
		}
	}
	
	void playerAdded(int uid)
	{
		if((server.getUserAuthRaw(uid) & (AUTH_BOT | AUTH_ADMIN | AUTH_MOD))>0)
			informants.insertLast(uid);
	}
	
	void playerDeleted(int uid, int)
	{
		int index = informants.find(uid);
		if(index>=0) informants.removeAt(index);
	}

	int streamAdded(int uid, stream_register_t@ reg)
	{
#if FALSE
		server.log("New stream detected:");
		server.log("	  UID " + uid);
		server.log("	 NAME " + reg.getName());
		server.log("	 TYPE " + reg.type);
		server.log("   STATUS " + reg.status);
		server.log("	  UID " + reg.origin_sourceid);
		server.log("	  SID " + reg.origin_streamid);
#endif
		
		// Ignore chat and character streams
		string name = reg.getName();
		if(name=="chat" || name=="default")
			return BROADCAST_NORMAL;

		// Loop over the list and compare the vehicle name
		bool found = false;
		for(uint i=0; i<filterList.length; ++i)
		{
			if(name == filterList[i])
			{
				found = true;
				break;
			}
		}
		
		// Take action if required
		if( (found and type==BLACKLIST) or (not found and type==WHITELIST) )
		{
			// Let the user know
			server.say("#110000", uid, FROM_SERVER);
 			server.say("#110000============WARNING============", uid, FROM_SERVER); 
			server.say("#FF000 This vehicle is not allowed on this server!", uid, FROM_SERVER); 
			server.say("#FF000 All moderators and/or admins on the server have been messaged and you are now subject to being kicked!", uid, FROM_SERVER); 
			server.say("#110000===============================", uid, FROM_SERVER); 
			server.say("#110000", uid, FROM_SERVER); 
			
			// Let the informants know
			string msg = "User '"+server.getUserName(uid)+"' with uid ("+uid+") has spawned a '"+name+"', which is a banned vehicle.";
			for(uint i=0; i<informants.length; ++i)
			{
				server.say(msg, informants[i], FROM_SERVER);
			}
			
			return BROADCAST_BLOCK;
		}
		else
			return BROADCAST_NORMAL;
	}
}