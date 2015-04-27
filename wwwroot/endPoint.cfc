	/*******************************************************   
    * endPointCFC -- The End point for txtLocal call backs *   
    *                                                      *   
    * Author:  Big Mad Kev                                 *   
    *                                                      *   
    * Version:  0.1							               *   
    *                                                      *   
    * Usage:                                               *   
    *      	Call back from txtLocal and deal with returned *   
	*		data.       								   *   
    ********************************************************/   

<cfcomponent displayname="EndPoint" hint="End Point Object" output="false">

<!--- In your control Panel > settings > SMS delivery receipts enter your url + endPoint.cfc?METHOD=receiptSMS --->
	<cffunction name="receiptSMS" displayname="receipt SMS" description="Recives Receipt SMS" access="remote" output="false" returntype="void">
		<cfargument name="number" 		displayName="number"				type="string"	required="true"		hint="The mobile number of the handset." />
		<cfargument name="status" 		displayName="status" 				type="string" 	required="true"		hint="The message status. Either D for delivered, I for invalid or U for undelivered after 72 hours." />
		<cfargument name="customID" 	displayName="customID" 				type="string" 	required="false"	hint="The custom value passed during message send (if used)." />
		<cfdump var="#arguments#" format="html" output="#getdirectoryfrompath(getcurrenttemplatepath())#/receiptSMS#getTickCount()#.htm"/> 
	</cffunction>

<!--- In your control Panel > Inboxes > Settings > check Forward incoming messages to a URL > enter your url + endPoint.cfc?METHOD=receiveSMS --->
	<cffunction name="receiveSMS" displayname="receive SMS" description="Recives Incoming SMS" access="remote" output="false"   returntype="void">
		<cfargument name="sender" 		displayName="sender" 				type="string"	required="false" 	hint="The mobile number of the handset." />
		<cfargument name="content" 		displayName="content" 				type="string"	required="false" 	hint="The message content." />
		<cfargument name="inNumber" 	displayName="In Number" 			type="string"	required="false" 	hint="The number the message was sent to (your inbound number)." />
		<cfargument name="email" 		displayName="Email Address" 		type="string"	required="false" 	hint="Any email address extracted." />
		<cfargument name="credits" 		displayName="Credits Remaining" 	type="string"	required="false" 	hint="The number of credits remaining on your Txtlocal account." />
		<cfargument name="lat" 			displayName="Latitude" 				type="string"	required="false" 	hint="The latitude of the handset (LBS only)." />
		<cfargument name="long" 		displayName="Longitude" 			type="string"	required="false" 	hint="The longitude of the handset (LBS only)." />
		<cfargument name="rad" 			displayName="Radius" 				type="string"	required="false" 	hint="The radius of error for the location (LBS only)." />
		<cfargument name="lbscredits" 	displayName="LBS Credits Remaining"	type="string"	required="false" 	hint="The number of location credits remaining on your Txtlocal account (LBS only)." />
		<cfdump var="#arguments#" format="html" output="#getdirectoryfrompath(getcurrenttemplatepath())#/receiveSMS#getTickCount()#.htm"/>
	</cffunction>

</cfcomponent>