<!--
/********************** PROPERTY OF JASCI, LLC USA CORPORATION, COPYRIGHT 2015 ********************
* 										ALL RIGHTS RESERVED
* @Program: AI_Configurator_SelectGroup.jsp
* @Description: Page to do the Search for Restart Work 
* @Developer: Yuzhong Liang
* @Date: July 02, 2025
* @TemplateVersion: V01
**************************************************************************************************/
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.kendoui.com/jsp/tags" prefix="kendo"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>

<%@ page import="java.util.Properties, 
				 java.io.IOException,
				 java.io.InputStream,
				 com.jasci.common.constant.GLOBALCONSTANT, 
				 com.jasci.biz.AdminModule.be.GENERALCODESBE" %>

<!DOCTYPE html>
<html>
<head>

<link rel="stylesheet" type="text/css"href="<c:url value="/resourcesValidate/css/standard.css" />">
<link rel="stylesheet" type="text/css"href="<c:url value="/resourcesValidate/css/jasci.css" />">

<script src="<c:url value="/resourcesValidate/form-validation.js" />"type="text/javascript"></script>
<script src="<c:url value="/resourcesValidate/js/jsp-util.js" />" type="text/javascript"></script>
<script src="<c:url value="/resourcesValidate/js/bootbox.js"/>" type="text/javascript"></script>
<script src="<c:url value="/resourcesValidate/js/bootbox.min.js"/>" type="text/javascript"></script>

<style>

button {
	padding: 0;
	border: none;
	background: none;
}



</style>

</head>

<body>

	<tiles:insertDefinition name="subMenuAssigmentTemplate">
		<tiles:putAttribute name="body">
			<div id="container" style="position: relative" class="loader_div">
				<div class="page-container">
					<div class="page-head">
						<div class="container">
							<!-- BEGIN PAGE TITLE -->
							<div class="page-title">
								<h1>${screenLabels.getTitleSelectGroupLabel()}</h1>
							</div>
						</div>

						<!-- BEGIN PAGE CONTENT -->
						<div class="page-content" id="page-content">
							<div class="container">


								<!-- Display Company and Fulfillment Center -->

								<div class="col-md-12">
									<div class="portlet">
										<div class="margin-left-15">
											<table width="90%">
												<tr>
													<td width="30%">
														<span class="subheader-medium-bold">${screenLabels.getCompanyLabel()}:</span>&nbsp;
														<span class="subheader-medium">${ObjCommonSession.getCompany()} &nbsp;&nbsp;
													</td>
													<td width="30%">
														<span class="subheader-medium-bold">${screenLabels.getFulfillmentCenterLabel()}:</span>&nbsp;
														<span class="subheader-medium">${ObjCommonSession.getFulfillmentCenter()} &nbsp;-&nbsp;
														${ObjCommonSession.getFulfillment_Center_Name_20()} </span>
													</td>
												</tr>
											</table>
										</div>	
									</div>
								</div>
 								<br>
								
								<div style="padding-left: 30px; padding-top: 70px;">
									<div class="row"></div>
									<button type="button" id="btnAddSequence" class="btn btn-sm green" style="margin-bottom: 10pt" onclick="addNew() ">${screenLabels.getNewGroupLabel()}</button>
								</div>
								
							</div>
						</div>
						
						
					</div>
				</div>
				<!-- END PAGE CONTENT -->
			</div>
			</div>
			</div>
		</tiles:putAttribute>
	</tiles:insertDefinition>

	<script>

	function addNew() {
		const form = document.createElement('form');
		form.method = 'GET';
		form.action = 'newGroup';

		document.body.appendChild(form);
		form.submit();
	}
	
	$( document ).ready(function() {
		var entityGrid = $(".row").data("kendoGrid");
		var rowSelect = entityGrid.select();
		console.log(rowSelect);
	});

	generateKendoGrid();
	function generateKendoGrid(){

		kendo.ui.progress($("#container"), true);
		$(".row").kendoGrid({
			selectable: "row",
		    dataBound: function() {
		    	kendo.ui.progress($("#container"), false);
		        this.tbody.on("click", "tr", function() {
		        	var grid = $(".row").data("kendoGrid");
		            var row = $(this);
		            var dataItem = grid.dataItem(row);
		            
		            
		            if (row.hasClass("k-state-selected")) {
		            	console.log(dataItem);
			            
		            	const form = document.createElement('form');
		        		form.method = 'GET';
		        		form.action = 'selectConversation';

		        		const input = document.createElement('input');
		        		input.type = 'hidden';
		                input.name = 'aiGroup';
		                input.value = dataItem["aiGroup"];
		                form.appendChild(input);

		        		document.body.appendChild(form);
		        		form.submit();
		            } else {
		            }
		        });
		    },
			sortable : {
				allowUnsort: false,  //default true, and if true, only sort twice
				mode: "single"
			},
			columns : [
				{  field : "aiGroup" , title : "${screenLabels.getGroupsLabel()}" , width : "4%", attributes: {"class": "text-align-center-justify"}},
				{  field : "description" , title : "${screenLabels.getDescriptionLabel()}" , width : "8%", attributes: {"class": "text-align-center-justify"}}
			],
			dataSource : {
				transport: {
		            read: { 
		                url : "selectGroup/read",
			            contentType : "application/json",
			            dataType : "json",
			            type : "POST"     
		            },
		            /* with the setting of serverPaging and serverSorting to true, allow to send back data towards Controller */
					// batch: true,
					parameterMap: function (data, type) {
						console.log(type, data, kendo.stringify(data));
					    return kendo.stringify(data);
					} 
		        },			
				serverPaging: true, // allow us to send page, pageSize, take and skip 
				serverSorting: true, // The current sort configuration as set via the sort option
				/* The configuration used to parse the remote service response. In this case, the response would be DataSourceResult FROM Controller */		
				schema: {
					data: "data",
				    total: "total" // total is returned in the "total" field of the response
				}
			},	
			/* loading finished, the gif animation stop */
			pageable: {
			    pageSize: 10,
			    pageSizes: true,
			    messages: {
			        itemsPerPage: "items per page"
			    },
			    buttonCount: 5
			}
			
		});
	} 

	function headerChangeLanguage(){ 
	   $.ajax({
			url: '${pageContext.request.contextPath}/HeaderLanguageChange',
			type: 'GET',
	        cache: false,
			success: function(
					data1) {

				if (data1.boolStatus) {

					location.reload();
				}
			}
		});
	}

    function headerInfoHelp(){
        $.post( "${pageContext.request.contextPath}/HeaderInfoHelp",
  			{
 				InfoHelp: 'Putwall_Put_Light_Assignments_Search_Lookup',
   				InfoHelpType: 'PROGRAM'
  		 	}, 
  		 	
  		 	function( data1,status ) {
				  if (data1.boolStatus) { window.open(data1.strMessage); }
	    	});
	  	
		}
	
	</script>
</body>

</html>