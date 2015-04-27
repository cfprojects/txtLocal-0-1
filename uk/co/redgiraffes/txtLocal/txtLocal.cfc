	/*******************************************************   
    * txtLocalCFC -- Interact with txtLocal Service        *   
    *                                                      *   
    * Author:  Big Mad Kev                                 *   
    *                                                      *   
    * Version:  0.1							               *   
    *                                                      *   
    * Usage:                                               *   
    *      	To Send SMS Messages / Check Balance / 		   *   
	*		Inject Numbers to a Group					   *   
    ********************************************************/   

<cfcomponent displayname="txtLocalAPI" hint="TxtLocal API Interface" output="false">
	<cfscript>
		instance 					= {};
		instance.remoteURLPrefix	= 'http://www.txtlocal.com/';
		instance.params				= {};
	</cfscript>

	<cffunction name="init"			displayName="init Function"	description="The Inital Funciton to load the CFC" access="public"	output="false" returntype="txtLocal">
		<cfargument name="username" 		displayName="User Name" 			type="string" 	required="true"		hint="Your Txtlocal username" />
		<cfargument name="password" 		displayName="Password" 				type="string" 	required="true"		hint="Your Txtlocal password" />

		<cfscript>
			//Place the authentication data into the instance
			instance.username			= arguments.username;
			instance.password			= arguments.password;
			//Lets Place these variable in the params Instance
			instance.params['uname']	= instance.username;
			instance.params['pword']	= instance.password;
			
			return this;
		</cfscript>
		
	</cffunction>

	<cffunction name="checkCredits" displayname="Check Credits" description="Checks the Credits on your Account" access="public" output="false" returntype="struct">
		<cfscript>
			//Take the base URL and add the File for the Task in Hand
			var url							= instance.remoteURLPrefix & 'getcredits.php';
			//Duplicate the Instance Params which has the authentication data
			var params						= duplicate(instance.params);
			var httpCall					= {};
			var returnStruct				= {};
			//Make a call to a local UDF for the http cal so we can stay in script
			httpCall 						= udf_cfhttp(url,params);
			//Return a simple Struct so that all returns in the CFC are similar
			returnStruct['message']			= trim(httpCall.Filecontent);
			return returnStruct;
		</cfscript>
	</cffunction>
	
	<cffunction name="addToGroup" displayname="Add to Group" description="inject numbers and contact information directly in to a group on your account" hint="injectNumbers" access="public" output="false" returntype="struct">
		<cfargument name="group" 		displayName="group" 				type="string"	required="true"		hint="ID of the target group. You can get this from your control panel 'reports' section" />
		<cfargument name="numbers" 		displayName="number" 				type="numeric"	required="true"		hint="The mobile telephone number to insert, in international format." />
		<cfargument name="firstname" 	displayName="First Name" 			type="string"	required="false"	hint="The content to save as 'firstname'. Optional" />
		<cfargument name="lastname" 	displayName="Last Name" 			type="string"	required="false"	hint="The content to save as 'lastname'. Optional" />
		<cfargument name="custom1" 		displayName="custom 1" 				type="string"	required="false"	hint="The content to save as 'custom1'. Optional" />
		<cfargument name="custom2" 		displayName="Custom 2" 				type="string"	required="false"	hint="The content to save as 'custom2'. Optional" />
		<cfargument name="custom3" 		displayName="Custom 3" 				type="string"	required="false"	hint="The content to save as 'custom3'. Optional"  />
		<cfscript>
			//Take the base URL and add the File for the Task in Hand
			var url							= instance.remoteURLPrefix & 'tl_inject.php';
			//Duplicate the Instance Params which has the authentication data
			var params						= duplicate(instance.params);
			var httpCall					= {};
			var returnStruct				= {};
			
			params['group']					= arguments.group;
			params['numbers']				= arguments.numbers;
			if(structKeyExists(arguments,'firstname'))
			params['firstname']				= arguments.firstname;
			if(structKeyExists(arguments,'lastname'))
			params['lastname']				= arguments.lastname;
			if(structKeyExists(arguments,'custom1'))
			params['custom1']				= arguments.custom1;
			if(structKeyExists(arguments,'custom2'))
			params['custom2']				= arguments.custom2;
			if(structKeyExists(arguments,'custom3'))
			params['custom3']				= arguments.custom3;
			
			//Make a call to a local UDF for the http cal so we can stay in script
			httpCall 						= udf_cfhttp(url,params);
			//Return a simple Struct so that all returns in the CFC are similar
			returnStruct['message']			= trim(httpCall.Filecontent);
			return returnStruct;
		</cfscript>
	</cffunction>

	<cffunction name="sendSMS" displayname="Send SMS" description="Sends a Text Meesage" hint="send Text" access="public" output="false" returntype="struct">
		<cfargument name="debug" 		displayName="debug" 				type="boolean" 	required="true" 	hint="A flag to switch on/off debug information" default="0" />
		<cfargument name="json" 		displayName="Return as JSON" 		type="boolean" 	required="true" 	hint="If set to 1, this will return 'info' in JSON format." default="0"/>
		<cfargument name="test" 		displayName="test" 					type="boolean" 	required="true" 	hint="This is the test mode. If test=1 then messages will not be sent and credits will not be deducted." default="0" />
		<cfargument name="message" 		displayName="message" 				type="string"	required="true" 	hint="The text message body." />
		<cfargument name="from" 		displayName="from" 					type="string"	required="true" 	hint="From Address that is displayed when the message arrives on handset." />
		<cfargument name="selectednums"	displayName="Selected Numbers"		type="string"	required="false"	hint="A comma separated list of international mobile numbers" />
		<cfargument name="group" 		displayName="group" 				type="string"  	required="false"	hint="send to a precreated Txtlocal.com group" />
		<cfargument name="customID" 	displayName="Custom ID" 			type="string" 	required="false"	hint="you can record a custom ID against the the message batch, which will be passed back in the delivery receipt." />
		<cfargument name="receiptURL" 	displayName="receipt URL" 			type="string" 	required="false" 	hint="Alternate receipt URL. Instead of using the receipt URL in the Txtlocal Account Settings, receipts will be sent to this URL." />
		<cfargument name="schedule" 	displayName="schedule Message"		type="date" 	required="false" 	hint="The scheduled message date/time. In the format YYYY-MM-DD-HH-MM-SS (e.g 2008-03-28-14-56-00). Scheduled messages can be viewed and deleted via your Txtlocal online account."/>
		<cfargument name="validity" 	displayName="validity" 				type="numeric"  required="false" 	hint="The time at which you wish the message to expire if it has not been received by the phone (i.e. Phone out of signal range or turned off). In the format MMDDHHmm (It cannot be greater than 48hours in the future)." />
		<cfargument name="wapURL" 		displayName="WAP URL" 				type="string"	required="false"	hint="you can send a WAP PUSH (mobile internet bookmark) to a mobile phone" />
		
		<cfscript>
			//Take the base URL and add the File for the Task in Hand
			var url							= instance.remoteURLPrefix & 'sendsmspost.php';
			//Duplicate the Instance Params which has the authentication data
			var params						= duplicate(instance.params);
			var httpCall					= {};
			var returnStruct				= {};
			
			
			params['info']					= arguments.debug;
			params['json']					= arguments.json;
			params['test']					= arguments.test;
			params['message']				= arguments.message;
			params['from']					= arguments.from;
			
			if(structKeyExists(arguments,'selectednums'))
			params['selectednums']			= arguments.selectednums;
			if(structKeyExists(arguments,'group'))
			params['group']					= arguments.group;
			if(structKeyExists(arguments,'wapURL'))
			params['url']					= arguments.wapURL;
			//If No Custom ID is sent in lets generate a UUID
			if(structKeyExists(arguments,'customID')) {
				params['custom']			= arguments.customID;
			}
			else {
				params['custom']			= createUUID();
			}
			if(structKeyExists(arguments,'receiptURL'))
			params['rcpurl']				= arguments.receiptURL;
			if(structKeyExists(arguments,'schedule'))
			params['shed']					= arguments.schedule;
			if(structKeyExists(arguments,'validity'))
			params['validity']				= arguments.validity;
			
			//Make a call to a local UDF for the http cal so we can stay in script
			httpCall 						= udf_cfhttp(url,params);
			
			if (isJSON(httpCall.Filecontent)) {
				//If the return content is a JSON Packet turn it into a Struct to Return
				returnStruct				= deserializeJSON(httpCall.Filecontent);
			}
			else {
				//Return a simple Struct so that all returns in the CFC are similar
				returnStruct['message']		= trim(httpCall.Filecontent);
			}
			return returnStruct;
		</cfscript>

	</cffunction>

	<!--- A Private Function for CFHTTP --->
	
	<cffunction name="udf_cfhttp" displayname="CFHTTP" description="CFHTTP In Script for Pre CF9" hint="CFHTTP" access="private" output="false" returntype="struct">
		<cfargument name="url"			displayName="url"					type="string" 	required="true" 	hint="The URL to Hit" />
		<cfargument name="params"		displayName="params"				type="struct" 	required="false"	hint="Params to Pass to the URL" />
		
		<cfset var returnStruct	= {}/>
		<!--- Make the HTTP Call --->
		<cfhttp url="#arguments.url#" method="post" result="returnStruct" >
			<!--- Loop over the Params --->
			<cfloop collection="#arguments.params#" item="param">
				<cfhttpparam type="formfield"    encoded="true" name="#param#" value="#arguments.params[param]#">
			</cfloop>
		</cfhttp>
		<!--- Return from the CFHTTP Call --->
		<cfreturn returnStruct/>
	</cffunction>

</cfcomponent>