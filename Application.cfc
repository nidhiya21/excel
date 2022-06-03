<cfcomponent output="false">
    <cfset this.name = 'Excel Manager'/>
	<cfset this.datasource = 'cf_task_employee'/>  
	<cfset this.applicationTimeout = createtimespan(0,2,0,0) />    
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimespan(0,0,30,0) />  
	<cfset this.clientManagement = true>
	<cfset this.setClientCookies = true /> 
	<cfset This.scriptProtect="all"/> 
	<cffunction name="onApplicationStart" returntype="boolean" >		
		<cfreturn true />
	</cffunction> 
	<cffunction name="onRequestStart" returntype="boolean" >
		<cfargument name="targetPage" type="string" required="true" />
			<cfif isDefined('url.restartApp')>
				<cfset this.onApplicationStart() />
			</cfif>		
			<cfreturn true/>
	</cffunction> 
	
	<cffunction name="onMissingTemplate" returntype="Boolean" output="false">
		<cfargument name="templateName" required="true" type="String" />
		<!--- Put your home page file name here --->
		<cflocation url="./index.cfm" /> 
    <cfreturn true />
	</cffunction>
</cfcomponent> 