<cfcomponent  accessors="true" output="false">
    <cffunction  name="verifyAndUploadXLSX" returntype ="struct" output="false" hint="reading excel"   access="remote">
        <cfargument name="xlsfile" type="string">
        <cfargument name="numColumn" type="numeric">
        <cfset dest = getTempDirectory()>
        <cfset local.errors = "">
        <cfset local.savedFile = "">
        <cfset local.success = false>
        <cffile action="upload" destination="#dest#" filefield="xlsfile" result="upload" nameconflict="makeunique">
        
        <cfif upload.fileWasSaved>
            <cfset theFile = upload.serverDirectory & "/" & upload.serverFile>
            <cfif isSpreadsheetFile(theFile)>
                <cfspreadsheet action="read" src="#theFile#" query="spreadsheetData" headerrow="1">
                <cfset local.success = true>
                <cfset session.success = true>
                <cfset session.spreadsheetData = spreadsheetData>  
                <cfset session.numColumn = #arguments.numColumn#> 
                <cflocation  url="../index.cfm?success=true" addtoken="false">
            <cfelse>
                <cfset local.errors = "The file was not an Excel file.">
                <cffile action="delete" file="#theFile#">
            </cfif>
        <cfelse>
            <cfset local.errors = "The file was not properly uploaded.">	
        </cfif>
        <cfset returnData = structNew()> 
        <cfset returnData["success"] = local.success>
        <cfset returnData["errors"] = local.errors>
        <cfset returnData["savedFile"] = local.savedFile>
        <cfif local.success>
            <cfset returnData["spreadsheet"] = spreadsheetData> 
        </cfif>
        <cfreturn returnData>
    </cffunction>
</cfcomponent>     
