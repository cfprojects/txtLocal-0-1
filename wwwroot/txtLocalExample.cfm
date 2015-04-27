<cfscript>
	//Before we do anything Lets check our credits / also it checks our credentials are ok.	
	checkCredits	= application.objTXTLocal.checkCredits();
	//You need to create a Group on your account, then get the ID from > Reports > Advanced Reports > Group IDs
	addToGroup		= application.objTXTLocal.addToGroup('your#groupID#','A Telephone Number');
	//Send a Message
	sendMessage		= application.objTXTLocal.sendSMS(0,1,1,'Test Message','nowt','','','MyID','http://inner-rhythm.co.uk');
</cfscript>

<cfdump var="#checkCredits#" />
<cfdump var="#addToGroup#" />
<cfdump var="#sendMessage#" />
