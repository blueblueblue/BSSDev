/*
 * SalesPersonnelForm.java
 *
 * Created on January 28, 2009, 11:44 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.witribe.sales.vo;

//import org.apache.struts.action.ActionForm;

/**
 *
 * @author SC43278
 */
public class SalesPersonnelVO {
    
    /** Creates a new instance of SalesPersonnelForm */
    public SalesPersonnelVO() {
    }
    private String leadId;
    private String salesId;
    private String salestype;
    private String channeltype;
    private String firstname;
    private String lastname;
    private String contactnumber;
    private String email;
    private String plot;
    private String street;
    private String subzone;
    private String zone;
    private String city;
    private String province;
    private String country;
    private String zip;
    private String fullname;
    private String typecode;
    private String typevalue;
    private String userId;
    private String password;
    private String createDate;
    private String modifiedDate;
    private String assignedTL;
    private String shop_id;
    private boolean isNsmAvailable;
    private String location;
    private String []salesLocation;
    private String salespersonstatus;
    private String cseStatus;
    private String type;
    private String address;
    private String subAddress;
     private String childSalesId;
     //Added by Bhawna on 9th october 2009

    private String shopZone;

    public String getShopZone() {
        return shopZone;
    }
 
    public void setShopZone(String shopZone) {
        this.shopZone = shopZone;
    }
//end
     
      public String getCseStatus() {
        return cseStatus;
    }
    public void setCseStatus(String cseStatus) {
        this.cseStatus = cseStatus;
    }
      

    public String getLeadId() {
        return leadId;
    }
    public void setLeadId(String leadId) {
        this.leadId = leadId;
    }
    public boolean isNsmAvailable() {
            return isNsmAvailable;
    }
    public void setNsmAvailable(boolean isNsmAvailable) {
            this.isNsmAvailable = isNsmAvailable;
    }
    public String getSalesId() {
            return salesId;
    }
    public void setSalesId(String salesId) {
            this.salesId = salesId;
    }
     
    public String getChanneltype() {
             return channeltype;
    }
    public void setChanneltype(String channeltype) {
            this.channeltype = channeltype;
    }
     public String getAssignedTL() {
        return assignedTL;
    }
    public String getShop_id() {
        return shop_id;
    }

    public void setShop_id(String shop_id) {
        this.shop_id = shop_id;
    }
    public void setAssignedTL(String assignedTL) {
        this.assignedTL = assignedTL;
    }
     
    public String getTypecode() {
            return typecode;
    }
    public void setTypecode(String typecode) {
            this.typecode = typecode;
    }
    public String getTypevalue() {
            return typevalue;
    }
    public void setTypevalue(String typevalue) {
            this.typevalue = typevalue;
    }
    public String getSalestype() {
            return salestype;
    }
    public void setSalestype(String salestype) {
            this.salestype = salestype;
    }
    public String getEmail() {
            return email;
    }
    public void setEmail(String email) {
            this.email = email;
    }
    public String getFirstname() {
            return firstname;
    }
    public void setFirstname(String firstname) {
            this.firstname = firstname;
    }
    public String getContactnumber() {
            return contactnumber;
    }
    public void setContactnumber(String contactnumber) {
            this.contactnumber = contactnumber;
    }
     public String getLastname() {
            return lastname;
    }
    public void setLastname(String lastname) {
            this.lastname = lastname;
    }
    public String getStreet() {
            return street;
    }
    public void setStreet(String street) {
            this.street = street;
    }
           
   public void setFullname(String fullname) {
            this.fullname = fullname;
    }
    public String getFullname() {
        return fullname;
    }
    
    public String getPlot() {
        return plot;
    }
    public void setPlot(String plot) {
        this.plot = plot;
    }      
    public String getSubzone() {
        return subzone;
    }
    public void setSubzone(String subzone) {
        this.subzone = subzone;
    }
    public String getZone() {
        return zone;
    }
    public void setZone(String zone) {
        this.zone = zone;
    }    
    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }
    public String getProvince() {
         return province;
    }
    public void setProvince(String province) {
        this.province = province;
    }
    public String getCountry() {
         return country;
    }
    public void setCountry(String country) {
        this.country = country;
    }
     public String getSalespersonstatus() {
         return salespersonstatus;
    }
    public void setSalespersonstatus(String salespersonstatus) {
        this.salespersonstatus = salespersonstatus;
    }
    public String getZip() {
         return zip;
    }
    public void setZip(String zip) {
        this.zip = zip;
    }
    public String getUserId() {
			return userId;
		}
   public void setUserId(String userId) {
		this.userId = userId;
	}
   public String getPassword() {
	return password;
    }
    public void setPassword(String password) {
	this.password = password;
    }
   public String getCreateDate() {
        return createDate;
    }
     public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }
    public String getModifiedDate() {
        return modifiedDate;
    }
     public void setModifiedDate(String modifiedDate) {
        this.modifiedDate = modifiedDate;
    }  

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String[] getSalesLocation() {
        return salesLocation;
    }

    public void setSalesLocation(String[] salesLocation) {
        this.salesLocation = salesLocation;
    }
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getSubAddress() {
        return subAddress;
    }

    public void setSubAddress(String subAddress) {
        this.subAddress = subAddress;
    }

    public String getChildSalesId() {
        return childSalesId;
    }

    public void setChildSalesId(String childSalesId) {
        this.childSalesId = childSalesId;
    }

    
  

}
