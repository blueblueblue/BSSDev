/*
 * UpdateShopHierarchyAction.java
 *
 * Created on April 7, 2009, 12:35 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.witribe.sales.action;

import com.witribe.action.BaseAction;
import com.witribe.constants.WitribeConstants;
import com.witribe.sales.actionform.ShopDetailsForm;
import com.witribe.sales.bo.WitribeSalesBO;
import com.witribe.sales.vo.SalesHierarchyVO;
import com.witribe.sales.vo.ShopsVO;
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
public class UpdateShopHierarchyAction extends BaseAction{
    
    /** Creates a new instance of UpdateShopHierarchyAction */
    public UpdateShopHierarchyAction() {
    }
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest req, HttpServletResponse res) throws SQLException, Exception{
        ShopDetailsForm sform = (ShopDetailsForm)form;
        req.setAttribute(WitribeConstants.LEAD_MANAGEMENT_ID,WitribeConstants.SHOPS_HIERARCHY);
        try{
            if(!validateSession(req,res)) {
                return mapping.findForward("login");                
            }
            WitribeSalesBO wsbo = new WitribeSalesBO();
            ShopsVO shopobj = new ShopsVO();
            shopobj.setShopId(sform.getShopId());
            shopobj.setSubShopId(sform.getSubShopId());
            if(wsbo.updateShopHierarchybySubshop(shopobj))
            {
                req.setAttribute(WitribeConstants.HEADING,WitribeConstants.MODIFY_SHOP_HIERARCHY);
                return mapping.findForward("success");
            }
            
        }catch(Exception e) {
            LogUtil.error("Exception "+e.getMessage(),this.getClass()); 
            req.setAttribute(WitribeConstants.HEADING,WitribeConstants.HEADING_APP_FAIL);
            req.setAttribute(WitribeConstants.ERR_VAR,WitribeConstants.APP_FAIL_MSG);
            return mapping.findForward(WitribeConstants.APP_FAIL_FWD);
        }
        req.setAttribute(WitribeConstants.HEADING,WitribeConstants.FAILED_MODIFY_SHOP_HIERARCHY);
        return mapping.findForward("failure");
    }
}