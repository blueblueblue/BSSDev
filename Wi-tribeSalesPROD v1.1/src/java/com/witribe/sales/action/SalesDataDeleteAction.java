/*
 * SalesDataDeleteAction.java
 *
 * Created on February 4, 2009, 4:33 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.witribe.sales.action;

import com.witribe.action.BaseAction;
import com.witribe.constants.WitribeConstants;
import com.witribe.sales.actionform.SalesPersonnelForm;
import com.witribe.sales.bo.WitribeSalesBO;
import com.witribe.sales.vo.SalesPersonnelVO;
import com.witribe.util.LogUtil;
import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 *
 * @author SC43278
 */
public class SalesDataDeleteAction extends BaseAction{
    
    /** Creates a new instance of SalesDataDeleteAction */
    public SalesDataDeleteAction() {
    }
    public ActionForward execute(ActionMapping mapping,ActionForm form,HttpServletRequest req,HttpServletResponse res) {
        SalesPersonnelForm sform= (SalesPersonnelForm)form; 
        req.setAttribute(WitribeConstants.LEAD_MANAGEMENT_ID,WitribeConstants.SALES_PERSONNEL);
        try{
             if(!validateSession(req,res)) {
                return mapping.findForward("login");
            }
            if(deleteSalesPerson(sform,req)) {
                req.setAttribute(WitribeConstants.HEADING,WitribeConstants.DELETE_SALES_PERSONNEL);
                return mapping.findForward("success");
            }
            else
            {
                 req.setAttribute(WitribeConstants.HEADING,WitribeConstants.FAILED_DELETE_SALES_PERSONNEL);
                 req.setAttribute(WitribeConstants.ERR_VAR,WitribeConstants.MSG_FAILED_DELETE_SALES_PERSONNEL);
                 return mapping.findForward("failure");
            }
        } catch(SQLException e) {
            LogUtil.error("Exception "+e.getMessage(),this.getClass()); 
            if(e.getErrorCode() == WitribeConstants.ORA_REF_ERR) {
               req.setAttribute(WitribeConstants.HEADING,WitribeConstants.FAILED_DELETE_SALES_PERSONNEL); 
               req.setAttribute(WitribeConstants.ERR_VAR,WitribeConstants.MSG_SALES_PERSONNEL); 
               return mapping.findForward("failure") ;
           }
              req.setAttribute(WitribeConstants.HEADING,WitribeConstants.HEADING_APP_FAIL); 
              req.setAttribute(WitribeConstants.ERR_VAR,WitribeConstants.APP_FAIL_MSG); 
              return mapping.findForward(WitribeConstants.APP_FAIL_FWD);
        } catch(Exception e) {
               LogUtil.error("Exception "+e.getMessage(),this.getClass()); 
               req.setAttribute(WitribeConstants.HEADING,WitribeConstants.HEADING_APP_FAIL); 
               req.setAttribute(WitribeConstants.ERR_VAR,WitribeConstants.APP_FAIL_MSG); 
               return mapping.findForward(WitribeConstants.APP_FAIL_FWD);
        }
      // req.setAttribute("heading","Failed Deleting Sales Personnel Data");
       //return mapping.findForward("failure") ;
    }
    boolean deleteSalesPerson(SalesPersonnelForm sform,HttpServletRequest req)throws SQLException,Exception{
        SalesPersonnelVO objSalesVO = new SalesPersonnelVO();
        String[] check=req.getParameterValues("check");
        objSalesVO.setSalesId(sform.getSalesId());
        WitribeSalesBO objBO= new WitribeSalesBO();
        boolean status = objBO.deleteSalesPersonnel(objSalesVO,check);
        return status;
          
    }
}
