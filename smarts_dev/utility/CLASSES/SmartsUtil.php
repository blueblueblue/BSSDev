<? 
/*************************************************
* @author Saad Bashir Dar 
* imsaady@gmail.com
* sales rep class, authentication based on
**************************************************/


class SmartsUtil
{

	private $db;
	private $conf;
	public $error;
        private $debug;

	public function __construct()
	{ 
		$tns_name = "(DESCRIPTION =
                        (ADDRESS_LIST =
                            (ADDRESS = (PROTOCOL = TCP)(HOST = 10.1.67.201)(PORT = 1522))
                        )
                        (CONNECT_DATA =
                           (SERVICE_NAME = pindb)
                        )
                      )";
                $this->db = &ADONewConnection("oci8");
		$this->db->Connect($tns_name , 'smarts2' , 'smarts321');
	}
	
	public function __destruct()
	{
		$this->db->Disconnect();
	}
	
	public function searchAccount($acct_info)
	{
		
		$search_type = $acct_info['search_type'];
		$search_term = $acct_info['search_term'];
		switch($search_type)
		{
			case "name":
				 $condition = "first_name LIKE '%$search_term%' or last_name LIKE '%$search_term%' order by first_name, last_name ";
				 break;
			case "phone_number":
				 $condition = "telephone_number like '$search_term' or mobile_number like '$search_term'";
				 break;
			case "mac_address":
				 $condition = "cpe_mac_address like '$search_term'";
				 break;
			case "customer_id":
				 $condition = "customer_id =$search_term";
				 break;
			case "sales_rep_id":
				$condition = " to_char( date_created, 'YYYYMM')= 201010 and sales_rep_id = $search_term";
				break;
		}
		
		$query = "SELECT * FROM brm_activations WHERE $condition";
		$acct_record_set= $this->db->Execute($query);
		$count=0;
		while ( $acct = $acct_record_set->FetchRow())
		{
			$accts[$count]=$acct;
			$count++;
	
		}
                
		return $accts;
	}
	

	public function getAccountDetails($acctInfo)
	{
		$customer_id = $acctInfo['customer_id'];	
		$condition = "customer_id = $customer_id";
		$query = "SELECT * FROM brm_activations WHERE $condition";
	//	print $query;
		$acct_record_set= $this->db->Execute($query);
		$details = $acct_record_set->FetchRow();
		return $details;
		
	}
	
	////////////////////////////////////////////////////////////// BELOW APIS ARE GIVING REAL TIME DATA. ////////////////////////////////////////////
	
	public function getBRMCurrentMonthSales($sale_rep_id, $from_date,$to_date)
	{
		$query = "	Select * from VU_ACT_REGION  
					inner join vu_cust on vu_cust.customer_id = VU_ACT_REGION.customer_id 
					where TO_DATE(TO_CHAR(DATE_CREATED,'MM/DD/YYYY'),'MM/DD/YYYY') >= TO_DATE('$from_date','MM/DD/YYYY')
                                        and TO_DATE(TO_CHAR(DATE_CREATED,'MM/DD/YYYY'),'MM/DD/YYYY') <= TO_DATE('$to_date','MM/DD/YYYY')
					and SALES_REP_ID = '$sale_rep_id' order by DATE_CREATED desc" ;
                
		$acct_record_set= $this->db->Execute($query);
		$count=0;
		while ( $acct = $acct_record_set->FetchRow())
		{
			$accts[$count]=$acct;
			$count++;
		}
		return $accts;
	}
	
	public function getBRMAccountDetails($acct_id)
	{
		$query = "Select * from vu_cust where customer_id=$acct_id";
		$acct_record_set= $this->db->Execute($query);
		$count=0;
		while ( $acct = $acct_record_set->FetchRow())
		{
			$accts[$count]=$acct;
			$count++;
	
		}					
		
		return $accts;
	}

	public function getBRMPaymentDetails($acct_id)
	{
		$query = "	select * from receipt_info_t where account_obj_id0 ='$acct_id'";
		$acct_record_set= $this->db->Execute($query);
		$count=0;
		while ( $acct = $acct_record_set->FetchRow())
		{
			$accts[$count]=$acct;
			$count++;
	
		}					
		
		return $accts;
	}

        public function getSalesBySalesRepID($salesrep_id)
	{
		$condition = "SALES_REP_ID = '$salesrep_id'";
		$billing_cycle = date('Ym');

		$query = "select decode(calls.times_called,null,0,calls.times_called)times_called,
                        decode(calls.last_called_on,null,'-',calls.last_called_on) last_called_on,
                        decode(paid,1,'Paid','Unpaid') Payment_status,
                        TO_CHAR(ADD_MONTHS(SYSDATE, -2), 'MON-YYYY') as start_month,
                        TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'MON-YYYY') as end_month,
                        TO_CHAR(date_created, 'MON-YYYY') as current_month,
                        customer_payables.*
                from customer_payables
		left outer join
		(select rec_id, count(*) times_called, max(datetime) last_called_on  from customer_payables_calls group by rec_id) calls
		 on calls.rec_id = customer_payables.rec_id

		 where $condition and TOTAL_DUE >200 --and paid!=1
                 and TO_CHAR(date_created, 'YYYYMM') >= TO_CHAR(ADD_MONTHS(SYSDATE, -2), 'YYYYMM')
                 and TO_CHAR(date_created, 'YYYYMM') <= TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM')
		 
		 order by payment_status desc,date_created asc";
		
	/*	$query =	"SELECT * ".
					" FROM ".CUSTOMER_PAYABLES_CURRENT.
					" WHERE $condition".
					" ORDER BY total_due desc";*/
                $sales_rec= $this->db->Execute($query);

		//print_r($_sales_rec);
		$shop_sales =null;
		$sale_count=0;
		while ( $sale = $sales_rec->FetchRow())
		{

			$shop_sales[$sale_count]=$sale;
			$sale_count++;

		}
		return $shop_sales;
	}

        public function getAccount($account)
	{
		$condition = "rec_id=".$account['rec_id'];
		$query =	"SELECT * ".
					" FROM CUSTOMER_PAYABLES WHERE $condition";
		$user_set= $this->db->Execute($query);
		$user = $user_set->FetchRow();
		return $user;
	}

        public function getCalls($call)
	{
		$condition = "rec_id = ".$call['rec_id'];

		$query =	"SELECT * FROM CUSTOMER_PAYABLES_CALLS WHERE $condition";

		$calls_set= $this->db->Execute($query);
		$calls=null;
		$call_count =0;
		while ( $call = $calls_set->FetchRow())
		{

			$calls[$call_count]=$call;
			$call_count++;

		}
		return $calls;
	}
}
?>