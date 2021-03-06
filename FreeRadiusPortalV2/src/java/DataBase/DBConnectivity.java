/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package DataBase;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author PKMDUsman
 */
public class DBConnectivity {

    String PortNumber = "1522";
    String SID = "PINDB";
    String UserName = "Waqas";
    String Password = "toor";
    String ServerName = "10.1.67.201";
    String ConnString = "jdbc:oracle:thin:@" + ServerName + ":" + PortNumber + ":" + SID;
    List<String> availableDomains = new ArrayList<String>();
    List<String> availableProfiles = new ArrayList<String>();
    List<String> availableOperations = new ArrayList<String>();
    List<String> groupPermissions = new ArrayList<String>();
    List<String> availableroups = new ArrayList<String>();
    List<String> permissions = new ArrayList<String>();

    private Connection Connect() {
        try {

            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            Connection con = DriverManager.getConnection(ConnString, UserName, Password);
            System.out.println("Database Connection Established.");
            return con;
        } catch (SQLException ex) {
            System.out.println("Problem establishing connection to Database due to.. " + ex.toString());
        }
        return null;
    }

    private void disConnect(Connection con) {
        try {
            con.close();
            System.out.println("Database is disconnected successfully");
        } catch (SQLException ex) {
            System.out.println("Exception in closing Database Connection due to " + ex.toString());
        }
    }

    public String verifyUser(String username, String Password) {//to verify if portal user exists or not
        boolean found = false;
        Connection vuCon = null;
        String group = null;
        try {
            vuCon = Connect();
            if (vuCon == null) {
                return null;
            }
            String query = "SELECT * FROM PORTALUSERS WHERE LOWER(USERNAME) = LOWER(?) AND PASSWORD = ?";
            PreparedStatement prest = vuCon.prepareStatement(query);
            prest.setString(1, username);
            prest.setString(2, Password);

            ResultSet rs = prest.executeQuery();
            while (rs.next()) {
                String userName = rs.getString(2);
                group = rs.getString(4);
                System.out.println(userName + " Authenticated.");
                found = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to check user status.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(vuCon);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (found == true) {
                    return group;
                } else {
                    return "not found";
                }
            }
        }


    }

    public List getAvailableProfiles() {//checked
        Connection con = null;
        boolean result = false;
        try {

            con = Connect();
            if (con == null) {
                return null;
            }
            String profile;
            String sql = "select distinct (GROUPNAME) from RADGROUPCHECK";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                profile = rs.getString("GROUPNAME");
                availableProfiles.add(profile);
            }
            System.out.println("Query to get all available profiles executed successfully");
            result = true;
        } catch (SQLException ex) {
            System.out.println("Exception in executing query to check available profiles.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return availableProfiles;
                } else {
                    return null;
                }
            }
        }

    }

    public List getAvailableDomains() {//checked

        availableDomains.add("wi-tribe.com");
//        availableDomains.add("test-cpe.com");
        System.out.println("Query to get Available Domains successfully executed.");
        return availableDomains;

    }

    public String checkUserStatus(String mac) {//to check status of MAC
        Connection con = null;
        boolean recordFound = false;
        if (mac.length() != 12) {
            recordFound = false;
            return "lenghtProblem";
        }
        try {
            con = Connect();
            if (con == null) {
                return null;
            }
            String result = null;
            String query = "select (USERNAME) from RADUSERGROUP where  LOWER(USERNAME)  like LOWER(?)";
            PreparedStatement prest = con.prepareStatement(query);
            prest.setString(1, "%" + mac + "%");
            ResultSet rs = prest.executeQuery();

            while (rs.next()) {
                result = rs.getString("USERNAME");
                System.out.println("Username - " + result + " already exist..");
                recordFound = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to check user existance status.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (recordFound == true) {
                    return "found";
                } else {
                    return "not found";
                }
            }
        }
    }

    public String addMAC(String mac, String profile, String domain) {
        boolean result = false;
        if (mac.length() != 12) {
            result = false;
            return "lenghtProblem";
        }
        Connection addCon = null;
        try {
            addCon = Connect();
            if (addCon == null) {
                return null;
            }
            mac = mac.toUpperCase();
            String query = "insert into radusergroup (username, groupname) values (?,?)";
            PreparedStatement prest = addCon.prepareStatement(query);
            String username = mac + "@" + domain;
            prest.setString(1, username);
            prest.setString(2, profile);

            int rowsAffected = prest.executeUpdate();
            if (rowsAffected != 0) {
                System.out.println(rowsAffected + " records are inserted");
                result = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to add new record.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(addCon);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return "inserted";
                } else {
                    return "failed";
                }
            }
        }

    }

    public List getMacAddressRecord(String MAC) {
        List<String> MAC_ADD_REC = new ArrayList<String>();
        String User, Group;
        Connection con = null;
        boolean recordFound = false;
        try {
            con = Connect();
            if (con == null) {
                return null;
            }
            String query = "select username,groupname from RADUSERGROUP where  LOWER(USERNAME)  like LOWER(?)";
            PreparedStatement prest = con.prepareStatement(query);
            prest.setString(1, "%" + MAC + "%");
            ResultSet rs = prest.executeQuery();

            while (rs.next()) {
                User = rs.getString("USERNAME");
                MAC_ADD_REC.add(User);
                Group = rs.getString("GROUPNAME");
                MAC_ADD_REC.add(Group);
                System.out.println("Username - " + User + "  exist..");
                recordFound = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to check user existance status.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (recordFound == true) {
                    return MAC_ADD_REC;
                } else {
                    return null;
                }
            }
        }
    }

    public String[] searchUser(String MAC) {
        Connection con = null;
        boolean recordFound = false;
        String[] result = new String[3];
        try {
            con = Connect();
            if (con == null) {
                return null;
            }
            String query = "select * from RADUSERGROUP where  LOWER(USERNAME)  like LOWER(?)";
            PreparedStatement prest = con.prepareStatement(query);
            prest.setString(1, "%" + MAC + "%");
            ResultSet rs = prest.executeQuery();

            while (rs.next()) {
                result[0] = rs.getString("USERNAME");
                result[1] = rs.getString("GROUPNAME");
                System.out.println("Username - " + result[0] + " found..");
                recordFound = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to search user.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (recordFound == true) {
                    return result;
                } else {
                    return null;
                }
            }
        }

    }

    public String updateUser(String oldMAC, String newMAC, String oldDomain, String newDomain, String newGroup) {
        int updateRows;
        boolean result = false;
        if (oldMAC.length() != 12 || newMAC.length() != 12) {
            result = false;
            return "lenghtProblem";
        }
        Connection con = null;
        try {
            con = Connect();
            if (con == null) {
                return null;
            }
            oldMAC = oldMAC.toUpperCase();
            newMAC = newMAC.toUpperCase();
            oldMAC = oldMAC + "@" + oldDomain;
            newMAC = newMAC + "@" + newDomain;
            String queryString = "UPDATE RADUSERGROUP SET USERNAME=?,GROUPNAME=? where LOWER(USERNAME)=LOWER(?)";
            PreparedStatement pstatement = null;
            pstatement = con.prepareStatement(queryString);
            pstatement.setString(1, newMAC);
            pstatement.setString(2, newGroup);
            pstatement.setString(3, oldMAC);
            System.out.println("new MAC " + newMAC);
            System.out.println("new Group " + newGroup);
            System.out.println("old MAC " + oldMAC);
            //System.out.println("Query " + queryString);
            updateRows = pstatement.executeUpdate();
            System.out.println("updated rows: " + updateRows);
            if (updateRows != 0) {
                System.out.println(updateRows + " records are updated");
                result = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to update record.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return "updated";
                } else {
                    return "failed";
                }
            }
        }
    }

    public String deleteMAC(String MAC) {
        int deletedRows;
        boolean result = false;
        Connection con = null;
        if (MAC.length() != 12) {
            result = false;
            return "lenghtProblem";
        }
        try {
            con = Connect();
            if (con == null) {
                return null;
            }
            String queryString = "DELETE FROM RADUSERGROUP WHERE LOWER(USERNAME) LIKE LOWER(?)";
            PreparedStatement pstatement = null;
            pstatement = con.prepareStatement(queryString);
            pstatement.setString(1, "%" + MAC + "%");

            deletedRows = pstatement.executeUpdate();
            if (deletedRows != 0) {
                System.out.println(deletedRows + " records are deleted");
                result = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to delete record.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return "deleted";
                } else {
                    return "failed";
                }
            }
        }
    }

    public String changePassword(String Username, String Password) {
        int updateRows;
        boolean result = false;
        Connection con = null;
        try {
            con = Connect();
            if (con == null) {
                return null;
            }

            String queryString = "UPDATE PORTALUSERS SET PASSWORD=? where LOWER(USERNAME)=LOWER(?)";
            PreparedStatement pstatement = null;
            pstatement = con.prepareStatement(queryString);
            pstatement.setString(1, Password);
            pstatement.setString(2, Username);

            updateRows = pstatement.executeUpdate();
            if (updateRows != 0) {
                System.out.println(updateRows + " records are updated");
                result = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to update record.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return "changed";
                } else {
                    return "failed";
                }
            }
        }
    }

    public List getAvailableOperations() {
        Connection con = null;
        boolean result = false;
        try {

            con = Connect();
            if (con == null) {
                return null;
            }
            String operation;
            String sql = "select distinct (NAME) from PORTALOPERATIONS";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                operation = rs.getString("NAME");
                availableOperations.add(operation);
            }
            System.out.println("Query to get all available operations executed successfully");
            result = true;
        } catch (SQLException ex) {
            System.out.println("Exception in executing query to check available operations.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return availableOperations;
                } else {
                    return null;
                }
            }
        }

    }

    public String addGroup(String group) {
        boolean result = false;
        Connection addCon = null;
        try {
            addCon = Connect();
            if (addCon == null) {
                return null;
            }
            String query = "insert into portalgroups (name) values (?)";
            PreparedStatement prest = addCon.prepareStatement(query);
            prest.setString(1, group);

            int rowsAffected = prest.executeUpdate();
            if (rowsAffected != 0) {
                System.out.println(rowsAffected + " records are inserted");
                result = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to add new group.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(addCon);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return "inserted";
                } else {
                    return "failed";
                }
            }
        }

    }

    public String addGroupPermission(String group, String operation) {
        boolean result = false;
        Connection addCon = null;
        try {
            addCon = Connect();
            if (addCon == null) {
                return null;
            }
            String query = "insert into portalpermissions (groupname, operationsallowed) values (?,?)";
            PreparedStatement prest = addCon.prepareStatement(query);
            prest.setString(1, group);
            prest.setString(2, operation);

            int rowsAffected = prest.executeUpdate();
            if (rowsAffected != 0) {
                System.out.println(rowsAffected + " records are inserted");
                result = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to add new group permission.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(addCon);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return "inserted";
                } else {
                    return "failed";
                }
            }
        }

    }

    public List getGroupPermissions(String groupName) {
        Connection con = null;
        boolean result = false;
        try {

            con = Connect();
            if (con == null) {
                return null;
            }
            String permission;
            String sql = "select (OPERATIONSALLOWED) from PORTALPERMISSIONS where LOWER(GROUPNAME)=LOWER(?)";
            PreparedStatement prest = con.prepareStatement(sql);
            prest.setString(1, groupName);
            ResultSet rs = prest.executeQuery();

            while (rs.next()) {
                permission = rs.getString("OPERATIONSALLOWED");
                groupPermissions.add(permission);
            }
            System.out.println("Query to get all group permissions executed successfully");
            result = true;
        } catch (SQLException ex) {
            System.out.println("Exception in executing query to check group permissions.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return groupPermissions;
                } else {
                    return null;
                }
            }
        }

    }

    public String checkGroupStatus(String groupName) {
        Connection con = null;
        boolean recordFound = false;
        try {
            con = Connect();
            if (con == null) {
                return null;
            }
            String result = null;
            String query = "select (NAME) from PORTALGROUPS where  LOWER(NAME) = LOWER(?)";
            PreparedStatement prest = con.prepareStatement(query);
            prest.setString(1, groupName);
            ResultSet rs = prest.executeQuery();

            while (rs.next()) {
                result = rs.getString("NAME");
                System.out.println("Group - " + result + " already exist..");
                recordFound = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to check group existance status.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (recordFound == true) {
                    return "found";
                } else {
                    return "not found";
                }
            }
        }
    }

    public List getAvailableGroups() {
        Connection con = null;
        boolean result = false;
        try {

            con = Connect();
            if (con == null) {
                return null;
            }
            String profile;
            String sql = "select (NAME) from PORTALGROUPS";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                profile = rs.getString("NAME");
                availableroups.add(profile);
            }
            System.out.println("Query to get all available groups executed successfully");
            result = true;
        } catch (SQLException ex) {
            System.out.println("Exception in executing query to check available groups.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return availableroups;
                } else {
                    return null;
                }
            }
        }

    }

    public String checkPortalUserStatus(String userName) {
        Connection con = null;
        boolean recordFound = false;
        try {
            con = Connect();
            if (con == null) {
                return null;
            }
            String result = null;
            String query = "select (USERNAME) from PORTALUSERS where  LOWER(USERNAME) = LOWER(?)";
            PreparedStatement prest = con.prepareStatement(query);
            prest.setString(1, userName);
            ResultSet rs = prest.executeQuery();

            while (rs.next()) {
                result = rs.getString("USERNAME");
                System.out.println("User - " + result + " already exist..");
                recordFound = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to check portal user existance status.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (recordFound == true) {
                    return "found";
                } else {
                    return "not found";
                }
            }
        }
    }

    public String addPortalUser(String userName, String password, String groupName) {
        boolean result = false;
        Connection addCon = null;
        try {
            addCon = Connect();
            if (addCon == null) {
                return null;
            }
            String query = "insert into portalusers (username, password, groupname) values (?,?,?)";
            PreparedStatement prest = addCon.prepareStatement(query);
            prest.setString(1, userName);
            prest.setString(2, password);
            prest.setString(3, groupName);

            int rowsAffected = prest.executeUpdate();
            if (rowsAffected != 0) {
                System.out.println(rowsAffected + " records are inserted");
                result = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to add new portal user.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(addCon);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return "inserted";
                } else {
                    return "failed";
                }
            }
        }

    }

    public List getPermissions(String groupName) {
        Connection con = null;
        boolean result = false;
        try {

            con = Connect();
            if (con == null) {
                return null;
            }
            String profile;
            String query = "select distinct (OPERATIONSALLOWED) from PORTALPERMISSIONS WHERE LOWER(GROUPNAME)=LOWER(?)";
            PreparedStatement prest = con.prepareStatement(query);
            prest.setString(1, groupName);
            ResultSet rs = prest.executeQuery();
            while (rs.next()) {
                profile = rs.getString("OPERATIONSALLOWED");
                permissions.add(profile);
            }
            System.out.println("Query to get all permissions for group " + groupName + " executed successfully");
            result = true;
        } catch (SQLException ex) {
            System.out.println("Exception in executing query to check permissions for group + " + groupName + ".");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return permissions;
                } else {
                    return null;
                }
            }
        }

    }

    public String checkGroupPermissionStatus(String groupName, String permission) {
        Connection con = null;
        boolean recordFound = false;
        try {
            con = Connect();
            if (con == null) {
                return null;
            }
            String result = null;
            String query = "select (GROUPNAME) from PORTALPERMISSIONS where  LOWER(GROUPNAME) = LOWER(?) AND LOWER(OPERATIONSALLOWED) = LOWER(?)";
            PreparedStatement prest = con.prepareStatement(query);
            prest.setString(1, groupName);
            prest.setString(2, permission);
            ResultSet rs = prest.executeQuery();

            while (rs.next()) {
                result = rs.getString("GROUPNAME");
                System.out.println("Permission - " + result + " already exist..");
                recordFound = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to check portal group permissioning status.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (recordFound == true) {
                    return "found";
                } else {
                    return "not found";
                }
            }
        }
    }

    public String deleteGroupPermissions(String groupName, String operation) {
        int deletedRows;
        boolean result = false;
        Connection con = null;
        try {
            con = Connect();
            if (con == null) {
                return null;
            }
            String queryString = "DELETE FROM PORTALPERMISSIONS WHERE LOWER(GROUPNAME) = LOWER(?) AND LOWER(OPERATIONSALLOWED) = LOWER(?)";
            PreparedStatement pstatement = null;
            pstatement = con.prepareStatement(queryString);
            pstatement.setString(1, groupName);
            pstatement.setString(2, operation);

            deletedRows = pstatement.executeUpdate();
            if (deletedRows != 0) {
                System.out.println(deletedRows + " records are deleted");
                result = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to delete permission for group " + groupName + " .");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return "deleted";
                } else {
                    return "failed";
                }
            }
        }
    }

    public String deletePortalUser(String userName) {
        int deletedRows;
        boolean result = false;
        Connection con = null;
        try {
            con = Connect();
            if (con == null) {
                return null;
            }
            String queryString = "DELETE FROM PORTALUSERS WHERE LOWER(USERNAME) LIKE LOWER(?)";
            PreparedStatement pstatement = null;
            pstatement = con.prepareStatement(queryString);
            pstatement.setString(1, "%" + userName + "%");

            deletedRows = pstatement.executeUpdate();
            if (deletedRows != 0) {
                System.out.println(deletedRows + " records are deleted");
                result = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to delete portal user.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return "deleted";
                } else {
                    return "failed";
                }
            }
        }
    }

    public String updatePortalUser(String Username, String Group) {
        int updateRows;
        boolean result = false;
        Connection con = null;
        try {
            con = Connect();
            if (con == null) {
                return null;
            }

            String queryString = "UPDATE PORTALUSERS SET GROUPNAME=? where LOWER(USERNAME)=LOWER(?)";
            PreparedStatement pstatement = null;
            pstatement = con.prepareStatement(queryString);
            pstatement.setString(1, Group);
            pstatement.setString(2, Username);

            updateRows = pstatement.executeUpdate();
            if (updateRows != 0) {
                System.out.println(updateRows + " records are updated");
                result = true;
            }

        } catch (SQLException ex) {
            System.out.println("Exception in executing query to update record.");
            System.out.println(ex.toString());
        } finally {
            try {
                disConnect(con);
            } catch (Exception ex) {
                System.out.println("Exception in closing connection.");
                System.out.println(ex.toString());

            } finally {
                if (result == true) {
                    return "changed";
                } else {
                    return "failed";
                }
            }
        }
    }
}
