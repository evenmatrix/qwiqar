module TopUpgGenie
  API_KEY=""
  SECRET=""
  TOKEN=""

  def top_up(top_up)
     var url="https://topupgenie.com/beta/vas/merchants/topup.json"
     phone_number=get_number_for_tup_up(top_up);
     params={:key=>API_KEY,:secret=>SECRET,:amount=>top_up.item.amount,:network=>phone_number.carrier.name.downcase,:number=>phone_number.number}
     response=RestClient.get url,:params => params
     case response.code
       when 200
         result=Yajl::Parser.parse(response)
         status=result["status"]
         data=result["data"]
         if status = "01"
           top_up.save_top_genie_order(data["order"])
           query_top_up_status(top_up)
         end
       else
         response.return!(request,result,&block)
     end
  end

  def query_top_up_status(top_up)
    var url="https://topupgenie.com/beta/vas/merchants/querytopupstatus.json"
    params={:key=>API_KEY,:secret=>SECRET,:order_id=>top_up.top_genie_order_id}
    response=RestClient.get url,:params => params
    case response.code
      when 200
         result=Yajl::Parser.parse(response)
         status=result["status"]
         data=result["data"]
         if status = "01"
           top_up_genie_order=data["order"]
           case top_up_genie_order["orderstatus"]
             when "1"
               top_up.delivered(top_up_genie_order)
           end
         end
      else
        response.return!(request,result,&block)
    end
  end

  def get_number_for_tup_up(top_up)
       phone_number=case top_up.type
         when "PhoneNumberTopUp"
              top_up.phone_number
         when "ContactTopUp"
             top_up.contact.phone_number
      end
  end

end
