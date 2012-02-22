<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" pageEncoding="UTF-8" language="java" import="com.witribe.ctutil.*, customfields.*, com.portal.bas.*, com.portal.bas.comp.*, com.portal.pcm.* , com.portal.app.ccare.comp.*, Wtb.MyAccount.*, com.portal.web.comp.*, com.portal.web.*, java.net.*, java.util.*, java.text.*,java.net.*"%>
<%@taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%> 
<%@taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
//Page level local variables

String endpointString = "";
String strHouseNo = "";
String strStreet = "";
String strZone = "";
String strCity = "";
String strTask = "";

String sResult1 = "";
String sResult2 = "";
String strLongitude = "";
String strLatitude = "";
String covStatus = "";
String sla = "";
String scoOrdinates = "";
double x=0.00;
double y=0.00;
String sx = "";
String sy = "";
boolean proceed = false;
double usbCoverage = 0.0;
double indoorCoverage = 0.0;
double outdoorCoverage = 0.0;
String susbCoverage = "";
String sindoorCoverage = "";
String soutdoorCoverage = "";
String arrCoOrdinates[] = null;
String arrResult2[] = null;
String cvgType = "";
String result;
String sCVGStatus = "";
String dCVGStatus = "";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>        
        <%@ include file="includes/headinc.jsp" %>
        <%@ include file="includes/ClientCode.jsp" %>
        <script src="js/jquery/jquery.js" type="text/javascript" language="javascript"></script>
        <script src="js/jquery/ui.core.js" type="text/javascript" language="javascript"></script>
        <link href="css/Stylesstyle.css" rel="stylesheet" type="text/css">
        <script language="javascript" src="js/xmlPost.js" type="text/javascript"></script>
        <script language="javascript" src="js/xmlGet.js" type="text/javascript"></script>
        <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAaNcmKM0QttFysMz8uw35sxQzB10VroHqKjktk46NizRkuHodLxQUFqIHJFDSnzmXFekHUxqfYU0ZvQ" type="text/javascript"></script>
        <script src="http://serverapi.arcgisonline.com/jsapi/gmaps/?v=1.3" type="text/javascript" ></script>
        <script language="javascript" type="text/javascript" src="js/witribescript.js"></script>
        
    </head>
    <SCRIPT>
        var ipAddress = "115.167.72.8";
var token ="U6Y7oqEpm8jHzb13-pd2mAL5FGlixRKJQA7BpNREoQn1YU6toIMmaTu3CmgP19EQDjhkGG64RSObwD_gT07DDw..";
        function createRequestObject(){
    var req;
    if(window.XMLHttpRequest){
        //For Firefox, Safari, Opera
        req = new XMLHttpRequest();
    }
    else if(window.ActiveXObject){
        //For IE 5+
        req = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else{
        //Error for an old browser
        alert('Your browser is not IE 5 or higher, or Firefox or Safari or Opera');
    }
    return req;
}
function IsNonNumericNumbers(value) {
    var numberFilter=/^\d{0,}\.\d{0,}$/;
    return(numberFilter.test(value));
}
 function formSubmit1(actionName){
 
 if(ResultType == 'AUTO') {
    document.locater.action=actionName;
    document.locater.submit();
 }
 else{
        $('p.validationmsg').hide();
        //alert("In else");
        content="locate_div";
	clearGetSpan();
       
	if((document.manualaddress.HouseNo.value) == '') {
            showMessage(document.manualaddress.HouseNo, "Please enter plot no.");
            return;
        }
        if((document.manualaddress.Street.value) == '') {
            showMessage(document.manualaddress.Street, "Please enter street.");
            return;
        }
        if((document.manualaddress.City.value) == '') {
            showMessage(document.manualaddress.City, "Please enter City.");
            return;
        }
        if((document.manualaddress.Zone.value) == '') {
            showMessage(document.manualaddress.Zone, "Please enter sector.");
            return;
        }
       /* if((document.manualaddress.x.value) == '') {
            showMessage(document.manualaddress.x, "Please enter latitude.");
            return;
        } else if(!IsNonNumericNumbers(document.manualaddress.x.value)){
            showMessage(document.manualaddress.x, "Please enter valid latitude.");
            return;
        }
        if((document.manualaddress.y.value) == '') {
            showMessage(document.manualaddress.y, "Please enter longitude.");
            return;
        } else if(!IsNonNumericNumbers(document.manualaddress.y.value)){
            showMessage(document.manualaddress.y, "Please enter valid longitude.");
            return;
        }*/

        document.locater.action=actionName;
        document.locater.submit();
     }
  }
 function formSubmitAccount1(actionName){
  
    //validateCTForm(document.locater);
    if(ResultType == 'AUTO') {
    document.locater.city.value = document.address.City.value;
    document.locater.state.value = document.address.state.value;
    document.locater.zone.value = document.address.Zone.value;
    document.locater.street.value = document.address.Street.value;
    document.locater.plot.value = document.address.HouseNo.value;
    document.locater.latitude.value = document.locater.y.value;
    document.locater.longitude.value = document.locater.x.value;
    // Added by Swapna for Coverage_type null issue (March25th)
    document.locater.coverage_type.value = document.locater.coverage.value;
    // End
    }
    else{
    document.locater.city.value = document.manualaddress.City.value;
    document.locater.state.value = document.manualaddress.state.value;
    document.locater.zone.value = document.manualaddress.Zone.value;
    document.locater.street.value = document.manualaddress.Street.value;
    document.locater.plot.value = document.manualaddress.HouseNo.value;
    document.locater.latitude.value = document.manualaddress.y.value;
    document.locater.longitude.value = document.manualaddress.x.value;
     // Added by Swapna for Coverage_type null issue (March25th)
    document.locater.coverage_type.value = document.locater.coverage.value;
    // End
    }

  
	  formSubmit1(actionName);
  
                 
  }

function mcallBack()
{
	gcallbackfunc=null;
	content=null;
}

function search_address()
{
	$('p.validationmsg').hide();
        content="search_results_div";
	clearGetSpan();
	gcallbackfunc="mcallBack()";
	customGetText("<img src='images/loading.gif' border=0> searching address ...");
	plot_no=document.address.HouseNo.value;
	road_no=document.address.Street.value;
	sector=document.address.Zone.value;
	City=document.address.City.value;
	getstr = "?HouseNo="+plot_no+"&Street="+road_no+"&Zone="+sector+"&City="+City;
	makeRequest('coverage/search.php', getstr);				
}

function showMessageDiv(field, msg) {
    $(field).parent('div').find('p.validationmsg').html(msg).show('slow');
    field.setfocus();
}
var l_lat;
var l_lng;
function locate(leadId)
{
	content="locate_div";
        $('p.validationmsg').hide();
	if(document.address.City.options[document.address.City.selectedIndex].value == 'Select') {
            showMessage(document.address.City, "Please select city.");
            return;
        }
	if(document.address.Zone.options[document.address.Zone.selectedIndex].value == 'Select') {
            showMessageDiv(document.address.Zone, "Please select sector.");
            return;
        }
	if(document.address.Street.options[document.address.Street.selectedIndex].value == 'Select') {
            showMessageDiv(document.address.Street, "Please select Street.");
            return;
        }
	if(document.address.HouseNo.options[document.address.HouseNo.selectedIndex].value == 'Select') {
            showMessageDiv(document.address.HouseNo, "Please select plot.");
            return;
        }
        
        clearGetSpan();
        var url;
	gcallbackfunc="show_map()";
	customGetText("<img src='images/loading.gif' border=0> locating address ...");
	plot_no=trimString(document.address.HouseNo.value);
	road_no=trimString(document.address.Street.value);
        block=trimString(document.address.Block.value);
	subzone=trimString(document.address.SubZone.value);
        sector=trimString(document.address.Zone.value);
        City=trimString(document.address.City.value);
       // Commented by swapna 
//Lahore Coverage chk added by satya
        /*if(City == "Lahore"){
            if(road_no == 'NUN'){
             url = "LahoreApiCall.jsp?q=hl&city=lahore&scheme="+sector+"&phase="+subzone+"&block="+block+"&house="+plot_no;
            }else{
             url = "LahoreApiCall.jsp?q=hl&city=lahore&scheme="+sector+"&phase="+subzone+"&block="+block+"&street="+road_no+"&house="+plot_no;
            }
            getstr = "HouseNo="+plot_no+"&Street="+road_no+"&Zone="+sector+"&City="+City+"&leadId="+leadId;
        
            http.open("POST", url , true );
            http.onreadystatechange = handleCoverageResponseLahoreLatLng;
            http.send();
              ResultType = "AUTO";         
        }else{ */
	gc = plot_no+","+road_no+","+sector+","+City;
	//alert(gc);
		getstr = "HouseNo="+plot_no+"&Street="+road_no+"&Zone="+sector+"&City="+City+"&leadId="+leadId;
        var url = "CTCheckStatus.jsp";
        
        http.open("POST", url , true);
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", getstr.length);
        http.setRequestHeader("Connection", "close");
        http.onreadystatechange = handleCoverageResponse;
        handler = "";
        http.send(getstr);
        ResultType = "AUTO";
	//}
}
function locatemanualvalidation()
{
        if((document.manualaddress.HouseNo.value) == '') {
            showMessage(document.manualaddress.HouseNo, "Please enter plot no.");
            return false;
        }
        if((document.manualaddress.Street.value) == '') {
            showMessage(document.manualaddress.Street, "Please enter street.");
            return false;
        }
        if((document.manualaddress.Zone.value) == '') {
            showMessage(document.manualaddress.Zone, "Please enter sector.");
            return false;
        }
        if((document.manualaddress.City.value) == '') {
            showMessage(document.manualaddress.City, "Please select city.");
            return false;
        }
    
}
function locatemanual()
{
	$('p.validationmsg').hide();
        content="locate_div";
	clearGetSpan();
	if((document.manualaddress.HouseNo.value) == '') {
            showMessage(document.manualaddress.HouseNo, "Please enter plot no.");
            return;
        }
        if((document.manualaddress.Street.value) == '') {
            showMessage(document.manualaddress.Street, "Please enter street.");
            return;
        }
        if((document.manualaddress.Zone.value) == '') {
            showMessage(document.manualaddress.Zone, "Please enter sector.");
            return;
        }
        if((document.manualaddress.City.value) == '') {
            showMessage(document.manualaddress.City, "Please select city.");
            return;
        }
        if((document.manualaddress.x.value) == '') {
            showMessage(document.manualaddress.x, "Please enter longitude.");
            return;
        } else if(!IsNonNumericNumbers(document.manualaddress.x.value)){
            showMessage(document.manualaddress.x, "Please enter valid longitude.");
            return;
        }
        if((document.manualaddress.y.value) == '') {
            showMessage(document.manualaddress.y, "Please enter latitude.");
            return;
        } else if(!IsNonNumericNumbers(document.manualaddress.y.value)){
            showMessage(document.manualaddress.y, "Please enter valid latitude.");
            return;
        }
        
        
        gcallbackfunc="show_map()";
	customGetText("<img src='images/loading.gif' border=0> locating address ...");
	plot_no=document.manualaddress.HouseNo.value;
	road_no=document.manualaddress.Street.value;
	City=document.manualaddress.City.value;
        block = '';
        subzone='';
	sector=document.manualaddress.Zone.value;
	x = document.manualaddress.x.value;
        y = document.manualaddress.y.value;
        // Commented by Swapna
//Lahore Coverage chk Added by satya
      /* if(City == "Lahore"){
        url = "LahoreApiCall.jsp?q=IsAreaCoveredByLatLng&lat="+x+"&lng="+y;
        http.open("POST", url , true );
        http.onreadystatechange = handleCoverageResponseLahoreManual;
        http.send();  
        ResultType = "MANUAL";
     }else{ */
	gc = plot_no+","+road_no+","+sector+","+City;
	//alert(gc);
	getstr = "HouseNo="+plot_no+"&Street="+road_no+"&Zone="+sector+"&City="+City+"&query=manual&x="+x+"&y="+y;
        var url = "CTCheckStatus.jsp";
        
        http.open("POST", url , true);
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", getstr.length);
        http.setRequestHeader("Connection", "close");
        http.onreadystatechange = handleCoverageResponse;
        handler = "";
        http.send(getstr);
        ResultType = "MANUAL";
	//}
}
// Commented by Swapna
//Lahore response functions added by satya 
/*function handleCoverageResponseLahoreLatLng() {
     $('p.validationmsg').hide();
     //alert("hi");
    var url;
     if(http.readyState == 4 && http.status == 200) {       
        var response = http.responseText;
        //alert(response);        
        var op = response.split(",");        
        for(i=0; i<3;i++) {
            op[i] = op[i].replace("<strong>","");
            op[i] = op[i].replace("</strong>","");
            op[i] = op[i].slice(op[i].indexOf('(') + 1 , op[i].indexOf('%'));
            //alert(op[i]);
        }
        l_lat = '31.'+ parseInt(trimString(op[0])*7);
	l_lng = '74.'+parseInt(trimString(op[1])*3);
        x = l_lat;
        y = l_lng;
        lahoreZooom = trimString(op[2]);
        if(road_no == 'NUN'){
         url = "LahoreApiCall.jsp?q=IsAreaCoveredByGeoCodeAddress&city=lahore&scheme="+sector+"&phase="+subzone+"&block="+block+"&house="+plot_no;
        }else{
         url = "LahoreApiCall.jsp?q=IsAreaCoveredByGeoCodeAddress&city=lahore&scheme="+sector+"&phase="+subzone+"&block="+block+"&street="+road_no+"&house="+plot_no;
        }
        http.open("POST", url , true );
        http.onreadystatechange = handleCoverageResponseLahore;
        http.send();
      }
}
function handleCoverageResponseLahore() {
     $('p.validationmsg').hide();
    if(http.readyState == 4 && http.status == 200) {
       
        var response = http.responseText;
        //alert("response"); 
        var op = response.split("#");        
        for(i=0; i<3;i++) {
            op[i] = op[i].replace("<strong>","");
            op[i] = op[i].replace("</strong>","");
            op[i] = op[i].slice(op[i].indexOf('(') + 1 , op[i].indexOf('%'));
            //alert(op[i]);
        }
        //x=l_lat;
        //y=l_lng;
        //alert(x);
        //alert(y);
        getstr = "HouseNo="+plot_no+"&Street="+road_no+"&block="+block+"&SubZone="+subzone+"&Zone="+sector+"&City="+City+"&x="+x+"&y="+y+"&USB="+op[0]+"&INDOOR="+op[1]+"&OUTDOOR="+op[2];
        var url = "CTCheckStatusLahore.jsp";
        //alert(url);
        http.open("POST", url , true);
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", getstr.length);
        http.setRequestHeader("Connection", "close");
        http.onreadystatechange = handleCoverageResponse;
        handler = "";
        http.send(getstr);
      }
}
function handleCoverageResponseLahoreManual() {
     $('p.validationmsg').hide();
    if(http.readyState == 4 && http.status == 200) {
       var url;
        var response = http.responseText;
        //alert(response); 
        var op = response.split(";");        
        for(i=0; i<3;i++) {
            op[i] = op[i].replace("<strong>","");
            op[i] = op[i].replace("</strong>","");
            op[i] = op[i].slice(op[i].indexOf('(') + 1 , op[i].indexOf('%'));
            //alert(op[i]);
        }
        //x=l_lat;
        //y=l_lng;
        //alert(x);
        //alert(y);
        getstr = "HouseNo="+plot_no+"&Street="+road_no+"&block="+block+"&SubZone="+subzone+"&Zone="+sector+"&City="+City+"&x="+x+"&y="+y+"&USB="+op[0]+"&INDOOR="+op[1]+"&OUTDOOR="+op[2];
        url = "CTCheckStatusLahore.jsp";
        http.open("POST", url , true);
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", getstr.length);
        http.setRequestHeader("Connection", "close");
        http.onreadystatechange = handleCoverageResponse;
        handler = "";
        http.send(getstr);
      }
}
*/
// End by Swapna
function locatemanualformap(lat,lon)
{
    document.manualaddress.y.value = lon;
    document.manualaddress.x.value = lat;
    locatemanual();
/*	     alert(lat);
             alert(lon);
             $('p.validationmsg').hide();
        content="locate_div";
	clearGetSpan();
        gcallbackfunc="show_map()";
	//customGetText("<img src='images/loading.gif' border=0> locating address ...");
	var plot_no="";//=document.manualaddress.HouseNo.value;
	var road_no=""; //document.manualaddress.Street.value;
	var sector=""; //document.manualaddress.Zone.value;
	var City="";//document.manualaddress.City.value;
        x = lat;
        y = lon;
	gc = plot_no+","+road_no+","+sector+","+City;
	//alert(gc);
	getstr = "HouseNo="+plot_no+"&Street="+road_no+"&Zone="+sector+"&City="+City+"&query=manual&x="+x+"&y="+y;
        var url = "CTCheckStatus.jsp";
        
        http.open("POST", url , true);
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", getstr.length);
        http.setRequestHeader("Connection", "close");
        http.onreadystatechange = handleCoverageResponse;
        handler = "";
        http.send(getstr);
        ResultType = "MANUAL";*/
}
function handleCoverageResponse() {
    $('p.validationmsg').hide();
    
    if(http.readyState == 4 && http.status == 200) {
    document.getElementById("buttons").style.display = 'none';
        customGetText("");
        var response = http.responseText;
        document.getElementById("locate_div").innerHTML = response;
        show_map();
        
     }
}

function locate_poi()
{
    $('p.validationmsg').hide();
    content="locate_div";
	clearGetSpan();
	gcallbackfunc="mcallBack()";
    customGetText(" locating address ...");
	gc = plot_no+","+road_no+","+sector+","+City;
    getstr = "?address="+gc;
}

function clearDropDownList(theDropDown)
{
    $('p.validationmsg').hide();
     var numberOfOptions = theDropDown.options.length;
     for (i=0; i<numberOfOptions; i++)
     {
          //Note: Always remove(0) and NOT remove(i)
          theDropDown.remove(0)
    }
}

var http = createRequestObject(); 
var handler = "";
var ResultType = "";
//added by satya
function GetLabels(City){
    $('p.validationmsg').hide();
        clearDropDownList(document.address.Zone);
        clearDropDownList(document.address.SubZone);
        clearDropDownList(document.address.Block);
	clearDropDownList(document.address.Street);
	clearDropDownList(document.address.HouseNo);
      // Commented by Swapna    
       /* if(City == 'Lahore') {           
            document.getElementById('lahore_msubzone').style.visibility="visible";
            document.getElementById('lahore_msubzone').style.visibility="visible";
            document.getElementById('lblSector').innerHTML = "Schemes";
            document.getElementById('lahore_mblock').style.visibility="visible";
            document.getElementById('lblmStreet').innerHTML = "Streets";
            document.getElementById('lblPlot').innerHTML = "Houses";
        }else{ */
            document.getElementById('lahore_msubzone').style.visibility="hidden";
            document.getElementById('lahore_mblock').style.visibility="hidden";
            document.getElementById('lblSector').innerHTML = "Sector";
            document.getElementById('lblmStreet').innerHTML = "Street / Category";
            document.getElementById('lblPlot').innerHTML = "Plot No / Name";
       // }
}

function GetZones(City)
{

        $('p.validationmsg').hide();
	//clearDropDownList(document.address.Zone);
	//clearDropDownList(document.address.Street);
	//clearDropDownList(document.address.HouseNo);
       // alert(document.address.City.options[document.address.City.selectedIndex].title);
        document.address.state.value=document.address.City.options[document.address.City.selectedIndex].title;
	content="zone_div";
        //alert("zones");
	clearGetSpan();
	gcallbackfunc="mcallBack()";
	customGetText("<img src='images/loading.gif' border=0> locating address ...");
	getstr = "City="+City + "&ReqFor=1";
	//makeRequest('CTSupport.jsp', getstr);
        // Commented By Swapna
         //code added by satya
      /*  if(City == 'Lahore') {
            
            document.getElementById('lahore_subzone').style.display="";
            document.getElementById('lahore_block').style.display="";
            document.getElementById('lblZone').innerHTML = "Schemes";
            document.getElementById('lblStreet').innerHTML = "Streets";
            document.getElementById('lblHouseno').innerHTML = "Houses";
            var url = "LahoreApiCall.jsp?q=GetSchemes&city=lahore";
            //alert("satya");
            http.open("POST", url , true );
            //alert("Opend in lahore");
            http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            http.setRequestHeader("Content-length", getstr.length);
            http.setRequestHeader("Connection", "close");
            http.onreadystatechange = handleSchemesResponse;
            handler = "1";
            http.send();
         } else { */
         
            document.getElementById('lahore_subzone').style.display="none";
            document.getElementById('lahore_block').style.display="none";
            document.getElementById('lblZone').innerHTML = "Sector";
            document.getElementById('lblStreet').innerHTML = "Street / Category";
            document.getElementById('lblHouseno').innerHTML = "Plot No / Name";
            var url = "CTSupport.jsp";
           //alert(url);
            http.open("POST", url , true);
            
            http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            http.setRequestHeader("Content-length", getstr.length);
            http.setRequestHeader("Connection", "close");
            http.onreadystatechange = handleZonesResponse;
            handler = "1";
            http.send(getstr);
       // }
}
function handleZonesResponse() {
    $('p.validationmsg').hide();
    var ResultString = "";
    if(http.readyState == 4 && http.status == 200) {
        customGetText("");
        var response = http.responseText;
        //alert("response");
        if(response.indexOf("Exception:") < 0) {
            var arrZones = response.split(";");
            ResultString = "<select class='selectbox' name='Zone' onchange='javascript: GetStreets(this.value);'>"
            ResultString = ResultString + "<option value='Select'>Select  </option>";
            for(i=0; i< arrZones.length; i++) { 
                //arrZones[i] = trimString(arrZones[i]);
                //if(arrZones[i] != "")
                    ResultString = ResultString + "<option value='" + arrZones[i] + "'>" + arrZones[i] + "</option>";
            }
            ResultString = ResultString + "</select> <p class=validationmsg></p>";
        } else {
            ResultString = "Error: Try again.";
        }
        document.getElementById("zone_div").innerHTML = ResultString;
     }
        
}
//function added by satya
 function handleSchemesResponse() {
    $('p.validationmsg').hide();
    var ResultString = "";
    if(http.readyState == 4 && http.status == 200) {
        customGetText("");
        var response = http.responseText;
        //alert("response");
        if(response.indexOf("Exception:") < 0) {
            var arrZones = response.split(";");
            ResultString = "<select class='selectbox' name='Zone' onchange='javascript: GetPhases(this.value);'>"
            ResultString = ResultString + "<option value='Select'>Select  </option>";
            for(i=0; i< arrZones.length; i++) { 
                //arrZones[i] = trimString(arrZones[i]);
                //if(arrZones[i] != "")
                    ResultString = ResultString + "<option value='" + arrZones[i] + "'>" + arrZones[i] + "</option>";
            }
            ResultString = ResultString + "</select> <p class=validationmsg></p>";
        } else {
            ResultString = "Error: Try again.";
        }
        document.getElementById("zone_div").innerHTML = ResultString;
     }
        
}
//function added by satya
function GetPhases(scheme)
{
    $('p.validationmsg').hide();
    clearDropDownList(document.address.HouseNo);
    City = document.address.City.value;
    
    content="subzone_div";
    clearGetSpan();
    
    gcallbackfunc="mcallBack()";
    customGetText("<img src='images/loading.gif' border=0> locating address ...");
    var url = "LahoreApiCall.jsp?q=GetPhases&city=lahore&scheme="+scheme;
    http.open("POST", url , true);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.setRequestHeader("Content-length", getstr.length);
    http.setRequestHeader("Connection", "close");
    http.onreadystatechange = handlePhasesResponse;
    handler = "1";
    http.send();
}
//function added by satya
function handlePhasesResponse() {
    $('p.validationmsg').hide();
    var ResultString = "";
    if(http.readyState == 4 && http.status == 200) {
        customGetText("");
        var response = http.responseText;
        //alert(response);
        if(response.indexOf("Exception:") < 0) {
            var arrZones = response.split(";");
            ResultString = "<select class='selectbox' name='SubZone' onchange='javascript: GetBlocks(this.value);'>"
            ResultString = ResultString + "<option value='Select'>Select  </option>";
            for(i=0; i< arrZones.length; i++) { 
                //arrZones[i] = trimString(arrZones[i]);
                //if(arrZones[i] != "")
                    ResultString = ResultString + "<option value='" + arrZones[i] + "'>" + arrZones[i] + "</option>";
            }
            ResultString = ResultString + "</select> <p class=validationmsg></p>";
        } else {
            ResultString = "Error: Try again.";
        }
        document.getElementById("subzone_div").innerHTML = ResultString;
     }
        
}
function GetBlocks(phase)
{
    $('p.validationmsg').hide();
    clearDropDownList(document.address.HouseNo);
    City = document.address.City.value;        
    zone = document.address.Zone.value; 
    
    content="block_div";
    clearGetSpan();
    
    gcallbackfunc="mcallBack()";
    customGetText("<img src='images/loading.gif' border=0> locating address ...");
    var url = "LahoreApiCall.jsp?q=GetBlocks&city=lahore&scheme="+zone+"&phase="+phase;
    http.open("POST", url , true );
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.setRequestHeader("Content-length", getstr.length);
    http.setRequestHeader("Connection", "close");
    http.onreadystatechange = handleBlocksResponse;
    handler = "1";
    http.send();
}

function handleBlocksResponse() {
    $('p.validationmsg').hide();
    var ResultString = "";
    if(http.readyState == 4 && http.status == 200) {
        customGetText("");
        var response = http.responseText;
        //alert(response);
        if(response.indexOf("Exception:") < 0) {
            var arrBlocks = response.split(";");
            ResultString = "<select class='selectbox' name='Block' onchange='javascript: GetStreets(this.value);'>"
            ResultString = ResultString + "<option value='Select'>Select  </option>";
            for(i=0; i< arrBlocks.length; i++) { 
                //arrStreets[i] = trimString(arrStreets[i]);
                //if(arrStreets[i] != "")
                    ResultString = ResultString + "<option value='" + arrBlocks[i] + "'>" + arrBlocks[i] + "</option>";
            }
            ResultString = ResultString + "</select><p class=validationmsg></p>";
        } else {
            ResultString = "Error: Try again.";
        }
        //alert(ResultString);
        document.getElementById("block_div").innerHTML = ResultString;
     }
        
}
function GetStreets(block)
{
    $('p.validationmsg').hide();
    clearDropDownList(document.address.HouseNo);
    City = document.address.City.value;    
    zone = document.address.Zone.value;
    subzone = document.address.SubZone.value;
   
      
    content="street_div";
    clearGetSpan();
    gcallbackfunc="mcallBack()";
    customGetText("<img src='images/loading.gif' border=0> locating address ...");
   
    getstr = "City="+City+"&Zone="+zone+"&ReqFor=2";
// Commented By Swapna
    //code added by satya
   /* if(City == "Lahore"){
        var url = "LahoreApiCall.jsp?q=GetStreets&city=lahore&scheme="+zone+"&phase="+subzone+"&block="+block;
        http.open("POST", url , true );
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", getstr.length);
        http.setRequestHeader("Connection", "close");
        http.onreadystatechange = handleStreetsResponse;
        handler = "1";
        http.send();
    }else{ */
        var url = "CTSupport.jsp";
        http.open("POST", url , true);
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", getstr.length);
        http.setRequestHeader("Connection", "close");
        http.onreadystatechange = handleStreetsResponse;
        handler = "";
        http.send(getstr);
   // }
    
}
function handleStreetsResponse() {
    $('p.validationmsg').hide();
    var ResultString = "";
    if(http.readyState == 4 && http.status == 200) {
        customGetText("");
        var response = http.responseText;
        if(response.indexOf("Exception:") < 0) {
            var arrStreets = response.split(";");
            ResultString = "<select class='selectbox' name='Street' onchange='javascript: GetHouses(this.value);'>"
            ResultString = ResultString + "<option value='Select'>Select  </option>";
            for(i=0; i< arrStreets.length; i++) { 
                //arrStreets[i] = trimString(arrStreets[i]);
                //if(arrStreets[i] != "")
                    ResultString = ResultString + "<option value='" + arrStreets[i] + "'>" + arrStreets[i] + "</option>";
            }
            ResultString = ResultString + "</select><p class=validationmsg></p>";
        } else {
            ResultString = "Error: Try again.";
        }
        document.getElementById("street_div").innerHTML = ResultString;
     }
        
}

function GetHouses(street)
{
$('p.validationmsg').hide();
City = trimString(document.address.City.value);
zone = trimString(document.address.Zone.value);
subzone = trimString(document.address.SubZone.value);
block =  trimString(document.address.Block.value);
var url;
content="house_div";
clearGetSpan();
gcallbackfunc="mcallBack()";
customGetText("<img src='images/loading.gif' border=0> locating address ...");   
 getstr = "City="+City+"&Zone="+zone+"&Street="+street+"&ReqFor=3";
 //code added by satya
 // Commented By Swapna
/* if(City == "Lahore"){
    customGetText("<img src='images/loading.gif' border=0> locating address ...");    
    street = trimString(street);
    if(street == 'NUN'){
         url = "LahoreApiCall.jsp?q=GetHouses&city=lahore&scheme="+zone+"&phase="+subzone+"&block="+block;
    }else{
         url = "LahoreApiCall.jsp?q=GetHouses&city=lahore&scheme="+zone+"&phase="+subzone+"&block="+block+"&street="+street;
    }
    http.open("POST", url , true );
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.setRequestHeader("Content-length", getstr.length);
    http.setRequestHeader("Connection", "close");
    http.onreadystatechange = handlePlotResponse;
    handler = "1";
    http.send();
 }else{ */
    var url = "CTSupport.jsp";
    http.open("POST", url , true);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.setRequestHeader("Content-length", getstr.length);
    http.setRequestHeader("Connection", "close");
    http.onreadystatechange = handlePlotResponse;
    handler = "";
    http.send(getstr);				
  //}
}

function handlePlotResponse() {
    $('p.validationmsg').hide();
    var ResultString = "";
    if(http.readyState == 4 && http.status == 200) {
        customGetText("");
        var response = http.responseText;
        
        if(response.indexOf("Exception:") < 0) {
            var arrHouse = response.split(";");
            ResultString = "<select class='selectbox' name='HouseNo' onchange='javascript:locate(<%=request.getParameter("leadId")%>);' >"
            ResultString = ResultString + "<option value='Select'>Select  </option>";
            for(i=0; i< arrHouse.length; i++) { 
                //arrHouse[i] = trimString(arrHouse[i]);
                //if(arrHouse[i] != "")
                    ResultString = ResultString + "<option value='" + arrHouse[i] + "'>" + arrHouse[i] + "</option>";
            }
            ResultString = ResultString + "</select><p class=validationmsg></p>";
        } else {
            ResultString = "Error: Try again.";
        }
        document.getElementById("house_div").innerHTML = ResultString;
     }
        
}

var x,y,gcG;
var map="nullV";
var urlAd;

function show_map()
{

    $('p.validationmsg').hide();
	gc=document.address.HouseNo.value+","+document.address.Street.value+","+document.address.Zone.value+","+document.address.City.value;
        // Commented By Swapna
       /* if(document.address.City.value == 'Lahore') {
            document.locater.coordinates.value = l_lat + ',' + l_lng;
            coord = document.locater.coordinates.value;
            x = l_lat;
            y = l_lng;
            
        }
        else */
            coord = document.locater.coordinates.value;
            
	coverage_value = document.locater.coverage_value.value;
	xy = coord.split(',');
	x = xy[0];
	y = xy[1];
	gcG = gc;
       // Commented By Swapna
       /* if(document.address.City.value == 'Lahore') {
           initGMap(x,y,18);
        } else { */
	initialize();
       // }
}

function initGMap(lat,lng,zoom){
    	if (GBrowserIsCompatible()) {
 
 		var  mapTypes = [G_NORMAL_MAP,G_HYBRID_MAP,G_SATELLITE_MAP,G_SATELLITE_3D_MAP];
		for(var i = 0; i < mapTypes.length; i++){
			mapTypes[i].getMaximumResolution = function(latlng){ return 18;};
			mapTypes[i].getMinimumResolution = function(latlng){ return 1;};
		}
        //map = new GMap2(document.getElementById("map_canvas"), {mapTypes: mapTypes});
		
		
		//var  mapTypes = [G_NORMAL_MAP,G_HYBRID_MAP,G_SATELLITE_MAP];
		map = new GMap2(document.getElementById("map_canvas"),{mapTypes:mapTypes});
		map.addControl(new GMapTypeControl());
		map.addControl(new GLargeMapControl());
		map.enableContinuousZoom();
		map.enableDoubleClickZoom();
		
		map.setMapType(G_HYBRID_MAP);
		map.enableScrollWheelZoom();
		
		
		if(zoom==12){
			map.setCenter(new GLatLng(31.4869428108,74.325256347), zoom);
			alert("NOT FOUND");
		}
		else
		{
			var l_lat = lat;
			var l_lng = lng;
			
			
			var l_point = new GLatLng(parseFloat(l_lat),parseFloat(l_lng));
			
			
			map.setCenter(l_point, zoom);
			var marker = new GMarker(l_point);
			map.addOverlay(marker);
		}

    }
  }//end function

/*function swapKML()
{
    var dynamicMap = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://10.1.82.11/ArcGIS/rest/services/Coverage/MapServer",null,0.45,dynmapcallback);
		
}

function swapUSBCoverage()
{
    //var dynamicMap15 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://10.1.82.11/ArcGIS/rest/services/USBCoverage/MapServer",null,0.45,dynmapcallback15);
    var token = 6QWnlW4UAFC1kLLI__Ahy7FJpfIv825jdWApGBda6Ecx-2lmbLS4L1aEftJwfcb7rR2iFnmHkDey0ewEzpfxqg..;
    var Host = 115.167.72.8;
    var dynamicMap15 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://"+Host+"/ArcGIS/rest/services/USBCoverage/MapServer?token="+token,null,0.45,dynmapcallback15);
		
}

function swapOutDoorCoverage()
{
    //var dynamicMap5 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://10.1.82.11/ArcGIS/rest/services/OutDoorCoverage/MapServer",null,0.45,dynmapcallback5);
    var token = 6QWnlW4UAFC1kLLI__Ahy7FJpfIv825jdWApGBda6Ecx-2lmbLS4L1aEftJwfcb7rR2iFnmHkDey0ewEzpfxqg..;
    var Host = 115.167.72.8;
   var dynamicMap9 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://"+Host+"/ArcGIS/rest/services/InDoorCoverage/MapServer?token="+token,null,0.45,dynmapcallback9);// Changed by swapna
}

function swapInDoorCoverage()
{
    //var dynamicMap9 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://10.1.82.11/ArcGIS/rest/services/InDoorCoverage/MapServer",null,0.45,dynmapcallback9);
    var token = 6QWnlW4UAFC1kLLI__Ahy7FJpfIv825jdWApGBda6Ecx-2lmbLS4L1aEftJwfcb7rR2iFnmHkDey0ewEzpfxqg..;
    var Host = 115.167.72.8;
    var dynamicMap9 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://"+Host+"/ArcGIS/rest/services/InDoorCoverage/MapServer?token="+token,null,0.45,dynmapcallback9);// Changed by swapna
}

function swapRoadsKML()
{
    var dynamicMap2 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://10.1.82.11/ArcGIS/rest/services/IsbRoads/MapServer",null,0.80,dynmapcallback2);
    var dynamicMap3 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://10.1.82.11/ArcGIS/rest/services/PakistanRoads/MapServer",null,0.80,dynmapcallback3);
}

function swapZonesKML()
{
    var dynamicMap4 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://10.1.82.11/ArcGIS/rest/services/PakistanZones/MapServer",null,1.0,dynmapcallback4);
}

function swapSitePoints() 
{ 
    var dynamicPoint =  
    new  esri.arcgis.gmaps.DynamicMapServiceLayer("http://115.167.72.11/ArcGIS/rest/services/CoverageSitePoints/MapServer",null,1.0,dynmapCallSite); 
                
} */

// Added by Swapna for Coverage Layer change

function swapKML()
{
    var dynamicMap = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://"+ipAddress+"/As/Coverage/MapServer?token="+token,null,0.45,dynmapcallback);
		
}

function swapUSBCoverage()
{
    var dynamicMap15 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://"+ipAddress+"/ArcGIS/rest/services/USBCoverage/MapServer?token="+token,null,0.45,dynmapcallback15);
		
}

function swapOutDoorCoverage()
{
    var dynamicMap5 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://"+ipAddress+"/ArcGIS/rest/services/OutDoorCoverage/MapServer?token="+token,null,0.45,dynmapcallback5);
}

function swapInDoorCoverage()
{
    var dynamicMap9 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://"+ipAddress+"/ArcGIS/rest/services/InDoorCoverage/MapServer?token="+token,null,0.45,dynmapcallback9);
}

function swapRoadsKML()
{
    var dynamicMap2 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://"+ipAddress+"/ArcGIS/rest/services/IsbRoads/MapServer?token="+token,null,0.80,dynmapcallback2);
    var dynamicMap3 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://"+ipAddress+"/ArcGIS/rest/services/PakistanRoads/MapServer?token="+token,null,0.80,dynmapcallback3);
}

function swapZonesKML()
{
    var dynamicMap4 = new esri.arcgis.gmaps.DynamicMapServiceLayer("http://"+ipAddress+"/ArcGIS/rest/services/PakistanZones/MapServer?token="+token,null,1.0,dynmapcallback4);
}
function swapSitePoints() 
{ 
		var dynamicPoint =  
		new  esri.arcgis.gmaps.DynamicMapServiceLayer("http://"+ipAddress+"/ArcGIS/rest/services/CoverageSitePoints/MapServer?token="+token,null,1.0,dynmapCallSite); 
                
} 

// end by swapna

function initialize()
{
    //alert('Called');
 
	if (GBrowserIsCompatible())
	{
		//alert(map);
		if(map=="nullV"){
		map = new GMap2(document.getElementById("map_canvas"));
			map.enableScrollWheelZoom();
		
		GEvent.addListener(map,'zoomend',function(){
 
				zooming();
 
			});
		
		var zoomlvl = 18;
		if(document.address.Zone.value==""){
			zoomlvl=13;
		}else if(document.address.Street.value==""){
			zoomlvl=15;		
		}else if(document.address.HouseNo.value==""){
			zoomlvl=16;
		}else{
			zoomlvl=18;
		}
		
		
		
         	var givenmaptypes = map.getMapTypes();
         	map.setMapType(givenmaptypes[2]);
        	//alert("create controller");
		var mapControl = new GMapTypeControl();
		map.addControl(mapControl);      	
		map.addControl(new GLargeMapControl());
        	//alert("create controller-1");		
		var ovCont = new GOverviewMapControl();
		ovCont.setMapType(givenmaptypes[2]);
		map.addControl(ovCont);
                var latlon;
                GEvent.addListener(map,"click", function(overlay, point) {     
                      if (point) { 
                        var myHtml = "The GPoint value is: " + point.x + " at zoom level " + map.getZoom();
                       // map.openInfoWindow(latlng, myHtml);
                         //latlon = latlng; 
                       
                       // map.openInfoWindow(point, myHtml);
                        locatemanualformap(point.x,point.y)                      
                      }
                    });
                    
                     
		}
		//alert("adding listener");
		map.setCenter(new GLatLng(y, x), zoomlvl);
		var point = new GLatLng( y, x);
		var gmarker = new GMarker(point);
        	//alert("create controller-3");
                map.clearOverlays()
		map.addOverlay(gmarker);
		swapSitePoints();
 
    }
}




var dynMapOv;
var flag0=0;
var flag=0;
var flag1=0;
var flag2=0;
var dynMapOv2;
var dynMapOv3;
var dynMapOv4;

var dynMapOv5;
var dynMapOv9;
var dynMapOv15;
var dynMap; 



function dynmapcallback(groundov)
{
    if(document.kmlBoxes.C.checked)
    {
        map.addOverlay(groundov);
        flag0=1;
        dynMapOv = groundov;
    }else{
        map.removeOverlay(dynMapOv);
        flag0=0;
    }
}


function dynmapCallSite(groundov) { 

      //Add groundoverlay to map using map.addOverlay() 
	  map.addOverlay(groundov); 
	  dynMap= groundov; 
 } 
 
function dynmapcallback15(groundov)
{
    //Add groundoverlay to map using map.addOverlay()
	if(document.kmlBoxes2.U.checked)
    {
        map.addOverlay(groundov);
        dynMapOv15 = groundov;
    }else{
        map.removeOverlay(dynMapOv15);
		
	}
}

function dynmapcallback9(groundov)
{
    //Add groundoverlay to map using map.addOverlay()
	if(document.kmlBoxes2.I.checked)
    {
        map.addOverlay(groundov);
        dynMapOv9 = groundov;
    }else
    {
        map.removeOverlay(dynMapOv9);
    }
}
function dynmapcallback5(groundov)
{
    //Add groundoverlay to map using map.addOverlay()
	if(document.kmlBoxes2.O.checked)
    {
        map.addOverlay(groundov);
        dynMapOv5 = groundov;
	}else
    {
        map.removeOverlay(dynMapOv5);
    }
}

function zooming()
{
    if (map.getZoom()<16)
	{
		if(flag==1)
		{
			map.removeOverlay(dynMapOv2);
			map.removeOverlay(dynMapOv3);
			flag=0;
		}
		if(flag1==0)
		{swapZonesKML();}
	}
	else
	{
	   if(flag1==1)
		{
			map.removeOverlay(dynMapOv4);
			flag1=0;
		}
        if(flag==0)
		{swapRoadsKML();}
	}
}


function dynmapcallback2(groundov)
{
    //Add groundoverlay to map using map.addOverlay()
	if(document.kmlBoxes.R.checked && map.getZoom()>=16)
	{
        map.addOverlay(groundov);
        flag=1;
        dynMapOv2 = groundov;
    }else
    {
        map.removeOverlay(dynMapOv2);
        flag=0;
    }
}

function dynmapcallback3(groundov) 
{
    //Add groundoverlay to map using map.addOverlay()
    if(document.kmlBoxes.R.checked  && map.getZoom()>=16)
    {
        map.addOverlay(groundov);
        flag=1;
        dynMapOv3 = groundov;
    }
    else
    {
        map.removeOverlay(dynMapOv3);
        flag=0;
    }
}

function dynmapcallback4(groundov)
{
    //	alert(map.getZoom());
    //	Add groundoverlay to map using map.addOverlay()
    if(document.kmlBoxes.Z.checked  && map.getZoom()<16)
    {
        map.addOverlay(groundov);
        flag1=1;
        dynMapOv4 = groundov;
    }else {
        map.removeOverlay(dynMapOv4);
        flag1=0;
    }
}

function swapInput()
{
	if(document.kmlBoxes.ad_input.checked == true)
	{
		document.getElementById("drill").style.display= "none";
		document.getElementById("manual").style.display = 'inline';
                document.getElementById("buttons").style.display = 'none';
                content="locate_div";
                clearGetSpan();
	}else
	{
		document.getElementById("drill").style.display= "inline";
		document.getElementById("manual").style.display = 'none';
                document.getElementById("buttons").style.display = 'none';
	}
}

function submitManual()
{
	var form = document.coverage_info;
	
	validated =true;
	errors="";
	if($.trim(form.x.value)=="")
    {  
		validated= false;
		errors+="Please Enter  longitude<BR>";
    }
	
	if($.trim(form.y.value)=="")
    {	
		validated= false;
    	errors+="Please Enter latitude<BR>";
    }
	if(!validated)
	{
		document.getElementById("manual_error").innerHTML = errors;
		return false;
	}
	
	var HouseNo=$.trim(form.HouseNo.value.replace(/,/g," "));
	var Street=$.trim(form.Street.value.replace(/,/g," "));
	var Zone=$.trim(form.Zone.value.replace(/,/g," "));
	form.gc.value = HouseNo+","+Street+","+Zone+","+form.City.value;
	form.submit();
	return true;

}
    </SCRIPT>    
    <body>
        
        <!-- Inner content starts here -->
                                
        <!--<P>Fields marked with an asterisk (<SPAN class=mandatory>*</SPAN>) are required.</P> -->
        <!-- message end -->
                               
                                    
        <TABLE border=0 cellSpacing=0 cellPadding=0 width="99%" align=left class="Act-listing">
            <tr class='info-listing'><td colspan=3><DIV style="WIDTH: 650px; HEIGHT: 500px" id=map_canvas></DIV></td></tr>
            <tr class='info-listing'><td colspan=3>&nbsp;</td></tr>
            <tr  class='info-listing'>
            <td  valign="top" width=40%>
            <!--  address form -->
            <FORM name=address onsubmit='return (false);'>
                <DIV  id=drill >
                    <TABLE border=0 cellpadding=0 CELLSPACING="0" class=ct-info>
                        <TBODY>
                            <tr><th colspan=2><SPAN 
                                style="COLOR: #c60551; FONT-SIZE: 12px"><STRONG>Address</STRONG></SPAN></th></tr>
                                <!-- Code Added by muralidhar -->
                                <tr> <TD class=textboxBur height=22 align=left >City</TD>
                                <TD align=left >
                                    <logic:notEmpty name="CitylList">
                                        <select name="City" id="City" onchange= "javascript: GetZones(this.value);">
                                                     <logic:iterate name="CitylList" id="cityid" type="com.witribe.sales.vo.SalesPersonnelVO" scope="request">                                                 
                                                    <option title="${cityid.province}" value="${cityid.city}">${cityid.city}</option>
                                                    
                                                </logic:iterate>   
                                        </select>
                                    </logic:notEmpty> <p class=validationmsg></p></td>
                              </tr>
                            <!--<
                                    <select class="textboxGray" name="City" onchange="javascript: GetZones(this.value);">
                                        <option value='Select'>Select City </option>
                                        <option title="Punjab" value="Islamabad">Islamabad</option>
                                        <option title="Sindh" value="Karachi" >Karachi</option>
                                        <option title="Punjab" value="Lahore" >Lahore</option>
                                        <option title="Punjab" value="Rawalpindi" >Rawalpindi</option>
                            </select>-->
                          </TD>
                            <TR>
                                <TD class=textboxBur align=left><div id=lblZone>Sector</div></TD>
                                <TD align=left>
                                    <div class="normalGrayFont" id="zone_div">
                                        <select class="textboxGray" name="Zone" onchange="javascript: GetPhases(this.value);">
                                            <option value="Select">Select</option>
                                        </select><p class=validationmsg></p>
                                    </div>
                                </TD>
                            </TR>
                            <!--code added by satya-->
                            <TR STYLE="display:none" id="lahore_subzone">
                                <TD class=textboxBur align=left><div id=lblSubZone>Phases</div></TD>
                                <TD class=normalColoredFont align=left>
                                    <div class="normalGrayFont" id="subzone_div">
                                        <select class="textboxGray" name="SubZone" onchange="javascript: GetBlocks(this.value);">
                                            <option value="Select">Select</option>
                                        </select><p class=validationmsg></p>
                            </div></TD></TR>
                            <TR STYLE="display:none" id="lahore_block">
                                <TD class=textboxBur align=left><div id=lblBlock>Blocks</div></TD>
                                <TD class=normalColoredFont align=left>
                                    <div class="normalGrayFont" id="block_div">
                                        <select class="textboxGray" name="Block" onchange="javascript: GetStreets(this.value);">
                                            <option value="Select">Select</option>
                                        </select><p class=validationmsg></p>
                            </div></TD></TR>
                            <TR>
                                <TD class=textboxBur align=left><div id=lblStreet>Street / Category</div></TD>
                                <TD class=normalColoredFont align=left>
                                    <div class="normalGrayFont" id="street_div">
                                        <select class="textboxGray" name="Street" onchange="javascript: GetHouses(this.value);">
                                            <option value="Select">Select</option>
                                        </select><p class=validationmsg></p>
                            </div></TD></TR>
                            <TR>
                                <TD class=textboxBur align=left><div id=lblHouseno>Plot No / Name</div></TD>
                                <TD class=normalColoredFont align=left>
                                    <div class="normalGrayFont" id="house_div">
                                        <select class="textboxGray" name="HouseNo" onchange="javascript:locate('<%=request.getParameter("leadId")%>');" >
                                            <option value="Select">Select</option>
                                        </select><p class=validationmsg></p>
                            </div></TD></TR>
                            <tr ><td>&nbsp;</td><td align="left">
                                    <input type ="hidden" name="TASK" value="QUERY"/>
                                    
                                    <INPUT Type="hidden" Name="state" Value="">
                                    <input type=image src="images/btn-locate.gif" onclick="javascript: locate('<%=request.getParameter("leadId")%>');"  onmouseover="this.src='images/btn-locate-on.gif'" onmouseout="this.src='images/btn-locate.gif'">
                                    
                            </td></tr>
            </TBODY></TABLE></DIV></FORM>
            <!-- Address form Ends here -->
            <!-- Manual Address form Starts here -->
            <FORM method=post name=manualaddress onsubmit='return(false);'>
            <DIV style="DISPLAY: none" id=manual>
                
                <TABLE  class=ct-info>
                    <TBODY>
                        <tr><th colspan=2><SPAN 
                            style="COLOR: #c60551; FONT-SIZE: 12px"><STRONG>Address</STRONG></SPAN></th></tr>
                        <TR height=22>
                            <TD class=textboxBur>Plot. No.</TD>
                            <TD class=normalColoredFont ALIGN="left"> 
                                <INPUT class=textboxGray  type=text name=HouseNo MAXLENGTH="50"  value=""><p class=validationmsg></p>
                            <INPUT type=hidden name=gc><INPUT type=hidden name=coverage></TD>
                        </TR>
                        <TR height=22>
                            <TD class=textboxBur>Street / Road</TD>
                            <TD class=normalColoredFont align=left><INPUT  class=textboxGray MAXLENGTH="50" type=text name=Street value=""><p class=validationmsg></p></TD>
                        </TR>
                        <TR height=22>
                            <TD class=textboxBur>Sector</TD>
                            <TD class=normalColoredFont><INPUT class=textboxGray  type=text MAXLENGTH="50" name=Zone value=""><p class=validationmsg></p></TD>
                        </TR>
                        <TR>
                            <tr> <TD class=textboxBur height=22 align=left >City</TD>
                                <TD align=left >
                                    <logic:notEmpty name="CitylList">
                                        <select name="city" id="city" onchange= "javascript: GetZones(this.value);">
                                                     <logic:iterate name="CitylList" id="cityid" type="com.witribe.sales.vo.SalesPersonnelVO" scope="request">
                                                    <option value="${cityid.city}">${cityid.city}</option>
                                                    
                                                </logic:iterate>   
                                        </select>
                                    </logic:notEmpty> <p class=validationmsg></p></td>
                              </tr>
                           <!-- 
                                   
                                <select class="textboxGray" name="City" onchange='document.manualaddress.state.value=this.options[this.selectedIndex].title;'>
                                    <option title="Punjab" value="Islamabad">Islamabad</option>
                                    <option title="Sindh" value="Karachi" >Karachi</option>
                                    <option title="Punjab" value="Lahore" >Lahore</option>
                                    <option title="Punjab" value="Rawalpindi" >Rawalpindi</option>
                            </select> -->
                           
                        </TR>
                        <TR>
                            <TD class=textboxBur>Latitude</TD>
                            <TD class=normalColoredFont><INPUT class=textboxGray type=text name=y MAXLENGTH="50"><p class=validationmsg></p></TD>
                        </TR>
                        <TR>
                            <TD class=textboxBur>Longitude</TD>
                            <TD class=normalColoredFont><INPUT class=textboxGray type=text name=x MAXLENGTH="50"><p class=validationmsg></p></TD>
                        </TR>
                       
                        
                        <TR>
                            <TD></TD>
                            <TD>
                                <INPUT value=QUERY type=hidden name=TASK>
                                <input type=hidden name=state value="">
                                
                                <input type=image src="images/btn-locate.gif" onclick='javascript:locatemanual();'  onmouseover="this.src='images/btn-locate-on.gif'" onmouseout="this.src='images/btn-locate.gif'">
                            </TD>
                        </TR>
                        
                    </TBODY>
                </TABLE>
                
            </DIV>
            <div style="DISPLAY: none" id="buttons">
                <TABLE  class=ct-info>
                <tr><td> <input type="button" value="Update&nbsp;Status" name="ConvertToProspect" onclick="javascript:formSubmit1('./GetReason.do?leadId=<%=request.getParameter("leadId")%>');"/></td>
                <td ><input type="button" value="Convert&nbsp;to&nbsp;Account" name="ConvertToAccount" onclick="javascript:formSubmitAccount1('./GetMore.do');" /></td></tr>
            </div>
        </table>
        </FORM>
        <!-- Manual Address form Ends here -->
        </td>
        <td align=left width=30% >
            <!-- Utility Layers form starts here -->
                                                    
            <DIV id=kml_div2  style="color:#7f7f7f">
                <FORM name=kmlBoxes2>
                    <table border=0  cellpadding=0 cellspacing=0  class=ct-info>
                        <tr><th colspan=2><SPAN 
                            style="COLOR: #c60551; FONT-SIZE: 12px"><STRONG>Coverage Layers</STRONG></SPAN></th></tr>
                        <tr>
                            <td width=10%><INPUT onclick=javascript:swapUSBCoverage(); value=USB type=checkbox name=U></td><td width=90%><LABEL>USB</LABEL>
                            </td>
                        </tr>
                        <tr>
                            <td><INPUT onclick=javascript:swapInDoorCoverage(); value=InDoor type=checkbox name=I></td><td><LABEL>In Door</LABEL>
                            </td>
                        </tr>
                        <tr>
                            <td><INPUT onclick=javascript:swapOutDoorCoverage(); value=OutDoor type=checkbox name=O></td><td><LABEL>Out Door</LABEL>
                            </td>
                        </tr>
                    </table>
                    
                </FORM>
            </DIV>
            
            <!-- Utility Layers form ends  here -->
        </td>
        <td width=30%>
            <DIV id=kml_div >
                <FORM name=kmlBoxes>
                    <table  border=0 cellpadding=0 cellspacing=0 class=ct-info>
                        <tr><th><SPAN 
                            style="COLOR: #c60551; FONT-SIZE: 12px"><STRONG>Digital Maps</STRONG></SPAN></th></tr>
                        <tr>
                            <td><INPUT onclick="" value=Parcels type=checkbox name=P> <LABEL>Parcels</LABEL>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <INPUT onclick=javascript:swapRoadsKML(); value=Roads type=checkbox name=R> <LABEL>Roads</LABEL>
                            </td>
                        </tr>
                        <tr>
                            <td><INPUT onclick=javascript:swapZonesKML(); value=Zones type=checkbox name=Z> <LABEL>Zones</LABEL></td>
                        </tr>
                        <tr>
                            <td><INPUT onclick=javascript:swapInput(); value=ad_input type=checkbox name=ad_input> <LABEL>Address is not found</LABEL>
                            </td>
                        </tr>
                    </table>
                </FORM>
            </DIV>
        </td>
        </tr>
        <script lanaguage=javascript>
                                                function validateCTForm(frm) {
                                                    //alert(frm.nationality.value);
                                                    //alert(frm.referrer.value);
                                                    //alert(frm.gc.value);
                                                         //alert(document.address.state.value);
                                                        frm.city.value = document.address.City.value;
                                                        frm.state.value = document.address.state.value;
                                                        frm.zone.value = document.address.Zone.value;
                                                        frm.street.value = document.address.Street.value;
                                                        frm.plot.value = document.address.HouseNo.value;
                                          
                                                    frm.latitude.value = frm.y.value;
                                                    frm.longitude.value = frm.x.value;
                                                    frm.coverage_type.value=frm.coverage.value;
                                                    //frm.leadId.value=leadId;
                                                    //alert(document.address.City.value);
                                                    var sHNo, sStreet, sZone;                                                    
                                                    if(ResultType == 'AUTO') {
                                                        sHNo = (document.address.HouseNo.value);
                                                        sStreet = (document.address.Street.value);
                                                        sZone = (document.address.Zone.value);
                                                        if(sHNo =='') sHNo = "-";
                                                        if(sStreet == '') sStreet = '-';
                                                        if(sZone == '') sZone = '';
                                                        frm.address1.value =  sHNo;
                                                        frm.address1.value = frm.address1.value  + "   " + sStreet;
                                                        frm.address1.value = frm.address1.value  + "   " + "_";
                                                        frm.address1.value = frm.address1.value  + "   " + sZone;
                                                        frm.city.value = document.address.City.value;
                                                        frm.state.value = document.address.state.value;
                                                        frm.zone.value = sZone;
                                                        frm.street.value = sStreet;
                                                        frm.plot.value = sHNo;
                                                        
                                                    } else {
                                                        sHNo = (document.manualaddress.HouseNo.value);
                                                        sStreet = (document.manualaddress.Street.value);
                                                        sZone = (document.manualaddress.Zone.value);
                                                        if(sHNo =='') sHNo = "-";
                                                        if(sStreet == '') sStreet = '-';
                                                        if(sZone == '') sZone = '';
                                                        frm.address1.value = sHNo ;
                                                        frm.address1.value = frm.address1.value  + "   " + sStreet;
                                                        frm.address1.value = frm.address1.value  + "   " + "_";
                                                        frm.address1.value = frm.address1.value  + "   " + sZone;
                                                        frm.city.value = document.manualaddress.City.value;
                                                        frm.state.value = document.manualaddress.state.value;
                                                    }
                                                    /*if(frm.cvgchkstatue.value == 'not covered')
                                                    {
							var answer = confirm ("Area is not under Coverage Location. You cannot create the account. Do you want to continue bypassing the Coverage Check?");
                                                        if(!answer) {
                                                            return(false);
                                                        }
                                                        else {
                                                            frm.coverage_type.value = frm.coverage_type.value + " (Bypassed)";
                                                            return(true);
                                                        }
                                                    }
                                                    else {
                                                        return(true);
                                                       }*/
                                                    return(true);
                                                }
        </script>                                            
        <tr   class='info-listing'><td colspan=3>
                <FORM class=bigBoldFont method=post name=locater action=NewAccountDealer_Step1.jsp onsubmit="return validateCTForm(this,'<%=request.getParameter("leadId")%>')">
                    <DIV id=locate_div class=normalGrayFont align=center>
                        <!-- Generated out put  for http://oe-fut.wi-tribe.net.pk/dev/coverage/search_gc.php?HouseNo=145&street=11&zone=MARGALLA TOWN&City=Islamabad-->
                        <!-- Retun output format structure begin-->
                                                                                
                        <!-- REturn output format structure - ends -->
                                                                                
                        <!--  Generated output ends here -->
                    </DIV>
                    <input type=hidden name="address1" value="-   -   -   -">
                    <input type=hidden name="city" value="Islamabad">
                    <INPUT TYPE="hidden" NAME="zip" value="" >
                    <INPUT TYPE="hidden" NAME="state" value="Karachi">
                    <INPUT TYPE="hidden" NAME="zone" value="">
                    <INPUT TYPE="hidden" NAME="subzone" value="">
                    <INPUT TYPE="hidden" NAME="plot" value="">
                    <INPUT TYPE="hidden" NAME="street" value="">
                    
                    <input type=hidden name="coverage_type" value="">
                    <input type=hidden name=latitude value="">
                    <input type=hidden name=longitude value="">
                    <input type=hidden name=sla value="">
                    <INPUT TYPE="hidden" NAME="leadId" value="<%=request.getParameter("leadId")%>">
                    <input type="hidden" name="referredBy" value="<%=request.getParameter("referredBy")%>">
                    <input type=hidden name=salesweb value="DEALER">
                    <input type=hidden value=button name=button onclick="validateCTForm(document.locater);">
                </FORM>
                
        </td></tr>
        
        </table>
        <SCRIPT language="javascript">
    x="73.03311243";
    y="33.68435332";
    initialize(x,y);
        </SCRIPT>
        
        
        
        
        <!-- Inner content ends here -->                        
           
    </body>
</html>
