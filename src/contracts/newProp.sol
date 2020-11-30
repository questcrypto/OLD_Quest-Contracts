// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

contract newProp{
    using SafeMath for uint256;
    uint id =0;
    string[] public items;
    struct coinIssue{
        uint256 coin_issue;
        uint256 org_val;
        uint256 equity_at_issuance;
        uint256 curr_val;
        uint256 tot_curr_val;
        uint256 increase;
    
    }
    
    struct Prop_Value_Details{
        uint256 Orig_Value;
        uint256 Curr_Value;
        uint256 Orig_Issue_Rate;
        string next_reevaluation_date;
        coinIssue[] coins_issue;
        coinIssue total_coins_issue;
        string[] Property_images;
        string[] Property_location;
        uint256 taxes;
        uint256 insurance;
        uint256 maintainence;
        uint256 total;
        uint256 monthly_hoa_payment;
        string property_features;
        }
        
       struct myDetail{
           string name;
           uint age;
       }
        
       
        
        mapping(uint256 => Prop_Value_Details) public prop;
        mapping(uint256 => myDetail) public mydet;

        function setdetail() public returns(myDetail memory){
              mydet[0].name="abc";
              mydet[0].age=21;
              return mydet[0];
        }
        
        function getdetail() public view returns(myDetail memory){
             return mydet[0];
        }
        
        
        function getArray(uint256 property_id,uint256 index) public view returns(coinIssue memory){
            return prop[property_id].coins_issue[index];
        }

        function getMetaData(uint propertyid) public view returns(Prop_Value_Details memory){
            return prop[propertyid];
        }
        
        function setMetaData_of_Property(uint256 origVal,
                                         uint256 currVal,
                                         uint256 orig_rate,
                                         string memory date,
                                         uint256 coins,
                                         string[] memory pro_add_details,
                                         uint prop_tax,
                                         uint prop_insurance,
                                         uint prop_maintainence,
                                         string memory features_prop) public {
                                 

         coinIssue memory coinsdetails;
        
        
         prop[id].Orig_Value = origVal;
         prop[id].Curr_Value = currVal;
         prop[id].Orig_Issue_Rate = orig_rate;
         prop[id].next_reevaluation_date = date;
    
         coinsdetails.coin_issue = coins;
         coinsdetails.org_val = 100;
         coinsdetails.equity_at_issuance =  (coins.mul(100)).div(origVal);
         
         uint temp = (currVal.sub(origVal));
         uint temp1=  (temp.mul(100)).div(origVal);
         
         coinsdetails.curr_val = temp1.add(100);
         coinsdetails.tot_curr_val = ((coinsdetails.curr_val).mul(coins)).div(100);
        
         uint curr = coinsdetails.tot_curr_val;
         uint orig=  ((coinsdetails.org_val).mul(coins)).div(100);
         coinsdetails.increase = ((curr.sub(orig)).mul(10000)).div(orig);
        
         prop[id].coins_issue.push(coinsdetails);
         prop[id].total_coins_issue = coinsdetails;
         
         for(uint i=0;i<pro_add_details.length;i++){
         items.push(pro_add_details[i]);
         }
         prop[id].Property_location = items;
         delete items;
         
         prop[id].taxes = prop_tax;
         prop[id].insurance = prop_insurance;
         prop[id].maintainence = prop_maintainence;
         
         prop[id].total = (prop_tax.add(prop_insurance)).add(prop_maintainence);
         prop[id].monthly_hoa_payment = (prop[id].total).div(12);
         prop[id].property_features = features_prop;
        //  return prop[id++];
                                 
        }
    
        
         function issue_coins_for_Property(uint256 property_id,uint256 coins) public {
                                 
         if(prop[property_id].coins_issue.length >= 1)
        {
         coinIssue memory coinsdetails;
        
         Prop_Value_Details memory property_details;
         
         property_details = prop[property_id];
    
         coinsdetails.coin_issue = coins;
         
         uint len = property_details.coins_issue.length;
         
         coinsdetails.org_val = property_details.coins_issue[len-1].curr_val;
         coinsdetails.equity_at_issuance =  (coins.mul(100)).div(property_details.Orig_Value);
         
         uint temp = (property_details.Curr_Value).sub((property_details.Orig_Value));
         uint temp1=  (temp.mul(100)).div(property_details.Orig_Value);
         
         coinsdetails.curr_val = temp1.add(100);
         coinsdetails.tot_curr_val = ((coinsdetails.curr_val).mul(coins)).div(100);
        
         uint curr = coinsdetails.tot_curr_val;
         uint orig=  ((coinsdetails.org_val).mul(coins)).div(100);
         coinsdetails.increase = ((curr.sub(orig)).mul(10000)).div(orig);
        
         prop[property_id].coins_issue.push(coinsdetails);
         
         
         coinIssue memory c;
         
         c=prop[property_id].total_coins_issue;
         
         c.coin_issue=(c.coin_issue).add(coinsdetails.coin_issue);
         c.org_val = coinsdetails.org_val;
         c.equity_at_issuance=(c.equity_at_issuance).add(coinsdetails.equity_at_issuance);
         c.curr_val =coinsdetails.curr_val;
         c.tot_curr_val = (c.tot_curr_val).add(coinsdetails.tot_curr_val);
         
         prop[property_id].total_coins_issue = c;
         
        //  return prop[property_id];
        }                         
    }
}