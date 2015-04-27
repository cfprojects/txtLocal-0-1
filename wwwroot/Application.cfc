<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">
 
 
	<!--- Set up the application. --->
	<cfscript>
		this.Name = "txtLocal";
		this.ApplicationTimeout = CreateTimeSpan( 0, 0, 1, 0 ) ;
		this.SessionManagement = true;
		this.SetClientCookies = false;
		//do this for CF7
		this.mappings = structnew();
		//do this for CF 8+
		this.mappings['/uk'] = GetDirectoryFromPath(GetCurrentTemplatePath()) & "../uk";
	</cfscript>	
  
 
	<cffunction
		name="OnApplicationStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires when the application is first created.">
 		<cfscript>
 			//Create the CFC Object for Txt Local
			application.objTXTLocal	= createObject('component','uk.co.redgiraffes.txtLocal.txtLocal').init('username','password');
			//Return out
			return true;
		</cfscript>
	</cffunction>
 
	<cffunction
		name="OnError"
		access="public"
		returntype="void"
		output="true"
		hint="Fires when an exception occures that is not caught by a try/catch.">
 
		<!--- Define arguments. --->
		<cfargument
			name="Exception"
			type="any"
			required="true"
			/>
 
		<cfargument
			name="EventName"
			type="string"
			required="false"
			default=""
			/>
 
 			<cfdump var="#arguments#" format="html" output="#getdirectoryfrompath(getcurrenttemplatepath())#/error#getTickCount()#.htm"/> 
	
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
</cfcomponent>