<!--
/********************** PROPERTY OF JASCI, LLC USA CORPORATION, COPYRIGHT 2015 ********************
* ALL RIGHTS RESERVED
* @Program: AI_Element_Maintenance.jsp
* @Description: it is used to Add new record or Update the record in AI Element
* @Developer: Xingji Yan
* @Date: Feb 03, 2025
** @MODIFICATIONS:
* nn. - xxxxxxxxx
* @TemplateVersion: V01
***************************************************************************************************/
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags"            prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form"       prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"              prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"         prefix="fn"%>
<%@ taglib uri="http://www.kendoui.com/jsp/tags"                prefix="kendo"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles"             prefix="tiles"%>

<c:url var="addUrl" value="/AI_Element_Maintenance_Add"/>
<c:url var="updateUrl" value="/AI_Element_Maintenance_Update_Record"/>
<c:set var="formAction" value="${isEdit ? updateUrl : addUrl}"/>

<tiles:insertDefinition name="subMenuAssigmentTemplate">
<tiles:putAttribute name="body">

<style>
    /* Keep the validation text from overlapping the hazard icon: icon on the
       left, then a gap, then the message. */
    #myForm .error,
    #myForm .error-select {
        padding-left: 22px !important;
        background-position: left center !important;
    }
    /* Space out the header info line (Company / Last Activity Date /
       Last Activity By / Element Name) so the items are not cramped. */
    #aiElmHeaderInfo label.control-label {
        margin-right: 45px;
    }
    #aiElmHeaderInfo label.control-label:last-child {
        margin-right: 0;
    }
</style>

<div class="page-head">
	<div class="container">
        <div class="page-title">
            <h1>${isEdit ? ScreenLabels.getAiElementMaintenanceEdit() : ScreenLabels.getAiElementMaintenanceHeaderNew()}</h1>
        </div>
    </div>

    <div class="page-content" id="page-content">
        <div class="container">
            <c:if test="${not empty successMessage}"><div class="note note-success"><p>${successMessage}</p></div></c:if>
            <c:if test="${not empty errorMessage}"><div class="note note-danger"><p>${errorMessage}</p></div></c:if>

            <div id="ErrorMessage" class="note note-danger CustomHide"><p id="MessageRestFull" class="error error-Top margin-left-7px"></p></div>

            <div id="aiElmHeaderInfo" class="form-group ipadmarginbottom gridbuttonpaddingbottom">
                <label class="control-label text-font-weight"><b>Company:</b>&nbsp;${ObjCommonSession.getCompany_Name_20()}</label>
                <label class="control-label text-font-weight"><b>${ScreenLabels.getAiElementMaintenanceLastActivityDate()}:</b>&nbsp;${ObjectElement.lastActivityDate}</label>
                <label class="control-label text-font-weight"><b>${ScreenLabels.getAiElementMaintenanceLastActivityBy()}:</b>&nbsp;${ObjectElement.lastActivityBy}</label>
                <label class="control-label text-font-weight"><b>${ScreenLabels.getAiElementMaintenanceElementName()}:</b>&nbsp;${ObjectElement.elementName}</label>
            </div>

            <form:form name="myForm" id="myForm" class="form-horizontal form-row-seperated"
                       action="${formAction}" method="post" modelAttribute="ObjectElement"
                       onsubmit="return SubmitRecord();">
                <input type="hidden" name="isEdit" id="isEdit" value="${isEdit}"/>

                <div class="portlet"><div class="portlet-body"><div class="tabbable"><div class="tab-content no-space"><div class="tab-pane active" id="tab_general"><div class="form-body">

                    <div class="form-group">
                        <label class="col-md-2 control-label">${ScreenLabels.getAiElementMaintenanceElementName()}:<span class="required">*</span></label>
                        <div class="col-md-10">
                            <c:choose>
                                <c:when test="${isEdit}">
                                    <input type="text" id="elementNameReadonly" class="form-controlwidth" value="${ObjectElement.elementName}" readonly/>
                                    <input type="hidden" name="elementName" id="elementName" value="${ObjectElement.elementName}"/>
                                </c:when>
                                <c:otherwise>
                                    <input type="text" name="elementName" id="elementName" class="form-controlwidth" maxlength="60" value="${ObjectElement.elementName}"/>
                                </c:otherwise>
                            </c:choose>
                            <span id="ErrorElementName" class="error"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-2 control-label">${ScreenLabels.aiElementMaintenanceApplication}:<span class="required">*</span></label>
                        <div class="col-md-10">
                            <select name="applicationId" id="applicationId" class="table-group-action-input form-control input-medium">
                                <option value="">${ScreenLabels.getAiElementMaintenanceSelect()}...</option>
                                <c:forEach items="${SelectApplications}" var="app">
                                    <option value="${app.generalCode}" ${ObjectElement.applicationId == app.generalCode ? 'selected' : ''}>${app.generalCode} - ${app.description20}</option>
                                </c:forEach>
                            </select>
                            <span id="ErrorApplication" class="error-select"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-2 control-label">${ScreenLabels.getAiElementMaintenanceElementUse()}:<span class="required">*</span></label>
                        <div class="col-md-10"><input type="text" name="elementUse" id="elementUse" class="form-controlwidth" maxlength="50" value="${ObjectElement.elementUse}"/><span id="ErrorElementUse" class="error"></span></div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-2 control-label">${ScreenLabels.getAiElementMaintenanceElementSubUse()}:</label>
                        <div class="col-md-10"><input type="text" name="elementSubUse" id="elementSubUse" class="form-controlwidth" maxlength="50" value="${ObjectElement.elementSubUse}"/></div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-2 control-label">${ScreenLabels.getAiElementMaintenanceDescriptionShort()}:<span class="required">*</span></label>
                        <div class="col-md-10"><input type="text" name="description20" id="description20" class="form-controlwidth" maxlength="20" value="${ObjectElement.description20}"/><span id="ErrorDesc20" class="error"></span></div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-2 control-label">${ScreenLabels.getAiElementMaintenanceDescriptionLong()}:<span class="required">*</span></label>
                        <div class="col-md-10"><textarea name="description500" id="description500" class="form-control form-controlwidth" rows="3" maxlength="500">${ObjectElement.description500}</textarea><span id="ErrorDesc500" class="error"></span></div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-2 control-label">${ScreenLabels.getAiElementMaintenanceExecutionPath()}:<span class="required">*</span></label>
                        <div class="col-md-10"><input type="text" name="executionPath" id="executionPath" class="form-controlwidth" maxlength="250" value="${ObjectElement.executionPath}"/><span id="ErrorExecPath" class="error"></span></div>
                    </div>

                    <div class="margin-bottom-5-right-allign Custom_AddButtons">
                        <button type="submit" class="btn btn-sm yellow filter-submit margin-bottom">Save</button>
                    </div>

                </div></div></div></div></div></div>
            </form:form>
        </div>
    </div>
</div>

</tiles:putAttribute>
</tiles:insertDefinition>

<script>
function isBlank(id){ return $.trim($('#'+id).val()).length===0; }
function equalsIgnoreCase(a,b){ return $.trim(a).toLowerCase() === $.trim(b).toLowerCase(); }
function isUrl(p){ try{ new URL(p); return true; }catch(e){ return false; } }

function SubmitRecord(){
    var ok=true;
    $('#ErrorMessage').hide();
    $('.error,.error-select').html('');

    var elementName = $('#elementName').val();
    var description20 = $('#description20').val();
    var description500 = $('#description500').val();

    if(isBlank('elementName')){ $('#ErrorElementName').html('${ScreenLabels.getAiElementMaintenanceMandatoryFieldBlank()}'); ok=false; }
    if($('#applicationId').val()===''){ $('#ErrorApplication').html('${ScreenLabels.getAiElementMaintenanceMandatoryFieldBlank()}'); ok=false; }
    if(isBlank('elementUse')){ $('#ErrorElementUse').html('${ScreenLabels.getAiElementMaintenanceMandatoryFieldBlank()}'); ok=false; }

    if(isBlank('description20')){
        $('#ErrorDesc20').html('${ScreenLabels.getAiElementMaintenanceMandatoryFieldBlank()}'); ok=false;
    }else if(equalsIgnoreCase(description20, elementName)){
        $('#ErrorDesc20').html('Description Short can not be same as Element Name'); ok=false;
    }

    if(isBlank('description500')){
        $('#ErrorDesc500').html('${ScreenLabels.getAiElementMaintenanceMandatoryFieldBlank()}'); ok=false;
    }else if(equalsIgnoreCase(description500, elementName)){
        $('#ErrorDesc500').html('Description Long can not be same as Element Name'); ok=false;
    }else if(equalsIgnoreCase(description500, description20)){
        $('#ErrorDesc500').html('Description Long can not be same as Description Short'); ok=false;
    }

    if(isBlank('executionPath')){
        $('#ErrorExecPath').html('${ScreenLabels.getAiElementMaintenanceMandatoryFieldBlank()}'); ok=false;
    }else if(!isUrl($('#executionPath').val())){
        $('#ErrorExecPath').html('${ScreenLabels.getAiElementMaintenanceExecutionPathError()}'); ok=false;
    }

    if(!ok){ window.scrollTo(0,0); }
    return ok;
}
</script>
