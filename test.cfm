!---
	Get the month that we are going to be showing the
	events for (April 2007).
--->
<cfset dtThisMonth = CreateDate( 2007, 4, 1 ) />

<!---
	Because the calendar month doesn't just show our
	month - it may also show the end of last month and
	the beginning of next month - we need to figure out
	the start and end of the "calendar" display month,
	not just this month.
--->
<cfset dtMonthStart = (dtThisMonth + 1 - DayOfWeek( dtThisMonth )) />

<!--- Get the last day of the calendar display month. --->
<cfset dtMonthEnd = (dtThisMonth - 1 + DaysInMonth( dtThisMonth )) />
<cfset dtMonthEnd = (dtMonthEnd + (7 - DayOfWeek( dtMonthEnd ))) />


<!---
	ASSERT: At this point, not only do we know what month
	we are going to display, we also know the first and last
	calendar days that are going to display. We do not need
	to know what numeric month those actually fall on.
--->


<!---
	Create an object to hold the dates that we want to
	show on the calendar. Since our calendar view doesn't
	have any real detail other than event existence, we
	don't have to care about event details. We will use
	this struct to create an index of date DAYS only.
--->
<cfset objEvents = StructNew() />


<!---
	Let's populate the event struct. Here, we have to
	be careful not just about single day events but also
	multi day events which have to show up more than once
	on the calendar.
--->
<cfloop query="qEvent">

	<!---
		For each event, we are going to loop over all the
		days between the start date and the end date. Each
		day within that date range is going to be indexed
		in our event index.
		When we are getting the date of the event, remember
		that these dates might have associated times. We
		don't care about the time, we only care about the
		day. Therefore, when we grab the date, we are Fixing
		the value. This will strip out the time and convert
		the date to an integer.
	--->
	<cfset intDateFrom = Fix( qEvent.date_started ) />
	<cfset intDateTo = Fix( qEvent.date_ended ) />


	<!---
		Loop over all the dates between our start date and
		end date. Be careful though, we don't care about days
		that will NOT show up on our calendar. Therefore,
		using our are Month Start and Month End values found
		above, we can Min/Max our loop.
		When looping, increment the index by one. This will
		add a single day for each loop iteration.
	--->
	<cfloop
		index="intDate"
		from="#Max( intDateFrom, dtMonthStart )#"
		to="#Min( intDateTo, dtMonthEnd )#"
		step="1">

		<!---
			Index this date. We don't care if two different
			event dates overwrite each other so long as at
			least one of the events registers this date.
		--->
		<cfset objEvents[ intDate ] = qEvent.id />

	</cfloop>

</cfloop>


<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>Calendar Month</title>

	<style type="text/css">
		body,
		td {
			font: 11px verdana ;
			}
		table.month {}
		table.month tr.dayheader td {
			background-color: ##8EDB00 ;
			border: 1px solid ##308800 ;
			border-bottom-width: 2px ;
			color: ##E3FB8E ;
			font-weight: bold ;
			padding: 5px 0px 5px 0px ;
			text-align: center ;
			}
		table.month tr.day td {
			background-color: ##E3FB8E ;
			border: 1px solid ##999999 ;
			color: ##308800 ;
			padding: 5px 0px 5px 0px ;
			text-align: center ;
			}
		table.month tr.day td.othermonth {
			background-color: ##F3FDD0 ;
			color: ##999999 ;
			}
		table.month tr.day td.event {
			background-color: ##C8F821 ;
			color: ##666666 ;
			font-weight: bold ;
			}
	</style>
</head>
<body>

	<h2>
		#DateFormat( dtThisMonth, "mmmm yyyy" )#
	</h2>

	<table width="100%" cellspacing="2" class="month">
	<colgroup>
		<col width="12%" />
		<col width="15%" />
		<col width="15%" />
		<col width="15%" />
		<col width="15%" />
		<col width="15%" />
		<col width="13%" />
	</colgroup>
	<tr class="dayheader">
		<td>
			Sun
		</td>
		<td>
			Mon
		</td>
		<td>
			Tus
		</td>
		<td>
			Wed
		</td>
		<td>
			Thr
		</td>
		<td>
			Fri
		</td>
		<td>
			Sat
		</td>
	</tr>
	<tr class="day">

		<!---
			Now, we need to loop over the days in the
			calendar display month. We can use the start
			and end days we found above. When looping, add
			one to the index. This will add a single day
			per loop iteration.
		--->
		<cfloop
			index="intDate"
			from="#dtMonthStart#"
			to="#dtMonthEnd#"
			step="1">


			<!---
				Check to see which classes we are going to
				need to assign to this day. We are going to
				use one class for month (this vs. other) and
				one for whether or not there is an event.
			--->
			<cfif (Month( intDate ) EQ Month( dtThisMonth))>
				<cfset strClass = "thismonth" />
			<cfelse>
				<cfset strClass = "othermonth" />
			</cfif>

			<!---
				Check to see if there is an event scheduled
				on this day. We can figure this out by checking
				for this date in the event index.
			--->
			<cfif StructKeyExists( objEvents, intDate )>
				<cfset strClass = (strClass & " event") />
			</cfif>

			<td class="#strClass#">
				#Day( intDate )#
			</td>


			<!---
				Check to see if we need to start a new row.
				We will need to do this after every Saturday
				UNLESS we are at the end of our loop.
			--->
			<cfif (
				(DayOfWeek( intDate ) EQ 7) AND
				(intDate LT dtMonthEnd)
				)>
				</tr>
				<tr class="day">
			</cfif>

		</cfloop>
	</tr>
	</table>

</body>
</html>
</cfoutput>