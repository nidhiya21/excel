<cfif structKeyExists(url, 'success')>
    <cfoutput> 
        <cfif structKeyExists(session, 'success')> 
            <cfset spreadsheetData = #session.spreadsheetData#> 
            <cfset numColumn       = #session.numColumn#> 
            <cfif session.success>
                <div class="alert alert-success alert-dismissible d-flex align-items-center" role="alert"> 
                    <div>
                        Excel uploaded Succesfully. <a href="./index.cfm"> Back to page</a>
                    </div>
                </div>
            </cfif>
            <cfset metadata = getMetadata(spreadsheetData)>
            <cfset colList = "">
            <cfloop index="col" array="#metadata#">
                <cfset colList = listAppend(colList, col.name)>
            </cfloop>
            <cfif spreadsheetData.recordCount is 1>
                <p> This spreadsheet appeared to have no data.</p>
            <cfelse>
                <table style="border:1px solid black;">
                    <cfset nos = #spreadsheetData.recordcount#>
                    <cfset len = #numColumn#>
                    <cfset i = 1>
                    <cfset logic = #ceiling(nos/len)#>
                    <cfdump var =#nos#>
                    <cfset dividend = nos MOD len>
                    <cfset postion = len- dividend>
                    <cfset term = postion-1>
                    <cfdump var="#postion#">
                    <cfloop index="j" from="1" to="#len#">  
                        <cfloop index="k" from="1" to="#logic#">
                            <cfif i gt nos>
                                <cfcontinue>
                            </cfif>
                            <cfif postion gt 0>
                                <cfloop index="z" from="#term#" to="#postion#">
                                    <cfset x[logic][z]= ''>
                                </cfloop>
                                
                            </cfif>
                            <cfset x[k][j]= i++>      
                        </cfloop>
                    </cfloop>  
                    <cfloop index="r" from="1" to="#postion#" step ="1">
                        <cfset x[1][postion]= #x[numColumn][2]# +1>  
                        <cfset x[r+1][postion]= #x[r][postion]# +1>
                        <cfset x[1][postion+1]= #x[numColumn][3]# +1>  
                       
                    </cfloop>
                    <cfloop index="h" from="1" to="#postion#" step ="1">
                        
                        <cfset x[h+1][postion+1]= #x[h][postion+1]# +1>
                        
                    </cfloop>
            
                    <cfloop index="y" array="#x#">
                        <tr style="border:1px solid black;"> 
                            <cfloop index="m" array="#y#">
                                <td style="border:1px solid black;">#m# </td>
                            </cfloop>
                        </tr>
                    </cfloop>
                </table>
            </cfif>
        </cfif>
    </cfoutput>
</cfif> 
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Excel Manager</title>
        <link href="./css/bootstrap.css" rel="stylesheet" type="text/css"/>         
    </head>
    <body>
        <cfoutput>
            <div class="container">
                <div class="row">
                    <h2>Excel Manager</h2>  
                    <cfparam name="form.numColumn" default="" >
                    <cfparam name="form.xlsfile" default=""> 
                    <form action="./components/index.cfc?method=verifyAndUploadXLSX" name="excelRead" method="post" enctype="multipart/form-data" > 
                        <div class="form-group col-md-4">
                            <label>Input Number Of columns</label>
                            <input type="text" name="numColumn" class="form-control"> 
                        </div><br>
                        <div class="form-group col-md-4">
                            <label>Upload Image</label>
                            <input type="file" name="xlsfile" accept=".xls, .xlsx" >
                        </div><br>
                        <div class="form-group col-md-4"> 
                            <label></label> 
                            <input type="Submit" class="btn btn-success" value="Submit" name="formSubmit">
                        </div>  
                    </form> 
                </div>
            </div>
        </cfoutput> 
    </body> 
</html>